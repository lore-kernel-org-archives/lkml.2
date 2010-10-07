Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab0JGRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:09:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50612 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0JGRJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:09:55 -0400
Date: Thu, 07 Oct 2010 18:09:54 +0100
To: linux-m68k@vger.kernel.org
Subject: [PATCH 4/6] m68k: don't lose state if sigframe setup fails
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P3tyc-0007ig-Fv@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we'd failed in setup_frame(), we've no place to store
the original sigmask.  It's not an unrecoverable situation -
we raise SIGSEGV, but that SIGSEGV might be successfully
handled (e.g. on altstack).  In that case we really don't
want sa_mask of original signal permanently slapped on
the set of blocked signals.

Standard solution: have setup_frame()/setup_rt_frame()
report failure and don't mess with the signal-related
state if that has happened...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/kernel/signal.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index a18b251..a6dd614 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -743,7 +743,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 	return (void __user *)((usp - frame_size) & -8UL);
 }
 
-static void setup_frame (int sig, struct k_sigaction *ka,
+static int setup_frame (int sig, struct k_sigaction *ka,
 			 sigset_t *set, struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
@@ -813,14 +813,14 @@ adjust_stack:
 		tregs->pc = regs->pc;
 		tregs->sr = regs->sr;
 	}
-	return;
+	return err;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
 	goto adjust_stack;
 }
 
-static void setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
+static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 			    sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
@@ -901,7 +901,7 @@ adjust_stack:
 		tregs->pc = regs->pc;
 		tregs->sr = regs->sr;
 	}
-	return;
+	return err;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
@@ -963,6 +963,7 @@ static void
 handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
+	int err;
 	/* are we from a system call? */
 	if (regs->orig_d0 >= 0)
 		/* If so, check system call restarting.. */
@@ -970,9 +971,12 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame(sig, ka, info, oldset, regs);
+		err = setup_rt_frame(sig, ka, info, oldset, regs);
 	else
-		setup_frame(sig, ka, oldset, regs);
+		err = setup_frame(sig, ka, oldset, regs);
+
+	if (err)
+		return;
 
 	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
@@ -983,6 +987,8 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 		regs->sr &= ~0x8000;
 		send_sig(SIGTRAP, current, 1);
 	}
+
+	clear_thread_flag(TIF_RESTORE_SIGMASK);
 }
 
 /*
@@ -1008,7 +1014,6 @@ asmlinkage void do_signal(struct pt_regs *regs)
 	if (signr > 0) {
 		/* Whee!  Actually deliver the signal.  */
 		handle_signal(signr, &ka, &info, oldset, regs);
-		clear_thread_flag(TIF_RESTORE_SIGMASK);
 		return;
 	}
 
-- 
1.5.6.5


