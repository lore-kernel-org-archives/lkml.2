Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab2FMMby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:31:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:59611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2FMMbx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:31:53 -0400
Message-ID: <1339590696.8980.21.camel@twins>
Subject: Re: [PATCH v2] sched: balance_cpu to consider other cpus in its
 group as target of (pinned) task
From: Peter Zijlstra <peterz@infradead.org>
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, efault@gmx.de,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Jun 2012 14:31:36 +0200
In-Reply-To: <4FCF55E3.3020900@linux.vnet.ibm.com>
References: <4FCF55E3.3020900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 18:36 +0530, Prashanth Nageshappa wrote:
> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> Current load balance scheme lets one cpu in a sched_group (balance_cpu)
> look at other peer sched_groups for imbalance and pull tasks to
> itself from a busy cpu. Tasks thus pulled to balance_cpu will later get
> picked up by cpus that are in the same sched_group as that of balance_cpu.

Not strictly true.. but close enough I think.

> This scheme fails to pull tasks that are not allowed to run on
> balance_cpu (but are allowed to run on other cpus in its sched_group).
> 
> This can affect fairness and in some worst case scenarios cause
> starvation, as illustrated below. Consider a two core (2 threads/core)
> system running tasks as below:
> 
>         Core            Core
> 
>         C0 - F0         C2 - F1
>         C1 - T1         C3 - idle
> 
> F0 & F1 are SCHED_FIFO cpu hogs pinned to C0 & C2 respectively, while T1 is
> a SCHED_OTHER task pinned to C1. Another SCHED_OTHER task T2 (which can
> run on cpus 1,2) now wakes up and lands on its prev_cpu of C2, which is
> now running SCHED_FIFO cpu hog. To prevent starvation, T2 needs to move to C1.
> However between C0 & C1, C0 is chosen to balance its core with peer cores and
> thus fails to pull T2 towards its core (C0 not being in T2's affinity mask). T2 was
> found to starve eternally in this case.
> 
> Although the problem is illustrated in presence of rt tasks, this is a
> general problem that can manifest in presence of non-rt tasks as well.

If you can come up with a relatively simple example without rt tasks
that would be preferred. Also I think the above description could be
improved.

The graph only confuses me and I'm not sure the description is maximally
concise either.

> Some solutions that were considered to solve this problem were:
> 
> - Have the right sibling cpus to do load balance ignoring balance_cpu
> 
> - Modify move_tasks to move a pinned tasks to a sibling cpu in the
>   same sched_group as env->dst_cpu. This will involve some runqueue
>   lock juggling (a third runqueue locks needs to be taken when we
>   already have two locks held). Moreover we may be just fine to ignore
>   that particular task and meet load balance goals by moving other
>   tasks.
> 
> - Hint that move_tasks should be called with a different env->dst_cpu
> 
> This patch implements the 3rd of the above approach, which seemed least
> invasive. Essentially can_migrate_task() records if any task(s) were not moved
> as the destination cpu was not in the cpus_allowed mask of the target task(s)
> and the new destination cpu that task can be moved to. We reissue a call
> to move_tasks with that new destination cpu, provided we failed to meet
> load balance goal by moving other tasks from env->src_cpu.

Still no word on why doing a 3-way pull is ok.. (I think it is, I just
want you to convince me)..

> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
> 
> ----
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 939fd63..21a59fc 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3098,6 +3098,7 @@ static unsigned long __read_mostly max_load_balance_interval = HZ/10;
>  
>  #define LBF_ALL_PINNED	0x01
>  #define LBF_NEED_BREAK	0x02
> +#define LBF_NEW_DST_CPU	0x04

I still don't really like the new_dst_cpu name, I think it is because it
describes a solution detail, not a problem diagnosis.

> @@ -3198,7 +3201,26 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
>  	 * 3) are cache-hot on their current CPU.
>  	 */
>  	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
> -		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
> +		int new_dst_cpu;
> +
> +		if (!env->dst_grpmask) {
> +			schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
> +			return 0;
> +		}
> +
> +		/*
> +		 * remember if this task can be moved to any other cpus in our
> +		 * sched_group so that we can retry load balance and move
> +		 * that task to a new_dst_cpu if required.
> +		 */
> +		new_dst_cpu = cpumask_first_and(env->dst_grpmask,
> +						tsk_cpus_allowed(p));
> +		if (new_dst_cpu >= nr_cpu_ids) {
> +			schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
> +		} else {
> +			env->flags |= LBF_NEW_DST_CPU;
> +			env->new_dst_cpu = new_dst_cpu;
> +		}
>  		return 0;
>  	}

This wants a comment describing why we're doing this.. this also wants a
comment describing why we do what we do about multiple new_dst.. I think
we should do the cheap thing and not compute a new dst if we already
have one.

For bonus points you'll also add a comment for the all pinned muck,
although that's somewhat more obvious.

>  	env->flags &= ~LBF_ALL_PINNED;
> @@ -4440,7 +4462,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  			struct sched_domain *sd, enum cpu_idle_type idle,
>  			int *balance)
>  {
> -	int ld_moved, active_balance = 0;
> +	int ld_moved, cur_ld_moved, active_balance = 0;

better than the old_ld_moved, but still not really obvious.. maybe we
can cure this with a comment... 

>  	struct sched_group *group;
>  	struct rq *busiest;
>  	unsigned long flags;
> @@ -4450,6 +4472,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  		.sd		    = sd,
>  		.dst_cpu	    = this_cpu,
>  		.dst_rq		    = this_rq,
> +		.dst_grpmask	    = sched_group_cpus(sd->groups),
>  		.idle		    = idle,
>  		.loop_break	    = sched_nr_migrate_break,
>  		.find_busiest_queue = find_busiest_queue,
> @@ -4502,7 +4525,8 @@ more_balance:
>  		double_rq_lock(this_rq, busiest);
>  		if (!env.loop)
>  			update_h_load(env.src_cpu);
> -		ld_moved += move_tasks(&env);
> +		cur_ld_moved = move_tasks(&env);
> +		ld_moved += cur_ld_moved;
>  		double_rq_unlock(this_rq, busiest);
>  		local_irq_restore(flags);
>  
> @@ -4514,8 +4538,23 @@ more_balance:
>  		/*
>  		 * some other cpu did the load balance for us.

so add something here describing the cur_ld_moved vs ld_moved thing..

>  		 */

> +		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
> +			resched_cpu(env.dst_cpu);
> +
> +		if ((env.flags & LBF_NEW_DST_CPU) && (env.imbalance > 0)) {

Is this different from the last version?, ISTR only doing the loop again
when we didn't move anything.

> +			/*
> +			 * we could not balance completely as some tasks
> +			 * were not allowed to move to the dst_cpu, so try
> +			 * again with new_dst_cpu.
> +			 */
> +			this_rq = cpu_rq(env.new_dst_cpu);
> +			env.dst_rq = this_rq;
> +			env.dst_cpu = env.new_dst_cpu;
> +			env.flags &= ~LBF_NEW_DST_CPU;
> +			env.loop = 0;
> +			env.loop_break = sched_nr_migrate_break;
> +			goto more_balance;

What guarantees there's an end to this iteration? Also we explicitly use
more_balance over redo so that we're sure to iterate the same src cpu
because otherwise our new dst_cpu is meaningless? Sounds like something
that would be good to mention in .. wait for it .. a comment?

> +		}
>  
>  		/* All tasks on this runqueue were pinned by CPU affinity */
>  		if (unlikely(env.flags & LBF_ALL_PINNED)) {
> @@ -4716,6 +4755,7 @@ static int active_load_balance_cpu_stop(void *data)
>  			.sd		= sd,
>  			.dst_cpu	= target_cpu,
>  			.dst_rq		= target_rq,
> +			.dst_grpmask	= NULL,

This is superfluous, c99 initialization zeros all unmentioned members.

>  			.src_cpu	= busiest_rq->cpu,
>  			.src_rq		= busiest_rq,
>  			.idle		= CPU_IDLE,
> 

