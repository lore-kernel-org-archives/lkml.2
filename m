Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2AWVEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:04:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:33255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2AWVEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:04:01 -0500
Message-ID: <1327352631.2446.22.camel@twins>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 23 Jan 2012 22:03:51 +0100
In-Reply-To: <4F1DA9D0.6090208@fb.com>
References: <1327026020-32376-1-git-send-email-asharma@fb.com>
	 <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 10:41 -0800, Arun Sharma wrote:
> On 1/23/12 3:34 AM, Peter Zijlstra wrote:

> > This'll fail to compile for !CONFIG_SCHEDSTAT I guess.. I should have
> > paid more attention to the initial patch, that tracepoint having
> > side-effects is a big no-no.
> >
> > Having unconditional writes there is somewhat sad, but I suspect putting
> > a conditional around it isn't going to help much..
> 
> For performance reasons?

Yep.

> 
> > bah can we
> > restructure things so we don't need this?
> >
> 
> We can go back to the old code, where these values were getting reset in 
> {en,de}queue_sleeper(). But we'll have to do it conditionally, so the 
> values are preserved till context switch time when we need it there.
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1003,6 +1003,8 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, 
> struct sched_entity *se)
>                  if (unlikely(delta > se->statistics.sleep_max))
>                          se->statistics.sleep_max = delta;
> 
> +               if (!trace_sched_stat_sleeptime_enabled())
> +                       se->statistics.sleep_start = 0;
>                  se->statistics.sum_sleep_runtime += delta;
> 
>                  if (tsk) {
> @@ -1019,6 +1021,8 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, 
> struct sched_entity *se)
>                  if (unlikely(delta > se->statistics.block_max))
>                          se->statistics.block_max = delta;
> 
> +               if (!trace_sched_stat_sleeptime_enabled())
> +                       se->statistics.block_start = 0;
>                  se->statistics.sum_sleep_runtime += delta;
> 
>                  if (tsk) {
> 
> This looks pretty ugly too,

Agreed, it still violates the tracepoints shouldn't actually affect the
code principle.

>  I don't know how to check for a tracepoint 
> being active (Steven?). The only advantage of this approach is that it's 
> in the sleep/wakeup path, rather than the context switch path.

Right, thus avoiding the stores for preemptions.

> Conceptually, the following seems to be the simplest:
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1939,8 +1939,10 @@ static void finish_task_switch(struct rq *rq, 
> struct task_struct *prev)
>          finish_lock_switch(rq, prev);
> 
>          trace_sched_stat_sleeptime(current, rq->clock);
> +#ifdef CONFIG_SCHEDSTAT
>          current->se.statistics.block_start = 0;
>          current->se.statistics.sleep_start = 0;
> +#endif /* CONFIG_SCHEDSTAT */
> 
> Perhaps we can reorder fields in sched_statistics so we touch one 
> cacheline here instead of two?

That might help some, but no stores for preemptions would still be best.

I was thinking something along the lines of the below, since enqueue
uses non-zero to mean its set and we need the values to still be
available in schedule dequeue is the last moment we can clear them.

This would limit the stores to the blocking case, your suggestion of
moving them to the same cacheline will then get us back where we started
in terms of performance.

Or did I miss something?


---
 kernel/sched/fair.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84adb2d..60f9ab9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1191,6 +1191,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
 
+			se->statistics.sleep_start = 0;
+			se->statistics.block_start = 0;
+
 			if (tsk->state & TASK_INTERRUPTIBLE)
 				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)

