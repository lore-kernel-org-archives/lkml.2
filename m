Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab2FOUNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:13:46 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59756 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab2FOUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:13:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/14] rcu: Consolidate tree/tiny __rcu_read_{,un}lock() implementations
Date: Fri, 15 Jun 2012 13:13:10 -0700
Message-Id: <1339791195-26389-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061520-7408-0000-0000-000005E491C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The CONFIG_TREE_PREEMPT_RCU and CONFIG_TINY_PREEMPT_RCU versions of
__rcu_read_unlock() and __rcu_read_unlock() are identical, so this commit
consolidates them into kernel/rcupdate.h.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 +
 kernel/rcupdate.c        |   44 +++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny_plugin.h  |   47 +---------------------------------------------
 kernel/rcutree_plugin.h  |   47 +---------------------------------------------
 4 files changed, 47 insertions(+), 92 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2f6ec55..f773a4a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -147,6 +147,7 @@ extern void synchronize_sched(void);
 
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
+extern void rcu_read_unlock_special(struct task_struct *t);
 void synchronize_rcu(void);
 
 /*
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 95cba41..4e6a61b 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -54,6 +54,50 @@
 #ifdef CONFIG_PREEMPT_RCU
 
 /*
+ * Preemptible RCU implementation for rcu_read_lock().
+ * Just increment ->rcu_read_lock_nesting, shared state will be updated
+ * if we block.
+ */
+void __rcu_read_lock(void)
+{
+	current->rcu_read_lock_nesting++;
+	barrier();  /* critical section after entry code. */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_lock);
+
+/*
+ * Preemptible RCU implementation for rcu_read_unlock().
+ * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ */
+void __rcu_read_unlock(void)
+{
+	struct task_struct *t = current;
+
+	if (t->rcu_read_lock_nesting != 1) {
+		--t->rcu_read_lock_nesting;
+	} else {
+		barrier();  /* critical section before exit code. */
+		t->rcu_read_lock_nesting = INT_MIN;
+		barrier();  /* assign before ->rcu_read_unlock_special load */
+		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+			rcu_read_unlock_special(t);
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		t->rcu_read_lock_nesting = 0;
+	}
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
+
+		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
+	}
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_unlock);
+
+/*
  * Check for a task exiting while in a preemptible-RCU read-side
  * critical section, clean up if so.  No need to issue warnings,
  * as debug_check_no_locks_held() already does this if lockdep
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index fc31a2d..a269b0d 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -132,7 +132,6 @@ static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
 	RCU_TRACE(.rcb.name = "rcu_preempt")
 };
 
-static void rcu_read_unlock_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(void);
 static void rcu_report_exp_done(void);
 
@@ -527,23 +526,11 @@ void rcu_preempt_note_context_switch(void)
 }
 
 /*
- * Tiny-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static noinline void rcu_read_unlock_special(struct task_struct *t)
+void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -627,38 +614,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 }
 
 /*
- * Tiny-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- */
-void __rcu_read_unlock(void)
-{
-	struct task_struct *t = current;
-
-	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
-	else {
-		t->rcu_read_lock_nesting = INT_MIN;
-		barrier();  /* assign before ->rcu_read_unlock_special load */
-		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-			rcu_read_unlock_special(t);
-		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
-	}
-#ifdef CONFIG_PROVE_LOCKING
-	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
-
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
-	}
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
-
-/*
  * Check for a quiescent state from the current CPU.  When a task blocks,
  * the task is recorded in the rcu_preempt_ctrlblk structure, which is
  * checked elsewhere.  This is called from the scheduling-clock interrupt.
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 2411000..d806186 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -78,7 +78,6 @@ struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
-static void rcu_read_unlock_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
 /*
@@ -233,18 +232,6 @@ void rcu_preempt_note_context_switch(void)
 }
 
 /*
- * Tree-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Check for preempted RCU readers blocking the current grace period
  * for the specified rcu_node structure.  If the caller needs a reliable
  * answer, it must hold the rcu_node's ->lock.
@@ -310,7 +297,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static noinline void rcu_read_unlock_special(struct task_struct *t)
+void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -418,38 +405,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	}
 }
 
-/*
- * Tree-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- */
-void __rcu_read_unlock(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting != 1)
-		--t->rcu_read_lock_nesting;
-	else {
-		barrier();  /* critical section before exit code. */
-		t->rcu_read_lock_nesting = INT_MIN;
-		barrier();  /* assign before ->rcu_read_unlock_special load */
-		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-			rcu_read_unlock_special(t);
-		barrier();  /* ->rcu_read_unlock_special load before assign */
-		t->rcu_read_lock_nesting = 0;
-	}
-#ifdef CONFIG_PROVE_LOCKING
-	{
-		int rrln = ACCESS_ONCE(t->rcu_read_lock_nesting);
-
-		WARN_ON_ONCE(rrln < 0 && rrln > INT_MIN / 2);
-	}
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
-
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
 /*
-- 
1.7.8

