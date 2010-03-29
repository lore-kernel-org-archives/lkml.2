Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab0C2Ojv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:39:51 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:60704 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab0C2Ojt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:39:49 -0400
Message-Id: <20100329143702.845838001@efficios.com>
References: <20100329143405.252313609@efficios.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Mar 2010 10:34:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [patch 5/5] tree/tiny rcu: Add debug RCU head objects (v5)
Content-Disposition: inline; filename=rcu-head-debug.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Mon, 29 Mar 2010 14:37:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helps finding racy users of call_rcu(), which results in hangs because list
entries are overwritten and/or skipped.

Changelog since v4:
- Bissectability is now OK
- Now generate a WARN_ON_ONCE() for non-initialized rcu_head passed to
  call_rcu(). Statically initialized objects are detected with
  object_is_static().
- Rename rcu_head_init_on_stack to init_rcu_head_on_stack.
- Remove init_rcu_head() completely.

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

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David S. Miller <davem@davemloft.net>
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
 include/linux/rcupdate.h |   49 +++++++++++++++
 kernel/rcupdate.c        |  149 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny.c         |    2 
 kernel/rcutree.c         |    2 
 lib/Kconfig.debug        |    6 +
 5 files changed, 208 insertions(+)

Index: linux.trees.git/include/linux/rcupdate.h
===================================================================
--- linux.trees.git.orig/include/linux/rcupdate.h	2010-03-29 10:19:01.000000000 -0400
+++ linux.trees.git/include/linux/rcupdate.h	2010-03-29 10:19:18.000000000 -0400
@@ -40,6 +40,7 @@
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>
+#include <linux/debugobjects.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -77,6 +78,16 @@ extern void rcu_scheduler_starting(void)
 #error "Unknown RCU implementation specified to kernel configuration"
 #endif
 
+/*
+ * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
+ * initialization and destruction of rcu_head on the stack. rcu_head structures
+ * allocated dynamically in the heap or defined statically don't need any
+ * initialization.
+ */
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+extern void init_rcu_head_on_stack(struct rcu_head *head);
+extern void destroy_rcu_head_on_stack(struct rcu_head *head);
+#else /* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 static inline void init_rcu_head_on_stack(struct rcu_head *head)
 {
 }
@@ -84,6 +95,7 @@ static inline void init_rcu_head_on_stac
 static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 {
 }
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -456,4 +468,41 @@ extern void call_rcu(struct rcu_head *he
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
--- linux.trees.git.orig/kernel/rcutree.c	2010-03-29 10:18:05.000000000 -0400
+++ linux.trees.git/kernel/rcutree.c	2010-03-29 10:19:18.000000000 -0400
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
--- linux.trees.git.orig/lib/Kconfig.debug	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/lib/Kconfig.debug	2010-03-29 10:19:18.000000000 -0400
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
--- linux.trees.git.orig/kernel/rcutiny.c	2010-03-29 10:18:05.000000000 -0400
+++ linux.trees.git/kernel/rcutiny.c	2010-03-29 10:19:18.000000000 -0400
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
--- linux.trees.git.orig/kernel/rcupdate.c	2010-03-29 10:17:50.000000000 -0400
+++ linux.trees.git/kernel/rcupdate.c	2010-03-29 10:21:26.000000000 -0400
@@ -115,3 +115,152 @@ void wakeme_after_rcu(struct rcu_head  *
 	rcu = container_of(head, struct rcu_synchronize, head);
 	complete(&rcu->completion);
 }
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+static inline void debug_init_rcu_head(struct rcu_head *head)
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
+ */
+static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		/*
+		 * This is not really a fixup. We just make sure that it is
+		 * tracked in the object tracker.
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
+void init_rcu_head_on_stack(struct rcu_head *head)
+{
+	debug_object_init_on_stack(head, &rcuhead_debug_descr);
+}
+EXPORT_SYMBOL_GPL(init_rcu_head_on_stack);
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
+#endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
