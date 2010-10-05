Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab0JEI5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:57:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:35645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab0JEI5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:57:49 -0400
Message-ID: <4CAAE907.8010507@kernel.org>
Date: Tue, 05 Oct 2010 10:59:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH wq#for-next 2/2] workqueue: add queue_work and activate_work
 trace points
References: <1285861140-5948-1-git-send-regression-fweisbec@gmail.com> <4CA9E8E0.7040503@kernel.org> <20101004155410.GA5381@nowhere>
In-Reply-To: <20101004155410.GA5381@nowhere>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 08:57:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two tracepoints allow tracking when and how a work is queued and
activated.  This patch is based on Frederic's patch to add queue_work
trace point.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/trace/events/workqueue.h |   53 ++++++++++++++++++++++++++++++++++++++
 kernel/workqueue.c               |    3 ++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index ec9d724..7d49729 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -25,6 +25,59 @@ DECLARE_EVENT_CLASS(workqueue_work,
 );

 /**
+ * workqueue_queue_work - called when a work gets queued
+ * @req_cpu:	the requested cpu
+ * @cwq:	pointer to struct cpu_workqueue_struct
+ * @work:	pointer to struct work_struct
+ *
+ * This event occurs when a work is queued immediately or once a
+ * delayed work is actually queued on a workqueue (ie: once the delay
+ * has been reached).
+ */
+TRACE_EVENT(workqueue_queue_work,
+
+	TP_PROTO(unsigned int req_cpu, struct cpu_workqueue_struct *cwq,
+		 struct work_struct *work),
+
+	TP_ARGS(req_cpu, cwq, work),
+
+	TP_STRUCT__entry(
+		__field( void *,	work	)
+		__field( void *,	function)
+		__field( void *,	workqueue)
+		__field( unsigned int,	req_cpu	)
+		__field( unsigned int,	cpu	)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->function	= work->func;
+		__entry->workqueue	= cwq->wq;
+		__entry->req_cpu	= req_cpu;
+		__entry->cpu		= cwq->gcwq->cpu;
+	),
+
+	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
+		  __entry->work, __entry->function, __entry->workqueue,
+		  __entry->req_cpu, __entry->cpu)
+);
+
+/**
+ * workqueue_activate_work - called when a work gets activated
+ * @work:	pointer to struct work_struct
+ *
+ * This event occurs when a queued work is put on the active queue,
+ * which happens immediately after queueing unless @max_active limit
+ * is reached.
+ */
+DEFINE_EVENT(workqueue_work, workqueue_activate_work,
+
+	TP_PROTO(struct work_struct *work),
+
+	TP_ARGS(work)
+);
+
+/**
  * workqueue_execute_start - called immediately before the workqueue callback
  * @work:	pointer to struct work_struct
  *
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 026f778..cb2ccfb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -997,6 +997,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,

 	/* gcwq determined, get cwq and queue */
 	cwq = get_cwq(gcwq->cpu, wq);
+	trace_workqueue_queue_work(cpu, cwq, work);

 	BUG_ON(!list_empty(&work->entry));

@@ -1004,6 +1005,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	work_flags = work_color_to_flags(cwq->work_color);

 	if (likely(cwq->nr_active < cwq->max_active)) {
+		trace_workqueue_activate_work(work);
 		cwq->nr_active++;
 		worklist = gcwq_determine_ins_pos(gcwq, cwq);
 	} else {
@@ -1679,6 +1681,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
 						    struct work_struct, entry);
 	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);

+	trace_workqueue_activate_work(work);
 	move_linked_works(work, pos, NULL);
 	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
 	cwq->nr_active++;
-- 
1.7.1

