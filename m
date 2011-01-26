Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1AZWZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:25:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1AZWZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:25:37 -0500
Date: Wed, 26 Jan 2011 17:21:01 -0500
From: Rik van Riel <riel@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: [RFC -v7 PATCH 3/7] sched: use a buddy to implement yield_task_fair
Message-ID: <20110126172101.7b5c22e6@annuminas.surriel.com>
In-Reply-To: <20110126165657.2ddd2ac9@annuminas.surriel.com>
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>
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
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ad946fd..a56d410 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -384,6 +384,22 @@ static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 	return rb_entry(left, struct sched_entity, run_node);
 }
 
+static struct sched_entity *__pick_second_entity(struct cfs_rq *cfs_rq)
+{
+	struct rb_node *left = cfs_rq->rb_leftmost;
+	struct rb_node *second;
+
+	if (!left)
+		return NULL;
+
+	second = rb_next(left);
+
+	if (!second)
+		second = left;
+
+	return rb_entry(second, struct sched_entity, run_node);
+}
+
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
@@ -806,6 +822,17 @@ static void __clear_buddies_next(struct sched_entity *se)
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
@@ -813,6 +840,9 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	if (cfs_rq->next == se)
 		__clear_buddies_next(se);
+
+	if (cfs_rq->skip == se)
+		__clear_buddies_skip(se);
 }
 
 static void
@@ -926,13 +956,27 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
 	struct sched_entity *left = se;
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
-		se = cfs_rq->next;
+	/*
+	 * Avoid running the skip buddy, if running something else can
+	 * be done without getting too unfair.
+	 */
+	if (cfs_rq->skip == se) {
+		struct sched_entity *second = __pick_second_entity(cfs_rq);
+		if (wakeup_preempt_entity(second, left) < 1)
+			se = second;
+	}
 
 	/*
 	 * Prefer last buddy, try to return the CPU to a preempted task.
@@ -940,6 +984,12 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
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
@@ -1096,52 +1146,6 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
@@ -1660,6 +1664,14 @@ static void set_next_buddy(struct sched_entity *se)
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
@@ -1758,6 +1770,36 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
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
