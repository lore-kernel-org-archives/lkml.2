Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab1ADO2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:28:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1ADO2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:28:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vYr62mG6x31EqF+TBs5gRjnGMvLyu2xnZCo84Md4OcPSGlpoydHoG+rIYXgSWfNwic
         JzXKJmIpwxXlq+0uS9gLJ8eQHt50z4oM17JEiSksUXm89ulw8V9xAr/M7knCcZZy0M73
         fSQVcP/0m+VqjSiHl9rM0Aigar9gBvZ591cYw=
MIME-Version: 1.0
In-Reply-To: <20110103162918.577a9620@annuminas.surriel.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	<20110103162918.577a9620@annuminas.surriel.com>
Date: Tue, 4 Jan 2011 22:28:16 +0800
Message-ID: <AANLkTinHOCF7uS-OEwoyeOkKeQ3DvQ=a_8Rg1vXZ2BOk@mail.gmail.com>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 5:29 AM, Rik van Riel <riel@redhat.com> wrote:
> From: Mike Galbraith <efault@gmx.de>
>
> Add a yield_to function to the scheduler code, allowing us to
> give enough of our timeslice to another thread to allow it to
> run and release whatever resource we need it to release.
>
> We may want to use this to provide a sys_yield_to system call
> one day.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Not-signed-off-by: Mike Galbraith <efault@gmx.de>
>
> ---
> Mike, want to change the above into a Signed-off-by: ? :)
> This code seems to work well.
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c5f926c..0b8a3e6 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1083,6 +1083,7 @@ struct sched_class {
>        void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
>        void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
>        void (*yield_task) (struct rq *rq);
> +       int (*yield_to_task) (struct task_struct *p, int preempt);
>
>        void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
>
> @@ -1981,6 +1982,7 @@ static inline int rt_mutex_getprio(struct task_struct *p)
>  # define rt_mutex_adjust_pi(p)         do { } while (0)
>  #endif
>
> +extern void yield_to(struct task_struct *p, int preempt);
>  extern void set_user_nice(struct task_struct *p, long nice);
>  extern int task_prio(const struct task_struct *p);
>  extern int task_nice(const struct task_struct *p);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index f8e5a25..ffa7a9d 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6901,6 +6901,53 @@ void __sched yield(void)
>  }
>  EXPORT_SYMBOL(yield);
>
> +/**
> + * yield_to - yield the current processor to another thread in
> + * your thread group, or accelerate that thread toward the
> + * processor it's on.
> + *
> + * It's the caller's job to ensure that the target task struct
> + * can't go away on us before we can do any checks.
> + */
> +void __sched yield_to(struct task_struct *p, int preempt)
> +{
> +       struct task_struct *curr = current;
> +       struct rq *rq, *p_rq;
> +       unsigned long flags;
> +       int yield = 0;
> +
> +       local_irq_save(flags);
> +       rq = this_rq();
> +
> +again:
> +       p_rq = task_rq(p);
> +       double_rq_lock(rq, p_rq);
> +       while (task_rq(p) != p_rq) {
> +               double_rq_unlock(rq, p_rq);
> +               goto again;
> +       }
> +
> +       if (task_running(p_rq, p) || p->state || !p->se.on_rq ||
> +                       !same_thread_group(p, curr) ||
> +                       !curr->sched_class->yield_to_task ||
> +                       curr->sched_class != p->sched_class) {
> +               goto out;
> +       }
> +
> +       yield = curr->sched_class->yield_to_task(p, preempt);
> +
> +out:
> +       double_rq_unlock(rq, p_rq);
> +       local_irq_restore(flags);
> +
> +       if (yield) {
> +               set_current_state(TASK_RUNNING);
> +               schedule();
> +       }
> +}
> +EXPORT_SYMBOL(yield_to);
> +
> +
>  /*
>  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
>  * that process accounting knows that this is a task in IO wait state.
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5119b08..3288e7c 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1119,6 +1119,61 @@ static void yield_task_fair(struct rq *rq)
>  }
>
>  #ifdef CONFIG_SMP
> +static void pull_task(struct rq *src_rq, struct task_struct *p,
> +                     struct rq *this_rq, int this_cpu);
> +#endif
> +
> +static int yield_to_task_fair(struct task_struct *p, int preempt)
> +{
> +       struct sched_entity *se = &current->se;
> +       struct sched_entity *pse = &p->se;
> +       struct sched_entity *curr = &(task_rq(p)->curr)->se;
> +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +       struct cfs_rq *p_cfs_rq = cfs_rq_of(pse);
> +       int yield = this_rq() == task_rq(p);
> +       int want_preempt = preempt;
> +
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +       if (cfs_rq->tg != p_cfs_rq->tg)
> +               return 0;
> +
> +       /* Preemption only allowed within the same task group. */
> +       if (preempt && cfs_rq->tg != cfs_rq_of(curr)->tg)
> +               preempt = 0;
> +#endif
> +       /* Preemption only allowed within the same thread group. */
> +       if (preempt && !same_thread_group(current, task_of(p_cfs_rq->curr)))
> +               preempt = 0;
> +
> +#ifdef CONFIG_SMP
> +       /*
> +        * If this yield is important enough to want to preempt instead
> +        * of only dropping a ->next hint, we're alone, and the target
> +        * is not alone, pull the target to this cpu.
> +        */
> +       if (want_preempt && !yield && cfs_rq->nr_running == 1 &&
> +                       cpumask_test_cpu(smp_processor_id(), &p->cpus_allowed)) {
> +               pull_task(task_rq(p), p, this_rq(), smp_processor_id());
> +               p_cfs_rq = cfs_rq_of(pse);
> +               yield = 1;
> +       }
> +#endif
> +
> +       if (yield)
> +               clear_buddies(cfs_rq, se);
> +       else if (preempt)
> +               clear_buddies(p_cfs_rq, curr);
> +
> +       /* Tell the scheduler that we'd really like pse to run next. */
> +       p_cfs_rq->next = pse;

If not pulled and this_rq() != task_rq(p), only assigning ->next could
kick p onto its CPU?

If not, how is the lock contention eased then?

A few words to explain please.

thanks
Hillf

> +
> +       if (!yield && preempt)
> +               resched_task(task_of(p_cfs_rq->curr));
> +
> +       return yield;
> +}
> +
> +#ifdef CONFIG_SMP
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  /*
> @@ -2081,6 +2136,7 @@ static const struct sched_class fair_sched_class = {
>        .enqueue_task           = enqueue_task_fair,
>        .dequeue_task           = dequeue_task_fair,
>        .yield_task             = yield_task_fair,
> +       .yield_to_task          = yield_to_task_fair,
>
>        .check_preempt_curr     = check_preempt_wakeup,
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
