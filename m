Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0CYN4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:56:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:59958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0CYN4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:56:11 -0400
Message-Id: <20100325135414.017536066@chello.nl>
References: <20100325135148.626077692@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 25 Mar 2010 14:51:51 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] x86, ptrace: Fix block-step
Content-Disposition: inline; filename=x86-fix-btf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement ptrace-block-step using TIF_BLOCKSTEP which will set
DEBUGCTLMSR_BTF when set for a task while preserving any other
DEBUGCTLMSR bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/processor.h   |    4 ++--
 arch/x86/include/asm/thread_info.h |    4 +++-
 arch/x86/kernel/kprobes.c          |   14 ++++++++++++--
 arch/x86/kernel/process.c          |   11 +++++++++++
 arch/x86/kernel/step.c             |   24 ++++++++++++++++++++----
 arch/x86/kernel/traps.c            |    5 +++++
 6 files changed, 53 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -798,7 +798,7 @@ extern void cpu_init(void);
 
 static inline unsigned long get_debugctlmsr(void)
 {
-    unsigned long debugctlmsr = 0;
+	unsigned long debugctlmsr = 0;
 
 #ifndef CONFIG_X86_DEBUGCTLMSR
 	if (boot_cpu_data.x86 < 6)
@@ -806,7 +806,7 @@ static inline unsigned long get_debugctl
 #endif
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 
-    return debugctlmsr;
+	return debugctlmsr;
 }
 
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
Index: linux-2.6/arch/x86/include/asm/thread_info.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/thread_info.h
+++ linux-2.6/arch/x86/include/asm/thread_info.h
@@ -92,6 +92,7 @@ struct thread_info {
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
+#define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
 #define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
 #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
 
@@ -113,6 +114,7 @@ struct thread_info {
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
+#define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
 #define _TIF_LAZY_MMU_UPDATES	(1 << TIF_LAZY_MMU_UPDATES)
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 
@@ -143,7 +145,7 @@ struct thread_info {
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_NOTSC)
+	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP)
 
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW|_TIF_DEBUG)
Index: linux-2.6/arch/x86/kernel/kprobes.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kprobes.c
+++ linux-2.6/arch/x86/kernel/kprobes.c
@@ -422,12 +422,22 @@ static void __kprobes set_current_kprobe
 
 static void __kprobes clear_btf(void)
 {
-	/* XXX */
+	if (test_thread_flag(TIF_BLOCKSTEP)) {
+		unsigned long debugctl = get_debugctlmsr();
+
+		debugctl &= ~DEBUGCTLMSR_BTF;
+		update_debugctlmsr(debugctl);
+	}
 }
 
 static void __kprobes restore_btf(void)
 {
-	/* XXX */
+	if (test_thread_flag(TIF_BLOCKSTEP)) {
+		unsigned long debugctl = get_debugctlmsr();
+
+		debugctl |= DEBUGCTLMSR_BTF;
+		update_debugctlmsr(debugctl);
+	}
 }
 
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -195,6 +195,17 @@ void __switch_to_xtra(struct task_struct
 	prev = &prev_p->thread;
 	next = &next_p->thread;
 
+	if (test_tsk_thread_flag(prev_p, TIF_BLOCKSTEP) ^
+	    test_tsk_thread_flag(next_p, TIF_BLOCKSTEP)) {
+		unsigned long debugctl = get_debugctlmsr();
+
+		debugctl &= ~DEBUGCTLMSR_BTF;
+		if (test_tsk_thread_flag(next_p, TIF_BLOCKSTEP))
+			debugctl |= DEBUGCTLMSR_BTF;
+
+		update_debugctlmsr(debugctl);
+	}
+
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
Index: linux-2.6/arch/x86/kernel/step.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/step.c
+++ linux-2.6/arch/x86/kernel/step.c
@@ -169,9 +169,19 @@ static void enable_step(struct task_stru
 	 * So noone should try to use debugger block stepping in a program
 	 * that uses user-mode single stepping itself.
 	 */
-	if (!enable_single_step(child))
-		return;
-	/* XXX */
+	if (enable_single_step(child) && block) {
+		unsigned long debugctl = get_debugctlmsr();
+
+		debugctl |= DEBUGCTLMSR_BTF;
+		update_debugctlmsr(debugctl);
+		set_tsk_thread_flag(child, TIF_BLOCKSTEP);
+	} else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
+		unsigned long debugctl = get_debugctlmsr();
+
+		debugctl &= ~DEBUGCTLMSR_BTF;
+		update_debugctlmsr(debugctl);
+		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
+	}
 }
 
 void user_enable_single_step(struct task_struct *child)
@@ -189,7 +199,13 @@ void user_disable_single_step(struct tas
 	/*
 	 * Make sure block stepping (BTF) is disabled.
 	 */
-	/* XXX */
+	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
+		unsigned long debugctl = get_debugctlmsr();
+
+		debugctl &= ~DEBUGCTLMSR_BTF;
+		update_debugctlmsr(debugctl);
+		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
+	}
 
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
Index: linux-2.6/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/traps.c
+++ linux-2.6/arch/x86/kernel/traps.c
@@ -551,6 +551,11 @@ dotraplinkage void __kprobes do_debug(st
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
 
+	/*
+	 * The processor cleared BTF, so don't mark that we need it set.
+	 */
+	clear_tsk_thread_flag(tsk, TIF_BLOCKSTEP);
+
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 

-- 

