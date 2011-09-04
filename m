Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1IDXjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 19:39:01 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46532 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1IDXi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 19:38:56 -0400
Date: Sun, 4 Sep 2011 16:38:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] rcu: Fix early call to rcu_irq_exit()
Message-ID: <20110904233846.GO2411@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
 <1313861452-24783-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313861452-24783-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 07:30:52PM +0200, Frederic Weisbecker wrote:
> On the irq exit path, tick_nohz_stop_sched_tick()
> may raise a softirq, which action leads to the wake up
> path and select_task_rq_fair() that makes use of rcu
> to iterate the domains.
> 
> This is an illegal use of RCU because we may be in dyntick
> idle mode:

The rest of these look good!

							Thanx, Paul

> [  132.978883] ===============================
> [  132.978883] [ INFO: suspicious RCU usage. ]
> [  132.978883] -------------------------------
> [  132.978883] kernel/sched_fair.c:1707 suspicious rcu_dereference_check() usage!
> [  132.978883]
> [  132.978883] other info that might help us debug this:
> [  132.978883]
> [  132.978883]
> [  132.978883] rcu_scheduler_active = 1, debug_locks = 0
> [  132.978883] RCU used illegally from extended quiescent state!
> [  132.978883] 2 locks held by swapper/0:
> [  132.978883]  #0:  (&p->pi_lock){-.-.-.}, at: [<ffffffff8105a729>] try_to_wake_up+0x39/0x2f0
> [  132.978883]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8105556a>] select_task_rq_fair+0x6a/0xec0
> [  132.978883]
> [  132.978883] stack backtrace:
> [  132.978883] Pid: 0, comm: swapper Tainted: G        W   3.0.0+ #178
> [  132.978883] Call Trace:
> [  132.978883]  <IRQ>  [<ffffffff810a01f6>] lockdep_rcu_suspicious+0xe6/0x100
> [  132.978883]  [<ffffffff81055c49>] select_task_rq_fair+0x749/0xec0
> [  132.978883]  [<ffffffff8105556a>] ? select_task_rq_fair+0x6a/0xec0
> [  132.978883]  [<ffffffff812fe494>] ? do_raw_spin_lock+0x54/0x150
> [  132.978883]  [<ffffffff810a1f2d>] ? trace_hardirqs_on+0xd/0x10
> [  132.978883]  [<ffffffff8105a7c3>] try_to_wake_up+0xd3/0x2f0
> [  132.978883]  [<ffffffff81094f98>] ? ktime_get+0x68/0xf0
> [  132.978883]  [<ffffffff8105aa35>] wake_up_process+0x15/0x20
> [  132.978883]  [<ffffffff81069dd5>] raise_softirq_irqoff+0x65/0x110
> [  132.978883]  [<ffffffff8108eb65>] __hrtimer_start_range_ns+0x415/0x5a0
> [  132.978883]  [<ffffffff812fe3ee>] ? do_raw_spin_unlock+0x5e/0xb0
> [  132.978883]  [<ffffffff8108ed08>] hrtimer_start+0x18/0x20
> [  132.978883]  [<ffffffff8109c9c3>] tick_nohz_stop_sched_tick+0x393/0x450
> [  132.978883]  [<ffffffff810694f2>] irq_exit+0xd2/0x100
> [  132.978883]  [<ffffffff81829e96>] do_IRQ+0x66/0xe0
> [  132.978883]  [<ffffffff81820d53>] common_interrupt+0x13/0x13
> [  132.978883]  <EOI>  [<ffffffff8103434b>] ? native_safe_halt+0xb/0x10
> [  132.978883]  [<ffffffff810a1f2d>] ? trace_hardirqs_on+0xd/0x10
> [  132.978883]  [<ffffffff810144ea>] default_idle+0xba/0x370
> [  132.978883]  [<ffffffff810147fe>] amd_e400_idle+0x5e/0x130
> [  132.978883]  [<ffffffff8100a9f6>] cpu_idle+0xb6/0x120
> [  132.978883]  [<ffffffff817f217f>] rest_init+0xef/0x150
> [  132.978883]  [<ffffffff817f20e2>] ? rest_init+0x52/0x150
> [  132.978883]  [<ffffffff81ed9cf3>] start_kernel+0x3da/0x3e5
> [  132.978883]  [<ffffffff81ed9346>] x86_64_start_reservations+0x131/0x135
> [  132.978883]  [<ffffffff81ed944d>] x86_64_start_kernel+0x103/0x112
> 
> Fix this by calling rcu_irq_exit() after tick_nohz_stop_sched_tick().
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/softirq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index fca82c3..d4047b8 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -347,12 +347,12 @@ void irq_exit(void)
>  	if (!in_interrupt() && local_softirq_pending())
>  		invoke_softirq();
> 
> -	rcu_irq_exit();
>  #ifdef CONFIG_NO_HZ
>  	/* Make sure that timer wheel updates are propagated */
>  	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
>  		tick_nohz_stop_sched_tick(0);
>  #endif
> +	rcu_irq_exit();
>  	preempt_enable_no_resched();
>  }
> 
> -- 
> 1.7.5.4
> 
