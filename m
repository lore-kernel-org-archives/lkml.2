Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab0ENDSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 23:18:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:3164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0ENDSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 23:18:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="567057705"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 1/3] x86: Split fpu_save_init() to fpu_save() and fpu_clear()
Date: Fri, 14 May 2010 11:16:51 +0800
Message-Id: <1273807013-4792-2-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273807013-4792-1-git-send-email-sheng@linux.intel.com>
References: <1273807013-4792-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fpu_save() would be used later by KVM.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/i387.h |   71 ++++++++++++++++++++++++++-----------------
 1 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 1a8cca3..989d3b7 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -180,13 +180,17 @@ static inline void fpu_fxsave(struct fpu *fpu)
 #endif
 }
 
-static inline void fpu_save_init(struct fpu *fpu)
+static inline void fpu_save(struct fpu *fpu)
 {
 	if (use_xsave())
 		fpu_xsave(fpu);
 	else
 		fpu_fxsave(fpu);
+}
 
+static inline void fpu_save_init(struct fpu *fpu)
+{
+	fpu_save(fpu);
 	fpu_clear(fpu);
 }
 
@@ -237,19 +241,41 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 /*
  * These must be called with preempt disabled
  */
-static inline void fpu_save_init(struct fpu *fpu)
+static inline void fpu_fxsave(struct fpu *fpu)
 {
-	if (use_xsave()) {
-		struct xsave_struct *xstate = &fpu->state->xsave;
-		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
+	/* Use more nops than strictly needed in case the compiler
+	   varies code */
+	alternative_input(
+		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
+		"fxsave %[fx]\n"
+		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
+		X86_FEATURE_FXSR,
+		[fx] "m" (fpu->state->fxsave),
+		[fsw] "m" (fpu->state->fxsave.swd) : "memory");
+}
 
+static inline void fpu_save(struct fpu *fpu)
+{
+	if (use_xsave())
 		fpu_xsave(fpu);
+	else
+		fpu_fxsave(fpu);
+}
+
+/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
+   is pending.  Clear the x87 state here by setting it to fixed
+   values. safe_address is a random variable that should be in L1 */
+static inline void fpu_clear(struct fpu *fpu)
+{
+	struct xsave_struct *xstate = &fpu->state->xsave;
+	struct i387_fxsave_struct *fx = &fpu->state->fxsave;
 
+	if (use_xsave()) {
 		/*
 		 * xsave header may indicate the init state of the FP.
 		 */
 		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
-			goto end;
+			return;
 
 		if (unlikely(fx->swd & X87_FSW_ES))
 			asm volatile("fnclex");
@@ -257,30 +283,19 @@ static inline void fpu_save_init(struct fpu *fpu)
 		/*
 		 * we can do a simple return here or be paranoid :)
 		 */
-		goto clear_state;
 	}
+ 	alternative_input(
+ 		GENERIC_NOP8 GENERIC_NOP2,
+ 		"emms\n\t"	  	/* clear stack tags */
+ 		"fildl %[addr]", 	/* set F?P to defined value */
+ 		X86_FEATURE_FXSAVE_LEAK,
+ 		[addr] "m" (safe_address));
+}
 
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
-	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
-	   is pending.  Clear the x87 state here by setting it to fixed
-	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
-end:
-	;
+static inline void fpu_save_init(struct fpu *fpu)
+{
+	fpu_save(fpu);
+	fpu_clear(fpu);
 }
 
 static inline void __save_init_fpu(struct task_struct *tsk)
-- 
1.7.0.1

