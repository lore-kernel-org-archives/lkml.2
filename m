Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2DNQU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:20:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41548 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2DNQUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 3/7] rcu: Make exit_rcu() more precise and consolidate
Date: Sat, 14 Apr 2012 09:20:33 -0700
Message-Id: <1334420437-19264-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-2398-0000-0000-000005D1BC10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

When running preemptible RCU, if a task exits in an RCU read-side
critical section having blocked within that same RCU read-side critical
section, the task must be removed from the list of tasks blocking a
grace period (perhaps the current grace period, perhaps the next grace
period, depending on timing).  The exit() path invokes exit_rcu() to
do this cleanup.

However, the current implementation of exit_rcu() needlessly does the
cleanup even if the task did not block within the current RCU read-side
critical section, which wastes time and needlessly increases the size
of the state space.  Fix this by only doing the cleanup if the current
task is actually on the list of tasks blocking some grace period.

While we are at it, consolidate the two identical exit_rcu() functions
into a single function.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 +
 include/linux/rcutiny.h  |    5 -----
 include/linux/rcutree.h  |   12 ------------
 kernel/rcupdate.c        |   27 ++++++++++++++++++++++++++-
 kernel/rcutiny_plugin.h  |   16 ----------------
 kernel/rcutree_plugin.h  |   16 ----------------
 6 files changed, 27 insertions(+), 50 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1cf19ef..5a94dcf 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -193,6 +193,7 @@ extern void rcu_idle_enter(void);
 extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+extern void exit_rcu(void);
 
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 080b5bd..adb5e5a 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -87,10 +87,6 @@ static inline void kfree_call_rcu(struct rcu_head *head,
 
 #ifdef CONFIG_TINY_RCU
 
-static inline void exit_rcu(void)
-{
-}
-
 static inline int rcu_needs_cpu(int cpu)
 {
 	return 0;
@@ -98,7 +94,6 @@ static inline int rcu_needs_cpu(int cpu)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
-extern void exit_rcu(void);
 int rcu_preempt_needs_cpu(void);
 
 static inline int rcu_needs_cpu(int cpu)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e8ee5dd..782a8ab 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -45,18 +45,6 @@ static inline void rcu_virt_note_context_switch(int cpu)
 	rcu_note_context_switch(cpu);
 }
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
-
-extern void exit_rcu(void);
-
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-
-static inline void exit_rcu(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
-
 extern void synchronize_rcu_bh(void);
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index eb5d160..1acf0da 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -54,7 +54,32 @@
 #ifdef CONFIG_PREEMPT_RCU
 DEFINE_PER_CPU(int, rcu_read_lock_nesting);
 DEFINE_PER_CPU(int, rcu_read_unlock_special);
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+
+/*
+ * Check for a task exiting while in a preemptible-RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.
+ */
+void exit_rcu(void)
+{
+	struct task_struct *t = current;
+
+	if (likely(list_empty(&current->rcu_node_entry)))
+		return;
+	t->rcu_read_lock_nesting = 1;
+	barrier();
+	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
+	__rcu_read_unlock();
+}
+
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+void exit_rcu(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index ff7ec65..66a542a 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -851,22 +851,6 @@ int rcu_preempt_needs_cpu(void)
 	return rcu_preempt_ctrlblk.rcb.rcucblist != NULL;
 }
 
-/*
- * Check for a task exiting while in a preemptible -RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting == 0)
-		return;
-	t->rcu_read_lock_nesting = 1;
-	__rcu_read_unlock();
-}
-
 #else /* #ifdef CONFIG_TINY_PREEMPT_RCU */
 
 #ifdef CONFIG_RCU_TRACE
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index f60b315..76a1ba9 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -969,22 +969,6 @@ static void __init __rcu_init_preempt(void)
 	rcu_init_one(&rcu_preempt_state, &rcu_preempt_data);
 }
 
-/*
- * Check for a task exiting while in a preemptible-RCU read-side
- * critical section, clean up if so.  No need to issue warnings,
- * as debug_check_no_locks_held() already does this if lockdep
- * is enabled.
- */
-void exit_rcu(void)
-{
-	struct task_struct *t = current;
-
-	if (t->rcu_read_lock_nesting == 0)
-		return;
-	t->rcu_read_lock_nesting = 1;
-	__rcu_read_unlock();
-}
-
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static struct rcu_state *rcu_state = &rcu_sched_state;
-- 
1.7.8

