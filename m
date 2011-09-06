Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1IGGVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:21:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49975 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1IGGUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/55] rcu: Abstract common code for RCU grace-period-wait primitives
Date: Tue,  6 Sep 2011 11:00:02 -0700
Message-Id: <1315332049-2604-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pull the code that waits for an RCU grace period into a single function,
which is then called by synchronize_rcu() and friends in the case of
TREE_RCU and TREE_PREEMPT_RCU, and from rcu_barrier() and friends in
the case of TINY_RCU and TINY_PREEMPT_RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |  130 ++++++++++++++++++++++++++--------------------
 include/linux/rcutiny.h  |   16 +++++-
 include/linux/rcutree.h  |    2 +
 kernel/rcupdate.c        |   21 +++++++-
 kernel/rcutiny.c         |   28 ----------
 kernel/rcutiny_plugin.h  |   14 -----
 kernel/rcutree.c         |   22 +-------
 kernel/rcutree_plugin.h  |   11 +----
 8 files changed, 113 insertions(+), 131 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2516555..6433a6f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -66,11 +66,73 @@ static inline void rcutorture_record_progress(unsigned long vernum)
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
 /* Exported common interfaces */
+
+#ifdef CONFIG_PREEMPT_RCU
+
+/**
+ * call_rcu() - Queue an RCU callback for invocation after a grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all pre-existing RCU read-side
+ * critical sections have completed.  However, the callback function
+ * might well execute concurrently with RCU read-side critical sections
+ * that started after call_rcu() was invoked.  RCU read-side critical
+ * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
+ * and may be nested.
+ */
+extern void call_rcu(struct rcu_head *head,
+			      void (*func)(struct rcu_head *head));
+
+#else /* #ifdef CONFIG_PREEMPT_RCU */
+
+/* In classic RCU, call_rcu() is just call_rcu_sched(). */
+#define	call_rcu	call_rcu_sched
+
+#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
+
+/**
+ * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all currently executing RCU
+ * read-side critical sections have completed. call_rcu_bh() assumes
+ * that the read-side critical sections end on completion of a softirq
+ * handler. This means that read-side critical sections in process
+ * context must not be interrupted by softirqs. This interface is to be
+ * used when most of the read-side critical sections are in softirq context.
+ * RCU read-side critical sections are delimited by :
+ *  - rcu_read_lock() and  rcu_read_unlock(), if in interrupt context.
+ *  OR
+ *  - rcu_read_lock_bh() and rcu_read_unlock_bh(), if in process context.
+ *  These may be nested.
+ */
+extern void call_rcu_bh(struct rcu_head *head,
+			void (*func)(struct rcu_head *head));
+
+/**
+ * call_rcu_sched() - Queue an RCU for invocation after sched grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all currently executing RCU
+ * read-side critical sections have completed. call_rcu_sched() assumes
+ * that the read-side critical sections end on enabling of preemption
+ * or on voluntary preemption.
+ * RCU read-side critical sections are delimited by :
+ *  - rcu_read_lock_sched() and  rcu_read_unlock_sched(),
+ *  OR
+ *  anything that disables preemption.
+ *  These may be nested.
+ */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
+
 extern void synchronize_sched(void);
-extern void rcu_barrier_bh(void);
-extern void rcu_barrier_sched(void);
 
 static inline void __rcu_read_lock_bh(void)
 {
@@ -143,6 +205,15 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
+/*
+ * Infrastructure to implement the synchronize_() primitives in
+ * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
+ */
+
+typedef void call_rcu_func_t(struct rcu_head *head,
+			     void (*func)(struct rcu_head *head));
+void wait_rcu_gp(call_rcu_func_t crf);
+
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
 #elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
@@ -723,61 +794,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
-/* Infrastructure to implement the synchronize_() primitives. */
-
-struct rcu_synchronize {
-	struct rcu_head head;
-	struct completion completion;
-};
-
-extern void wakeme_after_rcu(struct rcu_head  *head);
-
-#ifdef CONFIG_PREEMPT_RCU
-
-/**
- * call_rcu() - Queue an RCU callback for invocation after a grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual callback function to be invoked after the grace period
- *
- * The callback function will be invoked some time after a full grace
- * period elapses, in other words after all pre-existing RCU read-side
- * critical sections have completed.  However, the callback function
- * might well execute concurrently with RCU read-side critical sections
- * that started after call_rcu() was invoked.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
- */
-extern void call_rcu(struct rcu_head *head,
-			      void (*func)(struct rcu_head *head));
-
-#else /* #ifdef CONFIG_PREEMPT_RCU */
-
-/* In classic RCU, call_rcu() is just call_rcu_sched(). */
-#define	call_rcu	call_rcu_sched
-
-#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
-
-/**
- * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual callback function to be invoked after the grace period
- *
- * The callback function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed. call_rcu_bh() assumes
- * that the read-side critical sections end on completion of a softirq
- * handler. This means that read-side critical sections in process
- * context must not be interrupted by softirqs. This interface is to be
- * used when most of the read-side critical sections are in softirq context.
- * RCU read-side critical sections are delimited by :
- *  - rcu_read_lock() and  rcu_read_unlock(), if in interrupt context.
- *  OR
- *  - rcu_read_lock_bh() and rcu_read_unlock_bh(), if in process context.
- *  These may be nested.
- */
-extern void call_rcu_bh(struct rcu_head *head,
-			void (*func)(struct rcu_head *head));
-
 /*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
  * by call_rcu() and rcu callback execution, and are therefore not part of the
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 52b3e02..4eab233 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -31,6 +31,16 @@ static inline void rcu_init(void)
 {
 }
 
+static inline void rcu_barrier_bh(void)
+{
+	wait_rcu_gp(call_rcu_bh);
+}
+
+static inline void rcu_barrier_sched(void)
+{
+	wait_rcu_gp(call_rcu_sched);
+}
+
 #ifdef CONFIG_TINY_RCU
 
 static inline void synchronize_rcu_expedited(void)
@@ -45,9 +55,13 @@ static inline void rcu_barrier(void)
 
 #else /* #ifdef CONFIG_TINY_RCU */
 
-void rcu_barrier(void);
 void synchronize_rcu_expedited(void);
 
+static inline void rcu_barrier(void)
+{
+	wait_rcu_gp(call_rcu);
+}
+
 #endif /* #else #ifdef CONFIG_TINY_RCU */
 
 static inline void synchronize_rcu_bh(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e65d066..6745846 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -67,6 +67,8 @@ static inline void synchronize_rcu_bh_expedited(void)
 }
 
 extern void rcu_barrier(void);
+extern void rcu_barrier_bh(void);
+extern void rcu_barrier_sched(void);
 
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 7784bd2..a088c90 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -94,11 +94,16 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
+
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
  */
-void wakeme_after_rcu(struct rcu_head  *head)
+static void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
 
@@ -106,6 +111,20 @@ void wakeme_after_rcu(struct rcu_head  *head)
 	complete(&rcu->completion);
 }
 
+void wait_rcu_gp(call_rcu_func_t crf)
+{
+	struct rcu_synchronize rcu;
+
+	init_rcu_head_on_stack(&rcu.head);
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	crf(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+	destroy_rcu_head_on_stack(&rcu.head);
+}
+EXPORT_SYMBOL_GPL(wait_rcu_gp);
+
 #ifdef CONFIG_PROVE_RCU
 /*
  * wrapper function to avoid #include problems.
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 7bbac7d..f544e34 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -281,34 +281,6 @@ void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu_bh);
 
-void rcu_barrier_bh(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_bh(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_bh);
-
-void rcu_barrier_sched(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_sched(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_sched);
-
 /*
  * Spawn the kthread that invokes RCU callbacks.
  */
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f259c67..6b0cedb 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -697,20 +697,6 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
-void rcu_barrier(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
-}
-EXPORT_SYMBOL_GPL(rcu_barrier);
-
 /*
  * synchronize_rcu - wait until a grace period has elapsed.
  *
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ba06207..a7c6bce 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1613,18 +1613,9 @@ EXPORT_SYMBOL_GPL(call_rcu_bh);
  */
 void synchronize_sched(void)
 {
-	struct rcu_synchronize rcu;
-
 	if (rcu_blocking_is_gp())
 		return;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_sched(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
+	wait_rcu_gp(call_rcu_sched);
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
@@ -1639,18 +1630,9 @@ EXPORT_SYMBOL_GPL(synchronize_sched);
  */
 void synchronize_rcu_bh(void)
 {
-	struct rcu_synchronize rcu;
-
 	if (rcu_blocking_is_gp())
 		return;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_bh(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
+	wait_rcu_gp(call_rcu_bh);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 9703298..43daa46 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -656,18 +656,9 @@ EXPORT_SYMBOL_GPL(call_rcu);
  */
 void synchronize_rcu(void)
 {
-	struct rcu_synchronize rcu;
-
 	if (!rcu_scheduler_active)
 		return;
-
-	init_rcu_head_on_stack(&rcu.head);
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-	destroy_rcu_head_on_stack(&rcu.head);
+	wait_rcu_gp(call_rcu);
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
-- 
1.7.3.2

