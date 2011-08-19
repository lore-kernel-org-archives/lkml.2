Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab1HSQ4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:56:06 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57284 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756389Ab1HSQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:47:33 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH v2 13/43] m68k: Use set_current_blocked() and block_sigmask()
Date: Fri, 19 Aug 2011 17:46:29 +0100
Message-Id: <1313772419-21951-14-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Also, use the new helper function block_sigmask() which centralises
the code for updating current->blocked after successfully delivering a
signal and reduces the amount of duplicate code across
architectures. In the past some architectures got this code wrong, so
using this helper function should stop that from happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
for adding sigmask to current->blocked" so they need to go through the
same tree but this patch would benefit from some maintainer ACK's.

 arch/m68k/kernel/signal_mm.c |   22 +++++++++-------------
 arch/m68k/kernel/signal_no.c |   28 +++++++++-------------------
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/arch/m68k/kernel/signal_mm.c b/arch/m68k/kernel/signal_mm.c
index a0afc23..74ba0cf 100644
--- a/arch/m68k/kernel/signal_mm.c
+++ b/arch/m68k/kernel/signal_mm.c
@@ -97,12 +97,13 @@ int handle_kernel_fault(struct pt_regs *regs)
 asmlinkage int
 sys_sigsuspend(int unused0, int unused1, old_sigset_t mask)
 {
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -465,8 +466,7 @@ asmlinkage int do_sigreturn(unsigned long __unused)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	current->blocked = set;
-	recalc_sigpending();
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->sc, frame + 1))
 		goto badframe;
@@ -491,8 +491,7 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	current->blocked = set;
-	recalc_sigpending();
+	set_current_blocked(&set);
 
 	if (rt_restore_ucontext(regs, sw, &frame->uc))
 		goto badframe;
@@ -965,10 +964,7 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		return;
 
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
+	block_sigmask(ka, sig);
 
 	if (test_thread_flag(TIF_DELAYED_TRACE)) {
 		regs->sr &= ~0x8000;
diff --git a/arch/m68k/kernel/signal_no.c b/arch/m68k/kernel/signal_no.c
index 36a81bb..33e8bf5 100644
--- a/arch/m68k/kernel/signal_no.c
+++ b/arch/m68k/kernel/signal_no.c
@@ -60,12 +60,13 @@ void ret_from_user_rt_signal(void);
 asmlinkage int
 sys_sigsuspend(int unused0, int unused1, old_sigset_t mask)
 {
-	mask &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &= _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -343,10 +344,7 @@ asmlinkage int do_sigreturn(unsigned long __unused)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	
 	if (restore_sigcontext(regs, &frame->sc, frame + 1, &d0))
 		goto badframe;
@@ -372,10 +370,7 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	
 	if (rt_restore_ucontext(regs, sw, &frame->uc, &d0))
 		goto badframe;
@@ -708,12 +703,7 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		return;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	clear_thread_flag(TIF_RESTORE_SIGMASK);
 }
-- 
1.7.4.4

