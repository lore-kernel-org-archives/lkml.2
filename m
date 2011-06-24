Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1FXMx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:53:28 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60942 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1FXMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:53:24 -0400
MIME-Version: 1.0
Date: Fri, 24 Jun 2011 20:53:22 +0800
Message-ID: <BANLkTi=qf7Dm6U+3B9qL+gYThe4oQXp3tg@mail.gmail.com>
Subject: [RFC] sched: use plist in pulling RT task
From: Hillf Danton <dhillf@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven

It is pushable tasks that are pulled, and they are maintained by runqueue with
plist, so the plist can be also used by puller for free.

Thanks

Hillf
---
 kernel/sched_rt.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b03cd89..f4eecf9 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1471,6 +1471,7 @@ static int pull_rt_task(struct rq *this_rq)
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
 	struct task_struct *p;
 	struct rq *src_rq;
+	int pulled_prio = MAX_RT_PRIO;

 	if (likely(!rt_overloaded(this_rq)))
 		return 0;
@@ -1481,6 +1482,8 @@ static int pull_rt_task(struct rq *this_rq)

 		src_rq = cpu_rq(cpu);

+		if (src_rq->rt.highest_prio.next >= pulled_prio)
+			continue;
 		/*
 		 * Don't bother taking the src_rq->lock if the next highest
 		 * task is known to be lower-priority than our current task.
@@ -1502,18 +1505,19 @@ static int pull_rt_task(struct rq *this_rq)
 		/*
 		 * Are there still pullable RT tasks?
 		 */
-		if (src_rq->rt.rt_nr_running <= 1)
+		if (! has_pushable_tasks(src_rq))
 			goto skip;

-		p = pick_next_highest_task_rt(src_rq, this_cpu);
-
 		/*
 		 * Do we have an RT task that preempts
 		 * the to-be-scheduled task?
 		 */
-		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
-			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->on_rq);
+		plist_for_each_entry(p, &src_rq->rt.pushable_tasks,
+						    pushable_tasks) {
+			if (p->prio >= pulled_prio)
+				break;
+			if (! (p->prio < this_rq->rt.highest_prio.curr))
+				break;

 			/*
 			 * There's a chance that p is higher in priority
@@ -1524,22 +1528,27 @@ static int pull_rt_task(struct rq *this_rq)
 			 * current task on the run queue
 			 */
 			if (p->prio < src_rq->curr->prio)
-				goto skip;
+				continue;
+
+			if (! cpumask_test_cpu(this_cpu, &p->cpus_allowed))
+				continue;

+			pulled_prio = p->prio;
 			ret = 1;

 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
-			/*
-			 * We continue with the search, just in
-			 * case there's an even higher prio task
-			 * in another runqueue. (low likelihood
-			 * but possible)
-			 */
+			break;
 		}
 skip:
 		double_unlock_balance(this_rq, src_rq);
+		/*
+		 * We continue with the search, just in
+		 * case there's an even higher prio task
+		 * in another runqueue. (low likelihood
+		 * but possible)
+		 */
 	}

 	return ret;
