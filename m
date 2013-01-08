Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3AHJpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:45:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3AHJpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:45:39 -0500
Message-ID: <1357638325.5678.47.camel@marge.simpson.net>
Subject: Re: kernel BUG at kernel/sched_rt.c:493!
From: Mike Galbraith <bitbucket@online.de>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Date: Tue, 08 Jan 2013 10:45:25 +0100
In-Reply-To: <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
References: <20130105174632.GB19226@u1004.rgmadvisors.com>
	 <20130107175818.GA3411@BohrerMBP.rgmadvisors.com>
	 <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:880nNIHzYpOCY1Ximod9aQNtBTPhorrI80pXYcPoIss
 hDdO25ccmy3OFTDcAc0GClPZkvk4MDhn2j1NAAOd5d5ZQYCHnY
 z07CbiSTPew3jxPLHo6Admrog0Wl3s7ziXwl7RN9qz2KcE4bdJ
 PZlq3C/kPjdPJqIiJjo1iv0iywmucJKMNvn9OHP2nlp8T6e/Z+
 XpmM2+Xap5zeiFj1ipzu5gxf787EPjDSmkAQO3Galc1lLypVOW
 jO1MxQjWb//ryx4zslBFXc9CPZwUAswMxVEGHLfLyInIQHzarB
 v/+LwAvUD12VgjLhM6uliPGf4Wiatozm8Qpo3vXoH8obBYp0Ev
 qhYNJSWKNUsirhrqfxrHjFxIrVd+ed0L/1kuTjf2HJRuDxXyeW
 BADfPyvd0YHSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-07 at 17:02 -0600, Shawn Bohrer wrote: 
> On Mon, Jan 07, 2013 at 11:58:18AM -0600, Shawn Bohrer wrote:
> > On Sat, Jan 05, 2013 at 11:46:32AM -0600, Shawn Bohrer wrote:
> > > I've tried reproducing the issue, but so far I've been unsuccessful
> > > but I believe that is because my RT tasks aren't using enough CPU
> > > cause borrowing from the other runqueues.  Normally our RT tasks use
> > > very little CPU so I'm not entirely sure what conditions caused them
> > > to run into throttling on the day that this happened.
> > 
> > I've managed to reproduce this a couple times now on 3.1.9 I'll give
> > this a try later with a more recent kernel.  Here is what I've done to
> > reproduce the issue.
> > 
> > 
> > # Setup in shell 1
> > root@berbox39:/cgroup/cpuset# mkdir package0
> > root@berbox39:/cgroup/cpuset# echo 0 > package0/cpuset.mems
> > root@berbox39:/cgroup/cpuset# echo 0,2,4,6 > package0/cpuset.cpus
> > root@berbox39:/cgroup/cpuset# cat cpuset.sched_load_balance
> > 1
> > root@berbox39:/cgroup/cpuset# cat package0/cpuset.sched_load_balance
> > 1
> > root@berbox39:/cgroup/cpuset# cat sysdefault/cpuset.sched_load_balance
> > 1
> > root@berbox39:/cgroup/cpuset# echo 1,3,5,7 > sysdefault/cpuset.cpus
> > root@berbox39:/cgroup/cpuset# echo 0 > sysdefault/cpuset.mems
> > root@berbox39:/cgroup/cpuset# echo $$ > package0/tasks
> > 
> > # Setup in shell 2
> > root@berbox39:~# cd /cgroup/cpuset/
> > root@berbox39:/cgroup/cpuset# chrt -f -p 60 $$
> > root@berbox39:/cgroup/cpuset# echo $$ > sysdefault/tasks
> > 
> > # In shell 1
> > root@berbox39:/cgroup/cpuset# chrt -f 1 /root/burn.sh &
> > root@berbox39:/cgroup/cpuset# chrt -f 1 /root/burn.sh &
> > 
> > # In shell 2
> > root@berbox39:/cgroup/cpuset# echo 0 > cpuset.sched_load_balance
> > root@berbox39:/cgroup/cpuset# echo 1 > cpuset.sched_load_balance
> > root@berbox39:/cgroup/cpuset# echo 0 > cpuset.sched_load_balance
> > root@berbox39:/cgroup/cpuset# echo 1 > cpuset.sched_load_balance
> > 
> > I haven't found the exact magic combination but I've been going back
> > and forth adding/killing burn.sh processes and toggling
> > cpuset.sched_load_balance and in a couple of minutes I can usually get
> > the machine to trigger the bug.
> 
> I've also managed to reproduce this on 3.8.0-rc2 so it appears the bug
> is still present in the latest kernel.
> 
> Also just re-reading my instructions above /root/burn.sh is just a
> simple:
> 
> while true; do : ; done
> 
> I've also had to make the kworker threads SCHED_FIFO with a higher
> priority than burn.sh or as expected I can lock up the system due to
> some xfs threads getting starved.
> 
> Let me know if anyone needs any more information, or needs me to try
> anything since it appears I can trigger this fairly easily now.

I hit something very similar.

In my case, I had booted with sched_debug, and a 57600 serial console
connected to my local box via a horribly slow internet link, which led
to it taking 40 seconds to get 2 of 80 cpus down for reboot.  There were
a gaggle of CPUs with pilfered rt_runtime, a matching gaggle of bandits,
no runqueues were throttled, nor were there any with rt_time accrued at
crash time, but as CPU4 tried to go down, it couldn't find its property,
so cleverly fired a thermonuclear pop-flare, lest thieves escape unseen,
precious rt_runtime in hand.

     runqueues 
     0xffff88047f811180      rt_runtime = 888192922   cpu0
     0xffff880c7f811180      rt_runtime = RUNTIME_INF cpu1
     0xffff88087f811180      rt_runtime = RUNTIME_INF cpu2
     0xffff880e7f811180      rt_runtime = 699462573   cpu3
     0xffff88047f851180      rt_runtime = 841094505   cpu4
     0xffff880c7f851180      rt_runtime = 926250000   cpu5
     0xffff88087f851180      rt_runtime = 926250000   cpu6
     0xffff880e7f851180      rt_runtime = 926250000   cpu7
     0xffff88047f891180      rt_runtime = 926250000   cpu8
     0xffff880c7f891180      rt_runtime = 926250000   cpu9
     0xffff88087f891180      rt_runtime = 926250000   cpu10
     0xffff880e7f891180      rt_runtime = 926250000   cpu11
     0xffff88047f8d1180      rt_runtime = 926250000   cpu12
     0xffff880c7f8d1180      rt_runtime = 926250000   cpu13
     0xffff88087f8d1180      rt_runtime = 1000000000  cpu14
     0xffff880e7f8d1180      rt_runtime = 1000000000  cpu15
     0xffff88047f911180      rt_runtime = 1000000000  cpu16
     0xffff880c7f911180      rt_runtime = 1000000000  cpu17
     0xffff88087f911180      rt_runtime = 1000000000  cpu18
     0xffff880e7f911180      rt_runtime = 1000000000  cpu19
     0xffff88047f951180      rt_runtime = 1000000000  cpu20
     0xffff880c7f951180      rt_runtime = 1000000000  cpu21
     0xffff88087f951180      rt_runtime = 1000000000  cpu23
     0xffff880e7f951180      rt_runtime = 1000000000  cpu24
     0xffff88047f991180      rt_runtime = 1000000000  cpu25
     0xffff880c7f991180      rt_runtime = 950000000   cpu26
     0xffff88087f991180      rt_runtime = 1000000000  cpu27
     0xffff880e7f991180      rt_runtime = 950000000   cpu28
     ....
     0xffff88087fcd1180      rt_runtime = 950000000   cpu79

crash> bt
PID: 14735  TASK: ffff880e75e86500  CPU: 4   COMMAND: "reboot"
 #0 [ffff880e74b3d890] machine_kexec at ffffffff8102676e
 #1 [ffff880e74b3d8e0] crash_kexec at ffffffff810a3a3a
 #2 [ffff880e74b3d9b0] oops_end at ffffffff81446238
 #3 [ffff880e74b3d9d0] do_invalid_op at ffffffff810035d4
 #4 [ffff880e74b3da70] invalid_op at ffffffff8144d9bb
    [exception RIP: __disable_runtime+494]
    RIP: ffffffff81045dae  RSP: ffff880e74b3db28  RFLAGS: 00010082
    RAX: 000000000000046a  RBX: ffff880e7fcd1310  RCX: ffffffff81d88a90
    RDX: 000000000000046a  RSI: 0000000000000050  RDI: ffff880e7fcd19b0
    RBP: ffff880e74b3db98   R8: 0000000000000010   R9: ffff88047f423408
    R10: 0000000000000050  R11: ffffffff81250190  R12: 0000000000000050
    R13: fffffffffde9f140  R14: ffff880e7fcd1310  R15: 000000000000122f
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #5 [ffff880e74b3dba0] rq_offline_rt at ffffffff8104b36a
 #6 [ffff880e74b3dbc0] set_rq_offline at ffffffff81043c9e
 #7 [ffff880e74b3dbe0] rq_attach_root at ffffffff8104c130
 #8 [ffff880e74b3dc10] cpu_attach_domain at ffffffff81054f44
 #9 [ffff880e74b3dc80] build_sched_domains at ffffffff81055525
#10 [ffff880e74b3dcd0] partition_sched_domains at ffffffff81055835
#11 [ffff880e74b3dd70] cpuset_cpu_inactive at ffffffff81055a0d
#12 [ffff880e74b3dd80] notifier_call_chain at ffffffff81448907
#13 [ffff880e74b3ddb0] _cpu_down at ffffffff8142b57b
#14 [ffff880e74b3de10] disable_nonboot_cpus at ffffffff8105ba23
#15 [ffff880e74b3de40] kernel_restart at ffffffff81071dde
#16 [ffff880e74b3de50] sys_reboot at ffffffff81071fc3
#17 [ffff880e74b3df80] system_call_fastpath at ffffffff8144ca12
    RIP: 00007fed35778316  RSP: 00007fff23f7e198  RFLAGS: 00010202
    RAX: 00000000000000a9  RBX: ffffffff8144ca12  RCX: 00007fed35771130
    RDX: 0000000001234567  RSI: 0000000028121969  RDI: fffffffffee1dead
    RBP: 0000000000000000   R8: 0000000000020fd0   R9: 000000000060d120
    R10: 00007fff23f7df40  R11: 0000000000000202  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000001  R15: 0000000000000000
    ORIG_RAX: 00000000000000a9  CS: 0033  SS: 002b

