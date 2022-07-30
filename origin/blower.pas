{***************************************************************************}
{BLOWER 1.0a(Jean Moulin Version) Youen Ch‚n‚ ¸1997}
{***************************************************************************}

program Blower;


uses dos,crt;
{$i clavier.pas}
{$i vga.pas}


LABEL 1,2,3;
type TMap=array[1..7,0..219] of byte;
     TPre=array[0..259] of byte;
     flamme=array[1..4,1..3,0..15,0..15] of byte;
     eclat=array[1..4,0..7,0..7] of byte;
     Icone=array[0..58,0..15,0..15] of byte;
     Bobs=array[0..3,0..14] of integer;
          {Caract‚ristique}
     {0..3 > nø perso}
     {0..12 > 0 > X
              1 > Y
              2 > Direction
              3 > Etape animation
              4 > si Tir
              5 > X tir
              6 > Y tir
              7 > Direction Tir
              8 > Buffer
              9 > Tempo Animation
             10 > Energie
             11 > Type arme
             12 > Tempo Bonus
             13 > Maladie
             14 > Vitesse D‚placement
             }

const
 VIt=40;
 MaxEnergie=15;
 LM=19;
 HM=11;
 NbCarte=8;
 tableau: TMap=(
                {***********----Tableau1----***********}
                (2,2,2,2,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,
                2,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,2,
                2,0,2,0,2,0,2,0,2,0,0,2,0,2,0,2,0,2,0,2,
                2,0,1,0,0,0,0,0,2,0,0,3,0,0,0,0,0,0,0,3,
                2,0,2,0,3,0,2,0,3,1,0,2,0,2,0,2,0,2,0,2,
                2,0,0,0,1,0,0,0,2,0,0,2,0,1,0,0,0,1,0,2,
                3,0,2,0,2,0,2,0,2,0,1,2,0,3,0,2,0,2,0,3,
                2,0,0,0,0,0,0,0,3,0,0,2,0,0,0,0,0,0,1,2,
                2,0,2,0,3,0,2,1,2,0,0,2,0,2,0,2,0,2,0,2,
                2,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,2,
                2,2,2,2,3,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2),
                {***********----Tableau2----***********}
                (2,2,2,2,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,
                 2,0,0,1,0,0,0,0,0,3,2,0,0,1,0,0,0,0,0,2,
                 2,0,2,3,2,2,2,0,0,2,2,0,0,2,2,2,2,3,0,2,
                 2,0,2,0,0,0,0,0,1,2,2,0,0,0,0,0,0,2,0,3,
                 2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,2,
                 2,2,2,2,2,2,2,2,0,0,0,0,2,2,2,2,3,2,2,2,
                 3,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,3,
                 2,0,2,1,0,0,0,0,0,2,2,0,0,0,0,0,0,2,1,2,
                 2,0,2,2,2,2,2,1,0,2,3,0,0,3,2,2,2,2,0,2,
                 2,0,1,0,0,0,0,0,0,2,2,0,0,0,1,0,0,0,0,2,
                 2,2,2,2,3,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2),
                 {***********----Tableau3----***********}
                 (2,2,2,2,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,
                  2,0,0,1,0,0,0,1,2,0,0,3,0,0,0,0,0,0,0,2,
                  2,0,2,0,2,0,2,0,2,0,0,3,0,2,0,2,0,3,0,2,
                  2,0,2,0,2,0,3,0,0,0,0,0,0,2,0,2,0,2,0,3,
                  2,0,2,0,3,0,2,0,2,0,0,2,0,2,0,2,0,2,1,2,
                  2,0,3,1,2,0,2,0,3,0,0,2,0,3,0,2,0,2,0,2,
                  3,0,2,0,2,0,3,0,2,0,0,2,0,2,0,2,0,2,0,2,
                  2,0,2,0,2,0,2,0,0,0,0,0,0,2,1,2,0,2,0,2,
                  2,0,2,0,2,1,2,0,2,0,0,2,0,3,0,2,0,2,0,2,
                  2,0,0,0,0,0,0,0,2,0,1,2,0,0,1,0,0,0,0,2,
                  2,2,2,2,3,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2),
                 {***********----Tableau4----***********}
                 (2,2,2,2,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,
                  2,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,2,
                  2,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,2,
                  2,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,2,
                  2,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,2,
                  2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,
                  2,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,2,
                  2,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
                  2,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
                  2,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,2,
                  2,2,2,2,3,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2),
                 {***********----Tableau5----***********}
                 (2,2,2,2,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,
                  2,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,2,
                  2,0,2,0,0,0,0,0,0,3,3,0,0,0,0,0,1,2,0,2,
                  2,0,0,2,0,0,0,0,0,0,0,0,0,1,0,0,2,0,0,2,
                  2,0,0,0,2,3,2,2,0,0,0,1,2,2,3,2,0,0,0,2,
                  2,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,2,
                  2,0,0,0,2,3,2,2,1,0,0,0,2,2,3,2,0,0,0,2,
                  2,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,
                  2,0,2,0,0,1,0,0,0,3,3,0,0,0,0,0,0,2,0,2,
                  2,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,2,
                  2,2,2,2,3,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2),
                 {***********----Tableau6----***********}
                 (2,2,2,2,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,
                  2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,
                  2,0,2,0,1,0,2,0,0,0,3,0,0,2,0,0,1,2,0,2,
                  2,0,0,2,0,2,0,0,2,0,0,2,0,1,2,0,2,0,0,2,
                  2,0,0,0,2,0,0,2,0,0,0,0,2,0,0,2,0,0,0,2,
                  2,0,1,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,2,
                  2,0,0,0,2,0,0,2,0,0,0,0,2,0,0,2,0,0,0,2,
                  2,0,0,2,0,2,0,0,2,0,0,2,0,0,2,0,2,0,0,2,
                  2,0,2,0,0,1,2,0,0,3,0,0,0,2,0,0,0,2,0,2,
                  2,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,2,
                  2,2,2,2,3,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2),
                 {***********----Tableau7----***********}
                 (2,2,2,2,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,
                  2,0,0,3,0,0,2,0,0,0,0,0,0,2,0,0,2,0,0,2,
                  2,0,0,2,0,0,2,0,0,0,0,0,0,2,0,0,1,0,0,2,
                  2,3,0,2,0,0,2,0,0,0,0,0,0,1,0,0,0,0,2,2,
                  2,0,0,0,0,0,2,0,3,2,2,2,2,2,0,0,2,3,2,2,
                  2,0,1,2,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,2,
                  2,0,0,2,0,0,2,0,0,0,0,3,0,0,0,0,2,0,0,2,
                  2,2,0,2,2,2,3,0,0,2,0,2,0,0,0,0,2,0,3,2,
                  2,0,0,0,0,1,0,0,0,3,0,2,0,0,0,0,0,0,0,2,
                  2,0,0,2,0,0,0,0,0,2,0,0,0,0,0,0,3,0,0,2,
                  2,2,2,2,3,2,2,3,2,2,2,2,2,2,2,2,2,2,2,2)
                );
TablPres: TPre=(
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
2,2,0,3,0,0,2,2,2,3,0,0,0,3,2,2,0,3,3,0,
2,0,2,3,0,0,2,0,2,3,0,0,0,3,2,0,0,3,0,3,
2,2,2,3,0,0,2,0,2,3,0,3,0,3,2,2,0,3,3,0,
2,0,2,3,0,0,2,0,2,3,0,3,0,3,2,0,0,3,0,3,
2,2,0,3,3,0,2,2,2,0,3,0,3,0,2,2,0,3,0,3,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
var
{Page Graphique}
E1:^screen;
e2:^screen;
{Dessins}
pal1:^palet;
Cases:array [0..15,0..15,0..15] of byte;
BOB:array [0..87,0..15,0..15] of byte;
Flam:Flamme;
eclats:eclat;
Icones:icone;
Bonus:array[0..3] of byte;
{Donn‚es Joueur}
joueur:integer;
carte:byte;
Terrain:byte;
map:array [0..LM,1..HM] of byte;
Clav:byte; {Variables clavier}
t,r,s:word;
pers:bobs;
key:char;
esc:boolean;
i,j:integer;
go,go1:byte;
Shell: STRING[128];
function Puis(n,e:integer):integer;
var
n2:integer;
s,b:byte;
begin
n2:=n;
for s:=2 to e do
n:=n*n2;
puis:=n;
end;

function Shift(o,q:integer):integer;
var
j:byte;
begin
for j:=7 downto q  do
begin
o:=o-puis(2,j) ;
if o<0 then o:=o+puis(2,j)
end;
shift:=o;
end;

procedure initMap;
var
i,j:word;
begin
Bmp('Mapping.bmp',pal1^);
{Frankenstein}
for i:=0 to 15 do for j:=0 to 15 do
cases[4,j,i]:=mem[$a000:i+1+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[6,j,i]:=mem[$a000:i+18+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[5,j,i]:=mem[$a000:i+1+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[7,j,i]:=mem[$a000:i+18+(j+18)*320];
{Western}
for i:=0 to 15 do for j:=0 to 15 do
cases[0,j,i]:=mem[$a000:i+171+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[2,j,i]:=mem[$a000:i+188+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[1,j,i]:=mem[$a000:i+171+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[3,j,i]:=mem[$a000:i+188+(j+35)*320];
{Militaire}
for i:=0 to 15 do for j:=0 to 15 do
cases[8,j,i]:=mem[$a000:i+205+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[10,j,i]:=mem[$a000:i+222+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[9,j,i]:=mem[$a000:i+205+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[11,j,i]:=mem[$a000:i+222+(j+35)*320];
{Ville}
for i:=0 to 15 do for j:=0 to 15 do
cases[12,j,i]:=mem[$a000:i+256+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[14,j,i]:=mem[$a000:i+273+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[13,j,i]:=mem[$a000:i+256+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
cases[15,j,i]:=mem[$a000:i+273+(j+35)*320];
{icones}
for i:=0 to 15 do for j:=0 to 15 do
icones[0,j,i]:=mem[$a000:i+154+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[1,j,i]:=mem[$a000:i+154+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[2,j,i]:=mem[$a000:i+137+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[3,j,i]:=mem[$a000:i+120+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[4,j,i]:=mem[$a000:i+103+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[5,j,i]:=mem[$a000:i+154+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[6,j,i]:=mem[$a000:i+137+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[7,j,i]:=mem[$a000:i+120+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[8,j,i]:=mem[$a000:i+171+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[9,j,i]:=mem[$a000:i+222+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[10,j,i]:=mem[$a000:i+205+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[11,j,i]:=mem[$a000:i+188+(j+103)*320];
{Bonus}
for i:=0 to 15 do for j:=0 to 15 do
icones[12,j,i]:=mem[$a000:i+239+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[13,j,i]:=mem[$a000:i+239+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[14,j,i]:=mem[$a000:i+256+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[15,j,i]:=mem[$a000:i+239+(j+103)*320];
{Ecriture}
{commencer}
for i:=0 to 15 do for j:=0 to 15 do
icones[16,j,i]:=mem[$a000:i+35+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[17,j,i]:=mem[$a000:i+52+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[18,j,i]:=mem[$a000:i+69+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[19,j,i]:=mem[$a000:i+86+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[20,j,i]:=mem[$a000:i+103+(j+52)*320];
{Joueur}
for i:=0 to 15 do for j:=0 to 15 do
icones[21,j,i]:=mem[$a000:i+35+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[22,j,i]:=mem[$a000:i+52+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[23,j,i]:=mem[$a000:i+69+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[24,j,i]:=mem[$a000:i+86+(j+69)*320];
{Touches}
for i:=0 to 15 do for j:=0 to 15 do
icones[25,j,i]:=mem[$a000:i+35+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[26,j,i]:=mem[$a000:i+52+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[27,j,i]:=mem[$a000:i+69+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[28,j,i]:=mem[$a000:i+86+(j+86)*320];
{Quitter}
for i:=0 to 15 do for j:=0 to 15 do
icones[29,j,i]:=mem[$a000:i+120+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[30,j,i]:=mem[$a000:i+137+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[31,j,i]:=mem[$a000:i+154+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[32,j,i]:=mem[$a000:i+171+(j+52)*320];
{2 3 4}
for i:=0 to 15 do for j:=0 to 15 do
icones[33,j,i]:=mem[$a000:i+103+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[34,j,i]:=mem[$a000:i+103+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[35,j,i]:=mem[$a000:i+239+(j+69)*320];
{Manoir}
for i:=0 to 15 do for j:=0 to 15 do
icones[36,j,i]:=mem[$a000:i+120+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[37,j,i]:=mem[$a000:i+137+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[38,j,i]:=mem[$a000:i+154+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[39,j,i]:=mem[$a000:i+171+(j+69)*320];
{Western}
for i:=0 to 15 do for j:=0 to 15 do
icones[40,j,i]:=mem[$a000:i+120+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[41,j,i]:=mem[$a000:i+137+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[42,j,i]:=mem[$a000:i+154+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[43,j,i]:=mem[$a000:i+171+(j+86)*320];
{Forˆts}
for i:=0 to 15 do for j:=0 to 15 do
icones[44,j,i]:=mem[$a000:i+188+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[45,j,i]:=mem[$a000:i+205+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[46,j,i]:=mem[$a000:i+222+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[47,j,i]:=mem[$a000:i+239+(j+52)*320];
{Ville}
for i:=0 to 15 do for j:=0 to 15 do
icones[48,j,i]:=mem[$a000:i+188+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[49,j,i]:=mem[$a000:i+205+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[50,j,i]:=mem[$a000:i+222+(j+69)*320];
{Copyright}
for i:=0 to 15 do for j:=0 to 15 do
icones[51,j,i]:=mem[$a000:i+188+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[52,j,i]:=mem[$a000:i+205+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[53,j,i]:=mem[$a000:i+222+(j+86)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[54,j,i]:=mem[$a000:i+239+(j+86)*320];
{gagn‚e}
for i:=0 to 15 do for j:=0 to 15 do
icones[55,j,i]:=mem[$a000:i+35+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[56,j,i]:=mem[$a000:i+52+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[57,j,i]:=mem[$a000:i+69+(j+103)*320];
for i:=0 to 15 do for j:=0 to 15 do
icones[58,j,i]:=mem[$a000:i+86+(j+103)*320];
{Cow-boy}
{Position Droite}
for i:=0 to 15 do for j:=0 to 15 do
BOB[5,j,i]:=mem[$a000:i+35+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[6,j,i]:=mem[$a000:i+52+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[7,j,i]:=mem[$a000:i+69+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[8,j,i]:=mem[$a000:i+86+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[9,j,i]:=mem[$a000:i+103+(j+1)*320];
{Position gauche}
for i:=0 to 15 do for j:=0 to 15 do
BOB[15,j,i]:=mem[$a000:i+120+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[16,j,i]:=mem[$a000:i+137+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[17,j,i]:=mem[$a000:i+154+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[18,j,i]:=mem[$a000:i+171+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[19,j,i]:=mem[$a000:i+188+(j+1)*320];
{Position Haute}
for i:=0 to 15 do for j:=0 to 15 do
BOB[0,j,i]:=mem[$a000:i+205+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[1,j,i]:=mem[$a000:i+222+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[2,j,i]:=mem[$a000:i+239+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[3,j,i]:=mem[$a000:i+256+(j+1)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[4,j,i]:=mem[$a000:i+273+(j+1)*320];
{Position Basse}
for i:=0 to 15 do for j:=0 to 15 do
BOB[10,j,i]:=mem[$a000:i+35+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[11,j,i]:=mem[$a000:i+52+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[12,j,i]:=mem[$a000:i+69+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[13,j,i]:=mem[$a000:i+86+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[14,j,i]:=mem[$a000:i+103+(j+18)*320];
{Position Mort}
for i:=0 to 15 do for j:=0 to 15 do
BOB[20,j,i]:=mem[$a000:i+120+(j+18)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[21,j,i]:=mem[$a000:i+136+(j+18)*320];
{frankenstein}
{Position Droite}
for i:=0 to 15 do for j:=0 to 15 do
BOB[27,j,i]:=mem[$a000:i+86+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[28,j,i]:=mem[$a000:i+103+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[29,j,i]:=mem[$a000:i+120+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[30,j,i]:=mem[$a000:i+154+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[31,j,i]:=mem[$a000:i+137+(j+120)*320];
{Position gauche}
for i:=0 to 15 do for j:=0 to 15 do
BOB[37,j,i]:=mem[$a000:i+171+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[38,j,i]:=mem[$a000:i+188+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[39,j,i]:=mem[$a000:i+205+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[40,j,i]:=mem[$a000:i+239+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[41,j,i]:=mem[$a000:i+222+(j+120)*320];
{Position Haute}
for i:=0 to 15 do for j:=0 to 15 do
BOB[22,j,i]:=mem[$a000:i+1+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[23,j,i]:=mem[$a000:i+18+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[24,j,i]:=mem[$a000:i+35+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[25,j,i]:=mem[$a000:i+69+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[26,j,i]:=mem[$a000:i+52+(j+137)*320];
{Position Basse}
for i:=0 to 15 do for j:=0 to 15 do
BOB[32,j,i]:=mem[$a000:i+1+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[33,j,i]:=mem[$a000:i+18+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[34,j,i]:=mem[$a000:i+35+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[35,j,i]:=mem[$a000:i+69+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[36,j,i]:=mem[$a000:i+52+(j+120)*320];
{Position Mort}
for i:=0 to 15 do for j:=0 to 15 do
BOB[42,j,i]:=mem[$a000:i+86+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[43,j,i]:=mem[$a000:i+102+(j+137)*320];
{Soldats}
{Position Droite}
for i:=0 to 15 do for j:=0 to 15 do
BOB[49,j,i]:=mem[$a000:i+86+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[50,j,i]:=mem[$a000:i+103+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[51,j,i]:=mem[$a000:i+120+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[52,j,i]:=mem[$a000:i+154+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[53,j,i]:=mem[$a000:i+137+(j+154)*320];
{Position gauche}
for i:=0 to 15 do for j:=0 to 15 do
BOB[59,j,i]:=mem[$a000:i+171+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[60,j,i]:=mem[$a000:i+188+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[61,j,i]:=mem[$a000:i+205+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[62,j,i]:=mem[$a000:i+239+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[63,j,i]:=mem[$a000:i+222+(j+154)*320];
{Position Haute}
for i:=0 to 15 do for j:=0 to 15 do
BOB[44,j,i]:=mem[$a000:i+1+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[45,j,i]:=mem[$a000:i+18+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[46,j,i]:=mem[$a000:i+35+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[47,j,i]:=mem[$a000:i+69+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[48,j,i]:=mem[$a000:i+52+(j+171)*320];
{Position Basse}
for i:=0 to 15 do for j:=0 to 15 do
BOB[54,j,i]:=mem[$a000:i+1+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[55,j,i]:=mem[$a000:i+18+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[56,j,i]:=mem[$a000:i+35+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[57,j,i]:=mem[$a000:i+69+(j+154)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[58,j,i]:=mem[$a000:i+52+(j+154)*320];
{Position Mort}
for i:=0 to 15 do for j:=0 to 15 do
BOB[64,j,i]:=mem[$a000:i+86+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[65,j,i]:=mem[$a000:i+102+(j+171)*320];
{Rambo}
{Position Droite}
for i:=0 to 15 do for j:=0 to 15 do
BOB[71,j,i]:=mem[$a000:i+120+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[72,j,i]:=mem[$a000:i+137+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[73,j,i]:=mem[$a000:i+154+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[74,j,i]:=mem[$a000:i+188+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[75,j,i]:=mem[$a000:i+171+(j+171)*320];
{Position gauche}
for i:=0 to 15 do for j:=0 to 15 do
BOB[81,j,i]:=mem[$a000:i+205+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[82,j,i]:=mem[$a000:i+222+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[83,j,i]:=mem[$a000:i+239+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[84,j,i]:=mem[$a000:i+273+(j+171)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[85,j,i]:=mem[$a000:i+256+(j+171)*320];
{Position Haute}
for i:=0 to 15 do for j:=0 to 15 do
BOB[66,j,i]:=mem[$a000:i+205+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[67,j,i]:=mem[$a000:i+222+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[68,j,i]:=mem[$a000:i+239+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[69,j,i]:=mem[$a000:i+273+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[70,j,i]:=mem[$a000:i+256+(j+137)*320];
{Position Basse}
for i:=0 to 15 do for j:=0 to 15 do
BOB[76,j,i]:=mem[$a000:i+120+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[77,j,i]:=mem[$a000:i+137+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[78,j,i]:=mem[$a000:i+154+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[79,j,i]:=mem[$a000:i+188+(j+137)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[80,j,i]:=mem[$a000:i+171+(j+137)*320];
{Position Mort}
for i:=0 to 15 do for j:=0 to 15 do
BOB[86,j,i]:=mem[$a000:i+256+(j+120)*320];
for i:=0 to 15 do for j:=0 to 15 do
BOB[87,j,i]:=mem[$a000:i+272+(j+120)*320];
{flamme Gauche}
for i:=0 to 15 do for j:=0 to 15 do
flam[2,1,j,i]:=mem[$a000:i+1+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[2,2,j,i]:=mem[$a000:i+18+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[2,3,j,i]:=mem[$a000:i+35+(j+35)*320];
{flamme Droite}
for i:=0 to 15 do for j:=0 to 15 do
flam[4,3,j,i]:=mem[$a000:i+52+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[4,2,j,i]:=mem[$a000:i+69+(j+35)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[4,1,j,i]:=mem[$a000:i+86+(j+35)*320];
{flamme Bas}
for i:=0 to 15 do for j:=0 to 15 do
flam[3,1,j,i]:=mem[$a000:i+1+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[3,2,j,i]:=mem[$a000:i+1+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[3,3,j,i]:=mem[$a000:i+1+(j+86)*320];
{flamme haute}
for i:=0 to 15 do for j:=0 to 15 do
flam[1,3,j,i]:=mem[$a000:i+18+(j+52)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[1,2,j,i]:=mem[$a000:i+18+(j+69)*320];
for i:=0 to 15 do for j:=0 to 15 do
flam[1,1,j,i]:=mem[$a000:i+18+(j+86)*320];
{eclats}
{haut}
for i:=0 to 7 do for j:=0 to 7 do
eclats[1,j,i]:=mem[$a000:i+111+(j+43)*320];
{Droite}
for i:=0 to 7 do for j:=0 to 7 do
eclats[2,j,i]:=mem[$a000:i+111+(j+35)*320];
{Bas}
for i:=0 to 7 do for j:=0 to 7 do
eclats[3,j,i]:=mem[$a000:i+103+(j+43)*320];
{gauche}
for i:=0 to 7 do for j:=0 to 7 do
eclats[4,j,i]:=mem[$a000:i+103+(j+35)*320];
{carte de jeux}
carte:=1;
joueur:=3;
cls(0);
couleurs(pal1^);
end;

procedure PutIco(x,y:word;n:byte;var scr:screen);
begin
putsprite(x,y,16,16,@icones[n,0,0],@scr);
end;

procedure AffMap(x1,y1,x2,y2:byte);
begin
for t:=x1 to x2 do
for r:=y1 to y2 do
if (t>=0) and (t<20) and (r>=1) and (r<12) then
putsprite(16*t,r*16+8,16,16,@cases[map[t,r]+terrain*4,0,0],e2);
end;

procedure  DBOB(x,y:word;n:byte;var scr:screen);
begin
 putsprite(x,y,16,16,@bob[n,0,0],@scr);
end;

procedure  DECLAT(x,y:word;n:byte;var scr:screen);
begin
 putsprite(x,y,8,8,@eclats[n,0,0],@scr);
end;

procedure Gauche(n:byte);
begin
if pers[n,3]<2 then pers[n,3]:=pers[n,3]+1 else pers[n,3]:=0; {bob}
if pers[n,2]=4 then
begin
if (map[trunc((pers[n,0]-1)/16),trunc((pers[n,1]-8)/16)]<2) and
(map[trunc((pers[n,0]-1)/16),trunc((pers[n,1]+7)/16)]<2) then
begin
pers[n,0]:=pers[n,0]-pers[n,14];
end
else
{adaptation}
begin
if (map[trunc((pers[n,0]-1)/16),trunc((pers[n,1]+7)/16)]>1) then
if (map[trunc((pers[n,0]-1)/16),trunc((pers[n,1]-4)/16)]<2) then pers[n,1]:=pers[n,1]-4;
if (map[trunc((pers[n,0]-1)/16),trunc((pers[n,1]-8)/16)]>1) then
if (map[trunc((pers[n,0]-1)/16),trunc((pers[n,1]+4)/16)]<2) then pers[n,1]:=pers[n,1]+4;
end;
end
else
pers[n,2]:=4;
end;

procedure Droite(n:byte);
begin
if pers[n,3]<2 then pers[n,3]:=pers[n,3]+1 else pers[n,3]:=0; {bob}
if pers[n,2]=2 then
begin
if (map[trunc((pers[n,0]+17)/16),trunc((pers[n,1]-8)/16)]<2) and
(map[trunc((pers[n,0]+17)/16),trunc((pers[n,1]+7)/16)]<2) then
 begin
 pers[n,0]:=pers[n,0]+pers[n,14];
 {pers[n,2]:=2; }
 end
 else
 {Adaptation}
 begin
 if (map[trunc((pers[n,0]+17)/16),trunc((pers[n,1]+7)/16)]>1) then
 if (map[trunc((pers[n,0]+17)/16),trunc((pers[n,1]-4)/16)]<2) then pers[n,1]:=pers[n,1]-4;
 if (map[trunc((pers[n,0]+17)/16),trunc((pers[n,1]-8)/16)]>1) then
 if (map[trunc((pers[n,0]+17)/16),trunc((pers[n,1]+4)/16)]<2) then pers[n,1]:=pers[n,1]+4;
 end;
end
else
pers[n,2]:=2;
end;

procedure haut(n:byte);
begin
if pers[n,3]<2 then pers[n,3]:=pers[n,3]+1 else pers[n,3]:=0; {bob}
if pers[n,2]=1 then
begin
if (map[trunc((pers[n,0])/16),trunc((pers[n,1]-9)/16)]<2) and
(map[trunc((pers[n,0]+15)/16),trunc((pers[n,1]-9)/16)]<2) then
begin
pers[n,1]:=pers[n,1]-pers[n,14];
end
else
begin
if (map[trunc((pers[n,0]+15)/16),trunc((pers[n,1]-9)/16)]>1) then
if (map[trunc((pers[n,0]+4)/16),trunc((pers[n,1]-9)/16)]<2) then pers[n,0]:=pers[n,0]-4;
if (map[trunc((pers[n,0])/16),trunc((pers[n,1]-9)/16)]>1) then
if(map[trunc((pers[n,0]+12)/16),trunc((pers[n,1]-9)/16)]<2) then pers[n,0]:=pers[n,0]+4;
end;
end
else
pers[n,2]:=1;
end;

procedure Bas(n:byte);
begin
if pers[n,3]<2 then pers[n,3]:=pers[n,3]+1 else pers[n,3]:=0; {bob}
if (pers[n,2]=3) then
begin
if (map[trunc((pers[n,0])/16),trunc((pers[n,1]+9)/16)]<2) and
(map[trunc((pers[n,0]+15)/16),trunc((pers[n,1]+9)/16)]<2) then
begin
pers[n,1]:=pers[n,1]+pers[n,14];
end
else
begin
if (map[trunc((pers[n,0]+15)/16),trunc((pers[n,1]+9)/16)]>1) then
if (map[trunc((pers[n,0]+4)/16),trunc((pers[n,1]+9)/16)]<2) then pers[n,0]:=pers[n,0]-4;
if (map[trunc((pers[n,0])/16),trunc((pers[n,1]+9)/16)]>1) then
if (map[trunc((pers[n,0]+12)/16),trunc((pers[n,1]+9)/16)]<2) then pers[n,0]:=pers[n,0]+4;
end;
end
else
pers[n,2]:=3;
{end;}
end;

procedure tire(n:byte);
begin
pers[n,3]:=4; {bob}
pers[n,4]:=1;
pers[n,7]:=pers[n,2];
if pers[n,2]=1 then
begin pers[n,5]:=pers[n,0]+8; pers[n,6]:=pers[n,1]-1; end;
if pers[n,2]=2 then
begin pers[n,6]:=pers[n,1]+8; pers[n,5]:=pers[n,0]+17; end;
if pers[n,2]=3 then
begin pers[n,5]:=pers[n,0]+8; pers[n,6]:=pers[n,1]+17; end;
if pers[n,2]=4 then
begin pers[n,6]:=pers[n,1]+8; pers[n,5]:=pers[n,0]-1; end;
end;

procedure AffTire(coul,n1:byte);
begin
putpixel(pers[n1,5],pers[n1,6],coul,e1^);
end;

procedure Calctire (n:byte);
begin
if pers[n,4]=2 then pers[n,4]:=0;
if pers[n,4]=1 then
begin
if pers[n,7]=1 then pers[n,6]:=pers[n,6]-14;
if pers[n,7]=2 then pers[n,5]:=pers[n,5]+14;
if pers[n,7]=3 then pers[n,6]:=pers[n,6]+14;
if pers[n,7]=4 then pers[n,5]:=pers[n,5]-14;
if map[trunc(pers[n,5]/16),trunc((pers[n,6]-8)/16)]>1 then
begin
pers[n,4]:=2;
if pers[n,7]=1 then declat(pers[n,5]-4,trunc((pers[n,6]-8)/16)*16+24,3,e1^);
if pers[n,7]=2 then declat(trunc(pers[n,5]/16)*16-8,pers[n,6]-4,4,e1^);
if pers[n,7]=3 then declat(pers[n,5]-4,trunc((pers[n,6]-8)/16)*16,1,e1^);
if pers[n,7]=4 then declat(trunc(pers[n,5]/16)*16+16,pers[n,6]-4,2,e1^);
end
else
for i:=0 to joueur-1 do
begin
if (n<>i) and (pers[i,13]<>1) and (pers[i,10]>=0) and(pers[n,5]>pers[i,0]) and (pers[n,5]<pers[i,0]+16) and
(pers[n,6]>pers[i,1]) and (pers[n,6]<pers[i,1]+16) then
begin
pers[i,10]:=pers[i,10]-2;
pers[i,3]:=3;     {bob}
pers[i,9]:=5; {tempo bob}
pers[n,4]:=0;
end
else
affTire(215,n);
end;
end;
end;

procedure  DFLAM(x,y:word;n1,n2:byte;var scr:screen);
var
i,j:word;
begin
 putspriteclip(x,y,16,16,0,24,320,200,@flam[n1,n2,0,0],@scr)
end;

procedure LanceFlam(n:byte);
var
u:byte;
begin
{Position Haute}
if pers[n,2]=1 then
{*******}
for u:=1 to 3  do
begin
 for i:=0 to joueur-1 do
 begin
 if (n<>i) and (pers[i,13]<>1) and (trunc(round(pers[n,0]/16))=trunc(round(pers[i,0]/16))) and
 (trunc(round(pers[n,1]/16))-u=trunc(round(pers[i,1]/16))) then
 begin
 pers[i,10]:=pers[i,10]-1;
 pers[i,3]:=3; {bob}
 pers[i,9]:=5; {tempo bob}
 end;
 end;
{*******}
if pers[n,4]=1 then
dflam(pers[n,0],pers[n,1]-u*16,1,u,e1^);
end;

if pers[n,2]=2 then
for u:=1 to 3  do
begin
 for i:=0 to joueur-1 do
 begin
 if (n<>i) and (pers[i,13]<>1) and (trunc(round(pers[n,0]/16))+u=trunc(round(pers[i,0]/16))) and
 (trunc(round(pers[n,1]/16))=trunc(round(pers[i,1]/16))) then
 begin
 pers[i,10]:=pers[i,10]-1;
 pers[i,3]:=3; {bob}
 pers[i,9]:=5; {tempo bob}
 end;
 end;
if pers[n,4]=1 then
dflam(pers[n,0]+u*16,pers[n,1],2,u,e1^);
end;

if pers[n,2]=3 then
for u:=1 to 3  do
begin
 for i:=0 to joueur-1 do
 begin
 if (n<>i) and (pers[i,13]<>1) and (trunc(round(pers[n,0]/16))=trunc(round(pers[i,0]/16))) and
 (trunc(round(pers[n,1]/16))+u=trunc(round(pers[i,1]/16))) then
 begin
 pers[i,10]:=pers[i,10]-1;
 pers[i,3]:=3; {bob}
 pers[i,9]:=5; {tempo bob}
 end;
 end;
if pers[n,4]=1 then
dflam(pers[n,0],pers[n,1]+u*16,3,u,e1^);
end;

if pers[n,2]=4 then
for u:=1 to 3  do
begin
 for i:=0 to joueur-1 do
 begin
 if (n<>i) and (pers[i,13]<>1) and (trunc(round(pers[n,0]/16))-u=trunc(round(pers[i,0]/16))) and
 (trunc(round(pers[n,1]/16))=trunc(round(pers[i,1]/16))) then
 begin
 pers[i,10]:=pers[i,10]-1;
 pers[i,3]:=3; {bob}
 pers[i,9]:=5; {tempo bob}
 end;
 end;
if pers[n,4]=1 then
dflam(pers[n,0]-u*16,pers[n,1],4,u,e1^);
end;

if pers[n,4]=2 then pers[n,4]:=0;
if pers[n,4]=1 then pers[n,4]:=2;
end;

procedure TestBonus;
var f:byte;
begin
 if bonus[2]=0 then
 begin
  if random(200)>180 then
  begin
   bonus[0]:=random(LM);
   bonus[1]:=random(HM);
   if map[bonus[0],bonus[1]+1]<2 then
   begin
    bonus[2]:=random(5);
   end;
  end;
 end
 else
 begin
  putico(bonus[0]*16,bonus[1]*16+24,11+bonus[2],e1^);
  for i:=0 to joueur-1 do
  if (trunc(pers[i,0]/16)=bonus[0]) and (trunc((pers[i,1]-24)/16)=bonus[1]) then
  begin
   if bonus[2]=1 then pers[i,10]:=MaxEnergie;
   if bonus[2]=2 then
   begin
   pers[i,14]:=4;
   pers[i,11]:=1;
   pers[i,13]:=0;
   pers[i,12]:=200;
   pers[i,4]:=0;
   end;
   IF bonus[2]=3 then
   begin
   pers[i,13]:=1;
   pers[i,11]:=0;
   pers[i,12]:=150;
   pers[i,4]:=0;
   end;
   IF bonus[2]=4 then
   begin
   s:=random(4);
   if s=3 then pers[i,10]:=trunc(pers[i,10]/2);
   if s=0 then
   begin
   pers[i,13]:=0;
   pers[i,11]:=0;
   pers[i,4]:=3;
   pers[i,12]:=200;
   end;
   if s=1 then
   begin
   for f:=0 to 3 do
   if f<>i then pers[f,10]:=trunc(pers[f,10]/2);
   end;
   if s=2 then
   begin
   pers[i,14]:=8;
   pers[i,13]:=0;
   pers[i,11]:=0;
   pers[i,12]:=250;
   end;
   end;
   bonus[2]:=0;
   i:=joueur-1;
  end;
 end;
end;

procedure  BarreEnergie(var scr:screen);
var
y:byte;
begin
for i:=0 to joueur-1 do
begin
for y:=15 downto  0 do
for j:=0 to 15 do
scr[y,16+i*80+j]:=0;
for y:=15 downto  15-pers[i,10] do
for j:=0 to 15 do
scr[y,16+i*80+j]:=19;
end;
end;

procedure SiFin;
var go2:byte;
begin
go2:=joueur;
for i:=0 to joueur-1 do
if pers[i,10]<0 then go2:=go2-1;
if go2<>go then go:=go2;
end;

procedure AffPage(var scr:screen);
var
t,r,i,j:integer;
begin
for t:=0 to 19 do
for r:=0 to 12 do
putsprite(16*t,r*16,16,16,@cases[tablpres[20*r+t]+terrain*4,0,0],e1);
end;

procedure PagePre;
var
m,v,p,a,g,d,x:integer;
deb:boolean;
begin
carte:=1;
x:=0;
d:=1;
v:=7;
a:=0;
p:=5;
deb:=false;
esc:=false;
repeat
if terrain>3 then terrain:=0;
if joueur>4 then joueur:=2;
if m<0 then m:=4;
if m>4 then m:=0;
AffPage(e1^);
{commencer}
putIco(112,112,16,e1^);
putIco(128,112,17,e1^);
putIco(144,112,18,e1^);
putIco(160,112,19,e1^);
putIco(176,112,20,e1^);
{x Joueur}
putIco(112,128,31+joueur,e1^);
putIco(128,128,21,e1^);
putIco(144,128,22,e1^);
putIco(160,128,23,e1^);
putIco(176,128,24,e1^);
{Terrain}
if terrain=1 then
begin
putIco(112,144,36,e1^);
putIco(128,144,37,e1^);
putIco(144,144,38,e1^);
putIco(160,144,39,e1^);
end;
if terrain=0 then
begin
putIco(112,144,40,e1^);
putIco(128,144,41,e1^);
putIco(144,144,42,e1^);
putIco(160,144,43,e1^);
end;
if terrain=2 then
begin
putIco(112,144,44,e1^);
putIco(128,144,45,e1^);
putIco(144,144,46,e1^);
putIco(160,144,47,e1^);
end;
if terrain=3 then
begin
putIco(112,144,48,e1^);
putIco(128,144,49,e1^);
putIco(144,144,50,e1^);
end;
{Touches}
putIco(112,160,25,e1^);
putIco(128,160,26,e1^);
putIco(144,160,27,e1^);
putIco(160,160,28,e1^);
{Quitter}
putIco(112,176,29,e1^);
putIco(128,176,30,e1^);
putIco(144,176,31,e1^);
putIco(160,176,32,e1^);
{Copyright}
putIco(256,184,51,e1^);
putIco(272,184,52,e1^);
putIco(288,184,53,e1^);
putIco(304,184,54,e1^);
DBOB(96,112+m*16,p+a+terrain*22,e1^);

if keypressed=true then key:=readkey;
e:=e1^;
if deb=false then begin fondu1(15,pal1^); deb:=true; end;
with clavier do
begin
if echap=true then esc:=true;
if fleche[1]=true then m:=m-1;
if fleche[2]=true then m:=m+1;
if entree=true then
begin
a:=3;
if m=0 then g:=1;
if m=2 then terrain:=terrain+1;
if m=1 then joueur:=joueur+1;
if m=4 then esc:=true;
end;
end;
a:=a+1;
if a>=3 then a:=0;
x:=x+d*v;
if x>=448 then
begin
d:=-1;
p:=15;
end;
if x<=0 then
begin
d:=1;
p:=5;
end;
delay(50);
until (g=1) or (esc=true);
fondu2(30,pal1^);
cls(0);
e1^:=e;
end;

procedure GAGNER(n:byte;var scr:screen);
var
g:boolean;
t:word;
begin
for t:=0 to 19 do
putico(t*16,64,n,e1^);
putico(128,80,55,e1^);
putico(144,80,56,e1^);
putico(160,80,57,e1^);
putico(176,80,58,e1^);
e:=e1^;
g:=false;
repeat
begin
with clavier do
begin
if entree=true then g:=true;
end;
end;
until g=true;
fondu2(30,pal1^);
cls(0);
e1^:=e;
end;

{***************************************************************************}
begin
{ChAcces:='c:\tp\progs\blower\';}
new(pal1);
initclavier;
ecran;
new (E1);
new (E2);
e1^:=e;
e2^:=e;
initMap;
 Bmp('PageP.Bmp',pal1^);
 fondu1(50,pal1^);
 delay(2000);
 fondu2(70,pal1^);
 cls(0);
 terrain:=1;
 2:
 PagePre;
 if esc=true then goto 3;
 1:
 go:=joueur;
 bonus[2]:=0;
 pers[0,0]:=16;
 pers[0,1]:=40;
 pers[0,2]:=2;
 pers[0,4]:=0;
 pers[0,9]:=0;
 pers[0,3]:=0;
 pers[0,9]:=0;
 pers[0,10]:=MaxEnergie;
 pers[0,11]:=0;
 pers[0,13]:=0;
 pers[0,14]:=4;
 pers[1,0]:=288;
 pers[1,1]:=168;
 pers[1,2]:=4;
 pers[1,4]:=0;
 pers[1,9]:=0;
 pers[1,3]:=0;
 pers[1,9]:=0;
 pers[1,10]:=MaxEnergie;
 pers[1,11]:=0;
 pers[1,13]:=0;
 pers[1,14]:=4;
 pers[2,0]:=288;
 pers[2,1]:=40;
 pers[2,2]:=4;
 pers[2,4]:=0;
 pers[2,9]:=0;
 pers[2,3]:=0;
 pers[2,9]:=0;
 pers[2,10]:=MaxEnergie;
 pers[2,11]:=0;
 pers[2,13]:=0;
 pers[2,14]:=4;
 pers[3,0]:=16;
 pers[3,1]:=168;
 pers[3,2]:=2;
 pers[3,4]:=0;
 pers[3,9]:=0;
 pers[3,3]:=0;
 pers[3,9]:=0;
 pers[3,10]:=MaxEnergie;
 pers[3,11]:=0;
 pers[3,13]:=0;
 pers[3,14]:=4;
 for i:=0 to 19 do for j:=0 to 11 do
 map[i,j+1]:=tableau[carte,I+J*20];
 effacebuffer(e2,0);
 for i:=0 to 3 do
 putico(0+i*80,0,i,e1^);
 affmap(0,1,19,11);
 go1:=0;
 for i:=0 to joueur-1 do DBOB(Pers[i,0],pers[i,1],pers[i,3]+pers[i,9]+i*22,e1^);
 e:=e1^;
 fondu1(25,pal1^);
 repeat
 {-----------------}
 {Interface Clavier}
 if keypressed=true then key:=readkey;
 with clavier do
 begin
 {d‚placements}
 if (pers[0,4]<>2) and (pers[0,10]>=0) then
 begin
 if fleche[3]=true then Gauche(0);
 if fleche[4]=true then Droite(0);
 if fleche[1]=true then Haut(0);
 if fleche[2]=true then Bas(0);
 end;
 if (pers[1,4]<>2) and (pers[1,10]>=0) then
 begin
 if pavealphabetique[2,3]=true then Gauche(1);
 if pavealphabetique[4,3]=true then Droite(1);
 if pavealphabetique[3,2]=true then Haut(1);
 if pavealphabetique[3,3]=true then Bas(1);
 end;
 if (pers[2,4]<>2) and (pers[2,10]>=0) then
 begin
 if pavenumerique[1,3]=true then Gauche(2);
 if pavenumerique[3,3]=true then Droite(2);
 if pavenumerique[2,2]=true then Haut(2);
 if pavenumerique[2,3]=true then Bas(2);
 end;
 if (pers[3,4]<>2) and (pers[3,10]>=0) then
 begin
  if pavealphabetique[7,3]=true then Gauche(3);
  if pavealphabetique[9,3]=true then Droite(3);
  if pavealphabetique[8,2]=true then Haut(3);
  if pavealphabetique[8,3]=true then Bas(3);
 end;
 {tirer}
 if (ctrl[2]=true) and (pers[0,4]<>1) and (pers[0,4]<>3) and (pers[0,10]>=0) then tire(0);
 if (ctrl[1]=true) and (pers[1,4]<>1) and (pers[1,4]<>3) and (pers[1,10]>=0) then tire(1);
 if (pavenumerique[1,5]=true) and (pers[2,4]<>1) and (pers[2,4]<>3) and (pers[2,10]>=0) then tire(2);
 if (alt[2]=true) and (pers[3,4]<>1) and (pers[3,4]<>3) and (pers[3,10]>=0) then tire(3);
 {Commande g‚n‚rale}
 if fonction[12]=true then go1:=2;
 if fonction[3]=true then go1:=1;
 if fonction[1]=true then repeat until fonction[2]=true;
 end;
 {-----------------}
 copiebuffer(e2,e1);
 TestBonus;
 BarreEnergie(e1^);
 for j:=0 to joueur-1 do
 begin
  if keypressed=true then key:=readkey;
  if pers[j,10]>=0 then
  begin
   if pers[j,11]=0 then CalcTire(j);
   if (pers[j,11]=1) and (pers[j,4]>0) then LanceFlam(j);
   if pers[j,13]=1  then
    begin if random(2)=1 then DBOB(Pers[j,0],pers[j,1],(pers[j,2]-1)*5+pers[j,3]+j*22,e1^); end
     else DBOB(Pers[j,0],pers[j,1],(pers[j,2]-1)*5+pers[j,3]+j*22,e1^);
    if (pers[j,3]=3) and (pers[j,9]<=0) then pers[j,3]:=0;   {Animation}
    if pers[j,9]<>0 then pers[j,9]:=pers[j,9]-1;
    if pers[j,12]>0 then {Bonus}
    begin
    pers[j,12]:=pers[j,12]-1;
    if pers[j,12]<=0 then
     begin
     if pers[j,4]=3 then pers[j,4]:=0;
     if pers[j,13]=0 then pers[j,11]:=0;
     if pers[j,13]=1 then pers[j,13]:=0;
     if pers[j,14]=8 then pers[j,14]:=4;
     end;
    end;
   end
   else
   begin
   dbob(pers[j,0]-16,pers[j,1],20+j*22,e1^);
   dbob(pers[j,0],pers[j,1],21+j*22,e1^);
   end;
   if pers[j,3]=4 then pers[j,3]:=0; {fin anim tire}
  end;
  if keypressed=true then key:=readkey;
  {Affichage des tronches}
  for i:=0 to 3 do
  begin
  if i+4*(2-round(pers[i,10]/(15/2)))<12 then putico(0+i*80,0,i+4*(2-round(pers[i,10]/(15/2))),e1^);
 if pers[i,10]<=0 then putico(0+i*80,0,i+8,e1^);
 end;
 vsync;
 copiebuffer(e1,@e);
 SiFin;
 delay(VIT);
until (go=1) or (Go1<>0);
carte:=carte+1;
if carte>=Nbcarte then go1:=1;
for i:=0 to 19 do for j:=0 to 11 do
map[i,j+1]:=tableau[carte,I+J*20];
if go1=2 then goto 1;
for i:=0 to joueur-1 do
if (pers[i,10]>=0) and (go=1) then Gagner(i,e1^);
cls(0);
if go1<>1 then goto 1 else begin fondu2(20,pal1^); goto 2 end;
3:
doneclavier;
dispose(e1);
{mode texte}
Bmp('PageP.Bmp',pal1^);
fondu1(50,pal1^);
delay(2000);
fondu2(70,pal1^);
asm
mov ax,03h
int 10h
end;
writeln('Au revoir!  J ‚spŠre que tu as aim‚ BLOWER 1.0a.');
writeln('BLOWER 1.0a est FREEWARE (Gratuit, mais pas libre de droits).');
writeln('Youen Ch‚n‚ ¸1997.');
readln;
end.
