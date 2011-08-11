Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1HKN5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:57:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60066 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab1HKN5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:39 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH 11/41] m68k: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:56:45 +0100
Message-Id: <1313071035-12047-12-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/m68k/kernel/signal_mm.c |   24 ++++++++++++------------
 arch/m68k/kernel/signal_no.c |   30 ++++++++++++------------------
 2 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/arch/m68k/kernel/signal_mm.c b/arch/m68k/kernel/signal_mm.c
index a0afc23..eeeaf3c 100644
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
@@ -950,6 +949,7 @@ static void
 handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
 	int err;
 	/* are we from a system call? */
 	if (regs->orig_d0 >= 0)
@@ -965,10 +965,10 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		return;
 
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 
 	if (test_thread_flag(TIF_DELAYED_TRACE)) {
 		regs->sr &= ~0x8000;
diff --git a/arch/m68k/kernel/signal_no.c b/arch/m68k/kernel/signal_no.c
index 36a81bb..97f3c39 100644
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
@@ -693,6 +688,7 @@ static void
 handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
 	int err;
 	/* are we from a system call? */
 	if (regs->orig_d0 >= 0)
@@ -708,12 +704,10 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		return;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	set_current_blocked(&blocked);
 
 	clear_thread_flag(TIF_RESTORE_SIGMASK);
 }
-- 
1.7.4.4

