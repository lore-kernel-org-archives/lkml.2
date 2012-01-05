Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2AERzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:55:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43269 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2AERzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:55:42 -0500
Message-ID: <1325786132.3508.1.camel@twins>
Subject: Re: [PATCH] sched_rt: the task in irq context can be migrated
 during context switching
From: Peter Zijlstra <peterz@infradead.org>
To: Chanho Min <chanho0207@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        chanho.min@lge.com, rostedt <rostedt@goodmis.org>
Date: Thu, 05 Jan 2012 18:55:32 +0100
In-Reply-To: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
References: <CAOAMb1BHA=5fm7KTewYyke6u-8DP0iUuJMpgQw54vNeXFsGpoQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 20:00 +0900, Chanho Min wrote:
> This issue happens under the following conditions
> 1. preemption is off
> 2. __ARCH_WANT_INTERRUPTS_ON_CTXSW is defined.
> 3. RT scheduling class
> 4. SMP system
> 
> Sequence is as follows:
> 1.suppose current task is A. start schedule()
> 2.task A is enqueued pushable task at the entry of schedule()
>    __schedule
>     prev = rq->curr;
>     ...
>     put_prev_task
>      put_prev_task_rt
>       enqueue_pushable_task
> 4.pick the task B as next task.
>    next = pick_next_task(rq);
> 3.rq->curr set to task B and context_switch is started.
>    rq->curr = next;
> 4.At the entry of context_swtich, release this cpu's rq->lock.
>    context_switch
>     prepare_task_switch
>      prepare_lock_switch
>       raw_spin_unlock_irq(&rq->lock);
> 5.Shortly after rq->lock is released, interrupt is occurred and start
> IRQ context
> 6.try_to_wake_up() which called by ISR acquires rq->lock
>     try_to_wake_up
>      ttwu_remote
>       rq = __task_rq_lock(p)
>       ttwu_do_wakeup(rq, p, wake_flags);
>         task_woken_rt
> 7.push_rt_task picks the task A which is enqueued before.
>    task_woken_rt
>     push_rt_tasks(rq)
>      next_task = pick_next_pushable_task(rq)
> 8.At find_lock_lowest_rq(), If double_lock_balance() returns 0,
> lowest_rq can be the remote rq.
>   (But,If preemption is on, double_lock_balance always return 1 and it
> does't happen.)
>    push_rt_task
>     find_lock_lowest_rq
>      if (double_lock_balance(rq, lowest_rq))..
> 9.find_lock_lowest_rq return the available rq. task A is migrated to
> the remote cpu/rq.
>    push_rt_task
>     ...
>     deactivate_task(rq, next_task, 0);
>     set_task_cpu(next_task, lowest_rq->cpu);
>     activate_task(lowest_rq, next_task, 0);
> 10. But, task A is on irq context at this cpu.
>     So, task A is scheduled by two cpus at the same time until restore from IRQ.
>     Task A's stack is corrupted. Unexpected problem is occurred.
> 
> In recent ARM, I saw the patch to remove
> __ARCH_WANT_INTERRUPTS_ON_CTXSW is posted.
> But, if that feature is adopted by the others architecture or to
> remain in the release version,,this can occur.
> This is my patch to fix it. Any opinions will be appreciated.

So the problem is quite real, as already said we don't need to worry
about the future, but we might want to fix this in previous kernels.
What I'm not entirely sure of is the proposed solution, Steven don't we
get in trouble by simply bailing out on the push?

> Signed-off-by: Chanho Min <chanho.min@lge.com>
> ---
>  kernel/sched_rt.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 583a136..59e66e3 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1388,6 +1388,11 @@ static int push_rt_task(struct rq *rq)
>         if (!next_task)
>                 return 0;
> 
> +#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> +       if (unlikely(task_running(rq, next_task)))
> +               return 0;
> +#endif
> +
>  retry:
>         if (unlikely(next_task == rq->curr)) {
>                 WARN_ON(1);
> --

