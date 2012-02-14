Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460Ab2BNLmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:42:47 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57735 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760433Ab2BNLmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:42:45 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org
Subject: [PATCH 19/40] MIPS: Use set_current_blocked() and block_sigmask()
Date: Tue, 14 Feb 2012 11:40:52 +0000
Message-Id: <1329219673-28711-20-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

As described in e6fa16ab ("signal: sigprocmask() should do
retarget_shared_pending()") the modification of current->blocked is
incorrect as we need to check whether the signal we're about to block
is pending in the shared queue.

Also, use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate
code across architectures. In the past some architectures got this
code wrong, so using this helper function should stop that from
happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/mips/kernel/signal.c     |   27 +++++----------------------
 arch/mips/kernel/signal32.c   |   20 ++++----------------
 arch/mips/kernel/signal_n32.c |   10 ++--------
 3 files changed, 11 insertions(+), 46 deletions(-)

diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index f852400..76084cc 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -256,11 +256,8 @@ asmlinkage int sys_sigsuspend(nabi_no_regargs struct pt_regs regs)
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -285,11 +282,8 @@ asmlinkage int sys_rt_sigsuspend(nabi_no_regargs struct pt_regs regs)
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -361,10 +355,7 @@ asmlinkage void sys_sigreturn(nabi_no_regargs struct pt_regs regs)
 		goto badframe;
 
 	sigdelsetmask(&blocked, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = blocked;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&blocked);
 
 	sig = restore_sigcontext(&regs, &frame->sf_sc);
 	if (sig < 0)
@@ -400,10 +391,7 @@ asmlinkage void sys_rt_sigreturn(nabi_no_regargs struct pt_regs regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext(&regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
@@ -579,12 +567,7 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 	if (ret)
 		return ret;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, sig);
 
 	return ret;
 }
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index aae9866..902a889 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -290,11 +290,8 @@ asmlinkage int sys32_sigsuspend(nabi_no_regargs struct pt_regs regs)
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -318,11 +315,8 @@ asmlinkage int sys32_rt_sigsuspend(nabi_no_regargs struct pt_regs regs)
 		return -EFAULT;
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -488,10 +482,7 @@ asmlinkage void sys32_sigreturn(nabi_no_regargs struct pt_regs regs)
 		goto badframe;
 
 	sigdelsetmask(&blocked, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = blocked;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&blocked);
 
 	sig = restore_sigcontext32(&regs, &frame->sf_sc);
 	if (sig < 0)
@@ -529,10 +520,7 @@ asmlinkage void sys32_rt_sigreturn(nabi_no_regargs struct pt_regs regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext32(&regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
diff --git a/arch/mips/kernel/signal_n32.c b/arch/mips/kernel/signal_n32.c
index ee24d81..30fc7ff 100644
--- a/arch/mips/kernel/signal_n32.c
+++ b/arch/mips/kernel/signal_n32.c
@@ -94,11 +94,8 @@ asmlinkage int sysn32_rt_sigsuspend(nabi_no_regargs struct pt_regs regs)
 	sigset_from_compat(&newset, &uset);
 	sigdelsetmask(&newset, ~_BLOCKABLE);
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -122,10 +119,7 @@ asmlinkage void sysn32_rt_sigreturn(nabi_no_regargs struct pt_regs regs)
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	sig = restore_sigcontext(&regs, &frame->rs_uc.uc_mcontext);
 	if (sig < 0)
-- 
1.7.4.4

