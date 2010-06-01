Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0FAIQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:16:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58057 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0FAIQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:16:48 -0400
Subject: Re: [rfc] forked kernel task and mm structures imbalanced on NUMA
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20100601073343.GQ9453@laptop>
References: <20100601073343.GQ9453@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Jun 2010 10:16:42 +0200
Message-ID: <1275380202.27810.26214.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 17:33 +1000, Nick Piggin wrote:
> Another problem I found when testing this patch is that the scheduler
> has some issues of its own when balancing. This is improved by
> traversing the sd groups starting from a different spot each time, so
> processes get sprinkled around the nodes a bit better.

Right, makes sense. And I think we could merge that group iteration
without much problems.

Your alternative placement for sched_exec() seems to make sense too, the
earlier we do that the better the memory allocations will be.

Your changes to sched_fork() and wake_up_new_task() made my head hurt a
bit -- but that's not your fault. I'm not quite sure why you're changing
that though.

The addition of sched_fork_suggest_cpu() to select a target node seems
to make sense, but since you then call fork balancing a second time we
have a chance of ending up on a totally different node all together.

So I think it would make sense to rework the fork balancing muck to be
called only once and stick with its decision.

One thing that would make the whole fork path much easier is fully
ripping out that child_runs_first mess for CONFIG_SMP, I think its been
disabled by default for long enough, and its always been broken in the
face of fork balancing anyway.

So basically we have to move fork balancing back to sched_fork(), I'd
have to again look at wth happens to ->cpus_allowed, but I guess it
should be fixable, and I don't think we should care overly much about
cpu-hotplug.


A specific code comment:

> @@ -2550,14 +2561,16 @@ void wake_up_new_task(struct task_struct
>          * We set TASK_WAKING so that select_task_rq() can drop rq->lock
>          * without people poking at ->cpus_allowed.
>          */
> -       cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
> -       set_task_cpu(p, cpu);
> -
> -       p->state = TASK_RUNNING;
> -       task_rq_unlock(rq, &flags);
> +       if (!cpumask_test_cpu(cpu, &p->cpus_allowed)) {
> +               p->state = TASK_WAKING;
> +               cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
> +               set_task_cpu(p, cpu);
> +               p->state = TASK_RUNNING;
> +               task_rq_unlock(rq, &flags);
> +               rq = task_rq_lock(p, &flags);
> +       }
>  #endif

That's iffy because p->cpus_allowed isn't stable when we're not holding
the task's current rq->lock or p->state is not TASK_WAKING.


