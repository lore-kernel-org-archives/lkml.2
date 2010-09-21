Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0IUQll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:41:41 -0400
Received: from www.tglx.de ([62.245.132.106]:60166 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab0IUQlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:41:40 -0400
Date: Tue, 21 Sep 2010 17:39:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
In-Reply-To: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.2.00.1009211735540.2416@localhost6.localdomain6>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Heiko Carstens wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> I've seen the following deadlock on cpu hotplug stress test:
> 
> On cpu down the process that triggered offlining of a cpu waits for
> stop_machine() to finish:
> 
> PID: 56033  TASK: e001540           CPU: 2   COMMAND: "cpu_all_off"
>  #0 [37aa7990] schedule at 559194
>  #1 [37aa7a40] schedule_timeout at 559de0
>  #2 [37aa7b18] wait_for_common at 558bfa
>  #3 [37aa7b90] __stop_cpus at 1a876e
>  #4 [37aa7c68] stop_cpus at 1a8a3a
>  #5 [37aa7c98] __stop_machine at 1a8adc
>  #6 [37aa7cf8] _cpu_down at 55007a
>  #7 [37aa7d78] cpu_down at 550280
>  #8 [37aa7d98] store_online at 551d48
>  #9 [37aa7dc0] sysfs_write_file at 2a3fa2
>  #10 [37aa7e18] vfs_write at 229b3c
>  #11 [37aa7e78] sys_write at 229d38
>  #12 [37aa7eb8] sysc_noemu at 1146de
> 
> All cpus actually have been synchronized and cpu 0 got offlined. However,
> the migration thread on cpu 5 got preempted just between preempt_enable()
> and cpu_stop_signal_done() within cpu_stopper_thread():
> 
> PID: 55622  TASK: 31a00a40          CPU: 5   COMMAND: "migration/5"
>  #0 [30f8bc80] schedule at 559194
>  #1 [30f8bd30] preempt_schedule at 559b54
>  #2 [30f8bd50] cpu_stopper_thread at 1a81dc
>  #3 [30f8be28] kthread at 163224
>  #4 [30f8beb8] kernel_thread_starter at 106c1a
> 
> For some reason the scheduler decided to throttle RT tasks on the runqueue
> of cpu 5 (rt_throttled = 1). So as long as rt_throttled == 1 we won't see the
> migration thread coming back to execution.
> The only thing that would unthrottle the runqueue would be the rt_period_timer.
> The timer is indeed scheduled, however in the dump I have it has been expired
> for more than four hours.
> The reason is simply that the timer is pending on the offlined cpu 0 and
> therefore would never fire before it gets migrated to an online cpu. Before
> the cpu hotplug mechanisms (cpu hotplug notifier with state CPU_DEAD) would
> migrate the timer to an online cpu stop_machine() must complete ---> deadlock.
> 
> The fix _seems_ to be simple: just migrate timers after __cpu_disable() has
> been called and use the CPU_DYING state. The subtle difference is of course
> that the migration code now gets executed on the cpu that actually just is
> going to disable itself instead of an arbitrary cpu that stays online.
> 
> This patch moves the migration of pending timers to an earlier time
> (CPU_DYING), so that the deadlock described cannot happen anymore.
> 
> Up to now the hrtimer migration code called __hrtimer_peek_ahead_timers()
> after migrating timers to the _current_ cpu. Now pending timers are moved
> to a remote cpu and calling that function isn't possible anymore.
> To solve that I introduced the function raise_remote_softirq() which gets
> used to raise the HRTIMER_SOFTIRQ on the cpu where the timers have been
> migrated to. Which will lead to execution of hrtimer_peek_ahead_timers()
> as soon as softirq are executed on the remote cpu.
> 
> The proper place for such a generic function should be softirq.c, but this
> is just an RFC and I would like to check if people are ok with the general
> approach.
> Or maybe it's possible to fix this in a better way?

Hmm, shouldnt we simply prevent the throttler to hold off the
migration thread ?

Thanks,

	tglx
