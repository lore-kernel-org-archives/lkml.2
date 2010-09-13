Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0IMJ4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 05:56:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0IMJ4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 05:56:12 -0400
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
In-Reply-To: <1284371457.14888.9.camel@marge.simson.net>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 11:55:56 +0200
Message-ID: <1284371756.2275.108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:50 +0200, Mike Galbraith wrote:
> Perhaps lag should be negated if you've received a
> reasonable chunk or something.. but what we really want is a service
> deadline.

Hey, I've got a patch for that too :-)

Not rebased to anything current, but should be able to get frobbed onto
the last zero-lag thingy without too much grief (I think).

---
Subject: 
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Apr 20 16:50:03 CEST 2010


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/sched.h   |   17 +-
 kernel/sched.c          |    8 
 kernel/sched_debug.c    |   28 +--
 kernel/sched_fair.c     |  388 ++++++++++++++++++++++++++++++++++++------------
 kernel/sched_features.h |    5 
 kernel/sysctl.c         |    4 
 6 files changed, 337 insertions(+), 113 deletions(-)

Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -94,20 +94,22 @@ print_task(struct seq_file *m, struct rq
 	else
 		SEQ_printf(m, " ");
 
-	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
+	SEQ_printf(m, "%15s %5d %9Ld.%06ld %c %9Ld.%06ld %9Ld.%06ld %9Ld.%06ld %9Ld %5d ",
 		p->comm, p->pid,
 		SPLIT_NS(p->se.vruntime),
+		entity_eligible(cfs_rq_of(&p->se), &p->se) ? 'E' : 'N',
+		SPLIT_NS(p->se.deadline),
+		SPLIT_NS(p->se.slice),
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
@@ -129,10 +131,12 @@ static void print_rq(struct seq_file *m,
 
 	SEQ_printf(m,
 	"\nrunnable tasks:\n"
-	"            task   PID         tree-key  switches  prio"
-	"     exec-runtime         sum-exec        sum-sleep\n"
-	"------------------------------------------------------"
-	"----------------------------------------------------\n");
+	"            task   PID         vruntime e         deadline"
+	"            slice     exec_runtime  switches  prio"
+	"        sum-sleep\n"
+	"----------------------------------------------------------"
+	"---------------------------------"
+	"-----------------\n");
 
 	read_lock_irqsave(&tasklist_lock, flags);
 
@@ -326,7 +330,7 @@ static int sched_debug_show(struct seq_f
 	SEQ_printf(m, "  .%-40s: %Ld.%06ld\n", #x, SPLIT_NS(x))
 	P(jiffies);
 	PN(sysctl_sched_latency);
-	PN(sysctl_sched_min_granularity);
+	PN(sysctl_sched_slice);
 	PN(sysctl_sched_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -24,21 +24,6 @@
 #include <linux/sched.h>
 
 /*
- * Targeted preemption latency for CPU-bound tasks:
- * (default: 5ms * (1 + ilog(ncpus)), units: nanoseconds)
- *
- * NOTE: this latency value is not the same as the concept of
- * 'timeslice length' - timeslices in CFS are of variable length
- * and have no persistent notion like in traditional, time-slice
- * based scheduling concepts.
- *
- * (to see the precise effective timeslice length of your workload,
- *  run vmstat and monitor the context-switches (cs) field)
- */
-unsigned int sysctl_sched_latency = 6000000ULL;
-unsigned int normalized_sysctl_sched_latency = 6000000ULL;
-
-/*
  * The initial- and re-scaling of tunables is configurable
  * (default SCHED_TUNABLESCALING_LOG = *(1+ilog(ncpus))
  *
@@ -50,17 +35,14 @@ unsigned int normalized_sysctl_sched_lat
 enum sched_tunable_scaling sysctl_sched_tunable_scaling
 	= SCHED_TUNABLESCALING_LOG;
 
+unsigned int sysctl_sched_latency = 6000000ULL;
+
 /*
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 2 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 2000000ULL;
-unsigned int normalized_sysctl_sched_min_granularity = 2000000ULL;
-
-/*
- * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
- */
-static unsigned int sched_nr_latency = 3;
+unsigned int sysctl_sched_slice = 2000000ULL;
+unsigned int normalized_sysctl_sched_slice = 2000000ULL;
 
 /*
  * After fork, child runs first. If set to 0 (default) then
@@ -272,6 +254,40 @@ find_matching_se(struct sched_entity **s
  * Scheduling class tree data structure manipulation methods:
  */
 
+static inline struct sched_entity *se_of(struct rb_node *node)
+{
+	return rb_entry(node, struct sched_entity, run_node);
+}
+
+static inline s64 deadline_key(struct cfs_rq *cfs_rq, u64 deadline)
+{
+	return (s64)(deadline - cfs_rq->min_vruntime);
+}
+
+#define deadline_gt(cfs_rq, field, lse, rse)			\
+({ deadline_key(cfs_rq, lse->field) >				\
+   deadline_key(cfs_rq, rse->field); })
+
+static void update_min_deadline(struct cfs_rq *cfs_rq,
+				struct sched_entity *se, struct rb_node *node)
+{
+	if (node && deadline_gt(cfs_rq, min_deadline, se, se_of(node)))
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
@@ -375,6 +391,34 @@ static u64 avg_vruntime(struct cfs_rq *c
 	return cfs_rq->min_vruntime + lag;
 }
 
+/*
+ * Entity is eligible once it received less service than it ought to have,
+ * eg. lag >= 0.
+ *
+ * lag_i = S_i - s_i = w_i*(V - w_i)
+ *
+ * lag_i >=0 -> V >= v_i
+ *
+ *     \Sum (v_i - v)*w_i
+ * V = ------------------ + v
+ *          \Sum w_i
+ *
+ * lag_i >= 0 -> \Sum (v_i - v)*w_i >= (v_i - v)*(\Sum w_i)
+ */
+static int entity_eligible(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	struct sched_entity *curr = cfs_rq->curr;
+	s64 avg_vruntime = cfs_rq->avg_vruntime;
+	long avg_load = cfs_rq->avg_load;
+
+	if (curr) {
+		avg_vruntime += entity_key(cfs_rq, curr) * curr->load.weight;
+		avg_load += curr->load.weight;
+	}
+
+	return avg_vruntime >= entity_key(cfs_rq, se) * avg_load;
+}
+
 static void __update_min_vruntime(struct cfs_rq *cfs_rq, u64 vruntime)
 {
 	/*
@@ -405,7 +449,7 @@ static void __enqueue_entity(struct cfs_
 	 */
 	while (*link) {
 		parent = *link;
-		entry = rb_entry(parent, struct sched_entity, run_node);
+		entry = se_of(parent);
 		/*
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
@@ -427,10 +471,14 @@ static void __enqueue_entity(struct cfs_
 
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
 
@@ -439,9 +487,58 @@ static void __dequeue_entity(struct cfs_
 	}
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_augment_erase_end(node, update_node, cfs_rq);
 	avg_vruntime_sub(cfs_rq, se);
 }
 
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
+	printk("%d v: %Ld md: %Ld d: %Ld %s %s\n",
+			rb_node_pid(node),
+			se_of(node)->vruntime - cfs_rq->min_vruntime,
+			se_of(node)->min_deadline - cfs_rq->min_vruntime,
+			se_of(node)->deadline - cfs_rq->min_vruntime,
+			entity_eligible(cfs_rq, se_of(node)) ? "E" : " ",
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
 static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
@@ -449,7 +546,7 @@ static struct sched_entity *__pick_first
 	if (!left)
 		return NULL;
 
-	return rb_entry(left, struct sched_entity, run_node);
+	return se_of(left);
 }
 
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
@@ -459,7 +556,86 @@ static struct sched_entity *__pick_last_
 	if (!last)
 		return NULL;
 
-	return rb_entry(last, struct sched_entity, run_node);
+	return se_of(last);
+}
+
+/*
+ * Earliest Eligible Virtual Deadline First
+ *
+ * In order to provide latency guarantees for different request sizes
+ * EEVDF selects the best runnable task from two criteria:
+ *
+ *  1) the task must be eligible (must be owed service)
+ *
+ *  2) from those tasks that meet 1), we select the one
+ *     with the earliest virtual deadline.
+ *
+ * We can do this in O(log n) time due to an augmented RB-tree. The
+ * tree keeps the entries sorted on service, but also functions as a
+ * heap based on the deadline by keeping:
+ *
+ *  se->min_deadline = min(se->deadline, se->{left,right}->min_deadline)
+ *
+ * Which allows an EDF like search on (sub)trees.
+ */
+static struct sched_entity *__pick_next_eevdf(struct cfs_rq *cfs_rq)
+{
+	struct rb_node *node = cfs_rq->tasks_timeline.rb_node;
+	struct sched_entity *best = NULL;
+
+	while (node) {
+		struct sched_entity *se = se_of(node);
+
+		/*
+		 * If this entity is not eligible, try the left subtree.
+		 *
+		 * XXX: would it be worth it to do the single division for
+		 *      avg_vruntime() once, instead of the multiplication
+		 *      in entity_eligible() O(log n) times?
+		 */
+		if (!entity_eligible(cfs_rq, se)) {
+			node = node->rb_left;
+			continue;
+		}
+
+		/*
+		 * If this entity has an earlier deadline than the previous
+		 * best, take this one. If it also has the earliest deadline
+		 * of its subtree, we're done.
+		 */
+		if (!best || deadline_gt(cfs_rq, deadline, best, se)) {
+			best = se;
+			if (best->deadline == best->min_deadline)
+				break;
+		}
+
+		/*
+		 * If the earlest deadline in this subtree is in the fully
+		 * eligible left half of our space, go there.
+		 */
+		if (node->rb_left &&
+		    se_of(node->rb_left)->min_deadline == se->min_deadline) {
+			node = node->rb_left;
+			continue;
+		}
+
+		node = node->rb_right;
+	}
+
+	if (unlikely(!best && cfs_rq->nr_running)) {
+		rb_tree_print(cfs_rq, NULL);
+		return __pick_first_entity(cfs_rq);
+	}
+
+	return best;
+}
+
+static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+{
+	if (sched_feat(EEVDF))
+		return __pick_next_eevdf(cfs_rq);
+
+	return __pick_first_entity(cfs_rq);
 }
 
 /**************************************************************
@@ -477,13 +653,9 @@ int sched_proc_update_handler(struct ctl
 	if (ret || !write)
 		return ret;
 
-	sched_nr_latency = DIV_ROUND_UP(sysctl_sched_latency,
-					sysctl_sched_min_granularity);
-
 #define WRT_SYSCTL(name) \
 	(normalized_sysctl_##name = sysctl_##name / (factor))
-	WRT_SYSCTL(sched_min_granularity);
-	WRT_SYSCTL(sched_latency);
+	WRT_SYSCTL(sched_slice);
 	WRT_SYSCTL(sched_wakeup_granularity);
 	WRT_SYSCTL(sched_shares_ratelimit);
 #undef WRT_SYSCTL
@@ -504,55 +676,6 @@ calc_delta_fair(unsigned long delta, str
 	return delta;
 }
 
-/*
- * The idea is to set a period in which each task runs once.
- *
- * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
- * this period because otherwise the slices get too small.
- *
- * p = (nr <= nl) ? l : l*nr/nl
- */
-static u64 __sched_period(unsigned long nr_running)
-{
-	u64 period = sysctl_sched_latency;
-	unsigned long nr_latency = sched_nr_latency;
-
-	if (unlikely(nr_running > nr_latency)) {
-		period = sysctl_sched_min_granularity;
-		period *= nr_running;
-	}
-
-	return period;
-}
-
-/*
- * We calculate the wall-time slice from the period by taking a part
- * proportional to the weight.
- *
- * s = p*P[w/rw]
- */
-static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	u64 slice = __sched_period(cfs_rq->nr_running + !se->on_rq);
-
-	for_each_sched_entity(se) {
-		struct load_weight *load;
-		struct load_weight lw;
-
-		cfs_rq = cfs_rq_of(se);
-		load = &cfs_rq->load;
-
-		if (unlikely(!se->on_rq)) {
-			lw = cfs_rq->load;
-
-			update_load_add(&lw, se->load.weight);
-			load = &lw;
-		}
-		slice = calc_delta_mine(slice, se->load.weight, load);
-	}
-	return slice;
-}
-
 static void update_min_vruntime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
 {
 	struct sched_entity *left = __pick_first_entity(cfs_rq);
@@ -707,6 +830,53 @@ add_cfs_task_weight(struct cfs_rq *cfs_r
 }
 #endif
 
+static void __set_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (sched_feat(FAIR_DEADLINE)) {
+		/*
+		 * If v_i < V, set the deadline relative to V instead,
+		 * so that it will not constrain already running tasks.
+		 */
+		se->deadline = max_vruntime(avg_vruntime(cfs_rq), se->vruntime);
+	} else {
+		se->deadline = se->vruntime;
+	}
+
+	se->deadline += calc_delta_fair(se->slice, se);
+}
+
+static void new_slice(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
+{
+	if (!sched_feat(EEVDF))
+		goto fixed;
+
+	if (flags & ENQUEUE_LATENCY) {
+		se->slice = calc_delta_mine(sysctl_sched_latency,
+					    se->load.weight, &cfs_rq->load);
+		se->interactive = DIV_ROUND_UP(sysctl_sched_slice, se->slice);
+	} else if (!(flags & ENQUEUE_IO)) {
+fixed:
+		se->interactive = 1;
+		se->slice = sysctl_sched_slice;
+	}
+
+	__set_slice(cfs_rq, se);
+}
+
+static void next_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	if (sched_feat(EEVDF) && se->interactive) {
+		se->slice = calc_delta_mine(sysctl_sched_latency,
+					    se->load.weight, &cfs_rq->load);
+		se->interactive--;
+	} else {
+		se->slice = sysctl_sched_slice;
+		se->interactive = 0;
+	}
+
+	__set_slice(cfs_rq, se);
+}
+
 static void
 account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -814,9 +984,28 @@ place_entity(struct cfs_rq *cfs_rq, stru
 {
 	u64 vruntime = cfs_rq->min_vruntime;
 
-	/* sleeps up to a single latency don't count. */
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
 	if (sched_feat(FAIR_SLEEPERS) && !initial) {
-		unsigned long thresh = sysctl_sched_latency;
+		unsigned long thresh = 2*sysctl_sched_slice;
 
 		/*
 		 * Halve their sleep time's effect, to allow
@@ -851,6 +1040,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
+		new_slice(cfs_rq, se, flags);
 	}
 
 	update_stats_enqueue(cfs_rq, se);
@@ -884,6 +1074,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 
 	update_stats_dequeue(cfs_rq, se);
 	if (flags & DEQUEUE_SLEEP) {
+		if (sched_feat(PRESERVE_LAG))
+			se->lag = se->vruntime - avg_vruntime(cfs_rq);
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
@@ -918,7 +1110,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 static void
 check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 {
-	unsigned long slice = sched_slice(cfs_rq, curr);
+	unsigned long slice = curr->slice;
 
 	if (curr->sum_exec_runtime - curr->prev_sum_exec_runtime < slice)
 		return;
@@ -955,7 +1147,7 @@ wakeup_preempt_entity(struct sched_entit
 
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_first_entity(cfs_rq);
+	struct sched_entity *se = __pick_next_entity(cfs_rq);
 	struct sched_entity *left = se;
 
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
@@ -974,10 +1166,12 @@ static struct sched_entity *pick_next_en
 
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
-	unsigned long slice = sched_slice(cfs_rq, prev);
+	unsigned long slice = prev->slice;
 
-	if (prev->sum_exec_runtime - prev->prev_sum_exec_runtime >= slice)
+	if (prev->sum_exec_runtime - prev->prev_sum_exec_runtime >= slice) {
 		prev->prev_sum_exec_runtime += slice;
+		next_slice(cfs_rq, prev);
+	}
 
 	/*
 	 * If still on the runqueue then deactivate_task()
@@ -1037,9 +1231,8 @@ static void hrtick_start_fair(struct rq 
 	WARN_ON(task_rq(p) != rq);
 
 	if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
-		u64 slice = sched_slice(cfs_rq, se);
 		u64 ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
-		s64 delta = slice - ran;
+		s64 delta = se->slice - ran;
 
 		if (delta < 0) {
 			if (rq->curr == p)
@@ -1070,7 +1263,7 @@ static void hrtick_update(struct rq *rq)
 	if (curr->sched_class != &fair_sched_class)
 		return;
 
-	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
+	if (cfs_rq_of(&curr->se)->nr_running > 1)
 		hrtick_start_fair(rq, curr);
 }
 #else /* !CONFIG_SCHED_HRTICK */
@@ -1095,6 +1288,9 @@ enqueue_task_fair(struct rq *rq, struct 
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
 
+	if (p->sched_in_iowait)
+		flags |= ENQUEUE_IO;
+
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
@@ -1717,7 +1913,7 @@ static void check_preempt_wakeup(struct 
 	if (unlikely(se == pse))
 		return;
 
-	if (!(wake_flags & WF_FORK) && p->se.interactive) {
+	if (!sched_feat(EEVDF) && !(wake_flags & WF_FORK) && p->se.interactive) {
 		clear_buddies(cfs_rq, NULL);
 		set_next_buddy(pse);
 		preempt = 1;
@@ -1748,6 +1944,14 @@ static void check_preempt_wakeup(struct 
 	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
 	BUG_ON(!pse);
+
+	if (sched_feat(EEVDF)) {
+		if (entity_eligible(cfs_rq, pse) &&
+		    deadline_gt(cfs_rq, deadline, se, pse))
+			goto preempt;
+		return;
+	}
+
 	if (preempt || wakeup_preempt_entity(se, pse) == 1)
 		goto preempt;
 
@@ -3813,8 +4017,10 @@ static void task_fork_fair(struct task_s
 
 	update_curr(cfs_rq);
 
-	if (curr)
+	if (curr) {
 		se->vruntime = curr->vruntime;
+		se->slice = curr->slice;
+	}
 	place_entity(cfs_rq, se, 1);
 
 	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
@@ -3901,7 +4107,7 @@ static unsigned int get_rr_interval_fair
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(se->slice);
 
 	return rr_interval;
 }
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1028,9 +1028,11 @@ struct sched_domain;
 #define WF_FORK		0x02		/* child wakeup after fork */
 #define WF_INTERACTIVE	0x04
 
-#define ENQUEUE_WAKEUP		0x1
-#define ENQUEUE_WAKING		0x2
-#define ENQUEUE_HEAD		0x4
+#define ENQUEUE_WAKEUP		0x01
+#define ENQUEUE_WAKING		0x02
+#define ENQUEUE_HEAD		0x04
+#define ENQUEUE_IO		0x08
+#define ENQUEUE_LATENCY		0x10
 
 #define DEQUEUE_SLEEP		0x1
 
@@ -1125,13 +1127,18 @@ struct sched_entity {
 	struct rb_node		run_node;
 	struct list_head	group_node;
 	unsigned int		on_rq       : 1,
-				interactive : 1;
+				interactive : 8;
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
 	u64			vruntime;
 	u64			prev_sum_exec_runtime;
 
+	u64			deadline;
+	u64			min_deadline;
+	u64			lag;
+	u64			slice;
+
 	u64			nr_migrations;
 
 #ifdef CONFIG_SCHEDSTATS
@@ -1871,7 +1878,7 @@ static inline void wake_up_idle_cpu(int 
 #endif
 
 extern unsigned int sysctl_sched_latency;
-extern unsigned int sysctl_sched_min_granularity;
+extern unsigned int sysctl_sched_slice;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_shares_ratelimit;
 extern unsigned int sysctl_sched_shares_thresh;
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -282,8 +282,8 @@ static struct ctl_table kern_table[] = {
 	},
 #ifdef CONFIG_SCHED_DEBUG
 	{
-		.procname	= "sched_min_granularity_ns",
-		.data		= &sysctl_sched_min_granularity,
+		.procname	= "sched_slice_ns",
+		.data		= &sysctl_sched_slice,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= sched_proc_update_handler,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2365,7 +2365,7 @@ static int try_to_wake_up(struct task_st
 		if (current->sched_wake_interactive ||
 				wake_flags & WF_INTERACTIVE ||
 				current->se.interactive)
-			p->se.interactive = 1;
+			en_flags |= ENQUEUE_LATENCY;
 	}
 
 	this_cpu = get_cpu();
@@ -2442,6 +2442,8 @@ out_activate:
 		      cpu == this_cpu, en_flags);
 	success = 1;
 out_running:
+	trace_printk("sched_wakeup: wake_flags: %d enqueue_flags: %d\n",
+			wake_flags, en_flags);
 	ttwu_post_activation(p, rq, wake_flags, success);
 out:
 	task_rq_unlock(rq, &flags);
@@ -2515,6 +2517,7 @@ static void __sched_fork(struct task_str
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
+	p->se.lag			= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
@@ -5410,8 +5413,7 @@ static void update_sysctl(void)
 
 #define SET_SYSCTL(name) \
 	(sysctl_##name = (factor) * normalized_sysctl_##name)
-	SET_SYSCTL(sched_min_granularity);
-	SET_SYSCTL(sched_latency);
+	SET_SYSCTL(sched_slice);
 	SET_SYSCTL(sched_wakeup_granularity);
 	SET_SYSCTL(sched_shares_ratelimit);
 #undef SET_SYSCTL
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -52,3 +52,8 @@ SCHED_FEAT(INTERACTIVE, 0)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+SCHED_FEAT(EEVDF, 1)
+SCHED_FEAT(FAIR_DEADLINE, 1)
+SCHED_FEAT(ZERO_LAG, 0)
+SCHED_FEAT(PRESERVE_LAG, 0)

