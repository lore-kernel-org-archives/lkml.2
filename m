Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1LSXXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:23:46 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:58935 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752779Ab1LSXXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:23:35 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] tracing, sched: Add delay info to sched_switch
Date: Mon, 19 Dec 2011 15:23:25 -0800
Message-Id: <1324337005-31718-3-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1324337005-31718-1-git-send-email-asharma@fb.com>
References: <1324337005-31718-1-git-send-email-asharma@fb.com>
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
 include/trace/events/sched.h      |   21 +++++++++++++++++----
 kernel/sched_fair.c               |    6 ++++--
 kernel/trace/trace_sched_switch.c |    2 +-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..830784b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -113,9 +113,10 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 TRACE_EVENT(sched_switch,
 
 	TP_PROTO(struct task_struct *prev,
-		 struct task_struct *next),
+		 struct task_struct *next,
+		 unsigned long now),
 
-	TP_ARGS(prev, next),
+	TP_ARGS(prev, next, now),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
@@ -125,6 +126,7 @@ TRACE_EVENT(sched_switch,
 		__array(	char,	next_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	next_pid			)
 		__field(	int,	next_prio			)
+		__field(	long,	delay				)
 	),
 
 	TP_fast_assign(
@@ -135,9 +137,20 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
+#ifdef CONFIG_SCHEDSTATS
+		__entry->delay		= next->se.statistics.block_start ? next->se.statistics.block_start
+					  : next->se.statistics.sleep_start ? next->se.statistics.sleep_start : 0;
+		__entry->delay = __entry->delay ? now - __entry->delay : 0;
+#else
+		__entry->delay = 0;
+#endif
+	)
+
+	TP_perf_assign(
+		__perf_count(__entry->delay);
 	),
 
-	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
+	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d delay=%ld",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
 		__entry->prev_state & (TASK_STATE_MAX-1) ?
 		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
@@ -145,7 +158,7 @@ TRACE_EVENT(sched_switch,
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "W" }) : "R",
 		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
-		__entry->next_comm, __entry->next_pid, __entry->next_prio)
+		__entry->next_comm, __entry->next_pid, __entry->next_prio, __entry->delay)
 );
 
 /*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8a39fa3..b51a613 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -893,7 +893,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.sleep_max))
 			se->statistics.sleep_max = delta;
 
-		se->statistics.sleep_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -910,7 +909,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.block_max))
 			se->statistics.block_max = delta;
 
-		se->statistics.block_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -1083,8 +1081,12 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 			if (tsk->state & TASK_INTERRUPTIBLE)
 				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
+			else
+				se->statistics.sleep_start = 0;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
 				se->statistics.block_start = rq_of(cfs_rq)->clock;
+			else
+				se->statistics.block_start = 0;
 		}
 #endif
 	}
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 7e62c0a..b8b98d4 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -50,7 +50,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next)
+probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next, unsigned long now)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
-- 
1.7.4

