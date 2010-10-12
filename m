Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0JLIpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:45:22 -0400
Received: from canuck.infradead.org ([134.117.69.58]:52845 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0JLIpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:45:20 -0400
Subject: Re: [PATCH try 3] CFS: Add hierarchical tree-based penalty.
From: Peter Zijlstra <peterz@infradead.org>
To: William Pitcock <nenolod@dereferenced.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20101012072859.4A14DCE142@carpathia.dereferenced.org>
References: <20101012072859.4A14DCE142@carpathia.dereferenced.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Oct 2010 10:45:04 +0200
Message-ID: <1286873104.29097.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's customary to CC people who work on the code you patch...

On Tue, 2010-10-12 at 00:32 -0500, William Pitcock wrote:
> Inspired by the recent change to BFS by Con Kolivas, this patch causes
> vruntime to be penalized based on parent depth from their root task
> group.
> 
> I have, for the moment, decided to make it a default feature since the
> design of CFS ensures that broken applications depending on task enqueue
> behaviour behaving traditionally will continue to work.
> 
> My method for applying the penalty is different than that of BFS, it
> divides the vruntime by the number of parents the process has.

Aside from the funny semantic error in your sentence there (every
process can, by definition, only have one parent), the patch doesn't
look quite right either.


> Signed-off-by: William Pitcock <nenolod@dereferenced.org>
> ---
>  include/linux/sched.h   |    2 ++
>  kernel/sched.c          |    4 ++++
>  kernel/sched_fair.c     |    8 ++++++++
>  kernel/sched_features.h |   12 ++++++++++++
>  4 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1e2a6db..7b44f98 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1494,6 +1494,8 @@ struct task_struct {
>  		unsigned long memsw_bytes; /* uncharged mem+swap usage */
>  	} memcg_batch;
>  #endif
> +
> +	int parent_count;
>  };

so copy_process() will make a child inherit the parent_count from the
parent.

>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index dc85ceb..16ad939 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2621,6 +2621,10 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
>  #endif
>  
>  	rq = task_rq_lock(p, &flags);
> +
> +	if (!(clone_flags & CLONE_THREAD))
> +		p->parent_count++;
> +

And we increment it for every new !THREAD child, so its basically a task
depth counter, except it doesn't take re-parenting into account.

>  	activate_task(rq, p, 0);
>  	trace_sched_wakeup_new(p, 1);
>  	check_preempt_curr(rq, p, WF_FORK);
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index db3f674..3f17ec1 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -737,6 +737,14 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>  	if (initial && sched_feat(START_DEBIT))
>  		vruntime += sched_vslice(cfs_rq, se);
>  
> +	if (sched_feat(HIERARCHICAL_PENALTY)) {
> +		struct task_struct *tsk = task_of(se);
> +

And here you have a bug,.. there is no guarantee se is actually a task.
Which means you're dereferencing random memory here:

> +		if (tsk->parent_count > 1)
> +			vruntime = max_vruntime(vruntime,
> +						vruntime / tsk->parent_count);

Aside from the wrap issue, that is a NOP statement.

x / y < x : y > 1, therefore, max(x, x/y) == x and you wrote, x = x;

Furthermore, vruntime here is an absolute measure of service, dividing
that by anything reduces the total amount of service the task received
during its history, doing so for y > 1 means at least halving it, which
again means that you basically end up with:

  se->vruntime = se->vruntime;

Due to the final few statements in place_entity():

  se->vruntime = max_vruntime(se->vruntime, vruntime);

What I think you meant to do was proportionally decrease the relative
placement of the new task by the task-depth, or something like that.

> +	}
> +
>  	/* sleeps up to a single latency don't count. */
>  	if (!initial) {
>  		unsigned long thresh = sysctl_sched_latency;
> diff --git a/kernel/sched_features.h b/kernel/sched_features.h
> index 83c66e8..cf17f97 100644
> --- a/kernel/sched_features.h
> +++ b/kernel/sched_features.h
> @@ -45,6 +45,18 @@ SCHED_FEAT(LAST_BUDDY, 1)
>  SCHED_FEAT(CACHE_HOT_BUDDY, 1)
>  
>  /*
> + * Hierarchical tree-based penalty: penalize service deficit by
> + * an order of magnitude for each parent process in the process
> + * tree.  This has the natural effect of forcing preference towards
> + * processes that are not fork()-hungry, like make(1), which helps
> + * to preserve good latency.
> + *
> + * This also has the side effect of providing in a limited way,
> + * per-user CPU entitlement partitioning.
> + */

But that doesn't quite match your description here, because decreasing
the relative placement for deep tasks will actually give those a benefit
over the shallow tasks...

> +SCHED_FEAT(HIERARCHICAL_PENALTY, 1)
> +
> +/*
>   * Use arch dependent cpu power functions
>   */
>  SCHED_FEAT(ARCH_POWER, 0)

