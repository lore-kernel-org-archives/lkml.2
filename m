Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0JRTWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:22:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:35134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab0JRTWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:22:24 -0400
Date: Mon, 18 Oct 2010 19:21:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101014203625.501657727@chello.nl>
References: <20101014203625.501657727@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Use jump_labels to optimize the scheduler hooks
Message-ID: <tip-82cd6def9806dcb6a325fb6abbc1d61388a15f6a@git.kernel.org>
Git-Commit-ID: 82cd6def9806dcb6a325fb6abbc1d61388a15f6a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82cd6def9806dcb6a325fb6abbc1d61388a15f6a
Gitweb:     http://git.kernel.org/tip/82cd6def9806dcb6a325fb6abbc1d61388a15f6a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 17:57:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:58 +0200

perf: Use jump_labels to optimize the scheduler hooks

Trades a call + conditional + ret for an unconditional jmp.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101014203625.501657727@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   27 +++++++++++++++++++++++++--
 kernel/perf_event.c        |   24 +++++++++---------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 97965fa..7f0e7f5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -487,6 +487,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
+#include <linux/jump_label_ref.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
 
@@ -895,8 +896,30 @@ extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
 extern const char *perf_pmu_name(void);
-extern void perf_event_task_sched_in(struct task_struct *task);
-extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
+extern void __perf_event_task_sched_in(struct task_struct *task);
+extern void __perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
+
+extern atomic_t perf_task_events;
+
+static inline void perf_event_task_sched_in(struct task_struct *task)
+{
+	JUMP_LABEL(&perf_task_events, have_events);
+	return;
+
+have_events:
+	__perf_event_task_sched_in(task);
+}
+
+static inline
+void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
+{
+	JUMP_LABEL(&perf_task_events, have_events);
+	return;
+
+have_events:
+	__perf_event_task_sched_out(task, next);
+}
+
 extern int perf_event_init_task(struct task_struct *child);
 extern void perf_event_exit_task(struct task_struct *child);
 extern void perf_event_free_task(struct task_struct *task);
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 856e20b..f7febb0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -34,7 +34,7 @@
 
 #include <asm/irq_regs.h>
 
-static atomic_t nr_events __read_mostly;
+atomic_t perf_task_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -1311,8 +1311,8 @@ void perf_event_context_sched_out(struct task_struct *task, int ctxn,
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-void perf_event_task_sched_out(struct task_struct *task,
-			       struct task_struct *next)
+void __perf_event_task_sched_out(struct task_struct *task,
+				 struct task_struct *next)
 {
 	int ctxn;
 
@@ -1340,14 +1340,6 @@ static void task_ctx_sched_out(struct perf_event_context *ctx,
 /*
  * Called with IRQs disabled
  */
-static void __perf_event_task_sched_out(struct perf_event_context *ctx)
-{
-	task_ctx_sched_out(ctx, EVENT_ALL);
-}
-
-/*
- * Called with IRQs disabled
- */
 static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
 			      enum event_type_t event_type)
 {
@@ -1494,7 +1486,7 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void perf_event_task_sched_in(struct task_struct *task)
+void __perf_event_task_sched_in(struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2216,7 +2208,8 @@ static void free_event(struct perf_event *event)
 	irq_work_sync(&event->pending);
 
 	if (!event->parent) {
-		atomic_dec(&nr_events);
+		if (event->attach_state & PERF_ATTACH_TASK)
+			jump_label_dec(&perf_task_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5354,7 +5347,8 @@ done:
 	event->pmu = pmu;
 
 	if (!event->parent) {
-		atomic_inc(&nr_events);
+		if (event->attach_state & PERF_ATTACH_TASK)
+			jump_label_inc(&perf_task_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5849,7 +5843,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * our context.
 	 */
 	child_ctx = child->perf_event_ctxp[ctxn];
-	__perf_event_task_sched_out(child_ctx);
+	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
 	 * Take the context lock here so that if find_get_context is
