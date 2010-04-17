Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab0DQOHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 10:07:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0DQOHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 10:07:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] X86_64: Optimise fls(), ffs() and fls64() [ver #2]
To: torvalds@osdl.org, mingo@elte.hu, tglx@linutronix.de, matthew@wil.cx,
       arjan@infradead.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Sat, 17 Apr 2010 15:07:01 +0100
Message-ID: <20100417140701.15855.26978.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fls(N), ffs(N) and fls64(N) can be optimised on x86_64.  Currently they use a
CMOV instruction after the BSR/BSF to set the destination register to -1 if the
value to be scanned was 0 (in which case BSR/BSF set the Z flag).

Instead, according to the AMD64 specification, we can make use of the fact that
BSR/BSF doesn't modify its output register if its input is 0.  By preloading
the output with -1 and incrementing the result, we achieve the desired result
without the need for a conditional check.

The Intel x86_64 specification, however, says that the result of BSR/BSF in
such a case is undefined.  That said, when queried, one of the Intel CPU
architects said that the behaviour on all Intel CPUs is that:

 (1) with BSRQ/BSFQ, the 64-bit destination register is written with its
     original value if the source is 0, thus, in essence, giving the effect we
     want.  And,

 (2) with BSRL/BSFL, the lower half of the 64-bit destination register is
     written with its original value if the source is 0, and the upper half is
     cleared, thus giving us the effect we want (we return a 4-byte int).

Further, it was indicated that they (Intel) are unlikely to get away with
changing the behaviour.


It might be possible to optimise the 32-bit versions of these functions, but
there's a lot more variation, and so the effective non-destructive property of
BSRL/BSRF cannot be relied on.


I have benchmarked these functions on my Core2 Duo test machine using the
following program:

	#include <stdlib.h>
	#include <stdio.h>

	#ifndef __x86_64__
	#error
	#endif

	#define PAGE_SHIFT 12

	typedef unsigned long long __u64, u64;
	typedef unsigned int __u32, u32;
	#define noinline	__attribute__((noinline))

	static __always_inline int fls64(__u64 x)
	{
		long bitpos = -1;

		asm("bsrq %1,%0"
		    : "+r" (bitpos)
		    : "rm" (x));
		return bitpos + 1;
	}

	static inline unsigned long __fls(unsigned long word)
	{
		asm("bsr %1,%0"
		    : "=r" (word)
		    : "rm" (word));
		return word;
	}
	static __always_inline int old_fls64(__u64 x)
	{
		if (x == 0)
			return 0;
		return __fls(x) + 1;
	}

	static noinline // __attribute__((const))
	int old_get_order(unsigned long size)
	{
		int order;

		size = (size - 1) >> (PAGE_SHIFT - 1);
		order = -1;
		do {
			size >>= 1;
			order++;
		} while (size);
		return order;
	}

	static inline __attribute__((const))
	int get_order_old_fls64(unsigned long size)
	{
		int order;
		size--;
		size >>= PAGE_SHIFT;
		order = old_fls64(size);
		return order;
	}

	static inline __attribute__((const))
	int get_order(unsigned long size)
	{
		int order;
		size--;
		size >>= PAGE_SHIFT;
		order = fls64(size);
		return order;
	}

	unsigned long prevent_optimise_out;

	static noinline unsigned long test_old_get_order(void)
	{
		unsigned long n, total = 0;
		long rep, loop;

		for (rep = 1000000; rep > 0; rep--) {
			for (loop = 0; loop <= 16384; loop += 4) {
				n = 1UL << loop;
				total += old_get_order(n);
			}
		}
		return total;
	}

	static noinline unsigned long test_get_order_old_fls64(void)
	{
		unsigned long n, total = 0;
		long rep, loop;

		for (rep = 1000000; rep > 0; rep--) {
			for (loop = 0; loop <= 16384; loop += 4) {
				n = 1UL << loop;
				total += get_order_old_fls64(n);
			}
		}
		return total;
	}

	static noinline unsigned long test_get_order(void)
	{
		unsigned long n, total = 0;
		long rep, loop;

		for (rep = 1000000; rep > 0; rep--) {
			for (loop = 0; loop <= 16384; loop += 4) {
				n = 1UL << loop;
				total += get_order(n);
			}
		}
		return total;
	}

	int main(int argc, char **argv)
	{
		unsigned long total;

		switch (argc) {
		case 1:  total = test_old_get_order();		break;
		case 2:  total = test_get_order_old_fls64();	break;
		default: total = test_get_order();		break;
		}
		prevent_optimise_out = total;
		return 0;
	}

This allows me to test the use of the old fls64() implementation and the new
fls64() implementation and also to contrast these to the out-of-line loop-based
implementation of get_order().  The results were:

	warthog>time ./get_order
	real    1m37.191s
	user    1m36.313s
	sys     0m0.861s
	warthog>time ./get_order x
	real    0m16.892s
	user    0m16.586s
	sys     0m0.287s
	warthog>time ./get_order x x
	real    0m7.731s
	user    0m7.727s
	sys     0m0.002s

Using the current upstream fls64() as a basis for an inlined get_order() [the
second result above] is much faster than using the current out-of-line
loop-based get_order() [the first result above].

Using my optimised inline fls64()-based get_order() [the third result above]
is even faster still.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/bitops.h |   65 +++++++++++++++++++++++++++++++++++------
 1 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..a57b4b1 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -395,10 +395,21 @@ static inline unsigned long __fls(unsigned long word)
 static inline int ffs(int x)
 {
 	int r;
-#ifdef CONFIG_X86_CMOV
+
+#if BITS_PER_LONG == 64
+	/* AMD64 says BSFL won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before, except that the
+	 * top 32-bits will be cleared.
+	 */
+	long tmp = -1;
+	asm("bsfl %1,%0"
+	    : "=r" (r)
+	    : "rm" (x), "0" (tmp));
+#elif defined(CONFIG_X86_CMOV)
 	asm("bsfl %1,%0\n\t"
 	    "cmovzl %2,%0"
-	    : "=r" (r) : "rm" (x), "r" (-1));
+	    : "=&r" (r) : "rm" (x), "r" (-1));
 #else
 	asm("bsfl %1,%0\n\t"
 	    "jnz 1f\n\t"
@@ -422,7 +433,18 @@ static inline int ffs(int x)
 static inline int fls(int x)
 {
 	int r;
-#ifdef CONFIG_X86_CMOV
+
+#if BITS_PER_LONG == 64
+	/* AMD64 says BSRL won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before, except that the
+	 * top 32-bits will be cleared.
+	 */
+	long tmp = -1;
+	asm("bsrl %1,%0"
+	    : "=r" (r)
+	    : "rm" (x), "0" (tmp));
+#elif defined(CONFIG_X86_CMOV)
 	asm("bsrl %1,%0\n\t"
 	    "cmovzl %2,%0"
 	    : "=&r" (r) : "rm" (x), "rm" (-1));
@@ -434,10 +456,41 @@ static inline int fls(int x)
 #endif
 	return r + 1;
 }
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
+#if BITS_PER_LONG == 64
+static __always_inline int fls64(__u64 x)
+{
+	long bitpos = -1;
+
+	/* AMD64 says BSRQ won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before.
+	 */
+	asm("bsrq %1,%0"
+	    : "+r" (bitpos)
+	    : "rm" (x));
+	return bitpos + 1;
+}
+#endif
 #endif /* __KERNEL__ */
 
 #undef ADDR
 
+#if BITS_PER_LONG == 32
+#include <asm-generic/bitops/fls64.h>
+#endif
+
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/sched.h>
@@ -446,12 +499,6 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/hweight.h>
 
-#endif /* __KERNEL__ */
-
-#include <asm-generic/bitops/fls64.h>
-
-#ifdef __KERNEL__
-
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
 #define ext2_set_bit_atomic(lock, nr, addr)			\

