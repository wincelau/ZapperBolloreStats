echo -n > README.md

echo "# Statistiques Zapper Bolloré" >> README.md
echo >> README.md

rm /tmp/zapperbollore_*
curl https://docs.google.com/document/d/1sh-xkEMkNLGw7U8GacAPe4p6828jnDVApuIVeYb8VnI/mobilebasic | tr -d "\n" | sed 's|</p>|#|g' | sed -r 's|</?[a-z]+[^<>]*>||g' | sed -r 's/^.*zapperbollore@proton\.me//' | tr '#' "\n" | grep "," | sed 's/^39;//' | grep -v window.set | sort > /tmp/zapperbollore


cat bin/filtres | while read ligne; do
  TITRE=$(echo -n $ligne | cut -d ";" -f 1);
  REGEXP=$(echo -n $ligne | cut -d ";" -f 2);
  cat /tmp/zapperbollore | grep -Ei "$REGEXP" | grep -v "coach" > "/tmp/zapperbollore_$TITRE"
done
cat /tmp/zapperbollore_* | sort > /tmp/zapperbollore_tous
join -t ";" -v 1 /tmp/zapperbollore /tmp/zapperbollore_tous > /tmp/zapperbollore_ZZZZAutres

echo "|**Total**|**$(cat /tmp/zapperbollore | sort | uniq | wc -l)**|" >> README.md
echo "|:-|-:|" >> README.md
ls /tmp/zapperbollore_* | grep -v _tous | while read file; do
  echo "|$(echo -n $file | sed 's|/tmp/zapperbollore_||' | sed 's|ZZZZ||' )|[$(cat "$file" | sort | uniq | wc -l)](#$(echo -n $file | sed 's|/tmp/zapperbollore_||' | sed 's|ZZZZ||' | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[\.,]//g' ))|" >> README.md
done

ls /tmp/zapperbollore_* | grep -v _tous | while read file; do
  echo >> README.md
  echo "## $file" | sed 's|/tmp/zapperbollore_||' | sed 's|ZZZZ||' >> README.md
  echo >> README.md
  echo "[Retourner au début de la page](#statstiques-zapper-bolloré)" >> README.md
  echo >> README.md
  cat "$file" | sed 's/^/- /' >> README.md
  echo >> README.md
  echo "[Retourner au début de la page](#statstiques-zapper-bolloré)" >> README.md
done
