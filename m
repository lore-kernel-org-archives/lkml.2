Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2JPAnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:43:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57787 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2JPAnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:43:18 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/4] ARM: Move some macros from entry-armv to entry-header
Date: Mon, 15 Oct 2012 17:39:53 -0700
Message-Id: <1350347996-25412-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121016003756.GA23146@lizard>
References: <20121016003756.GA23146@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just move the macros into header file as we would want to use them for
KGDB FIQ entry code.

The following macros were moved:

 - svc_entry
 - usr_entry
 - kuser_cmpxchg_check
 - vector_stub

To make kuser_cmpxchg_check actually work across different files, we
also have to make kuser_cmpxchg64_fixup global.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/kernel/entry-armv.S   | 167 +---------------------------------------
 arch/arm/kernel/entry-header.S | 170 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+), 166 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..0f15368 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -136,57 +136,6 @@ common_invalid:
 	b	bad_mode
 ENDPROC(__und_invalid)
 
-/*
- * SVC mode handlers
- */
-
-#if defined(CONFIG_AEABI) && (__LINUX_ARM_ARCH__ >= 5)
-#define SPFIX(code...) code
-#else
-#define SPFIX(code...)
-#endif
-
-	.macro	svc_entry, stack_hole=0
- UNWIND(.fnstart		)
- UNWIND(.save {r0 - pc}		)
-	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
-#ifdef CONFIG_THUMB2_KERNEL
- SPFIX(	str	r0, [sp]	)	@ temporarily saved
- SPFIX(	mov	r0, sp		)
- SPFIX(	tst	r0, #4		)	@ test original stack alignment
- SPFIX(	ldr	r0, [sp]	)	@ restored
-#else
- SPFIX(	tst	sp, #4		)
-#endif
- SPFIX(	subeq	sp, sp, #4	)
-	stmia	sp, {r1 - r12}
-
-	ldmia	r0, {r3 - r5}
-	add	r7, sp, #S_SP - 4	@ here for interlock avoidance
-	mov	r6, #-1			@  ""  ""      ""       ""
-	add	r2, sp, #(S_FRAME_SIZE + \stack_hole - 4)
- SPFIX(	addeq	r2, r2, #4	)
-	str	r3, [sp, #-4]!		@ save the "real" r0 copied
-					@ from the exception stack
-
-	mov	r3, lr
-
-	@
-	@ We are now ready to fill in the remaining blanks on the stack:
-	@
-	@  r2 - sp_svc
-	@  r3 - lr_svc
-	@  r4 - lr_<exception>, already fixed up for correct return/restart
-	@  r5 - spsr_<exception>
-	@  r6 - orig_r0 (see pt_regs definition in ptrace.h)
-	@
-	stmia	r7, {r2 - r6}
-
-#ifdef CONFIG_TRACE_IRQFLAGS
-	bl	trace_hardirqs_off
-#endif
-	.endm
-
 	.align	5
 __dabt_svc:
 	svc_entry
@@ -348,71 +297,8 @@ ENDPROC(__pabt_svc)
 
 /*
  * User mode handlers
- *
- * EABI note: sp_svc is always 64-bit aligned here, so should S_FRAME_SIZE
  */
 
-#if defined(CONFIG_AEABI) && (__LINUX_ARM_ARCH__ >= 5) && (S_FRAME_SIZE & 7)
-#error "sizeof(struct pt_regs) must be a multiple of 8"
-#endif
-
-	.macro	usr_entry
- UNWIND(.fnstart	)
- UNWIND(.cantunwind	)	@ don't unwind the user space
-	sub	sp, sp, #S_FRAME_SIZE
- ARM(	stmib	sp, {r1 - r12}	)
- THUMB(	stmia	sp, {r0 - r12}	)
-
-	ldmia	r0, {r3 - r5}
-	add	r0, sp, #S_PC		@ here for interlock avoidance
-	mov	r6, #-1			@  ""  ""     ""        ""
-
-	str	r3, [sp]		@ save the "real" r0 copied
-					@ from the exception stack
-
-	@
-	@ We are now ready to fill in the remaining blanks on the stack:
-	@
-	@  r4 - lr_<exception>, already fixed up for correct return/restart
-	@  r5 - spsr_<exception>
-	@  r6 - orig_r0 (see pt_regs definition in ptrace.h)
-	@
-	@ Also, separately save sp_usr and lr_usr
-	@
-	stmia	r0, {r4 - r6}
- ARM(	stmdb	r0, {sp, lr}^			)
- THUMB(	store_user_sp_lr r0, r1, S_SP - S_PC	)
-
-	@
-	@ Enable the alignment trap while in kernel mode
-	@
-	alignment_trap r0
-
-	@
-	@ Clear FP to mark the first stack frame
-	@
-	zero_fp
-
-#ifdef CONFIG_IRQSOFF_TRACER
-	bl	trace_hardirqs_off
-#endif
-	.endm
-
-	.macro	kuser_cmpxchg_check
-#if !defined(CONFIG_CPU_32v6K) && !defined(CONFIG_NEEDS_SYSCALL_FOR_CMPXCHG)
-#ifndef CONFIG_MMU
-#warning "NPTL on non MMU needs fixing"
-#else
-	@ Make sure our user space atomic helper is restarted
-	@ if it was interrupted in a critical region.  Here we
-	@ perform a quick test inline since it should be false
-	@ 99.9999% of the time.  The rest is done out of line.
-	cmp	r4, #TASK_SIZE
-	blhs	kuser_cmpxchg64_fixup
-#endif
-#endif
-	.endm
-
 	.align	5
 __dabt_usr:
 	usr_entry
@@ -846,6 +732,7 @@ __kuser_cmpxchg64:				@ 0xffff0f60
 	ldmfd	sp!, {r4, r5, r6, pc}
 
 	.text
+	.global kuser_cmpxchg64_fixup
 kuser_cmpxchg64_fixup:
 	@ Called from kuser_cmpxchg_fixup.
 	@ r4 = address of interrupted insn (must be preserved).
@@ -976,58 +863,6 @@ __kuser_helper_end:
 
  THUMB(	.thumb	)
 
-/*
- * Vector stubs.
- *
- * This code is copied to 0xffff0200 so we can use branches in the
- * vectors, rather than ldr's.  Note that this code must not
- * exceed 0x300 bytes.
- *
- * Common stub entry macro:
- *   Enter in IRQ mode, spsr = SVC/USR CPSR, lr = SVC/USR PC
- *
- * SP points to a minimal amount of processor-private memory, the address
- * of which is copied into r0 for the mode specific abort handler.
- */
-	.macro	vector_stub, name, mode, correction=0
-	.align	5
-
-vector_\name:
-	.if \correction
-	sub	lr, lr, #\correction
-	.endif
-
-	@
-	@ Save r0, lr_<exception> (parent PC) and spsr_<exception>
-	@ (parent CPSR)
-	@
-	stmia	sp, {r0, lr}		@ save r0, lr
-	mrs	lr, spsr
-	str	lr, [sp, #8]		@ save spsr
-
-	@
-	@ Prepare for SVC32 mode.  IRQs remain disabled.
-	@
-	mrs	r0, cpsr
-	eor	r0, r0, #(\mode ^ SVC_MODE | PSR_ISETSTATE)
-	msr	spsr_cxsf, r0
-
-	@
-	@ the branch table must immediately follow this code
-	@
-	and	lr, lr, #0x0f
- THUMB(	adr	r0, 1f			)
- THUMB(	ldr	lr, [r0, lr, lsl #2]	)
-	mov	r0, sp
- ARM(	ldr	lr, [pc, lr, lsl #2]	)
-	movs	pc, lr			@ branch to handler in SVC mode
-ENDPROC(vector_\name)
-
-	.align	2
-	@ handler addresses follow this label
-1:
-	.endm
-
 	.globl	__stubs_start
 __stubs_start:
 /*
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 9a8531e..c3c09ac 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -73,6 +73,109 @@
 	msr	cpsr_c, \rtemp			@ switch back to the SVC mode
 	.endm
 
+/*
+ * Vector stubs.
+ *
+ * This code is copied to 0xffff0200 so we can use branches in the
+ * vectors, rather than ldr's.  Note that this code must not
+ * exceed 0x300 bytes.
+ *
+ * Common stub entry macro:
+ *   Enter in IRQ mode, spsr = SVC/USR CPSR, lr = SVC/USR PC
+ *
+ * SP points to a minimal amount of processor-private memory, the address
+ * of which is copied into r0 for the mode specific abort handler.
+ */
+	.macro	vector_stub, name, mode, correction=0
+	.align	5
+
+vector_\name:
+	.if \correction
+	sub	lr, lr, #\correction
+	.endif
+
+	@
+	@ Save r0, lr_<exception> (parent PC) and spsr_<exception>
+	@ (parent CPSR)
+	@
+	stmia	sp, {r0, lr}		@ save r0, lr
+	mrs	lr, spsr
+	str	lr, [sp, #8]		@ save spsr
+
+	@
+	@ Prepare for SVC32 mode.  IRQs remain disabled.
+	@
+	mrs	r0, cpsr
+	eor	r0, r0, #(\mode ^ SVC_MODE | PSR_ISETSTATE)
+	msr	spsr_cxsf, r0
+
+	@
+	@ the branch table must immediately follow this code
+	@
+	and	lr, lr, #0x0f
+ THUMB(	adr	r0, 1f			)
+ THUMB(	ldr	lr, [r0, lr, lsl #2]	)
+	mov	r0, sp
+ ARM(	ldr	lr, [pc, lr, lsl #2]	)
+	movs	pc, lr			@ branch to handler in SVC mode
+ENDPROC(vector_\name)
+
+	.align	2
+	@ handler addresses follow this label
+1:
+	.endm
+
+/*
+ * SVC mode handlers
+ */
+
+#if defined(CONFIG_AEABI) && (__LINUX_ARM_ARCH__ >= 5)
+#define SPFIX(code...) code
+#else
+#define SPFIX(code...)
+#endif
+
+	.macro	svc_entry, stack_hole=0
+ UNWIND(.fnstart		)
+ UNWIND(.save {r0 - pc}		)
+	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
+#ifdef CONFIG_THUMB2_KERNEL
+ SPFIX(	str	r0, [sp]	)	@ temporarily saved
+ SPFIX(	mov	r0, sp		)
+ SPFIX(	tst	r0, #4		)	@ test original stack alignment
+ SPFIX(	ldr	r0, [sp]	)	@ restored
+#else
+ SPFIX(	tst	sp, #4		)
+#endif
+ SPFIX(	subeq	sp, sp, #4	)
+	stmia	sp, {r1 - r12}
+
+	ldmia	r0, {r3 - r5}
+	add	r7, sp, #S_SP - 4	@ here for interlock avoidance
+	mov	r6, #-1			@  ""  ""      ""       ""
+	add	r2, sp, #(S_FRAME_SIZE + \stack_hole - 4)
+ SPFIX(	addeq	r2, r2, #4	)
+	str	r3, [sp, #-4]!		@ save the "real" r0 copied
+					@ from the exception stack
+
+	mov	r3, lr
+
+	@
+	@ We are now ready to fill in the remaining blanks on the stack:
+	@
+	@  r2 - sp_svc
+	@  r3 - lr_svc
+	@  r4 - lr_<exception>, already fixed up for correct return/restart
+	@  r5 - spsr_<exception>
+	@  r6 - orig_r0 (see pt_regs definition in ptrace.h)
+	@
+	stmia	r7, {r2 - r6}
+
+#ifdef CONFIG_TRACE_IRQFLAGS
+	bl	trace_hardirqs_off
+#endif
+	.endm
+
 #ifndef CONFIG_THUMB2_KERNEL
 	.macro	svc_exit, rpsr
 	msr	spsr_cxsf, \rpsr
@@ -164,6 +267,73 @@
 #endif	/* !CONFIG_THUMB2_KERNEL */
 
 /*
+ * User mode handlers
+ *
+ * EABI note: sp_svc is always 64-bit aligned here, so should S_FRAME_SIZE
+ */
+
+#if defined(CONFIG_AEABI) && (__LINUX_ARM_ARCH__ >= 5) && (S_FRAME_SIZE & 7)
+#error "sizeof(struct pt_regs) must be a multiple of 8"
+#endif
+
+	.macro	usr_entry
+ UNWIND(.fnstart	)
+ UNWIND(.cantunwind	)	@ don't unwind the user space
+	sub	sp, sp, #S_FRAME_SIZE
+ ARM(	stmib	sp, {r1 - r12}	)
+ THUMB(	stmia	sp, {r0 - r12}	)
+
+	ldmia	r0, {r3 - r5}
+	add	r0, sp, #S_PC		@ here for interlock avoidance
+	mov	r6, #-1			@  ""  ""     ""        ""
+
+	str	r3, [sp]		@ save the "real" r0 copied
+					@ from the exception stack
+
+	@
+	@ We are now ready to fill in the remaining blanks on the stack:
+	@
+	@  r4 - lr_<exception>, already fixed up for correct return/restart
+	@  r5 - spsr_<exception>
+	@  r6 - orig_r0 (see pt_regs definition in ptrace.h)
+	@
+	@ Also, separately save sp_usr and lr_usr
+	@
+	stmia	r0, {r4 - r6}
+ ARM(	stmdb	r0, {sp, lr}^			)
+ THUMB(	store_user_sp_lr r0, r1, S_SP - S_PC	)
+
+	@
+	@ Enable the alignment trap while in kernel mode
+	@
+	alignment_trap r0
+
+	@
+	@ Clear FP to mark the first stack frame
+	@
+	zero_fp
+
+#ifdef CONFIG_IRQSOFF_TRACER
+	bl	trace_hardirqs_off
+#endif
+	.endm
+
+	.macro	kuser_cmpxchg_check
+#if !defined(CONFIG_CPU_32v6K) && !defined(CONFIG_NEEDS_SYSCALL_FOR_CMPXCHG)
+#ifndef CONFIG_MMU
+#warning "NPTL on non MMU needs fixing"
+#else
+	@ Make sure our user space atomic helper is restarted
+	@ if it was interrupted in a critical region.  Here we
+	@ perform a quick test inline since it should be false
+	@ 99.9999% of the time.  The rest is done out of line.
+	cmp	r4, #TASK_SIZE
+	blhs	kuser_cmpxchg64_fixup
+#endif
+#endif
+	.endm
+
+/*
  * These are the registers used in the syscall handler, and allow us to
  * have in theory up to 7 arguments to a function - r0 to r6.
  *
-- 
1.7.12.3

