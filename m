Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633Ab2BNLoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:44:44 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57886 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760510Ab2BNLoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:44:04 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH 39/40] xtensa: Don't mask signals if we fail to setup signal stack
Date: Tue, 14 Feb 2012 11:41:12 +0000
Message-Id: <1329219673-28711-40-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

setup_frame() needs to return an indication of whether it succeeded or
failed in setting up the signal stack frame. If setup_frame() fails
then we must not modify current->blocked.

Acked-by: Oleg Nesterov <oleg@redhat.com>
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

