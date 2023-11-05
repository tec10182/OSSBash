#! /bin/bash
echo "User Nane: Kang Min Su"
echo "Student Number: 12191545"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from '$1'"
echo "2. Get the data of action genre movies from '$1’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from '$2'"
echo "4. Delete the ‘IMDb URL’ from ‘$1'"
echo "5. Get the data about users from '$3’"
echo "6. Modify the format of 'release date' in '$1’"
echo "7. Get the data of movies rated by a specific 'user id' from '$2'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo ""

total_data=$(cat $1 | awk -F \| '{print $1}' | sort -n |tail -n 1) 
total_user=$(cat $3 | awk -F \| '{print $1}' | sort -n |tail -n 1) 



while : 
do
read -p "Enter your choice [ 1 - 9 ] " choice

case $choice in
1)
read -p "Please enter 'movie id'(1~$total_data):" id
cat $1 | awk -F\| -v id=$id '$1 ==id{print}' 
;;

2)
read -p "Do you want to get the data of 'action' genre movies from '$1'?(y/n):" next

if [ $next == 'n' ]
then
continue
elif [ $next != 'y' ]  
then
echo "wrong character"
continue
fi

for var in $(seq 1 10)
do
    id=$(cat $1 | awk -F\| '$7==1{print $1}' | sort -n | sed -n "${var}p")
    cat $1 | awk -F\| -v id=$id '$1==id{print $1,$2}'
done
;;

3)
read -p "Please enter the 'movie id' (1~$total_data):" id
cat $2 | awk -v id=$id '$2==id{sum+=$3; n+=1} END {if(n>0){printf "average rating of %d: %.5f\n",id,sum/n}else if(n==0){printf "no rating exists\n"}}' 
;;

4)
read -p "Do you want to delete 'IMDb URL' from '$1'?(y/n) " choice
if [ $choice == 'n' ]
then
continue
elif [ $choice != 'y' ]  
then
echo "wrong character"
continue
fi

cat $1 | sed -E 's/http:\/\/[a-zA-Z0-9!@#$%^&*()_+\./:?,='"'"'-]+//g' | head -n 10
;;

5)
read -p "Do you want to get the data about users from  '$3'?(y/n) " choice
if [ $choice == 'n' ]
then
continue
elif [ $choice != 'y' ]  
then
echo "wrong character"
continue
fi

cat $3 | sed -E 's/^/user /' | sed -E 's/\|/ is /;  s/\|M\|/ years old male /; s/\|F\|/ years old female /; s/\|.*/ /'  | head -n 10
;;

6)
read -p "Do you want to Modify the format of 'release data' in '$3'?(y/n) " choice
if [ $choice == 'n' ]
then
continue
elif [ $choice != 'y' ]  
then
echo "wrong character"
continue
fi
cat $1 | tail -n 10 | sed -E  's/(^[^|]*\|[^|]*\|)([0-9]{2})-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Nov|Oct|Dec)-([0-9]{4})(.*)/\1\4!@\3\2\5/; s/!@Jan/01/; s/!@Feb/02/; s/!@Mar/03/; s/!@Apr/04/; s/!@May/05/; s/!@Jun/06/; s/!@Jul/07/; s/!@Aug/08/; s/!@Sep/09/; s/!@Oct/10/; s/!@Nov/11/; s/!@Dec/12/;'


;;

7)
read -p "Please enter the 'user id'(1~$total_user): " id
cat $2 | awk -v id=$id '$1==id{print $2}' | sort -n | sed  ':a;N;$!ba;s/\n/\|/g'
echo ""

for var in $(seq 1 10)
do
    mid=$(cat $2 | awk -v id=$id '$1==id{print $2}' | sort -n | sed -n "${var}p")
    cat $1 | awk -F\|  -v mid=$mid '$1==mid{print $1, "|" , $2}' 
done
;;

8)
read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " choice
if [ $choice == 'n' ]
then
continue
elif [ $choice != 'y' ]  
then
echo "wrong character"
continue
fi

uid=$(cat $3| awk -F\| '$2>=20&&$2<=29&&$4=="programmer"{print $1}')


cat $2 | awk -v uid="$uid" -v total=$total_data '{split(uid,a,"\n");
        check=0;
        for(v in a) 
        {
            if($1 == a[v]) {check=1;}
        }
        if(check==1){rate[$2]+=$3; sum[$2]+=1;}
    } END {

        for(i=1; i<=total; i++){
                if(sum[i]!=0)
                    printf "%d %.5f\n",i,rate[i]/sum[i]
            } 
        }'| sed -E 's/([0-9]+\.0*[1-9]+)0*$/\1/' | sed -E 's/\.00000//'
;;

9)
echo "Bye!"
exit
;;
esac
done