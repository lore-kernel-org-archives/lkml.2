Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0JGRKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:10:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50614 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0JGRKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:10:05 -0400
Date: Thu, 07 Oct 2010 18:10:04 +0100
To: linux-m68k@vger.kernel.org
Subject: [PATCH 5/6] m68k: if we fail to set sigframe up, just leave regs
 alone...
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P3tym-0007jo-GR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Same principle as with the previous patch - do not destroy the
state if sigframe setup fails.  Incidentally, it's actually
_less_ work - we don't need to go through adjust_stack dance
on failure if we don't touch regs->stkadj until we know we'd
written sigframe out.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/kernel/signal.c |   44 ++++++++++++++++++++++++++++++--------------
 1 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index a6dd614..16ea319 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -761,10 +761,8 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 
 	frame = get_sigframe(ka, regs, sizeof(*frame) + fsize);
 
-	if (fsize) {
+	if (fsize)
 		err |= copy_to_user (frame + 1, regs + 1, fsize);
-		regs->stkadj = fsize;
-	}
 
 	err |= __put_user((current_thread_info()->exec_domain
 			   && current_thread_info()->exec_domain->signal_invmap
@@ -794,11 +792,21 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 
 	push_cache ((unsigned long) &frame->retcode);
 
-	/* Set up registers for signal handler */
+	/*
+	 * Set up registers for signal handler.  All the state we are about
+	 * to destroy is successfully copied to sigframe.
+	 */
 	wrusp ((unsigned long) frame);
 	regs->pc = (unsigned long) ka->sa.sa_handler;
 
-adjust_stack:
+	/*
+	 * This is subtle; if we build more than one sigframe, all but the
+	 * first one will see frame format 0 and have fsize == 0, so we won't
+	 * screw stkadj.
+	 */
+	if (fsize)
+		regs->stkadj = fsize;
+
 	/* Prepare to skip over the extra stuff in the exception frame.  */
 	if (regs->stkadj) {
 		struct pt_regs *tregs =
@@ -813,11 +821,11 @@ adjust_stack:
 		tregs->pc = regs->pc;
 		tregs->sr = regs->sr;
 	}
-	return err;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
-	goto adjust_stack;
+	return err;
 }
 
 static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -837,10 +845,8 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	frame = get_sigframe(ka, regs, sizeof(*frame));
 
-	if (fsize) {
+	if (fsize)
 		err |= copy_to_user (&frame->uc.uc_extra, regs + 1, fsize);
-		regs->stkadj = fsize;
-	}
 
 	err |= __put_user((current_thread_info()->exec_domain
 			   && current_thread_info()->exec_domain->signal_invmap
@@ -882,11 +888,21 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	push_cache ((unsigned long) &frame->retcode);
 
-	/* Set up registers for signal handler */
+	/*
+	 * Set up registers for signal handler.  All the state we are about
+	 * to destroy is successfully copied to sigframe.
+	 */
 	wrusp ((unsigned long) frame);
 	regs->pc = (unsigned long) ka->sa.sa_handler;
 
-adjust_stack:
+	/*
+	 * This is subtle; if we build more than one sigframe, all but the
+	 * first one will see frame format 0 and have fsize == 0, so we won't
+	 * screw stkadj.
+	 */
+	if (fsize)
+		regs->stkadj = fsize;
+
 	/* Prepare to skip over the extra stuff in the exception frame.  */
 	if (regs->stkadj) {
 		struct pt_regs *tregs =
@@ -901,11 +917,11 @@ adjust_stack:
 		tregs->pc = regs->pc;
 		tregs->sr = regs->sr;
 	}
-	return err;
+	return 0;
 
 give_sigsegv:
 	force_sigsegv(sig, current);
-	goto adjust_stack;
+	return err;
 }
 
 static inline void
-- 
1.5.6.5


