Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0LHAsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:48:04 -0500
Received: from kroah.org ([198.145.64.141]:58604 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340Ab0LHAsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:48:01 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:34 2010
Message-Id: <20101208004434.241292624@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [099/127] sparc: Dont mask signal when we cant setup signal frame.
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit 392c21802ee3aa85cee0e703105f797a8a7b9416 ]

Don't invoke the signal handler tracehook in that situation
either.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/signal32.c  |   55 +++++++++++++++++++++++++-----------------
 arch/sparc/kernel/signal_32.c |   53 +++++++++++++++++++++++++---------------
 arch/sparc/kernel/signal_64.c |   43 +++++++++++++++++++-------------
 3 files changed, 93 insertions(+), 58 deletions(-)

--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -511,8 +511,8 @@ out_irqs_on:
 
 }
 
-static void setup_frame32(struct k_sigaction *ka, struct pt_regs *regs,
-			  int signo, sigset_t *oldset)
+static int setup_frame32(struct k_sigaction *ka, struct pt_regs *regs,
+			 int signo, sigset_t *oldset)
 {
 	struct signal_frame32 __user *sf;
 	int sigframe_size;
@@ -620,13 +620,16 @@ static void setup_frame32(struct k_sigac
 
 sigill:
 	do_exit(SIGILL);
+	return -EINVAL;
+
 sigsegv:
 	force_sigsegv(signo, current);
+	return -EFAULT;
 }
 
-static void setup_rt_frame32(struct k_sigaction *ka, struct pt_regs *regs,
-			     unsigned long signr, sigset_t *oldset,
-			     siginfo_t *info)
+static int setup_rt_frame32(struct k_sigaction *ka, struct pt_regs *regs,
+			    unsigned long signr, sigset_t *oldset,
+			    siginfo_t *info)
 {
 	struct rt_signal_frame32 __user *sf;
 	int sigframe_size;
@@ -738,22 +741,30 @@ static void setup_rt_frame32(struct k_si
 
 		flush_signal_insns(address);
 	}
-	return;
+	return 0;
 
 sigill:
 	do_exit(SIGILL);
+	return -EINVAL;
+
 sigsegv:
 	force_sigsegv(signr, current);
+	return -EFAULT;
 }
 
-static inline void handle_signal32(unsigned long signr, struct k_sigaction *ka,
-				   siginfo_t *info,
-				   sigset_t *oldset, struct pt_regs *regs)
+static inline int handle_signal32(unsigned long signr, struct k_sigaction *ka,
+				  siginfo_t *info,
+				  sigset_t *oldset, struct pt_regs *regs)
 {
+	int err;
+
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame32(ka, regs, signr, oldset, info);
+		err = setup_rt_frame32(ka, regs, signr, oldset, info);
 	else
-		setup_frame32(ka, regs, signr, oldset);
+		err = setup_frame32(ka, regs, signr, oldset);
+
+	if (err)
+		return err;
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
@@ -761,6 +772,10 @@ static inline void handle_signal32(unsig
 		sigaddset(&current->blocked,signr);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
+
+	tracehook_signal_handler(signr, info, ka, regs, 0);
+
+	return 0;
 }
 
 static inline void syscall_restart32(unsigned long orig_i0, struct pt_regs *regs,
@@ -807,16 +822,14 @@ void do_signal32(sigset_t *oldset, struc
 	if (signr > 0) {
 		if (restart_syscall)
 			syscall_restart32(orig_i0, regs, &ka.sa);
-		handle_signal32(signr, &ka, &info, oldset, regs);
-
-		/* A signal was successfully delivered; the saved
-		 * sigmask will have been stored in the signal frame,
-		 * and will be restored by sigreturn, so we can simply
-		 * clear the TS_RESTORE_SIGMASK flag.
-		 */
-		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-
-		tracehook_signal_handler(signr, &info, &ka, regs, 0);
+		if (handle_signal32(signr, &ka, &info, oldset, regs) == 0) {
+			/* A signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TS_RESTORE_SIGMASK flag.
+			 */
+			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
+		}
 		return;
 	}
 	if (restart_syscall &&
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -315,8 +315,8 @@ save_fpu_state(struct pt_regs *regs, __s
 	return err;
 }
 
-static void setup_frame(struct k_sigaction *ka, struct pt_regs *regs,
-			int signo, sigset_t *oldset)
+static int setup_frame(struct k_sigaction *ka, struct pt_regs *regs,
+		       int signo, sigset_t *oldset)
 {
 	struct signal_frame __user *sf;
 	int sigframe_size, err;
@@ -384,16 +384,19 @@ static void setup_frame(struct k_sigacti
 		/* Flush instruction space. */
 		flush_sig_insns(current->mm, (unsigned long) &(sf->insns[0]));
 	}
-	return;
+	return 0;
 
 sigill_and_return:
 	do_exit(SIGILL);
+	return -EINVAL;
+
 sigsegv:
 	force_sigsegv(signo, current);
+	return -EFAULT;
 }
 
-static void setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
-			   int signo, sigset_t *oldset, siginfo_t *info)
+static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
+			  int signo, sigset_t *oldset, siginfo_t *info)
 {
 	struct rt_signal_frame __user *sf;
 	int sigframe_size;
@@ -466,22 +469,30 @@ static void setup_rt_frame(struct k_siga
 		/* Flush instruction space. */
 		flush_sig_insns(current->mm, (unsigned long) &(sf->insns[0]));
 	}
-	return;
+	return 0;
 
 sigill:
 	do_exit(SIGILL);
+	return -EINVAL;
+
 sigsegv:
 	force_sigsegv(signo, current);
+	return -EFAULT;
 }
 
-static inline void
+static inline int
 handle_signal(unsigned long signr, struct k_sigaction *ka,
 	      siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
+	int err;
+
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame(ka, regs, signr, oldset, info);
+		err = setup_rt_frame(ka, regs, signr, oldset, info);
 	else
-		setup_frame(ka, regs, signr, oldset);
+		err = setup_frame(ka, regs, signr, oldset);
+
+	if (err)
+		return err;
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
@@ -489,6 +500,10 @@ handle_signal(unsigned long signr, struc
 		sigaddset(&current->blocked, signr);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
+
+	tracehook_signal_handler(signr, info, ka, regs, 0);
+
+	return 0;
 }
 
 static inline void syscall_restart(unsigned long orig_i0, struct pt_regs *regs,
@@ -546,17 +561,15 @@ static void do_signal(struct pt_regs *re
 	if (signr > 0) {
 		if (restart_syscall)
 			syscall_restart(orig_i0, regs, &ka.sa);
-		handle_signal(signr, &ka, &info, oldset, regs);
-
-		/* a signal was successfully delivered; the saved
-		 * sigmask will have been stored in the signal frame,
-		 * and will be restored by sigreturn, so we can simply
-		 * clear the TIF_RESTORE_SIGMASK flag.
-		 */
-		if (test_thread_flag(TIF_RESTORE_SIGMASK))
-			clear_thread_flag(TIF_RESTORE_SIGMASK);
-
-		tracehook_signal_handler(signr, &info, &ka, regs, 0);
+		if (handle_signal(signr, &ka, &info, oldset, regs) == 0) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag.
+			 */
+			if (test_thread_flag(TIF_RESTORE_SIGMASK))
+				clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
 		return;
 	}
 	if (restart_syscall &&
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -409,7 +409,7 @@ static inline void __user *get_sigframe(
 	return (void __user *) sp;
 }
 
-static inline void
+static inline int
 setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
 	       int signo, sigset_t *oldset, siginfo_t *info)
 {
@@ -483,26 +483,37 @@ setup_rt_frame(struct k_sigaction *ka, s
 	}
 	/* 4. return to kernel instructions */
 	regs->u_regs[UREG_I7] = (unsigned long)ka->ka_restorer;
-	return;
+	return 0;
 
 sigill:
 	do_exit(SIGILL);
+	return -EINVAL;
+
 sigsegv:
 	force_sigsegv(signo, current);
+	return -EFAULT;
 }
 
-static inline void handle_signal(unsigned long signr, struct k_sigaction *ka,
-				 siginfo_t *info,
-				 sigset_t *oldset, struct pt_regs *regs)
+static inline int handle_signal(unsigned long signr, struct k_sigaction *ka,
+				siginfo_t *info,
+				sigset_t *oldset, struct pt_regs *regs)
 {
-	setup_rt_frame(ka, regs, signr, oldset,
-		       (ka->sa.sa_flags & SA_SIGINFO) ? info : NULL);
+	int err;
+
+	err = setup_rt_frame(ka, regs, signr, oldset,
+			     (ka->sa.sa_flags & SA_SIGINFO) ? info : NULL);
+	if (err)
+		return err;
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NOMASK))
 		sigaddset(&current->blocked,signr);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
+
+	tracehook_signal_handler(signr, info, ka, regs, 0);
+
+	return 0;
 }
 
 static inline void syscall_restart(unsigned long orig_i0, struct pt_regs *regs,
@@ -571,16 +582,14 @@ static void do_signal(struct pt_regs *re
 	if (signr > 0) {
 		if (restart_syscall)
 			syscall_restart(orig_i0, regs, &ka.sa);
-		handle_signal(signr, &ka, &info, oldset, regs);
-
-		/* A signal was successfully delivered; the saved
-		 * sigmask will have been stored in the signal frame,
-		 * and will be restored by sigreturn, so we can simply
-		 * clear the TS_RESTORE_SIGMASK flag.
-		 */
-		current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
-
-		tracehook_signal_handler(signr, &info, &ka, regs, 0);
+		if (handle_signal(signr, &ka, &info, oldset, regs) == 0) {
+			/* A signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TS_RESTORE_SIGMASK flag.
+			 */
+			current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
+		}
 		return;
 	}
 	if (restart_syscall &&


