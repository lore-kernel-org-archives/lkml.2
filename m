Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2HPJyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:54:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:51707 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2HPJyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:54:09 -0400
Message-ID: <1345110832.29668.12.camel@twins>
Subject: Re: [PATCH RFC] sched: Make migration_call() safe for
 stop_machine()-free hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com
Date: Thu, 16 Aug 2012 11:53:52 +0200
In-Reply-To: <20120725215126.GA7350@linux.vnet.ibm.com>
References: <20120725215126.GA7350@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 14:51 -0700, Paul E. McKenney wrote:
> The CPU_DYING branch of migration_call() relies on the fact that
> CPU-hotplug offline operations use stop_machine().  This commit therefore
> attempts to remedy this situation by acquiring the relevant runqueue
> locks.  Note that sched_ttwu_pending() remains outside of the scope of
> these new runqueue-lock critical sections because (1) sched_ttwu_pending()
> does its own runqueue-lock acquisition and (2) sched_ttwu_pending() handles
> pending wakeups, and no further wakeups can select this CPU because it
> is already marked as offline.
> 
> It is quite possible that migrate_nr_uninterruptible() 

The rules for nr_uninterruptible are that only the local cpu modifies
its own count -- with the exception for the offline case where someone
else picks up the remnant, which we assume is stable for the recently
dead cpu.

Only the direct sum over all cpus of nr_uninterruptible is meaningful,
see nr_uninterruptible() and the somewhat big comment titled "Global
load-average calculations".

> and
> calc_global_load_remove() somehow don't need runqueue-lock protection,
> but I was not able to prove this to myself.

It shouldn't need it, the offlined cpu's value should be stable and the
modification is to a global atomic with the proper atomic operation.

> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Gotta love this new schizophrenic you.. :-) I'm quite content with one
functional email addr from you there.

> ---
> 
>  core.c |   21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index eaead2d..2e7797a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5175,10 +5175,8 @@ void idle_task_exit(void)
>   * their home CPUs. So we just add the counter to another CPU's counter,
>   * to keep the global sum constant after CPU-down:
>   */
> -static void migrate_nr_uninterruptible(struct rq *rq_src)
> +static void migrate_nr_uninterruptible(struct rq *rq_src, struct rq *rq_dest)
>  {
> -	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
> -
>  	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
>  	rq_src->nr_uninterruptible = 0;
>  }
> @@ -5200,7 +5198,7 @@ static void calc_global_load_remove(struct rq *rq)
>   * there's no concurrency possible, we hold the required locks anyway
>   * because of lock validation efforts.
>   */
> -static void migrate_tasks(unsigned int dead_cpu)
> +static void migrate_tasks(unsigned int dead_cpu, struct rq *rq_dest)
>  {
>  	struct rq *rq = cpu_rq(dead_cpu);
>  	struct task_struct *next, *stop = rq->stop;
> @@ -5234,11 +5232,11 @@ static void migrate_tasks(unsigned int dead_cpu)
>  
>  		/* Find suitable destination for @next, with force if needed. */
>  		dest_cpu = select_fallback_rq(dead_cpu, next);
> -		raw_spin_unlock(&rq->lock);
> +		double_rq_unlock(rq, rq_dest);
>  
>  		__migrate_task(next, dead_cpu, dest_cpu);
>  
> -		raw_spin_lock(&rq->lock);
> +		double_rq_lock(rq, rq_dest);

I would almost propose adding ___migrate_task() to avoid the
unlock-lock-unlock-lock dance there, possibly there's a better name
though :-)

>  	}
>  
>  	rq->stop = stop;
> @@ -5452,6 +5450,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  	int cpu = (long)hcpu;
>  	unsigned long flags;
>  	struct rq *rq = cpu_rq(cpu);
> +	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));

I realize you took this from migrate_nr_uninterruptible(), but I think
its actually wrong now, given the rules for nr_uninterruptible. But in
general it seems to make more sense to pull stuff towards the operating
cpu than to a random other cpu, no?

>  	switch (action & ~CPU_TASKS_FROZEN) {
>  
> @@ -5474,17 +5473,19 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  	case CPU_DYING:
>  		sched_ttwu_pending();
>  		/* Update our root-domain */
> -		raw_spin_lock_irqsave(&rq->lock, flags);
> +		local_irq_save(flags);
> +		double_rq_lock(rq, rq_dest);
>  		if (rq->rd) {
>  			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
>  			set_rq_offline(rq);
>  		}
> -		migrate_tasks(cpu);
> +		migrate_tasks(cpu, rq_dest);
>  		BUG_ON(rq->nr_running != 1); /* the migration thread */
> -		raw_spin_unlock_irqrestore(&rq->lock, flags);
>  
> -		migrate_nr_uninterruptible(rq);
> +		migrate_nr_uninterruptible(rq, rq_dest);
>  		calc_global_load_remove(rq);
> +		double_rq_unlock(rq, rq_dest);
> +		local_irq_restore(flags);
>  		break;
>  #endif
>  	}
> 

