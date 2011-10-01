Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1JARHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 13:07:25 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32770 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab1JARHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 13:07:22 -0400
Date: Sat, 1 Oct 2011 10:07:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111001170714.GA17789@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110928123116.GP18553@somewhere>
 <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
 <20111001122442.GA3391@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001122442.GA3391@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11100117-8974-0000-0000-000000908DA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 02:24:45PM +0200, Frederic Weisbecker wrote:
> On Fri, Sep 30, 2011 at 12:24:38PM -0700, Paul E. McKenney wrote:
> > And here is a first cut, probably totally broken, but a start.
> > 
> > With this change, I am wondering about tick_nohz_stop_sched_tick()'s
> > invocation of rcu_idle_enter() -- this now needs to be called regardless
> > of whether or not tick_nohz_stop_sched_tick() actually stops the tick.
> > Except that if tick_nohz_stop_sched_tick() is invoked with inidle==0,
> > it looks like we should -not- call rcu_idle_enter().
> 
> Because of the new check in rcu_check_callbacks()? Yeah.
> 
> If you think it's fine to call rcu_enter_nohz() unconditionally
> everytime we enter the idle loop then yeah. I just don't know
> the overhead it adds, as it adds an unconditional tiny piece of
> code before we can finally save the power.
> 
> Either entering idle involves extended quiescent state as in this
> patch, or you separate both and then rcu_enter_nohz() is only
> called when the tick is stopped.
> 
> If you choose to merge both, you indeed need to call rcu_idle_enter()
> and rcu_idle_exit() whether the tick is stopped or not.
> 
> > I eventually just left the rcu_idle_enter() calls in their current
> > places due to paranoia about messing up and ending up with unbalanced
> > rcu_idle_enter() and rcu_idle_exit() calls.  Any thoughts on how to
> > make this work better?
> 
> Yeah something like this (untested):
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d5097c4..ad3ecad 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -273,9 +273,12 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	 * updated. Thus, it must not be called in the event we are called from
>  	 * irq_exit() with the prior state different than idle.
>  	 */
> -	if (!inidle && !ts->inidle)
> +	if (inidle)
> +		rcu_idle_enter();
> +	else if (!ts->inidle)
>  		goto end;
> 
> +
>  	/*
>  	 * Set ts->inidle unconditionally. Even if the system did not
>  	 * switch to NOHZ mode the cpu frequency governers rely on the
> @@ -409,7 +412,6 @@ void tick_nohz_stop_sched_tick(int inidle)
>  			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
>  			ts->tick_stopped = 1;
>  			ts->idle_jiffies = last_jiffies;
> -			rcu_enter_nohz();
>  		}
> 
>  		ts->idle_sleeps++;
> @@ -505,6 +507,9 @@ void tick_nohz_restart_sched_tick(void)
>  	ktime_t now;
> 
>  	local_irq_disable();
> +
> +	rcu_idle_exit();
> +
>  	if (ts->idle_active || (ts->inidle && ts->tick_stopped))
>  		now = ktime_get();
> 
> @@ -519,8 +524,6 @@ void tick_nohz_restart_sched_tick(void)
> 
>  	ts->inidle = 0;
> 
> -	rcu_exit_nohz();
> -
>  	/* Update jiffies first */
>  	select_nohz_load_balancer(0);
>  	tick_do_update_jiffies64(now);
> 
> 
> 
> 
> More things about your patch below:
> 
> > --- a/kernel/rcutiny.c
> > +++ b/kernel/rcutiny.c
> > @@ -54,31 +54,47 @@ static void __call_rcu(struct rcu_head *head,
> >  
> >  #include "rcutiny_plugin.h"
> >  
> > -#ifdef CONFIG_NO_HZ
> > -
> >  static long rcu_dynticks_nesting = 1;
> >  
> >  /*
> > - * Enter dynticks-idle mode, which is an extended quiescent state
> > - * if we have fully entered that mode (i.e., if the new value of
> > - * dynticks_nesting is zero).
> > + * Enter idle, which is an extended quiescent state if we have fully
> > + * entered that mode (i.e., if the new value of dynticks_nesting is zero).
> >   */
> > -void rcu_enter_nohz(void)
> > +void rcu_idle_enter(void)
> >  {
> >  	if (--rcu_dynticks_nesting == 0)
> >  		rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
> >  }
> >  
> >  /*
> > - * Exit dynticks-idle mode, so that we are no longer in an extended
> > - * quiescent state.
> > + * Exit idle, so that we are no longer in an extended quiescent state.
> >   */
> > -void rcu_exit_nohz(void)
> > +void rcu_idle_exit(void)
> >  {
> >  	rcu_dynticks_nesting++;
> >  }
> >  
> > -#endif /* #ifdef CONFIG_NO_HZ */
> > +#ifdef CONFIG_PROVE_RCU
> > +
> > +/*
> > + * Test whether the current CPU is idle.
> > + */
> 
> Is idle from an RCU point of view yeah.

Good point -- I now say "Test whether RCU thinks that the current CPU is idle."

> > +int rcu_is_cpu_idle(void)
> > +{
> > +	return !rcu_dynticks_nesting;
> > +}
> > +
> > +#endif /* #ifdef CONFIG_PROVE_RCU */
> > +
> > +/*
> > + * Test whether the current CPU was interrupted from idle.  Nested
> > + * interrupts don't count, we must be running at the first interrupt
> > + * level.
> > + */
> > +int rcu_is_cpu_rrupt_from_idle(void)
> > +{
> > +	return rcu_dynticks_nesting <= 0;
> > +}
> >  
> >  /*
> >   * Helper function for rcu_sched_qs() and rcu_bh_qs().
> > @@ -131,10 +147,7 @@ void rcu_bh_qs(int cpu)
> >   */
> >  void rcu_check_callbacks(int cpu, int user)
> >  {
> > -	if (user ||
> > -	    (idle_cpu(cpu) &&
> > -	     !in_softirq() &&
> > -	     hardirq_count() <= (1 << HARDIRQ_SHIFT)))
> > +	if (user || rcu_is_cpu_rrupt_from_idle())
> >  		rcu_sched_qs(cpu);
> 
> It wasn't obvious to me in the first shot. This might need a comment
> that tells rcu_check_callbacks() is called from an interrupt
> and thus need to handle that first level in the check.

OK, I added "This function must be called from hardirq context".

> Other than that, looks good overall.

Keeping fingers firmly crossed for the testing...

							Thanx, Paul

