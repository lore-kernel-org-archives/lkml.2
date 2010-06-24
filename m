Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0FXVlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:41:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab0FXVkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Cvx9efNzyQsLEFZ2uK1fqiUtmpmM8jfB84sPCwyHCEMPloaHd3kqvvJ9fAWnQrrRGP
         V49JjK5cavk2dTNKNqkJocJKbpfI3izY537/lsPKynR/Gs+jYLK7MMwX4BYs8ptHXcvh
         okx1MIsGBEPmxp3Fnb42X1zhjk50NWpagSvOs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Will Deacon <will.deacon@arm.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/7] hw_breakpoints: Fix per task breakpoint tracking
Date: Thu, 24 Jun 2010 23:40:52 +0200
Message-Id: <1277415658-10036-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freeing a perf event can happen in several ways. A task
calls perf_event_exit_task() right before exiting. This helper
will detach all the events from the task context and queue their
removal through free_event() if they are child tasks. The task
also loses its context reference there.

Releasing the breakpoint slot from the constraint table is made
from free_event() that calls release_bp_slot(). We count the number
of breakpoints this task is running by looking at the task's
perf_event_ctxp and iterating through its attached events.
But at this time, the reference to this context has been cleaned up
already.

So looking at the event->ctx instead of task->perf_event_ctxp
to count the remaining breakpoints should solve the problem.
At least it would for child breakpoints, but not for parent ones.
If the parent exits before the child, it will remove all its
events from the context but free_event() will be called later,
on fd release time. And checking the number of breakpoints the
task has attached to its context at this time is unreliable as all
events have been removed from the context.

To solve this, we keep track of the list of per task breakpoints.
On top of it, we maintain our array of numbers of breakpoints used
by the tasks. We use the context address as a task id.

So, instead of looking at the number of events attached to a context,
we walk through our list of per task breakpoints and count the number
of breakpoints that use the same ctx than the one to be reserved or
released from the constraint table, and update the count on top of this
result.

In the meantime it solves a bad refcounting, it also solves a warning,
reported by Paul.

Badness at /home/paulus/kernel/perf/kernel/hw_breakpoint.c:114
NIP: c0000000000cb470 LR: c0000000000cb46c CTR: c00000000032d9b8
REGS: c000000118e7b570 TRAP: 0700   Not tainted  (2.6.35-rc3-perf-00008-g76b0f13
)
MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 44004424  XER: 000fffff
TASK = c0000001187dcad0[3143] 'perf' THREAD: c000000118e78000 CPU: 1
GPR00: c0000000000cb46c c000000118e7b7f0 c0000000009866a0 0000000000000020
GPR04: 0000000000000000 000000000000001d 0000000000000000 0000000000000001
GPR08: c0000000009bed68 c00000000086dff8 c000000000a5bf10 0000000000000001
GPR12: 0000000024004422 c00000000ffff200 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000018 00000000101150f4
GPR20: 0000000010206b40 0000000000000000 0000000000000000 00000000101150f4
GPR24: c0000001199090c0 0000000000000001 0000000000000000 0000000000000001
GPR28: 0000000000000000 0000000000000000 c0000000008ec290 0000000000000000
NIP [c0000000000cb470] .task_bp_pinned+0x5c/0x12c
LR [c0000000000cb46c] .task_bp_pinned+0x58/0x12c
Call Trace:
[c000000118e7b7f0] [c0000000000cb46c] .task_bp_pinned+0x58/0x12c (unreliable)
[c000000118e7b8a0] [c0000000000cb584] .toggle_bp_task_slot+0x44/0xe4
[c000000118e7b940] [c0000000000cb6c8] .toggle_bp_slot+0xa4/0x164
[c000000118e7b9f0] [c0000000000cbafc] .release_bp_slot+0x44/0x6c
[c000000118e7ba80] [c0000000000c4178] .bp_perf_event_destroy+0x10/0x24
[c000000118e7bb00] [c0000000000c4aec] .free_event+0x180/0x1bc
[c000000118e7bbc0] [c0000000000c54c4] .perf_event_release_kernel+0x14c/0x170

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/perf_event.h |    6 ++-
 kernel/hw_breakpoint.c     |   78 +++++++++++++++++++++++---------------------
 2 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 63b5aa5..0dd5f8a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -533,8 +533,10 @@ struct hw_perf_event {
 			struct hrtimer	hrtimer;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-		/* breakpoint */
-		struct arch_hw_breakpoint	info;
+		struct { /* breakpoint */
+			struct arch_hw_breakpoint	info;
+			struct list_head		bp_list;
+		};
 #endif
 	};
 	local64_t			prev_count;
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 7a56b22..e34d94d 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -41,6 +41,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
 
@@ -62,6 +63,9 @@ static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);
 
 static int nr_slots[TYPE_MAX];
 
+/* Keep track of the breakpoints attached to tasks */
+static LIST_HEAD(bp_task_head);
+
 static int constraints_initialized;
 
 /* Gather the number of total pinned and un-pinned bp in a cpuset */
@@ -103,33 +107,21 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
 	return 0;
 }
 
-static int task_bp_pinned(struct task_struct *tsk, enum bp_type_idx type)
+/*
+ * Count the number of breakpoints of the same type and same task.
+ * The given event must be not on the list.
+ */
+static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
 {
-	struct perf_event_context *ctx = tsk->perf_event_ctxp;
-	struct list_head *list;
-	struct perf_event *bp;
-	unsigned long flags;
+	struct perf_event_context *ctx = bp->ctx;
+	struct perf_event *iter;
 	int count = 0;
 
-	if (WARN_ONCE(!ctx, "No perf context for this task"))
-		return 0;
-
-	list = &ctx->event_list;
-
-	raw_spin_lock_irqsave(&ctx->lock, flags);
-
-	/*
-	 * The current breakpoint counter is not included in the list
-	 * at the open() callback time
-	 */
-	list_for_each_entry(bp, list, event_entry) {
-		if (bp->attr.type == PERF_TYPE_BREAKPOINT)
-			if (find_slot_idx(bp) == type)
-				count += hw_breakpoint_weight(bp);
+	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
+		if (iter->ctx == ctx && find_slot_idx(iter) == type)
+			count += hw_breakpoint_weight(iter);
 	}
 
-	raw_spin_unlock_irqrestore(&ctx->lock, flags);
-
 	return count;
 }
 
@@ -149,7 +141,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			slots->pinned += max_task_bp_pinned(cpu, type);
 		else
-			slots->pinned += task_bp_pinned(tsk, type);
+			slots->pinned += task_bp_pinned(bp, type);
 		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
 
 		return;
@@ -162,7 +154,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			nr += max_task_bp_pinned(cpu, type);
 		else
-			nr += task_bp_pinned(tsk, type);
+			nr += task_bp_pinned(bp, type);
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
@@ -188,7 +180,7 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 /*
  * Add a pinned breakpoint for the given task in our constraint table
  */
-static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable,
+static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 				enum bp_type_idx type, int weight)
 {
 	unsigned int *tsk_pinned;
@@ -196,10 +188,11 @@ static void toggle_bp_task_slot(struct task_struct *tsk, int cpu, bool enable,
 	int old_idx = 0;
 	int idx = 0;
 
-	old_count = task_bp_pinned(tsk, type);
+	old_count = task_bp_pinned(bp, type);
 	old_idx = old_count - 1;
 	idx = old_idx + weight;
 
+	/* tsk_pinned[n] is the number of tasks having n breakpoints */
 	tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 	if (enable) {
 		tsk_pinned[idx]++;
@@ -222,23 +215,30 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	int cpu = bp->cpu;
 	struct task_struct *tsk = bp->ctx->task;
 
+	/* Pinned counter cpu profiling */
+	if (!tsk) {
+
+		if (enable)
+			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
+		else
+			per_cpu(nr_cpu_bp_pinned[type], bp->cpu) -= weight;
+		return;
+	}
+
 	/* Pinned counter task profiling */
-	if (tsk) {
-		if (cpu >= 0) {
-			toggle_bp_task_slot(tsk, cpu, enable, type, weight);
-			return;
-		}
 
+	if (!enable)
+		list_del(&bp->hw.bp_list);
+
+	if (cpu >= 0) {
+		toggle_bp_task_slot(bp, cpu, enable, type, weight);
+	} else {
 		for_each_online_cpu(cpu)
-			toggle_bp_task_slot(tsk, cpu, enable, type, weight);
-		return;
+			toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	}
 
-	/* Pinned counter cpu profiling */
 	if (enable)
-		per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
-	else
-		per_cpu(nr_cpu_bp_pinned[type], bp->cpu) -= weight;
+		list_add_tail(&bp->hw.bp_list, &bp_task_head);
 }
 
 /*
@@ -301,6 +301,10 @@ static int __reserve_bp_slot(struct perf_event *bp)
 	weight = hw_breakpoint_weight(bp);
 
 	fetch_bp_busy_slots(&slots, bp, type);
+	/*
+	 * Simulate the addition of this breakpoint to the constraints
+	 * and see the result.
+	 */
 	fetch_this_slot(&slots, weight);
 
 	/* Flexible counters need to keep at least one slot */
-- 
1.6.2.3

