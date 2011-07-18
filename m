Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1GRPaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:30:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41897 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab1GRPaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:30:08 -0400
Date: Mon, 18 Jul 2011 08:29:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ed Tomlinson <edt@aei.ca>, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110718152938.GC2312@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <201107151748.07109.edt@aei.ca>
 <20110715220447.GJ2327@linux.vnet.ibm.com>
 <201107161542.31755.edt@aei.ca>
 <1310981384.13765.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310981384.13765.40.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:29:44AM +0200, Peter Zijlstra wrote:
> On Sat, 2011-07-16 at 15:42 -0400, Ed Tomlinson wrote:
> > [39066.195274] -> #2 (rcu_node_level_0){..-.-.}:
> > [39066.195274]        [<ffffffff8108b805>] lock_acquire+0x95/0x140
> > [39066.195274]        [<ffffffff815780fb>] _raw_spin_lock+0x3b/0x50
> > [39066.195274]        [<ffffffff810ba7bf>] __rcu_read_unlock+0x19f/0x2d0
> > [39066.195274]        [<ffffffff8103ffc8>] cpuacct_charge+0xc8/0xe0
> > [39066.195274]        [<ffffffff81040ee5>] update_curr+0x1a5/0x210
> > [39066.195274]        [<ffffffff81043f8a>] enqueue_task_fair+0x7a/0x650
> > [39066.195274]        [<ffffffff81035369>] enqueue_task+0x79/0x90
> > [39066.195274]        [<ffffffff810353ad>] activate_task+0x2d/0x40
> > [39066.195274]        [<ffffffff81036921>] ttwu_activate+0x21/0x50
> > [39066.195274]        [<ffffffff810424cc>] T.2447+0x3c/0x60
> > [39066.195274]        [<ffffffff81042534>] sched_ttwu_pending+0x44/0x60
> > [39066.195274]        [<ffffffff8104255e>] scheduler_ipi+0xe/0x10
> > [39066.195274]        [<ffffffff8101e6aa>] smp_reschedule_interrupt+0x2a/0x30 
> 
> To go on top of my other patch
> 
> 
> ---
> Subject: sched: Add irq_{enter,exit}() to scheduler_ipi()
> 
> Ensure scheduler_ipi() calls irq_{enter,exit} when it does some actual
> work. Traditionally we never did any actual work from the resched IPI
> and all magic happened in the return from interrupt path.
> 
> Now that we do do some work, we need to ensure irq_{enter,exit} are
> called so that we don't confuse things.
> 
> This affects things like timekeeping, NO_HZ and RCU, basically
> everything with a hook in irq_enter/exit.
> 
> Explicit examples of things going wrong are:
> 
>   sched_clock_cpu() -- has a callback when leaving NO_HZ state to take
>                     a new reading from GTOD and TSC. Without this
>                     callback, time is stuck in the past.
> 
>   RCU -- needs in_irq() to work in order to avoid some nasty deadlocks

Cool -- avoids the extra overhead in the nothing-special-to-do case,
but gets the needed protection otherwise.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   40 ++++++++++++++++++++++++++++++++++------
>  1 files changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8fb4245..eb9cbe7 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2544,13 +2544,9 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
>  }
> 
>  #ifdef CONFIG_SMP
> -static void sched_ttwu_pending(void)
> +static void sched_ttwu_do_pending(struct task_struct *list)
>  {
>  	struct rq *rq = this_rq();
> -	struct task_struct *list = xchg(&rq->wake_list, NULL);
> -
> -	if (!list)
> -		return;
> 
>  	raw_spin_lock(&rq->lock);
> 
> @@ -2563,9 +2559,41 @@ static void sched_ttwu_pending(void)
>  	raw_spin_unlock(&rq->lock);
>  }
> 
> +static void sched_ttwu_pending(void)
> +{
> +	struct rq *rq = this_rq();
> +	struct task_struct *list = xchg(&rq->wake_list, NULL);
> +
> +	if (!list)
> +		return;
> +
> +	sched_ttwu_do_pending(list);
> +}
> +
>  void scheduler_ipi(void)
>  {
> -	sched_ttwu_pending();
> +	struct rq *rq = this_rq();
> +	struct task_struct *list = xchg(&rq->wake_list, NULL);
> +
> +	if (!list)
> +		return;
> +
> +	/*
> +	 * Not all reschedule IPI handlers call irq_enter/irq_exit, since
> +	 * traditionally all their work was done from the interrupt return
> +	 * path. Now that we actually do some work, we need to make sure
> +	 * we do call them.
> +	 *
> +	 * Some archs already do call them, luckily irq_enter/exit nest
> +	 * properly.
> +	 *
> +	 * Arguably we should visit all archs and update all handlers,
> +	 * however a fair share of IPIs are still resched only so this would
> +	 * somewhat pessimize the simple resched case.
> +	 */
> +	irq_enter();
> +	sched_ttwu_do_pending(list);
> +	irq_exit();
>  }
> 
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
