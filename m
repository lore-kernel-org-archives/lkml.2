Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2LVFVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:21:34 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47404 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2LVFVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:21:18 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 1/3] arch/tile: Call tracehook_report_syscall_{entry,exit} in syscall trace
Date: Sat, 22 Dec 2012 00:21:10 -0500
Message-Id: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
X-Poly-FromMTA: ([132.207.72.18]) at Sat, 22 Dec 2012 05:21:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call tracehook functions for syscall tracing.

The check for TIF_SYSCALL_TRACE was removed, because the same check is
done right before in the assembly file.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/kernel/intvec_32.S |    6 ++++--
 arch/tile/kernel/intvec_64.S |    6 ++++--
 arch/tile/kernel/ptrace.c    |   30 ++++++++++--------------------
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 6943515..6c3f597 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1201,7 +1201,8 @@ handle_syscall:
 	lw	r30, r31
 	andi    r30, r30, _TIF_SYSCALL_TRACE
 	bzt	r30, .Lrestore_syscall_regs
-	jal	do_syscall_trace
+	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	jal	do_syscall_trace_enter
 	FEEDBACK_REENTER(handle_syscall)
 
 	/*
@@ -1252,7 +1253,8 @@ handle_syscall:
 	lw	r30, r31
 	andi    r30, r30, _TIF_SYSCALL_TRACE
 	bzt     r30, 1f
-	jal	do_syscall_trace
+	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	jal	do_syscall_trace_exit
 	FEEDBACK_REENTER(handle_syscall)
 1:	{
 	 movei  r30, 0               /* not an NMI */
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 7c06d59..a717279 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1006,7 +1006,8 @@ handle_syscall:
 	 addi   r30, r31, THREAD_INFO_STATUS_OFFSET - THREAD_INFO_FLAGS_OFFSET
 	 beqzt	r30, .Lrestore_syscall_regs
 	}
-	jal	do_syscall_trace
+	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	jal	do_syscall_trace_enter
 	FEEDBACK_REENTER(handle_syscall)
 
 	/*
@@ -1075,7 +1076,8 @@ handle_syscall:
 	 andi    r0, r30, _TIF_SINGLESTEP
 	 beqzt   r0, 1f
 	}
-	jal	do_syscall_trace
+	PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
+	jal	do_syscall_trace_exit
 	FEEDBACK_REENTER(handle_syscall)
 	andi    r0, r30, _TIF_SINGLESTEP
 
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 9835312..0ab8b76 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/uaccess.h>
 #include <linux/regset.h>
 #include <linux/elf.h>
+#include <linux/tracehook.h>
 #include <asm/traps.h>
 #include <arch/chip.h>
 
@@ -246,29 +247,18 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 }
 #endif
 
-void do_syscall_trace(void)
+int do_syscall_trace_enter(struct pt_regs *regs)
 {
-	if (!test_thread_flag(TIF_SYSCALL_TRACE))
-		return;
-
-	if (!(current->ptrace & PT_PTRACED))
-		return;
+	if (tracehook_report_syscall_entry(regs)) {
+		regs->regs[TREG_SYSCALL_NR] = -1;
+	}
 
-	/*
-	 * The 0x80 provides a way for the tracing parent to distinguish
-	 * between a syscall stop and SIGTRAP delivery
-	 */
-	ptrace_notify(SIGTRAP|((current->ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
+	return regs->regs[TREG_SYSCALL_NR];
+}
 
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+void do_syscall_trace_exit(struct pt_regs *regs)
+{
+	tracehook_report_syscall_exit(regs, 0);
 }
 
 void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
-- 
1.7.1

