Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab1IORzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:55:53 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37041 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040Ab1IORzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:55:51 -0400
Date: Thu, 15 Sep 2011 23:25:38 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
Message-ID: <20110915175537.GA17701@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1315906788.575.3.camel@twins>
 <20110913112852.GE7254@linux.vnet.ibm.com>
 <1315922848.5977.11.camel@twins>
 <20110913162119.GA3045@linux.vnet.ibm.com>
 <1315931775.5977.29.camel@twins>
 <20110913175425.GB3062@linux.vnet.ibm.com>
 <1315937995.4226.9.camel@twins>
 <20110913182841.GO11100@linux.vnet.ibm.com>
 <1315938646.4226.12.camel@twins>
 <20110913183502.GP11100@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110913183502.GP11100@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11091517-2674-0000-0000-0000006BF9BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-14 00:05:02]:

> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 20:30:46]:
> 
> > On Tue, 2011-09-13 at 23:58 +0530, Srivatsa Vaddagiri wrote:
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 20:19:55]:
> > > 
> > > > On Tue, 2011-09-13 at 23:24 +0530, Srivatsa Vaddagiri wrote:
> > > > > We saw considerably high migration count on latest tip compared to
> > > > > previous kernels. Kamalesh, can you please post the migration count
> > > > > data? 
> > > > 
> > > > Hrmm, yes this looks horrid.. even without cgroup crap, something's funny.
> > > 
> > > Yes ..we could visualize that very much in top o/p .. A task's cpu would keep 
> > > changing *every* screen refresh (refreshed every 0.5 sec that too!).
> > > 
> > > We didn't see that with older kernels ..Kamalesh is planning to do a
> > > git bisect and see which commit lead to this "mad" hopping ..
> > 
> > Awesome, thanks! Btw, what is 'older'? 3.0?
> 
> We went back all the way upto 2.6.32! I think 2.6.38 and 2.6.39 were
> pretty stable ..I don't have the migration count data with me readily. I
> will let Kamalesh post that info soon.

Test Setup :
-----------
Machine is 2 socket Quad Core Intel (x5570) box. The lb.sh
script was run in a loop to execute 5 times after the box
was bought up with the kernel.  

lb.sh script spawns 2x number of CPU hogs, where x is
number of CPUs on the system. The script collects the
se.nr_migration before/after 60 seconds sleep and subtracts
the after_se.nr_migration - before_se.nr_migrations for 
all the spawned hogs.
----------------+-------+-------+-------+-------+-------+
Kernel		| Run 1	| Run 2	| Run 3	| Run 4	| Run 5	|
----------------+-------+-------+-------+-------+-------+
2.6.33		| 9604	| 101	| 66	| 2543	| 3488	|
----------------+-------+-------+-------+-------+-------+
2.6.34		| 28469	| 1514	| 1602	| 185	| 139	|	
----------------+-------+-------+-------+-------+-------+
2.6.35		| 1052	| 12	| 4	| 11	| 6	|
----------------+-------+-------+-------+-------+-------+
2.6.36		| 1253	| 53	| 78	| 76	| 50	|
----------------+-------+-------+-------+-------+-------+
2.6.37		| 262	| 36	| 48	| 61	| 43	|
----------------+-------+-------+-------+-------+-------+
2.6.38		| 1551	| 48	| 62	| 47	| 50	|
----------------+-------+-------+-------+-------+-------+
2.6.39		| 3784	| 457	| 722	| 3209	| 1037	|
----------------+-------+-------+-------+-------+-------+
3.0		| 933	| 608	| 658	| 1424	| 1415	|
----------------+-------+-------+-------+-------+-------+
3.1.0-rc4-tip	|	|	|	|	|	|
(e467f18f945)	| 1672	| 1643	| 1316	| 1577	| 61	|
----------------+-------+-------+-------+-------+-------+

lb.sh
------
#!/bin/bash

rm -rf test*
rm -rf t*

ITERATIONS=60			# No of Iterations to capture the details
NUM_CPUS=$(cat /proc/cpuinfo |grep -i proces|wc -l)

NUM_HOGS=$((NUM_CPUS * 2))	# No of hogs threads to invoke

echo "System has $NUM_CPUS cpus..... Spawing $NUM_HOGS cpu hogs ... for $ITERATIONS seconds.."
if [ ! -e while1.c ]
then
	cat >> while1.c << EOF
	int
	main (int argc, char **argv)
	{
		while(1);
		return (0);
	}
EOF
fi

for i in $(seq 1 $NUM_HOGS)
do
	gcc -o while$i while1.c
	if [ $? -ne 0 ]
	then
		echo "Looks like gcc is not present ... aborting"
		exit
	fi
done

for i in $(seq 1 $NUM_HOGS)
do
	./while$i &
	pids[$i]=$!
	pids_old[$i]=`cat /proc/$!/sched |grep -i nr_migr|grep -iv cold|cut -d ":" -f2|sed 's/  //g'`
done

sleep $ITERATIONS

j=1
old_nr_migrations=0
new_nr_migrations=0
echo  -e  "       \t New \t Old"
for i in $(seq 1 $NUM_HOGS)
do
	a=`echo ${pids[i]}`	
	new=`cat /proc/$a/sched |grep -i nr_migr|grep -iv cold|cut -d ":" -f2|sed 's/  //g'`
	old=`echo ${pids_old[i]}`
	old_nr_migrations=$((old_nr_migrations + old))
	c=$(($new - $old))
	new_nr_migrations=$((new_nr_migrations + c))
	echo -e "while$i\t[$new]\t[$old]\t"
done
echo "*******************************************"
echo -e "      $new_nr_migrations\t$old_nr_migrations"
echo "*******************************************"
pkill -9 while

exit

