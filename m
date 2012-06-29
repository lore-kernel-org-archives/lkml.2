Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab2F2HcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:32:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44818 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2F2HcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:32:11 -0400
X-AuditID: 9c930179-b7cceae000004195-18-4fed59f7f3e9
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
Subject: Re: [PATCH 12/16] sched: refactor update_shares_cpu() -> update_blocked_avgs()
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	<20120628022415.30496.57167.stgit@kitami.mtv.corp.google.com>
Date: Fri, 29 Jun 2012 16:28:22 +0900
In-Reply-To: <20120628022415.30496.57167.stgit@kitami.mtv.corp.google.com>
	(Paul Turner's message of "Wed, 27 Jun 2012 19:24:15 -0700")
Message-ID: <87pq8iwp9l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 19:24:15 -0700, Paul Turner wrote:
> Now that running entities maintain their own load-averages the work we must do
> in update_shares() is largely restricted to the periodic decay of blocked
> entities.  This allows us to be a little less pessimistic regarding our
> occupancy on rq->lock and the associated rq->clock updates required.
>
> Signed-off-by: Paul Turner <pjt@google.com>
> ---
>  kernel/sched/fair.c |   59 +++++++++++++++++++++++++++++----------------------
>  1 files changed, 33 insertions(+), 26 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4a9a828..dd1ef8a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3678,23 +3678,20 @@ out:
>  /*
>   * update tg->load_weight by folding this cpu's load_avg
>   */
> -static int update_shares_cpu(struct task_group *tg, int cpu)
> +static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
>  {
> -	struct sched_entity *se;
> -	struct cfs_rq *cfs_rq;
> -	unsigned long flags;
> -	struct rq *rq;
> -
> -
> -	rq = cpu_rq(cpu);
> -	se = tg->se[cpu];
> -	cfs_rq = tg->cfs_rq[cpu];
> +	struct sched_entity *se = tg->se[cpu];
> +	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
>  
> -	raw_spin_lock_irqsave(&rq->lock, flags);
> +	/* throttled entities do not contribute to load */
> +	if (throttled_hierarchy(cfs_rq))
> +		return;
>  
> -	update_rq_clock(rq);
>  	update_cfs_rq_blocked_load(cfs_rq, 1);
> -	update_entity_load_avg(tg->se[cpu], 1);
> +	if (se)
> +		update_entity_load_avg(se, 1);
> +	else
> +		update_rq_runnable_avg(rq_of(cfs_rq), 1);
>  
>  	if (se) {
>  		/*
> @@ -3707,29 +3704,39 @@ static int update_shares_cpu(struct task_group *tg, int cpu)
>  		else
>  			list_del_leaf_cfs_rq(cfs_rq);
>  	}
> -
> -	raw_spin_unlock_irqrestore(&rq->lock, flags);
> -
> -	return 0;
>  }
>  
> -static void update_shares(int cpu)
> +static void update_blocked_averages(int cpu)
>  {
> -	struct cfs_rq *cfs_rq;
>  	struct rq *rq = cpu_rq(cpu);
> +	struct cfs_rq *cfs_rq;
> +
> +	unsigned long flags;
> +	int num_updates = 0;
>  
>  	rcu_read_lock();
> +	raw_spin_lock_irqsave(&rq->lock, flags);
> +	update_rq_clock(rq);
>  	/*
>  	 * Iterates the task_group tree in a bottom up fashion, see
>  	 * list_add_leaf_cfs_rq() for details.
>  	 */
>  	for_each_leaf_cfs_rq(rq, cfs_rq) {
> -		/* throttled entities do not contribute to load */
> -		if (throttled_hierarchy(cfs_rq))
> -			continue;
> +		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
>  
> -		update_shares_cpu(cfs_rq->tg, cpu);
> +		/*
> +		 * Periodically release the lock so that a cfs_rq with many
> +		 * children cannot hold it for an arbitrary period of time.
> +		 */
> +		if (num_updates++ % 20 == 0) {

Should it be '++num_updates'? Otherwise, it'll release the lock at the
first iteration?

Thanks,
Namhyung


> +			raw_spin_unlock_irqrestore(&rq->lock, flags);
> +			cpu_relax();
> +			raw_spin_lock_irqsave(&rq->lock, flags);
> +			update_rq_clock(rq);
> +		}
>  	}
> +
> +	raw_spin_unlock_irqrestore(&rq->lock, flags);
>  	rcu_read_unlock();
>  }
>  
> @@ -3774,7 +3781,7 @@ unsigned long task_h_load(struct task_struct *p)
>  	return load;
>  }
>  #else
> -static inline void update_shares(int cpu)
> +static inline void update_blocked_averages(int cpu)
>  {
>  }
>  
> @@ -4936,7 +4943,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  	 */
>  	raw_spin_unlock(&this_rq->lock);
>  
> -	update_shares(this_cpu);
> +	update_blocked_averages(this_cpu);
>  	rcu_read_lock();
>  	for_each_domain(this_cpu, sd) {
>  		unsigned long interval;
> @@ -5196,7 +5203,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
>  	int update_next_balance = 0;
>  	int need_serialize;
>  
> -	update_shares(cpu);
> +	update_blocked_averages(cpu);
>  
>  	rcu_read_lock();
>  	for_each_domain(cpu, sd) {
