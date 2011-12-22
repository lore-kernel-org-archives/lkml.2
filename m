Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1LVAP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:15:56 -0500
Received: from intmgw002.ash2.facebook.com ([66.220.155.179]:43870 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752186Ab1LVAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:15:52 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] tracing, sched: Add a new tracepoint for sleeptime
Date: Wed, 21 Dec 2011 16:15:40 -0800
Message-Id: <1324512940-32060-2-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1324512940-32060-1-git-send-email-asharma@fb.com>
References: <1324512940-32060-1-git-send-email-asharma@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_SCHEDSTATS is defined, the kernel maintains
information about how long the task was sleeping or
in the case of iowait, blocking in the kernel before
getting woken up.

Note: this information is only provided for sched_fair.
Other scheduling classes may choose to provide this in
the future.

Note: the delay includes the time spent on the runqueue
as well.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---
 include/trace/events/sched.h |   50 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |    1 +
 kernel/sched/fair.c          |    2 -
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..3442c6d 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -363,6 +363,56 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+#ifdef CREATE_TRACE_POINTS
+static inline u64 trace_get_sleeptime(struct task_struct *tsk)
+{
+#ifdef CONFIG_SCHEDSTATS
+	u64 block, sleep;
+
+	block = tsk->se.statistics.block_start;
+	sleep = tsk->se.statistics.sleep_start;
+	tsk->se.statistics.block_start = 0;
+	tsk->se.statistics.sleep_start = 0;
+
+	return block ? block : sleep ? sleep : 0;
+#else
+	return 0;
+#endif
+}
+#endif
+
+/*
+ * Tracepoint for accounting sleeptime (time the task is sleeping
+ * or waiting for I/O).
+ */
+TRACE_EVENT(sched_stat_sleeptime,
+
+	TP_PROTO(struct task_struct *tsk, u64 now),
+
+	TP_ARGS(tsk, now),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	sleeptime		)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->sleeptime = trace_get_sleeptime(tsk);
+		__entry->sleeptime = __entry->sleeptime ?
+				now - __entry->sleeptime : 0;
+	)
+	TP_perf_assign(
+		__perf_count(__entry->sleeptime);
+	),
+
+	TP_printk("comm=%s pid=%d sleeptime=%Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->sleeptime)
+);
+
 /*
  * Tracepoint for showing priority inheritance modifying a tasks
  * priority.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca8fd44..172e6ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1899,6 +1899,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+	trace_sched_stat_sleeptime(current, rq->clock);
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd3b642..86deb3b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1003,7 +1003,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.sleep_max))
 			se->statistics.sleep_max = delta;
 
-		se->statistics.sleep_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -1020,7 +1019,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.block_max))
 			se->statistics.block_max = delta;
 
-		se->statistics.block_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
-- 
1.7.4

