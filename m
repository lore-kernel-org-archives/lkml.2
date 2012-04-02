Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2DBPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:25:58 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38994 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2DBPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:25:57 -0400
Date: Mon, 2 Apr 2012 07:06:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove the context test in rcu_read_unlock_special()
Message-ID: <20120402140634.GH2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F741B98.2070709@cn.fujitsu.com>
 <20120329215613.GX2450@linux.vnet.ibm.com>
 <4F7947EB.5040809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7947EB.5040809@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040215-6148-0000-0000-000004BE0B8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 02:32:11PM +0800, Lai Jiangshan wrote:
> On 03/30/2012 05:56 AM, Paul E. McKenney wrote:
> > On Thu, Mar 29, 2012 at 04:21:44PM +0800, Lai Jiangshan wrote:
> >> Because of commit#26861f and #10f39bb1b2, the context test in
> >> rcu_read_unlock_special() are not needed.
> >>
> >> commit#26861f and #10f39bb1b2 ensure ->rcu_read_unlock_special is zero
> >> after rcu_read_unlock(), which implies:
> >>
> >> if ->rcu_read_unlock_special is non-zero, the out-most RCU C.S. can
> >> be interrupted or can be preempted, such context is safe to
> >> call rcu_read_unlock_special().
> > 
> > In theory, I am very much in favor of this, but in practice we need to
> > put a WARN_ON_ONCE() in the "if" statement to be removed for a few years
> > first.  If there are never any warnings (or, more likely, once such
> > warnings have been fixed for some time), then this patch below would be
> > eminently sensible.
> 
> Add BUG_ON() instead, how about it?
> Thanks,
> Lai

We need a two-step process: (1) Add a WARN_ON() in the existing "if"
statement, and after a year or so of no WARN_ON()s being triggered (2)
eliminate the "if" and in_serving_softirq().

							Thanx, Paul

> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index 22ecea0..22e2ef1 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -571,12 +571,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
>  	if (special & RCU_READ_UNLOCK_NEED_QS)
>  		rcu_preempt_cpu_qs();
> 
> -	/* Hardware IRQ handlers cannot block. */
> -	if (in_irq() || in_serving_softirq()) {
> -		local_irq_restore(flags);
> -		return;
> -	}
> -
>  	/* Clean up if blocked during RCU read-side critical section. */
>  	if (special & RCU_READ_UNLOCK_BLOCKED) {
>  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index c023464..e90593e 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -210,6 +210,7 @@ static void rcu_preempt_note_context_switch(int cpu)
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  	} else if (t->rcu_read_lock_nesting < 0 &&
>  		   t->rcu_read_unlock_special) {
> +		WARN_ON_ONCE(t->rcu_read_lock_nesting != INT_MIN);
> 
>  		/*
>  		 * Complete exit from RCU read-side critical section on
> @@ -239,7 +240,10 @@ static void rcu_preempt_note_context_switch(int cpu)
>   */
>  void __rcu_read_lock(void)
>  {
> -	current->rcu_read_lock_nesting++;
> +	struct task_struct *t = current;
> +
> +	BUG_ON(!t->rcu_read_lock_nesting && t->rcu_read_unlock_special);
> +	t->rcu_read_lock_nesting++;
>  	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
>  }
>  EXPORT_SYMBOL_GPL(__rcu_read_lock);
> @@ -338,12 +342,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
>  		rcu_preempt_qs(smp_processor_id());
>  	}
> 
> -	/* Hardware IRQ handlers cannot block. */
> -	if (in_irq() || in_serving_softirq()) {
> -		local_irq_restore(flags);
> -		return;
> -	}
> -
>  	/* Clean up if blocked during RCU read-side critical section. */
>  	if (special & RCU_READ_UNLOCK_BLOCKED) {
>  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> @@ -439,6 +437,7 @@ void __rcu_read_unlock(void)
>  			rcu_read_unlock_special(t);
>  		barrier();  /* ->rcu_read_unlock_special load before assign */
>  		t->rcu_read_lock_nesting = 0;
> +		BUG_ON(t->rcu_read_unlock_special);
>  	}
>  #ifdef CONFIG_PROVE_LOCKING
>  	{
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 671f959..7074f97 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -318,12 +318,8 @@ static inline void invoke_softirq(void)
>  #else
>  		do_softirq();
>  #endif
> -	} else {
> -		__local_bh_disable((unsigned long)__builtin_return_address(0),
> -				SOFTIRQ_OFFSET);
> +	} else
>  		wakeup_softirqd();
> -		__local_bh_enable(SOFTIRQ_OFFSET);
> -	}
>  }
> 
>  /*
> 

