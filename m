Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1LXHcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 02:32:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56420 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab1LXHca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 02:32:30 -0500
Date: Fri, 23 Dec 2011 23:31:28 -0800
From: tip-bot for Arun Sharma <asharma@fb.com>
Message-ID: <tip-1ac9bc6943edf7d181b4b1cc734981350d4f6bae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@infradead.org, tglx@linutronix.de, mingo@elte.hu, asharma@fb.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, fweisbec@gmail.com, acme@infradead.org,
        rostedt@goodmis.org, tglx@linutronix.de, asharma@fb.com, mingo@elte.hu
In-Reply-To: <1324512940-32060-2-git-send-email-asharma@fb.com>
References: <1324512940-32060-2-git-send-email-asharma@fb.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/tracing: Add a new tracepoint for sleeptime
Git-Commit-ID: 1ac9bc6943edf7d181b4b1cc734981350d4f6bae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 23:31:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ac9bc6943edf7d181b4b1cc734981350d4f6bae
Gitweb:     http://git.kernel.org/tip/1ac9bc6943edf7d181b4b1cc734981350d4f6bae
Author:     Arun Sharma <asharma@fb.com>
AuthorDate: Wed, 21 Dec 2011 16:15:40 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Dec 2011 17:56:17 +0100

sched/tracing: Add a new tracepoint for sleeptime

If CONFIG_SCHEDSTATS is defined, the kernel maintains
information about how long the task was sleeping or
in the case of iowait, blocking in the kernel before
getting woken up.

This will be useful for sleep time profiling.

Note: this information is only provided for sched_fair.
Other scheduling classes may choose to provide this in
the future.

Note: the delay includes the time spent on the runqueue
as well.

Signed-off-by: Arun Sharma <asharma@fb.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1324512940-32060-2-git-send-email-asharma@fb.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/sched.h |   50 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |    1 +
 kernel/sched/fair.c          |    2 -
 3 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index e33ed1b..6ba596b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -370,6 +370,56 @@ TRACE_EVENT(sched_stat_runtime,
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
index 8ffe523..4dbfd04 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1937,6 +1937,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+	trace_sched_stat_sleeptime(current, rq->clock);
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bdf1883..8e42de9 100644
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
