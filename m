Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab0FAXrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:47:35 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38207 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0FAXrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:47:33 -0400
Date: Wed, 2 Jun 2010 05:17:19 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [patch 4/7] sched: Change nohz ilb logic from pull to push
 model
Message-ID: <20100601234719.GC7764@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
 <20100517184027.862696498@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100517184027.862696498@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2010-05-17 11:27:30]:

> From: Venkatesh Pallipadi <venki@google.com>
> Subject: sched: Change nohz ilb logic from pull to push model
> 
> In the new push model, all idle CPUs indeed go into nohz mode. There is
> still the concept of idle load balancer. Busy CPU kicks the nohz
> balancer when any of the nohz CPUs need idle load balancing.
> The kickee CPU does the idle load balancing on behalf of all idle CPUs
> instead of the normal idle balance.
> 
> This addresses the below two problems with the current nohz ilb logic:
> * the balancer will continue to have periodic ticks and wakeup
>   frequently, even though it may not have any rebalancing to do on
>   behalf of any of the idle CPUs.
> * On x86 and CPUs that have APIC timer stoppage on idle CPUs, this
>   periodic wakeup can result in an additional interrupt on a CPU
>   doing the timer broadcast.

How do we select the timer broadcast cpu today?  Is it changes at all
at run time?  Maybe that CPU should be a good target for the timer
migration so that additional CPU are not wokenup from idle states.

> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  kernel/sched.c      |   13 +-
>  kernel/sched_fair.c |  283 ++++++++++++++++++++++++++++++----------------------
>  2 files changed, 177 insertions(+), 119 deletions(-)
> 
> Index: tip/kernel/sched_fair.c
> ===================================================================
> --- tip.orig/kernel/sched_fair.c
> +++ tip/kernel/sched_fair.c
> @@ -3081,10 +3081,26 @@ out_unlock:
>  }
> 
>  #ifdef CONFIG_NO_HZ
> +
> +static DEFINE_PER_CPU(struct call_single_data, remote_sched_softirq_cb);
> +
> +/*
> + * idle load balancing details
> + * - One of the idle CPUs nominates itself as idle load_balancer, while
> + *   entering idle.
> + * - This idle load balancer CPU will also go into tickless mode when
> + *   it is idle, just like all other idle CPUs
> + * - When one of the busy CPUs notice that there may be an idle rebalancing
> + *   needed, they will kick the idle load balancer, which then does idle
> + *   load balancing for all the idle CPUs.
> + */
>  static struct {
>  	atomic_t load_balancer;
> -	cpumask_var_t cpu_mask;
> -	cpumask_var_t ilb_grp_nohz_mask;
> +	atomic_t first_pick_cpu;
> +	atomic_t second_pick_cpu;
> +	cpumask_var_t idle_cpus_mask;
> +	cpumask_var_t grp_idle_mask;
> +	unsigned long next_balance;     /* in jiffy units */
>  } nohz ____cacheline_aligned = {
>  	.load_balancer = ATOMIC_INIT(-1),
>  };
> @@ -3141,17 +3157,17 @@ static inline struct sched_domain *lowes
>   */
>  static inline int is_semi_idle_group(struct sched_group *ilb_group)
>  {
> -	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
> +	cpumask_and(nohz.grp_idle_mask, nohz.idle_cpus_mask,
>  					sched_group_cpus(ilb_group));
> 
>  	/*
>  	 * A sched_group is semi-idle when it has atleast one busy cpu
>  	 * and atleast one idle cpu.
>  	 */
> -	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
> +	if (cpumask_empty(nohz.grp_idle_mask))
>  		return 0;
> 
> -	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
> +	if (cpumask_equal(nohz.grp_idle_mask, sched_group_cpus(ilb_group)))
>  		return 0;
> 
>  	return 1;
> @@ -3184,7 +3200,7 @@ static int find_new_ilb(int cpu)
>  	 * Optimize for the case when we have no idle CPUs or only one
>  	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
>  	 */
> -	if (cpumask_weight(nohz.cpu_mask) < 2)
> +	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
>  		goto out_done;
> 
>  	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
> @@ -3192,7 +3208,7 @@ static int find_new_ilb(int cpu)
> 
>  		do {
>  			if (is_semi_idle_group(ilb_group))
> -				return cpumask_first(nohz.ilb_grp_nohz_mask);
> +				return cpumask_first(nohz.grp_idle_mask);
> 
>  			ilb_group = ilb_group->next;
> 
> @@ -3200,42 +3216,61 @@ static int find_new_ilb(int cpu)
>  	}
> 
>  out_done:
> -	return cpumask_first(nohz.cpu_mask);
> +	return nr_cpu_ids;
>  }
>  #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
>  static inline int find_new_ilb(int call_cpu)
>  {
> -	return cpumask_first(nohz.cpu_mask);
> +	return nr_cpu_ids;
>  }
>  #endif
> 
>  /*
> + * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
> + * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
> + * CPU (if there is one).
> + */
> +static void nohz_balancer_kick(int cpu)
> +{
> +	int ilb_cpu;
> +
> +	nohz.next_balance++;
> +
> +	ilb_cpu = get_nohz_load_balancer();
> +	if (ilb_cpu < 0) {
> +		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
> +		if (ilb_cpu >= nr_cpu_ids)
> +			return;
> +	}
> +
> +	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
> +		struct call_single_data *cp;
> +
> +		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
> +		cp = &per_cpu(remote_sched_softirq_cb, cpu);
> +		send_remote_softirq(cp, ilb_cpu, 0);
> +	}
> +	return;
> +}
> +
> +/*
>   * This routine will try to nominate the ilb (idle load balancing)
>   * owner among the cpus whose ticks are stopped. ilb owner will do the idle
> - * load balancing on behalf of all those cpus. If all the cpus in the system
> - * go into this tickless mode, then there will be no ilb owner (as there is
> - * no need for one) and all the cpus will sleep till the next wakeup event
> - * arrives...
> - *
> - * For the ilb owner, tick is not stopped. And this tick will be used
> - * for idle load balancing. ilb owner will still be part of
> - * nohz.cpu_mask..
> + * load balancing on behalf of all those cpus.
>   *
> - * While stopping the tick, this cpu will become the ilb owner if there
> - * is no other owner. And will be the owner till that cpu becomes busy
> - * or if all cpus in the system stop their ticks at which point
> - * there is no need for ilb owner.
> - *
> - * When the ilb owner becomes busy, it nominates another owner, during the
> - * next busy scheduler_tick()
> + * When the ilb owner becomes busy, we will not have new ilb owner until some
> + * idle CPU wakes up and goes back to idle or some busy CPU tries to kick
> + * idle load balancing by kicking one of the idle CPUs.
> + *
> + * Ticks are stopped for the ilb owner as well, with busy CPU kicking this
> + * ilb owner CPU in future (when there is a need for idle load balancing on
> + * behalf of all idle CPUs).
>   */
>  int select_nohz_load_balancer(int stop_tick)
>  {
>  	int cpu = smp_processor_id();
> 
>  	if (stop_tick) {
> -		cpu_rq(cpu)->in_nohz_recently = 1;
> -
>  		if (!cpu_active(cpu)) {
>  			if (atomic_read(&nohz.load_balancer) != cpu)
>  				return 0;
> @@ -3250,25 +3285,20 @@ int select_nohz_load_balancer(int stop_t
>  			return 0;
>  		}
> 
> -		cpumask_set_cpu(cpu, nohz.cpu_mask);
> +		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
> 
> -		/* time for ilb owner also to sleep */
> -		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
> -			if (atomic_read(&nohz.load_balancer) == cpu)
> -				atomic_set(&nohz.load_balancer, -1);
> -			return 0;
> -		}
> +		if (atomic_read(&nohz.first_pick_cpu) == cpu)
> +			atomic_cmpxchg(&nohz.first_pick_cpu, cpu, nr_cpu_ids);
> +		if (atomic_read(&nohz.second_pick_cpu) == cpu)
> +			atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
> 
>  		if (atomic_read(&nohz.load_balancer) == -1) {
> -			/* make me the ilb owner */
> -			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
> -				return 1;
> -		} else if (atomic_read(&nohz.load_balancer) == cpu) {
>  			int new_ilb;
> 
> -			if (!(sched_smt_power_savings ||
> -						sched_mc_power_savings))
> -				return 1;
> +			/* make me the ilb owner */
> +			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) != -1)
> +				return 0;
> +
>  			/*
>  			 * Check to see if there is a more power-efficient
>  			 * ilb.
> @@ -3279,13 +3309,13 @@ int select_nohz_load_balancer(int stop_t
>  				resched_cpu(new_ilb);
>  				return 0;
>  			}
> -			return 1;
> +			return 0;
>  		}
>  	} else {
> -		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
> +		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
>  			return 0;
> 
> -		cpumask_clear_cpu(cpu, nohz.cpu_mask);
> +		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
> 
>  		if (atomic_read(&nohz.load_balancer) == cpu)
>  			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
> @@ -3373,11 +3403,97 @@ out:
>  		rq->next_balance = next_balance;
>  }
> 
> +#ifdef CONFIG_NO_HZ
>  /*
> - * run_rebalance_domains is triggered when needed from the scheduler tick.
> - * In CONFIG_NO_HZ case, the idle load balance owner will do the
> + * In CONFIG_NO_HZ case, the idle balance kickee will do the
>   * rebalancing for all the cpus for whom scheduler ticks are stopped.
>   */
> +static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
> +{
> +	struct rq *this_rq = cpu_rq(this_cpu);
> +	struct rq *rq;
> +	int balance_cpu;
> +
> +	if (idle != CPU_IDLE || !this_rq->nohz_balance_kick)
> +		return;
> +
> +	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
> +		if (balance_cpu == this_cpu)
> +			continue;
> +
> +		/*
> +		 * If this cpu gets work to do, stop the load balancing
> +		 * work being done for other cpus. Next load
> +		 * balancing owner will pick it up.
> +		 */
> +		if (need_resched()) {
> +			this_rq->nohz_balance_kick = 0;
> +			break;
> +		}
> +
> +		rebalance_domains(balance_cpu, CPU_IDLE);
> +
> +		rq = cpu_rq(balance_cpu);
> +		if (time_after(this_rq->next_balance, rq->next_balance))
> +			this_rq->next_balance = rq->next_balance;
> +	}
> +	nohz.next_balance = this_rq->next_balance;
> +	this_rq->nohz_balance_kick = 0;
> +}
> +
> +/*
> + * Current heuristic for kicking the idle load balancer
> + * - first_pick_cpu is the one of the busy CPUs. It will kick
> + *   idle load balancer when it has more than one process active. This
> + *   eliminates the need for idle load balancing altogether when we have
> + *   only one running process in the system (common case).
> + * - If there are more than one busy CPU, idle load balancer may have
> + *   to run for active_load_balance to happen (i.e., two busy CPUs are
> + *   SMT or core siblings and can run better if they move to different
> + *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
> + *   which will kick idle load balancer as soon as it has any load.
> + */
> +static inline int nohz_kick_needed(struct rq *rq, int cpu)
> +{
> +	unsigned long now = jiffies;
> +	int ret;
> +	int first_pick_cpu, second_pick_cpu;
> +
> +	if (time_before(now, nohz.next_balance))
> +		return 0;
> +
> +	if (!rq->nr_running)
> +		return 0;
> +
> +	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
> +	second_pick_cpu = atomic_read(&nohz.second_pick_cpu);
> +
> +	if (first_pick_cpu < nr_cpu_ids && first_pick_cpu != cpu &&
> +	    second_pick_cpu < nr_cpu_ids && second_pick_cpu != cpu)
> +		return 0;
> +
> +	ret = atomic_cmpxchg(&nohz.first_pick_cpu, nr_cpu_ids, cpu);
> +	if (ret == nr_cpu_ids || ret == cpu) {
> +		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, nr_cpu_ids);
> +		if (rq->nr_running > 1)
> +			return 1;
> +	} else {
> +		ret = atomic_cmpxchg(&nohz.second_pick_cpu, nr_cpu_ids, cpu);
> +		if (ret == nr_cpu_ids || ret == cpu) {
> +			if (rq->nr_running)
> +				return 1;
> +		}
> +	}
> +	return 0;

Hi Suresh,

Can you please give more explanation on how the combination of
first_pick_cpu and second_pick_cpu works.  We need to kick an idle CPU
whenever our cpu or group becomes overloaded right.  We will have to
prefer cores of other packages when more tasks become ready to run.
So a notion of group overload is needed to kick new cpus.  Also new
idle CPUs that are kicked should come form other cores and packages
instead or nearest sibling.

As per the current implementation a sibling thread may be kicked but
it will not pull the task as the load balancer will be run on behalf
of all idle cores in the system and then a appropriate idle core will
pull the new task... correct?

--Vaidy

[snip]

