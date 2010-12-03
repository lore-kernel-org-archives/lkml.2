Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0LCNXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:23:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:60548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0LCNXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:23:34 -0500
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <20101202144423.3ad1908d@annuminas.surriel.com>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 14:23:39 +0100
Message-ID: <1291382619.32004.2124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 14:44 -0500, Rik van Riel wrote:
				unsigned long clone_flags);
> +
> +#ifdef CONFIG_SCHED_HRTICK
> +extern u64 slice_remain(struct task_struct *);
> +extern void yield_to(struct task_struct *);
> +#else
> +static inline void yield_to(struct task_struct *p) yield()
> +#endif

That does SCHED_HRTICK have to do with any of this?

>  #ifdef CONFIG_SMP
>   extern void kick_process(struct task_struct *tsk);
>  #else
> diff --git a/kernel/sched.c b/kernel/sched.c
> index f8e5a25..ef088cd 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1909,6 +1909,26 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
>  	p->se.on_rq = 0;
>  }
>  
> +/**
> + * requeue_task - requeue a task which priority got changed by yield_to

priority doesn't seem the right word, you're not actually changing
anything related to p->*prio

> + * @rq: the tasks's runqueue
> + * @p: the task in question
> + * Must be called with the runqueue lock held. Will cause the CPU to
> + * reschedule if p is now at the head of the runqueue.
> + */
> +void requeue_task(struct rq *rq, struct task_struct *p)
> +{
> +	assert_spin_locked(&rq->lock);
> +
> +	if (!p->se.on_rq || task_running(rq, p) || task_has_rt_policy(p))
> +		return;
> +
> +	dequeue_task(rq, p, 0);
> +	enqueue_task(rq, p, 0);
> +
> +	resched_task(p);

I guess that wants to be something like check_preempt_curr()

> +}
> +
>  /*
>   * __normal_prio - return the priority that is based on the static prio
>   */
> @@ -6797,6 +6817,36 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>  	return ret;
>  }
>  
> +#ifdef CONFIG_SCHED_HRTICK

Still wondering what all this has to do with SCHED_HRTICK..

> +/*
> + * Yield the CPU, giving the remainder of our time slice to task p.
> + * Typically used to hand CPU time to another thread inside the same
> + * process, eg. when p holds a resource other threads are waiting for.
> + * Giving priority to p may help get that resource released sooner.
> + */
> +void yield_to(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	struct sched_entity *se = &p->se;
> +	struct rq *rq;
> +	struct cfs_rq *cfs_rq;
> +	u64 remain = slice_remain(current);
> +
> +	rq = task_rq_lock(p, &flags);
> +	if (task_running(rq, p) || task_has_rt_policy(p))
> +		goto out;

See, this all ain't nice, slice_remain() don't make no sense to be
called for !fair tasks.

Why not write:

  if (curr->sched_class == p->sched_class &&
      curr->sched_class->yield_to)
	curr->sched_class->yield_to(curr, p);

or something, and then implement sched_class_fair::yield_to only,
leaving it a NOP for all other classes.


Also, I think you can side-step that whole curr vs p rq->lock thing
you're doing here, by holding p's rq->lock, you've disabled IRQs in
current's task context, since ->sum_exec_runtime and all are only
changed during scheduling and the scheduler_tick, disabling IRQs in its
task context pins them.

> +	cfs_rq = cfs_rq_of(se);
> +	se->vruntime -= remain;
> +	if (se->vruntime < cfs_rq->min_vruntime)
> +		se->vruntime = cfs_rq->min_vruntime;

Now here we have another problem, remain was measured in wall-time, and
then you go change a virtual time measure using that. These things are
related like:

 vt = t/weight

So you're missing a weight factor somewhere.

Also, that check against min_vruntime doesn't really make much sense.


> +	requeue_task(rq, p);

Just makes me wonder why you added requeue task to begin with.. why not
simply dequeue at the top of this function, and enqueue at the tail,
like all the rest does: see rt_mutex_setprio(), set_user_nice(),
sched_move_task().

> + out:
> +	task_rq_unlock(rq, &flags);
> +	yield();
> +}
> +EXPORT_SYMBOL(yield_to);

EXPORT_SYMBOL_GPL() pretty please, I really hate how kvm is a module and
needs to export hooks all over the core kernel :/

> +#endif
> +
>  /**
>   * sys_sched_yield - yield the current processor to other threads.
>   *
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5119b08..2a0a595 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -974,6 +974,25 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>   */
>  
>  #ifdef CONFIG_SCHED_HRTICK
> +u64 slice_remain(struct task_struct *p)
> +{
> +	unsigned long flags;
> +	struct sched_entity *se = &p->se;
> +	struct cfs_rq *cfs_rq;
> +	struct rq *rq;
> +	u64 slice, ran;
> +	s64 delta;
> +
> +	rq = task_rq_lock(p, &flags);
> +	cfs_rq = cfs_rq_of(se);
> +	slice = sched_slice(cfs_rq, se);
> +	ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
> +	delta = slice - ran;
> +	task_rq_unlock(rq, &flags);
> +
> +	return max(delta, 0LL);
> +}


Right, so another approach might be to simply swap the vruntime between
curr and p.

