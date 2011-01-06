Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1AFKZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:25:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1AFKZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:25:22 -0500
Date: Thu, 6 Jan 2011 11:25:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu changes for v2.6.38
Message-ID: <20110106102515.GA24430@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86-64, asm: Use fxsaveq/fxrestorq in more places


 arch/x86/include/asm/i387.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 4aa2bb3..ef32890 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -93,6 +93,17 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	int err;
 
 	/* See comment in fxsave() below. */
+#ifdef CONFIG_AS_FXSAVEQ
+	asm volatile("1:  fxrstorq %[fx]\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err)
+		     : [fx] "m" (*fx), "0" (0));
+#else
 	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
 		     "2:\n"
 		     ".section .fixup,\"ax\"\n"
@@ -102,6 +113,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err)
 		     : [fx] "R" (fx), "m" (*fx), "0" (0));
+#endif
 	return err;
 }
 
@@ -119,6 +131,17 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 		return -EFAULT;
 
 	/* See comment in fxsave() below. */
+#ifdef CONFIG_AS_FXSAVEQ
+	asm volatile("1:  fxsaveq %[fx]\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     _ASM_EXTABLE(1b, 3b)
+		     : [err] "=r" (err), [fx] "=m" (*fx)
+		     : "0" (0));
+#else
 	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
 		     "2:\n"
 		     ".section .fixup,\"ax\"\n"
@@ -128,6 +151,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err), "=m" (*fx)
 		     : [fx] "R" (fx), "0" (0));
+#endif
 	if (unlikely(err) &&
 	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
 		err = -EFAULT;
