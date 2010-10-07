Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0JGRJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:09:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50607 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab0JGRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:09:45 -0400
Date: Thu, 07 Oct 2010 18:09:44 +0100
To: linux-m68k@vger.kernel.org
Subject: [PATCH 3/6] m68k: simplify the singlestepping handling in signals
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P3tyS-0007iC-FW@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of checking the return value of do_signal() we can just do
the work (raise SIGTRAP and clear SR.T1) directly in handle_signal(),
when setting the sigframe up.  Simplifies the assembler glue and is
closer to the way we do it on other targets.

Note that do_delayed_trace does *not* disappear; it's still needed
to deal with single-stepping through syscall, since 68040 doesn't
raise the trace exception at all if the trap exception is pending.
We hit it after returning from sys_...() if TIF_DELAYED_TRACE is
set; all that has changed is that we don't reuse it for "single-step
into the handler" codepath.

As the result, do_signal() doesn't need to return anything anymore.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/kernel/entry.S  |    6 +-----
 arch/m68k/kernel/signal.c |   11 +++++++----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 3a15a03..4e49f57 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -178,11 +178,7 @@ do_signal_return:
 	addql	#4,%sp
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
-	tstl	%d0
-	jeq	resume_userspace
-	| when single stepping into handler stop at the first insn
-	btst	#6,%curptr@(TASK_INFO+TINFO_FLAGS+2)
-	jeq	resume_userspace
+	jbra	resume_userspace
 
 do_delayed_trace:
 	bclr	#7,%sp@(PT_OFF_SR)	| clear trace bit in SR
diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index fa8200d..a18b251 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -978,6 +978,11 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&current->blocked,sig);
 	recalc_sigpending();
+
+	if (test_thread_flag(TIF_DELAYED_TRACE)) {
+		regs->sr &= ~0x8000;
+		send_sig(SIGTRAP, current, 1);
+	}
 }
 
 /*
@@ -985,7 +990,7 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-asmlinkage int do_signal(struct pt_regs *regs)
+asmlinkage void do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	struct k_sigaction ka;
@@ -1004,7 +1009,7 @@ asmlinkage int do_signal(struct pt_regs *regs)
 		/* Whee!  Actually deliver the signal.  */
 		handle_signal(signr, &ka, &info, oldset, regs);
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
-		return 1;
+		return;
 	}
 
 	/* Did we come from a system call? */
@@ -1017,6 +1022,4 @@ asmlinkage int do_signal(struct pt_regs *regs)
 		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
-
-	return 0;
 }
-- 
1.5.6.5


