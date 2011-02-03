Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1BCOMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:12:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:35799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab1BCOMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:12:47 -0500
Date: Thu, 3 Feb 2011 14:12:16 GMT
From: tip-bot for Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110201095103.3a79e92a@annuminas.surriel.com>
References: <20110201095103.3a79e92a@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use a buddy to implement yield_task_fair()
Message-ID: <tip-ac53db596cc08ecb8040cfb6f71ae40c6f2041c4@git.kernel.org>
Git-Commit-ID: ac53db596cc08ecb8040cfb6f71ae40c6f2041c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 14:12:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac53db596cc08ecb8040cfb6f71ae40c6f2041c4
Gitweb:     http://git.kernel.org/tip/ac53db596cc08ecb8040cfb6f71ae40c6f2041c4
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 1 Feb 2011 09:51:03 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Feb 2011 14:20:33 +0100

sched: Use a buddy to implement yield_task_fair()

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110201095103.3a79e92a@annuminas.surriel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 -
 kernel/sched.c        |    2 +-
 kernel/sched_debug.c  |    2 +-
 kernel/sched_fair.c   |  148 +++++++++++++++++++++++++++++--------------------
 kernel/sysctl.c       |    7 --
 5 files changed, 90 insertions(+), 71 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0542774..4e9fad2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1942,8 +1942,6 @@ int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
-extern unsigned int sysctl_sched_compat_yield;
-
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern unsigned int sysctl_sched_autogroup_enabled;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 477e1bc..ae5e1a1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -324,7 +324,7 @@ struct cfs_rq {
 	 * 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr, *next, *last;
+	struct sched_entity *curr, *next, *last, *skip;
 
 	unsigned int nr_spread_over;
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index eb6cb8e..7bacd83 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -179,7 +179,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	if (cfs_rq->rb_leftmost)
-		MIN_vruntime = (__pick_next_entity(cfs_rq))->vruntime;
+		MIN_vruntime = (__pick_first_entity(cfs_rq))->vruntime;
 	last = __pick_last_entity(cfs_rq);
 	if (last)
 		max_vruntime = last->vruntime;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a785e08..c0fbeb9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -69,14 +69,6 @@ static unsigned int sched_nr_latency = 8;
 unsigned int sysctl_sched_child_runs_first __read_mostly;
 
 /*
- * sys_sched_yield() compat mode
- *
- * This option switches the agressive yield implementation of the
- * old scheduler back on.
- */
-unsigned int __read_mostly sysctl_sched_compat_yield;
-
-/*
  * SCHED_OTHER wake-up granularity.
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
@@ -419,7 +411,7 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
-static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
+static struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *left = cfs_rq->rb_leftmost;
 
@@ -429,6 +421,17 @@ static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
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
+#ifdef CONFIG_SCHED_DEBUG
 static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
 {
 	struct rb_node *last = rb_last(&cfs_rq->tasks_timeline);
@@ -443,7 +446,6 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
  * Scheduling class statistics methods:
  */
 
-#ifdef CONFIG_SCHED_DEBUG
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
@@ -1017,6 +1019,17 @@ static void __clear_buddies_next(struct sched_entity *se)
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
@@ -1024,6 +1037,9 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 	if (cfs_rq->next == se)
 		__clear_buddies_next(se);
+
+	if (cfs_rq->skip == se)
+		__clear_buddies_skip(se);
 }
 
 static void
@@ -1099,7 +1115,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (cfs_rq->nr_running > 1) {
-		struct sched_entity *se = __pick_next_entity(cfs_rq);
+		struct sched_entity *se = __pick_first_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
 		if (delta < 0)
@@ -1143,13 +1159,27 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
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
@@ -1157,6 +1187,12 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
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
@@ -1333,52 +1369,6 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
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
@@ -1849,6 +1839,14 @@ static void set_next_buddy(struct sched_entity *se)
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
@@ -1947,6 +1945,36 @@ static void put_prev_task_fair(struct rq *rq, struct task_struct *prev)
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
index bc86bb3..cbfda7e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -360,13 +360,6 @@ static struct ctl_table kern_table[] = {
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
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
