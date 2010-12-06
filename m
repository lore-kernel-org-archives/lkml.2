Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0LFRRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:17:51 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:40850 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752673Ab0LFRQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:42 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: D7Gx_FMVM1n8DTE5L2UaARGzl8cuz5TDnfcAytzh7rn1Z_j
 fXIHQFbBkMWLEViIqcMd48Y8CD0Ubsezb4Krg1ERh.o.BUpCtTrloBICtPji
 AgsHC_lL6nc4_3ltY7f0.3hsg9L6ZzbHNZ22Y3naaPFJ5rpcGxe6dhNeZqJB
 uXo.NoeFBT9_QiRcBYnfkmByPrx4e2RBm1yCJvOox1FUeS_o5rAMQjWhLQvz
 r0jJAfGpu0lRQEIlbDbbyuMml1c6833cWfm.aCrgW4jl0zRac0g6C
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171640.321083096@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:25 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Jason Baron <jbaron@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 07/11] kprobes: Use this_cpu_ops
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_kprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu ops in various places to optimize per cpu data access.

Cc: Jason Baron <jbaron@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/kernel/kprobes.c |   14 +++++++-------
 include/linux/kprobes.h   |    4 ++--
 kernel/kprobes.c          |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kprobes.c	2010-12-03 14:48:27.000000000 -0600
+++ linux-2.6/arch/x86/kernel/kprobes.c	2010-12-06 10:29:03.000000000 -0600
@@ -403,7 +403,7 @@ static void __kprobes save_previous_kpro
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
 	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
 	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
@@ -412,7 +412,7 @@ static void __kprobes restore_previous_k
 static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 				struct kprobe_ctlblk *kcb)
 {
-	__get_cpu_var(current_kprobe) = p;
+	__this_cpu_write(current_kprobe, p);
 	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (X86_EFLAGS_TF | X86_EFLAGS_IF));
 	if (is_IF_modifier(p->ainsn.insn))
@@ -586,7 +586,7 @@ static int __kprobes kprobe_handler(stru
 		preempt_enable_no_resched();
 		return 1;
 	} else if (kprobe_running()) {
-		p = __get_cpu_var(current_kprobe);
+		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
 			setup_singlestep(p, regs, kcb, 0);
 			return 1;
@@ -759,11 +759,11 @@ static __used __kprobes void *trampoline
 
 		orig_ret_address = (unsigned long)ri->ret_addr;
 		if (ri->rp && ri->rp->handler) {
-			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			__this_cpu_write(current_kprobe, &ri->rp->kp);
 			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
 			ri->ret_addr = correct_ret_addr;
 			ri->rp->handler(ri, regs);
-			__get_cpu_var(current_kprobe) = NULL;
+			__this_cpu_write(current_kprobe, NULL);
 		}
 
 		recycle_rp_inst(ri, &empty_rp);
@@ -1198,10 +1198,10 @@ static void __kprobes optimized_callback
 		regs->ip = (unsigned long)op->kp.addr + INT3_SIZE;
 		regs->orig_ax = ~0UL;
 
-		__get_cpu_var(current_kprobe) = &op->kp;
+		__this_cpu_write(current_kprobe, &op->kp);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 		opt_pre_handler(&op->kp, regs);
-		__get_cpu_var(current_kprobe) = NULL;
+		__this_cpu_write(current_kprobe, NULL);
 	}
 	preempt_enable_no_resched();
 }
Index: linux-2.6/include/linux/kprobes.h
===================================================================
--- linux-2.6.orig/include/linux/kprobes.h	2010-12-03 14:48:27.000000000 -0600
+++ linux-2.6/include/linux/kprobes.h	2010-12-06 10:29:03.000000000 -0600
@@ -303,12 +303,12 @@ struct hlist_head * kretprobe_inst_table
 /* kprobe_running() will just return the current_kprobe on this CPU */
 static inline struct kprobe *kprobe_running(void)
 {
-	return (__get_cpu_var(current_kprobe));
+	return (__this_cpu_read(current_kprobe));
 }
 
 static inline void reset_current_kprobe(void)
 {
-	__get_cpu_var(current_kprobe) = NULL;
+	__this_cpu_write(current_kprobe, NULL);
 }
 
 static inline struct kprobe_ctlblk *get_kprobe_ctlblk(void)
Index: linux-2.6/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/kernel/kprobes.c	2010-12-03 14:48:27.000000000 -0600
+++ linux-2.6/kernel/kprobes.c	2010-12-06 10:29:03.000000000 -0600
@@ -317,12 +317,12 @@ void __kprobes free_optinsn_slot(kprobe_
 /* We have preemption disabled.. so it is safe to use __ versions */
 static inline void set_kprobe_instance(struct kprobe *kp)
 {
-	__get_cpu_var(kprobe_instance) = kp;
+	__this_cpu_write(kprobe_instance, kp);
 }
 
 static inline void reset_kprobe_instance(void)
 {
-	__get_cpu_var(kprobe_instance) = NULL;
+	__this_cpu_write(kprobe_instance, NULL);
 }
 
 /*
@@ -775,7 +775,7 @@ static void __kprobes aggr_post_handler(
 static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
 					int trapnr)
 {
-	struct kprobe *cur = __get_cpu_var(kprobe_instance);
+	struct kprobe *cur = __this_cpu_read(kprobe_instance);
 
 	/*
 	 * if we faulted "during" the execution of a user specified
@@ -790,7 +790,7 @@ static int __kprobes aggr_fault_handler(
 
 static int __kprobes aggr_break_handler(struct kprobe *p, struct pt_regs *regs)
 {
-	struct kprobe *cur = __get_cpu_var(kprobe_instance);
+	struct kprobe *cur = __this_cpu_read(kprobe_instance);
 	int ret = 0;
 
 	if (cur && cur->break_handler) {

