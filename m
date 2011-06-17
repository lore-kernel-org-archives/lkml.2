Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab1FQCAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:00:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1FQB7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:59:21 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=CWrSLlMJQtYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=1nSz6Ew-AAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=tzl95Xyh9cU8A-vFr_cA:9 a=ctWtLeLUB0JStezjeyAA:7 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110617015920.197828866@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Jun 2011 21:55:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Hillf Danton <dhillf@gmail.com>,
        Gregory Haskins <ghaskins@novell.com>
Subject: [RFC][PATCH 7/7] sched: Use pushable_tasks to determine next highest prio
References: <20110617015516.301117218@goodmis.org>
Content-Disposition: inline; filename=0007-sched-Use-pushable_tasks-to-determine-next-highest-p.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Hillf Danton proposed a patch (see link) that cleaned up the
sched_rt code that calculates the priority of the next highest priority
task to be used in finding run queues to pull from.

His patch removed the calculating of the next prio to just use the current
prio when deteriming if we should examine a run queue to pull from. The problem
with his patch was that it caused more false checks. Because we check a run
queue for pushable tasks if the current priority of that run queue is higher
in priority than the task about to run on our run queue. But after grabbing
the locks and doing the real check, we find that there may not be a task
that has a higher prio task to pull. Thus the locks were taken with nothing to
do.

I added some trace_printks() to record when and how many times the run queue
locks were taken to check for pullable tasks, compared to how many times we
pulled a task.

With the current method, it was:

  3806 locks taken vs 2812 pulled tasks

With Hillf's patch:

  6728 locks taken vs 2804 pulled tasks

The number of times locks were taken to pull a task went up almost double with
no more success rate.

But his patch did get me thinking. When we look at the priority of the highest
task to consider taking the locks to do a pull, a failure to pull can be one
of the following: (in order of most likely)

 o RT task was pushed off already between the check and taking the lock
 o Waiting RT task can not be migrated
 o RT task's CPU affinity does not include the target run queue's CPU
 o RT task's priority changed between the check and taking the lock

And with Hillf's patch, the thing that caused most of the failures, is
the RT task to pull was not at the right priority to pull (not greater than
the current RT task priority on the target run queue).

Most of the above cases we can't help. But the current method does not check
if the next highest prio RT task can be migrated or not, and if it can not,
we still grab the locks to do the test (we don't find out about this fact until
after we have the locks). I thought about this case, and realized that the
pushable task plist that is maintained only holds RT tasks that can migrate.
If we move the calculating of the next highest prio task from the inc/dec_rt_task()
functions into the queuing of the pushable tasks, then we only measure the
priorities of those tasks that we push, and we get this basically for free.

Not only does this patch make the code a little more efficient, it cleans it
up and makes it a little simpler.

Thanks to Hillf Danton for inspiring me on this patch.

Cc: Hillf Danton <dhillf@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>
Link: http://lkml.kernel.org/r/BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |   61 +++++++++++++++-------------------------------------
 1 files changed, 18 insertions(+), 43 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 33636d2..19abd04 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -124,21 +124,33 @@ static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	update_rt_migration(rt_rq);
 }
 
+static inline int has_pushable_tasks(struct rq *rq)
+{
+	return !plist_head_empty(&rq->rt.pushable_tasks);
+}
+
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
 	plist_node_init(&p->pushable_tasks, p->prio);
 	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
+
+	/* Update the highest prio pushable task */
+	if (p->prio < rq->rt.highest_prio.next)
+		rq->rt.highest_prio.next = p->prio;
 }
 
 static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
-}
 
-static inline int has_pushable_tasks(struct rq *rq)
-{
-	return !plist_head_empty(&rq->rt.pushable_tasks);
+	/* Update the new highest prio pushable task */
+	if (has_pushable_tasks(rq)) {
+		p = plist_first_entry(&rq->rt.pushable_tasks,
+				      struct task_struct, pushable_tasks);
+		rq->rt.highest_prio.next = p->prio;
+	} else
+		rq->rt.highest_prio.next = MAX_RT_PRIO;
 }
 
 #else
@@ -686,47 +698,13 @@ static void update_curr_rt(struct rq *rq)
 
 #if defined CONFIG_SMP
 
-static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
-
-static inline int next_prio(struct rq *rq)
-{
-	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
-
-	if (next)
-		return next->prio;
-	else
-		return MAX_RT_PRIO;
-}
-
 static void
 inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (prio < prev_prio) {
-
-		/*
-		 * If the new task is higher in priority than anything on the
-		 * run-queue, we know that the previous high becomes our
-		 * next-highest.
-		 */
-		rt_rq->highest_prio.next = prev_prio;
-
-		if (rq->online)
-			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
-
-	} else if (prio == rt_rq->highest_prio.curr)
-		/*
-		 * If the next task is equal in priority to the highest on
-		 * the run-queue, then we implicitly know that the next highest
-		 * task cannot be any lower than current
-		 */
-		rt_rq->highest_prio.next = prio;
-	else if (prio < rt_rq->highest_prio.next)
-		/*
-		 * Otherwise, we need to recompute next-highest
-		 */
-		rt_rq->highest_prio.next = next_prio(rq);
+	if (rq->online && prio < prev_prio)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 }
 
 static void
@@ -734,9 +712,6 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
-		rt_rq->highest_prio.next = next_prio(rq);
-
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
-- 
1.7.4.4


