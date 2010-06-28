Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0F1VHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 17:07:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:42984 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0F1VHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 17:07:19 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/35] workqueue: temporarily remove workqueue tracing
Date: Mon, 28 Jun 2010 23:03:58 +0200
Message-Id: <1277759063-24607-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 28 Jun 2010 21:05:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip tracing code from workqueue and remove workqueue tracing.  This
is temporary measure till concurrency managed workqueue is complete.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/workqueue.h |   92 --------------------------------------
 kernel/trace/Kconfig             |   11 -----
 kernel/workqueue.c               |   14 +-----
 3 files changed, 3 insertions(+), 114 deletions(-)
 delete mode 100644 include/trace/events/workqueue.h

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
deleted file mode 100644
index d6c9744..0000000
--- a/include/trace/events/workqueue.h
+++ /dev/null
@@ -1,92 +0,0 @@
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM workqueue
-
-#if !defined(_TRACE_WORKQUEUE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_WORKQUEUE_H
-
-#include <linux/workqueue.h>
-#include <linux/sched.h>
-#include <linux/tracepoint.h>
-
-DECLARE_EVENT_CLASS(workqueue,
-
-	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-
-	TP_ARGS(wq_thread, work),
-
-	TP_STRUCT__entry(
-		__array(char,		thread_comm,	TASK_COMM_LEN)
-		__field(pid_t,		thread_pid)
-		__field(work_func_t,	func)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
-		__entry->thread_pid	= wq_thread->pid;
-		__entry->func		= work->func;
-	),
-
-	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
-		__entry->thread_pid, __entry->func)
-);
-
-DEFINE_EVENT(workqueue, workqueue_insertion,
-
-	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-
-	TP_ARGS(wq_thread, work)
-);
-
-DEFINE_EVENT(workqueue, workqueue_execution,
-
-	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-
-	TP_ARGS(wq_thread, work)
-);
-
-/* Trace the creation of one workqueue thread on a cpu */
-TRACE_EVENT(workqueue_creation,
-
-	TP_PROTO(struct task_struct *wq_thread, int cpu),
-
-	TP_ARGS(wq_thread, cpu),
-
-	TP_STRUCT__entry(
-		__array(char,	thread_comm,	TASK_COMM_LEN)
-		__field(pid_t,	thread_pid)
-		__field(int,	cpu)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
-		__entry->thread_pid	= wq_thread->pid;
-		__entry->cpu		= cpu;
-	),
-
-	TP_printk("thread=%s:%d cpu=%d", __entry->thread_comm,
-		__entry->thread_pid, __entry->cpu)
-);
-
-TRACE_EVENT(workqueue_destruction,
-
-	TP_PROTO(struct task_struct *wq_thread),
-
-	TP_ARGS(wq_thread),
-
-	TP_STRUCT__entry(
-		__array(char,	thread_comm,	TASK_COMM_LEN)
-		__field(pid_t,	thread_pid)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
-		__entry->thread_pid	= wq_thread->pid;
-	),
-
-	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
-);
-
-#endif /* _TRACE_WORKQUEUE_H */
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8b1797c..a0d95c1 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -391,17 +391,6 @@ config KMEMTRACE
 
 	  If unsure, say N.
 
-config WORKQUEUE_TRACER
-	bool "Trace workqueues"
-	select GENERIC_TRACER
-	help
-	  The workqueue tracer provides some statistical information
-          about each cpu workqueue thread such as the number of the
-          works inserted and executed since their creation. It can help
-          to evaluate the amount of work each of them has to perform.
-          For example it can help a developer to decide whether he should
-          choose a per-cpu workqueue instead of a singlethreaded one.
-
 config BLK_DEV_IO_TRACE
 	bool "Support for tracing block IO actions"
 	depends on SYSFS
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8e3082b..f7ab703 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,8 +33,6 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
-#define CREATE_TRACE_POINTS
-#include <trace/events/workqueue.h>
 
 /*
  * Structure fields follow one of the following exclusion rules.
@@ -243,10 +241,10 @@ static inline void clear_wq_data(struct work_struct *work)
 	atomic_long_set(&work->data, work_static(work));
 }
 
-static inline
-struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
+static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
-	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
+	return (void *)(atomic_long_read(&work->data) &
+			WORK_STRUCT_WQ_DATA_MASK);
 }
 
 /**
@@ -265,8 +263,6 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
-	trace_workqueue_insertion(cwq->thread, work);
-
 	/* we own @work, set data and link */
 	set_wq_data(work, cwq, extra_flags);
 
@@ -431,7 +427,6 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 	struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
 	/* claim and process */
-	trace_workqueue_execution(cwq->thread, work);
 	debug_work_deactivate(work);
 	cwq->current_work = work;
 	list_del_init(&work->entry);
@@ -1017,8 +1012,6 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 		return PTR_ERR(p);
 	cwq->thread = p;
 
-	trace_workqueue_creation(cwq->thread, cpu);
-
 	return 0;
 }
 
@@ -1123,7 +1116,6 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	 * checks list_empty(), and a "normal" queue_work() can't use
 	 * a dead CPU.
 	 */
-	trace_workqueue_destruction(cwq->thread);
 	kthread_stop(cwq->thread);
 	cwq->thread = NULL;
 }
-- 
1.6.4.2

