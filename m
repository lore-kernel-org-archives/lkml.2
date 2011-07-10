Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab1GJSY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:24:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab1GJSY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:24:57 -0400
Date: Sun, 10 Jul 2011 20:22:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: do_signal: simplify the TS_RESTORE_SIGMASK logic
Message-ID: <20110710182203.GA27979@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. do_signal() looks at TS_RESTORE_SIGMASK and calculates the
   mask which should be stored in the signal frame, then it
   passes "oldset" to the callees, down to setup_rt_frame().

   This is ugly, setup_rt_frame() can do this itself and nobody
   else needs this sigset_t. Move this code into setup_rt_frame.

2. do_signal() also clears TS_RESTORE_SIGMASK if handle_signal()
   succeeds.

   We can move this to setup_rt_frame() as well, this avoids the
   unnecessary checks and makes the logic more clear.

3. use set_current_blocked() instead of sigprocmask(SIG_SETMASK),
   sigprocmask() should be avoided.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/signal.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- ptrace/arch/x86/kernel/signal.c~2_restore_sigmask	2011-07-10 18:06:30.000000000 +0200
+++ ptrace/arch/x86/kernel/signal.c	2011-07-10 19:45:21.000000000 +0200
@@ -653,11 +653,15 @@ int ia32_setup_frame(int sig, struct k_s
 
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+		struct pt_regs *regs)
 {
 	int usig = signr_convert(sig);
+	sigset_t *set = &current->blocked;
 	int ret;
 
+	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
+		set = &current->saved_sigmask;
+
 	/* Set up the stack frame */
 	if (is_ia32) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
@@ -672,12 +676,13 @@ setup_rt_frame(int sig, struct k_sigacti
 		return -EFAULT;
 	}
 
+	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
 	return ret;
 }
 
 static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-	      sigset_t *oldset, struct pt_regs *regs)
+		struct pt_regs *regs)
 {
 	sigset_t blocked;
 	int ret;
@@ -712,7 +717,7 @@ handle_signal(unsigned long sig, siginfo
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	ret = setup_rt_frame(sig, ka, info, regs);
 
 	if (ret)
 		return ret;
@@ -758,7 +763,6 @@ static void do_signal(struct pt_regs *re
 	struct k_sigaction ka;
 	siginfo_t info;
 	int signr;
-	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which is why we may in certain
@@ -770,23 +774,10 @@ static void do_signal(struct pt_regs *re
 	if (!user_mode(regs))
 		return;
 
-	if (current_thread_info()->status & TS_RESTORE_SIGMASK)
-		oldset = &current->saved_sigmask;
-	else
-		oldset = &current->blocked;
-
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 	if (signr > 0) {
 		/* Whee! Actually deliver the signal.  */
-		if (handle_signal(signr, &info, &ka, oldset, regs) == 0) {
-			/*
-			 * A signal was successfully delivered; the saved
-			 * sigmask will have been stored in the signal frame,
-			 * and will be restored by sigreturn, so we can simply
-			 * clear the TS_RESTORE_SIGMASK flag.
-			 */
-			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		}
+		handle_signal(signr, &info, &ka, regs);
 		return;
 	}
 
@@ -814,7 +805,7 @@ static void do_signal(struct pt_regs *re
 	 */
 	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
 		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+		set_current_blocked(&current->saved_sigmask);
 	}
 }
 

