Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1AXSEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:04:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:51584 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1AXSEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:04:15 -0500
Subject: Re: [RFC -v6 PATCH 3/8] sched: use a buddy to implement
 yield_task_fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110120163355.4059c53e@annuminas.surriel.com>
References: <20110120163127.2568f4fe@annuminas.surriel.com>
	 <20110120163355.4059c53e@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 19:04:43 +0100
Message-ID: <1295892283.28776.455.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 16:33 -0500, Rik van Riel wrote:
> Use the buddy mechanism to implement yield_task_fair.  This
> allows us to skip onto the next highest priority se at every
> level in the CFS tree, unless doing so would introduce gross
> unfairness in CPU time distribution.
> 
> We order the buddy selection in pick_next_entity to check
> yield first, then last, then next.  We need next to be able
> to override yield, because it is possible for the "next" and
> "yield" task to be different processen in the same sub-tree
> of the CFS tree.  When they are, we need to go into that
> sub-tree regardless of the "yield" hint, and pick the correct
> entity once we get to the right level.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc91a4d..e4e57ff 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -327,7 +327,7 @@ struct cfs_rq {
>  	 * 'curr' points to currently running entity on this cfs_rq.
>  	 * It is set to NULL otherwise (i.e when none are currently running).
>  	 */
> -	struct sched_entity *curr, *next, *last;
> +	struct sched_entity *curr, *next, *last, *yield;

I'd prefer it be called: skip or somesuch..

>  	unsigned int nr_spread_over;
>  
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index ad946fd..f701a51 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -384,6 +384,22 @@ static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
>  	return rb_entry(left, struct sched_entity, run_node);
>  }
>  
> +static struct sched_entity *__pick_second_entity(struct cfs_rq *cfs_rq)
> +{
> +	struct rb_node *left = cfs_rq->rb_leftmost;
> +	struct rb_node *second;
> +
> +	if (!left)
> +		return NULL;
> +
> +	second = rb_next(left);
> +
> +	if (!second)
> +		second = left;
> +
> +	return rb_entry(second, struct sched_entity, run_node);
> +}

So this works because you only ever skip the leftmost, should we perhaps
write this as something like the below?

static struct sched_entity *__pick_next_entity(sched_entity *se)
{
	struct rb_node *next = rb_next(&se->run_node);
	if (!next)
		return NULL;
	return rb_entry(next, struct sched_entity, run_node);
}

>  static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
>  {
>  	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
> @@ -806,6 +822,17 @@ static void __clear_buddies_next(struct sched_entity *se)
>  	}
>  }
>  
> +static void __clear_buddies_yield(struct sched_entity *se)
> +{
> +	for_each_sched_entity(se) {
> +		struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +		if (cfs_rq->yield == se)
> +			cfs_rq->yield = NULL;
> +		else
> +			break;
> +	}
> +}
> +
>  static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
>  	if (cfs_rq->last == se)
> @@ -813,6 +840,9 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  
>  	if (cfs_rq->next == se)
>  		__clear_buddies_next(se);
> +
> +	if (cfs_rq->yield == se)
> +		__clear_buddies_yield(se);
>  }

The 3rd hierarchy iteration.. :/

>  static void
> @@ -926,13 +956,27 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  static int
>  wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
>  
> +/*
> + * Pick the next process, keeping these things in mind, in this order:
> + * 1) keep things fair between processes/task groups
> + * 2) pick the "next" process, since someone really wants that to run
> + * 3) pick the "last" process, for cache locality
> + * 4) do not run the "yield" process, if something else is available
> + */
>  static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
>  {
>  	struct sched_entity *se = __pick_next_entity(cfs_rq);
>  	struct sched_entity *left = se;
>  
> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
> -		se = cfs_rq->next;
> +	/*
> +	 * Avoid running the yield buddy, if running something else can
> +	 * be done without getting too unfair.
> +	 */
> +	if (cfs_rq->yield == se) {
> +		struct sched_entity *second = __pick_second_entity(cfs_rq);
> +		if (wakeup_preempt_entity(second, left) < 1)
> +			se = second;
> +	}
>  
>  	/*
>  	 * Prefer last buddy, try to return the CPU to a preempted task.
> @@ -940,6 +984,12 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
>  	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
>  		se = cfs_rq->last;
>  
> +	/*
> +	 * Someone really wants this to run. If it's not unfair, run it.
> +	 */
> +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
> +		se = cfs_rq->next;
> +
>  	clear_buddies(cfs_rq, se);
>  
>  	return se;

This seems to assume ->yield cannot be ->next nor ->last, but I'm not
quite sure that will actually be true.

> @@ -1096,52 +1146,6 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	hrtick_update(rq);
>  }
>  
> -/*
> - * sched_yield() support is very simple - we dequeue and enqueue.
> - *
> - * If compat_yield is turned on then we requeue to the end of the tree.
> - */
> -static void yield_task_fair(struct rq *rq)
> -{
> -	struct task_struct *curr = rq->curr;
> -	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
> -	struct sched_entity *rightmost, *se = &curr->se;
> -
> -	/*
> -	 * Are we the only task in the tree?
> -	 */
> -	if (unlikely(rq->nr_running == 1))
> -		return;
> -
> -	clear_buddies(cfs_rq, se);
> -
> -	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
> -		update_rq_clock(rq);
> -		/*
> -		 * Update run-time statistics of the 'current'.
> -		 */
> -		update_curr(cfs_rq);
> -
> -		return;
> -	}
> -	/*
> -	 * Find the rightmost entry in the rbtree:
> -	 */
> -	rightmost = __pick_last_entity(cfs_rq);
> -	/*
> -	 * Already in the rightmost position?
> -	 */
> -	if (unlikely(!rightmost || entity_before(rightmost, se)))
> -		return;
> -
> -	/*
> -	 * Minimally necessary key value to be last in the tree:
> -	 * Upon rescheduling, sched_class::put_prev_task() will place
> -	 * 'current' within the tree based on its new key value.
> -	 */
> -	se->vruntime = rightmost->vruntime + 1;
> -}
> -
>  #ifdef CONFIG_SMP
>  
>  static void task_waking_fair(struct rq *rq, struct task_struct *p)
> @@ -1660,6 +1664,14 @@ static void set_next_buddy(struct sched_entity *se)
>  	}
>  }
>  
> +static void set_yield_buddy(struct sched_entity *se)
> +{
> +	if (likely(task_of(se)->policy != SCHED_IDLE)) {
> +		for_each_sched_entity(se)
> +			cfs_rq_of(se)->yield = se;
> +	}
> +}
> +
>  /*
>   * Preempt the current task with a newly woken task if needed:
>   */
> @@ -1758,6 +1770,36 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
>  	}
>  }
>  
> +/*
> + * sched_yield() is very simple
> + *
> + * The magic of dealing with the ->yield buddy is in pick_next_entity.
> + */
> +static void yield_task_fair(struct rq *rq)
> +{
> +	struct task_struct *curr = rq->curr;
> +	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
> +	struct sched_entity *se = &curr->se;
> +
> +	/*
> +	 * Are we the only task in the tree?
> +	 */
> +	if (unlikely(rq->nr_running == 1))
> +		return;
> +
> +	clear_buddies(cfs_rq, se);
> +
> +	if (curr->policy != SCHED_BATCH) {
> +		update_rq_clock(rq);
> +		/*
> +		 * Update run-time statistics of the 'current'.
> +		 */
> +		update_curr(cfs_rq);
> +	}
> +
> +	set_yield_buddy(se);
> +}

You just lost sysctl_sched_compat_yield, someone might be upset (I
really can't be bothered much with people using sys_yield :-), but if
you're going down that road you want a hunk in kernel/sysctl.c as well I
think.

