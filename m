Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab0EDMjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:39:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:51771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0EDMjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:16 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/12] sched: coalesce event notifiers
Date: Tue,  4 May 2010 14:38:39 +0200
Message-Id: <1272976724-14312-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched currently hosts three different event notification mechanisms -
tracepoints, perf_event functions and sched_notifiers.  The previous
patches modified and moved them around so that they are colocated
where applicable and share most of the arguments.  This patch
introduces and uses SCHED_EVENT() and SCHED_EVENT_RQ() to coalesce
calls to different mechanisms.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/sched.c |   51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0b753f0..1acec30 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1439,6 +1439,39 @@ static inline void fire_sched_notifiers_in(struct task_struct *p)
 	fire_sched_notifiers(in, p);
 }
 
+/*
+ * Sched is watched by three different mechanisms - tracepoint,
+ * perf_event and sched_notifiers.  SCHED_EVENT*() can be used to
+ * define all or any part of them at once so that code clutter is kept
+ * to minimum and optimizations can be applied according to different
+ * config options.
+ *
+ * In SCHED_EVENT(), the first three arguments specify the name of
+ * tracepoint, perf_event and sched_notifier.  NONE can be used to
+ * omit any subset of the three.  The last argument is event arguments
+ * wrapped inside SE_ARGS() macro.
+ *
+ * SCHED_EVENT_RQ() is identical except that @rq argument will be
+ * added to tracepoint and perf calls.
+ */
+#define trace_sched_NONE(args...)		do { } while (0)
+#define perf_event_task_NONE(args...)		do { } while (0)
+#define fire_sched_notifiers_NONE(args...)	do { } while (0)
+
+#define SE_ARGS(args...)			args
+
+#define SCHED_EVENT(TP, PERF, SN, args) do {				\
+	trace_sched_##TP(args);						\
+	perf_event_task_##PERF(args);					\
+	fire_sched_notifiers_##SN(args);				\
+} while (0)
+
+#define SCHED_EVENT_RQ(TP, PERF, SN, rq, args) do {			\
+	trace_sched_##TP(rq, args);					\
+	perf_event_task_##PERF(rq, args);				\
+	fire_sched_notifiers_##SN(args);				\
+} while (0)
+
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
 {
 	update_load_add(&rq->load, load);
@@ -2083,8 +2116,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
 #endif
 
-	trace_sched_migrate_task(p, new_cpu);
-	perf_event_task_migrate(p, new_cpu);
+	SCHED_EVENT(migrate_task, migrate, NONE, SE_ARGS(p, new_cpu));
 
 	if (task_cpu(p) != new_cpu)
 		p->se.nr_migrations++;
@@ -2223,7 +2255,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
-		trace_sched_wait_task(rq, p);
+		SCHED_EVENT_RQ(wait_task, NONE, NONE, rq, SE_ARGS(p));
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
@@ -2515,7 +2547,7 @@ out_activate:
 	}
 
 out_running:
-	trace_sched_wakeup(rq, p, success);
+	SCHED_EVENT_RQ(wakeup, NONE, NONE, rq, SE_ARGS(p, success));
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2726,7 +2758,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	p->state = TASK_RUNNING;
 	update_rq_clock(rq);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(rq, p, 1);
+	SCHED_EVENT_RQ(wakeup_new, NONE, NONE, rq, SE_ARGS(p, 1));
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
@@ -2795,8 +2827,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
 
-	perf_event_task_sched_in(current);
-	fire_sched_notifiers_in(current);
+	SCHED_EVENT(NONE, sched_in, in, SE_ARGS(current));
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
@@ -3498,7 +3529,7 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
-	perf_event_task_tick(curr);
+	SCHED_EVENT(NONE, tick, NONE, SE_ARGS(curr));
 
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
@@ -3712,9 +3743,7 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
-		trace_sched_switch(rq, prev, next);
-		perf_event_task_sched_out(rq, prev, next);
-		fire_sched_notifiers_out(prev, next);
+		SCHED_EVENT_RQ(switch, sched_out, out, rq, SE_ARGS(prev, next));
 
 		rq->nr_switches++;
 		rq->curr = next;
-- 
1.6.4.2

