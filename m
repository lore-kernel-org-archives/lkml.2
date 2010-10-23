Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0JWBVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 21:21:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:35446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab0JWBVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 21:21:18 -0400
Date: Sat, 23 Oct 2010 01:20:23 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com>
References: <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86-64, asm: Use fxsaveq/fxrestorq in more places
Message-ID: <tip-fd35fbcdd1b2579a6e00a1545f7124e4005d0474@git.kernel.org>
Git-Commit-ID: fd35fbcdd1b2579a6e00a1545f7124e4005d0474
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 01:20:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd35fbcdd1b2579a6e00a1545f7124e4005d0474
Gitweb:     http://git.kernel.org/tip/fd35fbcdd1b2579a6e00a1545f7124e4005d0474
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 22 Oct 2010 15:33:38 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 22 Oct 2010 15:33:38 -0700

x86-64, asm: Use fxsaveq/fxrestorq in more places

Checkin d7acb92fea932ad2e7846480aeacddc2c03c8485 made use of fxsaveq
in fpu_fxsave() if the assembler supports it; this adds
fxsaveq/fxrstorq to fxrstor_checking() and fxsave_user() as well.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
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
