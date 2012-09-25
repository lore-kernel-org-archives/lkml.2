Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2IYMv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:51:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60289 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab2IYMv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:51:27 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] x86: Unspaghettize do_trap()
Date: Tue, 25 Sep 2012 14:51:19 +0200
Message-Id: <1348577479-2564-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the label maze in this function. Having a
seperate function to first handle the traps that don't
generate a signal makes it easier to convert into
more readable conditional paths.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/traps.c |   58 ++++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b481341..1a8dd87 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -107,30 +107,45 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
-static void __kprobes
-do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
-	long error_code, siginfo_t *info)
+static int __kprobes
+do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
+		  struct pt_regs *regs,	long error_code)
 {
-	struct task_struct *tsk = current;
-
 #ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK) {
 		/*
 		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
 		 * On nmi (interrupt 2), do_trap should not be called.
 		 */
-		if (trapnr < X86_TRAP_UD)
-			goto vm86_trap;
-		goto trap_signal;
+		if (trapnr < X86_TRAP_UD) {
+			if (!handle_vm86_trap((struct kernel_vm86_regs *) regs,
+						error_code, trapnr))
+				return 0;
+		}
+		return -1
 	}
 #endif
+	if (!user_mode(regs)) {
+		if (!fixup_exception(regs)) {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_nr = trapnr;
+			die(str, regs, error_code);
+		}
+		return 0;
+	}
 
-	if (!user_mode(regs))
-		goto kernel_trap;
+	return -1;
+}
 
-#ifdef CONFIG_X86_32
-trap_signal:
-#endif
+static void __kprobes
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
+	long error_code, siginfo_t *info)
+{
+	struct task_struct *tsk = current;
+
+
+	if (!do_trap_no_signal(tsk, trapnr, str, regs, error_code))
+		return;
 	/*
 	 * We want error_code and trap_nr set for userspace faults and
 	 * kernelspace faults which result in die(), but not
@@ -158,23 +173,6 @@ trap_signal:
 		force_sig_info(signr, info, tsk);
 	else
 		force_sig(signr, tsk);
-	return;
-
-kernel_trap:
-	if (!fixup_exception(regs)) {
-		tsk->thread.error_code = error_code;
-		tsk->thread.trap_nr = trapnr;
-		die(str, regs, error_code);
-	}
-	return;
-
-#ifdef CONFIG_X86_32
-vm86_trap:
-	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
-						error_code, trapnr))
-		goto trap_signal;
-	return;
-#endif
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
-- 
1.7.5.4

