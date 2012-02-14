Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2BNLrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:47:46 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57776 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760451Ab2BNLnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:43:19 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Jonas Bonn <jonas@southpole.se>, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net
Subject: [PATCH 23/40] OpenRISC: Don't mask signals if we fail to setup signal stack
Date: Tue, 14 Feb 2012 11:40:56 +0000
Message-Id: <1329219673-28711-24-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

setup_rt_frame() needs to return an indication of whether it succeeded
or failed in setting up the signal stack frame. If setup_rt_frame()
fails then we must not modify current->blocked.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux@lists.openrisc.net
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/openrisc/kernel/signal.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index 92d2218..14764e8 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -189,8 +189,8 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
  * trampoline which performs the syscall sigreturn, or a provided
  * user-mode trampoline.
  */
-static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+			  sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
 	unsigned long return_ip;
@@ -247,18 +247,23 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	/* actually move the usp to reflect the stacked frame */
 	regs->sp = (unsigned long)frame;
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
-static inline void
+static inline int
 handle_signal(unsigned long sig,
 	      siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
-	setup_rt_frame(sig, ka, info, oldset, regs);
+	int ret;
+
+	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ret)
+		return ret;
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
@@ -267,6 +272,8 @@ handle_signal(unsigned long sig,
 	recalc_sigpending();
 
 	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
 }
 
 /*
@@ -355,13 +362,13 @@ void do_signal(struct pt_regs *regs)
 			oldset = &current->blocked;
 
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, oldset, regs);
-		/* a signal was successfully delivered; the saved
-		 * sigmask will have been stored in the signal frame,
-		 * and will be restored by sigreturn, so we can simply
-		 * clear the TIF_RESTORE_SIGMASK flag */
-		if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		if (!handle_signal(signr, &info, &ka, oldset, regs)) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag */
 			clear_thread_flag(TIF_RESTORE_SIGMASK);
+		}
 
 		tracehook_signal_handler(signr, &info, &ka, regs,
 					 test_thread_flag(TIF_SINGLESTEP));
-- 
1.7.4.4

