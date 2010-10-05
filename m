Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0JEI53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:57:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:35610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab0JEI52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:57:28 -0400
Message-ID: <4CAAE8E3.5020207@kernel.org>
Date: Tue, 05 Oct 2010 10:59:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH wq#for-next 1/2] workqueue: prepare for more tracepoints
References: <1285861140-5948-1-git-send-regression-fweisbec@gmail.com> <4CA9E8E0.7040503@kernel.org> <20101004155410.GA5381@nowhere>
In-Reply-To: <20101004155410.GA5381@nowhere>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 08:57:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define workqueue_work event class and use it for workqueue_execute_end
trace point.  Also, move trace/events/workqueue.h include downwards
such that all struct definitions are visible to it.  This is to
prepare for more tracepoints and doesn't cause any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
I'll route these two through wq tree.  Thank you.

 include/trace/events/workqueue.h |   32 +++++++++++++++++++-------------
 kernel/workqueue.c               |    6 +++---
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 49682d7..ec9d724 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -7,13 +7,7 @@
 #include <linux/tracepoint.h>
 #include <linux/workqueue.h>

-/**
- * workqueue_execute_start - called immediately before the workqueue callback
- * @work:	pointer to struct work_struct
- *
- * Allows to track workqueue execution.
- */
-TRACE_EVENT(workqueue_execute_start,
+DECLARE_EVENT_CLASS(workqueue_work,

 	TP_PROTO(struct work_struct *work),

@@ -21,24 +15,22 @@ TRACE_EVENT(workqueue_execute_start,

 	TP_STRUCT__entry(
 		__field( void *,	work	)
-		__field( void *,	function)
 	),

 	TP_fast_assign(
 		__entry->work		= work;
-		__entry->function	= work->func;
 	),

-	TP_printk("work struct %p: function %pf", __entry->work, __entry->function)
+	TP_printk("work struct %p", __entry->work)
 );

 /**
- * workqueue_execute_end - called immediately before the workqueue callback
+ * workqueue_execute_start - called immediately before the workqueue callback
  * @work:	pointer to struct work_struct
  *
  * Allows to track workqueue execution.
  */
-TRACE_EVENT(workqueue_execute_end,
+TRACE_EVENT(workqueue_execute_start,

 	TP_PROTO(struct work_struct *work),

@@ -46,15 +38,29 @@ TRACE_EVENT(workqueue_execute_end,

 	TP_STRUCT__entry(
 		__field( void *,	work	)
+		__field( void *,	function)
 	),

 	TP_fast_assign(
 		__entry->work		= work;
+		__entry->function	= work->func;
 	),

-	TP_printk("work struct %p", __entry->work)
+	TP_printk("work struct %p: function %pf", __entry->work, __entry->function)
 );

+/**
+ * workqueue_execute_end - called immediately before the workqueue callback
+ * @work:	pointer to struct work_struct
+ *
+ * Allows to track workqueue execution.
+ */
+DEFINE_EVENT(workqueue_work, workqueue_execute_end,
+
+	TP_PROTO(struct work_struct *work),
+
+	TP_ARGS(work)
+);

 #endif /*  _TRACE_WORKQUEUE_H */

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 19e4bc1..026f778 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -42,9 +42,6 @@
 #include <linux/lockdep.h>
 #include <linux/idr.h>

-#define CREATE_TRACE_POINTS
-#include <trace/events/workqueue.h>
-
 #include "workqueue_sched.h"

 enum {
@@ -257,6 +254,9 @@ EXPORT_SYMBOL_GPL(system_long_wq);
 EXPORT_SYMBOL_GPL(system_nrt_wq);
 EXPORT_SYMBOL_GPL(system_unbound_wq);

+#define CREATE_TRACE_POINTS
+#include <trace/events/workqueue.h>
+
 #define for_each_busy_worker(worker, i, pos, gcwq)			\
 	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
 		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
-- 
1.7.1

