Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2IZGc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:32:28 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:41014 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751781Ab2IZGc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:32:27 -0400
From: Tao Guo <glorioustao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tao Guo <glorioustao@gmail.com>, Jan Beulich <jbeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>, stable@kernel.org
Subject: [PATCH] x86_64: Work around old gas bug
Date: Wed, 26 Sep 2012 02:15:18 -0400
Message-Id: <1348640118-26717-1-git-send-email-glorioustao@gmail.com>
X-Mailer: git-send-email 1.7.7.6
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gas in binutils(2.16.91) could not parse parentheses within macro
parameters, and this is a workaround to make old gas work without
generating below errors:
arch/x86/kernel/entry_64.S: Assembler messages:
arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
arch/x86/kernel/entry_64.S:390: Error: too many positional arguments
arch/x86/kernel/entry_64.S:391: Error: too many positional arguments
arch/x86/kernel/entry_64.S:392: Error: too many positional arguments
arch/x86/kernel/entry_64.S:393: Error: too many positional arguments
arch/x86/kernel/entry_64.S:394: Error: too many positional arguments

Signed-off-by: Tao Guo <glorioustao@gmail.com>
---
 arch/x86/include/asm/calling.h |   52 +++++++++++++++++++--------------------
 arch/x86/kernel/entry_64.S     |   18 +++++++-------
 2 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index a9e3a74..7627e26 100644
--- a/arch/x86/include/asm/calling.h
+++ b/arch/x86/include/asm/calling.h
@@ -49,38 +49,36 @@ For 32-bit we have the following conventions - kernel is built with
 #include "dwarf2.h"
 
 /*
- * 64-bit system call stack frame layout defines and helpers, for
- * assembly code (note that the seemingly unnecessary parentheses
- * are to prevent cpp from inserting spaces in expressions that get
- * passed to macros):
+ * 64-bit system call stack frame layout defines and helpers,
+ * for assembly code:
  */
 
-#define R15		  (0)
-#define R14		  (8)
-#define R13		 (16)
-#define R12		 (24)
-#define RBP		 (32)
-#define RBX		 (40)
+#define R15		  0
+#define R14		  8
+#define R13		 16
+#define R12		 24
+#define RBP		 32
+#define RBX		 40
 
 /* arguments: interrupts/non tracing syscalls only save up to here: */
-#define R11		 (48)
-#define R10		 (56)
-#define R9		 (64)
-#define R8		 (72)
-#define RAX		 (80)
-#define RCX		 (88)
-#define RDX		 (96)
-#define RSI		(104)
-#define RDI		(112)
-#define ORIG_RAX	(120)       /* + error_code */
+#define R11		 48
+#define R10		 56
+#define R9		 64
+#define R8		 72
+#define RAX		 80
+#define RCX		 88
+#define RDX		 96
+#define RSI		104
+#define RDI		112
+#define ORIG_RAX	120       /* + error_code */
 /* end of arguments */
 
 /* cpu exception frame or undefined in case of fast syscall: */
-#define RIP		(128)
-#define CS		(136)
-#define EFLAGS		(144)
-#define RSP		(152)
-#define SS		(160)
+#define RIP		128
+#define CS		136
+#define EFLAGS		144
+#define RSP		152
+#define SS		160
 
 #define ARGOFFSET	R11
 #define SWFRAME		ORIG_RAX
@@ -107,7 +105,7 @@ For 32-bit we have the following conventions - kernel is built with
 
 	.endm
 
-#define ARG_SKIP	(9*8)
+#define ARG_SKIP	9*8
 
 	.macro RESTORE_ARGS rstor_rax=1, addskip=0, rstor_rcx=1, rstor_r11=1, \
 			    rstor_r8910=1, rstor_rdx=1
@@ -157,7 +155,7 @@ For 32-bit we have the following conventions - kernel is built with
 	.endif
 	.endm
 
-#define REST_SKIP	(6*8)
+#define REST_SKIP	6*8
 
 	.macro SAVE_REST
 	subq $REST_SKIP, %rsp
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 69babd8..784a5b6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -342,15 +342,15 @@ ENDPROC(native_usergs_sysret64)
 	.macro SAVE_ARGS_IRQ
 	cld
 	/* start from rbp in pt_regs and jump over */
-	movq_cfi rdi, RDI-RBP
-	movq_cfi rsi, RSI-RBP
-	movq_cfi rdx, RDX-RBP
-	movq_cfi rcx, RCX-RBP
-	movq_cfi rax, RAX-RBP
-	movq_cfi  r8,  R8-RBP
-	movq_cfi  r9,  R9-RBP
-	movq_cfi r10, R10-RBP
-	movq_cfi r11, R11-RBP
+	movq_cfi rdi, (RDI-RBP)
+	movq_cfi rsi, (RSI-RBP)
+	movq_cfi rdx, (RDX-RBP)
+	movq_cfi rcx, (RCX-RBP)
+	movq_cfi rax, (RAX-RBP)
+	movq_cfi  r8,  (R8-RBP)
+	movq_cfi  r9,  (R9-RBP)
+	movq_cfi r10, (R10-RBP)
+	movq_cfi r11, (R11-RBP)
 
 	/* Save rbp so that we can unwind from get_irq_regs() */
 	movq_cfi rbp, 0
-- 
1.7.7

