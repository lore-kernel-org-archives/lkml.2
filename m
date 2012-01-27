Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2A0U6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:58:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50639 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab2A0U6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:58:45 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v4 10/18] perf: add hook to flush branch_stack on context switch
Date: Fri, 27 Jan 2012 21:56:10 +0100
Message-Id: <1327697778-18515-11-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327697778-18515-1-git-send-email-eranian@google.com>
References: <1327697778-18515-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With branch stack sampling, it is possible to filter by priv levels.
In system-wide mode, that means it is possible to capture only user
level branches. The builtin SW LBR filter needs to disassemble code
based on LBR captured addresses. For that, it needs to know the task
the addresses are associated with. Because of context switches, the
content of the branch stack buffer may contain addresses from
different tasks.

We need a hook on context switch to either flush the branch stack
or save it. This patch adds a new hook in struct pmu which is called
during context switches. The hook is called only when necessary.
That is when a system-wide context has, at least, one event which
uses PERF_SAMPLE_BRANCH_STACK. The hook is never called for per-thread
context.

In this version, the Intel X86 code simply flushes (reset) the LBR
on context switches (fill with zeroes). Those zeroed branches are
then filtered out by the SW filter.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   21 +++++---
 arch/x86/kernel/cpu/perf_event.h       |    1 +
 arch/x86/kernel/cpu/perf_event_intel.c |   13 +++++
 include/linux/perf_event.h             |    9 +++-
 kernel/events/core.c                   |   85 ++++++++++++++++++++++++++++++++
 5 files changed, 121 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 710ec93..01ce138 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1633,25 +1633,32 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
 	NULL,
 };
 
+static void x86_pmu_flush_branch_stack(void)
+{
+	if (x86_pmu.flush_branch_stack)
+		x86_pmu.flush_branch_stack();
+}
+
 static struct pmu pmu = {
-	.pmu_enable	= x86_pmu_enable,
-	.pmu_disable	= x86_pmu_disable,
+	.pmu_enable		= x86_pmu_enable,
+	.pmu_disable		= x86_pmu_disable,
 
 	.attr_groups	= x86_pmu_attr_groups,
 
 	.event_init	= x86_pmu_event_init,
 
-	.add		= x86_pmu_add,
-	.del		= x86_pmu_del,
-	.start		= x86_pmu_start,
-	.stop		= x86_pmu_stop,
-	.read		= x86_pmu_read,
+	.add			= x86_pmu_add,
+	.del			= x86_pmu_del,
+	.start			= x86_pmu_start,
+	.stop			= x86_pmu_stop,
+	.read			= x86_pmu_read,
 
 	.start_txn	= x86_pmu_start_txn,
 	.cancel_txn	= x86_pmu_cancel_txn,
 	.commit_txn	= x86_pmu_commit_txn,
 
 	.event_idx	= x86_pmu_event_idx,
+	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
 void perf_update_user_clock(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index a5281a4..1699d36 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -322,6 +322,7 @@ struct x86_pmu {
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);
 	void		(*cpu_dead)(int cpu);
+	void		(*flush_branch_stack)(void);
 
 	/*
 	 * Intel Arch Perfmon v2+
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7cc1e2d..6627089 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1539,6 +1539,18 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
+static void intel_pmu_flush_branch_stack(void)
+{
+	/*
+	 * Intel LBR does not tag entries with the
+	 * PID of the current task, then we need to
+	 * flush it on ctxsw
+	 * For now, we simply reset it
+	 */
+	if (x86_pmu.lbr_nr)
+		intel_pmu_lbr_reset();
+}
+
 static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -1566,6 +1578,7 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.cpu_starting		= intel_pmu_cpu_starting,
 	.cpu_dying		= intel_pmu_cpu_dying,
 	.guest_get_msrs		= intel_guest_get_msrs,
+	.flush_branch_stack	= intel_pmu_flush_branch_stack,
 };
 
 static __init void intel_clovertown_quirk(void)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3ac057d..6d9d712 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -745,6 +745,11 @@ struct pmu {
 	 * if no implementation is provided it will default to: event->hw.idx + 1.
 	 */
 	int (*event_idx)		(struct perf_event *event); /*optional */
+
+	/*
+	 * flush branch stack on context-switches (needed in cpu-wide mode)
+	 */
+	void (*flush_branch_stack)	(void);
 };
 
 /**
@@ -975,7 +980,8 @@ struct perf_event_context {
 	u64				parent_gen;
 	u64				generation;
 	int				pin_count;
-	int				nr_cgroups; /* cgroup events present */
+	int				nr_cgroups;	 /* cgroup evts */
+	int				nr_branch_stack; /* branch_stack evt */
 	struct rcu_head			rcu_head;
 };
 
@@ -1040,6 +1046,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
+
 struct perf_sample_data {
 	u64				type;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 431f7b4..7e4d4af 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -137,6 +137,7 @@ enum event_type_t {
  */
 struct jump_label_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
+static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -888,6 +889,9 @@ list_add_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (is_cgroup_event(event))
 		ctx->nr_cgroups++;
 
+	if (has_branch_stack(event))
+		ctx->nr_branch_stack++;
+
 	list_add_rcu(&event->event_entry, &ctx->event_list);
 	if (!ctx->nr_events)
 		perf_pmu_rotate_start(ctx->pmu);
@@ -1027,6 +1031,9 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 			cpuctx->cgrp = NULL;
 	}
 
+	if (has_branch_stack(event))
+		ctx->nr_branch_stack--;
+
 	ctx->nr_events--;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat--;
@@ -2202,6 +2209,66 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 }
 
 /*
+ * When sampling the branck stack in system-wide, it may be necessary
+ * to flush the stack on context switch. This happens when the branch
+ * stack does not tag its entries with the pid of the current task.
+ * Otherwise it becomes impossible to associate a branch entry with a
+ * task. This ambiguity is more likely to appear when the branch stack
+ * supports priv level filtering and the user sets it to monitor only
+ * at the user level (which could be a useful measurement in system-wide
+ * mode). In that case, the risk is high of having a branch stack with
+ * branch from multiple tasks. Flushing may mean dropping the existing
+ * entries or stashing them somewhere in the PMU specific code layer.
+ *
+ * This function provides the context switch callback to the lower code
+ * layer. It is invoked ONLY when there is at least one system-wide context
+ * with at least one active event using taken branch sampling.
+ */
+static void perf_branch_stack_sched_in(struct task_struct *prev,
+				       struct task_struct *task)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+
+	/* no need to flush branch stack if not changing task */
+	if (prev == task)
+		return;
+
+	local_irq_save(flags);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+
+		/*
+		 * check if the context has at least one
+		 * event using PERF_SAMPLE_BRANCH_STACK
+		 */
+		if (cpuctx->ctx.nr_branch_stack > 0
+		    && pmu->flush_branch_stack) {
+
+			pmu = cpuctx->ctx.pmu;
+
+			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+			perf_pmu_disable(pmu);
+
+			pmu->flush_branch_stack();
+
+			perf_pmu_enable(pmu);
+
+			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+		}
+	}
+
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
+/*
  * Called from scheduler to add the events of the current task
  * with interrupts disabled.
  *
@@ -2232,6 +2299,10 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	 */
 	if (atomic_read(&__get_cpu_var(perf_cgroup_events)))
 		perf_cgroup_sched_in(prev, task);
+
+	/* check for system-wide branch_stack events */
+	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
+		perf_branch_stack_sched_in(prev, task);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -2768,6 +2839,14 @@ static void free_event(struct perf_event *event)
 			atomic_dec(&per_cpu(perf_cgroup_events, event->cpu));
 			jump_label_dec_deferred(&perf_sched_events);
 		}
+
+		if (has_branch_stack(event)) {
+			jump_label_dec_deferred(&perf_sched_events);
+			/* is system-wide event */
+			if (!(event->attach_state & PERF_ATTACH_TASK))
+				atomic_dec(&per_cpu(perf_branch_stack_events,
+						    event->cpu));
+		}
 	}
 
 	if (event->rb) {
@@ -5887,6 +5966,12 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 				return ERR_PTR(err);
 			}
 		}
+		if (has_branch_stack(event)) {
+			jump_label_inc(&perf_sched_events.key);
+			if (!(event->attach_state & PERF_ATTACH_TASK))
+				atomic_inc(&per_cpu(perf_branch_stack_events,
+						    event->cpu));
+		}
 	}
 
 	return event;
-- 
1.7.1

