Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab2BIP2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:28:04 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:53987 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2BIP2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:28:01 -0500
Date: Thu, 9 Feb 2012 07:26:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 45/47] rcu: Allow nesting of
 rcu_idle_enter() and rcu_idle_exit()
Message-ID: <20120209152620.GI32560@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328319922-30828-45-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120209040701.GF25473@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209040701.GF25473@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020915-5518-0000-0000-0000021D031C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 05:07:04AM +0100, Frederic Weisbecker wrote:
> On Fri, Feb 03, 2012 at 05:45:20PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Use of RCU in the idle loop is incorrect, quite a few instances of
> > just that have made their way into mainline, primarily event tracing.
> > The problem with RCU read-side critical sections on CPUs that RCU believes
> > to be idle is that RCU is completely ignoring the CPU, along with any
> > attempts and RCU read-side critical sections.
> > 
> > The approaches of eliminating the offending uses and of pushing the
> > definition of idle down beyond the offending uses have both proved
> > impractical.  The new approach is to encapsulate offending uses of RCU
> > with rcu_idle_exit() and rcu_idle_enter(), but this requires nesting
> > for code that is invoked both during idle and and during normal execution.
> > Therefore, this commit modifies rcu_idle_enter() and rcu_idle_exit() to
> > permit nesting.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> > ---
> >  kernel/rcu.h     |   21 ++++++++++++++++++++-
> >  kernel/rcutiny.c |   16 ++++++++++++----
> >  kernel/rcutree.c |   21 ++++++++++++++-------
> >  3 files changed, 46 insertions(+), 12 deletions(-)
> > 
> > diff --git a/kernel/rcu.h b/kernel/rcu.h
> > index 30876f4..8ba99cd 100644
> > --- a/kernel/rcu.h
> > +++ b/kernel/rcu.h
> > @@ -33,8 +33,27 @@
> >   * Process-level increment to ->dynticks_nesting field.  This allows for
> >   * architectures that use half-interrupts and half-exceptions from
> >   * process context.
> > + *
> > + * DYNTICK_TASK_NEST_MASK defines a field of width DYNTICK_TASK_NEST_WIDTH
> > + * that counts the number of process-based reasons why RCU cannot
> > + * consider the corresponding CPU to be idle, and DYNTICK_TASK_NEST_VALUE
> > + * is the value used to increment or decrement this field.
> > + *
> > + * The rest of the bits could in principle be used to count interrupts,
> > + * but this would mean that a negative-one value in the interrupt
> > + * field could incorrectly zero out the DYNTICK_TASK_NEST_MASK field.
> > + * We therefore provide a two-bit guard field defined by DYNTICK_TASK_MASK
> > + * that is set to DYNTICK_TASK_FLAG upon initial exit from idle.
> > + * The DYNTICK_TASK_EXIT_IDLE value is thus the combined value used upon
> > + * initial exit from idle.
> >   */
> > -#define DYNTICK_TASK_NESTING (LLONG_MAX / 2 - 1)
> > +#define DYNTICK_TASK_NEST_WIDTH 7
> > +#define DYNTICK_TASK_NEST_VALUE ((LLONG_MAX >> DYNTICK_TASK_NEST_WIDTH) + 1)
> > +#define DYNTICK_TASK_NEST_MASK  (LLONG_MAX - DYNTICK_TASK_NEST_VALUE + 1)
> > +#define DYNTICK_TASK_FLAG	   ((DYNTICK_TASK_NEST_VALUE / 8) * 2)
> > +#define DYNTICK_TASK_MASK	   ((DYNTICK_TASK_NEST_VALUE / 8) * 3)
> 
> There is one unused bit between DYNTICK_TASK_NEST_MASK and DYNTICK_TASK_MASK, is
> that intentional?

Yep, it makes it easier for me to read hex dumps of the variables.

> Also do you want to allow nesting of that kind?
> 
> 	rcu_idle_enter();
> 		rcu_idle_enter();
> 		rcu_idle_exit();
> 	rcu_idle_exit()

No -- only the inverse where you exit idle multiple times.

> in which case I guess that rcu_irq_enter()/rcu_irq_exit() also need to
> be updated.
> 
> If we have this:
> 
> 	rcu_idle_enter()
> 	rcu_idle_enter()
> 
> 	rcu_irq_enter()
> 	rcu_irq_exit()
> 
> 	rcu_idle_exit()
> 	rcu_idle_exit()
> 
> On rcu_irq_enter(), oldval will never be 0 and we'll miss rcu_idle_exit_common().
> rcu_irq_exit() has a similar problem as it won't enter rcu_idle_enter_common().
> 
> Its check on WARN_ON_ONCE(rdtp->dynticks_nesting < 0) is also wrong because after
> two calls of rcu_idle_enter(), the value of dynticks_nesting is negative : it's
> -DYNTICK_TASK_NEST_VALUE.
> 
> Perhaps this change would allow that. But again that's just in case you need to
> support that kind of nesting.

Interesting.  I don't know of a use case for this -- do you have any?

							Thanx, Paul

> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index eacc10b..0b7d946 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -430,8 +430,8 @@ void rcu_irq_exit(void)
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	oldval = rdtp->dynticks_nesting;
>  	rdtp->dynticks_nesting--;
> -	WARN_ON_ONCE(rdtp->dynticks_nesting < 0);
> -	if (rdtp->dynticks_nesting)
> +	WARN_ON_ONCE(!oldval);
> +	if (rdtp->dynticks_nesting & ~DYNTICK_TASK_NEST_MASK)
>  		trace_rcu_dyntick("--=", oldval, rdtp->dynticks_nesting);
>  	else
>  		rcu_idle_enter_common(rdtp, oldval);
> @@ -525,8 +525,8 @@ void rcu_irq_enter(void)
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	oldval = rdtp->dynticks_nesting;
>  	rdtp->dynticks_nesting++;
> -	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);
> -	if (oldval)
> +	WARN_ON_ONCE(oldval == ~DYNTICK_TASK_NEST_MASK);
> +	if (oldval & ~DYNTICK_TASK_NEST_MASK)
>  		trace_rcu_dyntick("++=", oldval, rdtp->dynticks_nesting);
>  	else
>  		rcu_idle_exit_common(rdtp, oldval);
> 
> 
> 
> > +#define DYNTICK_TASK_EXIT_IDLE	   (DYNTICK_TASK_NEST_VALUE + \
> > +				    DYNTICK_TASK_FLAG)
> >  
> >  /*
> >   * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
> > diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> > index 4eb34fc..c8b0e15 100644
> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -53,7 +53,7 @@ static void __call_rcu(struct rcu_head *head,
> >  
> >  #include "rcutiny_plugin.h"
> >  
> > -static long long rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
> > +static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
> >  
> >  /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
> >  static void rcu_idle_enter_common(long long oldval)
> > @@ -88,7 +88,12 @@ void rcu_idle_enter(void)
> >  
> >  	local_irq_save(flags);
> >  	oldval = rcu_dynticks_nesting;
> > -	rcu_dynticks_nesting = 0;
> > +	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) == 0);
> > +	if ((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) ==
> > +	    DYNTICK_TASK_NEST_VALUE)
> > +		rcu_dynticks_nesting = 0;
> > +	else
> > +		rcu_dynticks_nesting  -= DYNTICK_TASK_NEST_VALUE;
> >  	rcu_idle_enter_common(oldval);
> >  	local_irq_restore(flags);
> >  }
> > @@ -140,8 +145,11 @@ void rcu_idle_exit(void)
> >  
> >  	local_irq_save(flags);
> >  	oldval = rcu_dynticks_nesting;
> > -	WARN_ON_ONCE(oldval != 0);
> > -	rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
> > +	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
> > +	if (rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK)
> > +		rcu_dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
> > +	else
> > +		rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
> >  	rcu_idle_exit_common(oldval);
> >  	local_irq_restore(flags);
> >  }
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index df0e3c1..92b4776 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -198,7 +198,7 @@ void rcu_note_context_switch(int cpu)
> >  EXPORT_SYMBOL_GPL(rcu_note_context_switch);
> >  
> >  DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
> > -	.dynticks_nesting = DYNTICK_TASK_NESTING,
> > +	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
> >  	.dynticks = ATOMIC_INIT(1),
> >  };
> >  
> > @@ -394,7 +394,11 @@ void rcu_idle_enter(void)
> >  	local_irq_save(flags);
> >  	rdtp = &__get_cpu_var(rcu_dynticks);
> >  	oldval = rdtp->dynticks_nesting;
> > -	rdtp->dynticks_nesting = 0;
> > +	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
> > +	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE)
> > +		rdtp->dynticks_nesting = 0;
> > +	else
> > +		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
> >  	rcu_idle_enter_common(rdtp, oldval);
> >  	local_irq_restore(flags);
> >  }
> > @@ -467,7 +471,7 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
> >   * Exit idle mode, in other words, -enter- the mode in which RCU
> >   * read-side critical sections can occur.
> >   *
> > - * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NESTING to
> > + * We crowbar the ->dynticks_nesting field to DYNTICK_TASK_NEST to
> >   * allow for the possibility of usermode upcalls messing up our count
> >   * of interrupt nesting level during the busy period that is just
> >   * now starting.
> > @@ -481,8 +485,11 @@ void rcu_idle_exit(void)
> >  	local_irq_save(flags);
> >  	rdtp = &__get_cpu_var(rcu_dynticks);
> >  	oldval = rdtp->dynticks_nesting;
> > -	WARN_ON_ONCE(oldval != 0);
> > -	rdtp->dynticks_nesting = DYNTICK_TASK_NESTING;
> > +	WARN_ON_ONCE(oldval < 0);
> > +	if (oldval & DYNTICK_TASK_NEST_MASK)
> > +		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
> > +	else
> > +		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
> >  	rcu_idle_exit_common(rdtp, oldval);
> >  	local_irq_restore(flags);
> >  }
> > @@ -2253,7 +2260,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
> >  	rdp->qlen_lazy = 0;
> >  	rdp->qlen = 0;
> >  	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
> > -	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
> > +	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
> >  	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
> >  	rdp->cpu = cpu;
> >  	rdp->rsp = rsp;
> > @@ -2281,7 +2288,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
> >  	rdp->qlen_last_fqs_check = 0;
> >  	rdp->n_force_qs_snap = rsp->n_force_qs;
> >  	rdp->blimit = blimit;
> > -	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_NESTING;
> > +	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
> >  	atomic_set(&rdp->dynticks->dynticks,
> >  		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
> >  	rcu_prepare_for_idle_init(cpu);
> > -- 
> > 1.7.8
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

