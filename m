Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab1HNQIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:08:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:52300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab1HNQIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:17 -0400
Date: Sun, 14 Aug 2011 16:07:56 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-5181f4a46afd99e5e85c639b189e43e0a42b53df@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, dhillf@gmail.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, ghaskins@novell.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, dhillf@gmail.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, ghaskins@novell.com,
        mingo@elte.hu
In-Reply-To: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
References: <BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use pushable_tasks to determine next highest prio
Git-Commit-ID: 5181f4a46afd99e5e85c639b189e43e0a42b53df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:08:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5181f4a46afd99e5e85c639b189e43e0a42b53df
Gitweb:     http://git.kernel.org/tip/5181f4a46afd99e5e85c639b189e43e0a42b53df
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 16 Jun 2011 21:55:23 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:55 +0200

sched: Use pushable_tasks to determine next highest prio

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>
Link: http://lkml.kernel.org/r/BANLkTimQ67180HxCx5vgMqumqw1EkFh3qg@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |   61 +++++++++++++++-------------------------------------
 1 files changed, 18 insertions(+), 43 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 2153a87..a8c207f 100644
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
@@ -698,47 +710,13 @@ static void update_curr_rt(struct rq *rq)
 
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
@@ -746,9 +724,6 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
-		rt_rq->highest_prio.next = next_prio(rq);
-
 	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
