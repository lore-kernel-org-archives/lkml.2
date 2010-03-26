Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0CZOne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 10:43:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab0CZOnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 10:43:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] X86: Optimise fls(), ffs() and fls64()
To: torvalds@osdl.org, mingo@elte.hu, tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Fri, 26 Mar 2010 14:42:41 +0000
Message-ID: <20100326144241.8583.95617.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fls(N), ffs(N) and fls64(N) can be optimised on x86/x86_64.  Currently they
perform checks against N being 0 before invoking the BSR/BSF instruction, or
use a CMOV instruction afterwards.  Either the check involves a conditional
jump which we'd like to avoid, or a CMOV, which we'd also quite like to avoid.

Instead, we can make use of the fact that BSR/BSF doesn't modify its output
register if its input is 0.  By preloading the output with -1 and incrementing
the result, we achieve the desired result without the need for a conditional
check.

The 32-bit version of fls64() can also have all its conditional checks removed
by chaining BSRs with a subtraction in the middle.  However, this may be
suboptimal on CPUs for which BSR/BSF is really slow (i486 and below for
example).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/bitops.h |   79 ++++++++++++++++++++++++++---------------
 1 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..a8e85ab 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -394,18 +394,12 @@ static inline unsigned long __fls(unsigned long word)
  */
 static inline int ffs(int x)
 {
-	int r;
-#ifdef CONFIG_X86_CMOV
-	asm("bsfl %1,%0\n\t"
-	    "cmovzl %2,%0"
-	    : "=r" (r) : "rm" (x), "r" (-1));
-#else
-	asm("bsfl %1,%0\n\t"
-	    "jnz 1f\n\t"
-	    "movl $-1,%0\n"
-	    "1:" : "=r" (r) : "rm" (x));
-#endif
-	return r + 1;
+	int bitpos = -1;
+
+	asm("bsfl %1,%0"
+	    : "+r" (bitpos)
+	    : "rm" (x));
+	return bitpos + 1;
 }
 
 /**
@@ -421,19 +415,52 @@ static inline int ffs(int x)
  */
 static inline int fls(int x)
 {
-	int r;
-#ifdef CONFIG_X86_CMOV
-	asm("bsrl %1,%0\n\t"
-	    "cmovzl %2,%0"
-	    : "=&r" (r) : "rm" (x), "rm" (-1));
+	int bitpos = -1;
+
+	asm("bsrl %1,%0"
+	    : "+r" (bitpos)
+	    : "rm" (x));
+	return bitpos + 1;
+}
+
+/**
+ * fls64 - find last set bit in a 64-bit word
+ * @x: the word to search
+ *
+ * This is defined in a similar way as the libc and compiler builtin
+ * ffsll, but returns the position of the most significant set bit.
+ *
+ * fls64(value) returns 0 if value is 0 or the position of the last
+ * set bit if value is nonzero. The last (most significant) bit is
+ * at position 64.
+ */
+#if BITS_PER_LONG == 32
+static __always_inline int fls64(__u64 x)
+{
+	__u32 h = x >> 32;
+	int bitpos = -1;
+
+	asm("bsrl	%1,%0	\n"
+	    "subl	%2,%0	\n"
+	    "bsrl	%3,%0	\n"
+	    : "+r" (bitpos)
+	    : "rm" (x), "i"(32), "rm" (h));
+
+	return bitpos + 33;
+}
+#elif BITS_PER_LONG == 64
+static __always_inline int fls64(__u64 x)
+{
+	long bitpos = -1;
+
+	asm("bsrq %1,%0"
+	    : "+r" (bitpos)
+	    : "rm" (x));
+	return bitpos + 1;
+}
 #else
-	asm("bsrl %1,%0\n\t"
-	    "jnz 1f\n\t"
-	    "movl $-1,%0\n"
-	    "1:" : "=r" (r) : "rm" (x));
+#error BITS_PER_LONG not 32 or 64
 #endif
-	return r + 1;
-}
 #endif /* __KERNEL__ */
 
 #undef ADDR
@@ -446,12 +473,6 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/hweight.h>
 
-#endif /* __KERNEL__ */
-
-#include <asm-generic/bitops/fls64.h>
-
-#ifdef __KERNEL__
-
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock, nr, addr)			\

