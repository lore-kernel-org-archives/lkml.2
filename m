Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2F1Ghl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:37:41 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44763 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2F1Ghj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:37:39 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-27-4febfbaaab72
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
Subject: Re: [PATCH 03/16] sched: aggregate load contributed by task entities on parenting cfs_rq
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	<20120628022414.30496.73426.stgit@kitami.mtv.corp.google.com>
Date: Thu, 28 Jun 2012 15:33:39 +0900
In-Reply-To: <20120628022414.30496.73426.stgit@kitami.mtv.corp.google.com>
	(Paul Turner's message of "Wed, 27 Jun 2012 19:24:14 -0700")
Message-ID: <87lij8x7wc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 19:24:14 -0700, Paul Turner wrote:
> For a given task t, we can compute its contribution to load as:
>   task_load(t) = runnable_avg(t) * weight(t)
>
> On a parenting cfs_rq we can then aggregate
>   runnable_load(cfs_rq) = \Sum task_load(t), for all runnable children t
>
> Maintain this bottom up, with task entities adding their contributed load to
> the parenting cfs_rq sum.  When a task entities load changes we add the same
                                         entity's ?

> delta to the maintained sum.
>
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Ben Segall <bsegall@google.com>
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/debug.c  |    3 +++
>  kernel/sched/fair.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++----
>  kernel/sched/sched.h  |   10 +++++++++-
>  4 files changed, 60 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5bf5c79..0c54ce0 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1139,6 +1139,7 @@ struct load_weight {
>  struct sched_avg {
>  	u32 runnable_avg_sum, runnable_avg_period;
>  	u64 last_runnable_update;
> +	unsigned long load_avg_contrib;
>  };
>  
>  #ifdef CONFIG_SCHEDSTATS
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 5d4a7dd..aeb74e3 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -94,6 +94,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>  #ifdef CONFIG_SMP
>  	P(se->avg.runnable_avg_sum);
>  	P(se->avg.runnable_avg_period);
> +	P(se->avg.load_avg_contrib);
>  #endif
>  #undef PN
>  #undef P
> @@ -227,6 +228,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>  			cfs_rq->load_contribution);
>  	SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
>  			atomic_read(&cfs_rq->tg->load_weight));
> +	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
> +			cfs_rq->runnable_load_avg);
>  #endif
>  
>  	print_cfs_group_stats(m, cpu, cfs_rq->tg);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 08bd3e0..8229766 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1085,20 +1085,63 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>  	return decayed;
>  }
>  
> +/* Compute the current contribution to load_avg by se, return any delta */
> +static long __update_entity_load_avg_contrib(struct sched_entity *se)
> +{
> +	long old_contrib = se->avg.load_avg_contrib;
> +
> +	if (!entity_is_task(se))
> +		return 0;
> +
> +	se->avg.load_avg_contrib = div64_u64(se->avg.runnable_avg_sum *
> +					     se->load.weight,
> +					     se->avg.runnable_avg_period + 1);
> +
> +	return se->avg.load_avg_contrib - old_contrib;
> +}
> +
>  /* Update a sched_entity's runnable average */
>  static inline void update_entity_load_avg(struct sched_entity *se)
>  {
> -	__update_entity_runnable_avg(rq_of(cfs_rq_of(se))->clock_task, &se->avg,
> -				     se->on_rq);
> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +	long contrib_delta;
> +
> +	if (!__update_entity_runnable_avg(rq_of(cfs_rq)->clock_task, &se->avg,
> +					  se->on_rq))

Ok, now I see that the return value is used here.

Thanks,
Namhyung


> +		return;
> +
> +	contrib_delta = __update_entity_load_avg_contrib(se);
> +	if (se->on_rq)
> +		cfs_rq->runnable_load_avg += contrib_delta;
>  }
>  
>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>  {
>  	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
>  }
> +
> +/* Add the load generated by se into cfs_rq's child load-average */
> +static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
> +						  struct sched_entity *se)
> +{
> +	update_entity_load_avg(se);
> +	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
> +}
> +
> +/* Remove se's load from this cfs_rq child load-average */
> +static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
> +						  struct sched_entity *se)
> +{
> +	update_entity_load_avg(se);
> +	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
> +}
>  #else
>  static inline void update_entity_load_avg(struct sched_entity *se) {}
>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
> +static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
> +						  struct sched_entity *se) {}
> +static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
> +						  struct sched_entity *se) {}
>  #endif
>  
>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
> @@ -1227,7 +1270,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	 */
>  	update_curr(cfs_rq);
>  	update_cfs_load(cfs_rq, 0);
> -	update_entity_load_avg(se);
> +	enqueue_entity_load_avg(cfs_rq, se);
>  	account_entity_enqueue(cfs_rq, se);
>  	update_cfs_shares(cfs_rq);
>  
> @@ -1302,7 +1345,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	 * Update run-time statistics of the 'current'.
>  	 */
>  	update_curr(cfs_rq);
> -	update_entity_load_avg(se);
> +	dequeue_entity_load_avg(cfs_rq, se);
>  
>  	update_stats_dequeue(cfs_rq, se);
>  	if (flags & DEQUEUE_SLEEP) {
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index bfdb119..26cc36f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -222,6 +222,15 @@ struct cfs_rq {
>  	unsigned int nr_spread_over;
>  #endif
>  
> +#ifdef CONFIG_SMP
> +	/*
> +	 * CFS Load tracking
> +	 * Under CFS, load is tracked on a per-entity basis and aggregated up.
> +	 * This allows for the description of both thread and group usage (in
> +	 * the FAIR_GROUP_SCHED case).
> +	 */
> +	u64 runnable_load_avg;
> +#endif
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
>  
> @@ -1204,4 +1213,3 @@ static inline void account_numa_dequeue(struct task_struct *p) { }
>  static inline void init_sched_numa(void) { }
>  
>  #endif /* CONFIG_NUMA */
> -
