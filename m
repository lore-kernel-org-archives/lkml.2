Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab0JRTVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:21:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:35074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0JRTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:21:10 -0400
Date: Mon, 18 Oct 2010 19:20:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101014203625.391543667@chello.nl>
References: <20101014203625.391543667@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, hw_breakpoint: Fix crash in hw_breakpoint creation
Message-ID: <tip-d580ff8699e8811a9af37e9de4dea375401bdeec@git.kernel.org>
Git-Commit-ID: d580ff8699e8811a9af37e9de4dea375401bdeec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:20:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d580ff8699e8811a9af37e9de4dea375401bdeec
Gitweb:     http://git.kernel.org/tip/d580ff8699e8811a9af37e9de4dea375401bdeec
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 17:43:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:55 +0200

perf, hw_breakpoint: Fix crash in hw_breakpoint creation

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
LKML-Reference: <20101014203625.391543667@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    7 +++++++
 kernel/hw_breakpoint.c     |    8 ++++----
 kernel/perf_event.c        |   23 ++++++++++++++++++-----
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2ebfc9a..97965fa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
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
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 3b714e8..2c9120f 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -113,12 +113,12 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
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
 
@@ -134,7 +134,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		    enum bp_type_idx type)
 {
 	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->ctx->task;
+	struct task_struct *tsk = bp->hw.bp_target;
 
 	if (cpu >= 0) {
 		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -213,7 +213,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	       int weight)
 {
 	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->ctx->task;
+	struct task_struct *tsk = bp->hw.bp_target;
 
 	/* Pinned counter cpu profiling */
 	if (!tsk) {
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b21d06a..856e20b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5255,9 +5255,10 @@ unlock:
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
@@ -5299,6 +5300,17 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (task) {
+		event->attach_state = PERF_ATTACH_TASK;
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+		/*
+		 * hw_breakpoint is a bit difficult here..
+		 */
+		if (attr->type == PERF_TYPE_BREAKPOINT)
+			event->hw.bp_target = task;
+#endif
+	}
+
 	if (!overflow_handler && parent_event)
 		overflow_handler = parent_event->overflow_handler;
 	
@@ -5559,7 +5571,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
+	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err_task;
@@ -5728,7 +5740,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 	 * Get the target context (task or percpu):
 	 */
 
-	event = perf_event_alloc(attr, cpu, NULL, NULL, overflow_handler);
+	event = perf_event_alloc(attr, cpu, task, NULL, NULL, overflow_handler);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
 		goto err;
@@ -5996,6 +6008,7 @@ inherit_event(struct perf_event *parent_event,
 
 	child_event = perf_event_alloc(&parent_event->attr,
 					   parent_event->cpu,
+					   child,
 					   group_leader, parent_event,
 					   NULL);
 	if (IS_ERR(child_event))
