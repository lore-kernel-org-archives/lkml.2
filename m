Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab0HUUMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 16:12:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:58464 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0HUUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 16:12:49 -0400
Date: Sat, 21 Aug 2010 13:14:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH] workqueue: Add basic tracepoints to track workqueue
 execution
Message-ID: <20100821131402.577c4d75@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 21 Aug 2010 13:07:26 -0700
Subject: [PATCH] workqueue: Add basic tracepoints to track workqueue execution

With the introduction of the new unified work queue thread pools,
we lost one feature: It's no longer possible to know which worker
is causing the CPU to wake out of idle. The result is that PowerTOP
now reports a lot of "kworker/a:b" instead of more readable results.

This patch adds a pair of tracepoints to the new workqueue code,
similar in style to the timer/hrtimer tracepoints.

With this pair of tracepoints, the next PowerTOP can correctly
report which work item caused the wakeup (and how long it took):

Interrupt (43)            i915      time   3.51ms    wakeups 141
Work      ieee80211_iface_work      time   0.81ms    wakeups  29
Work              do_dbs_timer      time   0.55ms    wakeups  24
Process                   Xorg      time  21.36ms    wakeups   4
Timer    sched_rt_period_timer      time   0.01ms    wakeups   1

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/trace/events/workqueue.h |   63 ++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c               |    9 +++++
 2 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/workqueue.h

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
new file mode 100644
index 0000000..4fd2bd1
--- /dev/null
+++ b/include/trace/events/workqueue.h
@@ -0,0 +1,63 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM workqueue
+
+#if !defined(_TRACE_WORKQUEUE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_WORKQUEUE_H
+
+#include <linux/tracepoint.h>
+#include <linux/workqueue.h>
+
+/**
+ * workqueue_execute_start - called immediately before the workqueue callback
+ * @work:	pointer to struct work_struct
+ *
+ * Allows to track workqueue execution.
+ */
+TRACE_EVENT(workqueue_execute_start,
+
+	TP_PROTO(struct work_struct *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field( void *,	work	)
+		__field( void *,	function)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->function	= work->func;
+	),
+
+	TP_printk("work struct %p: function %pf", __entry->work, __entry->function)
+);
+
+/**
+ * workqueue_execute_end - called immediately before the workqueue callback
+ * @work:	pointer to struct work_struct
+ *
+ * Allows to track workqueue execution.
+ */
+TRACE_EVENT(workqueue_execute_end,
+
+	TP_PROTO(struct work_struct *work),
+
+	TP_ARGS(work),
+
+	TP_STRUCT__entry(
+		__field( void *,	work	)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+	),
+
+	TP_printk("work struct %p", __entry->work)
+);
+
+
+#endif /*  _TRACE_WORKQUEUE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2994a0e..8bd600c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -35,6 +35,9 @@
 #include <linux/lockdep.h>
 #include <linux/idr.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/workqueue.h>
+
 #include "workqueue_sched.h"
 
 enum {
@@ -1790,7 +1793,13 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	work_clear_pending(work);
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
+	trace_workqueue_execute_start(work);
 	f(work);
+	/*
+	 * While we must be careful to not use "work" after this, the trace
+	 * point will only record its address.
+	 */
+	trace_workqueue_execute_end(work);
 	lock_map_release(&lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
 
-- 
1.7.1.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
