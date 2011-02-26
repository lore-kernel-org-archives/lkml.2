Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab1BZAnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:43:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab1BZAnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=glcZUpxKzsNtUehN9j2KGF36TGjr6llHHFewmqWKdcXMh/KLp6MWXHq4TcrekRXRld
         ONrTga8qjKlryWoulf9g==
MIME-Version: 1.0
In-Reply-To: <tip-d95f412200652694e63e64bfd49f0ae274a54479@git.kernel.org>
References: <20110201095051.4ddb7738@annuminas.surriel.com>
	<tip-d95f412200652694e63e64bfd49f0ae274a54479@git.kernel.org>
Date: Fri, 25 Feb 2011 16:43:17 -0800
Message-ID: <AANLkTi=b-tyXEUfBKJH1RbENsqq8a-NRF54dSS6E3WGf@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Add yield_to(task, preempt) functionality
From: Venkatesh Pallipadi <venki@google.com>
To: riel@redhat.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        mtosatti@redhat.com, efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 6:12 AM, tip-bot for Mike Galbraith
<efault@gmx.de> wrote:
> Commit-ID:  d95f412200652694e63e64bfd49f0ae274a54479
> Gitweb:     http://git.kernel.org/tip/d95f412200652694e63e64bfd49f0ae274a54479
> Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Tue, 1 Feb 2011 09:50:51 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 3 Feb 2011 14:20:33 +0100
>
> sched: Add yield_to(task, preempt) functionality

I was looking at this patch, while trying to figure out how best to
use next buddy to solve another unrelated to this cgroup context
switching problem. While going through this change I see something
that I don't really understand (inlined below). Not sure whether what
I am looking at is a bug or I am missing something very obvious.

Thanks in advance for clarification.

>
> Currently only implemented for fair class tasks.
>
> Add a yield_to_task method() to the fair scheduling class. allowing the
> caller of yield_to() to accelerate another thread in it's thread group,
> task group.
>

<snip>

>
>  static void calc_load_account_idle(struct rq *this_rq);
> @@ -5448,6 +5481,58 @@ void __sched yield(void)
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
> + *
> + * Returns true if we indeed boosted the target task.
> + */
> +bool __sched yield_to(struct task_struct *p, bool preempt)
> +{
> +       struct task_struct *curr = current;
> +       struct rq *rq, *p_rq;
> +       unsigned long flags;
> +       bool yielded = 0;
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
> +       if (!curr->sched_class->yield_to_task)
> +               goto out;
> +
> +       if (curr->sched_class != p->sched_class)
> +               goto out;
> +
> +       if (task_running(p_rq, p) || p->state)
> +               goto out;
> +
> +       yielded = curr->sched_class->yield_to_task(rq, p, preempt);
> +       if (yielded)
> +               schedstat_inc(rq, yld_count);
> +
> +out:
> +       double_rq_unlock(rq, p_rq);
> +       local_irq_restore(flags);
> +
> +       if (yielded)
> +               schedule();
> +
> +       return yielded;
> +}
> +EXPORT_SYMBOL_GPL(yield_to);
> +
>  /*
>  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
>  * that process accounting knows that this is a task in IO wait state.
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index c0fbeb9..0270246 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1975,6 +1975,25 @@ static void yield_task_fair(struct rq *rq)
>        set_skip_buddy(se);
>  }
>
> +static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preempt)
> +{
> +       struct sched_entity *se = &p->se;
> +
> +       if (!se->on_rq)
> +               return false;
> +
> +       /* Tell the scheduler that we'd really like pse to run next. */
> +       set_next_buddy(se);

The below comment says about rescheduling p's CPU. But the rq variable
we have here is the curr_rq and not p_rq. So, should this be done in
yield_to() with p_rq. I did try to see the discussion on other
versions of this patch. v3 and before had -
"resched_task(task_of(p_cfs_rq->curr));" which seems to be correct...

Also, we already have a test of (task_running(p_rq, p) || p->state) in
yield_to. Wondering why we need the additional (!se->on_rq) above?

> +
> +       /* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
> +       if (preempt)
> +               resched_task(rq->curr);
> +
> +       yield_task_fair(rq);
> +
> +       return true;
> +}

Thanks,
Venki

> +
>  #ifdef CONFIG_SMP
>  /**************************************************
>  * Fair scheduling class load-balancing methods:
> @@ -4243,6 +4262,7 @@ static const struct sched_class fair_sched_class = {
>        .enqueue_task           = enqueue_task_fair,
>        .dequeue_task           = dequeue_task_fair,
>        .yield_task             = yield_task_fair,
> +       .yield_to_task          = yield_to_task_fair,
>
>        .check_preempt_curr     = check_preempt_wakeup,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
