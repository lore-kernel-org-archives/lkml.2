Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1FJAX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:23:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58689 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab1FJAX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:23:58 -0400
Date: Thu, 9 Jun 2011 17:23:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 1/4] rcu: Detect uses of rcu read side in extended
 quiescent states
Message-ID: <20110610002350.GO2285@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
 <1307663247-5397-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307663247-5397-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:47:24AM +0200, Frederic Weisbecker wrote:
> Detect uses of rcu that are not supposed to happen when we
> are in an extended quiescent state.
> 
> This can happen for example if we use rcu between the time we
> stop the tick and the time we restart it. Or inside an irq that
> didn't use rcu_irq_enter,exit() or other possible kind of rcu API
> misuse.
> 
> v2: Rebase against latest rcu changes, handle tiny RCU as well

Good idea on checking for RCU read-side critical sections happening
in dyntick-idle periods!

But wouldn't it be better to put the checks in rcu_read_lock() and
friends?  The problem I see with putting them in rcu_dereference_check()
is that someone can legitimately do something like the following
while in dyntick-idle mode:

	spin_lock(&mylock);
	/* do a bunch of stuff */
	p = rcu_dereference_check(myrcuptr, lockdep_is_held(&mylock));

The logic below would complain about this usage, despite the fact
that it is perfectly safe because the update-side lock is held.

Make sense, or am I missing something?

						Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Milton Miller <miltonm@bga.com>
> ---
>  include/linux/rcupdate.h |    9 +++++++++
>  kernel/rcutiny.c         |   13 +++++++++++++
>  kernel/rcutree.c         |   14 ++++++++++++++
>  3 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 9db50df..6cad1f3 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -388,6 +388,12 @@ extern int rcu_my_thread_group_empty(void);
> 
>  #endif /* #else #ifdef CONFIG_PROVE_RCU */
> 
> +#if defined(CONFIG_PROVE_RCU) && defined(CONFIG_NO_HZ)
> +extern bool rcu_check_extended_qs(void);
> +#else
> +static inline bool rcu_check_extended_qs(void) { return false; }
> +#endif
> +
>  /*
>   * Helper functions for rcu_dereference_check(), rcu_dereference_protected()
>   * and rcu_assign_pointer().  Some of these could be folded into their
> @@ -415,6 +421,9 @@ extern int rcu_my_thread_group_empty(void);
>  		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
>  		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
>  				      " usage"); \
> +		rcu_lockdep_assert(!rcu_check_extended_qs(), \
> +				   "use of rcu_dereference_check() in an extended" \
> +				   " quiescent state");	\
>  		rcu_dereference_sparse(p, space); \
>  		smp_read_barrier_depends(); \
>  		((typeof(*p) __force __kernel *)(_________p1)); \
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 775d69a..44a2a15 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -76,6 +76,19 @@ void rcu_exit_nohz(void)
>  	rcu_dynticks_nesting++;
>  }
> 
> +
> +#ifdef CONFIG_PROVE_RCU
> +
> +bool rcu_check_extended_qs(void)
> +{
> +	if (!rcu_dynticks_nesting)
> +		return true;
> +
> +	return false;
> +}
> +
> +#endif
> +
>  #endif /* #ifdef CONFIG_NO_HZ */
> 
>  /*
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 305dfae..8211527 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -432,6 +432,20 @@ void rcu_irq_exit(void)
>  	rcu_enter_nohz();
>  }
> 
> +#ifdef CONFIG_PROVE_RCU
> +
> +bool rcu_check_extended_qs(void)
> +{
> +	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> +
> +	if (atomic_read(&rdtp->dynticks) & 0x1)
> +		return false;
> +
> +	return true;
> +}
> +
> +#endif /* CONFIG_PROVE_RCU */
> +
>  #ifdef CONFIG_SMP
> 
>  /*
> -- 
> 1.7.5.4
> 
