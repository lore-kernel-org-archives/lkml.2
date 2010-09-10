Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab0IJByN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:54:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:48307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690Ab0IJByJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:54:09 -0400
Date: Fri, 10 Sep 2010 01:49:41 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-12-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-12-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-32, fpu: Rewrite fpu_save_init()
Message-ID: <tip-58a992b9cbaf449aeebd3575c3695a9eb5d95b5e@git.kernel.org>
Git-Commit-ID: 58a992b9cbaf449aeebd3575c3695a9eb5d95b5e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:49:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58a992b9cbaf449aeebd3575c3695a9eb5d95b5e
Gitweb:     http://git.kernel.org/tip/58a992b9cbaf449aeebd3575c3695a9eb5d95b5e
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:18 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:17:31 -0700

x86-32, fpu: Rewrite fpu_save_init()

Rewrite fpu_save_init() to prepare for merging with 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-12-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/i387.h |   47 ++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 907967e..b45abef 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -73,6 +73,11 @@ static __always_inline __pure bool use_xsave(void)
 	return static_cpu_has(X86_FEATURE_XSAVE);
 }
 
+static __always_inline __pure bool use_fxsr(void)
+{
+        return static_cpu_has(X86_FEATURE_FXSR);
+}
+
 extern void __sanitize_i387_state(struct task_struct *);
 
 static inline void sanitize_i387_state(struct task_struct *tsk)
@@ -211,6 +216,12 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	return 0;
 }
 
+static inline void fpu_fxsave(struct fpu *fpu)
+{
+	asm volatile("fxsave %[fx]"
+		     : [fx] "=m" (fpu->state->fxsave));
+}
+
 /* We need a safe address that is cheap to find and that is already
    in L1 during context switch. The best choices are unfortunately
    different for UP and SMP */
@@ -226,36 +237,24 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 static inline void fpu_save_init(struct fpu *fpu)
 {
 	if (use_xsave()) {
-		struct xsave_struct *xstate = &fpu->state->xsave;
-		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
-
 		fpu_xsave(fpu);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
 		 */
-		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-			goto end;
-
-		if (unlikely(fx->swd & X87_FSW_ES))
-			asm volatile("fnclex");
-
-		/*
-		 * we can do a simple return here or be paranoid :)
-		 */
-		goto clear_state;
+		if (!(fpu->state->xsave.xsave_hdr.xstate_bv & XSTATE_FP))
+			return;
+	} else if (use_fxsr()) {
+		fpu_fxsave(fpu);
+	} else {
+		asm volatile("fsave %[fx]; fwait"
+			     : [fx] "=m" (fpu->state->fsave));
+		return;
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
+	if (unlikely(fpu->state->fxsave.swd & X87_FSW_ES))
+		asm volatile("fnclex");
+
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -265,8 +264,6 @@ clear_state:
 		"fildl %[addr]", 	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
-end:
-	;
 }
 
 #endif	/* CONFIG_X86_64 */
