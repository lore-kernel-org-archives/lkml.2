Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0JOEqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:46:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41843 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab0JOEqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:46:02 -0400
Date: Fri, 15 Oct 2010 10:15:52 +0530
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
Subject: Re: [PATCH v3 4/7] sched: unthrottle cfs_rq(s) who ran out of quota
 at period refresh
Message-ID: <20101015044552.GI13048@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
 <20101012075247.GE9893@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101012075247.GE9893@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bharata B Rao <bharata@linux.vnet.ibm.com> [2010-10-12 13:22:47]:

> sched: unthrottle cfs_rq(s) who ran out of quota at period refresh
> 
> From: Paul Turner <pjt@google.com>
> 
> At the start of a new period there are several actions we must take:
> - Refresh global bandwidth pool
> - Unthrottle entities who ran out of quota as refreshed bandwidth permits
> 
> Unthrottled entities have the cfs_rq->throttled flag set and are re-enqueued
> into the cfs entity hierarchy.
>

Am I reading this right?
 
> sched_rt_period_mask() is refactored slightly into sched_bw_period_mask()
> since it is now shared by both cfs and rt bandwidth period timers.
> 
> The !CONFIG_RT_GROUP_SCHED && CONFIG_SMP case has been collapsed to use
> rd->span instead of cpu_online_mask since I think that was incorrect before
> (don't want to hit cpu's outside of your root_domain for RT bandwidth).
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---
>  kernel/sched.c      |   16 ++++++++++++
>  kernel/sched_fair.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/sched_rt.c   |   19 --------------
>  3 files changed, 84 insertions(+), 19 deletions(-)
> 
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1565,6 +1565,8 @@ static int tg_nop(struct task_group *tg,
>  }
>  #endif
> 
> +static inline const struct cpumask *sched_bw_period_mask(void);
> +
>  #ifdef CONFIG_SMP
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
> @@ -1933,6 +1935,18 @@ static inline void __set_task_cpu(struct
> 
>  static const struct sched_class rt_sched_class;
> 
> +#ifdef CONFIG_SMP
> +static inline const struct cpumask *sched_bw_period_mask(void)
> +{
> +	return cpu_rq(smp_processor_id())->rd->span;
> +}
> +#else
> +static inline const struct cpumask *sched_bw_period_mask(void)
> +{
> +	return cpu_online_mask;
> +}
> +#endif
> +
>  #ifdef CONFIG_CFS_BANDWIDTH
>  /*
>   * default period for cfs group bandwidth.
> @@ -8937,6 +8951,8 @@ static int tg_set_cfs_bandwidth(struct t
> 
>  		raw_spin_lock_irq(&rq->lock);
>  		init_cfs_rq_quota(cfs_rq);
> +		if (cfs_rq_throttled(cfs_rq))
> +			unthrottle_cfs_rq(cfs_rq);
>  		raw_spin_unlock_irq(&rq->lock);
>  	}
>  	mutex_unlock(&mutex);
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -268,6 +268,13 @@ find_matching_se(struct sched_entity **s
>  #endif	/* CONFIG_FAIR_GROUP_SCHED */
> 
>  #ifdef CONFIG_CFS_BANDWIDTH
> +static inline
> +struct cfs_rq *cfs_bandwidth_cfs_rq(struct cfs_bandwidth *cfs_b, int cpu)
> +{

Nit pick, but I'd call this function cfs_bandwidth_cfs_cpu_rq

> +	return container_of(cfs_b, struct task_group,
> +			cfs_bandwidth)->cfs_rq[cpu];
> +}
> +
>  static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
>  {
>  	return &tg->cfs_bandwidth;
> @@ -1219,6 +1226,29 @@ out_throttled:
>  	cfs_rq->throttled = 1;
>  }
> 
> +static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
> +{
> +	struct sched_entity *se;
> +	struct rq *rq = rq_of(cfs_rq);
> +
> +	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> +
> +	cfs_rq->throttled = 0;
> +	for_each_sched_entity(se) {
> +		if (se->on_rq)
> +			break;
> +
> +		cfs_rq = cfs_rq_of(se);
> +		enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);

Should we really enqueue with ENQUEUE_WAKEUP - the task throttled, not
slept.

> +		if (cfs_rq_throttled(cfs_rq))
> +			break;
> +	}
> +
> +	/* determine whether we need to wake up potentally idle cpu */
> +	if (rq->curr == rq->idle && rq->cfs.nr_running)
> +		resched_task(rq->curr);
> +}
> +
>  static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
>  		unsigned long delta_exec)
>  {
> @@ -1241,8 +1271,44 @@ static void account_cfs_rq_quota(struct 
> 
>  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>  {
> -	return 1;
> +	int i, idle = 1;
> +	u64 delta;
> +	const struct cpumask *span;
> +
> +	if (cfs_b->quota == RUNTIME_INF)
> +		return 1;

I am afraid I don't understand how return codes are being used here.
idle is set to 1 if there are no running tasks across all CPUs. Why do
we return a 1 from here?

> +
> +	/* reset group quota */
> +	raw_spin_lock(&cfs_b->lock);
> +	cfs_b->runtime = cfs_b->quota;
> +	raw_spin_unlock(&cfs_b->lock);
> +
> +	span = sched_bw_period_mask();
> +	for_each_cpu(i, span) {
> +		struct rq *rq = cpu_rq(i);
> +		struct cfs_rq *cfs_rq = cfs_bandwidth_cfs_rq(cfs_b, i);
> +
> +		if (cfs_rq->nr_running)
> +			idle = 0;
> +
> +		if (!cfs_rq_throttled(cfs_rq))
> +			continue;
> +
> +		delta = tg_request_cfs_quota(cfs_rq->tg);
> +
> +		if (delta) {
> +			raw_spin_lock(&rq->lock);
> +			cfs_rq->quota_assigned += delta;
> +
> +			if (cfs_rq->quota_used < cfs_rq->quota_assigned)
> +				unthrottle_cfs_rq(cfs_rq);
> +			raw_spin_unlock(&rq->lock);
> +		}
> +	}
> +
> +	return idle;
>  }
> +
>  #endif
> 
>  #ifdef CONFIG_SMP
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -241,18 +241,6 @@ static int rt_se_boosted(struct sched_rt
>  	return p->prio != p->normal_prio;
>  }
> 
> -#ifdef CONFIG_SMP
> -static inline const struct cpumask *sched_rt_period_mask(void)
> -{
> -	return cpu_rq(smp_processor_id())->rd->span;
> -}
> -#else
> -static inline const struct cpumask *sched_rt_period_mask(void)
> -{
> -	return cpu_online_mask;
> -}
> -#endif
> -
>  static inline
>  struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
>  {
> @@ -302,11 +290,6 @@ static inline int rt_rq_throttled(struct
>  	return rt_rq->rt_throttled;
>  }
> 
> -static inline const struct cpumask *sched_rt_period_mask(void)
> -{
> -	return cpu_online_mask;
> -}
> -
>  static inline
>  struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
>  {
> @@ -524,7 +507,7 @@ static int do_sched_rt_period_timer(stru
>  	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
>  		return 1;
> 
> -	span = sched_rt_period_mask();
> +	span = sched_bw_period_mask();
>  	for_each_cpu(i, span) {
>  		int enqueue = 0;
>  		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);

-- 
	Three Cheers,
	Balbir
