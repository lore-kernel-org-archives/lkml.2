Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0IMIfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:35:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab0IMIfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:35:50 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284361716.25120.19.camel@marge.simson.net>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
	 <1284361716.25120.19.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 10:35:36 +0200
Message-ID: <1284366936.2275.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 09:08 +0200, Mike Galbraith wrote:
> We need a better fork fairness gizmo.

Proper zero-lag insertion would do. Much sadness in that tracking that
costs a u64 mult per enqueu/dequeue and using it adds a s64 div.

But if you want, have a play with:

---
 kernel/sched.c          |    3 +
 kernel/sched_debug.c    |   31 +++++------
 kernel/sched_fair.c     |  136 +++++++++++++++++++++++++++++++++++-----------
 kernel/sched_features.h |    6 --
 4 files changed, 120 insertions(+), 56 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1ab8394..1bff530 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -314,6 +314,9 @@ struct cfs_rq {
 	struct load_weight load;
 	unsigned long nr_running;
 
+	s64 avg_vruntime;
+	u64 avg_load;
+
 	u64 exec_clock;
 	u64 min_vruntime;
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..e775a04 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -162,10 +162,9 @@ static void task_group_path(struct task_group *tg, char *buf, int buflen)
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
-	s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
-		spread, rq0_min_vruntime, spread0;
+	s64 left_vruntime = -1, min_vruntime, right_vruntime = -1, spread;
 	struct rq *rq = cpu_rq(cpu);
-	struct sched_entity *last;
+	struct sched_entity *last, *first;
 	unsigned long flags;
 
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
@@ -182,26 +181,24 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			SPLIT_NS(cfs_rq->exec_clock));
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
-	if (cfs_rq->rb_leftmost)
-		MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
+	first = __pick_first_entity(cfs_rq);
+	if (first)
+		left_vruntime = first->vruntime;
 	last = __pick_last_entity(cfs_rq);
 	if (last)
-		max_vruntime = last->vruntime;
+		right_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
-	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
-			SPLIT_NS(MIN_vruntime));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "left_vruntime",
+			SPLIT_NS(left_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "min_vruntime",
 			SPLIT_NS(min_vruntime));
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "max_vruntime",
-			SPLIT_NS(max_vruntime));
-	spread = max_vruntime - MIN_vruntime;
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread",
-			SPLIT_NS(spread));
-	spread0 = min_vruntime - rq0_min_vruntime;
-	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread0",
-			SPLIT_NS(spread0));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
+			SPLIT_NS(avg_vruntime(cfs_rq)));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "right_vruntime",
+			SPLIT_NS(right_vruntime));
+	spread = right_vruntime - left_vruntime;
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "spread", SPLIT_NS(spread));
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..1dec344 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -301,25 +301,90 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
-static void update_min_vruntime(struct cfs_rq *cfs_rq)
+/*
+ * Compute virtual time from the per-task service numbers:
+ *
+ * Fair schedulers conserve lag: \Sum lag_i = 0
+ *
+ * lag_i = S_i - s_i = w_i * (V - v_i)
+ *
+ * \Sum lag_i = 0 -> \Sum w_i * (V - v_i) = V * \Sum w_i - \Sum w_i * v_i = 0
+ *
+ * From which we solve V:
+ *
+ *     \Sum v_i * w_i
+ * V = --------------
+ *        \Sum w_i
+ *
+ * However, since v_i is u64, and the multiplcation could easily overflow
+ * transform it into a relative form that uses smaller quantities:
+ *
+ * Substitute: v_i == (v_i - v) + v
+ *
+ *     \Sum ((v_i - v) + v) * w_i   \Sum (v_i - v) * w_i
+ * V = -------------------------- = -------------------- + v
+ *              \Sum w_i                   \Sum w_i
+ *
+ * min_vruntime = v
+ * avg_vruntime = \Sum (v_i - v) * w_i
+ * cfs_rq->load = \Sum w_i
+ *
+ * Since min_vruntime is a monotonic increasing variable that closely tracks
+ * the per-task service, these deltas: (v_i - v), will be in the order of the
+ * maximal (virtual) lag induced in the system due to quantisation.
+ */
+static void
+avg_vruntime_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 vruntime = cfs_rq->min_vruntime;
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_vruntime += key * se->load.weight;
+	cfs_rq->avg_load += se->load.weight;
+}
 
-	if (cfs_rq->curr)
-		vruntime = cfs_rq->curr->vruntime;
+static void
+avg_vruntime_sub(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 key = entity_key(cfs_rq, se);
+	cfs_rq->avg_vruntime -= key * se->load.weight;
+	cfs_rq->avg_load -= se->load.weight;
+}
 
-	if (cfs_rq->rb_leftmost) {
-		struct sched_entity *se = rb_entry(cfs_rq->rb_leftmost,
-						   struct sched_entity,
-						   run_node);
+static inline
+void avg_vruntime_update(struct cfs_rq *cfs_rq, s64 delta)
+{
+	/*
+	 * v' = v + d ==> avg_vruntime' = avg_runtime - d*avg_load
+	 */
+	cfs_rq->avg_vruntime -= cfs_rq->avg_load * delta;
+}
 
-		if (!cfs_rq->curr)
-			vruntime = se->vruntime;
-		else
-			vruntime = min_vruntime(vruntime, se->vruntime);
+static u64 avg_vruntime(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *se = cfs_rq->curr;
+	s64 lag = cfs_rq->avg_vruntime;
+	long load = cfs_rq->avg_load;
+
+	if (se) {
+		lag += entity_key(cfs_rq, se) * se->load.weight;
+		load += se->load.weight;
 	}
 
-	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+	if (load)
+		lag = div_s64(lag, load);
+
+	return cfs_rq->min_vruntime + lag;
+}
+
+static void __update_min_vruntime(struct cfs_rq *cfs_rq, u64 vruntime)
+{
+	/*
+	 * open coded max_vruntime() to allow updating avg_vruntime
+	 */
+	s64 delta = (s64)(vruntime - cfs_rq->min_vruntime);
+	if (delta > 0) {
+		avg_vruntime_update(cfs_rq, delta);
+		cfs_rq->min_vruntime = vruntime;
+	}
 }
 
 /*
@@ -333,6 +398,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
+	avg_vruntime_add(cfs_rq, se);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
@@ -372,9 +439,10 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	}
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	avg_vruntime_sub(cfs_rq, se);
 }
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
@@ -485,14 +553,25 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return slice;
 }
 
-/*
- * We calculate the vruntime slice of a to be inserted task
- *
- * vs = s/w
- */
-static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
-	return calc_delta_fair(sched_slice(cfs_rq, se), se);
+	u64 vruntime = cfs_rq->min_vruntime;
+
+	if (cfs_rq->curr)
+		vruntime = cfs_rq->curr->vruntime;
+
+	if (cfs_rq->rb_leftmost) {
+		struct sched_entity *se = rb_entry(cfs_rq->rb_leftmost,
+						   struct sched_entity,
+						   run_node);
+
+		if (!cfs_rq->curr)
+			vruntime = se->vruntime;
+		else
+			vruntime = min_vruntime(vruntime, se->vruntime);
+	}
+
+	__update_min_vruntime(cfs_rq, vruntime);
 }
 
 /*
@@ -726,16 +805,7 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
-	u64 vruntime = cfs_rq->min_vruntime;
-
-	/*
-	 * The 'current' period is already promised to the current tasks,
-	 * however the extra weight of the new task will slow them down a
-	 * little, place the new task so that it fits in the slot that
-	 * stays open at the end.
-	 */
-	if (initial && sched_feat(START_DEBIT))
-		vruntime += sched_vslice(cfs_rq, se);
+	u64 vruntime = avg_vruntime(cfs_rq);
 
 	/* sleeps up to a single latency don't count. */
 	if (!initial) {
@@ -869,7 +939,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
+		struct sched_entity *se = __pick_first_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
 		if (delta > ideal_runtime)
@@ -912,7 +982,7 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *se = __pick_first_entity(cfs_rq);
 	struct sched_entity *left = se;
 
 	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 83c66e8..b44d395 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -6,12 +6,6 @@
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*
- * Place new tasks ahead so that they do not starve already running
- * tasks
- */
-SCHED_FEAT(START_DEBIT, 1)
-
-/*
  * Should wakeups try to preempt running tasks.
  */
 SCHED_FEAT(WAKEUP_PREEMPT, 1)

