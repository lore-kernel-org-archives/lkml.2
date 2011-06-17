Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab1FQXTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 19:19:10 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54241 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab1FQXTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 19:19:06 -0400
Date: Fri, 17 Jun 2011 16:19:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 1/4] rcu: Detect uses of rcu read side in extended
 quiescent states
Message-ID: <20110617231902.GM2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307663247-5397-1-git-send-email-fweisbec@gmail.com>
 <1307663247-5397-2-git-send-email-fweisbec@gmail.com>
 <20110610002350.GO2285@linux.vnet.ibm.com>
 <20110610005041.GI25771@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610005041.GI25771@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 02:50:43AM +0200, Frederic Weisbecker wrote:
> On Thu, Jun 09, 2011 at 05:23:50PM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 10, 2011 at 01:47:24AM +0200, Frederic Weisbecker wrote:
> > > Detect uses of rcu that are not supposed to happen when we
> > > are in an extended quiescent state.
> > > 
> > > This can happen for example if we use rcu between the time we
> > > stop the tick and the time we restart it. Or inside an irq that
> > > didn't use rcu_irq_enter,exit() or other possible kind of rcu API
> > > misuse.
> > > 
> > > v2: Rebase against latest rcu changes, handle tiny RCU as well
> > 
> > Good idea on checking for RCU read-side critical sections happening
> > in dyntick-idle periods!
> > 
> > But wouldn't it be better to put the checks in rcu_read_lock() and
> > friends?  The problem I see with putting them in rcu_dereference_check()
> > is that someone can legitimately do something like the following
> > while in dyntick-idle mode:
> > 
> > 	spin_lock(&mylock);
> > 	/* do a bunch of stuff */
> > 	p = rcu_dereference_check(myrcuptr, lockdep_is_held(&mylock));
> > 
> > The logic below would complain about this usage, despite the fact
> > that it is perfectly safe because the update-side lock is held.
> > 
> > Make sense, or am I missing something?
> > 
> > 						Thanx, Paul
> 
> I'm an idiot. I put my check in rcu_dereference_check() on purpose because
> it's always called from places that check one of the rcu locks are held,
> but I forgot that's also used for custom conditions with the _check()
> things.
> 
> That said, putting the check in rcu_read_lock() and alike  would only work
> with rcu_read_lock() itself. Few users of rcu_read_lock_sched() actually
> call it explicitely but rely on irq disabled or preempt disabled. And I can't put the
> checks there as it's fine to disabled irqs in dyntick idle.
> 
> What about the below? (untested yet)
> 
> And I would print the state of dynticks-idle mode in the final lockdep warning.

Printing the dynticks-idle mode would be quite good!

However, it is possible to have an RCU read-side critical section that does
not have an rcu_dereference() or an rcu_read_lock_held().  So I do believe
that we really do need rcu_read_lock() and friends to do this checking.

That might seem to leave open the possibility of a stray rcu_dereference()
being executed from dyntick-idle mode, but the existing PROVE_RCU
checking will catch that, right?

So I believe that the simplest approach with the best coverage is to
put the checks into RCU's read-side critical-section-entry primitives.

Make sense, or am I confused?

							Thanx, Paul

> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 6cad1f3..b9e68ae 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -278,7 +278,7 @@ static inline int rcu_read_lock_held(void)
>  {
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
> -	return lock_is_held(&rcu_lock_map);
> +	return lock_is_held(&rcu_lock_map) && !rcu_check_extended_qs();
>  }
> 
>  /*
> @@ -310,13 +310,13 @@ static inline int rcu_read_lock_sched_held(void)
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
>  	if (debug_locks)
> -		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map) && !rcu_check_extended_qs();
>  	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
>  }
>  #else /* #ifdef CONFIG_PREEMPT */
>  static inline int rcu_read_lock_sched_held(void)
>  {
> -	return 1;
> +	return !rcu_check_extended_qs();
>  }
>  #endif /* #else #ifdef CONFIG_PREEMPT */
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index a088c90..20d6e7228 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -88,7 +88,7 @@ int rcu_read_lock_bh_held(void)
>  {
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
> -	return in_softirq() || irqs_disabled();
> +	return !rcu_check_extended_qs() && (in_softirq() || irqs_disabled());
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
> 
