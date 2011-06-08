Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1FHDJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:09:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1FHDJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jg5wMFzClcgarwOKVTRwvmXbLIhVU9/2LxHu3mqWlcbQxkbbVWK9YSiUsIFPjzkNhV
         1D4kU9SqnyCwrOVUoHQQ==
MIME-Version: 1.0
In-Reply-To: <20110607154542.GA2991@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com> <20110607154542.GA2991@linux.vnet.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 7 Jun 2011 20:09:09 -0700
Message-ID: <BANLkTimQcJi3Rbw=KAwQq=Cmnf9jNNem6w@mail.gmail.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs unpinned
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Sorry for the delayed response, I was out on vacation for the second
half of May until last week -- I've now caught up on email and am
preparing the next posting ]

Thanks for the test-case Kamalesh -- my immediate suspicion is quota
return may not be fine-grained enough (although the numbers provided
are large enough it's possible there's also just a bug).

I have some tools from my own testing I can use to pull this apart,
let me run your work-load and get back to you.

On Tue, Jun 7, 2011 at 8:45 AM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> Hi All,
>
>    In our test environment, while testing the CFS Bandwidth V6 patch set
> on top of 55922c9d1b84. We observed that the CPU's idle time is seen
> between 30% to 40% while running CPU bound test, with the cgroups tasks
> not pinned to the CPU's. Whereas in the inverse case, where the cgroups
> tasks are pinned to the CPU's, the idle time seen is nearly zero.
>
> Test Scenario
> --------------
> - 5 cgroups are created with each groups assigned 2, 2, 4, 8, 16 tasks respectively.
> - Each of the cgroup, has N sub-cgroups created. Where N is the NR_TASKS the cgroup
>  is assigned with. i.e., cgroup1, will create two sub-cgroups under it and assigned
>  one tasks per sub-group.
>                                ------------
>                                | cgroup 1 |
>                                ------------
>                                 /        \
>                                /          \
>                          --------------  --------------
>                          |sub-cgroup 1|  |sub-cgroup 2|
>                          | (task 1)   |  | (task 2)   |
>                          --------------  --------------
>
> - Top cgroup is given unlimited quota (cpu.cfs_quota_us = -1) and period of 500ms
>  (cpu.cfs_period_us = 500000). Whereas the sub-cgroups are given 250ms of quota
>  (cpu.cfs_quota_us = 250000) and period of 500ms. i.e. the top cgroups are given
>  unlimited bandwidth, whereas the sub-group are throttled every 250ms.
>
> - Additional if required the proportional CPU shares can be assigned to cpu.shares
>  as NR_TASKS * 1024. i.e. cgroup1 has 2 tasks * 1024 = 2048 worth cpu.shares
>  for cgroup1. (In the below test results published all cgroups and sub-cgroups
>  are given the equal share of 1024).
>
> - One CPU bound while(1) task is attached to each sub-cgroup.
>
> - sum-exec time for each cgroup/sub-cgroup is captured from /proc/sched_debug after
>  60 seconds and analyzed for the run time of the tasks a.k.a sub-cgroup.
>
> How is the idle CPU time measured ?
> ------------------------------------
> - vmstat stats are logged every 2 seconds, after attaching the last while1 task
>  to 16th sub-cgroup of cgroup 5 till the 60 sec run is over. After the run idle%
>  of a CPU is calculated by summing idle column from the vmstat log and dividing it
>  by number of samples collected, of-course after neglecting the first record
>  from the log.
>
> How are the tasks pinned to the CPU ?
> -------------------------------------
> - cgroup is mounted with cpuset,cpu controller and for every 2 sub-cgroups one
>  physical CPU is allocated. i.e. CPU 1 is allocated between 1/1 and 1/2 (Group 1,
>  sub-cgroup 1 and sub-cgroup 2). Similarly CPUs 7 to 15 are allocated to 15/1 to
>  15/16 (Group 15, subgroup 1 to 16). Note that test machine used to test has
>  16 CPUs.
>
> Result for non-pining case
> ---------------------------
> Only the hierarchy is created as stated above and cpusets are not assigned per cgroup.
>
> Average CPU Idle percentage 34.8% (as explained above in the Idle time measured)
> Bandwidth shared with remaining non-Idle 65.2%
>
> * Note: For the sake of roundoff value the numbers are multiplied by 100.
>
> In the below result for cgroup1 9.2500 corresponds to sum-exec time captured
> from /proc/sched_debug for cgroup 1 tasks (including sub-cgroup 1 and 2).
> Which is in-turn 6% of the non-Idle CPU time (which is derived by 9.2500 * 65.2 / 100 )
>
> Bandwidth of Group 1 = 9.2500 i.e = 6.0300% of non-Idle CPU time 65.2%
> |...... subgroup 1/1    = 48.7800       i.e = 2.9400% of 6.0300% Groups non-Idle CPU time
> |...... subgroup 1/2    = 51.2100       i.e = 3.0800% of 6.0300% Groups non-Idle CPU time
>
>
> Bandwidth of Group 2 = 9.0400 i.e = 5.8900% of non-Idle CPU time 65.2%
> |...... subgroup 2/1    = 51.0200       i.e = 3.0000% of 5.8900% Groups non-Idle CPU time
> |...... subgroup 2/2    = 48.9700       i.e = 2.8800% of 5.8900% Groups non-Idle CPU time
>
>
> Bandwidth of Group 3 = 16.9300 i.e = 11.0300% of non-Idle CPU time 65.2%
> |...... subgroup 3/1    = 26.0300       i.e = 2.8700% of 11.0300% Groups non-Idle CPU time
> |...... subgroup 3/2    = 25.8800       i.e = 2.8500% of 11.0300% Groups non-Idle CPU time
> |...... subgroup 3/3    = 22.7800       i.e = 2.5100% of 11.0300% Groups non-Idle CPU time
> |...... subgroup 3/4    = 25.2900       i.e = 2.7800% of 11.0300% Groups non-Idle CPU time
>
>
> Bandwidth of Group 4 = 27.9300 i.e = 18.2100% of non-Idle CPU time 65.2%
> |...... subgroup 4/1    = 16.6000       i.e = 3.0200% of 18.2100% Groups non-Idle CPU time
> |...... subgroup 4/2    = 8.0000        i.e = 1.4500% of 18.2100% Groups non-Idle CPU time
> |...... subgroup 4/3    = 9.0000        i.e = 1.6300% of 18.2100% Groups non-Idle CPU time
> |...... subgroup 4/4    = 7.9600        i.e = 1.4400% of 18.2100% Groups non-Idle CPU time
> |...... subgroup 4/5    = 12.3500       i.e = 2.2400% of 18.2100% Groups non-Idle CPU time
> |...... subgroup 4/6    = 16.2500       i.e = 2.9500% of 18.2100% Groups non-Idle CPU time
> |...... subgroup 4/7    = 12.6100       i.e = 2.2900% of 18.2100% Groups non-Idle CPU time
> |...... subgroup 4/8    = 17.1900       i.e = 3.1300% of 18.2100% Groups non-Idle CPU time
>
>
> Bandwidth of Group 5 = 36.8300 i.e = 24.0100% of non-Idle CPU time 65.2%
> |...... subgroup 5/1    = 56.6900       i.e = 13.6100%  of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/2    = 8.8600        i.e = 2.1200%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/3    = 5.5100        i.e = 1.3200%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/4    = 4.5700        i.e = 1.0900%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/5    = 7.9500        i.e = 1.9000%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/6    = 2.1600        i.e = .5100%    of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/7    = 2.3400        i.e = .5600%    of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/8    = 2.1500        i.e = .5100%    of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/9    = 9.7200        i.e = 2.3300%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/10   = 5.0600        i.e = 1.2100%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/11   = 4.6900        i.e = 1.1200%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/12   = 8.9700        i.e = 2.1500%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/13   = 8.4600        i.e = 2.0300%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/14   = 11.8400       i.e = 2.8400%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/15   = 6.3400        i.e = 1.5200%   of 24.0100% Groups non-Idle CPU time
> |...... subgroup 5/16   = 5.1500        i.e = 1.2300%   of 24.0100% Groups non-Idle CPU time
>
> Pinned case
> --------------
> CPU hierarchy is created and cpusets are allocated.
>
> Average CPU Idle percentage 0%
> Bandwidth shared with remaining non-Idle 100%
>
> Bandwidth of Group 1 = 6.3400 i.e = 6.3400% of non-Idle CPU time 100%
> |...... subgroup 1/1    = 50.0400       i.e = 3.1700% of 6.3400% Groups non-Idle CPU time
> |...... subgroup 1/2    = 49.9500       i.e = 3.1600% of 6.3400% Groups non-Idle CPU time
>
>
> Bandwidth of Group 2 = 6.3200 i.e = 6.3200% of non-Idle CPU time 100%
> |...... subgroup 2/1    = 50.0400       i.e = 3.1600% of 6.3200% Groups non-Idle CPU time
> |...... subgroup 2/2    = 49.9500       i.e = 3.1500% of 6.3200% Groups non-Idle CPU time
>
>
> Bandwidth of Group 3 = 12.6300 i.e = 12.6300% of non-Idle CPU time 100%
> |...... subgroup 3/1    = 25.0300       i.e = 3.1600% of 12.6300% Groups non-Idle CPU time
> |...... subgroup 3/2    = 25.0100       i.e = 3.1500% of 12.6300% Groups non-Idle CPU time
> |...... subgroup 3/3    = 25.0000       i.e = 3.1500% of 12.6300% Groups non-Idle CPU time
> |...... subgroup 3/4    = 24.9400       i.e = 3.1400% of 12.6300% Groups non-Idle CPU time
>
>
> Bandwidth of Group 4 = 25.1000 i.e = 25.1000% of non-Idle CPU time 100%
> |...... subgroup 4/1    = 12.5400       i.e = 3.1400% of 25.1000% Groups non-Idle CPU time
> |...... subgroup 4/2    = 12.5100       i.e = 3.1400% of 25.1000% Groups non-Idle CPU time
> |...... subgroup 4/3    = 12.5300       i.e = 3.1400% of 25.1000% Groups non-Idle CPU time
> |...... subgroup 4/4    = 12.5000       i.e = 3.1300% of 25.1000% Groups non-Idle CPU time
> |...... subgroup 4/5    = 12.4900       i.e = 3.1300% of 25.1000% Groups non-Idle CPU time
> |...... subgroup 4/6    = 12.4700       i.e = 3.1200% of 25.1000% Groups non-Idle CPU time
> |...... subgroup 4/7    = 12.4700       i.e = 3.1200% of 25.1000% Groups non-Idle CPU time
> |...... subgroup 4/8    = 12.4500       i.e = 3.1200% of 25.1000% Groups non-Idle CPU time
>
>
> Bandwidth of Group 5 = 49.5700 i.e = 49.5700% of non-Idle CPU time 100%
> |...... subgroup 5/1    = 49.8500       i.e = 24.7100% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/2    = 6.2900        i.e = 3.1100% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/3    = 6.2800        i.e = 3.1100% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/4    = 6.2700        i.e = 3.1000% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/5    = 6.2700        i.e = 3.1000% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/6    = 6.2600        i.e = 3.1000% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/7    = 6.2500        i.e = 3.0900% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/8    = 6.2400        i.e = 3.0900% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/9    = 6.2400        i.e = 3.0900% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/10   = 6.2300        i.e = 3.0800% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/11   = 6.2300        i.e = 3.0800% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/12   = 6.2200        i.e = 3.0800% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/13   = 6.2100        i.e = 3.0700% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/14   = 6.2100        i.e = 3.0700% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/15   = 6.2100        i.e = 3.0700% of 49.5700% Groups non-Idle CPU time
> |...... subgroup 5/16   = 6.2100        i.e = 3.0700% of 49.5700% Groups non-Idle CPU time
>
> with equal cpu shares allocated to all the groups/sub-cgroups and CFS bandwidth configured
> to allow 100% CPU utilization. We see the CPU idle time in the un-pinned case.
>
> Benchmark used to reproduce the issue, is attached. Justing executing the script should
> report similar numbers.
>
> #!/bin/bash
>
> NR_TASKS1=2
> NR_TASKS2=2
> NR_TASKS3=4
> NR_TASKS4=8
> NR_TASKS5=16
>
> BANDWIDTH=1
> SUBGROUP=1
> PRO_SHARES=0
> MOUNT=/cgroup/
> LOAD=/root/while1
>
> usage()
> {
>        echo "Usage $0: [-b 0|1] [-s 0|1] [-p 0|1]"
>        echo "-b 1|0 set/unset  Cgroups bandwidth control (default set)"
>        echo "-s Create sub-groups for every task (default creates sub-group)"
>        echo "-p create propotional shares based on cpus"
>        exit
> }
> while getopts ":b:s:p:" arg
> do
>        case $arg in
>        b)
>                BANDWIDTH=$OPTARG
>                shift
>                if [ $BANDWIDTH -gt 1 ] && [ $BANDWIDTH -lt  0 ]
>                then
>                        usage
>                fi
>                ;;
>        s)
>                SUBGROUP=$OPTARG
>                shift
>                if [ $SUBGROUP -gt 1 ] && [ $SUBGROUP -lt 0 ]
>                then
>                        usage
>                fi
>                ;;
>        p)
>                PRO_SHARES=$OPTARG
>                shift
>                if [ $PRO_SHARES -gt 1 ] && [ $PRO_SHARES -lt 0 ]
>                then
>                        usage
>                fi
>                ;;
>
>        *)
>
>        esac
> done
> if [ ! -d $MOUNT ]
> then
>        mkdir -p $MOUNT
> fi
> test()
> {
>        echo -n "[ "
>        if [ $1 -eq 0 ]
>        then
>                echo -ne '\E[42;40mOk'
>        else
>                echo -ne '\E[31;40mFailed'
>                tput sgr0
>                echo " ]"
>                exit
>        fi
>        tput sgr0
>        echo " ]"
> }
> mount_cgrp()
> {
>        echo -n "Mounting root cgroup "
>        mount -t cgroup -ocpu,cpuset,cpuacct none $MOUNT &> /dev/null
>        test $?
> }
>
> umount_cgrp()
> {
>        echo -n "Unmounting root cgroup "
>        cd /root/
>        umount $MOUNT
>        test $?
> }
>
> create_hierarchy()
> {
>        mount_cgrp
>        cpuset_mem=`cat $MOUNT/cpuset.mems`
>        cpuset_cpu=`cat $MOUNT/cpuset.cpus`
>        echo -n "creating groups/sub-groups ..."
>        for (( i=1; i<=5; i++ ))
>        do
>                mkdir $MOUNT/$i
>                echo $cpuset_mem > $MOUNT/$i/cpuset.mems
>                echo $cpuset_cpu > $MOUNT/$i/cpuset.cpus
>                echo -n ".."
>                if [ $SUBGROUP -eq 1 ]
>                then
>                        jj=$(eval echo "\$NR_TASKS$i")
>                        for (( j=1; j<=$jj; j++ ))
>                        do
>                                mkdir -p $MOUNT/$i/$j
>                                echo $cpuset_mem > $MOUNT/$i/$j/cpuset.mems
>                                echo $cpuset_cpu > $MOUNT/$i/$j/cpuset.cpus
>                                echo -n ".."
>                        done
>                fi
>        done
>        echo "."
> }
>
> cleanup()
> {
>        pkill -9 while1 &> /dev/null
>        sleep 10
>        echo -n "Umount groups/sub-groups .."
>        for (( i=1; i<=5; i++ ))
>        do
>                if [ $SUBGROUP -eq 1 ]
>                then
>                        jj=$(eval echo "\$NR_TASKS$i")
>                        for (( j=1; j<=$jj; j++ ))
>                        do
>                                rmdir $MOUNT/$i/$j
>                                echo -n ".."
>                        done
>                fi
>                rmdir $MOUNT/$i
>                echo -n ".."
>        done
>        echo " "
>        umount_cgrp
> }
>
> load_tasks()
> {
>        for (( i=1; i<=5; i++ ))
>        do
>                jj=$(eval echo "\$NR_TASKS$i")
>                shares="1024"
>                if [ $PRO_SHARES -eq 1 ]
>                then
>                        eval shares=$(echo "$jj * 1024" | bc)
>                fi
>                echo $hares > $MOUNT/$i/cpu.shares
>                for (( j=1; j<=$jj; j++ ))
>                do
>                        echo "-1" > $MOUNT/$i/cpu.cfs_quota_us
>                        echo "500000" > $MOUNT/$i/cpu.cfs_period_us
>                        if [ $SUBGROUP -eq 1 ]
>                        then
>
>                                $LOAD &
>                                echo $! > $MOUNT/$i/$j/tasks
>                                echo "1024" > $MOUNT/$i/$j/cpu.shares
>
>                                if [ $BANDWIDTH -eq 1 ]
>                                then
>                                        echo "500000" > $MOUNT/$i/$j/cpu.cfs_period_us
>                                        echo "250000" > $MOUNT/$i/$j/cpu.cfs_quota_us
>                                fi
>                        else
>                                $LOAD &
>                                echo $! > $MOUNT/$i/tasks
>                                echo $shares > $MOUNT/$i/cpu.shares
>
>                                if [ $BANDWIDTH -eq 1 ]
>                                then
>                                        echo "500000" > $MOUNT/$i/cpu.cfs_period_us
>                                        echo "250000" > $MOUNT/$i/cpu.cfs_quota_us
>                                fi
>                        fi
>                done
>        done
>        echo "Captuing idle cpu time with vmstat...."
>        vmstat 2 100 &> vmstat_log &
> }
>
> pin_tasks()
> {
>        cpu=0
>        count=1
>        for (( i=1; i<=5; i++ ))
>        do
>                if [ $SUBGROUP -eq 1 ]
>                then
>                        jj=$(eval echo "\$NR_TASKS$i")
>                        for (( j=1; j<=$jj; j++ ))
>                        do
>                                if [ $count -gt 2 ]
>                                then
>                                        cpu=$((cpu+1))
>                                        count=1
>                                fi
>                                echo $cpu > $MOUNT/$i/$j/cpuset.cpus
>                                count=$((count+1))
>                        done
>                else
>                        case $i in
>                        1)
>                                echo 0 > $MOUNT/$i/cpuset.cpus;;
>                        2)
>                                echo 1 > $MOUNT/$i/cpuset.cpus;;
>                        3)
>                                echo "2-3" > $MOUNT/$i/cpuset.cpus;;
>                        4)
>                                echo "4-6" > $MOUNT/$i/cpuset.cpus;;
>                        5)
>                                echo "7-15" > $MOUNT/$i/cpuset.cpus;;
>                        esac
>                fi
>        done
>
> }
>
> print_results()
> {
>        eval gtot=$(cat sched_log|grep -i while|sed 's/R//g'|awk '{gtot+=$7};END{printf "%f", gtot}')
>        for (( i=1; i<=5; i++ ))
>        do
>                eval temp=$(cat sched_log_$i|sed 's/R//g'| awk '{gtot+=$7};END{printf "%f",gtot}')
>                eval tavg=$(echo "scale=4;(($temp / $gtot) * $1)/100 " | bc)
>                eval avg=$(echo  "scale=4;($temp / $gtot) * 100" | bc)
>                eval pretty_tavg=$( echo "scale=4; $tavg * 100"| bc) # F0r pretty format
>                echo "Bandwidth of Group $i = $avg i.e = $pretty_tavg% of non-Idle CPU time $1%"
>                if [ $SUBGROUP -eq 1 ]
>                then
>                        jj=$(eval echo "\$NR_TASKS$i")
>                        for (( j=1; j<=$jj; j++ ))
>                        do
>                                eval tmp=$(cat sched_log_$i-$j|sed 's/R//g'| awk '{gtot+=$7};END{printf "%f",gtot}')
>                                eval stavg=$(echo "scale=4;($tmp / $temp) * 100" | bc)
>                                eval pretty_stavg=$(echo "scale=4;(($tmp / $temp) * $tavg) * 100" | bc)
>                                echo -n "|"
>                                echo -e "...... subgroup $i/$j\t= $stavg\ti.e = $pretty_stavg% of $pretty_tavg% Groups non-Idle CPU time"
>                        done
>                fi
>                echo " "
>                echo " "
>        done
> }
> capture_results()
> {
>        cat /proc/sched_debug > sched_log
>        pkill -9 vmstat -c
>        avg=$(cat vmstat_log |grep -iv "system"|grep -iv "swpd"|awk ' { if ( NR != 1) {id+=$15 }}END{print (id/NR)}')
>
>        rem=$(echo "scale=2; 100 - $avg" |bc)
>        echo "Average CPU Idle percentage $avg%"
>        echo "Bandwidth shared with remaining non-Idle $rem%"
>        for (( i=1; i<=5; i++ ))
>        do
>                cat sched_log |grep -i while1|grep -i " \/$i" > sched_log_$i
>                if [ $SUBGROUP -eq 1 ]
>                then
>                        jj=$(eval echo "\$NR_TASKS$i")
>                        for (( j=1; j<=$jj; j++ ))
>                        do
>                                cat sched_log |grep -i while1|grep -i " \/$i\/$j" > sched_log_$i-$j
>                        done
>                fi
>        done
>        print_results $rem
> }
> create_hierarchy
> pin_tasks
>
> load_tasks
> sleep 60
> capture_results
> cleanup
> exit
>
> Thanks,
> Kamalesh.
>
