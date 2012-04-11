Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2DKFGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:06:09 -0400
Received: from forward9.mail.yandex.net ([77.88.61.48]:51166 "EHLO
	forward9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2DKFGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:06:07 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1334073127.23924.213.camel@gandalf.stny.rr.com>
References: <1322774765.8386.2.camel@hp>
	 <20120213172316.GA24145@home.goodmis.org> <944171329661049@web81.yandex.ru> <1334073127.23924.213.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH]sched_rt.c: Avoid unnecessary dequeue and enqueue of pushable tasks in set_cpus_allowed_rt()
MIME-Version: 1.0
Message-Id: <273741334120764@web83.yandex.ru>
Date: Wed, 11 Apr 2012 09:06:04 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migration status depends on a difference of weight from 0 and 1.
If weight > 1 (<= 1) and old weight <= 1 (> 1) then task becomes
pushable (or not pushable). We are not insterested in its exact
values, is it 3 or 4, for example.
Now if we are changing affinity from a set of 3 cpus to a set of 4, the-
task will be dequeued and enqueued sequentially without important
difference in comparison with initial state. The only difference is in
internal representation of plist queue of pushable tasks and the fact
that the task may won't be the first in a sequence of the same priority
tasks. But it seems to me it gives nothing.

Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
---
 kernel/sched/rt.c |   56 ++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 44af55e..c5565c3 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1803,44 +1803,40 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 static void set_cpus_allowed_rt(struct task_struct *p,
 				const struct cpumask *new_mask)
 {
-	int weight = cpumask_weight(new_mask);
+	struct rq *rq;
+	int weight;
 
 	BUG_ON(!rt_task(p));
 
-	/*
-	 * Update the migration status of the RQ if we have an RT task
-	 * which is running AND changing its weight value.
-	 */
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
+	if (!p->on_rq)
+		return;
 
-			/*
-			 * Requeue if our weight is changing and still > 1
-			 */
-			if (weight > 1)
-				enqueue_pushable_task(rq, p);
+	weight = cpumask_weight(new_mask);
 
-		}
+	/*
+	 * Only update if the process changes its state from whether it
+	 * can migrate or not.
+	 */
+	if ((p->rt.nr_cpus_allowed > 1) == (weight > 1))
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
+	 * The process used to be able to migrate OR it can now migrate
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
