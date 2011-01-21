Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1AUXGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:06:14 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1AUXGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:06:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=htyhhMZsYNp4YFbucy88OCW498vFtvrQkKvU8qbd8U9dUYnn+fb/Y1P3A0L20KN27p
         /0264u7tqtCR9LXiXvfc1IeMHvjxUm+bAdtQWyzH+esgT3/Lfis6eez58uTsxOiLZdy2
         mO9i+MQrZaf0xrEWBDBP8Jl/Nl2sqPy3qilGY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101212232210.2971@localhost6.localdomain6>
References: <1295632350-10215-1-git-send-email-vernux@us.ibm.com>
	<alpine.LFD.2.00.1101212232210.2971@localhost6.localdomain6>
Date: Fri, 21 Jan 2011 15:06:12 -0800
X-Google-Sender-Auth: KGLyyY5rPuNNm7frTeAEbu0E8uE
Message-ID: <AANLkTinG5RmVERMKWFaJRNki+1NGbLLWudc2jtw=igPV@mail.gmail.com>
Subject: Re: [PATCH] Wait to remove active timer when rescheduling hrtimer
From: Vernon Mauery <vernux@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 1:32 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>
> On Fri, 21 Jan 2011, Vernon Mauery wrote:
>
>> In the current hrtimer implementation, when explicitly
>> removing a timer, the hrtimer_cancel function waits
>> until the timer is not currently running before actually
>> calling remove_hrtimer.  But in the __hrtimer_start_range_ns
>> function (called by hrtimer_start, among others), it
>> calls remove_hrtimer without checking to see if the
>> timer is currently running.  This doesn't seem to cause
>> much trouble in the vanilla kernel, but in the -RT
>> kernel, this causes a silent hang when exercising the
>> sch_htb module on a 10GbE interface.
>>
>> Signed-off-by: Vernon Mauery <vernux@us.ibm.com>
>> ---
>>  kernel/hrtimer.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
>> index 0c8d7c0..c7e8ba0 100644
>> --- a/kernel/hrtimer.c
>> +++ b/kernel/hrtimer.c
>> @@ -935,6 +935,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
>>       base = lock_hrtimer_base(timer, &flags);
>>
>>       /* Remove an active timer from the queue: */
>> +     while (hrtimer_callback_running(timer)) {
>> +             unlock_hrtimer_base(timer, &flags);
>> +             hrtimer_wait_for_timer(timer);
>> +             base = lock_hrtimer_base(timer, &flags);
>> +     }
>>       ret = remove_hrtimer(timer, base);
>>
>>       /* Switch the timer base, if necessary: */
>
> Hmm, why does it hang ?

It hangs when I set up QoS on a 10GbE interface and run traffic over
it.  Here is what I do:
#!/bin/bash

if [ -z "$1" ]; then
        ETH=eth2
else
        ETH="$1"
fi
IP=`ip addr show $ETH | grep 'inet\>' | sed 's/.*inet \([^/]*\)\/.*/\1/'`
IP=`echo $IP | sed 's/\([^.]*\)\.\([^.]*\)\.\([^.]*\)\.\([^.]*\)/\1.\2.\3.95/'`

SPEED=`ethtool $ETH | grep Speed | sed 's/[^0-9]*\([0-9]*\).*/\1/'`
case $SPEED in
   10000) ZEROS=00 ;;
    1000) ZEROS=0 ;;
 default) ZEROS='' ;;
esac

tc qdisc del dev $ETH root >&/dev/null || :
[ "$2" == "stop" ] && exit 0
set -x
tc qdisc add dev $ETH root handle 1: htb default 30 r2q 600$ZEROS
tc class add dev $ETH parent 1: classid 1:1 htb rate 30${ZEROS}mbit
tc class add dev $ETH parent 1:1 classid 1:10 htb rate 5${ZEROS}mbit prio 1
tc class add dev $ETH parent 1:1 classid 1:20 htb rate 5${ZEROS}mbit prio 2
tc class add dev $ETH parent 1:1 classid 1:30 htb rate 8${ZEROS}mbit
set +x

echo "netperf -l 2000 -H 10.1.1.94 -t UDP_STREAM -- -m 65505"
----------------------8< snip 8<-------------------------------

After running the script, I run a netperf command similar to the one
that the script prints, that runs traffic over the interface that we
just set up QoS on.  Within 10-15 seconds, the machine goes silent.
(this is on a 2.6.33.7-rt29 kernel)

My guess would be that without this patch, it is possible to have a
timer currently in the tree, not delete it and then schedule it again.
 Not on this machine or on this kernel, I saw a similar problem
(caused by the same thing: using sch_htb on -rt kernel), but instead
of a silent hang, it gave me an oops that looked like this:

Unable to handle kernel NULL pointer dereference at 0000000000000010
 RIP: [<ffffffff8113b38c>] rb_erase+0x1f3/0x2b1
PGD 14e150067 PUD 142d34067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 2
Modules linked in: sch_htb pktgen nfs nfsd lockd nfs_acl auth_rpcgss exportfs
ipmi_devintf ipmi_si ipmi_msghandler ibm_rtl ipv6 autofs4 i2c_dev i2c_core hidp
rfcomm l2cap bluetooth sunrpc dm_mirror dm_multipath scsi_dh dm_mod video
output sbs sbshc battery ac parport_pc lp parport sg bnx2 button netxen_nic
serio_raw amd64_edac edac_core pcspkr shpchp mptsas mptscsih mptbase
scsi_transport_sas sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 38, comm: sirq-hrtimer/2 Not tainted 2.6.24.7-139.el5rt #1
RIP: 0010:[<ffffffff8113b38c>]  [<ffffffff8113b38c>] rb_erase+0x1f3/0x2b1
RSP: 0018:ffff81014f16fe50  EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff81014640bac8 RCX: ffff810001085780
RDX: 0000000000000000 RSI: ffff8100010076a8 RDI: 0000000000000000
RBP: ffff81014f16fe60 R08: ffff81033f15dac8 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8100010076a8
R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000080
FS:  00007ff9960016e0(0000) GS:ffff81014fc09cc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 000000014e188000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sirq-hrtimer/2 (pid: 38, threadinfo ffff81014f16e000, task
ffff81014f16c300)
Stack:  ffff81013a5e67d0 ffff810001007698 ffff81014f16fe90 ffffffff81054dfc
 ffffffff81227401 ffff81013a5e67d0 ffff810001085640 0000000000000002
 ffff81014f16fec0 ffffffff81055cbb 0000000000000002 ffffffff815005e8
Call Trace:
 [<ffffffff81054dfc>] __remove_hrtimer+0x6e/0x7b
 [<ffffffff81227401>] ? qdisc_watchdog+0x0/0x23
 [<ffffffff81055cbb>] run_hrtimer_softirq+0x7a/0x14e
 [<ffffffff81043d26>] ksoftirqd+0x16a/0x26f
 [<ffffffff81043bbc>] ? ksoftirqd+0x0/0x26f
 [<ffffffff81043bbc>] ? ksoftirqd+0x0/0x26f
 [<ffffffff8105261c>] kthread+0x49/0x79
 [<ffffffff8100d088>] child_rip+0xa/0x12
 [<ffffffff810525d3>] ? kthread+0x0/0x79
 [<ffffffff8100d07e>] ? child_rip+0x0/0x12


My most common experience is to just experience a silent hang, which
allows me to do very little in the way of debugging -- unless I catch
it before it goes completely silent, not even sysrq works.  I have
managed to crash the machine on occasion, but the crash kernel never
seems to get very far before it dies off too... Very odd behavior.  I
tried to capture a sysrq+T, but it only gave me the names of the
processes, not the backtraces, and then the per CPU info.  I didn't
see anything that stuck out in the per-CPU info, but right after the
dump, the machine went completely silent again.

Sample from sysrq+T:

sshd          S ffff880417e65ea8     0  3621   3204 0x00000080

Call Trace:
bash          S ffff880417dd0200     0  3636   3621 0x00000080

Call Trace:
sshd          S 0000000000000000     0  3637   3204 0x00000080

Call Trace:
bash          S ffff880417ddc440     0  3662   3637 0x00000080

Call Trace:
top           S ffff88002838af48     0  3686   3662 0x00000080

Call Trace:
netperf       R  running task        0  3708   3636 0x00000080

Call Trace:
Sched Debug Version: v0.09, 2.6.33.7-rt29.35.el5rt #1
now at 134835.593881 msecs
  .jiffies                                 : 4294787328
  .sysctl_sched_latency                    : 20.000000
  .sysctl_sched_min_granularity            : 4.000000
  .sysctl_sched_wakeup_granularity         : 4.000000
  .sysctl_sched_child_runs_first           : 0.000000
  .sysctl_sched_features                   : 7917179
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2833.945 MHz
  .nr_running                    : 1
  .load                          : 0
  .nr_switches                   : 1030470
  .nr_load_updates               : 120033
  .nr_uninterruptible            : 141
  .next_balance                  : 4294.787429
  .curr->pid                     : 3708
  .clock                         : 122477.541494
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 4
  .cpu_load[2]                   : 56
  .cpu_load[3]                   : 122
  .cpu_load[4]                   : 168
  .rt.rt_nr_running              : 1
  .rt.rt_nr_uninterruptible      : 26920
  .rto_schedule                  : 534494
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 1070624
  .sched_goidle                  : 279923
  .avg_idle                      : 93170
  .ttwu_count                    : 640746
  .ttwu_local                    : 613469
  .bkl_count                     : 299

cfs_rq[0]:
  .exec_clock                    : 4267.411040
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 11634.164614
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 12978

rt_rq[0]:
  .rt_nr_running                 : 1
  .rt_throttled                  : 0
  .rt_time                       : 7.163839
  .rt_runtime                    : 850.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R        netperf  3708         0.000000    206988     9
0.000000      3237.342882      2155.844073



Any ideas on this?  The patch I sent fixes the problem.  The idea came
from a proposed patch a long time ago that just added a hrtimer_cancel
call just before the hrtimer_start call in the sch_api.c watchdog
code.  I figured if the explicit cancel before the start fixed the
problem, there was something that the cancel did that the start alone
didn't.  What I found was that the cancel waits if the timer is
currently running, while start just brute-force cancels the timer.

--Vernon
