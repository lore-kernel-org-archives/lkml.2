Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2C1Lnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:43:37 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39086 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2C1Lnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:43:35 -0400
Date: Wed, 28 Mar 2012 13:43:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
Message-ID: <20120328114323.GB17189@somewhere.redhat.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 05:02:34PM +0200, Gilad Ben-Yossef wrote:
> On Wed, Mar 21, 2012 at 3:58 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Hi all,
> >
> > A summary of what this is about can be found here:
> >  https://lkml.org/lkml/2011/8/15/245
> >
> > There are still a lot of things to handle. Especially about
> > what is done by scheduler_tick() but we also need to:
> >
> > - completely handle cputime accounting (need to find every "reader"
> > of cputime and flush cputimes for all of them).
> > -handle  perf
> > - handle irqtime finegrained accounting
> > - handle ilb load balancing
> > - etc...
> >
> 
> I gave the new version a spin (x86 8 way VM) and it looks cool.
> 
> I did get the following warning once, but couldn't recreate it:
> 
> [   31.812741] ------------[ cut here ]------------
> [   31.812741] WARNING: at
> /home/giladb/Workspace/linux/kernel/time/tick-sched.c:706
> tick_nohz_account_ticks+0x7c/0x90()
> [   31.812741] Hardware name: Bochs
> [   31.812741] Modules linked in:
> [   31.812741] Pid: 1006, comm: sh Not tainted 3.3.0-rc7+ #167
> [   31.812741] Call Trace:
> [   31.812741]  [<c102a3ad>] warn_slowpath_common+0x6d/0xa0
> [   31.812741]  [<c106be0c>] ? tick_nohz_account_ticks+0x7c/0x90
> [   31.812741]  [<c106be0c>] ? tick_nohz_account_ticks+0x7c/0x90
> [   31.812741]  [<c102a3fd>] warn_slowpath_null+0x1d/0x20
> [   31.812741]  [<c106be0c>] tick_nohz_account_ticks+0x7c/0x90
> [   31.812741]  [<c106be5f>] tick_nohz_flush_current_times+0x3f/0x80
> [   31.812741]  [<c106bf8d>] tick_nohz_restart_adaptive+0xd/0x30
> [   31.812741]  [<c106c02e>] tick_nohz_check_adaptive+0x3e/0x50
> [   31.812741]  [<c1018180>] smp_cpuset_update_nohz_interrupt+0x20/0x30
> [   31.812741]  [<c1639c6a>] cpuset_update_nohz_interrupt+0x2a/0x30
> [   31.812741]  [<c16395fd>] ? _raw_spin_unlock_irq+0xd/0x30
> [   31.812741]  [<c10575c6>] finish_task_switch+0x46/0xa0
> [   31.812741]  [<c1638558>] __schedule+0x398/0x910
> [   31.812741]  [<c10ef2f1>] ? deactivate_slab+0x611/0x730
> [   31.812741]  [<c1120777>] ? __find_get_block+0x97/0x1a0
> [   31.812741]  [<c1221214>] ? cpumask_next_and+0x24/0xa0
> [   31.812741]  [<c10558cb>] ? get_parent_ip+0xb/0x40
> [   31.812741]  [<c1638b50>] schedule+0x30/0x50
> [   31.812741]  [<c16379b5>] schedule_hrtimeout_range_clock+0xf5/0x110
> [   31.812741]  [<c10558cb>] ? get_parent_ip+0xb/0x40
> [   31.812741]  [<c10586db>] ? sub_preempt_count+0x7b/0xb0
> [   31.812741]  [<c1639633>] ? _raw_spin_unlock_irqrestore+0x13/0x40
> [   31.812741]  [<c1054140>] ? __wake_up+0x40/0x50
> [   31.812741]  [<c1294d1f>] ? put_ldisc+0x3f/0xa0
> [   31.812741]  [<c16379e2>] schedule_hrtimeout_range+0x12/0x20
> [   31.812741]  [<c1107969>] poll_schedule_timeout+0x39/0x60
> [   31.812741]  [<c1108020>] do_sys_poll+0x400/0x490
> [   31.812741]  [<c1054d15>] ? cpuacct_charge+0x65/0x70
> [   31.812741]  [<c1107a20>] ? poll_freewait+0x70/0x70
> [   31.812741]  [<c1107af0>] ? __pollwait+0xd0/0xd0
> [   31.812741]  [<c1107af0>] ? __pollwait+0xd0/0xd0
> [   31.812741]  [<c10094a3>] ? native_sched_clock+0x33/0xe0
> [   31.812741]  [<c105a0e2>] ? sched_clock_local+0xb2/0x190
> [   31.812741]  [<c1054d15>] ? cpuacct_charge+0x65/0x70
> [   31.812741]  [<c105b376>] ? update_curr+0x1a6/0x2a0
> [   31.812741]  [<c105a2f9>] ? sched_clock_cpu+0x139/0x190
> [   31.812741]  [<c105a0e2>] ? sched_clock_local+0xb2/0x190
> [   31.812741]  [<c104dd43>] ? hrtimer_forward+0x163/0x1b0
> [   31.812741]  [<c10644e2>] ? ktime_get+0x62/0x100
> [   31.812741]  [<c1018b56>] ? lapic_next_event+0x16/0x20
> [   31.812741]  [<c1069df2>] ? clockevents_program_event+0xc2/0x170
> [   31.812741]  [<c106b514>] ? tick_program_event+0x24/0x30
> [   31.812741]  [<c104cd1d>] ? hrtimer_interrupt+0x1ad/0x2e0
> [   31.812741]  [<c1095128>] ? rcu_pending+0x58/0x70
> [   31.812741]  [<c1030a3d>] ? irq_exit+0x6d/0x80
> [   31.812741]  [<c1019363>] ? smp_apic_timer_interrupt+0x53/0x90
> [   31.812741]  [<c11e0128>] ? avc_has_perm_noaudit+0xc8/0x360
> [   31.812741]  [<c163a3b6>] ? apic_timer_interrupt+0x2a/0x30
> [   31.812741]  [<c128f31e>] ? tty_ioctl+0x47e/0xa30
> [   31.812741]  [<c11e0d66>] ? inode_has_perm+0x36/0x50
> [   31.812741]  [<c11e13e8>] ? file_has_perm+0xa8/0xb0
> [   31.812741]  [<c128eea0>] ? tty_check_change+0xe0/0xe0
> [   31.812741]  [<c1106763>] ? do_vfs_ioctl+0x83/0x570
> [   31.812741]  [<c11e4e46>] ? selinux_file_ioctl+0x56/0x110
> [   31.812741]  [<c1108224>] sys_poll+0x54/0xb0
> [   31.812741]  [<c1639b29>] syscall_call+0x7/0xb
> [   31.812741] ---[ end trace 1d7d659b4aead681 ]---

Ah interesting. I think I see how that happened: we flushed the
time on tick_nohz_pre_schedule() and set SAVED_JIFFIES_NONE.
Then we received a nohz IPI before we could restart the tick
from tick_nohz_post_schedule(). With ts->tick_stopped we except
that ts->saved_jiffies_whence != SAVED_JIFFIES_NONE but that's
wrong.

I'll fix that.

> 
> With the two patches I'll attach to the next replies to this message,
> I've been able to get a task running
> on an isolated CPU with 0 timer interrupts.
> 
> In my case, I also had to disable the clocksource watchdog, but only
> because TSC is not stable on my VM.
> This is really not a nohz/cpuset problem.

Yeah that's a particular issue on its own. I luckily don't have it
on my main testbox.

> There is one source of interference to cpu isolation this causes,
> which is the cputime flush IPI. Every time you
> run a command in the shell you get 3 - 4 IPIs sent to the nohz cpuset
> to flush the cputimes so that thread group
> times get computed correctly. That's not very nice :-)
> 
> I've tried disabling the IPI send, just to see how it goes and as far
> as I've been able to tell you get bare metal like
> environment for a 100% cpu bound code with no interrupts. Of course.
> ps/top then show 0% cpu utilization for
> that task since without the IPI the times it spends on the CPU is not
> registered... that is a small price to pay
> in my eyes for bare metal performance on Linux, but what do I know? :-)

Yeah I'm sure we can reduce the amount of IPIs for the nohz thing. I've just
set a big one IPI executing on every tickless CPU for cases like cputime.
And may be too much IPIs sent for the scheduler and RCU. We can certainly
optimize everything. I'm not yet on the optimization stage but rather still
in the correctness one unfortunately :)

Thanks!

> 
> Overall, way cool. Please keep it up !
> 
> GIlad
> 
> -- 
> Gilad Ben-Yossef
> Chief Coffee Drinker
> gilad@benyossef.com
> Israel Cell: +972-52-8260388
> US Cell: +1-973-8260388
> http://benyossef.com
> 
> "If you take a class in large-scale robotics, can you end up in a
> situation where the homework eats your dog?"
>  -- Jean-Baptiste Queru
