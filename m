Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1LAVcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:32:12 -0500
Received: from forward3.mail.yandex.net ([77.88.46.8]:52792 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab1LAVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:32:10 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Dec 2011 16:32:09 EST
X-Yandex-Spam: 1
Message-ID: <1322774765.8386.2.camel@hp>
Subject: [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of
 pushable tasks in set_cpus_allowed_rt()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        tkhai@yandex.ru
Date: Fri, 02 Dec 2011 01:26:05 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of pushable
tasks in set_cpus_allowed_rt()

Migration status depends on a difference of weight from 0 and 1. If
weight > 1 (<= 1) and old weight <= 1 (> 1) then task becomes pushable
(not pushable). We are not insterested in exact values of it, is it 3 or
4, for example.

Now if we are changing affinity from a set of 3 cpus to a set of 4, the
task will be dequeued and enqueued sequentially without important
difference in comparison with initial state. The only difference is in
internal representation of plist queue of pushable tasks and the fact
that the task may won't be the first in a sequence of the same priority
tasks. But it seems to me it gives nothing.

Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>

--- kernel/sched_rt.c.orig	2011-12-02 00:29:11.970243145 +0400
+++ kernel/sched_rt.c	2011-12-02 00:37:43.622846606 +0400
@@ -1572,43 +1572,37 @@ static void set_cpus_allowed_rt(struct t
 				const struct cpumask *new_mask)
 {
 	int weight = cpumask_weight(new_mask);
+	struct rq *rq;
 
 	BUG_ON(!rt_task(p));
 
 	/*
-	 * Update the migration status of the RQ if we have an RT task
-	 * which is running AND changing its weight value.
+	 * Just exit if it's not necessary to change migration status
 	 */
-	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
-		struct rq *rq = task_rq(p);
+	if ((p->rt.nr_cpus_allowed <= 1 && weight <= 1)
+		|| (p->rt.nr_cpus_allowed > 1 && weight > 1))
+		return;
 
-		if (!task_current(rq, p)) {
-			/*
-			 * Make sure we dequeue this task from the pushable list
-			 * before going further.  It will either remain off of
-			 * the list because we are no longer pushable, or it
-			 * will be requeued.
-			 */
-			if (p->rt.nr_cpus_allowed > 1)
-				dequeue_pushable_task(rq, p);
-
-			/*
-			 * Requeue if our weight is changing and still > 1
-			 */
-			if (weight > 1)
-				enqueue_pushable_task(rq, p);
-
-		}
-
-		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
-			rq->rt.rt_nr_migratory++;
-		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
-			BUG_ON(!rq->rt.rt_nr_migratory);
-			rq->rt.rt_nr_migratory--;
-		}
+	if (!p->on_rq)
+		return;
 
-		update_rt_migration(&rq->rt);
+	rq = task_rq(p);
+
+	/*
+	 * Several cpus were allowed but now it's not so OR vice versa
+	 */
+	if (weight <= 1) {
+		if (!task_current(rq, p))
+			dequeue_pushable_task(rq, p);
+		BUG_ON(!rq->rt.rt_nr_migratory);
+		rq->rt.rt_nr_migratory--;
+	} else {
+		if (!task_current(rq, p))
+			enqueue_pushable_task(rq, p);
+		rq->rt.rt_nr_migratory++;
 	}
+
+	update_rt_migration(&rq->rt);
 }
 
 /* Assumes rq->lock is held */



