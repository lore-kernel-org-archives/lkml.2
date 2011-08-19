Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1HSQxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:53:41 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57345 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508Ab1HSQsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:48:00 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 26/43] [S390]: Use block_sigmask()
Date: Fri, 19 Aug 2011 17:46:42 +0100
Message-Id: <1313772419-21951-27-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Use the new helper function block_sigmask() which centralises the code
for updating current->blocked after successfully delivering a signal
and reduces the amount of duplicate code across architectures.

In the past some architectures got this code wrong, so using this
helper function should stop that from happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---

This patch depends on "[PATCH 01/43] signal: Add block_sigmask() for
adding sigmask to current->blocked" so they need to go through the
same tree but this patch would benefit from some maintainer ACK's.

 arch/s390/kernel/compat_signal.c |    6 +-----
 arch/s390/kernel/signal.c        |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index a9a285b..e78415c 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -592,7 +592,6 @@ give_sigsegv:
 int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Set up the stack frame */
@@ -602,10 +601,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 		ret = setup_frame32(sig, ka, oldset, regs);
 	if (ret)
 		return ret;
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 	return 0;
 }
 
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 9a40e1c..3564636 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -373,7 +373,6 @@ static int handle_signal(unsigned long sig, struct k_sigaction *ka,
 			 siginfo_t *info, sigset_t *oldset,
 			 struct pt_regs *regs)
 {
-	sigset_t blocked;
 	int ret;
 
 	/* Set up the stack frame */
@@ -383,10 +382,7 @@ static int handle_signal(unsigned long sig, struct k_sigaction *ka,
 		ret = setup_frame(sig, ka, oldset, regs);
 	if (ret)
 		return ret;
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 	return 0;
 }
 
-- 
1.7.4.4

