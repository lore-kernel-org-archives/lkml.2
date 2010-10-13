Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0JMNAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:00:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56651 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0JMNAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:00:43 -0400
Date: Wed, 13 Oct 2010 18:30:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [PATCH v3 1/7] sched: introduce primitives to account for CFS
 bandwidth tracking
Message-ID: <20101013130018.GC3914@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
 <20101012075023.GB9893@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101012075023.GB9893@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bharata B Rao <bharata@linux.vnet.ibm.com> [2010-10-12 13:20:23]:

> sched: introduce primitives to account for CFS bandwidth tracking
> 
> From: Paul Turner <pjt@google.com>
> 
> In this patch we introduce the notion of CFS bandwidth, to account for the
> realities of SMP this is partitioned into globally unassigned bandwidth, and
> locally claimed bandwidth:
> - The global bandwidth is per task_group, it represents a pool of unclaimed
>   bandwidth that cfs_rq's can allocate from.  It uses the new cfs_bandwidth
>   structure.
> - The local bandwidth is tracked per-cfs_rq, this represents allotments from
>   the global pool
>   bandwidth assigned to a task_group, this is tracked using the
>   new cfs_bandwidth structure.
> 
> Bandwidth is managed via cgroupfs via two new files in the cpu subsystem:
> - cpu.cfs_period_us : the bandwidth period in usecs
> - cpu.cfs_quota_us : the cpu bandwidth (in usecs) that this tg will be allowed
>   to consume over period above.
> 
> A per-cfs_bandwidth timer is also introduced to handle future refresh at
> period expiration.  There's some minor refactoring here so that
> start_bandwidth_timer() functionality can be shared
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  init/Kconfig        |    9 +
>  kernel/sched.c      |  271 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  kernel/sched_fair.c |   10 +
>  3 files changed, 268 insertions(+), 22 deletions(-)
> 
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -609,6 +609,15 @@ config FAIR_GROUP_SCHED
>  	depends on CGROUP_SCHED
>  	default CGROUP_SCHED
> 
> +config CFS_BANDWIDTH
> +	bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
> +	depends on EXPERIMENTAL
> +	depends on FAIR_GROUP_SCHED
> +	default n
> +	help
> +	  This option allows users to define quota and period for cpu
> +	  bandwidth provisioning on a per-cgroup basis.
> +
>  config RT_GROUP_SCHED
>  	bool "Group scheduling for SCHED_RR/FIFO"
>  	depends on EXPERIMENTAL
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -192,10 +192,28 @@ static inline int rt_bandwidth_enabled(v
>  	return sysctl_sched_rt_runtime >= 0;
>  }
> 
> -static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
> +static void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
>  {
> -	ktime_t now;
> +	unsigned long delta;
> +	ktime_t soft, hard, now;
> +
> +	for (;;) {
> +		if (hrtimer_active(period_timer))
> +			break;
> 
> +		now = hrtimer_cb_get_time(period_timer);
> +		hrtimer_forward(period_timer, now, period);
> +
> +		soft = hrtimer_get_softexpires(period_timer);
> +		hard = hrtimer_get_expires(period_timer);
> +		delta = ktime_to_ns(ktime_sub(hard, soft));
> +		__hrtimer_start_range_ns(period_timer, soft, delta,
> +					 HRTIMER_MODE_ABS_PINNED, 0);

This code can be replaced with

hrtimer_start_expires(period_timer, HRTIMER_MODE_ABS_PINNED) if we
don't care about wakeup_softirq, is there a reason we prefer to keep
wakeup as 0?

> +	}
> +}
> +
> +static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
> +{
>  	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
>  		return;
> 
> @@ -203,22 +221,7 @@ static void start_rt_bandwidth(struct rt
>  		return;
> 
>  	raw_spin_lock(&rt_b->rt_runtime_lock);
> -	for (;;) {
> -		unsigned long delta;
> -		ktime_t soft, hard;
> -
> -		if (hrtimer_active(&rt_b->rt_period_timer))
> -			break;
> -
> -		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
> -		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
> -
> -		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
> -		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
> -		delta = ktime_to_ns(ktime_sub(hard, soft));
> -		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
> -				HRTIMER_MODE_ABS_PINNED, 0);
> -	}
> +	start_bandwidth_timer(&rt_b->rt_period_timer, rt_b->rt_period);
>  	raw_spin_unlock(&rt_b->rt_runtime_lock);
>  }
> 
> @@ -243,6 +246,15 @@ struct cfs_rq;
> 
>  static LIST_HEAD(task_groups);
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +struct cfs_bandwidth {
> +	raw_spinlock_t		lock;
> +	ktime_t			period;
> +	u64			runtime, quota;
> +	struct hrtimer		period_timer;
> +};
> +#endif
> +
>  /* task group related information */
>  struct task_group {
>  	struct cgroup_subsys_state css;
> @@ -268,6 +280,10 @@ struct task_group {
>  	struct task_group *parent;
>  	struct list_head siblings;
>  	struct list_head children;
> +
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	struct cfs_bandwidth cfs_bandwidth;
> +#endif
>  };
> 
>  #define root_task_group init_task_group
> @@ -369,9 +385,76 @@ struct cfs_rq {
>  	 */
>  	unsigned long rq_weight;
>  #endif
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	u64 quota_assigned, quota_used;
> +#endif
>  #endif
>  };
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
> +
> +static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> +{
> +	struct cfs_bandwidth *cfs_b =
> +		container_of(timer, struct cfs_bandwidth, period_timer);
> +	ktime_t now;
> +	int overrun;
> +	int idle = 0;
> +
> +	for (;;) {
> +		now = hrtimer_cb_get_time(timer);
> +		overrun = hrtimer_forward(timer, now, cfs_b->period);
> +
> +		if (!overrun)
> +			break;

What is the significance of overrun? overrun is set when delta >
interval. The logic seems to be that hrtimer is forwarded in steps of
cfs_b->period till we reach the desired time.

> +
> +		idle = do_sched_cfs_period_timer(cfs_b, overrun);
> +	}
> +
> +	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
> +}
> +
> +static
> +void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 quota, u64 period)
> +{
> +	raw_spin_lock_init(&cfs_b->lock);
> +	cfs_b->quota = cfs_b->runtime = quota;
> +	cfs_b->period = ns_to_ktime(period);
> +
> +	hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	cfs_b->period_timer.function = sched_cfs_period_timer;
> +}
> +
> +static
> +void init_cfs_rq_quota(struct cfs_rq *cfs_rq)
> +{
> +	cfs_rq->quota_used = 0;
> +	if (cfs_rq->tg->cfs_bandwidth.quota == RUNTIME_INF)
> +		cfs_rq->quota_assigned = RUNTIME_INF;
> +	else
> +		cfs_rq->quota_assigned = 0;
> +}
> +
> +static void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> +{
> +	if (cfs_b->quota == RUNTIME_INF)
> +		return;
> +
> +	if (hrtimer_active(&cfs_b->period_timer))
> +		return;

Why the double check, start_bandwidth_timer also checks this. Is it to
avoid doing the check under cfs_b->lock?

> +
> +	raw_spin_lock(&cfs_b->lock);
> +	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
> +	raw_spin_unlock(&cfs_b->lock);
> +}
> +
> +static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> +{
> +	hrtimer_cancel(&cfs_b->period_timer);
> +}
> +#endif
> +
>  /* Real-Time classes' related field in a runqueue: */
>  struct rt_rq {
>  	struct rt_prio_array active;
> @@ -1840,6 +1923,14 @@ static inline void __set_task_cpu(struct
> 
>  static const struct sched_class rt_sched_class;
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +/*
> + * default period for cfs group bandwidth.
> + * default: 0.5s
> + */
> +static u64 sched_cfs_bandwidth_period = 500000000ULL;
> +#endif
> +
>  #define sched_class_highest (&rt_sched_class)
>  #define for_each_class(class) \
>     for (class = sched_class_highest; class; class = class->next)
> @@ -7644,6 +7735,9 @@ static void init_tg_cfs_entry(struct tas
>  	tg->cfs_rq[cpu] = cfs_rq;
>  	init_cfs_rq(cfs_rq, rq);
>  	cfs_rq->tg = tg;
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	init_cfs_rq_quota(cfs_rq);
> +#endif
>  	if (add)
>  		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
> 
> @@ -7789,6 +7883,10 @@ void __init sched_init(void)
>  		 * We achieve this by letting init_task_group's tasks sit
>  		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
>  		 */
> +#ifdef CONFIG_CFS_BANDWIDTH
> +		init_cfs_bandwidth(&init_task_group.cfs_bandwidth,
> +				RUNTIME_INF, sched_cfs_bandwidth_period);
> +#endif
>  		init_tg_cfs_entry(&init_task_group, &rq->cfs, NULL, i, 1, NULL);
>  #endif
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
> @@ -8032,6 +8130,10 @@ static void free_fair_sched_group(struct
>  {
>  	int i;
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	destroy_cfs_bandwidth(&tg->cfs_bandwidth);
> +#endif
> +
>  	for_each_possible_cpu(i) {
>  		if (tg->cfs_rq)
>  			kfree(tg->cfs_rq[i]);
> @@ -8059,7 +8161,10 @@ int alloc_fair_sched_group(struct task_g
>  		goto err;
> 
>  	tg->shares = NICE_0_LOAD;
> -
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	init_cfs_bandwidth(&tg->cfs_bandwidth, RUNTIME_INF,
> +			sched_cfs_bandwidth_period);
> +#endif
>  	for_each_possible_cpu(i) {
>  		rq = cpu_rq(i);
> 
> @@ -8505,7 +8610,7 @@ static int __rt_schedulable(struct task_
>  	return walk_tg_tree(tg_schedulable, tg_nop, &data);
>  }
> 
> -static int tg_set_bandwidth(struct task_group *tg,
> +static int tg_set_rt_bandwidth(struct task_group *tg,
>  		u64 rt_period, u64 rt_runtime)
>  {
>  	int i, err = 0;
> @@ -8544,7 +8649,7 @@ int sched_group_set_rt_runtime(struct ta
>  	if (rt_runtime_us < 0)
>  		rt_runtime = RUNTIME_INF;
> 
> -	return tg_set_bandwidth(tg, rt_period, rt_runtime);
> +	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
>  }
> 
>  long sched_group_rt_runtime(struct task_group *tg)
> @@ -8569,7 +8674,7 @@ int sched_group_set_rt_period(struct tas
>  	if (rt_period == 0)
>  		return -EINVAL;
> 
> -	return tg_set_bandwidth(tg, rt_period, rt_runtime);
> +	return tg_set_rt_bandwidth(tg, rt_period, rt_runtime);
>  }
> 
>  long sched_group_rt_period(struct task_group *tg)
> @@ -8776,6 +8881,116 @@ static u64 cpu_shares_read_u64(struct cg
> 
>  	return (u64) tg->shares;
>  }
> +
> +#ifdef CONFIG_CFS_BANDWIDTH
> +static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
> +{
> +	int i;
> +	static DEFINE_MUTEX(mutex);
> +
> +	if (tg == &init_task_group)
> +		return -EINVAL;
> +
> +	if (!period)
> +		return -EINVAL;
> +
> +	/*
> +	 * Ensure we have at least one tick of bandwidth every period.  This is
> +	 * to prevent reaching a state of large arrears when throttled via
> +	 * entity_tick() resulting in prolonged exit starvation.
> +	 */
> +	if (NS_TO_JIFFIES(quota) < 1)
> +		return -EINVAL;

I hope we document this in the Documentation :)

> +
> +	mutex_lock(&mutex);
> +	raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
> +	tg->cfs_bandwidth.period = ns_to_ktime(period);
> +	tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
> +	raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
> +
> +	for_each_possible_cpu(i) {

Why not for_each_online_cpu()?

> +		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
> +		struct rq *rq = rq_of(cfs_rq);
> +
> +		raw_spin_lock_irq(&rq->lock);
> +		init_cfs_rq_quota(cfs_rq);
> +		raw_spin_unlock_irq(&rq->lock);
> +	}
> +	mutex_unlock(&mutex);
> +
> +	return 0;
> +}
> +
> +int tg_set_cfs_quota(struct task_group *tg, long cfs_runtime_us)
> +{
> +	u64 quota, period;
> +
> +	period = ktime_to_ns(tg->cfs_bandwidth.period);
> +	if (cfs_runtime_us < 0)
> +		quota = RUNTIME_INF;

So -1 or -x results in infinite quota?

> +	else
> +		quota = (u64)cfs_runtime_us * NSEC_PER_USEC;
> +
> +	return tg_set_cfs_bandwidth(tg, period, quota);
> +}
> +
> +long tg_get_cfs_quota(struct task_group *tg)
> +{
> +	u64 quota_us;
> +
> +	if (tg->cfs_bandwidth.quota == RUNTIME_INF)
> +		return -1;

This is a little inconsistent, I can set -5, but I see -1 when I do a
get?

> +
> +	quota_us = tg->cfs_bandwidth.quota;
> +	do_div(quota_us, NSEC_PER_USEC);
> +	return quota_us;
> +}
> +
> +int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
> +{
> +	u64 quota, period;
> +
> +	period = (u64)cfs_period_us * NSEC_PER_USEC;
> +	quota = tg->cfs_bandwidth.quota;
> +
> +	if (period <= 0)
> +		return -EINVAL;
> +
> +	return tg_set_cfs_bandwidth(tg, period, quota);
> +}
> +
> +long tg_get_cfs_period(struct task_group *tg)
> +{
> +	u64 cfs_period_us;
> +
> +	cfs_period_us = ktime_to_ns(tg->cfs_bandwidth.period);
> +	do_div(cfs_period_us, NSEC_PER_USEC);
> +	return cfs_period_us;
> +}
> +
> +static s64 cpu_cfs_quota_read_s64(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	return tg_get_cfs_quota(cgroup_tg(cgrp));
> +}
> +
> +static int cpu_cfs_quota_write_s64(struct cgroup *cgrp, struct cftype *cftype,
> +				s64 cfs_quota_us)
> +{
> +	return tg_set_cfs_quota(cgroup_tg(cgrp), cfs_quota_us);
> +}
> +
> +static u64 cpu_cfs_period_read_u64(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	return tg_get_cfs_period(cgroup_tg(cgrp));
> +}
> +
> +static int cpu_cfs_period_write_u64(struct cgroup *cgrp, struct cftype *cftype,
> +				u64 cfs_period_us)
> +{
> +	return tg_set_cfs_period(cgroup_tg(cgrp), cfs_period_us);
> +}
> +
> +#endif /* CONFIG_CFS_BANDWIDTH */
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
> 
>  #ifdef CONFIG_RT_GROUP_SCHED
> @@ -8810,6 +9025,18 @@ static struct cftype cpu_files[] = {
>  		.write_u64 = cpu_shares_write_u64,
>  	},
>  #endif
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	{
> +		.name = "cfs_quota_us",
> +		.read_s64 = cpu_cfs_quota_read_s64,
> +		.write_s64 = cpu_cfs_quota_write_s64,
> +	},
> +	{
> +		.name = "cfs_period_us",
> +		.read_u64 = cpu_cfs_period_read_u64,
> +		.write_u64 = cpu_cfs_period_write_u64,
> +	},
> +#endif
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	{
>  		.name = "rt_runtime_us",
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -360,6 +360,9 @@ static void __enqueue_entity(struct cfs_
> 
>  	rb_link_node(&se->run_node, parent, link);
>  	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	start_cfs_bandwidth(&cfs_rq->tg->cfs_bandwidth);
> +#endif
>  }
> 
>  static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
> @@ -1126,6 +1129,13 @@ static void yield_task_fair(struct rq *r
>  	se->vruntime = rightmost->vruntime + 1;
>  }
> 
> +#ifdef CONFIG_CFS_BANDWIDTH
> +static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
> +{
> +	return 1;

Hmmm.. what is 1? true?

> +}
> +#endif
> +
>  #ifdef CONFIG_SMP
> 
>  static void task_waking_fair(struct rq *rq, struct task_struct *p)

-- 
	Three Cheers,
	Balbir
