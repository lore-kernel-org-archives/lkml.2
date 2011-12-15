Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab1LOX0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:26:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1LOX0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:26:20 -0500
Date: Thu, 15 Dec 2011 15:26:07 -0800
From: tip-bot for David Howells <dhowells@redhat.com>
Message-ID: <tip-ca3d30cc02f780f68771087040ce935add6ba2b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhowells@redhat.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20111213145654.14362.39868.stgit@warthog.procyon.org.uk>
References: <20111213145654.14362.39868.stgit@warthog.procyon.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86_64, asm: Optimise fls(), ffs() and fls64()
Git-Commit-ID: ca3d30cc02f780f68771087040ce935add6ba2b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Dec 2011 15:26:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca3d30cc02f780f68771087040ce935add6ba2b7
Gitweb:     http://git.kernel.org/tip/ca3d30cc02f780f68771087040ce935add6ba2b7
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Tue, 13 Dec 2011 14:56:54 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 15 Dec 2011 15:16:49 -0800

x86_64, asm: Optimise fls(), ffs() and fls64()

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

[ hpa: specifically, some 486 chips are known to NOT have this property. ]

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

[ hpa: changed the selection of 32 vs 64 bits to use CONFIG_X86_64
  instead of comparing BITS_PER_LONG, updated comments, rebased manually
  on top of 83d99df7c4bf x86, bitops: Move fls64.h inside __KERNEL__ ]

Signed-off-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20111213145654.14362.39868.stgit@warthog.procyon.org.uk
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/bitops.h |   67 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 4a6235b..b97596e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -397,10 +397,25 @@ static inline unsigned long __fls(unsigned long word)
 static inline int ffs(int x)
 {
 	int r;
-#ifdef CONFIG_X86_CMOV
+
+#ifdef CONFIG_X86_64
+	/*
+	 * AMD64 says BSFL won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before, except that the
+	 * top 32 bits will be cleared.
+	 *
+	 * We cannot do this on 32 bits because at the very least some
+	 * 486 CPUs did not behave this way.
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
@@ -424,7 +439,22 @@ static inline int ffs(int x)
 static inline int fls(int x)
 {
 	int r;
-#ifdef CONFIG_X86_CMOV
+
+#ifdef CONFIG_X86_64
+	/*
+	 * AMD64 says BSRL won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before, except that the
+	 * top 32 bits will be cleared.
+	 *
+	 * We cannot do this on 32 bits because at the very least some
+	 * 486 CPUs did not behave this way.
+	 */
+	long tmp = -1;
+	asm("bsrl %1,%0"
+	    : "=r" (r)
+	    : "rm" (x), "0" (tmp));
+#elif defined(CONFIG_X86_CMOV)
 	asm("bsrl %1,%0\n\t"
 	    "cmovzl %2,%0"
 	    : "=&r" (r) : "rm" (x), "rm" (-1));
@@ -437,6 +467,35 @@ static inline int fls(int x)
 	return r + 1;
 }
 
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
+#ifdef CONFIG_X86_64
+static __always_inline int fls64(__u64 x)
+{
+	long bitpos = -1;
+	/*
+	 * AMD64 says BSRQ won't clobber the dest reg if x==0; Intel64 says the
+	 * dest reg is undefined if x==0, but their CPU architect says its
+	 * value is written to set it to the same as before.
+	 */
+	asm("bsrq %1,%0"
+	    : "+r" (bitpos)
+	    : "rm" (x));
+	return bitpos + 1;
+}
+#else
+#include <asm-generic/bitops/fls64.h>
+#endif
+
 #include <asm-generic/bitops/find.h>
 
 #include <asm-generic/bitops/sched.h>
@@ -447,8 +506,6 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/const_hweight.h>
 
-#include <asm-generic/bitops/fls64.h>
-
 #include <asm-generic/bitops/le.h>
 
 #include <asm-generic/bitops/ext2-atomic-setbit.h>
