Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0IMLo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:44:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:54650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0IMLoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:44:25 -0400
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
In-Reply-To: <1284374728.2275.159.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
	 <1284361716.25120.19.camel@marge.simson.net>
	 <1284366936.2275.27.camel@laptop>
	 <1284369373.14710.11.camel@marge.simson.net>
	 <1284370660.2275.86.camel@laptop>
	 <1284371457.14888.9.camel@marge.simson.net>
	 <1284371756.2275.108.camel@laptop>  <1284374728.2275.159.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 13:43:55 +0200
Message-ID: <1284378235.2275.227.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 12:45 +0200, Peter Zijlstra wrote:
> What we want is real deadlines, the patch provides the infrastructure,
> let me frob something for that. 

Here, real deadline, but totally untested (except for compile).

Please read through the logic. The idea was to do as we always do,
except keep a deadline on enqueue for now + __sched_period, once we find
that a deadline expired, we force run that task.

I frobbed the wakeup-preemption to never preempt a deadline expired
task, but that might be a little harsh.

Its all a lot of extra code, but have a tinker to see if you can make it
do what seems wanted ;-)

---
 include/linux/sched.h   |    5 +-
 kernel/sched.c          |    4 +
 kernel/sched_debug.c    |   57 ++++----
 kernel/sched_fair.c     |  360 +++++++++++++++++++++++++++++++++++++----------
 kernel/sched_features.h |    7 +-
 5 files changed, 327 insertions(+), 106 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53eb33c..7a35a625 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1097,7 +1097,6 @@ struct sched_statistics {
 	u64			block_start;
 	u64			block_max;
 	u64			exec_max;
-	u64			slice_max;
 
 	u64			nr_migrations_cold;
 	u64			nr_failed_migrations_affine;
@@ -1128,6 +1127,10 @@ struct sched_entity {
 	u64			vruntime;
 	u64			prev_sum_exec_runtime;
 
+	u64			deadline;
+	u64			min_deadline;
+	u64			lag;
+
 	u64			nr_migrations;
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched.c b/kernel/sched.c
index 1ab8394..7b95728 100644
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
 
@@ -2497,6 +2500,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
+	p->se.lag			= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..59af6ce 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -76,7 +76,6 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
 	PN(se->statistics.sleep_max);
 	PN(se->statistics.block_max);
 	PN(se->statistics.exec_max);
-	PN(se->statistics.slice_max);
 	PN(se->statistics.wait_max);
 	PN(se->statistics.wait_sum);
 	P(se->statistics.wait_count);
@@ -95,20 +94,20 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	else
 		SEQ_printf(m, " ");
 
-	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
+	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld.%06ld %9Ld.%06ld %9Ld %5d ",
 		p->comm, p->pid,
 		SPLIT_NS(p->se.vruntime),
+		SPLIT_NS(p->se.deadline),
+		SPLIT_NS(p->se.sum_exec_runtime),
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
+	SEQ_printf(m, "%9Ld.%06ld",
 #ifdef CONFIG_SCHEDSTATS
-	SEQ_printf(m, "%9Ld.%06ld %9Ld.%06ld %9Ld.%06ld",
-		SPLIT_NS(p->se.vruntime),
-		SPLIT_NS(p->se.sum_exec_runtime),
-		SPLIT_NS(p->se.statistics.sum_sleep_runtime));
+		SPLIT_NS(p->se.statistics.sum_sleep_runtime)
 #else
-	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
-		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
+		0LL, 0L
 #endif
+		);
 
 #ifdef CONFIG_CGROUP_SCHED
 	{
@@ -130,10 +129,12 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
-	"            task   PID         tree-key  switches  prio"
-	"     exec-runtime         sum-exec        sum-sleep\n"
-	"------------------------------------------------------"
-	"----------------------------------------------------\n");
+	"            task   PID         vruntime        deadline"
+	"            exec_runtime  switches  prio"
+	"        sum-sleep\n"
+	"-------------------------------------------------------"
+	"----------------------------------------"
+	"-----------------\n");
 
 	read_lock_irqsave(&tasklist_lock, flags);
 
@@ -162,10 +163,9 @@ static void task_group_path(struct task_group *tg, char *buf, int buflen)
 
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
@@ -182,26 +182,24 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
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
 
@@ -408,7 +406,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.statistics.sleep_max);
 	PN(se.statistics.block_max);
 	PN(se.statistics.exec_max);
-	PN(se.statistics.slice_max);
 	PN(se.statistics.wait_max);
 	PN(se.statistics.wait_sum);
 	P(se.statistics.wait_count);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..ca437ba 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -272,6 +272,31 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
  * Scheduling class tree data structure manipulation methods:
  */
 
+static inline struct sched_entity *se_of(struct rb_node *node)
+{
+	return rb_entry(node, struct sched_entity, run_node);
+}
+
+static void update_min_deadline(struct cfs_rq *cfs_rq,
+				struct sched_entity *se, struct rb_node *node)
+{
+	if (node && se->min_deadline > se_of(node)->min_deadline)
+		se->min_deadline = se_of(node)->min_deadline;
+}
+
+/*
+ * se->min_deadline = min(se->deadline, left->min_deadline, right->min_deadline)
+ */
+static void update_node(struct rb_node *node, void *data)
+{
+	struct cfs_rq *cfs_rq = data;
+	struct sched_entity *se = se_of(node);
+
+	se->min_deadline = se->deadline;
+	update_min_deadline(cfs_rq, se, node->rb_right);
+	update_min_deadline(cfs_rq, se, node->rb_left);
+}
+
 static inline u64 max_vruntime(u64 min_vruntime, u64 vruntime)
 {
 	s64 delta = (s64)(vruntime - min_vruntime);
@@ -301,25 +326,90 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
@@ -333,12 +423,14 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
+	avg_vruntime_add(cfs_rq, se);
+
 	/*
 	 * Find the right place in the rbtree:
 	 */
 	while (*link) {
 		parent = *link;
-		entry = rb_entry(parent, struct sched_entity, run_node);
+		entry = se_of(parent);
 		/*
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
@@ -360,10 +452,14 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+
+	rb_augment_insert(&se->run_node, update_node, cfs_rq);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	struct rb_node *node = rb_augment_erase_begin(&se->run_node);
+
 	if (cfs_rq->rb_leftmost == &se->run_node) {
 		struct rb_node *next_node;
 
@@ -372,16 +468,65 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	}
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_augment_erase_end(node, update_node, cfs_rq);
+	avg_vruntime_sub(cfs_rq, se);
 }
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+#ifdef CONFIG_SCHED_DEBUG
+int rb_node_pid(struct rb_node *node)
+{
+	struct sched_entity *se = se_of(node);
+	if (!entity_is_task(se))
+		return -1;
+
+	return task_of(se)->pid;
+}
+
+static void rb_node_print(struct cfs_rq *cfs_rq, struct rb_node *node, struct rb_node *curr, int level)
+{
+	int i;
+
+	printk(KERN_ERR);
+	for (i = 0; i < level; i++)
+		printk("  ");
+
+	if (!node) {
+		printk("<NULL>\n");
+		return;
+	}
+
+	printk("%d v: %Ld md: %Ld d: %Ld %s\n",
+			rb_node_pid(node),
+			se_of(node)->vruntime - cfs_rq->min_vruntime,
+			se_of(node)->min_deadline - cfs_rq->min_vruntime,
+			se_of(node)->deadline - cfs_rq->min_vruntime,
+			(node == curr) ? "<===" : ""
+			);
+
+	rb_node_print(cfs_rq, node->rb_left, curr, level+1);
+	rb_node_print(cfs_rq, node->rb_right, curr, level+1);
+}
+
+static void rb_tree_print(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	dump_stack();
+	printk(KERN_ERR "V: %Ld\n", avg_vruntime(cfs_rq) - cfs_rq->min_vruntime);
+	rb_node_print(cfs_rq, cfs_rq->tasks_timeline.rb_node, &se->run_node, 1);
+}
+#else
+static void rb_tree_print(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+}
+#endif
+
+static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
 	if (!left)
 		return NULL;
 
-	return rb_entry(left, struct sched_entity, run_node);
+	return se_of(left);
 }
 
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
@@ -391,7 +536,26 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 	if (!last)
 		return NULL;
 
-	return rb_entry(last, struct sched_entity, run_node);
+	return se_of(last);
+}
+
+static struct sched_entity *__pick_next_edf(struct cfs_rq *cfs_rq)
+{
+	struct rb_node *node = cfs_rq->tasks_timeline.rb_node;
+	struct sched_entity *se = NULL;
+
+	while (node) {
+		se = se_of(node);
+
+		if (node->rb_left &&
+		    se_of(node->rb_left)->min_deadline == se->min_deadline) {
+			node = node->rb_left;
+		}
+
+		node = node->rb_right;
+	}
+
+	return se;
 }
 
 /**************************************************************
@@ -495,6 +659,27 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+static void update_min_vruntime(struct cfs_rq *cfs_rq)
+{
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
+}
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -708,6 +893,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		}
 	}
 #endif
+	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
 static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -718,7 +904,7 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (d < 0)
 		d = -d;
 
-	if (d > 3*sysctl_sched_latency)
+	if (d > 3*cfs_rq->nr_running*sysctl_sched_latency)
 		schedstat_inc(cfs_rq, nr_spread_over);
 #endif
 }
@@ -726,7 +912,7 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
-	u64 vruntime = cfs_rq->min_vruntime;
+	u64 vruntime = avg_vruntime(cfs_rq);
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -737,8 +923,27 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	if (initial && sched_feat(START_DEBIT))
 		vruntime += sched_vslice(cfs_rq, se);
 
-	/* sleeps up to a single latency don't count. */
-	if (!initial) {
+	/*
+	 * EEVDF strategy 1, preserve lag across leave/join.
+	 */
+	if (sched_feat(PRESERVE_LAG)) {
+		se->vruntime = vruntime + se->lag;
+		return;
+	}
+
+	/*
+	 * EEVDF strategy 2, always start a join with 0 lag.
+	 */
+	if (sched_feat(ZERO_LAG)) {
+		se->vruntime = vruntime;
+		return;
+	}
+
+	/*
+	 * CFS policy, let sleeps up to two default slices be considered
+	 * as competing instead of sleeping.
+	 */
+	if (sched_feat(FAIR_SLEEPERS) && !initial) {
 		unsigned long thresh = sysctl_sched_latency;
 
 		/*
@@ -752,9 +957,13 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	}
 
 	/* ensure we never gain time by being placed backwards. */
-	vruntime = max_vruntime(se->vruntime, vruntime);
+	se->vruntime = max_vruntime(se->vruntime, vruntime);
+}
 
-	se->vruntime = vruntime;
+static void set_deadline(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	se->deadline = rq_of(cfs_rq)->clock + 
+		__sched_period(cfs_rq->nr_running);
 }
 
 static void
@@ -776,6 +985,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
+		set_deadline(cfs_rq, se);
 	}
 
 	update_stats_enqueue(cfs_rq, se);
@@ -837,44 +1047,38 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		se->vruntime -= cfs_rq->min_vruntime;
 }
 
+static int
+wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	unsigned long ideal_runtime, delta_exec;
+	unsigned long slice = sched_slice(cfs_rq, curr);
+	struct sched_entity *pse;
+
+	if (curr->sum_exec_runtime - curr->prev_sum_exec_runtime < slice) {
+		if (sched_feat(DEADLINE) && curr->deadline < rq_of(cfs_rq)->clock)
+			return;
+
+		pse = __pick_first_entity(cfs_rq);
+
+		if (pse && wakeup_preempt_entity(curr, pse) == 1)
+			goto preempt;
 
-	ideal_runtime = sched_slice(cfs_rq, curr);
-	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
-		/*
-		 * The current task ran long enough, ensure it doesn't get
-		 * re-elected due to buddy favours.
-		 */
-		clear_buddies(cfs_rq, curr);
 		return;
 	}
 
 	/*
-	 * Ensure that a task that missed wakeup preemption by a
-	 * narrow margin doesn't have to wait for a full slice.
-	 * This also mitigates buddy induced latencies under load.
+	 * The current task ran long enough, ensure it doesn't get
+	 * re-elected due to buddy favours.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
-	if (delta_exec < sysctl_sched_min_granularity)
-		return;
+	clear_buddies(cfs_rq, curr);
 
-	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
-		s64 delta = curr->vruntime - se->vruntime;
-
-		if (delta > ideal_runtime)
-			resched_task(rq_of(cfs_rq)->curr);
-	}
+preempt:
+	resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
@@ -893,37 +1097,30 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	update_stats_curr_start(cfs_rq, se);
 	cfs_rq->curr = se;
-#ifdef CONFIG_SCHEDSTATS
-	/*
-	 * Track our maximum slice length, if the CPU's load is at
-	 * least twice that of our own weight (i.e. dont track it
-	 * when there are only lesser-weight tasks around):
-	 */
-	if (rq_of(cfs_rq)->load.weight >= 2*se->load.weight) {
-		se->statistics.slice_max = max(se->statistics.slice_max,
-			se->sum_exec_runtime - se->prev_sum_exec_runtime);
-	}
-#endif
-	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
-
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
-	struct sched_entity *left = se;
+	struct sched_entity *left, *se;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
+	if (sched_feat(DEADLINE)) {
+		struct rb_node *node = cfs_rq->tasks_timeline.rb_node;
+
+		if (node && se_of(node)->deadline < rq_of(cfs_rq)->clock)
+			return __pick_next_edf(cfs_rq);
+	}
+
+	left = se = __pick_first_entity(cfs_rq);
 
-	/*
-	 * Prefer last buddy, try to return the CPU to a preempted task.
-	 */
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
 		se = cfs_rq->last;
 
+	/*
+	 * Prefer next buddy, boost wakeup-chains
+	 */
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
+		se = cfs_rq->next;
+
 	clear_buddies(cfs_rq, se);
 
 	return se;
@@ -931,6 +1128,13 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
+	unsigned long slice = sched_slice(cfs_rq, prev);
+
+	if (prev->sum_exec_runtime - prev->prev_sum_exec_runtime >= slice) {
+		prev->prev_sum_exec_runtime += slice;
+		set_deadline(cfs_rq, prev);
+	}
+
 	/*
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
@@ -1022,7 +1226,7 @@ static void hrtick_update(struct rq *rq)
 	if (curr->sched_class != &fair_sched_class)
 		return;
 
-	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
+	if (cfs_rq_of(&curr->se)->nr_running > 1)
 		hrtick_start_fair(rq, curr);
 }
 #else /* !CONFIG_SCHED_HRTICK */
@@ -1652,7 +1856,11 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	int scale = cfs_rq->nr_running >= sched_nr_latency;
+	/*
+	 * The buddy logic doesn't work well when there's not actually enough
+	 * tasks for there to be buddies.
+	 */
+	int buddies = (cfs_rq->nr_running >= 2);
 
 	if (unlikely(rt_prio(p->prio)))
 		goto preempt;
@@ -1663,9 +1871,12 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(se == pse))
 		return;
 
-	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
+	if (sched_feat(NEXT_BUDDY) && buddies && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
+	if (sched_feat(DEADLINE) && cfs_rq->curr->deadline < rq->clock)
+		return;
+
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
 	 * wake up path.
@@ -1690,6 +1901,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
 	BUG_ON(!pse);
+
 	if (wakeup_preempt_entity(se, pse) == 1)
 		goto preempt;
 
@@ -1709,7 +1921,7 @@ preempt:
 	if (unlikely(!se->on_rq || curr == rq->idle))
 		return;
 
-	if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
+	if (sched_feat(LAST_BUDDY) && buddies && entity_is_task(se))
 		set_last_buddy(se);
 }
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 83c66e8..c4f8294 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -3,13 +3,14 @@
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.
  */
+SCHED_FEAT(FAIR_SLEEPERS, 1)
 SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 
 /*
  * Place new tasks ahead so that they do not starve already running
  * tasks
  */
-SCHED_FEAT(START_DEBIT, 1)
+SCHED_FEAT(START_DEBIT, 0)
 
 /*
  * Should wakeups try to preempt running tasks.
@@ -61,3 +62,7 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+SCHED_FEAT(DEADLINE, 1)
+SCHED_FEAT(PRESERVE_LAG, 0)
+SCHED_FEAT(ZERO_LAG, 0)

