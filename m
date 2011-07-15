Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab1GOFra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:47:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:49878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964790Ab1GOFr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:47:29 -0400
Date: Fri, 15 Jul 2011 05:47:24 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-9b429620740945363b746414e8b9a84b8119914c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, oleg@redhat.com, hpa@linux.intel.com
In-Reply-To: <20110710182203.GA27979@redhat.com>
References: <20110710182203.GA27979@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/signal] x86, do_signal: Simplify the TS_RESTORE_SIGMASK logic
Git-Commit-ID: 9b429620740945363b746414e8b9a84b8119914c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jul 2011 05:47:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b429620740945363b746414e8b9a84b8119914c
Gitweb:     http://git.kernel.org/tip/9b429620740945363b746414e8b9a84b8119914c
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 10 Jul 2011 20:22:03 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 21:22:11 -0700

x86, do_signal: Simplify the TS_RESTORE_SIGMASK logic

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
Link: http://lkml.kernel.org/r/20110710182203.GA27979@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/signal.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index bf9345d..8c55f97 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -651,11 +651,15 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 
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
@@ -670,12 +674,13 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
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
@@ -710,7 +715,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	    likely(test_and_clear_thread_flag(TIF_FORCED_TF)))
 		regs->flags &= ~X86_EFLAGS_TF;
 
-	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	ret = setup_rt_frame(sig, ka, info, regs);
 
 	if (ret)
 		return ret;
@@ -765,7 +770,6 @@ static void do_signal(struct pt_regs *regs)
 	struct k_sigaction ka;
 	siginfo_t info;
 	int signr;
-	sigset_t *oldset;
 
 	/*
 	 * We want the common case to go fast, which is why we may in certain
@@ -777,23 +781,10 @@ static void do_signal(struct pt_regs *regs)
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
 
@@ -821,7 +812,7 @@ static void do_signal(struct pt_regs *regs)
 	 */
 	if (current_thread_info()->status & TS_RESTORE_SIGMASK) {
 		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+		set_current_blocked(&current->saved_sigmask);
 	}
 }
 
