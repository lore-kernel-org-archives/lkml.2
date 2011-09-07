Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1IGQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:02:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44855 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1IGQCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:02:23 -0400
Date: Wed, 7 Sep 2011 07:22:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/4] nohz: Split extended quiescent state handling from
 nohz switch
Message-ID: <20110907142233.GA11570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
 <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
 <20110904233643.GN2411@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904233643.GN2411@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 04:36:43PM -0700, Paul E. McKenney wrote:
> On Sat, Aug 20, 2011 at 07:30:49PM +0200, Frederic Weisbecker wrote:
> > It is assumed that rcu won't be used once we switch to tickless
> > mode and until we restart the tick. However this is not always
> > true, as in x86-64 where we dereference the idle notifiers after
> > the tick is stopped.
> > 
> > To prepare for fixing this, split the tickless mode switching and
> > RCU extended quiescent state logics.
> > Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
> > a new pair of APIs tick_nohz_enter/exit_idle() that keep the
> > old behaviour by handling both the nohz mode and RCU extended
> > quiescent states, then convert every archs to use these.
> > 
> > Archs that want to switch to RCU extended QS to some custom points
> > can do it later by changing the parameter in tick_nohz_enter,exit_idle()
> > to false and call rcu_enter,exit() separately.
> 
> This approach looks quite good to me!  A few comments below.

But I get RCU stall warnings when running it on powerpc on top of
the patch set at:

	https://lkml.org/lkml/2011/9/7/64

At first glance, it appears that CPUs are entering dyntick-idle
mode without RCU being informed.  Any thoughts on diagnostics?

							Thanx, Paul

> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> > Cc: Mike Frysinger <vapier@gentoo.org>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > ---
> 
> [ . . . ]
> 
> > diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
> > index 39a2baa..b30ddf1 100644
> > --- a/arch/powerpc/kernel/idle.c
> > +++ b/arch/powerpc/kernel/idle.c
> > @@ -56,7 +56,7 @@ void cpu_idle(void)
> > 
> >  	set_thread_flag(TIF_POLLING_NRFLAG);
> >  	while (1) {
> > -		tick_nohz_stop_sched_tick(1);
> > +		tick_nohz_enter_idle(true);
> 
> This needs to pass false, as some variants of powerpc use event tracing
> (which in turn uses RCU) just before returning to the hypervisor.
> 
> >  		while (!need_resched() && !cpu_should_die()) {
> >  			ppc64_runlatch_off();
> > 
> > @@ -93,7 +93,7 @@ void cpu_idle(void)
> > 
> >  		HMT_medium();
> >  		ppc64_runlatch_on();
> > -		tick_nohz_restart_sched_tick();
> > +		tick_nohz_exit_idle(true);
> 
> As does this, as some variants of powerpc use event tracing just after
> the hypervisor returns control to the OS.
> 
> >  		preempt_enable_no_resched();
> >  		if (cpu_should_die())
> >  			cpu_die();
> > diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
> > index c25a081..aa2be7d 100644
> > --- a/arch/powerpc/platforms/iseries/setup.c
> > +++ b/arch/powerpc/platforms/iseries/setup.c
> > @@ -562,7 +562,7 @@ static void yield_shared_processor(void)
> >  static void iseries_shared_idle(void)
> >  {
> >  	while (1) {
> > -		tick_nohz_stop_sched_tick(1);
> > +		tick_nohz_enter_idle(true);
> 
> But I don't know enough about iseries to know whether or not this works.
> 
> >  		while (!need_resched() && !hvlpevent_is_pending()) {
> >  			local_irq_disable();
> >  			ppc64_runlatch_off();
> > @@ -576,7 +576,7 @@ static void iseries_shared_idle(void)
> >  		}
> > 
> >  		ppc64_runlatch_on();
> > -		tick_nohz_restart_sched_tick();
> > +		tick_nohz_exit_idle(true);
> > 
> >  		if (hvlpevent_is_pending())
> >  			process_iSeries_events();
> > @@ -592,7 +592,7 @@ static void iseries_dedicated_idle(void)
> >  	set_thread_flag(TIF_POLLING_NRFLAG);
> > 
> >  	while (1) {
> > -		tick_nohz_stop_sched_tick(1);
> > +		tick_nohz_enter_idle(true);
> >  		if (!need_resched()) {
> >  			while (!need_resched()) {
> >  				ppc64_runlatch_off();
> > @@ -609,7 +609,7 @@ static void iseries_dedicated_idle(void)
> >  		}
> > 
> >  		ppc64_runlatch_on();
> > -		tick_nohz_restart_sched_tick();
> > +		tick_nohz_exit_idle(true);
> >  		preempt_enable_no_resched();
> >  		schedule();
> >  		preempt_disable();
> 
> [ . . . ]
> 
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index eb98e55..609bb20 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -253,12 +253,13 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
> >   * Called either from the idle loop or from irq_exit() when an idle period was
> >   * just interrupted by an interrupt which did not cause a reschedule.
> >   */
> > -void tick_nohz_stop_sched_tick(int inidle)
> > +bool tick_nohz_stop_sched_tick(int inidle)
> >  {
> >  	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
> >  	struct tick_sched *ts;
> >  	ktime_t last_update, expires, now;
> >  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
> > +	int stopped = false;
> >  	u64 time_delta;
> >  	int cpu;
> > 
> > @@ -405,7 +406,7 @@ void tick_nohz_stop_sched_tick(int inidle)
> >  			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
> >  			ts->tick_stopped = 1;
> >  			ts->idle_jiffies = last_jiffies;
> > -			rcu_enter_nohz();
> > +			stopped = true;
> >  		}
> > 
> >  		ts->idle_sleeps++;
> > @@ -445,6 +446,24 @@ out:
> >  	ts->sleep_length = ktime_sub(dev->next_event, now);
> >  end:
> >  	local_irq_restore(flags);
> > +
> > +	return stopped;
> > +}
> > +
> > +
> > +/**
> > + * tick_nohz_enter_idle - stop the tick from the idle task
> > + * @rcu_ext_qs: enter rcu dynticks idle mode
> > + *
> > + * When an arch doesn't make any use of rcu read side critical section
> > + * between tick_nohz_enter_idle() and tick_nohz_exit_idle() it can set
> > + * rcu_ext_qs to 1. Otherwise it needs to call rcu_enter_nohz() itself
> > + * later before the CPU goes to sleep.
> 
> How about something like this?
> 
> + * When an arch doesn't make any use of rcu read side critical section
> + * between tick_nohz_enter_idle() and the time the CPU is put to sleep,
> + * it can set rcu_ext_qs to true. Otherwise it needs set rcu_ext_qs to
> + * false, and then to call rcu_enter_nohz() itself later, but before the
> + * CPU goes to sleep and after its last use of RCU.
> 
> > + */
> > +void tick_nohz_enter_idle(bool rcu_ext_qs)
> > +{
> > +	if (tick_nohz_stop_sched_tick(1) && rcu_ext_qs)
> > +		rcu_enter_nohz();
> >  }
> > 
> >  /**
> > @@ -486,11 +505,12 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
> >  }
> > 
> >  /**
> > - * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
> > + * tick_nohz_exit_idle - restart the idle tick from the idle task
> > + * @rcu_ext_qs: exit rcu dynticks idle mode
> >   *
> >   * Restart the idle tick when the CPU is woken up from idle
> 
> How about something like the following?
> 
> + * When an arch doesn't make any use of rcu read side critical section
> + * between the time the CPU wakes up and tick_nohz_exit_idle(), it can set
> + * rcu_ext_qs to true. Otherwise it needs set rcu_ext_qs to false, and it
> + * must also have called rcu_enter_nohz() itself earlier, after the CPU
> + * was awakened, but before its first use of RCU.
> 
> >   */
> > -void tick_nohz_restart_sched_tick(void)
> > +void tick_nohz_exit_idle(bool rcu_ext_qs)
> >  {
> >  	int cpu = smp_processor_id();
> >  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> > @@ -514,7 +534,8 @@ void tick_nohz_restart_sched_tick(void)
> > 
> >  	ts->inidle = 0;
> > 
> > -	rcu_exit_nohz();
> > +	if (rcu_ext_qs)
> > +		rcu_exit_nohz();
> > 
> >  	/* Update jiffies first */
> >  	select_nohz_load_balancer(0);
> > -- 
> > 1.7.5.4
> > 
