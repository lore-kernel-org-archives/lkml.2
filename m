Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1HSQvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:51:22 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57375 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756492Ab1HSQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:20 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH v2 33/43] um: Use set_current_blocked() and block_sigmask()
Date: Fri, 19 Aug 2011 17:46:49 +0100
Message-Id: <1313772419-21951-34-git-send-email-matt@console-pimps.org>
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
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
for adding sigmask to current->blocked" so they need to go through the
same tree but this patch would benefit from some maintainer ACK's.

Richard, I dropped your Acked-by because I felt this patch changed
quite dramatically since v1 and warrants another review. I hope that's
OK.

 arch/um/kernel/signal.c     |   22 ++++++++--------------
 arch/um/sys-i386/signal.c   |   12 ++----------
 arch/um/sys-x86_64/signal.c |    6 +-----
 3 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index b5c094c..9aa5cba 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -72,15 +72,8 @@ static int handle_signal(struct pt_regs *regs, unsigned long signr,
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
 		force_sigsegv(signr, current);
-	} else {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka->sa.sa_mask);
-		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, signr);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	} else
+		block_sigmask(ka, signr);
 
 	return err;
 }
@@ -163,12 +156,13 @@ int do_signal(void)
  */
 long sys_sigsuspend(int history0, int history1, old_sigset_t mask)
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
diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
index 89a4662..4403b48 100644
--- a/arch/um/sys-i386/signal.c
+++ b/arch/um/sys-i386/signal.c
@@ -458,11 +458,7 @@ long sys_sigreturn(struct pt_regs regs)
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, sc))
 		goto segfault;
@@ -489,11 +485,7 @@ long sys_rt_sigreturn(struct pt_regs regs)
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext))
 		goto segfault;
diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index b6b65c7..581b64d 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -270,11 +270,7 @@ long sys_rt_sigreturn(struct pt_regs *regs)
 		goto segfault;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (copy_sc_from_user(&current->thread.regs, &uc->uc_mcontext,
 			      &frame->fpstate))
-- 
1.7.4.4

