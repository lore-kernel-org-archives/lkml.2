Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1IMRyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:54:33 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58488 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab1IMRyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:54:32 -0400
Date: Tue, 13 Sep 2011 23:24:25 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110913175425.GB3062@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1315571462.26517.9.camel@twins>
 <20110912101722.GA28950@linux.vnet.ibm.com>
 <1315830943.26517.36.camel@twins>
 <20110913041545.GD11100@linux.vnet.ibm.com>
 <20110913050306.GB7254@linux.vnet.ibm.com>
 <1315906788.575.3.camel@twins>
 <20110913112852.GE7254@linux.vnet.ibm.com>
 <1315922848.5977.11.camel@twins>
 <20110913162119.GA3045@linux.vnet.ibm.com>
 <1315931775.5977.29.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <1315931775.5977.29.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 18:36:15]:
> > Value of sched_cfs_bandwidth_slice_us was reduced from default of 5000us
> > to 500us, which (along with reduction of min/max interval) helped cut down
> > idle time further (3.9% -> 2.7%). I was commenting that this may not necessarily
> > be optimal (as for example low 'sched_cfs_bandwidth_slice_us' could result
> > in all cpus contending for cfs_b->lock very frequently). 
> 
> Right.. so this seems to suggest you're migrating a lot.

We did do some experiments (outside of capping) to see how badly tasks
migrate on latest tip (compared to previous kernels). The test was to
spawn 32 cpuhogs on a 16-cpu system (place them in default cgroup -
without any capping in place) and measure how much they bounce around.
System had little load besides these cpu hogs.

We saw considerably high migration count on latest tip compared to
previous kernels. Kamalesh, can you please post the migration count
data?

> Also what workload are we talking about? the insane one with 5 groups of
> weight 1024?

We never were running the "insane" one ..we are always with proportional
shares, the "sane" one! I missed to mention that bit in my first email
(about the shares setup). I am attaching the test script we are using
for your reference. Fyi, we have added additional levels to cgroup setup
(/Level1/Level2/C1/C1_1 etc) to mimic cgroup hierarchy for VMS as
created by libvirt.

> Ramping up the frequency of the load-balancer and giving out smaller
> slices is really anti-scalability.. I bet a lot of that 'reclaimed' idle
> time is spend in system time. 

System time (in top and vmstat) does remain unchanged at 0% when
cranking up load-balance frequency and slicing down
sched_cfs_bandwidth_slice_us ..I guess the additional "system" time
can't be accounted for easily by the tick-based accounting system we
have. I agree there could be other un-observed side-effects of increased
load-balance frequency (like workload performance) that I haven't noticed. 

- vatsa

--vkogqOf2sHV7VnPd
Content-Type: application/x-sh
Content-Disposition: attachment; filename="hard_limit_test.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0ANR_TASKS1=3D2=0ANR_TASKS2=3D2=0ANR_TASKS3=3D4=0ANR_TASKS4=
=3D8=0ANR_TASKS5=3D16=0A=0ABANDWIDTH=3D1=0ASUBGROUP=3D1=0APRO_SHARES=3D1=0A=
MOUNT_POINT=3D/cgroups/=0AMOUNT=3D/cgroups/=0ALOAD=3D./while1=0ALEVELS=3D2=
=0ACFS_PERIOD=3D500000=0ACFS_QUOTA=3D250000=0Astart_bounce_count=3D`cat /pr=
oc/sys/kernel/sched_migrate_bounce`=0A=0Ausage()=0A{=0A	echo "Usage $0: [-b=
 0|1] [-s 0|1] [-p 0|1]"=0A	echo "-b 1|0 set/unset  Cgroups bandwidth contr=
ol (default set)"=0A	echo "-s Create sub-groups for every task (default cre=
ates sub-group)"=0A	echo "-p create propotional shares based on cpus"=0A	ex=
it=0A}=0Awhile getopts ":b:s:p:" arg=0Ado=0A	case $arg in=0A	b)=0A		BANDWID=
TH=3D$OPTARG=0A		shift=0A		if [ $BANDWIDTH -gt 1 ] && [ $BANDWIDTH -lt  0 ]=
=0A		then=0A			usage=0A		fi=0A		;;=0A	s)=0A		SUBGROUP=3D$OPTARG=0A		shift=
=0A		if [ $SUBGROUP -gt 1 ] && [ $SUBGROUP -lt 0 ]=0A		then=0A			usage=0A		=
fi=0A		;;=0A	p)=0A		PRO_SHARES=3D$OPTARG=0A		shift=0A		if [ $PRO_SHARES -gt=
 1 ] && [ $PRO_SHARES -lt 0 ]=0A		then=0A			usage=0A		fi=0A		;;=0A=0A	*)=0A=
=0A	esac=0Adone=0Aif [ ! -d $MOUNT ]=0Athen=0A	mkdir -p $MOUNT=0Afi=0Atest(=
)=0A{=0A	echo -n "[ "=0A	if [ $1 -eq 0 ]=0A	then=0A		echo -ne '\E[42;40mOk'=
=0A	else=0A		echo -ne '\E[31;40mFailed'=0A		tput sgr0=0A		echo " ]"=0A		exi=
t=0A	fi=0A	tput sgr0=0A	echo " ]"=0A}=0A=0Amount_cgrp()=0A{=0A	mkdir -p $MO=
UNT_POINT=0A	echo -n "Mounting root cgroup "=0A	mount -t cgroup -ocpu,cpuse=
t,cpuacct none $MOUNT_POINT &> /dev/null=0A	test $?=0A}=0A=0Aumount_cgrp()=
=0A{=0A	cur_dir=3D`pwd`=0A	echo -n "Unmounting root cgroup "=0A	cd $MOUNT_P=
OINT=0A	rmdir */*/*/*/*; rmdir */*/*/*; rmdir */*/*; rmdir */*; rmdir *=0A	=
cd /root/=0A	umount $MOUNT_POINT=0A=0A	service libvirtd stop=0A	cd /cgroup=
=0A	rmdir */*/*; rmdir */*=0A	umount *=0A	cd $cur_dir=0A}=0A=0Acreate_hiera=
rchy()=0A{=0A	umount_cgrp=0A	mount_cgrp=0A	cpuset_mem=3D`cat $MOUNT/cpuset.=
mems`=0A	cpuset_cpu=3D`cat $MOUNT/cpuset.cpus`=0A	echo -n "creating hierarc=
hy of levels $LEVELS "=0A	for (( i=3D1; i<=3D$LEVELS; i++ ))=0A	do=0A		MOUN=
T=3D"${MOUNT}/level${i}"=0A		mkdir $MOUNT=0A		echo $cpuset_mem > $MOUNT/cpu=
set.mems=0A		echo $cpuset_cpu > $MOUNT/cpuset.cpus=0A		if [ $PRO_SHARES -eq=
 1 ]=0A		then=0A			echo "32768" > $MOUNT/cpu.shares=0A		fi=0A		echo "-1" > =
$MOUNT/cpu.cfs_quota_us=0A		echo $CFS_PERIOD > $MOUNT/cpu.cfs_period_us=0A	=
	echo -n " .."=0A	done=0A	echo " "=0A	echo $MOUNT=0A	echo -n "creating grou=
ps/sub-groups ..."=0A	for (( i=3D1; i<=3D5; i++ ))=0A	do=0A		mkdir $MOUNT/$=
i=0A		echo $cpuset_mem > $MOUNT/$i/cpuset.mems=0A		echo $cpuset_cpu > $MOUN=
T/$i/cpuset.cpus=0A		echo -n ".."=0A		if [ $SUBGROUP -eq 1 ]=0A		then=0A			=
jj=3D$(eval echo "\$NR_TASKS$i")=0A			for (( j=3D1; j<=3D$jj; j++ ))=0A			d=
o=0A				mkdir -p $MOUNT/$i/$j=0A				echo $cpuset_mem > $MOUNT/$i/$j/cpuset.=
mems=0A				echo $cpuset_cpu > $MOUNT/$i/$j/cpuset.cpus=0A				echo -n ".."=
=0A			done=0A		fi=0A	done=0A	echo "."=0A}=0A=0Acleanup()=0A{=0A	pkill -9 wh=
ile1 &> /dev/null=0A	sleep 10=0A	echo -n "Umount groups/sub-groups .."=0A	f=
or (( i=3D1; i<=3D5; i++ ))=0A	do=0A		if [ $SUBGROUP -eq 1 ]=0A		then=0A			=
jj=3D$(eval echo "\$NR_TASKS$i")=0A			for (( j=3D1; j<=3D$jj; j++ ))=0A			d=
o=0A				rmdir $MOUNT/$i/$j=0A				echo -n ".."=0A			done=0A		fi=0A		rmdir $M=
OUNT/$i=0A		echo -n ".."=0A	done=0A	cd $MOUNT=0A	cd ../=0A	for (( i=3D$LEVE=
LS; i>=3D1; i-- ))=0A	do=0A		rmdir level$i=0A		cd ../	=0A	done=0A	echo " "=
=0A	umount_cgrp=0A}=0A=0Aload_tasks()=0A{=0A	for (( i=3D1; i<=3D5; i++ ))=
=0A	do=0A		jj=3D$(eval echo "\$NR_TASKS$i")=0A		shares=3D"1024"=0A		if [ $P=
RO_SHARES -eq 1 ]=0A		then=0A			eval shares=3D$(echo "$jj * 1024" | bc)=0A	=
	fi=0A		echo $shares > $MOUNT/$i/cpu.shares=0A		for (( j=3D1; j<=3D$jj; j++=
 ))=0A		do=0A			echo "-1" > $MOUNT/$i/cpu.cfs_quota_us=0A			echo "100000" >=
 $MOUNT/$i/cpu.cfs_period_us=0A			if [ $SUBGROUP -eq 1 ]=0A			then=0A=0A			=
	$LOAD &=0A				echo $! > $MOUNT/$i/$j/tasks=0A				echo "1024" > $MOUNT/$i/$=
j/cpu.shares=0A=0A				if [ $BANDWIDTH -eq 1 ]=0A				then=0A					echo $CFS_P=
ERIOD > $MOUNT/$i/$j/cpu.cfs_period_us=0A					echo $CFS_QUOTA > $MOUNT/$i/$=
j/cpu.cfs_quota_us=0A				fi=0A			else=0A				$LOAD & =0A				echo $! > $MOUNT=
/$i/tasks=0A				echo $shares > $MOUNT/$i/cpu.shares=0A=0A				if [ $BANDWIDT=
H -eq 1 ]=0A				then=0A					echo "100000" > $MOUNT/$i/cpu.cfs_period_us=0A	=
				echo "50000" > $MOUNT/$i/cpu.cfs_quota_us=0A				fi=0A			fi=0A		done=0A	=
done=0A	echo "Capturing idle cpu time with vmstat...."=0A	vmstat 2 100 &> v=
mstat_log &=0A}=0A=0Apin_tasks()=0A{=0A	cpu=3D0=0A	count=3D1=0A	for (( i=3D=
1; i<=3D5; i++ ))=0A	do=0A		if [ $SUBGROUP -eq 1 ]=0A		then=0A			jj=3D$(eva=
l echo "\$NR_TASKS$i")=0A			for (( j=3D1; j<=3D$jj; j++ ))=0A			do=0A	#			i=
f [ $count -gt 2 ]=0A	#			then=0A	#				cpu=3D$((cpu+1))=0A	#				count=3D1=
=0A	#			fi=0A	#			echo $cpu > $MOUNT/$i/$j/cpuset.cpus=0A	#			count=3D$((co=
unt+1))=0A			case $i in=0A			1)=0A				echo "0-3,8-11" > $MOUNT/$i/$j/cpuset=
=2Ecpus;;=0A			2)=0A				echo "0-3,8-11"  > $MOUNT/$i/$j/cpuset.cpus;;=0A			=
3)=0A				echo "0-3,8-11" > $MOUNT/$i/$j/cpuset.cpus;;=0A			4)=0A				echo "0=
-3,8-11" > $MOUNT/$i/$j/cpuset.cpus;;=0A			5)=0A				echo "4-7,12-15" > $MOU=
NT/$i/$j/cpuset.cpus;;=0A			esac=0A			done=0A		else=0A			case $i in=0A			1)=
=0A				echo 0 > $MOUNT/$i/cpuset.cpus;;=0A			2)=0A				echo 1 > $MOUNT/$i/cp=
uset.cpus;;=0A			3)=0A				echo "2-3" > $MOUNT/$i/cpuset.cpus;;=0A			4)=0A		=
		echo "4-6" > $MOUNT/$i/cpuset.cpus;;=0A			5)=0A				echo "7-15" > $MOUNT/$=
i/cpuset.cpus;;=0A			esac=0A		fi=0A	done=0A	=0A}=0A=0Aprint_results()=0A{=
=0A	eval gtot=3D$(cat sched_log|grep -i while|sed 's/R//g'|awk '{gtot+=3D$7=
};END{printf "%f", gtot}')=0A	for (( i=3D1; i<=3D5; i++ ))	=0A	do=0A		eval =
temp=3D$(cat sched_log_$i|sed 's/R//g'| awk '{gtot+=3D$7};END{printf "%f",g=
tot}')=0A		eval tavg=3D$(echo "scale=3D4;(($temp / $gtot) * $1)/100 " | bc)=
=0A		eval avg=3D$(echo  "scale=3D4;($temp / $gtot) * 100" | bc)=0A		eval pr=
etty_tavg=3D$( echo "scale=3D4; $tavg * 100"| bc) # F0r pretty format=0A		e=
cho "Bandwidth of Group $i =3D $avg i.e =3D $pretty_tavg% of non-Idle CPU t=
ime $1%"=0A		if [ $SUBGROUP -eq 1 ]=0A		then=0A			jj=3D$(eval echo "\$NR_TA=
SKS$i")=0A			for (( j=3D1; j<=3D$jj; j++ ))=0A			do=0A				eval tmp=3D$(cat =
sched_log_$i-$j|sed 's/R//g'| awk '{gtot+=3D$7};END{printf "%f",gtot}')=0A	=
			eval stavg=3D$(echo "scale=3D4;($tmp / $temp) * 100" | bc)=0A				eval pr=
etty_stavg=3D$(echo "scale=3D4;(($tmp / $temp) * $tavg) * 100" | bc)=0A				=
echo -n "|"=0A				echo -e "...... subgroup $i/$j\t=3D $stavg\ti.e =3D $pret=
ty_stavg% of $pretty_tavg% Groups non-Idle CPU time"=0A			done=0A		fi=0A		e=
cho " "=0A		echo " "=0A	done=0A}=0A=0Acapture_results()=0A{=0A	cat /proc/sc=
hed_debug > sched_log=0A	lev=3D""=0A	for (( i=3D1; i<=3D$LEVELS; i++ ))=0A	=
do=0A		lev=3D"$lev\/level${i}"	=0A	done=0A	pkill -9 vmstat =0A	avg=3D$(cat =
vmstat_log |grep -iv "system"|grep -iv "swpd"|awk ' { if ( NR !=3D 1) {id+=
=3D$15 }}END{print (id/(NR-1))}')=0A=0A	rem=3D$(echo "scale=3D2; 100 - $avg=
" |bc)=0A	echo "Average CPU Idle percentage $avg%"	=0A	echo "Bandwidth shar=
ed with remaining non-Idle $rem%" =0A	for (( i=3D1; i<=3D5; i++ ))=0A	do=0A=
		cat sched_log |grep -i while1|grep -i "$lev\/$i" > sched_log_$i=0A		if [ =
$SUBGROUP -eq 1 ]=0A		then=0A			jj=3D$(eval echo "\$NR_TASKS$i")=0A			for (=
( j=3D1; j<=3D$jj; j++ ))=0A			do=0A				cat sched_log |grep -i while1|grep =
-i "$lev\/$i\/$j" > sched_log_$i-$j=0A			done=0A		fi=0A	done=0A	print_resul=
ts $rem=0A}=0A=0Acreate_hierarchy=0A#pin_tasks=0A#sleep 60=0Aload_tasks=0As=
leep 60=0Aecho "Terminate?"=0Aread y=0Acapture_results=0Aecho -n "*********=
***bounces"=0A#cat /proc/sys/kernel/sched_migrate_bounce=0Acleanup=0Aexit=0A
--vkogqOf2sHV7VnPd--
