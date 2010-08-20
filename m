Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0HTSqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:46:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42199 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab0HTSpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/7] rcu: combine duplicate code, courtesy of CONFIG_PREEMPT_RCU
Date: Fri, 20 Aug 2010 11:45:43 -0700
Message-Id: <1282329945-26043-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100820184521.GA24715@linux.vnet.ibm.com>
References: <20100820184521.GA24715@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_PREEMPT_RCU kernel configuration parameter was recently
re-introduced, but as an indication of the type of RCU (preemptible
vs. non-preemptible) instead of as selecting a given implementation.
This commit uses CONFIG_PREEMPT_RCU to combine duplicate code
from include/linux/rcutiny.h and include/linux/rcutree.h into
include/linux/rcupdate.h.  This commit also combines a few other pieces
of duplicate code that have accumulated.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   75 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/rcutiny.h  |   51 -------------------------------
 include/linux/rcutree.h  |   50 ------------------------------
 kernel/rcutree_plugin.h  |    9 -----
 4 files changed, 72 insertions(+), 113 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 325bad7..89414d6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -61,16 +61,30 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
+extern void call_rcu_sched(struct rcu_head *head,
+			   void (*func)(struct rcu_head *rcu));
+extern void synchronize_sched(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
 extern void synchronize_sched_expedited(void);
 extern int sched_expedited_torture_stats(char *page);
 
-/* Internal to kernel */
-extern void rcu_init(void);
+static inline void __rcu_read_lock_bh(void)
+{
+	local_bh_disable();
+}
+
+static inline void __rcu_read_unlock_bh(void)
+{
+	local_bh_enable();
+}
 
 #ifdef CONFIG_PREEMPT_RCU
 
+extern void __rcu_read_lock(void);
+extern void __rcu_read_unlock(void);
+void synchronize_rcu(void);
+
 /*
  * Defined as a macro as it is a very low level header included from
  * areas that don't even know about current.  This gives the rcu_read_lock()
@@ -79,7 +93,53 @@ extern void rcu_init(void);
  */
 #define rcu_preempt_depth() (current->rcu_read_lock_nesting)
 
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+static inline void __rcu_read_lock(void)
+{
+	preempt_disable();
+}
+
+static inline void __rcu_read_unlock(void)
+{
+	preempt_enable();
+}
+
+static inline void synchronize_rcu(void)
+{
+	synchronize_sched();
+}
+
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
+/* Internal to kernel */
+extern void rcu_init(void);
+extern void rcu_sched_qs(int cpu);
+extern void rcu_bh_qs(int cpu);
+extern void rcu_check_callbacks(int cpu, int user);
+struct notifier_block;
+
+#ifdef CONFIG_NO_HZ
+
+extern void rcu_enter_nohz(void);
+extern void rcu_exit_nohz(void);
+
+#else /* #ifdef CONFIG_NO_HZ */
+
+static inline void rcu_enter_nohz(void)
+{
+}
+
+static inline void rcu_exit_nohz(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ */
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
@@ -626,6 +686,8 @@ struct rcu_synchronize {
 
 extern void wakeme_after_rcu(struct rcu_head  *head);
 
+#ifdef CONFIG_PREEMPT_RCU
+
 /**
  * call_rcu() - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -642,6 +704,13 @@ extern void wakeme_after_rcu(struct rcu_head  *head);
 extern void call_rcu(struct rcu_head *head,
 			      void (*func)(struct rcu_head *head));
 
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+/* In classic RCU, call_rcu() is just call_rcu_sched(). */
+#define	call_rcu	call_rcu_sched
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
 /**
  * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
  * @head: structure to be used for queueing the RCU updates.
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index c6b11dc..13877cb 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,34 +27,10 @@
 
 #include <linux/cache.h>
 
-void rcu_sched_qs(int cpu);
-void rcu_bh_qs(int cpu);
-
-#ifdef CONFIG_TINY_RCU
-#define __rcu_read_lock()	preempt_disable()
-#define __rcu_read_unlock()	preempt_enable()
-#else /* #ifdef CONFIG_TINY_RCU */
-void __rcu_read_lock(void);
-void __rcu_read_unlock(void);
-#endif /* #else #ifdef CONFIG_TINY_RCU */
-#define __rcu_read_lock_bh()	local_bh_disable()
-#define __rcu_read_unlock_bh()	local_bh_enable()
-extern void call_rcu_sched(struct rcu_head *head,
-			   void (*func)(struct rcu_head *rcu));
-
 #define rcu_init_sched()	do { } while (0)
 
-extern void synchronize_sched(void);
-
 #ifdef CONFIG_TINY_RCU
 
-#define call_rcu		call_rcu_sched
-
-static inline void synchronize_rcu(void)
-{
-	synchronize_sched();
-}
-
 static inline void synchronize_rcu_expedited(void)
 {
 	synchronize_sched();	/* Only one CPU, so pretty fast anyway!!! */
@@ -67,7 +43,6 @@ static inline void rcu_barrier(void)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
-void synchronize_rcu(void);
 void rcu_barrier(void);
 void synchronize_rcu_expedited(void);
 
@@ -83,25 +58,6 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched();
 }
 
-struct notifier_block;
-
-#ifdef CONFIG_NO_HZ
-
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-
-#else /* #ifdef CONFIG_NO_HZ */
-
-static inline void rcu_enter_nohz(void)
-{
-}
-
-static inline void rcu_exit_nohz(void)
-{
-}
-
-#endif /* #else #ifdef CONFIG_NO_HZ */
-
 #ifdef CONFIG_TINY_RCU
 
 static inline void rcu_preempt_note_context_switch(void)
@@ -117,11 +73,6 @@ static inline int rcu_needs_cpu(int cpu)
 	return 0;
 }
 
-static inline int rcu_preempt_depth(void)
-{
-	return 0;
-}
-
 #else /* #ifdef CONFIG_TINY_RCU */
 
 void rcu_preempt_note_context_switch(void);
@@ -141,8 +92,6 @@ static inline void rcu_note_context_switch(int cpu)
 	rcu_preempt_note_context_switch();
 }
 
-extern void rcu_check_callbacks(int cpu, int user);
-
 /*
  * Return the number of grace periods.
  */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 54a20c1..95518e6 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,59 +30,23 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-struct notifier_block;
-
-extern void rcu_sched_qs(int cpu);
-extern void rcu_bh_qs(int cpu);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
-extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-static inline void __rcu_read_lock(void)
-{
-	preempt_disable();
-}
-
-static inline void __rcu_read_unlock(void)
-{
-	preempt_enable();
-}
-
-#define synchronize_rcu synchronize_sched
-
 static inline void exit_rcu(void)
 {
 }
 
-static inline int rcu_preempt_depth(void)
-{
-	return 0;
-}
-
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-static inline void __rcu_read_lock_bh(void)
-{
-	local_bh_disable();
-}
-static inline void __rcu_read_unlock_bh(void)
-{
-	local_bh_enable();
-}
-
-extern void call_rcu_sched(struct rcu_head *head,
-			   void (*func)(struct rcu_head *rcu));
 extern void synchronize_rcu_bh(void);
-extern void synchronize_sched(void);
 extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
@@ -92,8 +56,6 @@ static inline void synchronize_rcu_bh_expedited(void)
 
 extern void rcu_barrier(void);
 
-extern void rcu_check_callbacks(int cpu, int user);
-
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
@@ -101,18 +63,6 @@ extern void rcu_force_quiescent_state(void);
 extern void rcu_bh_force_quiescent_state(void);
 extern void rcu_sched_force_quiescent_state(void);
 
-#ifdef CONFIG_NO_HZ
-void rcu_enter_nohz(void);
-void rcu_exit_nohz(void);
-#else /* CONFIG_NO_HZ */
-static inline void rcu_enter_nohz(void)
-{
-}
-static inline void rcu_exit_nohz(void)
-{
-}
-#endif /* CONFIG_NO_HZ */
-
 /* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
 {
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 561410f..87f60f0 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -939,15 +939,6 @@ static void rcu_preempt_process_callbacks(void)
 }
 
 /*
- * In classic RCU, call_rcu() is just call_rcu_sched().
- */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
-{
-	call_rcu_sched(head, func);
-}
-EXPORT_SYMBOL_GPL(call_rcu);
-
-/*
  * Wait for an rcu-preempt grace period, but make it happen quickly.
  * But because preemptable RCU does not exist, map to rcu-sched.
  */
-- 
1.7.0.6

