Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0JESak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:30:40 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:49392
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752245Ab0JESaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:30:39 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9TY2W-02-O9U-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 2/3] Allow saving of individual states in fpu_xsave().
Date: Tue, 5 Oct 2010 20:30:28 +0200
Message-ID: <1286303429-415145-3-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20101005182739.GE173@escobedo.osrc.amd.com>
References: <20101005182739.GE173@escobedo.osrc.amd.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a feature mask argument to fpu_xsave(). Introduce XCNTXT_DEFAULT
to specify which feature states are to be saved/restored by default at
context switches. Rename XCNTXT_MASK to XCNTXT_SUPPORTED to make clear
what it really is.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/i387.h  |    4 ++--
 arch/x86/include/asm/xsave.h |   14 +++++++++++---
 arch/x86/kernel/xsave.c      |    2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index de8593b..33600d3 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -201,7 +201,7 @@ static inline void fpu_save_init(struct fpu *fpu)
 	if (use_xsave()) {
 		struct xsave_struct *xstate = &fpu->state->xsave;
 
-		fpu_xsave(xstate);
+		fpu_xsave(xstate, XCNTXT_DEFAULT);
 
 		/*
 		 * xsave header may indicate the init state of the FP.
@@ -239,7 +239,7 @@ static inline void __save_init_fpu(struct task_struct *tsk)
 static inline int fpu_restore_checking(struct fpu *fpu)
 {
 	if (use_xsave())
-		return xrstor_checking(&fpu->state->xsave, -1);
+		return xrstor_checking(&fpu->state->xsave, XCNTXT_DEFAULT);
 	else
 		return fxrstor_checking(&fpu->state->fxsave);
 }
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 8bcbbce..8820b57 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -23,7 +23,12 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_SUPPORTED    (XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+
+/*
+ * These are the features that the OS saves/restores by default.
+ */
+#define XCNTXT_DEFAULT	    (-1)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
@@ -113,15 +118,18 @@ static inline void xsave_state(struct xsave_struct *fx, u64 mask)
 		     :   "memory");
 }
 
-static inline void fpu_xsave(struct xsave_struct *fx)
+static inline void fpu_xsave(struct xsave_struct *fx, u64 mask)
 {
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
 	alternative_input(
 		".byte " REX_PREFIX "0x0f,0xae,0x27",
 		".byte " REX_PREFIX "0x0f,0xae,0x37",
 		X86_FEATURE_XSAVEOPT,
-		[fx] "D" (fx), "a" (-1), "d" (-1) :
+		[fx] "D" (fx), "a" (lmask), "d" (hmask) :
 		"memory");
 }
 #endif
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 5eb15d4..11c3445 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -434,7 +434,7 @@ static void __init xstate_enable_boot_cpu(void)
 	/*
 	 * Support only the state known to OS.
 	 */
-	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
+	pcntxt_mask = pcntxt_mask & XCNTXT_SUPPORTED;
 
 	xstate_enable();
 
-- 
1.5.6.5


