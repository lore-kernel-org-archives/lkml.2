Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1LBJho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:37:44 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33539 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1LBJhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:37:42 -0500
MIME-Version: 1.0
Date: Fri, 2 Dec 2011 10:37:41 +0100
Message-ID: <CAMJ=MEe+kC9LsCQcS4sKidpCQXSm5+hV_8rM7CvE2m+_-j+PgA@mail.gmail.com>
Subject: SMP scheduling issue on P4040.
From: Ronny Meeus <ronny.meeus@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm running on a Freescale 4040 (Quad-core processor in SMP mode, all
4 cores enabled, Preemption model: Preemptible Kernel (Low-Latency
Desktop) ).
This is a part of the init log:

klogd started: BusyBox v1.17.4 (2011-12-01 08:38:25 CET)
[    0.000000] Using P4080 DS machine description
[    0.000000] Memory CAM mapping: 256/256/256 Mb, residual: 1248Mb
[    0.000000] Linux version 2.6.36.4 (meeusr@devws108) (gcc version
4.4.3 (crosstool-NG 1.12.1 - buildroot 2011.08-hgc1ffcd8944fa) ) #3
SMP PREEMPT Thu Dec 1 11:34:27 CET 2011

This is not a vanilla kernel, it contains a number of fsl patches to
support the P4040 processor.

I create a simple script that contains and end-less loop:

while true; do
    true;
done

I start this script on the second core (core 1) in FIFO scheduling mode:
chrt -f 20 taskset 2 /tmp/endlessloop

After this I login 2 times over SSH.
The first session I put on 1 specific core (core 0 for example) using.
taskset -p 1 $$
This is to guarantee that this shell is not getting blocked.

In the second ssh shell I run a small script to produce a process list
(similar to top). I think the command I execute here is not relevant.
The observation is that this command is very slow and sometimes even blocks.
In the first ssh session (locked to core 0), I can investigate the
system's state.
What I see is that the sp script is scheduled onto the core 2 as well
(which is also running the endless loop script) while there are 3
other cores that are running IDLE.
Since the priority of the endlessloop script is higher, the sp script
takes very long to complete. Sometimes is even never finishes. The
dump of the sched_stat file can be found below.

So in my opinion the problem is that the sp process gets scheduled on
an fully loaded core while there are other cores running IDLE and it
is not migrated lateron to one of the free cores.
Can this behaviour be explained, solved since it is making my system
very unstable.
Any help would be appreciated.


# cat /proc/sched_debug
Sched Debug Version: v0.09, 2.6.36.4 #3
now at 5906593.058839 msecs
  .jiffies                                 : 5606594
  .sysctl_sched_latency                    : 18.000000
  .sysctl_sched_min_granularity            : 2.250000
  .sysctl_sched_wakeup_granularity         : 3.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 15471
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 4959422
  .nr_load_updates               : 2792881
  .nr_uninterruptible            : 0
  .next_balance                  : 5.606846
  .curr->pid                     : 24519
  .clock                         : 5906652.704320
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 896
  .cpu_load[2]                   : 592
  .cpu_load[3]                   : 338
  .cpu_load[4]                   : 181

cfs_rq[0]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 47064.456651
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 8.331776
  .rt_runtime                    : 1000.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat 24519     47064.456651         2   120
0               0               0.000000               0.000000
       0.000000

cpu#1
  .nr_running                    : 5
  .load                          : 4096
  .nr_switches                   : 50876
  .nr_load_updates               : 2154308
  .nr_uninterruptible            : 0
  .next_balance                  : 5.606709
  .curr->pid                     : 11033
  .clock                         : 5906652.688864
  .cpu_load[0]                   : 4096
  .cpu_load[1]                   : 4096
  .cpu_load[2]                   : 4096
  .cpu_load[3]                   : 4096
  .cpu_load[4]                   : 4096

cfs_rq[1]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 24664.954247
  .min_vruntime                  : 24673.860327
  .max_vruntime                  : 24677.459624
  .spread                        : 12.505377
  .spread0                       : -22390.596324
  .nr_running                    : 4
  .load                          : 4096
  .nr_spread_over                : 0

rt_rq[1]:
  .rt_nr_running                 : 1
  .rt_throttled                  : 0
  .rt_time                       : 594.753888
  .rt_runtime                    : 1000.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     kworker/1:1  1098     24664.954247       625   120
0               0               0.000000               0.000000
       0.000000
R             sh 11033         0.000000      2071    79
0               0               0.000000               0.000000
       0.000000
         S50isam 19776     24673.860327         1   120
0               0               0.000000               0.000000
       0.000000
         S50isam 19781     24673.860327         1   120
0               0               0.000000               0.000000
       0.000000
              sp 24022     24677.459624         0   120
0               0               0.000000               0.000000
       0.000000

cpu#2
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 788386
  .nr_load_updates               : 536225
  .nr_uninterruptible            : 0
  .next_balance                  : 5.606598
  .curr->pid                     : 0
  .clock                         : 5906652.709344
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 546
  .cpu_load[2]                   : 373
  .cpu_load[3]                   : 308
  .cpu_load[4]                   : 274

cfs_rq[2]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 31683.223801
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -15381.232850
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

rt_rq[2]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 850.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#3
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 104649
  .nr_load_updates               : 65015
  .nr_uninterruptible            : 0
  .next_balance                  : 5.606598
  .curr->pid                     : 0
  .clock                         : 5906050.733024
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0

cfs_rq[3]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 26724.786292
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -20339.670359
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

rt_rq[3]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

#
#



Regards,
Ronny
