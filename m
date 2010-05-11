Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0EKXek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:34:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41165 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab0EKXdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:33:15 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH RFC tip/core/rcu 11/11] tree/tiny rcu: Add debug RCU head objects (v5)
Date: Tue, 11 May 2010 16:33:06 -0700
Message-Id: <1273620786-20392-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100511233241.GA20250@linux.vnet.ibm.com>
References: <20100511233241.GA20250@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

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
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |   49 +++++++++++++
 kernel/rcupdate.c        |  170 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny.c         |    2 +
 kernel/rcutree.c         |    2 +
 lib/Kconfig.debug        |    6 ++
 5 files changed, 229 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3a1a70d..2f9e56c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -40,6 +40,7 @@
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>
+#include <linux/debugobjects.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -73,6 +74,16 @@ extern void rcu_init(void);
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
@@ -80,6 +91,7 @@ static inline void init_rcu_head_on_stack(struct rcu_head *head)
 static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 {
 }
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -511,4 +523,41 @@ extern void call_rcu(struct rcu_head *head,
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
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 72a8dc9..5ab5a91 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -114,3 +114,173 @@ int rcu_my_thread_group_empty(void)
 }
 EXPORT_SYMBOL_GPL(rcu_my_thread_group_empty);
 #endif /* #ifdef CONFIG_PROVE_RCU */
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
+/**
+ * init_rcu_head_on_stack() - initialize on-stack rcu_head for debugobjects
+ * @head: pointer to rcu_head structure to be initialized
+ *
+ * This function informs debugobjects of a new rcu_head structure that
+ * has been allocated as an auto variable on the stack.  This function
+ * is not required for rcu_head structures that are statically defined or
+ * that are dynamically allocated on the heap.  This function has no
+ * effect for !CONFIG_DEBUG_OBJECTS_RCU_HEAD kernel builds.
+ */
+void init_rcu_head_on_stack(struct rcu_head *head)
+{
+	debug_object_init_on_stack(head, &rcuhead_debug_descr);
+}
+EXPORT_SYMBOL_GPL(init_rcu_head_on_stack);
+
+/**
+ * destroy_rcu_head_on_stack() - destroy on-stack rcu_head for debugobjects
+ * @head: pointer to rcu_head structure to be initialized
+ *
+ * This function informs debugobjects that an on-stack rcu_head structure
+ * is about to go out of scope.  As with init_rcu_head_on_stack(), this
+ * function is not required for rcu_head structures that are statically
+ * defined or that are dynamically allocated on the heap.  Also as with
+ * init_rcu_head_on_stack(), this function has no effect for
+ * !CONFIG_DEBUG_OBJECTS_RCU_HEAD kernel builds.
+ */
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
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 38729d3..196ec02 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -169,6 +169,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 	}
@@ -211,6 +212,7 @@ static void __call_rcu(struct rcu_head *head,
 {
 	unsigned long flags;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d443734..d5bc439 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1112,6 +1112,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 		if (++count >= rdp->blimit)
@@ -1388,6 +1389,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 930a9e5..8689646 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -307,6 +307,12 @@ config DEBUG_OBJECTS_WORK
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
-- 
1.7.0.6

