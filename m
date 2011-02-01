Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab1BAOzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:55:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab1BAOyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:54:06 -0500
Date: Tue, 1 Feb 2011 09:51:03 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [PATCH -v8a 3/7] sched: use a buddy to implement yield_task_fair
Message-ID: <20110201095103.3a79e92a@annuminas.surriel.com>
In-Reply-To: <20110201094433.72829892@annuminas.surriel.com>
References: <20110201094433.72829892@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the buddy mechanism to implement yield_task_fair.  This
allows us to skip onto the next highest priority se at every
level in the CFS tree, unless doing so would introduce gross
unfairness in CPU time distribution.

We order the buddy selection in pick_next_entity to check
yield first, then last, then next.  We need next to be able
to override yield, because it is possible for the "next" and
"yield" task to be different processen in the same sub-tree
of the CFS tree.  When they are, we need to go into that
sub-tree regardless of the "yield" hint, and pick the correct
entity once we get to the right level.

Signed-off-by: Rik van Riel <riel@redhat.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..7ff53e2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -327,7 +327,7 @@ struct cfs_rq {
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr, *next, *last;
+	struct sched_entity *curr, *next, *last, *skip;
 
 	unsigned int nr_spread_over;
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 2e1b0d1..f9a2721 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -183,7 +183,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	if (cfs_rq->rb_leftmost)
-		MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
+		MIN_vruntime = (__pick_first_entity(cfs_rq))->vruntime;
 	last = __pick_last_entity(cfs_rq);
 	if (last)
 		max_vruntime = last->vruntime;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ad946fd..bd32d2a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -374,7 +374,7 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
@@ -384,6 +384,16 @@ static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 	return rb_entry(left, struct sched_entity, run_node);
 }
 
+static struct sched_entity *__pick_next_entity(struct sched_entity *se)
+{
+	struct rb_node *next = rb_next(&se->run_node);
+
+	if (!next)
+		return NULL;
+
+	return rb_entry(next, struct sched_entity, run_node);
+}
+
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
@@ -806,6 +816,17 @@ static void __clear_buddies_next(struct sched_entity *se)
 	}
 }
 
+static void __clear_buddies_skip(struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->skip == se)
+			cfs_rq->skip = NULL;
+		else
+			break;
+	}
+}
+
 static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->last == se)
@@ -813,6 +834,9 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	if (cfs_rq->next == se)
 		__clear_buddies_next(se);
+
+	if (cfs_rq->skip == se)
+		__clear_buddies_skip(se);
 }
 
 static void
@@ -885,7 +909,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
+		struct sched_entity *se = __pick_first_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
 		if (delta > ideal_runtime)
@@ -926,13 +950,27 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static int
 wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 
+/*
+ * Pick the next process, keeping these things in mind, in this order:
+ * 1) keep things fair between processes/task groups
+ * 2) pick the "next" process, since someone really wants that to run
+ * 3) pick the "last" process, for cache locality
+ * 4) do not run the "skip" process, if something else is available
+ */
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
-	struct sched_entity *se = __pick_next_entity(cfs_rq);
+	struct sched_entity *se = __pick_first_entity(cfs_rq);
 	struct sched_entity *left = se;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
+	/*
+	 * Avoid running the skip buddy, if running something else can
+	 * be done without getting too unfair.
+	 */
+	if (cfs_rq->skip == se) {
+		struct sched_entity *second = __pick_next_entity(se);
+		if (second && wakeup_preempt_entity(second, left) < 1)
+			se = second;
+	}
 
 	/*
 	 * Prefer last buddy, try to return the CPU to a preempted task.
@@ -940,6 +978,12 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
 		se = cfs_rq->last;
 
+	/*
+	 * Someone really wants this to run. If it's not unfair, run it.
+	 */
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
+		se = cfs_rq->next;
+
 	clear_buddies(cfs_rq, se);
 
 	return se;
@@ -1096,52 +1140,6 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	hrtick_update(rq);
 }
 
-/*
- * sched_yield() support is very simple - we dequeue and enqueue.
- *
- * If compat_yield is turned on then we requeue to the end of the tree.
- */
-static void yield_task_fair(struct rq *rq)
-{
-	struct task_struct *curr = rq->curr;
-	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
-	struct sched_entity *rightmost, *se = &curr->se;
-
-	/*
-	 * Are we the only task in the tree?
-	 */
-	if (unlikely(rq->nr_running == 1))
-		return;
-
-	clear_buddies(cfs_rq, se);
-
-	if (likely(!sysctl_sched_compat_yield) && curr->policy != SCHED_BATCH) {
-		update_rq_clock(rq);
-		/*
-		 * Update run-time statistics of the 'current'.
-		 */
-		update_curr(cfs_rq);
-
-		return;
-	}
-	/*
-	 * Find the rightmost entry in the rbtree:
-	 */
-	rightmost = __pick_last_entity(cfs_rq);
-	/*
-	 * Already in the rightmost position?
-	 */
-	if (unlikely(!rightmost || entity_before(rightmost, se)))
-		return;
-
-	/*
-	 * Minimally necessary key value to be last in the tree:
-	 * Upon rescheduling, sched_class::put_prev_task() will place
-	 * 'current' within the tree based on its new key value.
-	 */
-	se->vruntime = rightmost->vruntime + 1;
-}
-
 #ifdef CONFIG_SMP
 
 static void task_waking_fair(struct rq *rq, struct task_struct *p)
@@ -1660,6 +1658,14 @@ static void set_next_buddy(struct sched_entity *se)
 	}
 }
 
+static void set_skip_buddy(struct sched_entity *se)
+{
+	if (likely(task_of(se)->policy != SCHED_IDLE)) {
+		for_each_sched_entity(se)
+			cfs_rq_of(se)->skip = se;
+	}
+}
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -1758,6 +1764,36 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
 	}
 }
 
+/*
+ * sched_yield() is very simple
+ *
+ * The magic of dealing with the ->skip buddy is in pick_next_entity.
+ */
+static void yield_task_fair(struct rq *rq)
+{
+	struct task_struct *curr = rq->curr;
+	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	struct sched_entity *se = &curr->se;
+
+	/*
+	 * Are we the only task in the tree?
+	 */
+	if (unlikely(rq->nr_running == 1))
+		return;
+
+	clear_buddies(cfs_rq, se);
+
+	if (curr->policy != SCHED_BATCH) {
+		update_rq_clock(rq);
+		/*
+		 * Update run-time statistics of the 'current'.
+		 */
+		update_curr(cfs_rq);
+	}
+
+	set_skip_buddy(se);
+}
+
 #ifdef CONFIG_SMP
 /**************************************************
  * Fair scheduling class load-balancing methods:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5abfa15..6212b4e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -375,13 +375,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
-	{
-		.procname	= "sched_compat_yield",
-		.data		= &sysctl_sched_compat_yield,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.procname	= "prove_locking",

