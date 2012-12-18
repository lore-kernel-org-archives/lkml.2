Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2LRTMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:12:33 -0500
Received: from forward14.mail.yandex.net ([95.108.130.92]:60727 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab2LRTMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:12:32 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Tkhai Kirill <tkhai@yandex.ru>
Subject: [PATCH] sched/rt: Move cpu rq properties from "struct rt_rq" to "struct rq"
MIME-Version: 1.0
Message-Id: <4807701355857948@web19f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Dec 2012 23:12:28 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The members rt_nr_total, rt_nr_migratory, overloaded and pushable_tasks are
properties of cpu runqueue, not group rt_rq.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>

---
 kernel/sched/core.c  |    5 ++++
 kernel/sched/rt.c    |   67 +++++++++++++++++++++++++-------------------------
 kernel/sched/sched.h |   11 ++++-----
 3 files changed, 44 insertions(+), 39 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c1fb821..bf6eda6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6938,6 +6938,11 @@ void __init sched_init(void)
 
 		INIT_LIST_HEAD(&rq->cfs_tasks);
 
+		rq->rt_nr_total = 0;
+		rq->rt_nr_migratory = 0;
+		rq->rt_overloaded = 0;
+		plist_head_init(&rq->pushable_tasks);
+
 		rq_attach_root(rq, &def_root_domain);
 #ifdef CONFIG_NO_HZ
 		rq->nohz_flags = 0;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..b102ab8 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -73,9 +73,6 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #if defined CONFIG_SMP
 	rt_rq->highest_prio.curr = MAX_RT_PRIO;
 	rt_rq->highest_prio.next = MAX_RT_PRIO;
-	rt_rq->rt_nr_migratory = 0;
-	rt_rq->overloaded = 0;
-	plist_head_init(&rt_rq->pushable_tasks);
 #endif
 
 	rt_rq->rt_time = 0;
@@ -259,63 +256,67 @@ static inline void rt_clear_overload(struct rq *rq)
 	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }
 
-static void update_rt_migration(struct rt_rq *rt_rq)
+static void update_rt_migration(struct rq *rq)
 {
-	if (rt_rq->rt_nr_migratory && rt_rq->rt_nr_total > 1) {
-		if (!rt_rq->overloaded) {
-			rt_set_overload(rq_of_rt_rq(rt_rq));
-			rt_rq->overloaded = 1;
+	if (rq->rt_nr_migratory && rq->rt_nr_total > 1) {
+		if (!rq->rt_overloaded) {
+			rt_set_overload(rq);
+			rq->rt_overloaded = 1;
 		}
-	} else if (rt_rq->overloaded) {
-		rt_clear_overload(rq_of_rt_rq(rt_rq));
-		rt_rq->overloaded = 0;
+	} else if (rq->rt_overloaded) {
+		rt_clear_overload(rq);
+		rq->rt_overloaded = 0;
 	}
 }
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	struct task_struct *p;
+	struct rq *rq;
 
 	if (!rt_entity_is_task(rt_se))
 		return;
 
 	p = rt_task_of(rt_se);
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	rq = rq_of_rt_rq(rt_rq);
+	rt_rq = &rq->rt;
 
-	rt_rq->rt_nr_total++;
+	rq->rt_nr_total++;
 	if (p->nr_cpus_allowed > 1)
-		rt_rq->rt_nr_migratory++;
+		rq->rt_nr_migratory++;
 
-	update_rt_migration(rt_rq);
+	update_rt_migration(rq);
 }
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	struct task_struct *p;
+	struct rq *rq;
 
 	if (!rt_entity_is_task(rt_se))
 		return;
 
 	p = rt_task_of(rt_se);
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	rq = rq_of_rt_rq(rt_rq);
+	rt_rq = &rq->rt;
 
-	rt_rq->rt_nr_total--;
+	rq->rt_nr_total--;
 	if (p->nr_cpus_allowed > 1)
-		rt_rq->rt_nr_migratory--;
+		rq->rt_nr_migratory--;
 
-	update_rt_migration(rt_rq);
+	update_rt_migration(rq);
 }
 
 static inline int has_pushable_tasks(struct rq *rq)
 {
-	return !plist_head_empty(&rq->rt.pushable_tasks);
+	return !plist_head_empty(&rq->pushable_tasks);
 }
 
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
-	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	plist_del(&p->pushable_tasks, &rq->pushable_tasks);
 	plist_node_init(&p->pushable_tasks, p->prio);
-	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	plist_add(&p->pushable_tasks, &rq->pushable_tasks);
 
 	/* Update the highest prio pushable task */
 	if (p->prio < rq->rt.highest_prio.next)
@@ -324,11 +325,11 @@ static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 
 static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
 {
-	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
+	plist_del(&p->pushable_tasks, &rq->pushable_tasks);
 
 	/* Update the new highest prio pushable task */
 	if (has_pushable_tasks(rq)) {
-		p = plist_first_entry(&rq->rt.pushable_tasks,
+		p = plist_first_entry(&rq->pushable_tasks,
 				      struct task_struct, pushable_tasks);
 		rq->rt.highest_prio.next = p->prio;
 	} else
@@ -1601,7 +1602,7 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 	if (!has_pushable_tasks(rq))
 		return NULL;
 
-	p = plist_first_entry(&rq->rt.pushable_tasks,
+	p = plist_first_entry(&rq->pushable_tasks,
 			      struct task_struct, pushable_tasks);
 
 	BUG_ON(rq->cpu != task_cpu(p));
@@ -1625,7 +1626,7 @@ static int push_rt_task(struct rq *rq)
 	struct rq *lowest_rq;
 	int ret = 0;
 
-	if (!rq->rt.overloaded)
+	if (!rq->rt_overloaded)
 		return 0;
 
 	next_task = pick_next_pushable_task(rq);
@@ -1843,21 +1844,21 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 	if (weight <= 1) {
 		if (!task_current(rq, p))
 			dequeue_pushable_task(rq, p);
-		BUG_ON(!rq->rt.rt_nr_migratory);
-		rq->rt.rt_nr_migratory--;
+		BUG_ON(!rq->rt_nr_migratory);
+		rq->rt_nr_migratory--;
 	} else {
 		if (!task_current(rq, p))
 			enqueue_pushable_task(rq, p);
-		rq->rt.rt_nr_migratory++;
+		rq->rt_nr_migratory++;
 	}
 
-	update_rt_migration(&rq->rt);
+	update_rt_migration(rq);
 }
 
 /* Assumes rq->lock is held */
 static void rq_online_rt(struct rq *rq)
 {
-	if (rq->rt.overloaded)
+	if (rq->rt_overloaded)
 		rt_set_overload(rq);
 
 	__enable_runtime(rq);
@@ -1868,7 +1869,7 @@ static void rq_online_rt(struct rq *rq)
 /* Assumes rq->lock is held */
 static void rq_offline_rt(struct rq *rq)
 {
-	if (rq->rt.overloaded)
+	if (rq->rt_overloaded)
 		rt_clear_overload(rq);
 
 	__disable_runtime(rq);
@@ -1922,7 +1923,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 */
 	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
-		if (rq->rt.overloaded && push_rt_task(rq) &&
+		if (rq->rt_overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
 		    rq != task_rq(p))
 			check_resched = 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..4faf9cd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -301,12 +301,6 @@ struct rt_rq {
 #endif
 	} highest_prio;
 #endif
-#ifdef CONFIG_SMP
-	unsigned long rt_nr_migratory;
-	unsigned long rt_nr_total;
-	int overloaded;
-	struct plist_head pushable_tasks;
-#endif
 	int rt_throttled;
 	u64 rt_time;
 	u64 rt_runtime;
@@ -431,6 +425,11 @@ struct rq {
 
 	struct list_head cfs_tasks;
 
+	unsigned long rt_nr_total;
+	unsigned long rt_nr_migratory;
+	int rt_overloaded;
+	struct plist_head pushable_tasks;
+
 	u64 rt_avg;
 	u64 age_stamp;
 	u64 idle_stamp;
