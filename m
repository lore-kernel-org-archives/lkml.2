Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1BWBlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 20:41:53 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54791 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab1BWBjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 20:39:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 09/11] rcu: merge TREE_PREEPT_RCU blocked_tasks[] lists
Date: Tue, 22 Feb 2011 17:39:38 -0800
Message-Id: <1298425183-21265-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110223013917.GA20996@linux.vnet.ibm.com>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Combine the current TREE_PREEMPT_RCU ->blocked_tasks[] lists in the
rcu_node structure into a single ->blkd_tasks list with ->gp_tasks
and ->exp_tasks tail pointers.  This is in preparation for RCU priority
boosting, which will add a third dimension to the combinatorial explosion
in the ->blocked_tasks[] case, but simply a third pointer in the new
->blkd_tasks case.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
---
 kernel/rcutree.c        |    5 +-
 kernel/rcutree.h        |   21 ++++--
 kernel/rcutree_plugin.h |  163 ++++++++++++++++++++++++++++-------------------
 kernel/rcutree_trace.c  |   11 +--
 4 files changed, 117 insertions(+), 83 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 90104a1..0ac1cc0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1901,10 +1901,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 					      j / rsp->levelspread[i - 1];
 			}
 			rnp->level = i;
-			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[2]);
-			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
+			INIT_LIST_HEAD(&rnp->blkd_tasks);
 		}
 	}
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index bd891de..5a439c1 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -107,7 +107,7 @@ struct rcu_node {
 				/*  an rcu_data structure, otherwise, each */
 				/*  bit corresponds to a child rcu_node */
 				/*  structure. */
-	unsigned long expmask;	/* Groups that have ->blocked_tasks[] */
+	unsigned long expmask;	/* Groups that have ->blkd_tasks */
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
@@ -120,11 +120,20 @@ struct rcu_node {
 	u8	grpnum;		/* CPU/group number for next level up. */
 	u8	level;		/* root is at level 0. */
 	struct rcu_node *parent;
-	struct list_head blocked_tasks[4];
-				/* Tasks blocked in RCU read-side critsect. */
-				/*  Grace period number (->gpnum) x blocked */
-				/*  by tasks on the (x & 0x1) element of the */
-				/*  blocked_tasks[] array. */
+	struct list_head blkd_tasks;
+				/* Tasks blocked in RCU read-side critical */
+				/*  section.  Tasks are placed at the head */
+				/*  of this list and age towards the tail. */
+	struct list_head *gp_tasks;
+				/* Pointer to the first task blocking the */
+				/*  current grace period, or NULL if there */
+				/*  is no such task. */
+	struct list_head *exp_tasks;
+				/* Pointer to the first task blocking the */
+				/*  current expedited grace period, or NULL */
+				/*  if there is no such task.  If there */
+				/*  is no current expedited grace period, */
+				/*  then there can cannot be any such task. */
 } ____cacheline_internodealigned_in_smp;
 
 /*
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 764b5fc..774f010 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -130,12 +130,12 @@ static void rcu_preempt_qs(int cpu)
  * We have entered the scheduler, and the current task might soon be
  * context-switched away from.  If this task is in an RCU read-side
  * critical section, we will no longer be able to rely on the CPU to
- * record that fact, so we enqueue the task on the appropriate entry
- * of the blocked_tasks[] array.  The task will dequeue itself when
- * it exits the outermost enclosing RCU read-side critical section.
- * Therefore, the current grace period cannot be permitted to complete
- * until the blocked_tasks[] entry indexed by the low-order bit of
- * rnp->gpnum empties.
+ * record that fact, so we enqueue the task on the blkd_tasks list.
+ * The task will dequeue itself when it exits the outermost enclosing
+ * RCU read-side critical section.  Therefore, the current grace period
+ * cannot be permitted to complete until the blkd_tasks list entries
+ * predating the current grace period drain, in other words, until
+ * rnp->gp_tasks becomes NULL.
  *
  * Caller must disable preemption.
  */
@@ -143,7 +143,6 @@ static void rcu_preempt_note_context_switch(int cpu)
 {
 	struct task_struct *t = current;
 	unsigned long flags;
-	int phase;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
 
@@ -165,15 +164,26 @@ static void rcu_preempt_note_context_switch(int cpu)
 		 * (i.e., this CPU has not yet passed through a quiescent
 		 * state for the current grace period), then as long
 		 * as that task remains queued, the current grace period
-		 * cannot end.
+		 * cannot end.  Note that there is some uncertainty as
+		 * to exactly when the current grace period started.
+		 * We take a conservative approach, which can result
+		 * in unnecessarily waiting on tasks that started very
+		 * slightly after the current grace period began.  C'est
+		 * la vie!!!
 		 *
 		 * But first, note that the current CPU must still be
 		 * on line!
 		 */
 		WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
 		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
-		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
-		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
+		if ((rnp->qsmask & rdp->grpmask) && rnp->gp_tasks != NULL) {
+			list_add(&t->rcu_node_entry, rnp->gp_tasks->prev);
+			rnp->gp_tasks = &t->rcu_node_entry;
+		} else {
+			list_add(&t->rcu_node_entry, &rnp->blkd_tasks);
+			if (rnp->qsmask & rdp->grpmask)
+				rnp->gp_tasks = &t->rcu_node_entry;
+		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
@@ -210,10 +220,7 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  */
 static int rcu_preempted_readers(struct rcu_node *rnp)
 {
-	int phase = rnp->gpnum & 0x1;
-
-	return !list_empty(&rnp->blocked_tasks[phase]) ||
-	       !list_empty(&rnp->blocked_tasks[phase + 2]);
+	return rnp->gp_tasks != NULL;
 }
 
 /*
@@ -253,6 +260,21 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
+ * Advance a ->blkd_tasks-list pointer to the next entry, instead
+ * returning NULL if at the end of the list.
+ */
+static struct list_head *rcu_next_node_entry(struct task_struct *t,
+					     struct rcu_node *rnp)
+{
+	struct list_head *np;
+
+	np = t->rcu_node_entry.next;
+	if (np == &rnp->blkd_tasks)
+		np = NULL;
+	return np;
+}
+
+/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
@@ -262,6 +284,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 	int empty;
 	int empty_exp;
 	unsigned long flags;
+	struct list_head *np;
 	struct rcu_node *rnp;
 	int special;
 
@@ -305,7 +328,12 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		empty = !rcu_preempted_readers(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
 		smp_mb(); /* ensure expedited fastpath sees end of RCU c-s. */
+		np = rcu_next_node_entry(t, rnp);
 		list_del_init(&t->rcu_node_entry);
+		if (&t->rcu_node_entry == rnp->gp_tasks)
+			rnp->gp_tasks = np;
+		if (&t->rcu_node_entry == rnp->exp_tasks)
+			rnp->exp_tasks = np;
 		t->rcu_blocked_node = NULL;
 
 		/*
@@ -361,18 +389,16 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
 {
 	unsigned long flags;
-	struct list_head *lp;
-	int phase;
 	struct task_struct *t;
 
-	if (rcu_preempted_readers(rnp)) {
-		raw_spin_lock_irqsave(&rnp->lock, flags);
-		phase = rnp->gpnum & 0x1;
-		lp = &rnp->blocked_tasks[phase];
-		list_for_each_entry(t, lp, rcu_node_entry)
-			sched_show_task(t);
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	}
+	if (!rcu_preempted_readers(rnp))
+		return;
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	t = list_entry(rnp->gp_tasks,
+		       struct task_struct, rcu_node_entry);
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+		sched_show_task(t);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -402,16 +428,14 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
-	struct list_head *lp;
-	int phase;
 	struct task_struct *t;
 
-	if (rcu_preempted_readers(rnp)) {
-		phase = rnp->gpnum & 0x1;
-		lp = &rnp->blocked_tasks[phase];
-		list_for_each_entry(t, lp, rcu_node_entry)
-			printk(" P%d", t->pid);
-	}
+	if (!rcu_preempted_readers(rnp))
+		return;
+	t = list_entry(rnp->gp_tasks,
+		       struct task_struct, rcu_node_entry);
+	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
+		printk(" P%d", t->pid);
 }
 
 /*
@@ -430,10 +454,15 @@ static void rcu_preempt_stall_reset(void)
  * period that still has RCU readers blocked!  This function must be
  * invoked -before- updating this rnp's ->gpnum, and the rnp's ->lock
  * must be held by the caller.
+ *
+ * Also, if there are blocked tasks on the list, they automatically
+ * block the newly created grace period, so set up ->gp_tasks accordingly.
  */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
 {
 	WARN_ON_ONCE(rcu_preempted_readers(rnp));
+	if (!list_empty(&rnp->blkd_tasks))
+		rnp->gp_tasks = rnp->blkd_tasks.next;
 	WARN_ON_ONCE(rnp->qsmask);
 }
 
@@ -457,45 +486,49 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 				     struct rcu_node *rnp,
 				     struct rcu_data *rdp)
 {
-	int i;
 	struct list_head *lp;
 	struct list_head *lp_root;
 	int retval = 0;
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
-	struct task_struct *tp;
+	struct task_struct *t;
 
 	if (rnp == rnp_root) {
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
 		return 0;  /* Shouldn't happen: at least one CPU online. */
 	}
-	WARN_ON_ONCE(rnp != rdp->mynode &&
-		     (!list_empty(&rnp->blocked_tasks[0]) ||
-		      !list_empty(&rnp->blocked_tasks[1]) ||
-		      !list_empty(&rnp->blocked_tasks[2]) ||
-		      !list_empty(&rnp->blocked_tasks[3])));
+
+	/* If we are on an internal node, complain bitterly. */
+	WARN_ON_ONCE(rnp != rdp->mynode);
 
 	/*
-	 * Move tasks up to root rcu_node.  Rely on the fact that the
-	 * root rcu_node can be at most one ahead of the rest of the
-	 * rcu_nodes in terms of gp_num value.  This fact allows us to
-	 * move the blocked_tasks[] array directly, element by element.
+	 * Move tasks up to root rcu_node.  Don't try to get fancy for
+	 * this corner-case operation -- just put this node's tasks
+	 * at the head of the root node's list, and update the root node's
+	 * ->gp_tasks and ->exp_tasks pointers to those of this node's,
+	 * if non-NULL.  This might result in waiting for more tasks than
+	 * absolutely necessary, but this is a good performance/complexity
+	 * tradeoff.
 	 */
 	if (rcu_preempted_readers(rnp))
 		retval |= RCU_OFL_TASKS_NORM_GP;
 	if (rcu_preempted_readers_exp(rnp))
 		retval |= RCU_OFL_TASKS_EXP_GP;
-	for (i = 0; i < 4; i++) {
-		lp = &rnp->blocked_tasks[i];
-		lp_root = &rnp_root->blocked_tasks[i];
-		while (!list_empty(lp)) {
-			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
-			raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
-			list_del(&tp->rcu_node_entry);
-			tp->rcu_blocked_node = rnp_root;
-			list_add(&tp->rcu_node_entry, lp_root);
-			raw_spin_unlock(&rnp_root->lock); /* irqs remain disabled */
-		}
+	lp = &rnp->blkd_tasks;
+	lp_root = &rnp_root->blkd_tasks;
+	while (!list_empty(lp)) {
+		t = list_entry(lp->next, typeof(*t), rcu_node_entry);
+		raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
+		list_del(&t->rcu_node_entry);
+		t->rcu_blocked_node = rnp_root;
+		list_add(&t->rcu_node_entry, lp_root);
+		if (&t->rcu_node_entry == rnp->gp_tasks)
+			rnp_root->gp_tasks = rnp->gp_tasks;
+		if (&t->rcu_node_entry == rnp->exp_tasks)
+			rnp_root->exp_tasks = rnp->exp_tasks;
+		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 	}
+	rnp->gp_tasks = NULL;
+	rnp->exp_tasks = NULL;
 	return retval;
 }
 
@@ -586,8 +619,7 @@ static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
  */
 static int rcu_preempted_readers_exp(struct rcu_node *rnp)
 {
-	return !list_empty(&rnp->blocked_tasks[2]) ||
-	       !list_empty(&rnp->blocked_tasks[3]);
+	return rnp->exp_tasks != NULL;
 }
 
 /*
@@ -647,12 +679,13 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 static void
 sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-	int must_wait;
+	int must_wait = 0;
 
 	raw_spin_lock(&rnp->lock); /* irqs already disabled */
-	list_splice_init(&rnp->blocked_tasks[0], &rnp->blocked_tasks[2]);
-	list_splice_init(&rnp->blocked_tasks[1], &rnp->blocked_tasks[3]);
-	must_wait = rcu_preempted_readers_exp(rnp);
+	if (!list_empty(&rnp->blkd_tasks)) {
+		rnp->exp_tasks = rnp->blkd_tasks.next;
+		must_wait = 1;
+	}
 	raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 	if (!must_wait)
 		rcu_report_exp_rnp(rsp, rnp);
@@ -661,9 +694,7 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 /*
  * Wait for an rcu-preempt grace period, but expedite it.  The basic idea
  * is to invoke synchronize_sched_expedited() to push all the tasks to
- * the ->blocked_tasks[] lists, move all entries from the first set of
- * ->blocked_tasks[] lists to the second set, and finally wait for this
- * second set to drain.
+ * the ->blkd_tasks lists and wait for this list to drain.
  */
 void synchronize_rcu_expedited(void)
 {
@@ -695,7 +726,7 @@ void synchronize_rcu_expedited(void)
 	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
 		goto unlock_mb_ret; /* Others did our work for us. */
 
-	/* force all RCU readers onto blocked_tasks[]. */
+	/* force all RCU readers onto ->blkd_tasks lists. */
 	synchronize_sched_expedited();
 
 	raw_spin_lock_irqsave(&rsp->onofflock, flags);
@@ -707,7 +738,7 @@ void synchronize_rcu_expedited(void)
 		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
 
-	/* Snapshot current state of ->blocked_tasks[] lists. */
+	/* Snapshot current state of ->blkd_tasks lists. */
 	rcu_for_each_leaf_node(rsp, rnp)
 		sync_rcu_preempt_exp_init(rsp, rnp);
 	if (NUM_RCU_NODES > 1)
@@ -715,7 +746,7 @@ void synchronize_rcu_expedited(void)
 
 	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 
-	/* Wait for snapshotted ->blocked_tasks[] lists to drain. */
+	/* Wait for snapshotted ->blkd_tasks lists to drain. */
 	rnp = rcu_get_root(rsp);
 	wait_event(sync_rcu_preempt_exp_wq,
 		   sync_rcu_preempt_exp_done(rnp));
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4a21ca5..1cedf94 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -161,7 +161,6 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
 	unsigned long gpnum;
 	int level = 0;
-	int phase;
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
@@ -178,13 +177,11 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 			seq_puts(m, "\n");
 			level = rnp->level;
 		}
-		phase = gpnum & 0x1;
-		seq_printf(m, "%lx/%lx %c%c>%c%c %d:%d ^%d    ",
+		seq_printf(m, "%lx/%lx %c%c>%c %d:%d ^%d    ",
 			   rnp->qsmask, rnp->qsmaskinit,
-			   "T."[list_empty(&rnp->blocked_tasks[phase])],
-			   "E."[list_empty(&rnp->blocked_tasks[phase + 2])],
-			   "T."[list_empty(&rnp->blocked_tasks[!phase])],
-			   "E."[list_empty(&rnp->blocked_tasks[!phase + 2])],
+			   ".G"[rnp->gp_tasks != NULL],
+			   ".E"[rnp->exp_tasks != NULL],
+			   ".T"[!list_empty(&rnp->blkd_tasks)],
 			   rnp->grplo, rnp->grphi, rnp->grpnum);
 	}
 	seq_puts(m, "\n");
-- 
1.7.3.2

