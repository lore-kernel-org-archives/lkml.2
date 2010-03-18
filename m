Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0CRSWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:22:18 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:59925 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0CRSV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C7ci3cxb8Hly0S3fz5z499MxAHMvXg6C+nIaWiwjnxn90ECx1u6v4flukJimQImQeU
         J74C5eFn2jPpHVwSXNVZCI78hJMffuwWKrz+w8dZP/ya+RwPNdtLM+Ge4gBc5XpGvy75
         4bofkzX81MUAk2anDKD4svjjaejwthWP2rBvQ=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86-32: Split cache flush handler from simd handler
Date: Thu, 18 Mar 2010 14:20:49 -0400
Message-Id: <1268936453-3727-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
References: <1268936453-3727-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the cache flush handler a seperate function, and use
an alternative to call the appropriate handler.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/entry_32.S |   16 +++++++++++++++-
 arch/x86/kernel/traps.c    |   43 ++++++++++++++++++++++++-------------------
 2 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 44a8e0d..c3769fa 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -53,6 +53,7 @@
 #include <asm/processor-flags.h>
 #include <asm/ftrace.h>
 #include <asm/irq_vectors.h>
+#include <asm/cpufeature.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -905,7 +906,20 @@ ENTRY(simd_coprocessor_error)
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl $do_simd_coprocessor_error
+661:	pushl $do_cache_flush_error
+662:
+.section .altinstructions,"a"
+	ALIGN
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
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1168e44..45b9cb0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -257,6 +257,27 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 }
 #endif
 
+#ifdef CONFIG_X86_32
+dotraplinkage void
+do_cache_flush_error(struct pt_regs *regs, long error_code)
+{
+	conditional_sti(regs);
+
+	/*
+	 * Handle strange cache flush from user space exception.
+	 * This is undocumented behaviour.
+	 */
+	if (regs->flags & X86_VM_MASK) {
+		handle_vm86_fault((struct kernel_vm86_regs *)regs, error_code);
+		return;
+	}
+	current->thread.trap_no = 19;
+	current->thread.error_code = error_code;
+	die_if_kernel("cache flush denied", regs, error_code);
+	force_sig(SIGSEGV, current);
+}
+#endif
+
 dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
@@ -729,30 +750,14 @@ do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
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

