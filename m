Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1HKOB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:01:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60153 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536Ab1HKN6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:12 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 28/41] sparc: Use set_current_blocked()
Date: Thu, 11 Aug 2011 14:57:02 +0100
Message-Id: <1313071035-12047-29-git-send-email-matt@console-pimps.org>
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
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/sparc/kernel/signal32.c  |   19 ++++++-------------
 arch/sparc/kernel/signal_32.c |   30 ++++++++++++------------------
 arch/sparc/kernel/signal_64.c |   30 ++++++++++++------------------
 3 files changed, 30 insertions(+), 49 deletions(-)

diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 75fad42..4f381ce 100644
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
@@ -756,6 +750,7 @@ static inline int handle_signal32(unsigned long signr, struct k_sigaction *ka,
 				  siginfo_t *info,
 				  sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
 	int err;
 
 	if (ka->sa.sa_flags & SA_SIGINFO)
@@ -766,12 +761,10 @@ static inline int handle_signal32(unsigned long signr, struct k_sigaction *ka,
 	if (err)
 		return err;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&current->blocked,signr);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, signr);
+	set_current_blocked(&blocked);
 
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index 5e5c5fd..d65c31d 100644
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
@@ -484,6 +479,7 @@ static inline int
 handle_signal(unsigned long signr, struct k_sigaction *ka,
 	      siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
 	int err;
 
 	if (ka->sa.sa_flags & SA_SIGINFO)
@@ -494,12 +490,10 @@ handle_signal(unsigned long signr, struct k_sigaction *ka,
 	if (err)
 		return err;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&current->blocked, signr);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, signr);
+	set_current_blocked(&blocked);
 
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index 006fe45..bb153d1 100644
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
+	set_current_blocked(&set);
 
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
@@ -498,18 +493,17 @@ static inline int handle_signal(unsigned long signr, struct k_sigaction *ka,
 				siginfo_t *info,
 				sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
 	int err;
 
 	err = setup_rt_frame(ka, regs, signr, oldset,
 			     (ka->sa.sa_flags & SA_SIGINFO) ? info : NULL);
 	if (err)
 		return err;
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
+	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NOMASK))
-		sigaddset(&current->blocked,signr);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, signr);
+	set_current_blocked(&blocked);
 
 	tracehook_signal_handler(signr, info, ka, regs, 0);
 
-- 
1.7.4.4

