Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0ECVWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:22:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:39882 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab0ECVWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:22:34 -0400
Date: Mon, 3 May 2010 21:22:19 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1269176446-2489-4-git-send-email-brgerst@gmail.com>
References: <1269176446-2489-4-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Merge kernel_math_error() into math_error()
Message-ID: <tip-e2e75c915de045f0785387dc32f55e92fab0614c@git.kernel.org>
Git-Commit-ID: e2e75c915de045f0785387dc32f55e92fab0614c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 21:22:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2e75c915de045f0785387dc32f55e92fab0614c
Gitweb:     http://git.kernel.org/tip/e2e75c915de045f0785387dc32f55e92fab0614c
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Sun, 21 Mar 2010 09:00:45 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 3 May 2010 13:39:31 -0700

x86: Merge kernel_math_error() into math_error()

Clean up the kernel exception handling and make it more similar to
the other traps.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1269176446-2489-4-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/traps.c |   44 ++++++++++++++++----------------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a472992..53ba86f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -576,20 +576,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	return;
 }
 
-#ifdef CONFIG_X86_64
-static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
-{
-	if (fixup_exception(regs))
-		return 1;
-
-	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
-	/* Illegal floating point operation in the kernel */
-	current->thread.trap_no = trapnr;
-	die(str, regs, 0);
-	return 0;
-}
-#endif
-
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
@@ -597,14 +583,28 @@ static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
  */
 void math_error(struct pt_regs *regs, int error_code, int trapnr)
 {
-	struct task_struct *task;
+	struct task_struct *task = current;
 	siginfo_t info;
 	unsigned short err;
+	char *str = (trapnr == 16) ? "fpu exception" : "simd exception";
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, SIGFPE) == NOTIFY_STOP)
+		return;
+	conditional_sti(regs);
+
+	if (!user_mode_vm(regs))
+	{
+		if (!fixup_exception(regs)) {
+			task->thread.error_code = error_code;
+			task->thread.trap_no = trapnr;
+			die(str, regs, error_code);
+		}
+		return;
+	}
 
 	/*
 	 * Save the info for the exception handler and clear the error.
 	 */
-	task = current;
 	save_init_fpu(task);
 	task->thread.trap_no = trapnr;
 	task->thread.error_code = error_code;
@@ -665,14 +665,8 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	conditional_sti(regs);
-
 #ifdef CONFIG_X86_32
 	ignore_fpu_irq = 1;
-#else
-	if (!user_mode(regs) &&
-	    kernel_math_error(regs, "kernel x87 math error", 16))
-		return;
 #endif
 
 	math_error(regs, error_code, 16);
@@ -681,14 +675,8 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
-	conditional_sti(regs);
-
 #ifdef CONFIG_X86_32
 	ignore_fpu_irq = 1;
-#else
-	if (!user_mode(regs) &&
-			kernel_math_error(regs, "kernel simd math error", 19))
-		return;
 #endif
 
 	math_error(regs, error_code, 19);
