Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1HSQ5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:57:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57239 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186Ab1HSQrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:47:19 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 03/43] arm: Use set_current_blocked() and block_sigmask()
Date: Fri, 19 Aug 2011 17:46:19 +0100
Message-Id: <1313772419-21951-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check for shared signals we're about to block.

Also, use the new helper function block_sigmask() which centralises
the code for updating current->blocked after successfully delivering a
signal and reduces the amount of duplicate code across
architectures. In the past some architectures got this code wrong, so
using this helper function should stop that from happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Dave Martin <dave.martin@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---

v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
for adding sigmask to current->blocked" so they need to go through the
same tree but this patch would benefit from some maintainer ACK's.

Will, I dropped your Acked-by because I felt this patch changed quite
dramatically since v1 and warrants another review. I hope that's OK.

 arch/arm/kernel/signal.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 0340224..d13e61a 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -66,12 +66,13 @@ const unsigned long syscall_restart_code[2] = {
  */
 asmlinkage int sys_sigsuspend(int restart, unsigned long oldmask, old_sigset_t mask)
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
@@ -281,10 +282,7 @@ static int restore_sigframe(struct pt_regs *regs, struct sigframe __user *sf)
 	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
 	if (err == 0) {
 		sigdelsetmask(&set, ~_BLOCKABLE);
-		spin_lock_irq(&current->sighand->siglock);
-		current->blocked = set;
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		set_current_blocked(&set);
 	}
 
 	__get_user_error(regs->ARM_r0, &sf->uc.uc_mcontext.arm_r0, err);
@@ -637,13 +635,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
 	/*
 	 * Block the signal if we were successful.
 	 */
-	spin_lock_irq(&tsk->sighand->siglock);
-	sigorsets(&tsk->blocked, &tsk->blocked,
-		  &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&tsk->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&tsk->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	return 0;
 }
-- 
1.7.4.4

