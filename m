Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0IDBS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:18:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59457 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0IDBSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DShmHPJb8K+hiIYVf6iFWh7V2TvbPwJg2b11eNlYaE8N1h0dgJfUqUoJsRR6oypbzT
         yq+TDhEeMseeH8WVRj7F+9Rij6qWI+KI0mztkor8qOhXi48EBpgkmnTh7/+Ily6rbSv/
         MykTvweaVGH0InGxM16cQ+jmYl6RNPbfdyE64=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: [PATCH 09/12] x86: Remove unnecessary ifdefs from i387 code.
Date: Fri,  3 Sep 2010 21:17:16 -0400
Message-Id: <1283563039-3466-10-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
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
index 768fcb2..42b507e 100644
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
@@ -189,12 +195,6 @@ static inline void fpu_save_init(struct fpu *fpu)
 
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
index 966fdcb..9238309 100644
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
@@ -114,12 +112,10 @@ void __cpuinit fpu_init(void)
 
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

