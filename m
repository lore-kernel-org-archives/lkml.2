Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0IJBxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:53:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:48280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab0IJBxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:53:45 -0400
Date: Fri, 10 Sep 2010 01:50:02 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-13-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-13-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Merge fpu_save_init()
Message-ID: <tip-b2b57fe053c9cf8b8af5a0e826a465996afed0ff@git.kernel.org>
Git-Commit-ID: b2b57fe053c9cf8b8af5a0e826a465996afed0ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:50:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2b57fe053c9cf8b8af5a0e826a465996afed0ff
Gitweb:     http://git.kernel.org/tip/b2b57fe053c9cf8b8af5a0e826a465996afed0ff
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:19 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:17:36 -0700

x86, fpu: Merge fpu_save_init()

Make 64-bit use the 32-bit version of fpu_save_init().  Remove
unused clear_fpu_state().

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-13-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h |   48 +++---------------------------------------
 1 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index b45abef..70626ed 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -105,36 +105,6 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
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
@@ -188,16 +158,6 @@ static inline void fpu_fxsave(struct fpu *fpu)
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
 
 /* perform fxrstor iff the processor has extended states, otherwise frstor */
@@ -222,6 +182,8 @@ static inline void fpu_fxsave(struct fpu *fpu)
 		     : [fx] "=m" (fpu->state->fxsave));
 }
 
+#endif	/* CONFIG_X86_64 */
+
 /* We need a safe address that is cheap to find and that is already
    in L1 during context switch. The best choices are unfortunately
    different for UP and SMP */
@@ -259,15 +221,13 @@ static inline void fpu_save_init(struct fpu *fpu)
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
 	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
+		ASM_NOP8 ASM_NOP2,
 		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
+		"fildl %P[addr]",	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
 }
 
-#endif	/* CONFIG_X86_64 */
-
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	fpu_save_init(&tsk->thread.fpu);
