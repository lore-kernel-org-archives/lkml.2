Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0CUNBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:01:32 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:62281 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0CUNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ebkRLjfpSjnC6gmSaf0QdtTQosFFFRXAgbcic20ka1tPTKLXLxrme/0XEbSIARYEJD
         Bmd9TUZze9bqyI/1iZr2LRtUBqdSS6fCZp1V3McZG2aBkWkP9CaF1RDRNj4FeNFvrMll
         XM2modcVpe7aqmHp6bJdavfDS3CfSy+wLd+OQ=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86-32: Rework cache flush denied handler
Date: Sun, 21 Mar 2010 09:00:43 -0400
Message-Id: <1269176446-2489-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
References: <1269176446-2489-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache flush denied error is an erratum on some AMD 486 clones.  If an invd
instruction is executed in userspace, the processor calls exception 19 (13 hex)
instead of #GP (13 decimal).  On cpus where XMM is not supported, redirect
exception 19 to do_general_protection().  Also, remove die_if_kernel(), since
this was the last user.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/Kconfig.cpu       |    4 ++++
 arch/x86/kernel/entry_32.S |   19 +++++++++++++++++++
 arch/x86/kernel/traps.c    |   31 +++----------------------------
 3 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f20ddf8..1012e8a 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -338,6 +338,10 @@ config X86_F00F_BUG
 	def_bool y
 	depends on M586MMX || M586TSC || M586 || M486 || M386
 
+config X86_INVD_BUG
+	def_bool y
+	depends on M486 || M386
+
 config X86_WP_WORKS_OK
 	def_bool y
 	depends on !M386
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 44a8e0d..1e958b8 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -53,6 +53,7 @@
 #include <asm/processor-flags.h>
 #include <asm/ftrace.h>
 #include <asm/irq_vectors.h>
+#include <asm/cpufeature.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -905,7 +906,25 @@ ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
+#ifdef CONFIG_X86_INVD_BUG
+	/* AMD 486 bug: invd from userspace calls exception 19 instead of #GP */
+661:	pushl $do_general_protection
+662:
+.section .altinstructions,"a"
+	.balign 4
+	.long 661b
+	.long 663f
+	.byte X86_FEATURE_XMM
+	.byte 662b-661b
+	.byte 664f-663f
+.previous
+.section .altinstr_replacement,"ax"	
+663:	pushl $do_simd_coprocessor_error
+664:
+.previous
+#else
 	pushl $do_simd_coprocessor_error
+#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3339917..bb4a7b3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -108,15 +108,6 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
-#ifdef CONFIG_X86_32
-static inline void
-die_if_kernel(const char *str, struct pt_regs *regs, long err)
-{
-	if (!user_mode_vm(regs))
-		die(str, regs, err);
-}
-#endif
-
 static void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
@@ -726,30 +717,14 @@ do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 	conditional_sti(regs);
 
 #ifdef CONFIG_X86_32
-	if (cpu_has_xmm) {
-		/* Handle SIMD FPU exceptions on PIII+ processors. */
-		ignore_fpu_irq = 1;
-		simd_math_error((void __user *)regs->ip);
-		return;
-	}
-	/*
-	 * Handle strange cache flush from user space exception
-	 * in all other cases.  This is undocumented behaviour.
-	 */
-	if (regs->flags & X86_VM_MASK) {
-		handle_vm86_fault((struct kernel_vm86_regs *)regs, error_code);
-		return;
-	}
-	current->thread.trap_no = 19;
-	current->thread.error_code = error_code;
-	die_if_kernel("cache flush denied", regs, error_code);
-	force_sig(SIGSEGV, current);
+	ignore_fpu_irq = 1;
 #else
 	if (!user_mode(regs) &&
 			kernel_math_error(regs, "kernel simd math error", 19))
 		return;
-	simd_math_error((void __user *)regs->ip);
 #endif
+
+	simd_math_error((void __user *)regs->ip);
 }
 
 dotraplinkage void
-- 
1.6.6.1

