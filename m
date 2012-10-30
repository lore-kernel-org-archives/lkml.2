Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160Ab2J3SXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:23:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9249 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759673Ab2J3SXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:23:32 -0400
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4c5qRh9MTAAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ctFK64zPdRsA:10 a=JqeBxlcDb3fY_9cQVdcA:9 a=PUjeQqilurYA:10 a=ZxKc-KBN8_A8pcCE:21 a=3Bi-RTDrAX39xM94:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351621408.4004.14.camel@gandalf.local.home>
Subject: Re: [PATCH 05/32] nohz: Adaptive tick stop and restart on nohz
 cpuset
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Date: Tue, 30 Oct 2012 14:23:28 -0400
In-Reply-To: <20121029203847.391136599@goodmis.org>
References: <20121029202711.062749374@goodmis.org>
	 <20121029203847.391136599@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 16:27 -0400, Steven Rostedt wrote:

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1196,6 +1196,29 @@ static void update_avg(u64 *avg, u64 sample)
>  }
>  #endif
>  
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +bool sched_can_stop_tick(void)
> +{
> +	struct rq *rq;
> +
> +	rq = this_rq();
> +
> +	/*
> +	 * This is called right after cpuset_adaptive_nohz() that

See below (for this caller).


> +	 * uses atomic_add_return() so that we are ordered against
> +	 * cpu_adaptive_nohz_ref. When inc_nr_running() sends an
> +	 * IPI to this CPU, we are guaranteed to see the update on
> +	 * nr_running.
> +	 */
> +
> +	/* More than one running task need preemption */
> +	if (rq->nr_running > 1)
> +		return false;
> +
> +	return true;
> +}
> +#endif
> +
>  static void
>  ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
>  {
> @@ -1897,6 +1920,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
>  	 * frame will be invalid.
>  	 */
>  	finish_task_switch(this_rq(), prev);
> +	tick_nohz_post_schedule();
>  }
>  
>  /*
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 7a7db09..c6cd9ec 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1,6 +1,7 @@
>  
>  #include <linux/sched.h>
>  #include <linux/mutex.h>
> +#include <linux/cpuset.h>
>  #include <linux/spinlock.h>
>  #include <linux/stop_machine.h>
>  
> @@ -927,6 +928,17 @@ static inline u64 steal_ticks(u64 steal)
>  static inline void inc_nr_running(struct rq *rq)
>  {
>  	rq->nr_running++;
> +
> +	if (rq->nr_running == 2) {
> +		/*
> +		 * cpuset_cpu_adaptive_nohz() uses atomic_add_return()
> +		 * to order against rq->nr_running updates. This way
> +		 * the CPU that receives the IPI is guaranteed to see
> +		 * the update on nr_running without the rq->lock.
> +		 */
> +		if (cpuset_cpu_adaptive_nohz(rq->cpu))
> +			smp_cpuset_update_nohz(rq->cpu);
> +	}
>  }
>  
>  static inline void dec_nr_running(struct rq *rq)

Should we add one for dec_nr_running()? Or is this done elsewhere. I
would think that there's a good chance that we can miss a chance to stop
the tick.


> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index cc96bdc..e06b8eb 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -25,6 +25,7 @@
>  #include <linux/smp.h>
>  #include <linux/smpboot.h>
>  #include <linux/tick.h>
> +#include <linux/cpuset.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/irq.h>
> @@ -307,7 +308,8 @@ void irq_enter(void)
>  	int cpu = smp_processor_id();
>  
>  	rcu_irq_enter();
> -	if (is_idle_task(current) && !in_interrupt()) {
> +
> +	if ((is_idle_task(current) || cpuset_adaptive_nohz()) && !in_interrupt()) {
>  		/*
>  		 * Prevent raise_softirq from needlessly waking up ksoftirqd
>  		 * here, as softirq will be serviced on return from interrupt.
> @@ -349,7 +351,7 @@ void irq_exit(void)
>  
>  #ifdef CONFIG_NO_HZ
>  	/* Make sure that timer wheel updates are propagated */
> -	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
> +	if (!in_interrupt())
>  		tick_nohz_irq_exit();
>  #endif
>  	rcu_irq_exit();
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index c7a78c6..35047b2 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -512,6 +512,24 @@ void tick_nohz_idle_enter(void)
>  	local_irq_enable();
>  }
>  
> +static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
> +{
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +	int cpu = smp_processor_id();
> +
> +	if (!cpuset_adaptive_nohz() || is_idle_task(current))
> +		return;

The above is most likely true. Lets remove the memory barrier in
cpuset_adaptive_nohz(), just add an explicit one here, in the slow path.

	/* Before checking the below conditions, we must first
	 * make sure that the cpuset/nohz is active, so we do
	 * not miss a deactivating IPI. 
	 * ie. when nr_running == 2, an IPI is sent, and this
	 * code must see the nr_running changed after testing
	 * if the current CPU is adaptive nohz.
	 */
	smp_mb();

> +
> +	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
> +		return;
> +
> +	if (!sched_can_stop_tick())
> +		return;
> +
> +	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
> +#endif
> +}
> +
>  /**
>   * tick_nohz_irq_exit - update next tick event from interrupt exit
>   *
> @@ -524,10 +542,12 @@ void tick_nohz_irq_exit(void)
>  {
>  	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>  
> -	if (!ts->inidle)
> -		return;
> -
> -	__tick_nohz_idle_enter(ts);
> +	if (ts->inidle) {
> +		if (!need_resched())
> +			__tick_nohz_idle_enter(ts);
> +	} else {
> +		tick_nohz_cpuset_stop_tick(ts);
> +	}
>  }
>  
>  /**
> @@ -568,7 +588,7 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
>  	}
>  }
>  
> -static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
> +static void __tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
>  {
>  	/* Update jiffies first */
>  	tick_do_update_jiffies64(now);
> @@ -584,6 +604,31 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
>  	tick_nohz_restart(ts, now);
>  }
>  
> +/**
> + * tick_nohz_restart_sched_tick - restart the tick for a tickless CPU
> + *
> + * Restart the tick when the CPU is in adaptive tickless mode.
> + */
> +void tick_nohz_restart_sched_tick(void)
> +{
> +	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> +	unsigned long flags;
> +	ktime_t now;
> +
> +	local_irq_save(flags);
> +
> +	if (!ts->tick_stopped) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +
> +	now = ktime_get();
> +	__tick_nohz_restart_sched_tick(ts, now);
> +
> +	local_irq_restore(flags);
> +}
> +
> +
>  static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
>  {
>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING
> @@ -630,7 +675,7 @@ void tick_nohz_idle_exit(void)
>  	if (ts->tick_stopped) {
>  		nohz_balance_enter_idle(cpu);
>  		calc_load_exit_idle();
> -		tick_nohz_restart_sched_tick(ts, now);
> +		__tick_nohz_restart_sched_tick(ts, now);
>  		tick_nohz_account_idle_ticks(ts);
>  	}
>  
> @@ -791,7 +836,6 @@ void tick_check_idle(int cpu)
>  }
>  
>  #ifdef CONFIG_CPUSETS_NO_HZ
> -
>  /*
>   * Take the timer duty if nobody is taking care of it.
>   * If a CPU already does and and it's in a nohz cpuset,
> @@ -810,6 +854,31 @@ static void tick_do_timer_check_handler(int cpu)
>  	}
>  }
>  
> +void tick_nohz_check_adaptive(void)
> +{
> +	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> +
> +	if (cpuset_adaptive_nohz()) {

Add smp_mb() here too, with the same comment.


Another option may be to only add the memory barrier on the true case:

static inline bool cpuset_adaptive_nohz(void)
{
	if (atomic_read(this_cpu_read(cpu_adaptive_nohz_ref)) > 0) {
		/*
		 * In order not to miss cases where we need to enable
		 * the tick again, we must make sure that all new checks
		 * are visible after we find we are in adaptive nohz
		 * mode.
		 */
		smp_mb();
		return true;
	}
	return false;
}

The above will only force the expensive memory barrier when adaptive
nohz is enabled. All other cases will avoid that overhead. If we miss
disabling the tick, the next tick should disable it. But we must make
sure that we enable it when needed.

But as this is called in several fast paths for everyone, we need to
keep the overhead of the default case as low as possible.

> +		if (ts->tick_stopped && !is_idle_task(current)) {
> +			if (!sched_can_stop_tick())
> +				tick_nohz_restart_sched_tick();
> +		}
> +	}
> +}
> +
> +void tick_nohz_post_schedule(void)
> +{
> +	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> +
> +	/*
> +	 * No need to disable irqs here. The worst that can happen
> +	 * is an irq that comes and restart the tick before us.
> +	 * tick_nohz_restart_sched_tick() is irq safe.
> +	 */
> +	if (ts->tick_stopped)
> +		tick_nohz_restart_sched_tick();
> +}
> +
>  #else
>  
>  static void tick_do_timer_check_handler(int cpu)
> @@ -856,6 +925,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
>  	 * no valid regs pointer
>  	 */
>  	if (regs) {
> +		int user = user_mode(regs);
>  		/*
>  		 * When we are idle and the tick is stopped, we have to touch
>  		 * the watchdog as we might not schedule for a really long
> @@ -869,7 +939,7 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
>  			if (is_idle_task(current))
>  				ts->idle_jiffies++;
>  		}
> -		update_process_times(user_mode(regs));
> +		update_process_times(user);

What's the purpose of this change?

-- Steve

>  		profile_tick(CPU_PROFILING);
>  	}
>  


