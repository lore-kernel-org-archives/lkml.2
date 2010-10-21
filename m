Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab0JUGFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:05:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59988 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0JUGFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:05:15 -0400
Date: Thu, 21 Oct 2010 11:34:15 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
Subject: Re: [RFC tg_shares_up improvements - v1 01/12] sched: rewrite
	tg_shares_up
Message-ID: <20101021060414.GA3581@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101016044349.830426011@google.com> <20101016045118.529238208@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016045118.529238208@google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:43:50PM -0700, pjt@google.com wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> By tracking a per-cpu load-avg for each cfs_rq and folding it into a
> global task_group load on each tick we can rework tg_shares_up to be
> strictly per-cpu.
> 
> This should improve cpu-cgroup performance for smp systems
> significantly.
> 
> [ Paul: changed to use queueing cfs_rq ]
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> Index: kernel/sched_fair.c
> ===================================================================
> --- kernel/sched_fair.c.orig
> +++ kernel/sched_fair.c
> @@ -417,7 +417,6 @@ int sched_proc_update_handler(struct ctl
>  	WRT_SYSCTL(sched_min_granularity);
>  	WRT_SYSCTL(sched_latency);
>  	WRT_SYSCTL(sched_wakeup_granularity);
> -	WRT_SYSCTL(sched_shares_ratelimit);
>  #undef WRT_SYSCTL
> 
>  	return 0;
> @@ -633,7 +632,6 @@ account_entity_enqueue(struct cfs_rq *cf
>  		list_add(&se->group_node, &cfs_rq->tasks);
>  	}
>  	cfs_rq->nr_running++;
> -	se->on_rq = 1;
>  }
> 
>  static void
> @@ -647,9 +645,89 @@ account_entity_dequeue(struct cfs_rq *cf
>  		list_del_init(&se->group_node);
>  	}
>  	cfs_rq->nr_running--;
> -	se->on_rq = 0;
>  }
> 
> +#if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
> +static void update_cfs_load(struct cfs_rq *cfs_rq)
> +{
> +	u64 period = sched_avg_period();
> +	u64 now, delta;
> +
> +	if (!cfs_rq)
> +		return;
> +
> +	now = rq_of(cfs_rq)->clock;
> +	delta = now - cfs_rq->load_stamp;
> +
> +	cfs_rq->load_stamp = now;
> +	cfs_rq->load_period += delta;
> +	cfs_rq->load_avg += delta * cfs_rq->load.weight;
> +
> +	while (cfs_rq->load_period > period) {
> +		/*
> +		 * Inline assembly required to prevent the compiler
> +		 * optimising this loop into a divmod call.
> +		 * See __iter_div_u64_rem() for another example of this.
> +		 */
> +		asm("" : "+rm" (cfs_rq->load_period));
> +		cfs_rq->load_period /= 2;
> +		cfs_rq->load_avg /= 2;
> +	}
> +}
> +
> +static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
> +			    unsigned long weight)
> +{
> +	if (se->on_rq)
> +		account_entity_dequeue(cfs_rq, se);
> +
> +	update_load_set(&se->load, weight);
> +
> +	if (se->on_rq)
> +		account_entity_enqueue(cfs_rq, se);
> +}
> +
> +static void update_cfs_shares(struct cfs_rq *cfs_rq)
> +{
> +	struct task_group *tg;
> +	struct sched_entity *se;
> +	long load_weight, load, shares;
> +
> +	if (!cfs_rq)
> +		return;
> +
> +	tg = cfs_rq->tg;
> +	se = tg->se[cpu_of(rq_of(cfs_rq))];
> +	if (!se)
> +		return;
> +
> +	load = cfs_rq->load.weight;
> +
> +	load_weight = atomic_read(&tg->load_weight);
> +	load_weight -= cfs_rq->load_contribution;
> +	load_weight += load;
> +
> +	shares = (tg->shares * load);
> +	if (load_weight)
> +		shares /= load_weight;
> +
> +	if (shares < MIN_SHARES)
> +		shares = MIN_SHARES;
> +	if (shares > tg->shares)
> +		shares = tg->shares;
> +
> +	reweight_entity(cfs_rq_of(se), se, shares);
> +}
> +#else /* CONFIG_FAIR_GROUP_SCHED */
> +static inline void update_cfs_load(struct cfs_rq *cfs_rq)
> +{
> +}
> +
> +static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
> +{
> +}
> +#endif /* CONFIG_FAIR_GROUP_SCHED */
> +
>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
>  #ifdef CONFIG_SCHEDSTATS
> @@ -771,7 +849,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>  	 * Update run-time statistics of the 'current'.
>  	 */
>  	update_curr(cfs_rq);
> +	update_cfs_load(cfs_rq);
>  	account_entity_enqueue(cfs_rq, se);

By placing update_cfs_load() before account_entity_enqueue(), you are
updating cfs_rq->load_avg before actually taking into account the current
load increment due to enqueing. I see same in dequeue also. Is there a
reason for this ?

> +	update_cfs_shares(cfs_rq_of(se));

Isn't cfs_rq_of(se) same as cfs_rq that enqueue_entity() gets
from enqueue_task_fair() ?  Same for dequeue case.

Regards,
Bharata.
