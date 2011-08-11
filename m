Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1HKOAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:00:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60183 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749Ab1HKN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:58:39 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: [PATCH 35/41] xtensa: Don't mask signals if we fail to setup signal stack
Date: Thu, 11 Aug 2011 14:57:09 +0100
Message-Id: <1313071035-12047-36-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

setup_frame() needs to return an indication of whether it succeeded or
failed in setting up the signal stack frame. If setup_frame() fails
then we must not modify current->blocked.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/xtensa/kernel/signal.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 24655e3..17ceab8 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -336,8 +336,8 @@ gen_return_code(unsigned char *codemem)
 }
 
 
-static void setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			sigset_t *set, struct pt_regs *regs)
+static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+		       sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
 	int err = 0;
@@ -422,10 +422,11 @@ static void setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		current->comm, current->pid, signal, frame, regs->pc);
 #endif
 
-	return;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
+	return -EFAULT;
 }
 
 /*
@@ -534,7 +535,9 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 
 		/* Whee!  Actually deliver the signal.  */
 		/* Set up the stack frame */
-		setup_frame(signr, &ka, &info, oldset, regs);
+		ret = setup_frame(signr, &ka, &info, oldset, regs);
+		if (ret)
+			return ret;
 
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked, &current->blocked, &ka.sa.sa_mask);
-- 
1.7.4.4

