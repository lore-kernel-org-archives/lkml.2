Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0H1QFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:05:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36253 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab0H1QFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s/rOazs5WL/unKdMxzpfG4E66oW4GmvgTxoO482P/5yv5lyuYIsVvL/ojLnXCNBLgZ
         ZHYfskmDjtYIrCulK2vp90RIgh26Y75hwlE2mkxu6KDnJEOIUyfXZRSicMs/jNoflZMh
         faElhpokv/ifAOuD1/uypBI4UOFvDg15eB76Y=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] x86: Remove unnecessary ifdefs from i387 code.
Date: Sat, 28 Aug 2010 12:04:37 -0400
Message-Id: <1283011478-27237-11-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ifdefs for code that the compiler can optimize away on 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h |   12 ++++++------
 arch/x86/kernel/i387.c      |    4 ----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 58cb6f0..3b4675d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -55,6 +55,12 @@ extern int save_i387_xstate_ia32(void __user *buf);
 extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
+#ifdef CONFIG_MATH_EMULATION
+extern void finit_soft_fpu(struct i387_soft_struct *soft);
+#else
+static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
+#endif
+
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
 
 static __always_inline __pure bool use_xsaveopt(void)
@@ -149,12 +155,6 @@ static inline void fpu_fxsave(struct fpu *fpu)
 
 #else  /* CONFIG_X86_32 */
 
-#ifdef CONFIG_MATH_EMULATION
-extern void finit_soft_fpu(struct i387_soft_struct *soft);
-#else
-static inline void finit_soft_fpu(struct i387_soft_struct *soft) {}
-#endif
-
 /* perform fxrstor iff the processor has extended states, otherwise frstor */
 static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index b1a732d..e21c138 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -74,10 +74,8 @@ static void __cpuinit init_thread_xstate(void)
 
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
-#ifdef CONFIG_X86_32
 	else
 		xstate_size = sizeof(struct i387_fsave_struct);
-#endif
 }
 
 /*
@@ -113,12 +111,10 @@ void __cpuinit fpu_init(void)
 
 void fpu_finit(struct fpu *fpu)
 {
-#ifdef CONFIG_X86_32
 	if (!HAVE_HWFP) {
 		finit_soft_fpu(&fpu->state->soft);
 		return;
 	}
-#endif
 
 	if (cpu_has_fxsr) {
 		struct i387_fxsave_struct *fx = &fpu->state->fxsave;
-- 
1.7.2.2

