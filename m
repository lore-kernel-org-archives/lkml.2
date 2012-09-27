Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2I0GJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:09:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2I0GJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:09:26 -0400
Date: Wed, 26 Sep 2012 23:09:10 -0700
From: tip-bot for Tao Guo <glorioustao@gmail.com>
Message-ID: <tip-1b2b23d8573076a587ed2081e0d2b69691079e0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, glorioustao@gmail.com,
        jbeulich@novell.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, glorioustao@gmail.com,
        jbeulich@novell.com, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
References: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86_64: Work around old GAS bug
Git-Commit-ID: 1b2b23d8573076a587ed2081e0d2b69691079e0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:09:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b2b23d8573076a587ed2081e0d2b69691079e0e
Gitweb:     http://git.kernel.org/tip/1b2b23d8573076a587ed2081e0d2b69691079e0e
Author:     Tao Guo <glorioustao@gmail.com>
AuthorDate: Wed, 26 Sep 2012 04:28:22 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Sep 2012 13:35:32 +0200

x86_64: Work around old GAS bug

GAS in binutils(2.16.91) could not parse parentheses within
macro parameters unless fully parenthesized, and this is a
workaround to make old gas work without generating below errors:

 arch/x86/kernel/entry_64.S: Assembler messages:
 arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
 arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
 [...]

Signed-off-by: Tao Guo <glorioustao@gmail.com>
Reluctantly-Acked-by: Jan Beulich <jbeulich@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1348648102-12653-1-git-send-email-glorioustao@gmail.com
[ Jan argues that these old GAS versions are fragile - which is so, but lets give them a chance. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/calling.h |   48 +++++++++++++++++++--------------------
 arch/x86/kernel/entry_64.S     |   20 ++++++++--------
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
index a9e3a74..7f8422a 100644
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
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b1dac12..2c67061 100644
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
@@ -384,7 +384,7 @@ ENDPROC(native_usergs_sysret64)
 	.endm
 
 ENTRY(save_rest)
-	PARTIAL_FRAME 1 REST_SKIP+8
+	PARTIAL_FRAME 1 (REST_SKIP+8)
 	movq 5*8+16(%rsp), %r11	/* save return address */
 	movq_cfi rbx, RBX+16
 	movq_cfi rbp, RBP+16
