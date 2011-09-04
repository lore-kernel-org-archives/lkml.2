Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1IDVBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 17:01:44 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42817 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab1IDVBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 17:01:38 -0400
Date: Sun, 4 Sep 2011 14:01:30 -0700
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
Message-ID: <20110904210130.GL2411@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
 <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 07:30:49PM +0200, Frederic Weisbecker wrote:
> It is assumed that rcu won't be used once we switch to tickless
> mode and until we restart the tick. However this is not always
> true, as in x86-64 where we dereference the idle notifiers after
> the tick is stopped.
> 
> To prepare for fixing this, split the tickless mode switching and
> RCU extended quiescent state logics.
> Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
> a new pair of APIs tick_nohz_enter/exit_idle() that keep the
> old behaviour by handling both the nohz mode and RCU extended
> quiescent states, then convert every archs to use these.
> 
> Archs that want to switch to RCU extended QS to some custom points
> can do it later by changing the parameter in tick_nohz_enter,exit_idle()
> to false and call rcu_enter,exit() separately.

Hello, Frederic,

Some of my testing indicates that it is necessary to push
tick_nohz_enter_idle() and tick_nohz_exit_idle() further down in the
powerpc case due to tracing that happens in functions called from
ppc_md.power_save().  My current guess is that for the pSeries flavor
of powerpc, these must be called from __trace_hcall_entry() and
__trace_hcall_exit(), probably controlled by a powerpc-specific per-CPU
variable.

The following functions likely need help.

	cbe_power_save()
	cpm_idle()
	e500_idle()
	idle_doze()
	idle_spin()
	ppc44x_idle()
	ppc6xx_idle()
	ps3_power_save()
	pseries_dedicated_idle_sleep()
	pseries_shared_idle_sleep()

I am continuing testing.  In the meantime, other thoughts?

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/arm/kernel/process.c              |    4 ++--
>  arch/avr32/kernel/process.c            |    4 ++--
>  arch/blackfin/kernel/process.c         |    4 ++--
>  arch/microblaze/kernel/process.c       |    4 ++--
>  arch/mips/kernel/process.c             |    4 ++--
>  arch/powerpc/kernel/idle.c             |    4 ++--
>  arch/powerpc/platforms/iseries/setup.c |    8 ++++----
>  arch/s390/kernel/process.c             |    4 ++--
>  arch/sh/kernel/idle.c                  |    2 +-
>  arch/sparc/kernel/process_64.c         |    4 ++--
>  arch/tile/kernel/process.c             |    4 ++--
>  arch/um/kernel/process.c               |    4 ++--
>  arch/unicore32/kernel/process.c        |    4 ++--
>  arch/x86/kernel/process_32.c           |    4 ++--
>  arch/x86/kernel/process_64.c           |    4 ++--
>  include/linux/tick.h                   |    9 +++++----
>  kernel/time/tick-sched.c               |   31 ++++++++++++++++++++++++++-----
>  17 files changed, 62 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 5e1e541..4d2e33e 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -182,7 +182,7 @@ void cpu_idle(void)
> 
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		leds_event(led_idle_start);
>  		while (!need_resched()) {
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -208,7 +208,7 @@ void cpu_idle(void)
>  			}
>  		}
>  		leds_event(led_idle_end);
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
> index ef5a2a0..a8fd60b 100644
> --- a/arch/avr32/kernel/process.c
> +++ b/arch/avr32/kernel/process.c
> @@ -34,10 +34,10 @@ void cpu_idle(void)
>  {
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched())
>  			cpu_idle_sleep();
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
> index 6a660fa..e032471 100644
> --- a/arch/blackfin/kernel/process.c
> +++ b/arch/blackfin/kernel/process.c
> @@ -88,10 +88,10 @@ void cpu_idle(void)
>  #endif
>  		if (!idle)
>  			idle = default_idle;
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched())
>  			idle();
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
> index 968648a..7134887 100644
> --- a/arch/microblaze/kernel/process.c
> +++ b/arch/microblaze/kernel/process.c
> @@ -103,10 +103,10 @@ void cpu_idle(void)
>  		if (!idle)
>  			idle = default_idle;
> 
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched())
>  			idle();
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
> 
>  		preempt_enable_no_resched();
>  		schedule();
> diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
> index d2112d3..d79e7d3 100644
> --- a/arch/mips/kernel/process.c
> +++ b/arch/mips/kernel/process.c
> @@ -56,7 +56,7 @@ void __noreturn cpu_idle(void)
> 
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched() && cpu_online(cpu)) {
>  #ifdef CONFIG_MIPS_MT_SMTC
>  			extern void smtc_idle_loop_hook(void);
> @@ -77,7 +77,7 @@ void __noreturn cpu_idle(void)
>  		     system_state == SYSTEM_BOOTING))
>  			play_dead();
>  #endif
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
> index 39a2baa..b30ddf1 100644
> --- a/arch/powerpc/kernel/idle.c
> +++ b/arch/powerpc/kernel/idle.c
> @@ -56,7 +56,7 @@ void cpu_idle(void)
> 
>  	set_thread_flag(TIF_POLLING_NRFLAG);
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched() && !cpu_should_die()) {
>  			ppc64_runlatch_off();
> 
> @@ -93,7 +93,7 @@ void cpu_idle(void)
> 
>  		HMT_medium();
>  		ppc64_runlatch_on();
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		if (cpu_should_die())
>  			cpu_die();
> diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
> index c25a081..aa2be7d 100644
> --- a/arch/powerpc/platforms/iseries/setup.c
> +++ b/arch/powerpc/platforms/iseries/setup.c
> @@ -562,7 +562,7 @@ static void yield_shared_processor(void)
>  static void iseries_shared_idle(void)
>  {
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched() && !hvlpevent_is_pending()) {
>  			local_irq_disable();
>  			ppc64_runlatch_off();
> @@ -576,7 +576,7 @@ static void iseries_shared_idle(void)
>  		}
> 
>  		ppc64_runlatch_on();
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
> 
>  		if (hvlpevent_is_pending())
>  			process_iSeries_events();
> @@ -592,7 +592,7 @@ static void iseries_dedicated_idle(void)
>  	set_thread_flag(TIF_POLLING_NRFLAG);
> 
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		if (!need_resched()) {
>  			while (!need_resched()) {
>  				ppc64_runlatch_off();
> @@ -609,7 +609,7 @@ static void iseries_dedicated_idle(void)
>  		}
> 
>  		ppc64_runlatch_on();
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
> index 541a750..b19f7b2 100644
> --- a/arch/s390/kernel/process.c
> +++ b/arch/s390/kernel/process.c
> @@ -90,10 +90,10 @@ static void default_idle(void)
>  void cpu_idle(void)
>  {
>  	for (;;) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched())
>  			default_idle();
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
> index 425d604..d8997ac 100644
> --- a/arch/sh/kernel/idle.c
> +++ b/arch/sh/kernel/idle.c
> @@ -88,7 +88,7 @@ void cpu_idle(void)
> 
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
> 
>  		while (!need_resched()) {
>  			check_pgt_cache();
> diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
> index c158a95..986d019 100644
> --- a/arch/sparc/kernel/process_64.c
> +++ b/arch/sparc/kernel/process_64.c
> @@ -95,12 +95,12 @@ void cpu_idle(void)
>  	set_thread_flag(TIF_POLLING_NRFLAG);
> 
>  	while(1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
> 
>  		while (!need_resched() && !cpu_is_offline(cpu))
>  			sparc64_yield(cpu);
> 
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
> 
>  		preempt_enable_no_resched();
> 
> diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
> index 9c45d8b..63fc9c0 100644
> --- a/arch/tile/kernel/process.c
> +++ b/arch/tile/kernel/process.c
> @@ -85,7 +85,7 @@ void cpu_idle(void)
> 
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched()) {
>  			if (cpu_is_offline(cpu))
>  				BUG();  /* no HOTPLUG_CPU */
> @@ -105,7 +105,7 @@ void cpu_idle(void)
>  				local_irq_enable();
>  			current_thread_info()->status |= TS_POLLING;
>  		}
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
> index fab4371..c18786f 100644
> --- a/arch/um/kernel/process.c
> +++ b/arch/um/kernel/process.c
> @@ -245,10 +245,10 @@ void default_idle(void)
>  		if (need_resched())
>  			schedule();
> 
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		nsecs = disable_timer();
>  		idle_sleep(nsecs);
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  	}
>  }
> 
> diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
> index ba401df..353b047 100644
> --- a/arch/unicore32/kernel/process.c
> +++ b/arch/unicore32/kernel/process.c
> @@ -55,7 +55,7 @@ void cpu_idle(void)
>  {
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched()) {
>  			local_irq_disable();
>  			stop_critical_timings();
> @@ -63,7 +63,7 @@ void cpu_idle(void)
>  			local_irq_enable();
>  			start_critical_timings();
>  		}
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index a3d0dc5..2cbf235 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -97,7 +97,7 @@ void cpu_idle(void)
> 
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched()) {
> 
>  			check_pgt_cache();
> @@ -112,7 +112,7 @@ void cpu_idle(void)
>  			pm_idle();
>  			start_critical_timings();
>  		}
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index ca6f7ab..3d56f0d 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -120,7 +120,7 @@ void cpu_idle(void)
> 
>  	/* endless idle loop with no priority at all */
>  	while (1) {
> -		tick_nohz_stop_sched_tick(1);
> +		tick_nohz_enter_idle(true);
>  		while (!need_resched()) {
> 
>  			rmb();
> @@ -145,7 +145,7 @@ void cpu_idle(void)
>  			__exit_idle();
>  		}
> 
> -		tick_nohz_restart_sched_tick();
> +		tick_nohz_exit_idle(true);
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index b232ccc..4cbbcbb 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -121,14 +121,15 @@ static inline int tick_oneshot_mode_active(void) { return 0; }
>  #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
> 
>  # ifdef CONFIG_NO_HZ
> -extern void tick_nohz_stop_sched_tick(int inidle);
> -extern void tick_nohz_restart_sched_tick(void);
> +extern bool tick_nohz_stop_sched_tick(int inidle);
> +extern void tick_nohz_enter_idle(bool rcu_ext_qs);
> +extern void tick_nohz_exit_idle(bool rcu_ext_qs);
>  extern ktime_t tick_nohz_get_sleep_length(void);
>  extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
>  extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
>  # else
> -static inline void tick_nohz_stop_sched_tick(int inidle) { }
> -static inline void tick_nohz_restart_sched_tick(void) { }
> +static inline void tick_nohz_enter_idle(bool rcu_ext_qs) { }
> +static inline void tick_nohz_exit_idle(bool rcu_ext_qs) { }
>  static inline ktime_t tick_nohz_get_sleep_length(void)
>  {
>  	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index eb98e55..609bb20 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -253,12 +253,13 @@ EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);
>   * Called either from the idle loop or from irq_exit() when an idle period was
>   * just interrupted by an interrupt which did not cause a reschedule.
>   */
> -void tick_nohz_stop_sched_tick(int inidle)
> +bool tick_nohz_stop_sched_tick(int inidle)
>  {
>  	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
>  	struct tick_sched *ts;
>  	ktime_t last_update, expires, now;
>  	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
> +	int stopped = false;
>  	u64 time_delta;
>  	int cpu;
> 
> @@ -405,7 +406,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
>  			ts->tick_stopped = 1;
>  			ts->idle_jiffies = last_jiffies;
> -			rcu_enter_nohz();
> +			stopped = true;
>  		}
> 
>  		ts->idle_sleeps++;
> @@ -445,6 +446,24 @@ out:
>  	ts->sleep_length = ktime_sub(dev->next_event, now);
>  end:
>  	local_irq_restore(flags);
> +
> +	return stopped;
> +}
> +
> +
> +/**
> + * tick_nohz_enter_idle - stop the tick from the idle task
> + * @rcu_ext_qs: enter rcu dynticks idle mode
> + *
> + * When an arch doesn't make any use of rcu read side critical section
> + * between tick_nohz_enter_idle() and tick_nohz_exit_idle() it can set
> + * rcu_ext_qs to 1. Otherwise it needs to call rcu_enter_nohz() itself
> + * later before the CPU goes to sleep.
> + */
> +void tick_nohz_enter_idle(bool rcu_ext_qs)
> +{
> +	if (tick_nohz_stop_sched_tick(1) && rcu_ext_qs)
> +		rcu_enter_nohz();
>  }
> 
>  /**
> @@ -486,11 +505,12 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
>  }
> 
>  /**
> - * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
> + * tick_nohz_exit_idle - restart the idle tick from the idle task
> + * @rcu_ext_qs: exit rcu dynticks idle mode
>   *
>   * Restart the idle tick when the CPU is woken up from idle
>   */
> -void tick_nohz_restart_sched_tick(void)
> +void tick_nohz_exit_idle(bool rcu_ext_qs)
>  {
>  	int cpu = smp_processor_id();
>  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> @@ -514,7 +534,8 @@ void tick_nohz_restart_sched_tick(void)
> 
>  	ts->inidle = 0;
> 
> -	rcu_exit_nohz();
> +	if (rcu_ext_qs)
> +		rcu_exit_nohz();
> 
>  	/* Update jiffies first */
>  	select_nohz_load_balancer(0);
> -- 
> 1.7.5.4
> 
