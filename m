Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab2EVRRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:17:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:46896 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2EVRRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:17:47 -0400
Date: Tue, 22 May 2012 10:16:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/41] nohz/cpuset: Don't turn off the tick if rcu needs
 it
Message-ID: <20120522171658.GA8087@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-12-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335830115-14335-12-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052217-5518-0000-0000-0000049757D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:54:45AM +0200, Frederic Weisbecker wrote:
> If RCU is waiting for the current CPU to complete a grace
> period, don't turn off the tick. Unlike dynctik-idle, we
> are not necessarily going to enter into rcu extended quiescent
> state, so we may need to keep the tick to note current CPU's
> quiescent states.
> 
> [added build fix from Zen Lin]

Hello, Frederic,

One question below -- why not rcu_needs_cpu() instead of rcu_pending()?

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/rcupdate.h |    1 +
>  kernel/rcutree.c         |    3 +--
>  kernel/time/tick-sched.c |   22 ++++++++++++++++++----
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 81c04f4..e06639e 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -184,6 +184,7 @@ static inline int rcu_preempt_depth(void)
>  extern void rcu_sched_qs(int cpu);
>  extern void rcu_bh_qs(int cpu);
>  extern void rcu_check_callbacks(int cpu, int user);
> +extern int rcu_pending(int cpu);
>  struct notifier_block;
>  extern void rcu_idle_enter(void);
>  extern void rcu_idle_exit(void);
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 6c4a672..e141c7e 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -212,7 +212,6 @@ int rcu_cpu_stall_suppress __read_mostly;
>  module_param(rcu_cpu_stall_suppress, int, 0644);
> 
>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
> -static int rcu_pending(int cpu);
> 
>  /*
>   * Return the number of RCU-sched batches processed thus far for debug & stats.
> @@ -1915,7 +1914,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
>   * by the current CPU, returning 1 if so.  This function is part of the
>   * RCU implementation; it is -not- an exported member of the RCU API.
>   */
> -static int rcu_pending(int cpu)
> +int rcu_pending(int cpu)
>  {
>  	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
>  	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 43fa7ac..4f99766 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -506,9 +506,21 @@ void tick_nohz_idle_enter(void)
>  	local_irq_enable();
>  }
> 
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +static bool can_stop_adaptive_tick(void)
> +{
> +	if (!sched_can_stop_tick())
> +		return false;
> +
> +	/* Is there a grace period to complete ? */
> +	if (rcu_pending(smp_processor_id()))

You lost me on this one.  Why can't this be rcu_needs_cpu()?

> +		return false;
> +
> +	return true;
> +}
> +
>  static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
>  {
> -#ifdef CONFIG_CPUSETS_NO_HZ
>  	int cpu = smp_processor_id();
> 
>  	if (!cpuset_adaptive_nohz() || is_idle_task(current))
> @@ -517,12 +529,14 @@ static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
>  	if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
>  		return;
> 
> -	if (!sched_can_stop_tick())
> +	if (!can_stop_adaptive_tick())
>  		return;
> 
>  	tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
> -#endif
>  }
> +#else
> +static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts) { }
> +#endif
> 
>  /**
>   * tick_nohz_irq_exit - update next tick event from interrupt exit
> @@ -852,7 +866,7 @@ void tick_nohz_check_adaptive(void)
>  	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> 
>  	if (ts->tick_stopped && !is_idle_task(current)) {
> -		if (!sched_can_stop_tick())
> +		if (!can_stop_adaptive_tick())
>  			tick_nohz_restart_sched_tick();
>  	}
>  }
> -- 
> 1.7.5.4
> 

