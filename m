Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2BVQK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:10:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2BVQKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:10:52 -0500
Date: Wed, 22 Feb 2012 08:09:53 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-pc4c9qhl8q6vg3bs4j6k0rbd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, avagin@openvz.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, avagin@openvz.org,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/events: Revert trace_sched_stat_sleeptime
 ()
Git-Commit-ID: 8c79a045fd590a26e81e75f5d8d4ec5c7d23e565
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:10:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c79a045fd590a26e81e75f5d8d4ec5c7d23e565
Gitweb:     http://git.kernel.org/tip/8c79a045fd590a26e81e75f5d8d4ec5c7d23e565
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 Jan 2012 14:51:37 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 12:06:55 +0100

sched/events: Revert trace_sched_stat_sleeptime()

Commit 1ac9bc69 ("sched/tracing: Add a new tracepoint for sleeptime")
added a new sched:sched_stat_sleeptime tracepoint.

It's broken: the first sample we get on a task might be bad because
of a stale sleep_start value that wasn't reset at the last task switch
because the tracepoint was not active.

It also breaks the existing schedstat samples due to the side
effects of:

-               se->statistics.sleep_start = 0;
...
-               se->statistics.block_start = 0;

Nor do I see means to fix it without adding overhead to the scheduler
fast path, which I'm not willing to for the sake of redundant
instrumentation.

Most importantly, sleep time information can already be constructed
by tracing context switches and wakeups, and taking the timestamp
difference between the schedule-out, the wakeup and the schedule-in.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-pc4c9qhl8q6vg3bs4j6k0rbd@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/sched.h |   50 ------------------------------------------
 kernel/sched/core.c          |    1 -
 kernel/sched/fair.c          |    2 +
 3 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 6ba596b..e33ed1b 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -370,56 +370,6 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
-#ifdef CREATE_TRACE_POINTS
-static inline u64 trace_get_sleeptime(struct task_struct *tsk)
-{
-#ifdef CONFIG_SCHEDSTATS
-	u64 block, sleep;
-
-	block = tsk->se.statistics.block_start;
-	sleep = tsk->se.statistics.sleep_start;
-	tsk->se.statistics.block_start = 0;
-	tsk->se.statistics.sleep_start = 0;
-
-	return block ? block : sleep ? sleep : 0;
-#else
-	return 0;
-#endif
-}
-#endif
-
-/*
- * Tracepoint for accounting sleeptime (time the task is sleeping
- * or waiting for I/O).
- */
-TRACE_EVENT(sched_stat_sleeptime,
-
-	TP_PROTO(struct task_struct *tsk, u64 now),
-
-	TP_ARGS(tsk, now),
-
-	TP_STRUCT__entry(
-		__array( char,	comm,	TASK_COMM_LEN	)
-		__field( pid_t,	pid			)
-		__field( u64,	sleeptime		)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
-		__entry->pid		= tsk->pid;
-		__entry->sleeptime = trace_get_sleeptime(tsk);
-		__entry->sleeptime = __entry->sleeptime ?
-				now - __entry->sleeptime : 0;
-	)
-	TP_perf_assign(
-		__perf_count(__entry->sleeptime);
-	),
-
-	TP_printk("comm=%s pid=%d sleeptime=%Lu [ns]",
-			__entry->comm, __entry->pid,
-			(unsigned long long)__entry->sleeptime)
-);
-
 /*
  * Tracepoint for showing priority inheritance modifying a tasks
  * priority.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5255c9d..b342f57 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1932,7 +1932,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
-	trace_sched_stat_sleeptime(current, rq->clock);
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c6414f..aca16b8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1003,6 +1003,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.sleep_max))
 			se->statistics.sleep_max = delta;
 
+		se->statistics.sleep_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -1019,6 +1020,7 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.block_max))
 			se->statistics.block_max = delta;
 
+		se->statistics.block_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
