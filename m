Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3AHCLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:11:07 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41335 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab3AHCJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:50 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 29/33] sched: Use an accessor to read rq clock
Date: Tue,  8 Jan 2013 03:08:29 +0100
Message-Id: <1357610913-1080-30-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read the runqueue clock through an accessor. This way
we'll be able to detect and debug stale rq clocks on
full dynticks CPUs.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c      |    6 +++---
 kernel/sched/fair.c      |   42 +++++++++++++++++++++---------------------
 kernel/sched/rt.c        |    8 ++++----
 kernel/sched/sched.h     |   10 ++++++++++
 kernel/sched/stats.h     |    8 ++++----
 kernel/sched/stop_task.c |    8 ++++----
 6 files changed, 46 insertions(+), 36 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e2884c5..15ba35e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -672,7 +672,7 @@ void sched_avg_update(struct rq *rq)
 {
 	s64 period = sched_avg_period();
 
-	while ((s64)(rq->clock - rq->age_stamp) > period) {
+	while ((s64)(rq_clock(rq) - rq->age_stamp) > period) {
 		/*
 		 * Inline assembly required to prevent the compiler
 		 * optimising this loop into a divmod call.
@@ -1347,7 +1347,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 	 * we are not idle and rq->idle_stamp == 0
 	 */
 	if (rq->idle_stamp) {
-		u64 delta = rq->clock - rq->idle_stamp;
+		u64 delta = rq_clock(rq) - rq->idle_stamp;
 		u64 max = 2*sysctl_sched_migration_cost;
 
 		if (delta > max)
@@ -2722,7 +2722,7 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 
 	if (task_current(rq, p)) {
 		update_rq_clock(rq);
-		ns = rq->clock_task - p->se.exec_start;
+		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
 			ns = 0;
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 473f50f..bd9113a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -685,7 +685,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock_task;
+	u64 now = rq_clock_task(rq_of(cfs_rq));
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -717,7 +717,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	schedstat_set(se->statistics.wait_start, rq_of(cfs_rq)->clock);
+	schedstat_set(se->statistics.wait_start, rq_clock(rq_of(cfs_rq)));
 }
 
 /*
@@ -737,14 +737,14 @@ static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	schedstat_set(se->statistics.wait_max, max(se->statistics.wait_max,
-			rq_of(cfs_rq)->clock - se->statistics.wait_start));
+			rq_clock(rq_of(cfs_rq)) - se->statistics.wait_start));
 	schedstat_set(se->statistics.wait_count, se->statistics.wait_count + 1);
 	schedstat_set(se->statistics.wait_sum, se->statistics.wait_sum +
-			rq_of(cfs_rq)->clock - se->statistics.wait_start);
+			rq_clock(rq_of(cfs_rq)) - se->statistics.wait_start);
 #ifdef CONFIG_SCHEDSTATS
 	if (entity_is_task(se)) {
 		trace_sched_stat_wait(task_of(se),
-			rq_of(cfs_rq)->clock - se->statistics.wait_start);
+			rq_clock(rq_of(cfs_rq)) - se->statistics.wait_start);
 	}
 #endif
 	schedstat_set(se->statistics.wait_start, 0);
@@ -770,7 +770,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	/*
 	 * We are starting a new run period:
 	 */
-	se->exec_start = rq_of(cfs_rq)->clock_task;
+	se->exec_start = rq_clock_task(rq_of(cfs_rq));
 }
 
 /**************************************************
@@ -1496,7 +1496,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
-	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
+	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 
@@ -1511,7 +1511,7 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * accumulated while sleeping.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
-		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
+		se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
 		if (se->avg.decay_count) {
 			/*
 			 * In a wake-up migration we have to approximate the
@@ -1585,7 +1585,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		tsk = task_of(se);
 
 	if (se->statistics.sleep_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->statistics.sleep_start;
+		u64 delta = rq_clock(rq_of(cfs_rq)) - se->statistics.sleep_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -1602,7 +1602,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		}
 	}
 	if (se->statistics.block_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->statistics.block_start;
+		u64 delta = rq_clock(rq_of(cfs_rq)) - se->statistics.block_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
@@ -1785,9 +1785,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 			struct task_struct *tsk = task_of(se);
 
 			if (tsk->state & TASK_INTERRUPTIBLE)
-				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
+				se->statistics.sleep_start = rq_clock(rq_of(cfs_rq));
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				se->statistics.block_start = rq_of(cfs_rq)->clock;
+				se->statistics.block_start = rq_clock(rq_of(cfs_rq));
 		}
 #endif
 	}
@@ -2062,7 +2062,7 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 	if (unlikely(cfs_rq->throttle_count))
 		return cfs_rq->throttled_clock_task;
 
-	return rq_of(cfs_rq)->clock_task - cfs_rq->throttled_clock_task_time;
+	return rq_clock_task(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
 }
 
 /* returns 0 on failure to allocate runtime */
@@ -2121,7 +2121,7 @@ static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 
 	/* if the deadline is ahead of our clock, nothing to do */
-	if (likely((s64)(rq->clock - cfs_rq->runtime_expires) < 0))
+	if (likely((s64)(rq_clock(rq_of(cfs_rq)) - cfs_rq->runtime_expires) < 0))
 		return;
 
 	if (cfs_rq->runtime_remaining < 0)
@@ -2210,7 +2210,7 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
 #ifdef CONFIG_SMP
 	if (!cfs_rq->throttle_count) {
 		/* adjust cfs_rq_clock_task() */
-		cfs_rq->throttled_clock_task_time += rq->clock_task -
+		cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
 					     cfs_rq->throttled_clock_task;
 	}
 #endif
@@ -2225,7 +2225,7 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 
 	/* group is entering throttled state, stop time */
 	if (!cfs_rq->throttle_count)
-		cfs_rq->throttled_clock_task = rq->clock_task;
+		cfs_rq->throttled_clock_task = rq_clock_task(rq);
 	cfs_rq->throttle_count++;
 
 	return 0;
@@ -2264,7 +2264,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		rq->nr_running -= task_delta;
 
 	cfs_rq->throttled = 1;
-	cfs_rq->throttled_clock = rq->clock;
+	cfs_rq->throttled_clock = rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	raw_spin_unlock(&cfs_b->lock);
@@ -2284,7 +2284,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	update_rq_clock(rq);
 
 	raw_spin_lock(&cfs_b->lock);
-	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
+	cfs_b->throttled_time += rq_clock(rq) - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
@@ -2687,7 +2687,7 @@ static void unthrottle_offline_cfs_rqs(struct rq *rq)
 #else /* CONFIG_CFS_BANDWIDTH */
 static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 {
-	return rq_of(cfs_rq)->clock_task;
+	return rq_clock_task(rq_of(cfs_rq));
 }
 
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
@@ -4292,7 +4292,7 @@ unsigned long scale_rt_power(int cpu)
 	age_stamp = ACCESS_ONCE(rq->age_stamp);
 	avg = ACCESS_ONCE(rq->rt_avg);
 
-	total = sched_avg_period() + (rq->clock - age_stamp);
+	total = sched_avg_period() + (rq_clock(rq) - age_stamp);
 
 	if (unlikely(total < avg)) {
 		/* Ensures that power won't end up being negative */
@@ -5255,7 +5255,7 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	unsigned long next_balance = jiffies + HZ;
 
 	update_nohz_rq_clock(this_rq);
-	this_rq->idle_stamp = this_rq->clock;
+	this_rq->idle_stamp = rq_clock(this_rq);
 
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..b1eb08b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -924,7 +924,7 @@ static void update_curr_rt(struct rq *rq)
 	if (curr->sched_class != &rt_sched_class)
 		return;
 
-	delta_exec = rq->clock_task - curr->se.exec_start;
+	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
@@ -934,7 +934,7 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
 
-	curr->se.exec_start = rq->clock_task;
+	curr->se.exec_start = rq_clock_task(rq);
 	cpuacct_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
@@ -1383,7 +1383,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	} while (rt_rq);
 
 	p = rt_task_of(rt_se);
-	p->se.exec_start = rq->clock_task;
+	p->se.exec_start = rq_clock_task(rq);
 
 	return p;
 }
@@ -2029,7 +2029,7 @@ static void set_curr_task_rt(struct rq *rq)
 {
 	struct task_struct *p = rq->curr;
 
-	p->se.exec_start = rq->clock_task;
+	p->se.exec_start = rq_clock_task(rq);
 
 	/* The running task is never eligible for pushing */
 	dequeue_pushable_task(rq, p);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 63915fe..e1bac76 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -502,6 +502,16 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		(&__raw_get_cpu_var(runqueues))
 
+static inline u64 rq_clock(struct rq *rq)
+{
+	return rq->clock;
+}
+
+static inline u64 rq_clock_task(struct rq *rq)
+{
+	return rq->clock_task;
+}
+
 #ifdef CONFIG_SMP
 
 #define rcu_dereference_check_sched_domain(p) \
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 2ef90a5..17d7065 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -61,7 +61,7 @@ static inline void sched_info_reset_dequeued(struct task_struct *t)
  */
 static inline void sched_info_dequeued(struct task_struct *t)
 {
-	unsigned long long now = task_rq(t)->clock, delta = 0;
+	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
 
 	if (unlikely(sched_info_on()))
 		if (t->sched_info.last_queued)
@@ -79,7 +79,7 @@ static inline void sched_info_dequeued(struct task_struct *t)
  */
 static void sched_info_arrive(struct task_struct *t)
 {
-	unsigned long long now = task_rq(t)->clock, delta = 0;
+	unsigned long long now = rq_clock(task_rq(t)), delta = 0;
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
@@ -100,7 +100,7 @@ static inline void sched_info_queued(struct task_struct *t)
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = task_rq(t)->clock;
+			t->sched_info.last_queued = rq_clock(task_rq(t));
 }
 
 /*
@@ -112,7 +112,7 @@ static inline void sched_info_queued(struct task_struct *t)
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
-	unsigned long long delta = task_rq(t)->clock -
+	unsigned long long delta = rq_clock(task_rq(t)) -
 					t->sched_info.last_arrival;
 
 	rq_sched_info_depart(task_rq(t), delta);
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index da5eb5b..e08fbee 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -28,7 +28,7 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 	struct task_struct *stop = rq->stop;
 
 	if (stop && stop->on_rq) {
-		stop->se.exec_start = rq->clock_task;
+		stop->se.exec_start = rq_clock_task(rq);
 		return stop;
 	}
 
@@ -57,7 +57,7 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	struct task_struct *curr = rq->curr;
 	u64 delta_exec;
 
-	delta_exec = rq->clock_task - curr->se.exec_start;
+	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
@@ -67,7 +67,7 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
 
-	curr->se.exec_start = rq->clock_task;
+	curr->se.exec_start = rq_clock_task(rq);
 	cpuacct_charge(curr, delta_exec);
 }
 
@@ -79,7 +79,7 @@ static void set_curr_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	stop->se.exec_start = rq->clock_task;
+	stop->se.exec_start = rq_clock_task(rq);
 }
 
 static void switched_to_stop(struct rq *rq, struct task_struct *p)
-- 
1.7.5.4

