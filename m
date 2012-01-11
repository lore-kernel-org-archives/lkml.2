Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab2AKTKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:10:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44973 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244Ab2AKTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:10:14 -0500
Message-ID: <1326309014.14099.5.camel@hp>
Subject: [PATCH] sched_rt.c: Avoid unnecessary dequeue and enqueue of
 pushable tasks in set_cpus_allowed_rt()
From: Kirill Tkhai <kirill.tkhai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, kirill.tkhai@gmail.com
Date: Wed, 11 Jan 2012 23:10:14 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migration status depends on a difference of weight from 0 and 1. If
weight > 1 (<= 1) and old weight <= 1 (> 1) then task becomes pushable
(not pushable). We are not insterested in exact values of it, is it 3 or
4, for example.

Now, if we are changing affinity from a set of 3 cpus to a set of 4, the
task will be dequeued and enqueued sequentially without important
difference in comparison with initial state. The only difference is in
internal representation of plist queue of pushable tasks and the fact
that the task may won't be the first in a sequence of the same priority
tasks. But it seems to me it gives nothing.

Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
---
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3640ebb..bf48343 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1774,43 +1774,36 @@ static void set_cpus_allowed_rt(struct task_struct *p,
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
-
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
+	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
+		return;
 
-		}
+	if (!p->on_rq)
+		return;
 
-		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
-			rq->rt.rt_nr_migratory++;
-		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
-			BUG_ON(!rq->rt.rt_nr_migratory);
-			rq->rt.rt_nr_migratory--;
-		}
+	rq = task_rq(p);
 
-		update_rt_migration(&rq->rt);
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




