Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909Ab0EXEE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 00:04:28 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:57090 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0EXEE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 00:04:27 -0400
Date: Mon, 24 May 2010 09:34:18 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Gibson <dwg@au1.ibm.com>, Roland McGrath <roland@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Michael Neuling <mikey@neuling.org>,
       Alan Stern <stern@rowland.harvard.edu>, shaggy@linux.vnet.ibm.com,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [RFC Patch 5/5] PPC64-HWBKPT: Enable proper distinction of
	per-task and per-cpu breakpoints
Message-ID: <20100524040418.GF20873@in.ibm.com>
References: <20100524034520.964014525@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=per_task_per_cpu_06
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-task and per-cpu breakpoints have to be unambiguously identified for
proper restoration of hw-breakpoints. The notion of pure user- and kernel-
space breakpoints is antiquated. Store 'pid' of the process against which
the perf-counter was requested to help proper distinction.

This helps seamless handling of kernel-space breakpoints within the context
of a user-space process and breakpoints for kernel-threads.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/hw_breakpoint.c |   24 +++++++++++++++++-------
 include/linux/perf_event.h          |    1 +
 kernel/perf_event.c                 |    9 ++++++---
 3 files changed, 24 insertions(+), 10 deletions(-)

Index: linux-2.6.ppc64_test/include/linux/perf_event.h
===================================================================
--- linux-2.6.ppc64_test.orig/include/linux/perf_event.h
+++ linux-2.6.ppc64_test/include/linux/perf_event.h
@@ -698,6 +698,7 @@ struct perf_event {
 
 	int				oncpu;
 	int				cpu;
+	pid_t				pid;
 
 	struct list_head		owner_entry;
 	struct task_struct		*owner;
Index: linux-2.6.ppc64_test/kernel/perf_event.c
===================================================================
--- linux-2.6.ppc64_test.orig/kernel/perf_event.c
+++ linux-2.6.ppc64_test/kernel/perf_event.c
@@ -4684,6 +4684,7 @@ static const struct pmu *sw_perf_event_i
 static struct perf_event *
 perf_event_alloc(struct perf_event_attr *attr,
 		   int cpu,
+		   pid_t pid,
 		   struct perf_event_context *ctx,
 		   struct perf_event *group_leader,
 		   struct perf_event *parent_event,
@@ -4717,6 +4718,7 @@ perf_event_alloc(struct perf_event_attr 
 	mutex_init(&event->mmap_mutex);
 
 	event->cpu		= cpu;
+	event->pid		= pid;
 	event->attr		= *attr;
 	event->group_leader	= group_leader;
 	event->pmu		= NULL;
@@ -5015,7 +5017,7 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_put_context;
 	}
 
-	event = perf_event_alloc(&attr, cpu, ctx, group_leader,
+	event = perf_event_alloc(&attr, cpu, pid, ctx, group_leader,
 				     NULL, NULL, GFP_KERNEL);
 	err = PTR_ERR(event);
 	if (IS_ERR(event))
@@ -5090,7 +5092,7 @@ perf_event_create_kernel_counter(struct 
 		goto err_exit;
 	}
 
-	event = perf_event_alloc(attr, cpu, ctx, NULL,
+	event = perf_event_alloc(attr, cpu, pid, ctx, NULL,
 				 NULL, overflow_handler, GFP_KERNEL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
@@ -5142,7 +5144,8 @@ inherit_event(struct perf_event *parent_
 		parent_event = parent_event->parent;
 
 	child_event = perf_event_alloc(&parent_event->attr,
-					   parent_event->cpu, child_ctx,
+					   parent_event->cpu, child->pid,
+					   child_ctx,
 					   group_leader, parent_event,
 					   NULL, GFP_KERNEL);
 	if (IS_ERR(child_event))
Index: linux-2.6.ppc64_test/arch/powerpc/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6.ppc64_test.orig/arch/powerpc/kernel/hw_breakpoint.c
+++ linux-2.6.ppc64_test/arch/powerpc/kernel/hw_breakpoint.c
@@ -221,7 +221,7 @@ void thread_change_pc(struct task_struct
  */
 int __kprobes hw_breakpoint_handler(struct die_args *args)
 {
-	bool is_kernel, is_ptrace_bp = false;
+	bool is_kernel, is_taskbound_bp, is_ptrace_bp = false;
 	int rc = NOTIFY_STOP;
 	struct perf_event *bp;
 	struct pt_regs *regs = args->regs;
@@ -246,6 +246,7 @@ int __kprobes hw_breakpoint_handler(stru
 	is_kernel = is_kernel_addr(bp->attr.bp_addr);
 	is_ptrace_bp = (bp->overflow_handler == ptrace_triggered) ?
 			true : false;
+	is_taskbound_bp = (bp->pid > 0) ? true : false;
 
 	/*
 	 * Verify if dar lies within the address range occupied by the symbol
@@ -288,7 +289,14 @@ int __kprobes hw_breakpoint_handler(stru
 	/* emulate_step() could not execute it, single-step them */
 	if (stepped == 0) {
 		regs->msr |= MSR_SE;
-		__get_cpu_var(last_hit_bp) = bp;
+		/*
+		 * Kernel-space addresses can also be bound to a task. If so,
+		 * store the breakpoint in its 'thread_struct'
+		 */
+		if (is_taskbound_bp)
+			bp->ctx->task->thread.last_hit_ubp = bp;
+		else
+			__get_cpu_var(last_hit_bp) = bp;
 		goto out;
 	}
 	/*
@@ -310,17 +318,17 @@ out:
 int __kprobes single_step_dabr_instruction(struct die_args *args)
 {
 	struct pt_regs *regs = args->regs;
-	struct perf_event *bp = NULL, *kernel_bp, *user_bp;
+	struct perf_event *bp = NULL, *kernel_bp, *per_task_bp;
 	struct arch_hw_breakpoint *bp_info;
 
 	/*
 	 * Identify the cause of single-stepping and find the corresponding
 	 * breakpoint structure
 	 */
-	user_bp = current->thread.last_hit_ubp;
+	per_task_bp = current->thread.last_hit_ubp;
 	kernel_bp = __get_cpu_var(last_hit_bp);
-	if (user_bp) {
-		bp = user_bp;
+	if (per_task_bp) {
+		bp = per_task_bp;
 		current->thread.last_hit_ubp = NULL;
 	} else if (kernel_bp) {
 		bp = kernel_bp;
@@ -348,7 +356,9 @@ int __kprobes single_step_dabr_instructi
 	 * for kernel-space breakpoints, so this cannot work along with other
 	 * debuggers (like KGDB, xmon) which may be single-stepping kernel code.
 	 */
-	if (!(user_bp && test_thread_flag(TIF_SINGLESTEP)))
+	if (!(per_task_bp &&
+	     (!is_kernel_addr(bp->attr.bp_addr)) &&
+	     test_thread_flag(TIF_SINGLESTEP)))
 		regs->msr &= ~MSR_SE;
 
 	set_dabr(bp_info->address | bp_info->type | DABR_TRANSLATION);

