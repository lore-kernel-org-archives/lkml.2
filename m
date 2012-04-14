Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2DNSX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:23:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab2DNSX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:23:27 -0400
Date: Sat, 14 Apr 2012 11:22:41 -0700
From: tip-bot for Kirill Tkhai <tkhai@yandex.ru>
Message-ID: <tip-8d3d5ada56a692d36a9d55858881147ec10cfeb6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <273741334120764@web83.yandex.ru>
References: <273741334120764@web83.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched_rt:
  Avoid unnecessary dequeue and enqueue of pushable tasks in set_cpus_allowed_rt
 ()
Git-Commit-ID: 8d3d5ada56a692d36a9d55858881147ec10cfeb6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 14 Apr 2012 11:22:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d3d5ada56a692d36a9d55858881147ec10cfeb6
Gitweb:     http://git.kernel.org/tip/8d3d5ada56a692d36a9d55858881147ec10cfeb6
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Wed, 11 Apr 2012 09:06:04 +0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 12 Apr 2012 16:59:37 -0400

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
---
 kernel/sched/rt.c |   56 ++++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 30 deletions(-)

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
