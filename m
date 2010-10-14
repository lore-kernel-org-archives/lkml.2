Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0JNVKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:10:30 -0400
Received: from canuck.infradead.org ([134.117.69.58]:56107 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab0JNVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:26 -0400
Message-Id: <20101014203625.552405859@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 6/7] perf: use jump_label to optimize the scheduler hooks
References: <20101014203404.222133139@chello.nl>
Content-Disposition: inline; filename=perf-jump-label.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   27 +++++++++++++++++++++++++--
 kernel/perf_event.c        |   24 +++++++++---------------
 2 files changed, 34 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -487,6 +487,7 @@ struct perf_guest_info_callbacks {
 #include <linux/ftrace.h>
 #include <linux/cpu.h>
 #include <linux/irq_work.h>
+#include <linux/jump_label_ref.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
 
@@ -893,8 +894,30 @@ struct perf_output_handle {
 extern int perf_pmu_register(struct pmu *pmu);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
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
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -34,7 +34,7 @@
 
 #include <asm/irq_regs.h>
 
-static atomic_t nr_events __read_mostly;
+atomic_t perf_task_events __read_mostly;
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
 static atomic_t nr_task_events __read_mostly;
@@ -1251,8 +1251,8 @@ void perf_event_context_sched_out(struct
  * accessing the event control register. If a NMI hits, then it will
  * not restart the event.
  */
-void perf_event_task_sched_out(struct task_struct *task,
-			       struct task_struct *next)
+void __perf_event_task_sched_out(struct task_struct *task,
+				 struct task_struct *next)
 {
 	int ctxn;
 
@@ -1280,14 +1280,6 @@ static void task_ctx_sched_out(struct pe
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
@@ -1434,7 +1426,7 @@ void perf_event_context_sched_in(struct 
  * accessing the event control register. If a NMI hits, then it will
  * keep the event running.
  */
-void perf_event_task_sched_in(struct task_struct *task)
+void __perf_event_task_sched_in(struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 	int ctxn;
@@ -2150,7 +2142,8 @@ static void free_event(struct perf_event
 	irq_work_sync(&event->pending);
 
 	if (!event->parent) {
-		atomic_dec(&nr_events);
+		if (event->attach_state & PERF_ATTACH_TASK)
+			jump_label_dec(&perf_task_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_dec(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5286,7 +5279,8 @@ perf_event_alloc(struct perf_event_attr 
 	event->pmu = pmu;
 
 	if (!event->parent) {
-		atomic_inc(&nr_events);
+		if (event->attach_state & PERF_ATTACH_TASK)
+			jump_label_inc(&perf_task_events);
 		if (event->attr.mmap || event->attr.mmap_data)
 			atomic_inc(&nr_mmap_events);
 		if (event->attr.comm)
@@ -5781,7 +5775,7 @@ static void perf_event_exit_task_context
 	 * our context.
 	 */
 	child_ctx = child->perf_event_ctxp[ctxn];
-	__perf_event_task_sched_out(child_ctx);
+	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
 	 * Take the context lock here so that if find_get_context is


