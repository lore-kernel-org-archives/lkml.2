Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0LFH7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 02:59:39 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0LFH7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 02:59:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QsB/0TrdBP740Ctjc4n26qRXHViYjD/cNYzb6SuV6nmK2fIusUWBostaAgVUf2oI1/
         amBgbEGJprIWfXj3oThQTB6eiz9sYV4YR/1sdMPD9oxO8bxsjN775/OEyq28x5pNGriq
         fgMMvAgrtSrDC5f44RdBjwgcXvyfTb/ANL5G8=
MIME-Version: 1.0
In-Reply-To: <1291613607.9457.5.camel@marge.simson.net>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
	<1290359641.4816.69.camel@maggy.simson.net>
	<alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
	<1290442781.16393.22.camel@maggy.simson.net>
	<alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
	<20101205052819.GA2878@zhy>
	<1291613607.9457.5.camel@marge.simson.net>
Date: Mon, 6 Dec 2010 15:59:36 +0800
Message-ID: <AANLkTimH0YN0fd4zOk3A=_Q7waqM=6V4pw4N+0g0-k=7@mail.gmail.com>
Subject: Re: Scheduler bug related to rq->skip_clock_update?
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 1:33 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Sun, 2010-12-05 at 13:28 +0800, Yong Zhang wrote:
>
>> when we init idle task, we doesn't mark it on_rq.
>> My test show the concern is smoothed by below patch.
>
> Close :)
>
> The skip_clock_update flag should only be set if rq->curr is on_rq,
> because it it _that_ clock update during dequeue, and subsequent
> microscopic vruntime update it causes that we're trying to avoid.
>
> I think the below fixes it up properly.

Yep. Now it's running well on my machine.

If you want, you can add my tested-by. :)

Thanks,
Yong

>
> Sched: fix skip_clock_update optimization
>
> idle_balance() drops/retakes rq->lock, leaving the previous task
> vulnerable to set_tsk_need_resched().  Clear it after we return
> from balancing instead, and in setup_thread_stack() as well, so
> no successfully descheduled or never scheduled task has it set.
>
> Need resched confused the skip_clock_update logic, which assumes
> that the next call to update_rq_clock() will come nearly immediately
> after being set.  Make the optimization robust against the waking
> a sleeper before it sucessfully deschedules case by checking that
> the current task has not been dequeued before setting the flag,
> since it is that useless clock update we're trying to save, and
> clear in update_rq_clock() to ensure that ONE call may be skipped.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Bjoern B. Brandenburg <bbb.lst@gmail.com>
> Reported-by: Bjoern B. Brandenburg <bbb.lst@gmail.com>
>
> ---
>  kernel/fork.c  |    1 +
>  kernel/sched.c |    6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> Index: linux-2.6.37.git/kernel/sched.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/sched.c
> +++ linux-2.6.37.git/kernel/sched.c
> @@ -660,6 +660,7 @@ inline void update_rq_clock(struct rq *r
>
>                sched_irq_time_avg_update(rq, irq_time);
>        }
> +       rq->skip_clock_update = 0;
>  }
>
>  /*
> @@ -2138,7 +2139,7 @@ static void check_preempt_curr(struct rq
>         * A queue event has occurred, and we're going to schedule.  In
>         * this case, we can save a useless back to back clock update.
>         */
> -       if (test_tsk_need_resched(rq->curr))
> +       if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
>                rq->skip_clock_update = 1;
>  }
>
> @@ -3854,7 +3855,6 @@ static void put_prev_task(struct rq *rq,
>  {
>        if (prev->se.on_rq)
>                update_rq_clock(rq);
> -       rq->skip_clock_update = 0;
>        prev->sched_class->put_prev_task(rq, prev);
>  }
>
> @@ -3912,7 +3912,6 @@ need_resched_nonpreemptible:
>                hrtick_clear(rq);
>
>        raw_spin_lock_irq(&rq->lock);
> -       clear_tsk_need_resched(prev);
>
>        switch_count = &prev->nivcsw;
>        if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
> @@ -3942,6 +3941,7 @@ need_resched_nonpreemptible:
>        if (unlikely(!rq->nr_running))
>                idle_balance(cpu, rq);
>
> +       clear_tsk_need_resched(prev);
>        put_prev_task(rq, prev);
>        next = pick_next_task(rq);
>
> Index: linux-2.6.37.git/kernel/fork.c
> ===================================================================
> --- linux-2.6.37.git.orig/kernel/fork.c
> +++ linux-2.6.37.git/kernel/fork.c
> @@ -275,6 +275,7 @@ static struct task_struct *dup_task_stru
>
>        setup_thread_stack(tsk, orig);
>        clear_user_return_notifier(tsk);
> +       clear_tsk_need_resched(tsk);
>        stackend = end_of_stack(tsk);
>        *stackend = STACK_END_MAGIC;    /* for overflow detection */
>
>
>
>
