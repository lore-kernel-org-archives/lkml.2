Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab0JNVKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:10:22 -0400
Received: from canuck.infradead.org ([134.117.69.58]:56103 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab0JNVKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:20 -0400
Message-Id: <20101014203625.391543667@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 3/7] perf, hw_breakpoint: Fix crash in hw_breakpoint creation
References: <20101014203404.222133139@chello.nl>
Content-Disposition: inline; filename=perf-fix-hw_bp-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hw_breakpoint creation needs to account stuff per-task to ensure there
is always sufficient hardware resources to back these things due to
ptrace.

With the perf per pmu context changes the event initialization no
longer has access to the event context, for the simple reason that we
need to first find the pmu (result of initialization) before we can
find the context.

This makes hw_breakpoints unhappy, because it can no longer do per
task accounting, cure this by frobbing a task pointer in the event::hw
bits for now...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/perf_event.h |    7 +++++++
 kernel/hw_breakpoint.c     |    8 ++++----
 kernel/perf_event.c        |   21 ++++++++++++++++-----
 3 files changed, 27 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -536,6 +536,12 @@ struct hw_perf_event {
 		struct { /* breakpoint */
 			struct arch_hw_breakpoint	info;
 			struct list_head		bp_list;
+			/*
+			 * Crufty hack to avoid the chicken and egg
+			 * problem hw_breakpoint has with context
+			 * creation and event initalization.
+			 */
+			struct task_struct		*bp_target;
 		};
 #endif
 	};
@@ -693,6 +699,7 @@ struct swevent_hlist {
 
 #define PERF_ATTACH_CONTEXT	0x01
 #define PERF_ATTACH_GROUP	0x02
+#define PERF_ATTACH_TASK	0x04
 
 /**
  * struct perf_event - performance event kernel representation:
Index: linux-2.6/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.orig/kernel/hw_breakpoint.c
+++ linux-2.6/kernel/hw_breakpoint.c
@@ -113,12 +113,12 @@ static unsigned int max_task_bp_pinned(i
  */
 static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
 {
-	struct perf_event_context *ctx = bp->ctx;
+	struct task_struct *tsk = bp->hw.bp_target;
 	struct perf_event *iter;
 	int count = 0;
 
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
-		if (iter->ctx == ctx && find_slot_idx(iter) == type)
+		if (iter->hw.bp_target == tsk && find_slot_idx(iter) == type)
 			count += hw_breakpoint_weight(iter);
 	}
 
@@ -134,7 +134,7 @@ fetch_bp_busy_slots(struct bp_busy_slots
 		    enum bp_type_idx type)
 {
 	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->ctx->task;
+	struct task_struct *tsk = bp->hw.bp_target;
 
 	if (cpu >= 0) {
 		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -213,7 +213,7 @@ toggle_bp_slot(struct perf_event *bp, bo
 	       int weight)
 {
 	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->ctx->task;
+	struct task_struct *tsk = bp->hw.bp_target;
 
 	/* Pinned counter cpu profiling */
 	if (!tsk) {
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5189,9 +5189,10 @@ struct pmu *perf_init_event(struct perf_
  */
 static struct perf_event *
 perf_event_alloc(struct perf_event_attr *attr, int cpu,
-		   struct perf_event *group_leader,
-		   struct perf_event *parent_event,
-		   perf_overflow_handler_t overflow_handler)
+		 struct task_struct *task,
+		 struct perf_event *group_leader,
+		 struct perf_event *parent_event,
+		 perf_overflow_handler_t overflow_handler)
 {
 	struct pmu *pmu;
 	struct perf_event *event;
@@ -5233,6 +5234,15 @@ perf_event_alloc(struct perf_event_attr 
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (task) {
+		event->attach_state = PERF_ATTACH_TASK;
+		/*
+		 * hw_breakpoint is a bit difficult here..
+		 */
+		if (attr->type == PERF_TYPE_BREAKPOINT)
+			event->hw.bp_target = task;
+	}
+
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
 	
@@ -5493,7 +5503,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_task;
@@ -5662,7 +5672,7 @@ perf_event_create_kernel_counter(struct 
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -5930,6 +5940,7 @@ inherit_event(struct perf_event *parent_
 
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
+					   child,
 					   group_leader, parent_event,
 					   NULL);
 	if (IS_ERR(child_event))


