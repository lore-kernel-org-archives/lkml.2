Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0H1QF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:05:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44702 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab0H1QFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nEsQK8eF07idCKwhmuFzjvmYr+6ixdLbefzYXkvEWM2iC9kN/mxR435qtoOMo+LkeP
         rWSJ0BtgFYNT579VL/n/FBFe2QXBOwqvM20eUQQsjTRYBC16olcjeEIxSSEgy5xwqJ5f
         H92XGmiQKVFM9t6/C+uNckZ5uGLQxx25N6X3k=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] x86-64: Simplify constraints for fxsave/fxtstor
Date: Sat, 28 Aug 2010 12:04:34 -0400
Message-Id: <1283011478-27237-8-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the "R" constraint (legacy register) instead of listing all the
possible registers.  Clean up the comments as well.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h |   44 ++++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 8b40a83..768fcb2 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -81,6 +81,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
 	int err;
 
+	/* See comment in fxsave() below. */
 	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
 		     "2:\n"
 		     ".section .fixup,\"ax\"\n"
@@ -89,11 +90,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err)
-#if 0 /* See comment in fxsave() below. */
-		     : [fx] "r" (fx), "m" (*fx), "0" (0));
-#else
-		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
-#endif
+		     : [fx] "R" (fx), "m" (*fx), "0" (0));
 	return err;
 }
 
@@ -140,6 +137,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 	if (unlikely(err))
 		return -EFAULT;
 
+	/* See comment in fxsave() below. */
 	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
 		     "2:\n"
 		     ".section .fixup,\"ax\"\n"
@@ -148,11 +146,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err), "=m" (*fx)
-#if 0 /* See comment in fxsave() below. */
-		     : [fx] "r" (fx), "0" (0));
-#else
-		     : [fx] "cdaSDb" (fx), "0" (0));
-#endif
+		     : [fx] "R" (fx), "0" (0));
 	if (unlikely(err) &&
 	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
 		err = -EFAULT;
@@ -165,26 +159,22 @@ static inline void fpu_fxsave(struct fpu *fpu)
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
 	   will be generated (to the assembler, rex64 followed by semicolon
-	   is a separate instruction), and hence the 64-bitness is lost. */
-#if 0
-	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
-	   starting with gas 2.16. */
-	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (fpu->state->fxsave));
-#elif 0
-	/* Using, as a workaround, the properly prefixed form below isn't
+	   is a separate instruction), and hence the 64-bitness is lost.
+	   Using "fxsaveq %0" would be the ideal choice, but is only supported
+	   starting with gas 2.16.
+	asm volatile("fxsaveq %0"
+		     : "=m" (fpu->state->fxsave));
+	   Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
-	   needed for addressing (fix submitted to mainline 2005-11-21). */
-	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (fpu->state->fxsave));
-#else
-	/* This, however, we can work around by forcing the compiler to select
+	   needed for addressing (fix submitted to mainline 2005-11-21).
+	asm volatile("rex64/fxsave %0"
+		     : "=m" (fpu->state->fxsave));
+	   This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__("rex64/fxsave (%1)"
-			     : "=m" (fpu->state->fxsave)
-			     : "cdaSDb" (&fpu->state->fxsave));
-#endif
+	asm volatile("rex64/fxsave (%[fx])"
+		     : "=m" (fpu->state->fxsave)
+		     : [fx] "R" (&fpu->state->fxsave));
 }
 
 static inline void fpu_save_init(struct fpu *fpu)
-- 
1.7.2.2

