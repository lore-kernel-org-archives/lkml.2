Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab0LNMWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:22:53 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52472 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab0LNMWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:22:51 -0500
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20101213224657.7e141746@annuminas.surriel.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Dec 2010 13:22:02 +0100
Message-ID: <1292329322.6803.1609.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 22:46 -0500, Rik van Riel wrote:


> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2c79e92..408326f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1086,6 +1086,8 @@ struct sched_class {
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>         void (*task_move_group) (struct task_struct *p, int on_rq);
>  #endif
> +
> +       void (*yield_to) (struct rq *rq, struct task_struct *p);
>  };
>  
>  struct load_weight {
> @@ -1947,6 +1949,7 @@ extern void set_user_nice(struct task_struct *p, long nice);
>  extern int task_prio(const struct task_struct *p);
>  extern int task_nice(const struct task_struct *p);
>  extern int can_nice(const struct task_struct *p, const int nice);
> +extern void requeue_task(struct rq *rq, struct task_struct *p);

That definitely doesn't want to be a globally visible symbol.

>  extern int task_curr(const struct task_struct *p);
>  extern int idle_cpu(int cpu);
>  extern int sched_setscheduler(struct task_struct *, int, struct sched_param *);
> @@ -2020,6 +2023,10 @@ extern int wake_up_state(struct task_struct *tsk, unsigned int state);
>  extern int wake_up_process(struct task_struct *tsk);
>  extern void wake_up_new_task(struct task_struct *tsk,
>                                 unsigned long clone_flags);
> +
> +extern u64 slice_remain(struct task_struct *);

idem.


> +void yield_to(struct task_struct *p)
> +{
> +       unsigned long flags;
> +       struct rq *rq, *p_rq;
> +
> +       local_irq_save(flags);
> +       rq = this_rq();
> +again:
> +       p_rq = task_rq(p);
> +       double_rq_lock(rq, p_rq);
> +       if (p_rq != task_rq(p)) {
> +               double_rq_unlock(rq, p_rq);
> +               goto again;
> +       }
> +
> +       /* We can't yield to a process that doesn't want to run. */
> +       if (!p->se.on_rq)
> +               goto out;
> +
> +       /*
> +        * We can only yield to a runnable task, in the same schedule class
> +        * as the current task, if the schedule class implements yield_to_task.
> +        */
> +       if (!task_running(rq, p) && current->sched_class == p->sched_class &&
> +                       current->sched_class->yield_to)
> +               current->sched_class->yield_to(rq, p);

rq and p don't match, see below.

> +
> +out:
> +       double_rq_unlock(rq, p_rq);
> +       local_irq_restore(flags);
> +       yield();

That wants to be plain: schedule(), possibly conditional on having
called sched_class::yield_to.

> +}
> +EXPORT_SYMBOL_GPL(yield_to);

> +u64 slice_remain(struct task_struct *p)
> +{
> +       unsigned long flags;
> +       struct sched_entity *se = &p->se;
> +       struct cfs_rq *cfs_rq;
> +       struct rq *rq;
> +       u64 slice, ran;
> +       s64 delta;
> +
> +       rq = task_rq_lock(p, &flags);

You're calling this from
yield_to()->sched_class::yield_to()->yield_to_fair()->slice_remain(),
yield_to() already holds p's rq lock.

> +       cfs_rq = cfs_rq_of(se);
> +       slice = sched_slice(cfs_rq, se);
> +       ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
> +       delta = slice - ran;
> +       task_rq_unlock(rq, &flags);
> +
> +       return max(delta, 0LL);
> +}

Like Mike said, the returned figure doesn't really mean anything, its
definitely not the remaining time of a slice. It might qualify for a
weak random number generator though.. :-)

> +static void yield_to_fair(struct rq *rq, struct task_struct *p)
> +{
> +       struct sched_entity *se = &p->se;
> +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +       u64 remain = slice_remain(current);
> +
> +       dequeue_task(rq, p, 0);

Here you assume @p lives on @rq, but you passed:

+               current->sched_class->yield_to(rq, p);

and rq = this_rq(), so this will go splat.

> +       se->vruntime -= remain;

You cannot simply subtract wall-time from virtual time, see the usage of
calc_delta_fair() in the proposal below.

> +       if (se->vruntime < cfs_rq->min_vruntime)
> +               se->vruntime = cfs_rq->min_vruntime;

Then clipping it to min_vruntime doesn't make any sense at all.

> +       enqueue_task(rq, p, 0);
> +       check_preempt_curr(rq, p, 0);
> +} 

Also, modifying the vruntime of one task without also modifying the
vruntime of the other task breaks stuff. You're injecting time into p
without taking time out of current. 


Maybe something like:

static void yield_to_fair(struct rq *p_rq, struct task_struct *p)
{
	struct rq *rq = this_rq();
	struct sched_entity *se = &current->se;
	struct cfs_rq *cfs_rq = cfs_rq_of(se);
	struct sched_entity *pse = &p->se;
	struct cfs_rq *p_cfs_rq = cfs_rq_of(pse);

	/*
	 * Transfer wakeup_gran worth of time from current to @p,
	 * this should ensure current is no longer eligible to run.
	 */
	unsigned long wakeup_gran = ACCESS_ONCE(sysctl_sched_wakeup_granularity);

	update_rq_clock(rq);
	update_curr(cfs_rq);

	if (pse != p_cfs_rq->curr) {
		__dequeue_entity(p_cfs_rq, pse);
	} else {
		update_rq_clock(p_rq);
		update_curr(p_cfs_rq);
	}

	se->vruntime += calc_delta_fair(wakeup_gran, se);
	pse->vruntime -= calc_delta_fair(wakeup_gran, pse);

	clear_buddies(cfs_rq, se);
	
	if (pse != p_cfs_rq->curr) {
		__enqueue_entity(p_cfs_rq, pse);
		check_preempt_curr(prq, p, 0)
	}
}

This isn't strictly correct for the group scheduling case though, that
wants a for_each_sched_entity() loop for both se and pse, but I'd have
to like actually think about that ;-)

A quick hack might be simply dis-allowing yield_to between different
groups, add something like the below to the above function:

#ifdef CONFIG_FAIR_GROUP_SCHED
	if (cfs_rq->tg != p_cfs_rq->tg)
		return;
#endif


