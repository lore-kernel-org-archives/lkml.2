Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab0CUNB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:01:29 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:44345 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0CUNBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A4SLwsWe41lPqYuf9+pcZC3jlwK71ZzC0EnTQRhOQsgNVSYM3RpLmxVNcjkIETPAU9
         QVEtKVlIPF80Yj8RT+mmKA4hzIACc236FRALTfULsZvhmeLrjUutjjBNcbO4Bc2AudB8
         yngyKFKR5pVtkLmwSFcG86qteD9bLxH2qd0uU=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86: Merge kernel_math_error() into math_error()
Date: Sun, 21 Mar 2010 09:00:45 -0400
Message-Id: <1269176446-2489-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
References: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the kernel exception handling and make it more similar to
the other traps.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/traps.c |   44 ++++++++++++++++----------------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 495dd5d..d53a443 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -573,20 +573,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
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
@@ -594,14 +580,28 @@ static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
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
@@ -662,14 +662,8 @@ void math_error(struct pt_regs *regs, int error_code, int trapnr)
 
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
@@ -678,14 +672,8 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
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
-- 
1.6.6.1

