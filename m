Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0IMNQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:16:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0IMNQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:16:11 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1284382387.2275.265.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal>  <1284382387.2275.265.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 15:15:58 +0200
Message-ID: <1284383758.2275.283.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 14:53 +0200, Peter Zijlstra wrote:
> On Sun, 2010-09-12 at 16:37 -0400, Mathieu Desnoyers wrote:
> > The whole point of my patch is not to have to do this latency vs performance
> > tradeoff for low number of running threads. With your approach, lowering the
> > granularity even when there are few threads running will very likely hurt
> > performance, no ? 
> 
> But you presented it as a latency patch, not a throughput patch. And I'm
> not sure it will matter enough to offset the computational cost it
> introduces.


---
On Mon, 2010-09-13 at 14:53 +0200, Peter Zijlstra wrote:
On Sun, 2010-09-12 at 16:37 -0400, Mathieu Desnoyers wrote:
> > The whole point of my patch is not to have to do this latency vs performance
> > tradeoff for low number of running threads. With your approach, lowering the
> > granularity even when there are few threads running will very likely hurt
> > performance, no ? 
> 
> But you presented it as a latency patch, not a throughput patch. And I'm
> not sure it will matter enough to offset the computational cost it
> introduces.
> 

One option is to simply get rid of that stuff in check_preempt_tick()
and instead do a wakeup-preempt check on the leftmost task instead.

The code as it stands today does that delta_exec < min_gran check to
ensure current gets some runtime before doing that second preemption
check, which compares vruntime with a wall-time measure.

Making that gran more complex doesn't really buy us much because for a
system with different weights in the gran and slice lengths don't match
up anyway.

---
Subject: sched: Simplify tick preemption
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jul 05 13:56:30 CEST 2010

Check the current slice, if not expired, see if the leftmost task
would otherwise have preempted current.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   43 +++++++++++++++----------------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -838,44 +838,34 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 		se->vruntime -= cfs_rq->min_vruntime;
 }
 
+static int
+wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	unsigned long ideal_runtime, delta_exec;
+	unsigned long slice = sched_slice(cfs_rq, curr);
+
+	if (curr->sum_exec_runtime - curr->prev_sum_exec_runtime < slice) {
+		struct sched_entity *pse = __pick_next_entity(cfs_rq);
+
+		if (pse && wakeup_preempt_entity(curr, pse) == 1)
+			goto preempt;
 
-	ideal_runtime = sched_slice(cfs_rq, curr);
-	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
-		/*
-		 * The current task ran long enough, ensure it doesn't get
-		 * re-elected due to buddy favours.
-		 */
-		clear_buddies(cfs_rq, curr);
 		return;
 	}
 
 	/*
-	 * Ensure that a task that missed wakeup preemption by a
-	 * narrow margin doesn't have to wait for a full slice.
-	 * This also mitigates buddy induced latencies under load.
+	 * The current task ran long enough, ensure it doesn't get
+	 * re-elected due to buddy favours.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
-	if (delta_exec < sysctl_sched_min_granularity)
-		return;
+	clear_buddies(cfs_rq, curr);
 
-	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
-		s64 delta = curr->vruntime - se->vruntime;
-
-		if (delta > ideal_runtime)
-			resched_task(rq_of(cfs_rq)->curr);
-	}
+preempt:
+	resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
@@ -908,9 +898,6 @@ set_next_entity(struct cfs_rq *cfs_rq, s
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
-
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);

