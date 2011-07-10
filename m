Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1GJT3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 15:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1GJT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 15:29:37 -0400
Date: Sun, 10 Jul 2011 21:27:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] signals: convert the IA32_EMULATION code to use
	set_current_blocked()
Message-ID: <20110710192724.GA31755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys32_sigsuspend() and sys32_*sigreturn() change ->blocked directly.
This is not correct, see the changelog in e6fa16ab
"signal: sigprocmask() should do retarget_shared_pending()"

Change them to use set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/ia32/ia32_signal.c |   44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

--- ptrace/arch/x86/ia32/ia32_signal.c~3_ia32_set_current_blocked	2011-06-14 16:00:33.000000000 +0200
+++ ptrace/arch/x86/ia32/ia32_signal.c	2011-07-10 21:21:30.000000000 +0200
@@ -127,15 +127,17 @@ int copy_siginfo_from_user32(siginfo_t *
 
 asmlinkage long sys32_sigsuspend(int history0, int history1, old_sigset_t mask)
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
+
 	set_restore_sigmask();
 	return -ERESTARTNOHAND;
 }
@@ -279,10 +281,7 @@ asmlinkage long sys32_sigreturn(struct p
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->sc, &ax))
 		goto badframe;
@@ -308,10 +307,7 @@ asmlinkage long sys32_rt_sigreturn(struc
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;

