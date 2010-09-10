Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab0IJBzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:55:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:48347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633Ab0IJBzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:55:06 -0400
Date: Fri, 10 Sep 2010 01:48:17 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-8-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-8-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-64, fpu: Simplify constraints for fxsave/fxtstor
Message-ID: <tip-820241356d6aa9a895fc10def15794a5a5bfcd98@git.kernel.org>
Git-Commit-ID: 820241356d6aa9a895fc10def15794a5a5bfcd98
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:48:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  820241356d6aa9a895fc10def15794a5a5bfcd98
Gitweb:     http://git.kernel.org/tip/820241356d6aa9a895fc10def15794a5a5bfcd98
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:14 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:17:06 -0700

x86-64, fpu: Simplify constraints for fxsave/fxtstor

Use the "R" constraint (legacy register) instead of listing all the
possible registers.  Clean up the comments as well.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-8-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
