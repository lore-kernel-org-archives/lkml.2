Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0C0Pii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:38:38 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:34901 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab0C0Pif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:38:35 -0400
Message-Id: <20100327153619.855387068@efficios.com>
References: <20100327153233.993367557@efficios.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Mar 2010 11:32:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 5/6] tree/tiny rcu: Add debug RCU head objects (v4)
Content-Disposition: inline; filename=rcu-head-debug.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 27 Mar 2010 15:36:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helps finding racy users of call_rcu(), which results in hangs because list
entries are overwritten and/or skipped.

Changelog since v3:
- Include comments from Lai Jiangshan

This new patch version is based on the debugobjects with the newly introduced
"active state" tracker.

Non-initialized entries are all considered as "statically initialized". An
activation fixup (triggered by call_rcu()) takes care of performing the debug
object initialization without issuing any warning. Since we cannot increase the
size of struct rcu_head, I don't see much room to put an identifier for
statically initialized rcu_head structures. So for now, we have to live without
"activation without explicit init" detection. But the main purpose of this debug
option is to detect double-activations (double call_rcu() use of a rcu_head
before the callback is executed), which is correctly addressed here.

This also detects potential internal RCU callback corruption, which would cause
the callbacks to be executed twice.

[bissectability warning]
This patch and "kernel call_rcu usage: initialize rcu_head structures" should be
applied together.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org
CC: mingo@elte.hu
CC: laijs@cn.fujitsu.com
CC: dipankar@in.ibm.com
CC: josh@joshtriplett.org
CC: dvhltc@us.ibm.com
CC: niv@us.ibm.com
CC: tglx@linutronix.de
CC: peterz@infradead.org
CC: rostedt@goodmis.org
CC: Valdis.Kletnieks@vt.edu
CC: dhowells@redhat.com
CC: eric.dumazet@gmail.com
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/rcupdate.h |   61 +++++++++++++++--
 kernel/rcupdate.c        |  168 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny.c         |    2 
 kernel/rcutree.c         |    2 
 lib/Kconfig.debug        |    6 +
 5 files changed, 235 insertions(+), 4 deletions(-)

Index: linux.trees.git/include/linux/rcupdate.h
===================================================================
--- linux.trees.git.orig/include/linux/rcupdate.h	2010-03-27 11:16:29.000000000 -0400
+++ linux.trees.git/include/linux/rcupdate.h	2010-03-27 11:16:37.000000000 -0400
@@ -40,6 +40,7 @@
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>
+#include <linux/debugobjects.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -77,11 +78,26 @@ extern void rcu_scheduler_starting(void)
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
+/* For dynamic initialization of rcu_head allocated in memory */
+extern void rcu_head_init(struct rcu_head *head);
+
+/* For static initialization of rcu_head */
 #define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
-#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
-#define INIT_RCU_HEAD(ptr) do { \
-       (ptr)->next = NULL; (ptr)->func = NULL; \
-} while (0)
+
+/* For dynamic initialization and destruction of rcu_head on the stack */
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+extern void rcu_head_init_on_stack(struct rcu_head *head);
+extern void destroy_rcu_head_on_stack(struct rcu_head *head);
+#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void rcu_head_init_on_stack(struct rcu_head *head)
+{
+	rcu_head_init(head);
+}
+
+static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
+{
+}
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -454,4 +470,41 @@ extern void call_rcu(struct rcu_head *he
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
 
+/*
+ * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
+ * by call_rcu() and rcu callback execution, and are therefore not part of the
+ * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
+ */
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+# define STATE_RCU_HEAD_READY	0
+# define STATE_RCU_HEAD_QUEUED	1
+
+extern struct debug_obj_descr rcuhead_debug_descr;
+
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+	debug_object_activate(head, &rcuhead_debug_descr);
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_READY,
+				  STATE_RCU_HEAD_QUEUED);
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_QUEUED,
+				  STATE_RCU_HEAD_READY);
+	debug_object_deactivate(head, &rcuhead_debug_descr);
+}
+#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+}
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
 #endif /* __LINUX_RCUPDATE_H */
Index: linux.trees.git/kernel/rcutree.c
===================================================================
--- linux.trees.git.orig/kernel/rcutree.c	2010-03-27 11:16:29.000000000 -0400
+++ linux.trees.git/kernel/rcutree.c	2010-03-27 11:16:44.000000000 -0400
@@ -1076,6 +1076,7 @@ static void rcu_do_batch(struct rcu_stat
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 		if (++count >= rdp->blimit)
@@ -1353,6 +1354,7 @@ __call_rcu(struct rcu_head *head, void (
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
Index: linux.trees.git/lib/Kconfig.debug
===================================================================
--- linux.trees.git.orig/lib/Kconfig.debug	2010-03-27 11:16:29.000000000 -0400
+++ linux.trees.git/lib/Kconfig.debug	2010-03-27 11:16:37.000000000 -0400
@@ -319,6 +319,12 @@ config DEBUG_OBJECTS_WORK
 	  work queue routines to track the life time of work objects and
 	  validate the work operations.
 
+config DEBUG_OBJECTS_RCU_HEAD
+	bool "Debug RCU callbacks objects"
+	depends on DEBUG_OBJECTS
+	help
+	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
Index: linux.trees.git/kernel/rcutiny.c
===================================================================
--- linux.trees.git.orig/kernel/rcutiny.c	2010-03-27 11:16:29.000000000 -0400
+++ linux.trees.git/kernel/rcutiny.c	2010-03-27 11:16:37.000000000 -0400
@@ -163,6 +163,7 @@ static void __rcu_process_callbacks(stru
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 	}
@@ -210,6 +211,7 @@ static void __call_rcu(struct rcu_head *
 {
 	unsigned long flags;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
Index: linux.trees.git/kernel/rcupdate.c
===================================================================
--- linux.trees.git.orig/kernel/rcupdate.c	2010-03-27 11:16:29.000000000 -0400
+++ linux.trees.git/kernel/rcupdate.c	2010-03-27 11:16:37.000000000 -0400
@@ -115,3 +115,171 @@ void wakeme_after_rcu(struct rcu_head  *
 	rcu = container_of(head, struct rcu_synchronize, head);
 	complete(&rcu->completion);
 }
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+static inline void debug_rcu_head_init(struct rcu_head *head)
+{
+	debug_object_init(head, &rcuhead_debug_descr);
+}
+
+static inline void debug_rcu_head_free(struct rcu_head *head)
+{
+	debug_object_free(head, &rcuhead_debug_descr);
+}
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
+ */
+static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#else
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_init(head, &rcuhead_debug_descr);
+		return 1;
+#endif
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_activate is called when:
+ * - an active object is activated
+ * - an unknown object is activated (might be a statically initialized object)
+ * Activation is performed internally by call_rcu().
+ * Let's make it valid to activate a static object.
+ */
+static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		/*
+		 * This is not really a fixup. The work struct was
+		 * statically initialized. We just make sure that it
+		 * is tracked in the object tracker.
+		 */
+		debug_object_init(head, &rcuhead_debug_descr);
+		debug_object_activate(head, &rcuhead_debug_descr);
+		return 0;
+
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#else
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_activate(head, &rcuhead_debug_descr);
+		return 1;
+#endif
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_free is called when:
+ * - an active object is freed
+ */
+static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#else
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_free(head, &rcuhead_debug_descr);
+		return 1;
+#endif
+	default:
+		return 0;
+	}
+}
+
+void rcu_head_init_on_stack(struct rcu_head *head)
+{
+	debug_object_init_on_stack(head, &rcuhead_debug_descr);
+	rcu_head_init(head);
+}
+EXPORT_SYMBOL_GPL(rcu_head_init_on_stack);
+
+void destroy_rcu_head_on_stack(struct rcu_head *head)
+{
+	debug_object_free(head, &rcuhead_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_rcu_head_on_stack);
+
+struct debug_obj_descr rcuhead_debug_descr = {
+	.name = "rcu_head",
+	.fixup_init = rcuhead_fixup_init,
+	.fixup_activate = rcuhead_fixup_activate,
+	.fixup_free = rcuhead_fixup_free,
+};
+EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
+#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void debug_rcu_head_init(struct rcu_head *head)
+{
+}
+#endif /* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
+/**
+ * rcu_head_init - initialize a RCU head
+ * @head:     the rcu head to be initialized
+ */
+void rcu_head_init(struct rcu_head *head)
+{
+	debug_rcu_head_init(head);
+	head->next = NULL;
+	head->func = NULL;
+}
+EXPORT_SYMBOL_GPL(rcu_head_init);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
