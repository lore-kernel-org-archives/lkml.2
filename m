Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2DMTz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:55:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2DMTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:55:24 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=VcnaFJ16KZsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=Vby4-OV0FW7ekriZ1IsA:9 a=QUOCoDCMEC9p25I3-yIA:7 a=PUjeQqilurYA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334346922.23924.370.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.5] sched_rt: Avoid unnecessary dequeue and
 enqueue of pushable tasks in set_cpus_allowed_rt()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tkhai Kirill <tkhai@yandex.ru>
Date: Fri, 13 Apr 2012 15:55:22 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/sched/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/sched/core

Head SHA1: 8d3d5ada56a692d36a9d55858881147ec10cfeb6


Kirill Tkhai (1):
      sched_rt: Avoid unnecessary dequeue and enqueue of pushable tasks in set_cpus_allowed_rt()

----
 kernel/sched/rt.c |   56 ++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)
---------------------------
commit 8d3d5ada56a692d36a9d55858881147ec10cfeb6
Author: Kirill Tkhai <tkhai@yandex.ru>
Date:   Wed Apr 11 09:06:04 2012 +0400

    sched_rt: Avoid unnecessary dequeue and enqueue of pushable tasks in set_cpus_allowed_rt()
    
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
    
    Link: http://lkml.kernel.org/r/273741334120764@web83.yandex.ru
    
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Tkhai Kirill <tkhai@yandex.ru>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index b60dad7..90607a9 100644
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


