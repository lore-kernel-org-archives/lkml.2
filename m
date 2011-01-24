Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1AXSMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:12:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1AXSL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:11:58 -0500
Subject: Re: [RFC -v6 PATCH 4/8] sched: Add yield_to(task, preempt)
 functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <20110120163443.762c2409@annuminas.surriel.com>
References: <20110120163127.2568f4fe@annuminas.surriel.com>
	 <20110120163443.762c2409@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 19:12:28 +0100
Message-ID: <1295892748.28776.463.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 16:34 -0500, Rik van Riel wrote:
> From: Mike Galbraith <efault@gmx.de>
> 
> Currently only implemented for fair class tasks.
> 
> Add a yield_to_task method() to the fair scheduling class. allowing the
> caller of yield_to() to accelerate another thread in it's thread group,
> task group.
> 
> Implemented via a scheduler hint, using cfs_rq->next to encourage the
> target being selected.  We can rely on pick_next_entity to keep things
> fair, so noone can accelerate a thread that has already used its fair
> share of CPU time.
> 
> This also means callers should only call yield_to when they really
> mean it.  Calling it too often can result in the scheduler just
> ignoring the hint.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Mike Galbraith <efault@gmx.de>

Patch 5 wants to be merged back in here I think..

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2c79e92..6c43fc4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1047,6 +1047,7 @@ struct sched_class {
>  	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
>  	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
>  	void (*yield_task) (struct rq *rq);
> +	bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
>  
>  	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
>  
> @@ -1943,6 +1944,7 @@ static inline int rt_mutex_getprio(struct task_struct *p)
>  # define rt_mutex_adjust_pi(p)		do { } while (0)
>  #endif
>  
> +extern bool yield_to(struct task_struct *p, bool preempt);
>  extern void set_user_nice(struct task_struct *p, long nice);
>  extern int task_prio(const struct task_struct *p);
>  extern int task_nice(const struct task_struct *p);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e4e57ff..1f38ed2 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5270,6 +5270,64 @@ void __sched yield(void)
>  }
>  EXPORT_SYMBOL(yield);
>  
> +/**
> + * yield_to - yield the current processor to another thread in
> + * your thread group, or accelerate that thread toward the
> + * processor it's on.
> + *
> + * It's the caller's job to ensure that the target task struct
> + * can't go away on us before we can do any checks.
> + *
> + * Returns true if we indeed boosted the target task.
> + */
> +bool __sched yield_to(struct task_struct *p, bool preempt)
> +{
> +	struct task_struct *curr = current;
> +	struct rq *rq, *p_rq;
> +	unsigned long flags;
> +	bool yielded = 0;
> +
> +	local_irq_save(flags);
> +	rq = this_rq();
> +
> +again:
> +	p_rq = task_rq(p);
> +	double_rq_lock(rq, p_rq);
> +	while (task_rq(p) != p_rq) {
> +		double_rq_unlock(rq, p_rq);
> +		goto again;
> +	}
> +
> +	if (!curr->sched_class->yield_to_task)
> +		goto out;
> +
> +	if (curr->sched_class != p->sched_class)
> +		goto out;
> +
> +	if (task_running(p_rq, p) || p->state)
> +		goto out;
> +
> +	if (!same_thread_group(p, curr))
> +		goto out;
> +
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +	if (task_group(p) != task_group(curr))
> +		goto out;
> +#endif
> +
> +	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
> +
> +out:
> +	double_rq_unlock(rq, p_rq);
> +	local_irq_restore(flags);
> +
> +	if (yielded)
> +		yield();

Calling yield() here is funny, you just had all the locks to actually do
it..

> +	return yielded;
> +}
> +EXPORT_SYMBOL_GPL(yield_to);



> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index f701a51..097e936 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1800,6 +1800,23 @@ static void yield_task_fair(struct rq *rq)
>  	set_yield_buddy(se);
>  }
>  
> +static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preempt)
> +{
> +	struct sched_entity *se = &p->se;
> +
> +	if (!se->on_rq)
> +		return false;
> +
> +	/* Tell the scheduler that we'd really like pse to run next. */
> +	set_next_buddy(se);
> +
> +	/* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
> +	if (preempt)
> +		resched_task(rq->curr);
> +
> +	return true;
> +}

So here we set ->next, we could be ->last, and after this we'll set
->yield to curr by calling yield().

So if you do this cyclically I can see ->yield == {->next,->last}
happening.
