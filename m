Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab2DJObF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:31:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51778 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2DJObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:31:03 -0400
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 22:31:02 +0800
Message-ID: <CAJd=RBB1Mah5Yueqh+tGK--0wF0HWJ2UC0UOeGnnknjreYV4LQ@mail.gmail.com>
Subject: [patch] DLS: refactor switched_to_dl
From: Hillf Danton <dhillf@gmail.com>
To: Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though should be splitted, the changes in switched_to_dl and prio_changed_dl
are interleaved, and they are combined just for easing review.

When the priority of task is changed, if it is not the current task, it is
handled by switched_to_dl. Otherwise if prio goes lower, it is rescheduled.

In switched_to_dl, if the given task is either a sleeper or the current task,
we do nothing. And if fail to preempt, we try to push it away.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_dl.c	Mon Apr  9 19:39:56 2012
+++ b/kernel/sched_dl.c	Tue Apr 10 21:49:50 2012
@@ -1482,7 +1482,8 @@ static void switched_from_dl(struct rq *
  */
 static void switched_to_dl(struct rq *rq, struct task_struct *p)
 {
-	int check_resched = 1;
+	if (!p->on_rq)
+		return;

 	/*
 	 * If p is throttled, don't consider the possibility
@@ -1492,53 +1493,32 @@ static void switched_to_dl(struct rq *rq
 	if (unlikely(p->dl.dl_throttled))
 		return;

-	if (!p->on_rq || rq->curr != p) {
-#ifdef CONFIG_SMP
-		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
-			/* Only reschedule if pushing failed */
-			check_resched = 0;
-#endif /* CONFIG_SMP */
-		if (check_resched && task_has_dl_policy(rq->curr))
-			check_preempt_curr_dl(rq, p, 0);
+	if (p == rq->curr)
+		return;
+
+	if (!dl_task(rq->curr)) {
+		check_preempt_curr(rq, p, 0);
+		return;
 	}
+
+	if (dl_entity_preempt(&p->dl, &rq->curr->dl)) {
+		check_preempt_curr_dl(rq, p, 0);
+		return;
+	}
+
+#ifdef CONFIG_SMP
+	if (p->dl.nr_cpus_allowed > 1)
+		if (p == pick_next_pushable_dl_task(rq))
+			push_dl_tasks(rq);
+#endif
 }

-/*
- * If the scheduling parameters of a -deadline task changed,
- * a push or pull operation might be needed.
- */
-static void prio_changed_dl(struct rq *rq, struct task_struct *p,
-			    int oldprio)
+static void prio_changed_dl(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (p->on_rq || rq->curr == p) {
-#ifdef CONFIG_SMP
-		/*
-		 * This might be too much, but unfortunately
-		 * we don't have the old deadline value, and
-		 * we can't argue if the task is increasing
-		 * or lowering its prio, so...
-		 */
-		if (!rq->dl.overloaded)
-			pull_dl_task(rq);
-
-		/*
-		 * If we now have a earlier deadline task than p,
-		 * then reschedule, provided p is still on this
-		 * runqueue.
-		 */
-		if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
-		    rq->curr == p)
-			resched_task(p);
-#else
-		/*
-		 * Again, we don't know if p has a earlier
-		 * or later deadline, so let's blindly set a
-		 * (maybe not needed) rescheduling point.
-		 */
-		resched_task(p);
-#endif /* CONFIG_SMP */
-	} else
+	if (p != rq->curr)
 		switched_to_dl(rq, p);
+	else if (oldprio < p->prio)		
+		resched_task(p);
 }

 static const struct sched_class dl_sched_class = {
--
