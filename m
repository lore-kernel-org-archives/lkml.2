Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab2DYL2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:28:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab2DYL2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:28:49 -0400
Message-Id: <20120425112244.953956269@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 25 Apr 2012 13:15:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] math128, x86_64: Implement {mult,add}_u128 in 64bit asm
References: <20120425111552.665217867@chello.nl>
Content-Disposition: inline; filename=math128-x86_64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/Kbuild    |    1 -
 arch/x86/include/asm/math128.h |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -26,4 +26,3 @@ header-y += vsyscall.h
 genhdr-y += unistd_32.h
 genhdr-y += unistd_64.h
 genhdr-y += unistd_x32.h
-generic-y += math128.h
--- /dev/null
+++ b/arch/x86/include/asm/math128.h
@@ -0,0 +1,39 @@
+#ifndef _ASM_MATH128_H
+#define _ASM_MATH128_H
+
+#ifdef CONFIG_X86_64
+
+#ifdef __SIZEOF_INT128__
+#define ARCH_HAS_INT128
+#endif
+
+#ifndef ARCH_HAS_INT128
+
+static inline mul_u64_u64(u64 a, u64 b)
+{
+       u128 res;
+
+       asm("mulq %2"
+               : "=a" (res.lo), "=d" (res.hi)
+               :  "rm" (b), "0" (a));
+
+       return res;
+}
+#define mult_u64_u64 mult_u64_u64
+
+static inline add_u128(u128 a, u128 b)
+{
+       u128 res;
+
+       asm("addq %2,%0;\n"
+           "adcq %3,%1;\n"
+               : "=rm" (res.lo), "=rm" (res.hi)
+               : "r" (b.lo), "r" (b.hi), "0" (a.lo), "1" (a.hi));
+
+       return res;
+}
+#define add_u128 add_u128
+
+#endif /* ARCH_HAS_INT128 */
+#endif /* CONFIG_X86_64 */
+#endif /* _ASM_MATH128_H */


