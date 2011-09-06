Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1IGGYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:24:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38192 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755730Ab1IGGWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:22:10 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/55] rcu: Add event-tracing for RCU callback invocation
Date: Tue,  6 Sep 2011 11:00:08 -0700
Message-Id: <1315332049-2604-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-000000711AB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

There was recently some controversy about the overhead of invoking RCU
callbacks.  Add TRACE_EVENT()s to obtain fine-grained timings for the
start and stop of a batch of callbacks and also for each callback invoked.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h   |   50 ----------------------
 include/trace/events/rcu.h |   98 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcu.h               |   79 +++++++++++++++++++++++++++++++++++
 kernel/rcupdate.c          |    5 ++
 kernel/rcutiny.c           |   26 +++++++++++-
 kernel/rcutree.c           |   15 +++++-
 6 files changed, 219 insertions(+), 54 deletions(-)
 create mode 100644 include/trace/events/rcu.h
 create mode 100644 kernel/rcu.h

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6433a6f..c61a535 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -794,44 +794,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define RCU_INIT_POINTER(p, v) \
 		p = (typeof(*v) __force __rcu *)(v)
 
-/*
- * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
- * by call_rcu() and rcu callback execution, and are therefore not part of the
- * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
- */
-
-#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
-# define STATE_RCU_HEAD_READY	0
-# define STATE_RCU_HEAD_QUEUED	1
-
-extern struct debug_obj_descr rcuhead_debug_descr;
-
-static inline void debug_rcu_head_queue(struct rcu_head *head)
-{
-	WARN_ON_ONCE((unsigned long)head & 0x3);
-	debug_object_activate(head, &rcuhead_debug_descr);
-	debug_object_active_state(head, &rcuhead_debug_descr,
-				  STATE_RCU_HEAD_READY,
-				  STATE_RCU_HEAD_QUEUED);
-}
-
-static inline void debug_rcu_head_unqueue(struct rcu_head *head)
-{
-	debug_object_active_state(head, &rcuhead_debug_descr,
-				  STATE_RCU_HEAD_QUEUED,
-				  STATE_RCU_HEAD_READY);
-	debug_object_deactivate(head, &rcuhead_debug_descr);
-}
-#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-static inline void debug_rcu_head_queue(struct rcu_head *head)
-{
-}
-
-static inline void debug_rcu_head_unqueue(struct rcu_head *head)
-{
-}
-#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-
 static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
 {
 	return offset < 4096;
@@ -850,18 +812,6 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 	call_rcu(head, (rcu_callback)offset);
 }
 
-extern void kfree(const void *);
-
-static inline void __rcu_reclaim(struct rcu_head *head)
-{
-	unsigned long offset = (unsigned long)head->func;
-
-	if (__is_kfree_rcu_offset(offset))
-		kfree((void *)head - offset);
-	else
-		head->func(head);
-}
-
 /**
  * kfree_rcu() - kfree an object after a grace period.
  * @ptr:	pointer to kfree
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
new file mode 100644
index 0000000..db3f6e9
--- /dev/null
+++ b/include/trace/events/rcu.h
@@ -0,0 +1,98 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rcu
+
+#if !defined(_TRACE_RCU_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RCU_H
+
+#include <linux/tracepoint.h>
+
+/*
+ * Tracepoint for calling rcu_do_batch, performed to start callback invocation:
+ */
+TRACE_EVENT(rcu_batch_start,
+
+	TP_PROTO(long callbacks_ready, int blimit),
+
+	TP_ARGS(callbacks_ready, blimit),
+
+	TP_STRUCT__entry(
+		__field(	long,	callbacks_ready		)
+		__field(	int,	blimit			)
+	),
+
+	TP_fast_assign(
+		__entry->callbacks_ready	= callbacks_ready;
+		__entry->blimit			= blimit;
+	),
+
+	TP_printk("CBs=%ld bl=%d", __entry->callbacks_ready, __entry->blimit)
+);
+
+/*
+ * Tracepoint for the invocation of a single RCU callback
+ */
+TRACE_EVENT(rcu_invoke_callback,
+
+	TP_PROTO(struct rcu_head *rhp),
+
+	TP_ARGS(rhp),
+
+	TP_STRUCT__entry(
+		__field(	void *,	rhp	)
+		__field(	void *,	func	)
+	),
+
+	TP_fast_assign(
+		__entry->rhp	= rhp;
+		__entry->func	= rhp->func;
+	),
+
+	TP_printk("rhp=%p func=%pf", __entry->rhp, __entry->func)
+);
+
+/*
+ * Tracepoint for the invocation of a single RCU kfree callback
+ */
+TRACE_EVENT(rcu_invoke_kfree_callback,
+
+	TP_PROTO(struct rcu_head *rhp, unsigned long offset),
+
+	TP_ARGS(rhp, offset),
+
+	TP_STRUCT__entry(
+		__field(void *,	rhp	)
+		__field(unsigned long,	offset	)
+	),
+
+	TP_fast_assign(
+		__entry->rhp	= rhp;
+		__entry->offset	= offset;
+	),
+
+	TP_printk("rhp=%p func=%ld", __entry->rhp, __entry->offset)
+);
+
+/*
+ * Tracepoint for leaving rcu_do_batch, performed after callback invocation:
+ */
+TRACE_EVENT(rcu_batch_end,
+
+	TP_PROTO(int callbacks_invoked),
+
+	TP_ARGS(callbacks_invoked),
+
+	TP_STRUCT__entry(
+		__field(	int,	callbacks_invoked		)
+	),
+
+	TP_fast_assign(
+		__entry->callbacks_invoked	= callbacks_invoked;
+	),
+
+	TP_printk("CBs-invoked=%d", __entry->callbacks_invoked)
+);
+
+#endif /* _TRACE_RCU_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/rcu.h b/kernel/rcu.h
new file mode 100644
index 0000000..7bc1643
--- /dev/null
+++ b/kernel/rcu.h
@@ -0,0 +1,79 @@
+/*
+ * Read-Copy Update definitions shared among RCU implementations.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2011
+ *
+ * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+#ifndef __LINUX_RCU_H
+#define __LINUX_RCU_H
+
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
+	WARN_ON_ONCE((unsigned long)head & 0x3);
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
+extern void kfree(const void *);
+
+static inline void __rcu_reclaim(struct rcu_head *head)
+{
+	unsigned long offset = (unsigned long)head->func;
+
+	if (__is_kfree_rcu_offset(offset)) {
+		trace_rcu_invoke_kfree_callback(head, offset);
+		kfree((void *)head - offset);
+	} else {
+		trace_rcu_invoke_callback(head);
+		head->func(head);
+	}
+}
+
+#endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a088c90..5031caf 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -46,6 +46,11 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/rcu.h>
+
+#include "rcu.h"
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index f544e34..19453ba 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -37,6 +37,25 @@
 #include <linux/cpu.h>
 #include <linux/prefetch.h>
 
+#ifdef CONFIG_RCU_TRACE
+
+#include <trace/events/rcu.h>
+
+#else /* #ifdef CONFIG_RCU_TRACE */
+
+/* No by-default tracing in TINY_RCU: Keep TINY_RCU tiny! */
+static void trace_rcu_invoke_kfree_callback(struct rcu_head *rhp,
+					    unsigned long offset)
+{
+}
+static void trace_rcu_invoke_callback(struct rcu_head *head)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_TRACE */
+
+#include "rcu.h"
+
 /* Controls for rcu_kthread() kthread, replacing RCU_SOFTIRQ used previously. */
 static struct task_struct *rcu_kthread_task;
 static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
@@ -161,11 +180,15 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	RCU_TRACE(int cb_count = 0);
 
 	/* If no RCU callbacks ready to invoke, just return. */
-	if (&rcp->rcucblist == rcp->donetail)
+	if (&rcp->rcucblist == rcp->donetail) {
+		RCU_TRACE(trace_rcu_batch_start(0, -1));
+		RCU_TRACE(trace_rcu_batch_end(0));
 		return;
+	}
 
 	/* Move the ready-to-invoke callbacks to a local list. */
 	local_irq_save(flags);
+	RCU_TRACE(trace_rcu_batch_start(0, -1));
 	list = rcp->rcucblist;
 	rcp->rcucblist = *rcp->donetail;
 	*rcp->donetail = NULL;
@@ -187,6 +210,7 @@ static void rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 		RCU_TRACE(cb_count++);
 	}
 	RCU_TRACE(rcu_trace_sub_qlen(rcp, cb_count));
+	RCU_TRACE(trace_rcu_batch_end(cb_count));
 }
 
 /*
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a7c6bce..45dcc20 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -52,6 +52,9 @@
 #include <linux/prefetch.h>
 
 #include "rcutree.h"
+#include <trace/events/rcu.h>
+
+#include "rcu.h"
 
 /* Data structures. */
 
@@ -1190,17 +1193,22 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int count;
+	int bl, count;
 
 	/* If no callbacks are ready, just return.*/
-	if (!cpu_has_callbacks_ready_to_invoke(rdp))
+	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
+		trace_rcu_batch_start(0, 0);
+		trace_rcu_batch_end(0);
 		return;
+	}
 
 	/*
 	 * Extract the list of ready callbacks, disabling to prevent
 	 * races with call_rcu() from interrupt handlers.
 	 */
 	local_irq_save(flags);
+	bl = rdp->blimit;
+	trace_rcu_batch_start(rdp->qlen, bl);
 	list = rdp->nxtlist;
 	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
 	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
@@ -1218,11 +1226,12 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 		debug_rcu_head_unqueue(list);
 		__rcu_reclaim(list);
 		list = next;
-		if (++count >= rdp->blimit)
+		if (++count >= bl)
 			break;
 	}
 
 	local_irq_save(flags);
+	trace_rcu_batch_end(count);
 
 	/* Update count, and requeue any remaining callbacks. */
 	rdp->qlen -= count;
-- 
1.7.3.2

