Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0H1QFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:05:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36253 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0H1QFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DgN4JMDbCbMYwwyu6xLIrZbDT4fM7ZzBY/r3t0OyJ/0xeIA7w9SnXKJ1XRMeL25qPJ
         dsPFy2gDLC5M5iSKfImw1f9YFJhTLpFR4kxBxUoXB/3Rm8KLC0NJtE/hqvq3XlBx1K4J
         PRBTwyANLwElBiBlq5N/0mGZ1ucpn550h27Cs=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] x86: Merge fpu_save_init()
Date: Sat, 28 Aug 2010 12:04:36 -0400
Message-Id: <1283011478-27237-10-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge 32-bit and 64-bit fpu_save_init().

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h |   88 +++++++++++--------------------------------
 1 files changed, 22 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 768fcb2..58cb6f0 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -94,36 +94,6 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	return err;
 }
 
-/* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
-   is pending. Clear the x87 state here by setting it to fixed
-   values. The kernel data segment can be sometimes 0 and sometimes
-   new user value. Both should be ok.
-   Use the PDA as safe address because it should be already in L1. */
-static inline void fpu_clear(struct fpu *fpu)
-{
-	struct xsave_struct *xstate = &fpu->state->xsave;
-	struct i387_fxsave_struct *fx = &fpu->state->fxsave;
-
-	/*
-	 * xsave header may indicate the init state of the FP.
-	 */
-	if (use_xsave() &&
-	    !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-		return;
-
-	if (unlikely(fx->swd & X87_FSW_ES))
-		asm volatile("fnclex");
-	alternative_input(ASM_NOP8 ASM_NOP2,
-			  "    emms\n"		/* clear stack tags */
-			  "    fildl %%gs:0",	/* load to clear state */
-			  X86_FEATURE_FXSAVE_LEAK);
-}
-
-static inline void clear_fpu_state(struct task_struct *tsk)
-{
-	fpu_clear(&tsk->thread.fpu);
-}
-
 static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
@@ -177,16 +147,6 @@ static inline void fpu_fxsave(struct fpu *fpu)
 		     : [fx] "R" (&fpu->state->fxsave));
 }
 
-static inline void fpu_save_init(struct fpu *fpu)
-{
-	if (use_xsave())
-		fpu_xsave(fpu);
-	else
-		fpu_fxsave(fpu);
-
-	fpu_clear(fpu);
-}
-
 #else  /* CONFIG_X86_32 */
 
 #ifdef CONFIG_MATH_EMULATION
@@ -211,6 +171,19 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	return 0;
 }
 
+static inline void fpu_fxsave(struct fpu *fpu)
+{
+	/* Use more nops than strictly needed in case the compiler
+	   varies code */
+	alternative_input(
+		"fnsave %[fx] ;fwait;" GENERIC_NOP2,
+		"fxsave %[fx]\n",
+		X86_FEATURE_FXSR,
+		[fx] "m" (fpu->state->fxsave) : "memory");
+}
+
+#endif	/* CONFIG_X86_64 */
+
 /* We need a safe address that is cheap to find and that is already
    in L1 during context switch. The best choices are unfortunately
    different for UP and SMP */
@@ -225,52 +198,35 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
  */
 static inline void fpu_save_init(struct fpu *fpu)
 {
+	struct i387_fxsave_struct *fx = &fpu->state->fxsave;
+
 	if (use_xsave()) {
 		struct xsave_struct *xstate = &fpu->state->xsave;
-		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
-
 		fpu_xsave(fpu);
-
 		/*
 		 * xsave header may indicate the init state of the FP.
 		 */
 		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-			goto end;
-
+			return;
 		if (unlikely(fx->swd & X87_FSW_ES))
 			asm volatile("fnclex");
-
-		/*
-		 * we can do a simple return here or be paranoid :)
-		 */
-		goto clear_state;
+	} else {
+		fpu_fxsave(fpu);
+		if (cpu_has_fxsr && unlikely(fx->swd & X87_FSW_ES))
+			asm volatile("fnclex");
 	}
 
-	/* Use more nops than strictly needed in case the compiler
-	   varies code */
-	alternative_input(
-		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
-		"fxsave %[fx]\n"
-		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
-		X86_FEATURE_FXSR,
-		[fx] "m" (fpu->state->fxsave),
-		[fsw] "m" (fpu->state->fxsave.swd) : "memory");
-clear_state:
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
 	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
+		ASM_NOP8 ASM_NOP2,
 		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
+		"fildl %P[addr]", 	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
-end:
-	;
 }
 
-#endif	/* CONFIG_X86_64 */
-
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	fpu_save_init(&tsk->thread.fpu);
-- 
1.7.2.2

