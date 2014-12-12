#@creation_date 3.05.08
#@modification_date 24.05.08
#@version 0.2
#@author Kornilov Ivan

#��������� ������ ������� ����������
sub short_statistics
{
my $k1,$u1,$k2,$u2;
my $p_time=$_[0];
my $sum=0;
my $sumb=0;

while (($k1,$u1)=each %{$p_time}){

my $q_ip=$u1;

while (($k2,$u2)=each %{$q_ip}){

my $vb=($u2/(1024*1024))*$cost{$k2};
$sum+=$vb;
$sumb+=$u2;
}
}
print "Itogo:","\t","\t","\t","\t",substr($sumb/(1024*1024),0,7),"\t","\t",substr($sum,0,7),"\n";
}

#��������� ������ ��������� ����������
sub detail_statistics
{
my $k1,$u1,$k2,$u2;
my $p_time=$_[0];
my $sum=0;
my $sumb=0;
foreach $k1 (sort keys(%{$p_time})){

my $q_ip=${$p_time}{$k1};
print "\t",$k1."\n";

while (($k2,$u2)=each %{$q_ip}){

my $vb=($u2/(1024*1024))*$cost{$k2};
$sum+=$vb;
$sumb+=$u2;
format MY =
            @<<<<<<<<<<<<<<<<<<<<<<<<<@||||||||| @>>>>>>>>>
$q1,$q2,$q3
.

$q1=$k2;
$q2=substr($u2/(1024*1024),0,7);
$q3=substr($vb,0,7);
$~='MY';
write;
}

}

format MY2 =
Itogo:                                @||||||||| @>>>>>>>>>
$q1,$q2
.

$q1=substr($sumb/(1024*1024),0,7);
$q2=substr($sum,0,7);
$~='MY2';
write;

}

#�������� ����� ���� �������� �� ������ 

open CF,'cost.txt' or die "Error opening file cost.txt: $!\n";
#������ ����� ���� ��������  

while (<CF>){
chomp;
@w=/(\S+)/g;
$cost{$w[0]}=$w[1];
}

#�������� ����� ���� �������� �� ������ 

close CF;

#����� ���� ��������

print "Cost resources (for mb):\n";
for (sort keys %cost){
print $_,"\t",$cost{$_},"\n";
}

#�������� ���-����� ���-������� �� ������

open LF,'access.log' or die "Error opening file access.log: $!\n";

#������ ���-����� ���-�������  

while (<LF>){
chomp;
@w=/(\S+)/g;

#������� �� ������� ����� �������, ��� ������������ , ���������� ������, �����

$name_user=$w[1];


$w[3]=~/(\d\d\/\D+\/\d\d\d\d)/;

$time=$1;

$bytes=$w[9];

$w[10]=~/"http:\/\/(.*)"/;
$str_url=$1;

#������ ����� �������, ��� ������������ , ���������� ������, ����� � ���

$users{$name_user}->{$time}->{$str_url}+=$bytes;

}

#�������� ���-����� ���-�������

close LF;

while (1)
{
print "For exit from program press 'q'","\n";
print "Input name user...";

#���� ����� ������������

$input_name=<STDIN>;

chomp $input_name;

#���� ������ ������ 'q'������ ����� ������������ �� �����
last if ($input_name eq "q");

#���� ��� ������������ ������ ������
if ($input_name eq "")
{print "\t","\t","\t","\t","size (mb)","\t","cost","\n";
	while (($k0,$u0)=each %users)
	{

		$p_time0=$u0;
		print $k0,"\n";
		short_statistics($p_time0);
	}
}
else #���� ��� ������������ �� ������ ������
{print "\t","\t","\t","\t","size (mb)","\t","cost","\n";
	if (exists $users{$input_name})
	{
		print $input_name,"\n";
		$p_time0=$users{$input_name};
		short_statistics($p_time0);
	}
}

print "Would you want see detail statistics?(y/n)";

#�������� �� ��������� ����������

$ce=<STDIN>;
chomp $ce;

#���� ������ ������ 'q'������ 'y' �� �����
last if ($ce eq "q");

#���� ������ ������ 'y' �� ������� ��������� ����������
if ($ce eq "y")
{

#���� ��� ������������ ������ ������, �� �������� ��������� ���������� �� ������� ������������
if ($input_name eq "")
{
format MY3 =
            @<<<<<<<<<<<<<<<<<<<<<<<<<@||||||||| @>>>>>>>>>
$q1,$q2,$q3
.

$q1="resource";
$q2="size (mb)";
$q3="cost";
$~='MY3';
write;

	while (($k0,$u0)=each %users)
	{

		$p_time0=$u0;
		print $k0,"\n";
		detail_statistics($p_time0);
	}
}
else#���� ��� ������������ �� ������ ������
{
format MY4 =
            @<<<<<<<<<<<<<<<<<<<<<<<<<@||||||||| @>>>>>>>>>
$q1,$q2,$q3
.
$q1="resource";
$q2="size (mb)";
$q3="cost";
$~='MY4';
write;
	if (exists $users{$input_name})
	{
		print $input_name,"\n";
		$p_time0=$users{$input_name};
		detail_statistics($p_time0);
	}
}
}
}