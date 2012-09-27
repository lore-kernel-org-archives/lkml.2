Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2I0GK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:10:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54765 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2I0GKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:10:23 -0400
Date: Wed, 26 Sep 2012 23:10:06 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-c416ddf5b909736f5b57d348f5de159693e699ad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <1348577479-2564-1-git-send-email-fweisbec@gmail.com>
References: <1348577479-2564-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Unspaghettize do_trap()
Git-Commit-ID: c416ddf5b909736f5b57d348f5de159693e699ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:10:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c416ddf5b909736f5b57d348f5de159693e699ad
Gitweb:     http://git.kernel.org/tip/c416ddf5b909736f5b57d348f5de159693e699ad
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 25 Sep 2012 14:51:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 13:36:50 +0200

x86: Unspaghettize do_trap()

Cleanup the label maze in this function. Having a
seperate function to first handle the traps that don't
generate a signal makes it easier to convert into
more readable conditional paths.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1348577479-2564-1-git-send-email-fweisbec@gmail.com
[ Fixed 32-bit build failure. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/traps.c |   60 ++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b481341..6ff7715 100644
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
-		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
+		 * Traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
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
+		return -1;
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
