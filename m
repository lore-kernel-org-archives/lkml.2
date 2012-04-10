Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab2DJOWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:22:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37566 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2DJOWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:22:50 -0400
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 22:22:48 +0800
Message-ID: <CAJd=RBAyOxHOhbkdJmou+P0=MhnyXG2b2ChRpS9jhd05VWKHxw@mail.gmail.com>
Subject: [patch] DLS: refactor task_woken_dl
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We try to push if the current task is not preempted.

For higher success rate, push only if the next pushable task is updated.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Mon Apr  9 19:39:56 2012
+++ b/kernel/sched_dl.c	Tue Apr 10 21:09:26 2012
@@ -1372,23 +1372,6 @@ static void post_schedule_dl(struct rq *
 	push_dl_tasks(rq);
 }

-/*
- * Since the task is not running and a reschedule is not going to happen
- * anytime soon on its runqueue, we try pushing it away now.
- */
-static void task_woken_dl(struct rq *rq, struct task_struct *p)
-{
-	if (!task_running(rq, p) &&
-	    !test_tsk_need_resched(rq->curr) &&
-	    has_pushable_dl_tasks(rq) &&
-	    p->dl.nr_cpus_allowed > 1 &&
-	    dl_task(rq->curr) &&
-	    (rq->curr->dl.nr_cpus_allowed < 2 ||
-	     dl_entity_preempt(&rq->curr->dl, &p->dl))) {
-		push_dl_tasks(rq);
-	}
-}
-
 static void set_cpus_allowed_dl(struct task_struct *p,
 				const struct cpumask *new_mask)
 {
@@ -1458,6 +1441,22 @@ static inline void init_sched_dl_class(v
 					GFP_KERNEL, cpu_to_node(i));
 }

+/*
+ * Since the task is not running and a reschedule is not going to happen
+ * anytime soon on its runqueue, we try pushing it away now.
+ */
+static void task_woken_dl(struct rq *rq, struct task_struct *p)
+{
+	if (!task_running(rq, p) &&
+	    !test_tsk_need_resched(rq->curr) &&
+	    p->dl.nr_cpus_allowed > 1)
+		/*
+		 * For higher success rate, push if woken task is
+		 * the next pushable.
+		 */
+		if (p == pick_next_pushable_dl_task(rq))
+			push_dl_tasks(rq);
+}
 #endif /* CONFIG_SMP */

 static void switched_from_dl(struct rq *rq, struct task_struct *p)
--
