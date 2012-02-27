Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2B0KaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:30:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50167 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab2B0KaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:30:08 -0500
Date: Mon, 27 Feb 2012 11:29:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fix
Message-ID: <20120227102956.GA3015@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 8c79a045fd590a26e81e75f5d8d4ec5c7d23e565 sched/events: Revert trace_sched_stat_sleeptime()

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched/events: Revert trace_sched_stat_sleeptime()


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
