Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab0IJBxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:53:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:48281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0IJBxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:53:46 -0400
Date: Fri, 10 Sep 2010 01:48:59 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-10-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-10-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Remove unnecessary ifdefs from i387 code.
Message-ID: <tip-8eb91a577d7763d21628f6761045328784b1911c@git.kernel.org>
Git-Commit-ID: 8eb91a577d7763d21628f6761045328784b1911c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:49:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eb91a577d7763d21628f6761045328784b1911c
Gitweb:     http://git.kernel.org/tip/8eb91a577d7763d21628f6761045328784b1911c
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:16 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:17:18 -0700

x86, fpu: Remove unnecessary ifdefs from i387 code.

Remove ifdefs for code that the compiler can optimize away on 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-10-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index f3775f5..e795e36 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -79,10 +79,8 @@ static void __cpuinit init_thread_xstate(void)
 
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
-#ifdef CONFIG_X86_32
 	else
 		xstate_size = sizeof(struct i387_fsave_struct);
-#endif
 }
 
 /*
@@ -119,12 +117,10 @@ void __cpuinit fpu_init(void)
 
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
