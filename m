Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab0I3Poc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 11:44:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63372 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0I3Pob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 11:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=aODvfyIvwi9mHQdhz3jUaozGF96G/Sfbbz1ayU3Xxg6P/f2QcGJRSWi3SXmfx4asi6
         3qegmCiSiMiSd2fBFp64/84KnmurxwlBYcvYWROQ/orxRQdQ9GEYW0a/iE98NJywwneW
         ydqHhqtBa8itZiCbypqswA1bQVUz53brpqm4w=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] workqueue: Add a trace event for works enqueuing
Date: Thu, 30 Sep 2010 17:39:00 +0200
Message-Id: <1285861140-5948-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracing worklet queuing provides useful informations to understand
their lifecycles. Combined with timers trace events, we can also
extend the informations about this lifecycle from delayed queueing.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/workqueue.h |   32 ++++++++++++++++++++++++++++++++
 kernel/workqueue.c               |    2 ++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 49682d7..4c2ec52 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -7,6 +7,38 @@
 #include <linux/tracepoint.h>
 #include <linux/workqueue.h>
 
+
+/**
+ * workqueue_queue_work - called when a work gets queued
+ * @work:	pointer to struct work_struct
+ * @wq:		workqueue structure
+ *
+ * Allows to track workqueue execution. This event occurs when
+ * a work is queued immediately or once a delayed work is actually
+ * queued on a workqueue (ie: once the delay has been reached).
+ */
+TRACE_EVENT(workqueue_queue_work,
+
+	TP_PROTO(struct work_struct *work, struct workqueue_struct *wq),
+
+	TP_ARGS(work, wq),
+
+	TP_STRUCT__entry(
+		__field( void *,	work	)
+		__field( void *,	function)
+		__field( void *,	workqueue)
+	),
+
+	TP_fast_assign(
+		__entry->work		= work;
+		__entry->function	= work->func;
+		__entry->workqueue	= wq;
+	),
+
+	TP_printk("work struct=%p function=%pf workqueue=%p",
+			__entry->work, __entry->function, __entry->workqueue)
+);
+
 /**
  * workqueue_execute_start - called immediately before the workqueue callback
  * @work:	pointer to struct work_struct
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f77afd9..5ed9f89 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -959,6 +959,8 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	if (WARN_ON_ONCE(wq->flags & WQ_DYING))
 		return;
 
+	trace_workqueue_queue_work(work, wq);
+
 	/* determine gcwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct global_cwq *last_gcwq;
-- 
1.6.2.3

