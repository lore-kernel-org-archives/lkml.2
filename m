Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2F1GKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:10:06 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47854 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932579Ab2F1GKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:10:01 -0400
X-AuditID: 9c93016f-b7c85ae00000559e-3a-4febf537d055
From: Namhyung Kim <namhyung@kernel.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/16] sched: track the runnable average on a per-task entitiy basis
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	<20120628022414.30496.98256.stgit@kitami.mtv.corp.google.com>
Date: Thu, 28 Jun 2012 15:06:10 +0900
In-Reply-To: <20120628022414.30496.98256.stgit@kitami.mtv.corp.google.com>
	(Paul Turner's message of "Wed, 27 Jun 2012 19:24:14 -0700")
Message-ID: <87pq8kx965.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some nitpicks and questions.


On Wed, 27 Jun 2012 19:24:14 -0700, Paul Turner wrote:
> Instead of tracking averaging the load parented by a cfs_rq, we can track
> entity load directly.  With the load for a given cfs_Rq then being the sum of

s/cfs_Rq/cfs_rq/


> its children.
>
> To do this we represent the historical contribution to runnable average within each
> trailing 1024us of execution as the coefficients of a geometric series.
>
> We can express this for a given task t as:
>   runnable_sum(t) = \Sum u_i * y^i ,
>   load(t) = weight_t * runnable_sum(t) / (\Sum 1024 * y^i)
>

This "\Sum 1024 *y^i" is the runnable(_avg)_period, right?


> Where: u_i is the usage in the last i`th 1024us period (approximately 1ms) ~ms
> and y is chosen such that y^k = 1/2.  We currently choose k to be 32 which
> roughly translates to about a sched period.
>
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  include/linux/sched.h |    8 +++
>  kernel/sched/debug.c  |    4 ++
>  kernel/sched/fair.c   |  128 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 140 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 9dced2e..5bf5c79 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1136,6 +1136,11 @@ struct load_weight {
>  	unsigned long weight, inv_weight;
>  };
>  
> +struct sched_avg {
> +	u32 runnable_avg_sum, runnable_avg_period;
> +	u64 last_runnable_update;
> +};
> +
>  #ifdef CONFIG_SCHEDSTATS
>  struct sched_statistics {
>  	u64			wait_start;
> @@ -1196,6 +1201,9 @@ struct sched_entity {
>  	/* rq "owned" by this entity/group: */
>  	struct cfs_rq		*my_q;
>  #endif
> +#ifdef CONFIG_SMP
> +	struct sched_avg	avg;
> +#endif
>  };
>  
>  struct sched_rt_entity {
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index c09a4e7..cd5ef23 100644
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
> index 3704ad3..864a122 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -976,6 +976,125 @@ static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
>  }
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>  
> +#ifdef CONFIG_SMP
> +/*
> + * Approximate:
> + *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
> + */
> +static __always_inline u64 decay_load(u64 val, int n)
> +{
> +	for (; n && val; n--) {
> +		val *= 4008;
> +		val >>= 12;
> +	}
> +
> +	return val;
> +}
> +
> +/* We can represent the historical contribution to runnable average as the
> + * coefficients of a geometric series.  To do this we sub-divide our runnable
> + * history into segments of approximately 1ms (1024us); label the segment that
> + * occurred N-ms ago p_N, with p_0 corresponding to the current period, e.g.
> + *
> + * [<- 1024us ->|<- 1024us ->|<- 1024us ->| ...
> + *      p0            p1           p1
                                      p2

> + *     (now)       (~1ms ago)  (~2ms ago)
> + *
> + * Let u_i denote the fraction of p_i that the entity was runnable.
> + *
> + * We then designate the fractions u_i as our co-efficients, yielding the
> + * following representation of historical load:
> + *   u_0 + u_1*y + u_2*y^2 + u_3*y^3 + ...
> + *
> + * We choose y based on the with of a reasonably scheduling period, fixing:
                               width ?
> + *   y^32 = 0.5
> + *
> + * This means that the contribution to load ~32ms ago (u_32) will be weighted
> + * approximately half as much as the contribution to load within the last ms
> + * (u_0).
> + *
> + * When a period "rolls over" and we have new u_0`, multiplying the previous
> + * sum again by y is sufficient to update:
> + *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
> + *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1]
                                                                    u_{i+1}]

> + */
> +static __always_inline int __update_entity_runnable_avg(u64 now,

Is the return value used by elsewhere?

Thanks,
Namhyung


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
> @@ -1102,6 +1221,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	 */
>  	update_curr(cfs_rq);
>  	update_cfs_load(cfs_rq, 0);
> +	update_entity_load_avg(se);
>  	account_entity_enqueue(cfs_rq, se);
>  	update_cfs_shares(cfs_rq);
>  
> @@ -1176,6 +1296,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	 * Update run-time statistics of the 'current'.
>  	 */
>  	update_curr(cfs_rq);
> +	update_entity_load_avg(se);
>  
>  	update_stats_dequeue(cfs_rq, se);
>  	if (flags & DEQUEUE_SLEEP) {
> @@ -1345,6 +1466,8 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
>  		update_stats_wait_start(cfs_rq, prev);
>  		/* Put 'current' back into the tree. */
>  		__enqueue_entity(cfs_rq, prev);
> +		/* in !on_rq case, update occurred at dequeue */
> +		update_entity_load_avg(prev);
>  	}
>  	cfs_rq->curr = NULL;
>  }
> @@ -1358,6 +1481,11 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
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
