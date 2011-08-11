Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1HKODx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:03:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60079 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab1HKN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:57:47 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 14/41] microblaze: Fix signal masking
Date: Thu, 11 Aug 2011 14:56:48 +0100
Message-Id: <1313071035-12047-15-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

There are a couple of problems with the current signal code,

1. If we failed to setup the signal stack frame then we
should not be masking any signals.

2. ka->sa.sa_mask is only added to the current blocked signals list if
SA_NODEFER is set in ka->sa.sa_flags. If we successfully setup the
signal frame and are going to run the handler then we must honour
sa_mask.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/microblaze/kernel/signal.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 9e749c0..f2c13d5 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -169,7 +169,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8UL);
 }
 
-static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
@@ -267,10 +267,11 @@ static void setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		current->comm, current->pid, frame, regs->pc);
 #endif
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 /* Handle restarting system calls */
@@ -314,21 +315,25 @@ static int
 handle_signal(unsigned long sig, struct k_sigaction *ka,
 		siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
+	int ret;
+
 	/* Set up the stack frame */
 	if (ka->sa.sa_flags & SA_SIGINFO)
-		setup_rt_frame(sig, ka, info, oldset, regs);
+		ret = setup_rt_frame(sig, ka, info, oldset, regs);
 	else
-		setup_rt_frame(sig, ka, NULL, oldset, regs);
+		ret = setup_rt_frame(sig, ka, NULL, oldset, regs);
+
+	if (ret)
+		return ret;
 
-	if (!(ka->sa.sa_flags & SA_NODEFER)) {
-		spin_lock_irq(&current->sighand->siglock);
-		sigorsets(&current->blocked,
-				&current->blocked, &ka->sa.sa_mask);
+	spin_lock_irq(&current->sighand->siglock);
+	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&current->blocked, sig);
-		recalc_sigpending();
-		spin_unlock_irq(&current->sighand->siglock);
-	}
-	return 1;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	return 0;
 }
 
 /*
@@ -369,7 +374,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset, int in_syscall)
 		/* Whee! Actually deliver the signal. */
 		if (in_syscall)
 			handle_restart(regs, &ka, 1);
-		if (handle_signal(signr, &ka, &info, oldset, regs)) {
+		if (!handle_signal(signr, &ka, &info, oldset, regs)) {
 			/*
 			 * A signal was successfully delivered; the saved
 			 * sigmask will have been stored in the signal frame,
-- 
1.7.4.4

