Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1HKN6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:58:18 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60161 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab1HKN6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:15 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 30/41] um: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:57:04 +0100
Message-Id: <1313071035-12047-31-git-send-email-matt@console-pimps.org>
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
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/um/kernel/signal.c     |   22 +++++++++++-----------
 arch/um/sys-i386/signal.c   |   12 ++----------
 arch/um/sys-x86_64/signal.c |    6 +-----
 3 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index b5c094c..1812524 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -73,13 +73,12 @@ static int handle_signal(struct pt_regs *regs, unsigned long signr,
 		spin_unlock_irq(&current->sighand->siglock);
 		force_sigsegv(signr, current);
 	} else {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked, &current->blocked,
-			  &ka->sa.sa_mask);
+		sigset_t blocked:
+
+		sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 		if (!(ka->sa.sa_flags & SA_NODEFER))
-			sigaddset(&current->blocked, signr);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+			sigaddset(&blocked, signr);
+		set_current_blocked(&blocked);
 	}
 
 	return err;
@@ -163,12 +162,13 @@ int do_signal(void)
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

