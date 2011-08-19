Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1HSQsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:48:24 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57366 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab1HSQsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:18 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 31/43] sparc: Use set_current_blocked() and block_sigmask()
Date: Fri, 19 Aug 2011 17:46:47 +0100
Message-Id: <1313772419-21951-32-git-send-email-matt@console-pimps.org>
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
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

v2 of this patch depends on "[PATCH 01/43] signal: Add block_sigmask()
for adding sigmask to current->blocked" so they need to go through the
same tree but this patch would benefit from some maintainer ACK's.

 arch/sparc/kernel/signal32.c  |   17 +++--------------
 arch/sparc/kernel/signal_32.c |   28 +++++++++-------------------
 arch/sparc/kernel/signal_64.c |   29 ++++++++++-------------------
 3 files changed, 22 insertions(+), 52 deletions(-)

diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 75fad42..88a3841 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -287,10 +287,7 @@ void do_sigreturn32(struct pt_regs *regs)
 		case 1: set.sig[0] = seta[0] + (((long)seta[1]) << 32);
 	}
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	return;
 
 segv:
@@ -383,10 +380,7 @@ asmlinkage void do_rt_sigreturn32(struct pt_regs *regs)
 		case 1: set.sig[0] = seta.sig[0] + (((long)seta.sig[1]) << 32);
 	}
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	return;
 segv:
 	force_sig(SIGSEGV, current);
@@ -766,12 +760,7 @@ static inline int handle_signal32(unsigned long signr, struct k_sigaction *ka,
 	if (err)
 		return err;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&current->blocked,signr);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, signr);
 
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 5e5c5fd..f6b0fab 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -60,12 +60,13 @@ struct rt_signal_frame {
 
 static int _sigpause_common(old_sigset_t set)
 {
-	set &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, set);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	set &= _BLOCKABLE;
+	siginitset(&blocked, set);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -165,10 +166,7 @@ asmlinkage void do_sigreturn(struct pt_regs *regs)
 		goto segv_and_exit;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	return;
 
 segv_and_exit:
@@ -229,10 +227,7 @@ asmlinkage void do_rt_sigreturn(struct pt_regs *regs)
 	set_fs(old_fs);
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	return;
 segv:
 	force_sig(SIGSEGV, current);
@@ -494,12 +489,7 @@ handle_signal(unsigned long signr, struct k_sigaction *ka,
 	if (err)
 		return err;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&current->blocked, signr);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	block_sigmask(ka, signr);
 
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 006fe45..977e258 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -69,10 +69,7 @@ asmlinkage void sparc64_set_context(struct pt_regs *regs)
 				goto do_sigsegv;
 		}
 		sigdelsetmask(&set, ~_BLOCKABLE);
-		spin_lock_irq(&current->sighand->siglock);
-		current->blocked = set;
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
+		set_current_blocked(&set);
 	}
 	if (test_thread_flag(TIF_32BIT)) {
 		pc &= 0xffffffff;
@@ -241,12 +238,13 @@ struct rt_signal_frame {
 
 static long _sigpause_common(old_sigset_t set)
 {
-	set &= _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask = current->blocked;
-	siginitset(&current->blocked, set);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	set &= _BLOCKABLE;
+	siginitset(&blocked, set);
+	set_current_blocked(&blocked);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
@@ -341,10 +339,7 @@ void do_rt_sigreturn(struct pt_regs *regs)
 	pt_regs_clear_syscall(regs);
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 	return;
 segv:
 	force_sig(SIGSEGV, current);
@@ -504,12 +499,8 @@ static inline int handle_signal(unsigned long signr, struct k_sigaction *ka,
 			     (ka->sa.sa_flags & SA_SIGINFO) ? info : NULL);
 	if (err)
 		return err;
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&current->blocked,signr);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	block_sigmask(ka, signr);
 
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
-- 
1.7.4.4

