Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0KFS0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:26:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55505 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0KFS0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=nZiGdG+Kjt7nwrO2s7aV+V9zHNHwF81J8gSuE9CTFlO+NYrjNpTNNSCe9XN0rSzbEO
         zXb5WZxAcAJiAloYO3LIHDOa4NcJ+9Wmrja4cj5tQwoEegYHPINkFVDird/kvINuyXYf
         QLFBR/XQQ5WApfQcMbk6+RJteSm+PPGCmNoWM=
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 3/6] ARM: ftrace: use gas macros to avoid code duplication
Date: Sat,  6 Nov 2010 23:55:51 +0530
Message-Id: <1289067954-5080-3-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289067954-5080-1-git-send-email-rabin@rab.in>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use assembler macros to avoid copy/pasting code between the
implementations of the two variants of the mcount call.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |  146 ++++++++++++++++++++++------------------
 1 files changed, 80 insertions(+), 66 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 8bfa987..fe1d586 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -141,98 +141,112 @@ ENDPROC(ret_from_fork)
 #endif
 #endif
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-ENTRY(__gnu_mcount_nc)
-	mov	ip, lr
-	ldmia	sp!, {lr}
-	mov	pc, ip
-ENDPROC(__gnu_mcount_nc)
+.macro __mcount suffix
+	mcount_enter
+	ldr	r0, =ftrace_trace_function
+	ldr	r2, [r0]
+	adr	r0, .Lftrace_stub
+	cmp	r0, r2
+	bne	1f
+	mcount_exit
 
-ENTRY(ftrace_caller)
-	stmdb	sp!, {r0-r3, lr}
-	mov	r0, lr
+1: 	mcount_get_lr	r1			@ lr of instrumented func
+	mov	r0, lr				@ instrumented function
+	sub	r0, r0, #MCOUNT_INSN_SIZE
+	adr	lr, BSYM(2f)
+	mov	pc, r2
+2:	mcount_exit
+.endm
+
+.macro __ftrace_caller suffix
+	mcount_enter
+
+	mcount_get_lr	r1			@ lr of instrumented func
+	mov	r0, lr				@ instrumented function
 	sub	r0, r0, #MCOUNT_INSN_SIZE
-	ldr	r1, [sp, #20]
 
-	.global	ftrace_call
-ftrace_call:
+	.globl ftrace_call\suffix
+ftrace_call\suffix:
 	bl	ftrace_stub
-	ldmia	sp!, {r0-r3, ip, lr}
-	mov	pc, ip
-ENDPROC(ftrace_caller)
+
+	mcount_exit
+.endm
 
 #ifdef CONFIG_OLD_MCOUNT
+/*
+ * mcount
+ */
+
+.macro mcount_enter
+	stmdb	sp!, {r0-r3, lr}
+.endm
+
+.macro mcount_get_lr reg
+	ldr	\reg, [fp, #-4]
+.endm
+
+.macro mcount_exit
+	ldr	lr, [fp, #-4]
+	ldmia	sp!, {r0-r3, pc}
+.endm
+
 ENTRY(mcount)
+#ifdef CONFIG_DYNAMIC_FTRACE
 	stmdb	sp!, {lr}
 	ldr	lr, [fp, #-4]
 	ldmia	sp!, {pc}
+#else
+	__mcount _old
+#endif
 ENDPROC(mcount)
 
+#ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(ftrace_caller_old)
-	stmdb	sp!, {r0-r3, lr}
-	ldr	r1, [fp, #-4]
-	mov	r0, lr
-	sub	r0, r0, #MCOUNT_INSN_SIZE
-
-	.globl ftrace_call_old
-ftrace_call_old:
-	bl	ftrace_stub
-	ldr	lr, [fp, #-4]			@ restore lr
-	ldmia	sp!, {r0-r3, pc}
+	__ftrace_caller _old
 ENDPROC(ftrace_caller_old)
 #endif
 
-#else
+.purgem mcount_enter
+.purgem mcount_get_lr
+.purgem mcount_exit
+#endif
 
-ENTRY(__gnu_mcount_nc)
+/*
+ * __gnu_mcount_nc
+ */
+
+.macro mcount_enter
 	stmdb	sp!, {r0-r3, lr}
-	ldr	r0, =ftrace_trace_function
-	ldr	r2, [r0]
-	adr	r0, .Lftrace_stub
-	cmp	r0, r2
-	bne	gnu_trace
+.endm
+
+.macro mcount_get_lr reg
+	ldr	\reg, [sp, #20]
+.endm
+
+.macro mcount_exit
 	ldmia	sp!, {r0-r3, ip, lr}
 	mov	pc, ip
+.endm
 
-gnu_trace:
-	ldr	r1, [sp, #20]			@ lr of instrumented routine
-	mov	r0, lr
-	sub	r0, r0, #MCOUNT_INSN_SIZE
-	adr	lr, BSYM(1f)
-	mov	pc, r2
-1:
-	ldmia	sp!, {r0-r3, ip, lr}
+ENTRY(__gnu_mcount_nc)
+#ifdef CONFIG_DYNAMIC_FTRACE
+	mov	ip, lr
+	ldmia	sp!, {lr}
 	mov	pc, ip
+#else
+	__mcount
+#endif
 ENDPROC(__gnu_mcount_nc)
 
-#ifdef CONFIG_OLD_MCOUNT
-/*
- * This is under an ifdef in order to force link-time errors for people trying
- * to build with !FRAME_POINTER with a GCC which doesn't use the new-style
- * mcount.
- */
-ENTRY(mcount)
-	stmdb	sp!, {r0-r3, lr}
-	ldr	r0, =ftrace_trace_function
-	ldr	r2, [r0]
-	adr	r0, ftrace_stub
-	cmp	r0, r2
-	bne	trace
-	ldr	lr, [fp, #-4]			@ restore lr
-	ldmia	sp!, {r0-r3, pc}
-
-trace:
-	ldr	r1, [fp, #-4]			@ lr of instrumented routine
-	mov	r0, lr
-	sub	r0, r0, #MCOUNT_INSN_SIZE
-	mov	lr, pc
-	mov	pc, r2
-	ldr	lr, [fp, #-4]			@ restore lr
-	ldmia	sp!, {r0-r3, pc}
-ENDPROC(mcount)
+#ifdef CONFIG_DYNAMIC_FTRACE
+ENTRY(ftrace_caller)
+	__ftrace_caller
+ENDPROC(ftrace_caller)
 #endif
 
-#endif /* CONFIG_DYNAMIC_FTRACE */
+.purgem mcount_enter
+.purgem mcount_get_lr
+.purgem mcount_exit
 
 ENTRY(ftrace_stub)
 .Lftrace_stub:
-- 
1.7.2.3

