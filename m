Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2KQVdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:33:41 -0500
Received: from forward5.mail.yandex.net ([77.88.46.21]:45666 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab2KQVdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:33:37 -0500
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tkhai Kirill <tkhai@yandex.ru>
Subject: [PATCH v2][sched] Ignore RT throttling if rq->rt tasks are the only running tasks in the rq 
MIME-Version: 1.0
Message-Id: <656471353188010@web12d.yandex.ru>
Date: Sun, 18 Nov 2012 01:33:30 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current throttling logic always skips RT class if rq->rt is throttled.
It doesn't handle the special case when RT tasks are the only running tasks
in the rq. So it's possible CPU picks idle task up when RTs are available.

This patch aims to avoid the above situation. The modified
_pick_next_task_rt() looks at the number of total rq->rt tasks(with the sum
of all child rt_rq's) and compares it with the number of all running tasks
of the rq. If they are equal then scheduler picks the highest rq->rt task
(children are considered too).

Later, the first unthrottled rq_rt will replace this task. In this moment
the prolongated rt_rq receives rt_time equal to rt_runtime. The case
of appearance of fair task is handled in check_preempt_curr() and
check_class_changed functions.

The patch changes the logic of pick_rt_task() and pick_next_highest_task_rt().
Now the negative cpu always makes task "picked". But there are no another
users of this posibility and nobody is touched by this change.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>

---
 kernel/sched/core.c  |   13 ++++-
 kernel/sched/rt.c    |  148 +++++++++++++++++++++++++++++++++++---------------
 kernel/sched/sched.h |    3 +-
 3 files changed, 118 insertions(+), 46 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c33495b..a79600b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -893,6 +893,8 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p);
 		p->sched_class->switched_to(rq, p);
+		if (p->on_rq && unlikely(rq->extended_class))
+			resched_task(rq->curr);
 	} else if (oldprio != p->prio)
 		p->sched_class->prio_changed(rq, p, oldprio);
 }
@@ -901,7 +903,9 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
 	const struct sched_class *class;
 
-	if (p->sched_class == rq->curr->sched_class) {
+	if (unlikely(rq->extended_class)) {
+		resched_task(rq->curr);
+	} else if (p->sched_class == rq->curr->sched_class) {
 		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
 	} else {
 		for_each_class(class) {
@@ -2771,6 +2775,7 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
 	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
+	rq->extended_class = NULL;
 }
 
 /*
@@ -6888,6 +6893,7 @@ void __init sched_init(void)
 		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
+		rq->extended_class = NULL;
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
@@ -7250,8 +7256,11 @@ void sched_move_task(struct task_struct *tsk)
 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
-	if (on_rq)
+	if (on_rq) {
 		enqueue_task(rq, tsk, 0);
+		if (unlikely(rq->extended_class))
+			resched_task(rq->curr);
+	}
 
 	task_rq_unlock(rq, tsk, &flags);
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..f6da2f4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -274,15 +274,8 @@ static void update_rt_migration(struct rt_rq *rt_rq)
 
 static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	struct task_struct *p;
-
-	if (!rt_entity_is_task(rt_se))
-		return;
-
-	p = rt_task_of(rt_se);
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	struct task_struct *p = rt_task_of(rt_se);
 
-	rt_rq->rt_nr_total++;
 	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory++;
 
@@ -291,15 +284,8 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 
 static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	struct task_struct *p;
-
-	if (!rt_entity_is_task(rt_se))
-		return;
-
-	p = rt_task_of(rt_se);
-	rt_rq = &rq_of_rt_rq(rt_rq)->rt;
+	struct task_struct *p = rt_task_of(rt_se);
 
-	rt_rq->rt_nr_total--;
 	if (p->nr_cpus_allowed > 1)
 		rt_rq->rt_nr_migratory--;
 
@@ -362,6 +348,22 @@ static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 	return !list_empty(&rt_se->run_list);
 }
 
+static void update_curr_rt(struct rq *rq);
+
+static void extended_rt_unthrottles(struct rt_rq *rt_rq, int this)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+
+	if (this) {
+		rq->skip_clock_update = 0;
+		update_rq_clock(rq);
+		update_curr_rt(rq);
+		rq->extended_class = NULL;
+	} else if (rt_rq->rt_nr_running)
+		resched_task(rq->curr);
+}
+
+
 #ifdef CONFIG_RT_GROUP_SCHED
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
@@ -803,19 +805,26 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 		span = cpu_online_mask;
 #endif
 	for_each_cpu(i, span) {
-		int enqueue = 0;
+		int extended, balance = 1, enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
 
 		raw_spin_lock(&rq->lock);
+		extended = (rq->extended_class == &rt_sched_class);
+		if (unlikely(extended))
+			balance = (rt_rq_of_se(&rq->curr->rt) != rt_rq);
 		if (rt_rq->rt_time) {
 			u64 runtime;
 
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
+			if (rt_rq->rt_throttled && balance)
 				balance_runtime(rt_rq);
 			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
+			if (likely(!extended || balance)) {
+				u64 diff = min(rt_rq->rt_time, overrun*runtime);
+				rt_rq->rt_time -= diff;
+			} else
+				rt_rq->rt_time = 0;
 			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
 				rt_rq->rt_throttled = 0;
 				enqueue = 1;
@@ -826,6 +835,9 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 				 */
 				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
 					rq->skip_clock_update = -1;
+
+				if (extended)
+					extended_rt_unthrottles(rt_rq, !balance);
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
@@ -942,6 +954,9 @@ static void update_curr_rt(struct rq *rq)
 	if (!rt_bandwidth_enabled())
 		return;
 
+	if (unlikely(rq->extended_class))
+		return;
+
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
 
@@ -1071,8 +1086,14 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_prio(prio));
 	rt_rq->rt_nr_running++;
 
+	if (rt_entity_is_task(rt_se)) {
+		struct rt_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
+
+		rt->rt_nr_total++;
+		inc_rt_migration(rt_se, rt);
+	}
+
 	inc_rt_prio(rt_rq, prio);
-	inc_rt_migration(rt_se, rt_rq);
 	inc_rt_group(rt_se, rt_rq);
 }
 
@@ -1083,8 +1104,15 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_rq->rt_nr_running);
 	rt_rq->rt_nr_running--;
 
+	if (rt_entity_is_task(rt_se)) {
+		struct rt_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
+
+		WARN_ON(!rt->rt_nr_total);
+		rt->rt_nr_total--;
+		dec_rt_migration(rt_se, rt);
+	}
+
 	dec_rt_prio(rt_rq, rt_se_prio(rt_se));
-	dec_rt_migration(rt_se, rt_rq);
 	dec_rt_group(rt_se, rt_rq);
 }
 
@@ -1362,28 +1390,41 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	return next;
 }
 
+static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
+
 static struct task_struct *_pick_next_task_rt(struct rq *rq)
 {
-	struct sched_rt_entity *rt_se;
-	struct task_struct *p;
 	struct rt_rq *rt_rq;
+	struct task_struct *p;
+	int running, rt_total;
 
 	rt_rq = &rq->rt;
+	running = rt_rq->rt_nr_running;
 
-	if (!rt_rq->rt_nr_running)
-		return NULL;
+	/* If rq->rt is suitable to get tasks */
+	if (running && !rt_rq_throttled(rt_rq)) {
+		struct sched_rt_entity *rt_se;
+
+		do {
+			rt_se = pick_next_rt_entity(rq, rt_rq);
+			BUG_ON(!rt_se);
+			rt_rq = group_rt_rq(rt_se);
+		} while (rt_rq);
+
+		return rt_task_of(rt_se);
+	}
 
-	if (rt_rq_throttled(rt_rq))
+	rt_total = rt_rq->rt_nr_total;
+
+	/* If rq has no-RT tasks OR rt_rq and its children are empty */
+	if (rt_total != rq->nr_running || !rt_total)
 		return NULL;
 
-	do {
-		rt_se = pick_next_rt_entity(rq, rt_rq);
-		BUG_ON(!rt_se);
-		rt_rq = group_rt_rq(rt_se);
-	} while (rt_rq);
+	/* All running tasks are RT. Let's avoid idle wasting CPU time */
+	p = pick_next_highest_task_rt(rq, cpu_of(rq));
+	rq->extended_class = &rt_sched_class;
 
-	p = rt_task_of(rt_se);
-	p->se.exec_start = rq->clock_task;
+	WARN_ON(!p || rq->cfs.h_nr_running);
 
 	return p;
 }
@@ -1392,9 +1433,11 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 {
 	struct task_struct *p = _pick_next_task_rt(rq);
 
-	/* The running task is never eligible for pushing */
-	if (p)
+	if (p) {
+		/* The running task is never eligible for pushing */
 		dequeue_pushable_task(rq, p);
+		p->se.exec_start = rq->clock_task;
+	}
 
 #ifdef CONFIG_SMP
 	/*
@@ -1407,10 +1450,23 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	return p;
 }
 
+static void put_extended_task_rt(struct task_struct *p)
+{
+	struct sched_rt_entity *rt_se = &p->rt;
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+
+	raw_spin_lock(&rt_rq->rt_runtime_lock);
+	rt_rq->rt_time = rt_rq->rt_runtime;
+	raw_spin_unlock(&rt_rq->rt_runtime_lock);
+}
+
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
 
+	if (rq->extended_class)
+		put_extended_task_rt(p);
+
 	/*
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
@@ -1419,17 +1475,15 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 		enqueue_pushable_task(rq, p);
 }
 
-#ifdef CONFIG_SMP
-
-/* Only try algorithms three times */
-#define RT_MAX_TRIES 3
-
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
-	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->nr_cpus_allowed > 1))
+	if (cpu == cpu_of(rq))
+		return 1;
+#ifdef CONFIG_SMP
+	else if (!task_running(rq, p) && p->nr_cpus_allowed > 1
+		&& cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return 1;
+#endif
 	return 0;
 }
 
@@ -1471,6 +1525,11 @@ next_idx:
 	return next;
 }
 
+#ifdef CONFIG_SMP
+
+/* Only try algorithms three times */
+#define RT_MAX_TRIES 3
+
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
 static int find_lowest_rq(struct task_struct *task)
@@ -1773,6 +1832,9 @@ static int pull_rt_task(struct rq *this_rq)
 			deactivate_task(src_rq, p, 0);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
+
+			if (unlikely(this_rq->extended_class))
+				resched_task(this_rq->curr);
 			/*
 			 * We continue with the search, just in
 			 * case there's an even higher prio task
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bb9475c..73b86c0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -294,6 +294,7 @@ static inline int rt_bandwidth_enabled(void)
 struct rt_rq {
 	struct rt_prio_array active;
 	unsigned int rt_nr_running;
+	unsigned long rt_nr_total;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
@@ -304,7 +305,6 @@ struct rt_rq {
 #endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
-	unsigned long rt_nr_total;
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
@@ -396,6 +396,7 @@ struct rq {
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct list_head leaf_rt_rq_list;
 #endif
+	const struct sched_class *extended_class;
 
 	/*
 	 * This is part of a global counter where only the total sum
