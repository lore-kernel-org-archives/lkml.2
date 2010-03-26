Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0CZM7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:59:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:57730 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab0CZM7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:59:34 -0400
Date: Fri, 26 Mar 2010 12:58:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100325135414.017536066@chello.nl>
References: <20100325135414.017536066@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, ptrace: Fix block-step
Message-ID: <tip-ea8e61b7bbc4a2faef77db34eb2db2a2c2372ff6@git.kernel.org>
Git-Commit-ID: ea8e61b7bbc4a2faef77db34eb2db2a2c2372ff6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Mar 2010 12:58:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea8e61b7bbc4a2faef77db34eb2db2a2c2372ff6
Gitweb:     http://git.kernel.org/tip/ea8e61b7bbc4a2faef77db34eb2db2a2c2372ff6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 25 Mar 2010 14:51:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Mar 2010 11:33:57 +0100

x86, ptrace: Fix block-step

Implement ptrace-block-step using TIF_BLOCKSTEP which will set
DEBUGCTLMSR_BTF when set for a task while preserving any other
DEBUGCTLMSR bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100325135414.017536066@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/processor.h   |    4 ++--
 arch/x86/include/asm/thread_info.h |    4 +++-
 arch/x86/kernel/kprobes.c          |   14 ++++++++++++--
 arch/x86/kernel/process.c          |   11 +++++++++++
 arch/x86/kernel/step.c             |   24 ++++++++++++++++++++----
 arch/x86/kernel/traps.c            |    5 +++++
 6 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 5bec21a..32428b4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -799,7 +799,7 @@ extern void cpu_init(void);
 
 static inline unsigned long get_debugctlmsr(void)
 {
-    unsigned long debugctlmsr = 0;
+	unsigned long debugctlmsr = 0;
 
 #ifndef CONFIG_X86_DEBUGCTLMSR
 	if (boot_cpu_data.x86 < 6)
@@ -807,7 +807,7 @@ static inline unsigned long get_debugctlmsr(void)
 #endif
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 
-    return debugctlmsr;
+	return debugctlmsr;
 }
 
 static inline void update_debugctlmsr(unsigned long debugctlmsr)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index dc85e12..d017ed5 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
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
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7a880ad..f2f56c0 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -422,12 +422,22 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 
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
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1a60beb..8328009 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -195,6 +195,17 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
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
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 7beba07..58de45e 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -169,9 +169,19 @@ static void enable_step(struct task_struct *child, bool block)
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
@@ -189,7 +199,13 @@ void user_disable_single_step(struct task_struct *child)
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
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index e3da5d7..36f1bd9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -544,6 +544,11 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* DR6 may or may not be cleared by the CPU */
 	set_debugreg(0, 6);
 
+	/*
+	 * The processor cleared BTF, so don't mark that we need it set.
+	 */
+	clear_tsk_thread_flag(tsk, TIF_BLOCKSTEP);
+
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
