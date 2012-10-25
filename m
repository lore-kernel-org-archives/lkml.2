Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965553Ab2JYDsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:48:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50263 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964892Ab2JYDsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:48:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,645,1344182400"; 
   d="scan'208";a="6064414"
Subject: Re: [tip:sched/core] sched: Track the runnable average on a
 per-task entity basis
From: li guang <lig.fnst@cn.fujitsu.com>
To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-9d85f21c94f7f7a84d0ba686c58aa6d9da58fdbb@git.kernel.org>
References: <20120823141506.372695337@google.com>
	 <tip-9d85f21c94f7f7a84d0ba686c58aa6d9da58fdbb@git.kernel.org>
Date: Thu, 25 Oct 2012 11:28:22 +0800
Message-ID: <1351135702.22927.8.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:30:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/25 11:30:10,
	Serialize complete at 2012/10/25 11:30:10
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2012-10-24三的 02:43 -0700，tip-bot for Paul Turner写道：
> Commit-ID:  9d85f21c94f7f7a84d0ba686c58aa6d9da58fdbb
> Gitweb:     http://git.kernel.org/tip/9d85f21c94f7f7a84d0ba686c58aa6d9da58fdbb
> Author:     Paul Turner <pjt@google.com>
> AuthorDate: Thu, 4 Oct 2012 13:18:29 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 24 Oct 2012 10:27:18 +0200
> 
> sched: Track the runnable average on a per-task entity basis
> 
> Instead of tracking averaging the load parented by a cfs_rq, we can track
> entity load directly. With the load for a given cfs_rq then being the sum
> of its children.
> 
> To do this we represent the historical contribution to runnable average
> within each trailing 1024us of execution as the coefficients of a
> geometric series.
> 
> We can express this for a given task t as:
> 
>   runnable_sum(t) = \Sum u_i * y^i, runnable_avg_period(t) = \Sum 1024 * y^i
>   load(t) = weight_t * runnable_sum(t) / runnable_avg_period(t)
> 
> Where: u_i is the usage in the last i`th 1024us period (approximately 1ms)
> ~ms and y is chosen such that y^k = 1/2.  We currently choose k to be 32 which
> roughly translates to about a sched period.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Reviewed-by: Ben Segall <bsegall@google.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/20120823141506.372695337@google.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/linux/sched.h |   13 +++++
>  kernel/sched/core.c   |    5 ++
>  kernel/sched/debug.c  |    4 ++
>  kernel/sched/fair.c   |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 151 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0dd42a0..418fc6d 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1095,6 +1095,16 @@ struct load_weight {
>  	unsigned long weight, inv_weight;
>  };
>  
> +struct sched_avg {
> +	/*
> +	 * These sums represent an infinite geometric series and so are bound
> +	 * above by 1024/(1-y).  Thus we only need a u32 to store them for for all
> +	 * choices of y < 1-2^(-32)*1024.
> +	 */
> +	u32 runnable_avg_sum, runnable_avg_period;
> +	u64 last_runnable_update;
> +};
> +
>  #ifdef CONFIG_SCHEDSTATS
>  struct sched_statistics {
>  	u64			wait_start;
> @@ -1155,6 +1165,9 @@ struct sched_entity {
>  	/* rq "owned" by this entity/group: */
>  	struct cfs_rq		*my_q;
>  #endif
> +#ifdef CONFIG_SMP
> +	struct sched_avg	avg;
> +#endif
>  };
>  
>  struct sched_rt_entity {
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2d8927f..fd9d085 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1524,6 +1524,11 @@ static void __sched_fork(struct task_struct *p)
>  	p->se.vruntime			= 0;
>  	INIT_LIST_HEAD(&p->se.group_node);
>  
> +#ifdef CONFIG_SMP
> +	p->se.avg.runnable_avg_period = 0;
> +	p->se.avg.runnable_avg_sum = 0;
> +#endif
> +
>  #ifdef CONFIG_SCHEDSTATS
>  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>  #endif
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 6f79596..61f7097 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -85,6 +85,10 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>  	P(se->statistics.wait_count);
>  #endif
>  	P(se->load.weight);
> +#ifdef CONFIG_SMP
> +	P(se->avg.runnable_avg_sum);
> +	P(se->avg.runnable_avg_period);
> +#endif
>  #undef PN
>  #undef P
>  }
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6b800a1..16d67f9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -971,6 +971,126 @@ static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
>  }
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>  
> +#ifdef CONFIG_SMP
> +/*
> + * Approximate:
> + *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
> + */
> +static __always_inline u64 decay_load(u64 val, u64 n)
> +{
> +	for (; n && val; n--) {
> +		val *= 4008;
> +		val >>= 12;
> +	}
> +
> +	return val;
> +}
> +
> +/*
> + * We can represent the historical contribution to runnable average as the
> + * coefficients of a geometric series.  To do this we sub-divide our runnable
> + * history into segments of approximately 1ms (1024us); label the segment that
> + * occurred N-ms ago p_N, with p_0 corresponding to the current period, e.g.
> + *
> + * [<- 1024us ->|<- 1024us ->|<- 1024us ->| ...
> + *      p0            p1           p2
> + *     (now)       (~1ms ago)  (~2ms ago)
> + *
> + * Let u_i denote the fraction of p_i that the entity was runnable.
> + *
> + * We then designate the fractions u_i as our co-efficients, yielding the
> + * following representation of historical load:
> + *   u_0 + u_1*y + u_2*y^2 + u_3*y^3 + ...
> + *
> + * We choose y based on the with of a reasonably scheduling period, fixing:
> + *   y^32 = 0.5
> + *
> + * This means that the contribution to load ~32ms ago (u_32) will be weighted
> + * approximately half as much as the contribution to load within the last ms
> + * (u_0).
> + *
> + * When a period "rolls over" and we have new u_0`, multiplying the previous
> + * sum again by y is sufficient to update:
> + *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
> + *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
> + */
> +static __always_inline int __update_entity_runnable_avg(u64 now,
> +							struct sched_avg *sa,
> +							int runnable)
> +{
> +	u64 delta;
> +	int delta_w, decayed = 0;
> +
> +	delta = now - sa->last_runnable_update;
> +	/*
> +	 * This should only happen when time goes backwards, which it
> +	 * unfortunately does during sched clock init when we swap over to TSC.
> +	 */
> +	if ((s64)delta < 0) {
> +		sa->last_runnable_update = now;
> +		return 0;
> +	}
> +
> +	/*
> +	 * Use 1024ns as the unit of measurement since it's a reasonable
> +	 * approximation of 1us and fast to compute.
> +	 */
> +	delta >>= 10;
> +	if (!delta)
> +		return 0;
> +	sa->last_runnable_update = now;
> +
> +	/* delta_w is the amount already accumulated against our next period */
> +	delta_w = sa->runnable_avg_period % 1024;
> +	if (delta + delta_w >= 1024) {
> +		/* period roll-over */
> +		decayed = 1;
> +
> +		/*
> +		 * Now that we know we're crossing a period boundary, figure
> +		 * out how much from delta we need to complete the current
> +		 * period and accrue it.
> +		 */
> +		delta_w = 1024 - delta_w;
> +		BUG_ON(delta_w > delta);
> +		do {
> +			if (runnable)
> +				sa->runnable_avg_sum += delta_w;
> +			sa->runnable_avg_period += delta_w;
> +
> +			/*
> +			 * Remainder of delta initiates a new period, roll over
> +			 * the previous.
> +			 */
> +			sa->runnable_avg_sum =
> +				decay_load(sa->runnable_avg_sum, 1);

Is this u0+u1*y+u2*y^2+u3*y^3 ...,
seems no, this is u0+u1*y+u2*y+u3*y+u4*y ...

> +			sa->runnable_avg_period =
> +				decay_load(sa->runnable_avg_period, 1);
> +
> +			delta -= delta_w;
> +			/* New period is empty */
> +			delta_w = 1024;
> +		} while (delta >= 1024);
> +	}
> +
> +	/* Remainder of delta accrued against u_0` */
> +	if (runnable)
> +		sa->runnable_avg_sum += delta;
> +	sa->runnable_avg_period += delta;
> +
> +	return decayed;
> +}
> +
> +/* Update a sched_entity's runnable average */
> +static inline void update_entity_load_avg(struct sched_entity *se)
> +{
> +	__update_entity_runnable_avg(rq_of(cfs_rq_of(se))->clock_task, &se->avg,
> +				     se->on_rq);
> +}
> +#else
> +static inline void update_entity_load_avg(struct sched_entity *se) {}
> +#endif
> +
>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
>  #ifdef CONFIG_SCHEDSTATS
> @@ -1097,6 +1217,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	 */
>  	update_curr(cfs_rq);
>  	update_cfs_load(cfs_rq, 0);
> +	update_entity_load_avg(se);
>  	account_entity_enqueue(cfs_rq, se);
>  	update_cfs_shares(cfs_rq);
>  
> @@ -1171,6 +1292,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	 * Update run-time statistics of the 'current'.
>  	 */
>  	update_curr(cfs_rq);
> +	update_entity_load_avg(se);
>  
>  	update_stats_dequeue(cfs_rq, se);
>  	if (flags & DEQUEUE_SLEEP) {
> @@ -1340,6 +1462,8 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
>  		update_stats_wait_start(cfs_rq, prev);
>  		/* Put 'current' back into the tree. */
>  		__enqueue_entity(cfs_rq, prev);
> +		/* in !on_rq case, update occurred at dequeue */
> +		update_entity_load_avg(prev);
>  	}
>  	cfs_rq->curr = NULL;
>  }
> @@ -1353,6 +1477,11 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>  	update_curr(cfs_rq);
>  
>  	/*
> +	 * Ensure that runnable average is periodically updated.
> +	 */
> +	update_entity_load_avg(curr);
> +
> +	/*
>  	 * Update share accounting for long-running entities.
>  	 */
>  	update_entity_shares_tick(cfs_rq);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
liguang    lig.fnst@cn.fujitsu.com
FNST linux kernel team

