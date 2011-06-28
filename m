Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab1F1Mnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:43:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46488 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab1F1Mmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:42:49 -0400
MIME-Version: 1.0
Date: Tue, 28 Jun 2011 20:42:47 +0800
Message-ID: <BANLkTi=x1zpVqMWoSSnSz34ivqdJzDBOdA@mail.gmail.com>
Subject: [RFC] sched: use trylock in pulling and pushing RT tasks
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

When pulling/pushing RT tasks from/to neighbor runqueues, if we canot take
the lock of neighbor RQ at the moment, it maybe a good news since the
neighbors are likely busy in scheduling/balancing, and we could shorten
the exec paths of puller and pusher.

For puller, it is a simple replacement of double_lock_balance with
raw_spin_trylock; for pusher, the manner to find and lock the lowest RQ is
changed a bit for trylock.


Hillf
---
 kernel/sched_rt.c |  119 ++++++++++-------------------------------------------
 1 files changed, 22 insertions(+), 97 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b03cd89..545a2b1 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1178,9 +1178,6 @@ static void put_prev_task_rt(struct rq *rq,
struct task_struct *p)

 #ifdef CONFIG_SMP

-/* Only try algorithms three times */
-#define RT_MAX_TRIES 3
-
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);

 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
@@ -1306,51 +1303,30 @@ static int find_lowest_rq(struct task_struct *task)
 	return -1;
 }

-/* Will lock the rq it finds */
 static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 {
-	struct rq *lowest_rq = NULL;
-	int tries;
-	int cpu;
-
-	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
-		cpu = find_lowest_rq(task);
+	int cpu = rq->cpu;
+	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);

-		if ((cpu == -1) || (cpu == rq->cpu))
-			break;
+	if (!lowest_mask ||
+	    !cpupri_find(&rq->rd->cpupri, task, lowest_mask) ||
+	    /* no more push if we are low enough in prio */
+	    cpumask_test_cpu(cpu, lowest_mask))
+		return NULL;

-		lowest_rq = cpu_rq(cpu);
-
-		/* if the prio of this runqueue changed, try again */
-		if (double_lock_balance(rq, lowest_rq)) {
-			/*
-			 * We had to unlock the run queue. In
-			 * the mean time, task could have
-			 * migrated already or had its affinity changed.
-			 * Also make sure that it wasn't scheduled on its rq.
-			 */
-			if (unlikely(task_rq(task) != rq ||
-				     !cpumask_test_cpu(lowest_rq->cpu,
-						       &task->cpus_allowed) ||
-				     task_running(rq, task) ||
-				     !task->on_rq)) {
-
-				raw_spin_unlock(&lowest_rq->lock);
-				lowest_rq = NULL;
-				break;
-			}
-		}
+	for_each_cpu(cpu, lowest_mask) {
+		struct rq *lowest_rq = cpu_rq(cpu);

+		if (!raw_spin_trylock(&lowest_rq->lock))
+			continue;
 		/* If this rq is still suitable use it. */
 		if (lowest_rq->rt.highest_prio.curr > task->prio)
-			break;
-
-		/* try again */
-		double_unlock_balance(rq, lowest_rq);
-		lowest_rq = NULL;
+			return lowest_rq;
+		raw_spin_unlock(&lowest_rq->lock);
+		break;
 	}

-	return lowest_rq;
+	return NULL;
 }

 static struct task_struct *pick_next_pushable_task(struct rq *rq)
@@ -1390,7 +1366,6 @@ static int push_rt_task(struct rq *rq)
 	if (!next_task)
 		return 0;

-retry:
 	if (unlikely(next_task == rq->curr)) {
 		WARN_ON(1);
 		return 0;
@@ -1406,44 +1381,10 @@ retry:
 		return 0;
 	}

-	/* We might release rq lock */
-	get_task_struct(next_task);
-
 	/* find_lock_lowest_rq locks the rq if found */
 	lowest_rq = find_lock_lowest_rq(next_task, rq);
-	if (!lowest_rq) {
-		struct task_struct *task;
-		/*
-		 * find lock_lowest_rq releases rq->lock
-		 * so it is possible that next_task has migrated.
-		 *
-		 * We need to make sure that the task is still on the same
-		 * run-queue and is also still the next task eligible for
-		 * pushing.
-		 */
-		task = pick_next_pushable_task(rq);
-		if (task_cpu(next_task) == rq->cpu && task == next_task) {
-			/*
-			 * If we get here, the task hasn't moved at all, but
-			 * it has failed to push.  We will not try again,
-			 * since the other cpus will pull from us when they
-			 * are ready.
-			 */
-			dequeue_pushable_task(rq, next_task);
-			goto out;
-		}
-
-		if (!task)
-			/* No more tasks, just exit */
-			goto out;
-
-		/*
-		 * Something has shifted, try again.
-		 */
-		put_task_struct(next_task);
-		next_task = task;
-		goto retry;
-	}
+	if (!lowest_rq)
+		return 0;

 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, lowest_rq->cpu);
@@ -1451,10 +1392,7 @@ retry:

 	resched_task(lowest_rq->curr);

-	double_unlock_balance(rq, lowest_rq);
-
-out:
-	put_task_struct(next_task);
+	raw_spin_unlock(&lowest_rq->lock);

 	return 1;
 }
@@ -1481,25 +1419,10 @@ static int pull_rt_task(struct rq *this_rq)

 		src_rq = cpu_rq(cpu);

-		/*
-		 * Don't bother taking the src_rq->lock if the next highest
-		 * task is known to be lower-priority than our current task.
-		 * This may look racy, but if this value is about to go
-		 * logically higher, the src_rq will push this task away.
-		 * And if its going logically lower, we do not care
-		 */
-		if (src_rq->rt.highest_prio.next >=
-		    this_rq->rt.highest_prio.curr)
+		if (!raw_spin_trylock(&src_rq->lock))
 			continue;

 		/*
-		 * We can potentially drop this_rq's lock in
-		 * double_lock_balance, and another CPU could
-		 * alter this_rq
-		 */
-		double_lock_balance(this_rq, src_rq);
-
-		/*
 		 * Are there still pullable RT tasks?
 		 */
 		if (src_rq->rt.rt_nr_running <= 1)
@@ -1529,8 +1452,10 @@ static int pull_rt_task(struct rq *this_rq)
 			ret = 1;

 			deactivate_task(src_rq, p, 0);
+			raw_spin_unlock(&src_rq->lock);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
+			continue;
 			/*
 			 * We continue with the search, just in
 			 * case there's an even higher prio task
@@ -1539,7 +1464,7 @@ static int pull_rt_task(struct rq *this_rq)
 			 */
 		}
 skip:
-		double_unlock_balance(this_rq, src_rq);
+		raw_spin_unlock(&src_rq->lock);
 	}

 	return ret;
