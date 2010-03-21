Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0CUNBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:01:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45848 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0CUNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CKfLfelU3ay1rtOj8w9fcQwRY56JNKuUo6s7q0FAHSiRVi/yN1hbhZCybU0KQ6M//b
         8axj0Y3nJmShazXOJK0D/CDFuVoFLBePTLyhuK8rhSp7Al5hjapJSV4j2uC0BPacKxdF
         rqdO+WnaG5xkvDl4XnqkiiypquSmQJ0l91pyk=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: Merge simd_math_error() into math_error()
Date: Sun, 21 Mar 2010 09:00:44 -0400
Message-Id: <1269176446-2489-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
References: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only difference between FPU and SIMD exceptions is where the
status bits are read from (cwd/swd vs. mxcsr).  This also fixes
the discrepency introduced by commit adf77bac, which fixed FPU
but not SIMD.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/traps.h |    2 +-
 arch/x86/kernel/irqinit.c    |    2 +-
 arch/x86/kernel/traps.c      |  100 +++++++++++++----------------------------
 3 files changed, 34 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 4da91ad..f66cda5 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -79,7 +79,7 @@ static inline int get_si_code(unsigned long condition)
 
 extern int panic_on_unrecovered_nmi;
 
-void math_error(void __user *);
+void math_error(struct pt_regs *, int, int);
 void math_emulate(struct math_emu_info *);
 #ifndef CONFIG_X86_32
 asmlinkage void smp_thermal_interrupt(void);
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index d593222..1867351 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -61,7 +61,7 @@ static irqreturn_t math_error_irq(int cpl, void *dev_id)
 	outb(0, 0xF0);
 	if (ignore_fpu_irq || !boot_cpu_data.hard_math)
 		return IRQ_NONE;
-	math_error((void __user *)get_irq_regs()->ip);
+	math_error(get_irq_regs(), 0, 16);
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index bb4a7b3..495dd5d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -592,36 +592,48 @@ static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
  * the correct behaviour even in the presence of the asynchronous
  * IRQ13 behaviour
  */
-void math_error(void __user *ip)
+void math_error(struct pt_regs *regs, int error_code, int trapnr)
 {
 	struct task_struct *task;
 	siginfo_t info;
-	unsigned short cwd, swd, err;
+	unsigned short err;
 
 	/*
 	 * Save the info for the exception handler and clear the error.
 	 */
 	task = current;
 	save_init_fpu(task);
-	task->thread.trap_no = 16;
-	task->thread.error_code = 0;
+	task->thread.trap_no = trapnr;
+	task->thread.error_code = error_code;
 	info.si_signo = SIGFPE;
 	info.si_errno = 0;
-	info.si_addr = ip;
-	/*
-	 * (~cwd & swd) will mask out exceptions that are not set to unmasked
-	 * status.  0x3f is the exception bits in these regs, 0x200 is the
-	 * C1 reg you need in case of a stack fault, 0x040 is the stack
-	 * fault bit.  We should only be taking one exception at a time,
-	 * so if this combination doesn't produce any single exception,
-	 * then we have a bad program that isn't synchronizing its FPU usage
-	 * and it will suffer the consequences since we won't be able to
-	 * fully reproduce the context of the exception
-	 */
-	cwd = get_fpu_cwd(task);
-	swd = get_fpu_swd(task);
+	info.si_addr = (void __user *)regs->ip;
+	if (trapnr == 16) {
+		unsigned short cwd, swd;
+		/*
+		 * (~cwd & swd) will mask out exceptions that are not set to unmasked
+		 * status.  0x3f is the exception bits in these regs, 0x200 is the
+		 * C1 reg you need in case of a stack fault, 0x040 is the stack
+		 * fault bit.  We should only be taking one exception at a time,
+		 * so if this combination doesn't produce any single exception,
+		 * then we have a bad program that isn't synchronizing its FPU usage
+		 * and it will suffer the consequences since we won't be able to
+		 * fully reproduce the context of the exception
+		 */
+		cwd = get_fpu_cwd(task);
+		swd = get_fpu_swd(task);
 
-	err = swd & ~cwd;
+		err = swd & ~cwd;
+	} else {
+		/*
+		 * The SIMD FPU exceptions are handled a little differently, as there
+		 * is only a single status/control register.  Thus, to determine which
+		 * unmasked exception was caught we must mask the exception mask bits
+		 * at 0x1f80, and then use these to mask the exception bits at 0x3f.
+		 */
+		unsigned short mxcsr = get_fpu_mxcsr(task);
+		err = ~(mxcsr >> 7) & mxcsr;
+	}
 
 	if (err & 0x001) {	/* Invalid op */
 		/*
@@ -660,55 +672,7 @@ dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 		return;
 #endif
 
-	math_error((void __user *)regs->ip);
-}
-
-static void simd_math_error(void __user *ip)
-{
-	struct task_struct *task;
-	siginfo_t info;
-	unsigned short mxcsr;
-
-	/*
-	 * Save the info for the exception handler and clear the error.
-	 */
-	task = current;
-	save_init_fpu(task);
-	task->thread.trap_no = 19;
-	task->thread.error_code = 0;
-	info.si_signo = SIGFPE;
-	info.si_errno = 0;
-	info.si_code = __SI_FAULT;
-	info.si_addr = ip;
-	/*
-	 * The SIMD FPU exceptions are handled a little differently, as there
-	 * is only a single status/control register.  Thus, to determine which
-	 * unmasked exception was caught we must mask the exception mask bits
-	 * at 0x1f80, and then use these to mask the exception bits at 0x3f.
-	 */
-	mxcsr = get_fpu_mxcsr(task);
-	switch (~((mxcsr & 0x1f80) >> 7) & (mxcsr & 0x3f)) {
-	case 0x000:
-	default:
-		break;
-	case 0x001: /* Invalid Op */
-		info.si_code = FPE_FLTINV;
-		break;
-	case 0x002: /* Denormalize */
-	case 0x010: /* Underflow */
-		info.si_code = FPE_FLTUND;
-		break;
-	case 0x004: /* Zero Divide */
-		info.si_code = FPE_FLTDIV;
-		break;
-	case 0x008: /* Overflow */
-		info.si_code = FPE_FLTOVF;
-		break;
-	case 0x020: /* Precision */
-		info.si_code = FPE_FLTRES;
-		break;
-	}
-	force_sig_info(SIGFPE, &info, task);
+	math_error(regs, error_code, 16);
 }
 
 dotraplinkage void
@@ -724,7 +688,7 @@ do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 		return;
 #endif
 
-	simd_math_error((void __user *)regs->ip);
+	math_error(regs, error_code, 19);
 }
 
 dotraplinkage void
-- 
1.6.6.1

