Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0E1O0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:26:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60136 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0E1O0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=xGJl81Sep3oggfopdukePpVAbMiYxy2HACucTpq5AbR9njrXBmEwWU6T+H8y8v3q4c
         9aIIdg6egCREYT32VihoijFzRYmhGn4XBoI9oc7rdufLDTgRnX03iW7/Ut9UpctvgEMa
         hig9eGIFSonnnJNURUHLCtQGsOQ/JKuqq7PYc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tracing: Add task activate/deactivate tracepoints
Date: Fri, 28 May 2010 16:26:02 +0200
Message-Id: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have various tracepoints that tell us when a task is going to
be enqueued in a runqueue: fork, wakeup, migrate.

But they don't always provide us the level of information necessary
to know what is actually in which runqueue, precisely because the
migrate event is only fired if the task is queued on another
cpu than its previous one. So we don't always know where a waking up
task goes.

And moreover we don't have events that tells a task goes to sleep,
and even that wouldn't cover every cases when a task is dequeued.

So bring these two new tracepoints to get informations about the
load of each runqueues.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   36 ++++++++++++++++++++++++++++++++++++
 kernel/sched.c               |    2 ++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 4f733ec..f7f94af 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -185,6 +185,42 @@ TRACE_EVENT(sched_migrate_task,
 		  __entry->orig_cpu, __entry->dest_cpu)
 );
 
+DECLARE_EVENT_CLASS(sched_activation_template,
+
+	TP_PROTO(struct task_struct *p, int cpu),
+
+	TP_ARGS(p, cpu),
+
+	TP_STRUCT__entry(
+		__field(	pid_t,	pid	)
+		__field(	int,	cpu	)
+	),
+
+	TP_fast_assign(
+		__entry->pid		= p->pid;
+		__entry->cpu		= cpu;
+	),
+
+	TP_printk("pid=%d cpu=%d", __entry->pid, __entry->cpu)
+);
+
+
+/*
+ * Tracepoint for activating a task, pulling it in a runqueue
+ */
+DEFINE_EVENT(sched_activation_template, sched_activate_task,
+	     TP_PROTO(struct task_struct *p, int cpu),
+	     TP_ARGS(p, cpu));
+
+
+/*
+ * Tracepoint for deactivating a task, pushing it out a runqueue
+ */
+DEFINE_EVENT(sched_activation_template, sched_deactivate_task,
+	     TP_PROTO(struct task_struct *p, int cpu),
+	     TP_ARGS(p, cpu));
+
+
 DECLARE_EVENT_CLASS(sched_process_template,
 
 	TP_PROTO(struct task_struct *p),
diff --git a/kernel/sched.c b/kernel/sched.c
index 1d93cd0..8c0b90d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1904,6 +1904,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
+	trace_sched_activate_task(p, cpu_of(rq));
 	enqueue_task(rq, p, flags);
 	inc_nr_running(rq);
 }
@@ -1916,6 +1917,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
 
+	trace_sched_deactivate_task(p, cpu_of(rq));
 	dequeue_task(rq, p, flags);
 	dec_nr_running(rq);
 }
-- 
1.6.2.3

