Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1CRI5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:57:14 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35765 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab1CRI4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:56:55 -0400
Date: Fri, 18 Mar 2011 09:56:49 +0100
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH RFC] consolidate *_le_bit operations [was linux-next: build
 failure after merge of the final tree (block tree  related)]
Message-ID: <20110318085649.GA28441@barkeeper1-xen.linbit>
References: <20110311175830.29a387b2.sfr@canb.auug.org.au>
 <4D79CB66.2020302@kernel.dk>
 <20110317103131.6c6be7a5.sfr@canb.auug.org.au>
 <4D81DFA4.7000204@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D81DFA4.7000204@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CC'ing fsdevel,
because ext2 and minix bit operations are affected
by the proposed patch.

On Thu, Mar 17, 2011 at 11:17:08AM +0100, Jens Axboe wrote:
> On 2011-03-17 00:31, Stephen Rothwell wrote:
> > Hi Jens,
> > 
> > On Fri, 11 Mar 2011 08:12:38 +0100 Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 2011-03-11 07:58, Stephen Rothwell wrote:
> >>>
> >>> After merging the final tree, today's linux-next build (powerpc
> >>> allyesconfig) failed like this:
> >>>
> >>> drivers/char/tpm/tpm_tis.c:96: warning: 'is_itpm' defined but not used
> >>> drivers/block/drbd/drbd_bitmap.c: In function '__bm_change_bits_to':
> >>> drivers/block/drbd/drbd_bitmap.c:1287: error: implicit declaration of function 'generic___test_and_set_le_bit'
> >>> drivers/block/drbd/drbd_bitmap.c:1289: error: implicit declaration of function 'generic___test_and_clear_le_bit'
> >>> drivers/block/drbd/drbd_bitmap.c: In function 'drbd_bm_test_bit':
> >>> drivers/block/drbd/drbd_bitmap.c:1438: error: implicit declaration of function 'generic_test_le_bit'
> >>>
> >>> Caused by commit 4b0715f09655 ("drbd: allow petabyte storage on 64bit
> >>> arch").
> >>>
> >>> I have applied this patch for today (surely there is a better way):

...  explicitly including 
+#include <asm-generic/bitops/le.h>

That fix is fine for DRBD from my perspective.
I'm not sure how to "measure" "better" here.
But see below.

> >> Thanks for not dropping it, I'll let the drbd guys send in a proper fix
> >> and get it committed.
> > 
> > Ping?
> 
> Lars, please send me a fix for this ASAP. It's holding up the block
> merge.
> 
> -- 
> Jens Axboe
> 

Thing is, on most architectures,
we get asm-generic/bitops/le.h included implicitly.
On some, it is missing, because they decide to provide their own
re-implementation of those generic defines/functions.

let me try this:

  # git grep asm-generic/bitops/le.h
  include/asm-generic/bitops/ext2-non-atomic.h:#include <asm-generic/bitops/le.h>
  include/asm-generic/bitops/minix-le.h:#include <asm-generic/bitops/le.h>
  net/ipv6/ip6_fib.c:      * See include/asm-generic/bitops/le.h.
  net/rds/cong.c:#include <asm-generic/bitops/le.h>
  virt/kvm/kvm_main.c:#include <asm-generic/bitops/le.h>

Seems to be unusual to include this directly. But

  # git grep asm-generic/bitops/ext2-non-atomic.h
  gives: include/asm-generic/bitops.h, as well as all arch/*/include/asm/bitops.h,
  except a few. Let's see

  # grep -L -E 'asm-generic/bitops(|/(ext2-non-atomic|le))\.h' arch/*/include/asm/bitops.h | cut -d/ -f2
  arm m68k powerpc s390 sparc
  where m68k is probably a false hit, see arch/m68k/include/asm/bitops_{mm,no}.h


What should we do?
add "#include <asm-generic/bitops.h>" or "#include <asm-generic/bitops/ext2-non-atomic.h>"
or something else that includes .../le.h implicitly to
arch/{arm,powerpc,s390,sparc}/include/asm/bitops.h as well?

Now, while I was trying to do that,
I got the impression that many LOC could be saved
by replacing repeated implementations in arch/*/bitops.h
with
#include <asm-generic/bitops/ext2-non-atomic.h>
#include <asm-generic/bitops/minix-le.h>

Some #define ext2_set_bit_atomic() would be left over.
E.g. powerpc does
#define ext2_clear_bit_atomic(lock, nr, addr) \
	test_and_clear_le_bit((nr), (unsigned long*)addr)

while asm-generic/bitops/ext2-atomic.h actually does
#define ext2_clear_bit_atomic(lock, nr, addr)		\
	({						\
		int ret;				\
		spin_lock(lock);			\
		ret = ext2_clear_bit((nr), (unsigned long *)(addr)); \
		spin_unlock(lock);			\
		ret;					\
	})

Now, I wonder why some architectures would need and use that spinlock,
if they can do test_and_clear_bit in their native endian just fine?

Why is this not generally defined as
#define ext2_clear_bit_atomic(lock, nr, addr) \
	generic_test_and_clear_le_bit(nr, addr)
(or
	generic_test_and_clear_le_bit((nr), (unsigned long*)(addr))
for that matter)?

How would that be less atomic?
I am probably missing something, so please educate me.

BTW, arch/s390/include/asm/bitops.h (and sparc,m68k) looks fishy to me:
#include <asm-generic/bitops/minix.h> should probably be
#include <asm-generic/bitops/minix-le.h>

or is it ok if they expect the minix bit operations to be native endian?

Why would that be ok for some archs, but not others?

Proposed patch below, I hope I did not remove too much lines ;-)

As mentioned, I'm unsure about the occurrences of
minix.h vs minix-le.h.  The help poor souls like me,
at least they deserve a comment when to use which and why.

On parisc, I moved the include of minix-le.h inside the __KERNEL__
protection, to match the other architectures.

In a further cleanup step, we could get rid of all those lock arguments
to ext2_*_atomic.

What do you think?

	Lars

---
 arch/alpha/include/asm/bitops.h          |    5 +-
 arch/arm/include/asm/bitops.h            |   38 +--------
 arch/cris/include/asm/bitops.h           |    5 +-
 arch/frv/include/asm/bitops.h            |    5 +-
 arch/ia64/include/asm/bitops.h           |    5 +-
 arch/m68k/include/asm/bitops_mm.h        |  138 +-----------------------------
 arch/m68k/include/asm/bitops_no.h        |  134 +----------------------------
 arch/mn10300/include/asm/bitops.h        |    6 +-
 arch/parisc/include/asm/bitops.h         |   12 +--
 arch/powerpc/include/asm/bitops.h        |   68 +--------------
 arch/s390/include/asm/bitops.h           |  106 +----------------------
 arch/sparc/include/asm/bitops_32.h       |    2 +-
 arch/sparc/include/asm/bitops_64.h       |    9 +--
 arch/x86/include/asm/bitops.h            |    7 +--
 arch/xtensa/include/asm/bitops.h         |   15 +---
 include/asm-generic/bitops/ext2-atomic.h |   21 +----
 16 files changed, 32 insertions(+), 544 deletions(-)

diff --git a/include/asm-generic/bitops/ext2-atomic.h b/include/asm-generic/bitops/ext2-atomic.h
index ab1c875..79d6c05 100644
--- a/include/asm-generic/bitops/ext2-atomic.h
+++ b/include/asm-generic/bitops/ext2-atomic.h
@@ -1,22 +1,11 @@
 #ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 #define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
 
-#define ext2_set_bit_atomic(lock, nr, addr)		\
-	({						\
-		int ret;				\
-		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (unsigned long *)(addr)); \
-		spin_unlock(lock);			\
-		ret;					\
-	})
+#include <asm-generic/bitops/le.h>
 
-#define ext2_clear_bit_atomic(lock, nr, addr)		\
-	({						\
-		int ret;				\
-		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (unsigned long *)(addr)); \
-		spin_unlock(lock);			\
-		ret;					\
-	})
+#define ext2_set_bit_atomic(lock,nr,p)          \
+	generic_test_and_set_le_bit((nr),(unsigned long*)(p))
+#define ext2_clear_bit_atomic(lock,nr,p)        \
+	generic_test_and_clear_le_bit((nr),(unsigned long*)(p))
 
 #endif /* _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_ */
diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
index adfab8a..9473ad4 100644
--- a/arch/alpha/include/asm/bitops.h
+++ b/arch/alpha/include/asm/bitops.h
@@ -455,10 +455,7 @@ sched_find_first_bit(const unsigned long b[2])
 }
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
-
+#include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index af54ed1..1ac7ffe 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -287,41 +287,9 @@ static inline int fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-/*
- * Ext2 is defined to use little-endian byte ordering.
- * These do not need to be atomic.
- */
-#define ext2_set_bit(nr,p)			\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_set_bit_atomic(lock,nr,p)          \
-                test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_clear_bit(nr,p)			\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_clear_bit_atomic(lock,nr,p)        \
-                test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define ext2_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
-#define ext2_find_next_zero_bit(p,sz,off)	\
-		_find_next_zero_bit_le(p,sz,off)
-#define ext2_find_next_bit(p, sz, off) \
-		_find_next_bit_le(p, sz, off)
-
-/*
- * Minix is defined to use little-endian byte ordering.
- * These do not need to be atomic.
- */
-#define minix_set_bit(nr,p)			\
-		__set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_test_bit(nr,p)			\
-		test_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_test_and_set_bit(nr,p)		\
-		__test_and_set_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_test_and_clear_bit(nr,p)		\
-		__test_and_clear_bit(WORD_BITOFF_TO_LE(nr), (unsigned long *)(p))
-#define minix_find_first_zero_bit(p,sz)		\
-		_find_first_zero_bit_le(p,sz)
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 9e69cfb..b4f2e42 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -155,10 +155,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
-
+#include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
 
diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
index 50ae91b..04f743d 100644
--- a/arch/frv/include/asm/bitops.h
+++ b/arch/frv/include/asm/bitops.h
@@ -402,10 +402,7 @@ int __ilog2_u64(u64 n)
 #include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
-#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
-
+#include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index 9da3df6..ab03fdd 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -457,10 +457,7 @@ static __inline__ unsigned long __arch_hweight64(unsigned long x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
-#define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
-
+#include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 #include <asm-generic/bitops/sched.h>
 
diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
index b4ecdaa..d0c3cdc 100644
--- a/arch/m68k/include/asm/bitops_mm.h
+++ b/arch/m68k/include/asm/bitops_mm.h
@@ -325,141 +325,9 @@ static inline int __fls(int x)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-/* Bitmap functions for the minix filesystem */
-
-static inline int minix_find_first_zero_bit(const void *vaddr, unsigned size)
-{
-	const unsigned short *p = vaddr, *addr = vaddr;
-	int res;
-	unsigned short num;
-
-	if (!size)
-		return 0;
-
-	size = (size >> 4) + ((size & 15) > 0);
-	while (*p++ == 0xffff)
-	{
-		if (--size == 0)
-			return (p - addr) << 4;
-	}
-
-	num = ~*--p;
-	__asm__ __volatile__ ("bfffo %1{#16,#16},%0"
-			      : "=d" (res) : "d" (num & -num));
-	return ((p - addr) << 4) + (res ^ 31);
-}
-
-#define minix_test_and_set_bit(nr, addr)	__test_and_set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_set_bit(nr,addr)			__set_bit((nr) ^ 16, (unsigned long *)(addr))
-#define minix_test_and_clear_bit(nr, addr)	__test_and_clear_bit((nr) ^ 16, (unsigned long *)(addr))
-
-static inline int minix_test_bit(int nr, const void *vaddr)
-{
-	const unsigned short *p = vaddr;
-	return (p[nr >> 4] & (1U << (nr & 15))) != 0;
-}
-
-/* Bitmap functions for the ext2 filesystem. */
-
-#define ext2_set_bit(nr, addr)			__test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_set_bit_atomic(lock, nr, addr)	test_and_set_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit(nr, addr)		__test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)	test_and_clear_bit((nr) ^ 24, (unsigned long *)(addr))
-#define ext2_find_next_zero_bit(addr, size, offset) \
-	generic_find_next_zero_le_bit((unsigned long *)addr, size, offset)
-#define ext2_find_next_bit(addr, size, offset) \
-	generic_find_next_le_bit((unsigned long *)addr, size, offset)
-
-static inline int ext2_test_bit(int nr, const void *vaddr)
-{
-	const unsigned char *p = vaddr;
-	return (p[nr >> 3] & (1U << (nr & 7))) != 0;
-}
-
-static inline int ext2_find_first_zero_bit(const void *vaddr, unsigned size)
-{
-	const unsigned long *p = vaddr, *addr = vaddr;
-	int res;
-
-	if (!size)
-		return 0;
-
-	size = (size >> 5) + ((size & 31) > 0);
-	while (*p++ == ~0UL)
-	{
-		if (--size == 0)
-			return (p - addr) << 5;
-	}
-
-	--p;
-	for (res = 0; res < 32; res++)
-		if (!ext2_test_bit (res, p))
-			break;
-	return (p - addr) * 32 + res;
-}
-
-static inline unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset)
-{
-	const unsigned long *p = addr + (offset >> 5);
-	int bit = offset & 31UL, res;
-
-	if (offset >= size)
-		return size;
-
-	if (bit) {
-		/* Look for zero in first longword */
-		for (res = bit; res < 32; res++)
-			if (!ext2_test_bit (res, p))
-				return (p - addr) * 32 + res;
-		p++;
-	}
-	/* No zero yet, search remaining full bytes for a zero */
-	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
-	return (p - addr) * 32 + res;
-}
-
-static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
-{
-	const unsigned long *p = vaddr, *addr = vaddr;
-	int res;
-
-	if (!size)
-		return 0;
-
-	size = (size >> 5) + ((size & 31) > 0);
-	while (*p++ == 0UL) {
-		if (--size == 0)
-			return (p - addr) << 5;
-	}
-
-	--p;
-	for (res = 0; res < 32; res++)
-		if (ext2_test_bit(res, p))
-			break;
-	return (p - addr) * 32 + res;
-}
-
-static inline unsigned long generic_find_next_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset)
-{
-	const unsigned long *p = addr + (offset >> 5);
-	int bit = offset & 31UL, res;
-
-	if (offset >= size)
-		return size;
-
-	if (bit) {
-		/* Look for one in first longword */
-		for (res = bit; res < 32; res++)
-			if (ext2_test_bit(res, p))
-				return (p - addr) * 32 + res;
-		p++;
-	}
-	/* No set bit yet, search remaining full bytes for a set bit */
-	res = ext2_find_first_bit(p, size - 32 * (p - addr));
-	return (p - addr) * 32 + res;
-}
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
index 9d3cbe5..cc7e2fd 100644
--- a/arch/m68k/include/asm/bitops_no.h
+++ b/arch/m68k/include/asm/bitops_no.h
@@ -196,137 +196,9 @@ static __inline__ int __test_bit(int nr, const volatile unsigned long * addr)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-static __inline__ int ext2_set_bit(int nr, volatile void * addr)
-{
-	char retval;
-
-#ifdef CONFIG_COLDFIRE
-	__asm__ __volatile__ ("lea %1,%%a0; bset %2,(%%a0); sne %0"
-	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
-	     : "d" (nr)
-	     : "%a0");
-#else
-	__asm__ __volatile__ ("bset %2,%1; sne %0"
-	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
-	     : "di" (nr)
-	     /* No clobber */);
-#endif
-
-	return retval;
-}
-
-static __inline__ int ext2_clear_bit(int nr, volatile void * addr)
-{
-	char retval;
-
-#ifdef CONFIG_COLDFIRE
-	__asm__ __volatile__ ("lea %1,%%a0; bclr %2,(%%a0); sne %0"
-	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
-	     : "d" (nr)
-	     : "%a0");
-#else
-	__asm__ __volatile__ ("bclr %2,%1; sne %0"
-	     : "=d" (retval), "+m" (((volatile char *)addr)[nr >> 3])
-	     : "di" (nr)
-	     /* No clobber */);
-#endif
-
-	return retval;
-}
-
-#define ext2_set_bit_atomic(lock, nr, addr)		\
-	({						\
-		int ret;				\
-		spin_lock(lock);			\
-		ret = ext2_set_bit((nr), (addr));	\
-		spin_unlock(lock);			\
-		ret;					\
-	})
-
-#define ext2_clear_bit_atomic(lock, nr, addr)		\
-	({						\
-		int ret;				\
-		spin_lock(lock);			\
-		ret = ext2_clear_bit((nr), (addr));	\
-		spin_unlock(lock);			\
-		ret;					\
-	})
-
-static __inline__ int ext2_test_bit(int nr, const volatile void * addr)
-{
-	char retval;
-
-#ifdef CONFIG_COLDFIRE
-	__asm__ __volatile__ ("lea %1,%%a0; btst %2,(%%a0); sne %0"
-	     : "=d" (retval)
-	     : "m" (((const volatile char *)addr)[nr >> 3]), "d" (nr)
-	     : "%a0");
-#else
-	__asm__ __volatile__ ("btst %2,%1; sne %0"
-	     : "=d" (retval)
-	     : "m" (((const volatile char *)addr)[nr >> 3]), "di" (nr)
-	     /* No clobber */);
-#endif
-
-	return retval;
-}
-
-#define ext2_find_first_zero_bit(addr, size) \
-        ext2_find_next_zero_bit((addr), (size), 0)
-
-static __inline__ unsigned long ext2_find_next_zero_bit(void *addr, unsigned long size, unsigned long offset)
-{
-	unsigned long *p = ((unsigned long *) addr) + (offset >> 5);
-	unsigned long result = offset & ~31UL;
-	unsigned long tmp;
-
-	if (offset >= size)
-		return size;
-	size -= result;
-	offset &= 31UL;
-	if(offset) {
-		/* We hold the little endian value in tmp, but then the
-		 * shift is illegal. So we could keep a big endian value
-		 * in tmp, like this:
-		 *
-		 * tmp = __swab32(*(p++));
-		 * tmp |= ~0UL >> (32-offset);
-		 *
-		 * but this would decrease performance, so we change the
-		 * shift:
-		 */
-		tmp = *(p++);
-		tmp |= __swab32(~0UL >> (32-offset));
-		if(size < 32)
-			goto found_first;
-		if(~tmp)
-			goto found_middle;
-		size -= 32;
-		result += 32;
-	}
-	while(size & ~31UL) {
-		if(~(tmp = *(p++)))
-			goto found_middle;
-		result += 32;
-		size -= 32;
-	}
-	if(!size)
-		return result;
-	tmp = *p;
-
-found_first:
-	/* tmp is little endian, so we would have to swab the shift,
-	 * see above. But then we have to swab tmp below for ffz, so
-	 * we might as well do this here.
-	 */
-	return result + ffz(__swab32(tmp) | (~0UL << size));
-found_middle:
-	return result + ffz(__swab32(tmp));
-}
-
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
-#include <asm-generic/bitops/minix.h>
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 3b8a868..637df7a 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -228,12 +228,8 @@ int ffs(int x)
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
 
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_bit((nr), (addr))
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_bit((nr), (addr))
-
 #include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
index 7a6ea10..8e2a6da 100644
--- a/arch/parisc/include/asm/bitops.h
+++ b/arch/parisc/include/asm/bitops.h
@@ -223,17 +223,9 @@ static __inline__ int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-/* '3' is bits per byte */
-#define LE_BYTE_ADDR ((sizeof(unsigned long) - 1) << 3)
-
-#define ext2_set_bit_atomic(l,nr,addr) \
-		test_and_set_bit((nr)   ^ LE_BYTE_ADDR, (unsigned long *)addr)
-#define ext2_clear_bit_atomic(l,nr,addr) \
-		test_and_clear_bit( (nr) ^ LE_BYTE_ADDR, (unsigned long *)addr)
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix-le.h>
 
 #endif	/* __KERNEL__ */
 
-#include <asm-generic/bitops/minix-le.h>
-
 #endif /* _PARISC_BITOPS_H */
diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index 8a7e931..2304871 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -278,71 +278,9 @@ unsigned long __arch_hweight64(__u64 w);
 #endif
 
 #include <asm-generic/bitops/find.h>
-
-/* Little-endian versions */
-
-static __inline__ int test_le_bit(unsigned long nr,
-				  __const__ unsigned long *addr)
-{
-	__const__ unsigned char	*tmp = (__const__ unsigned char *) addr;
-	return (tmp[nr >> 3] >> (nr & 7)) & 1;
-}
-
-#define __set_le_bit(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __clear_le_bit(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define test_and_set_le_bit(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define test_and_clear_le_bit(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define __test_and_set_le_bit(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define __test_and_clear_le_bit(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define find_first_zero_le_bit(addr, size) generic_find_next_zero_le_bit((addr), (size), 0)
-unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
-				    unsigned long size, unsigned long offset);
-
-unsigned long generic_find_next_le_bit(const unsigned long *addr,
-				    unsigned long size, unsigned long offset);
-/* Bitmap functions for the ext2 filesystem */
-
-#define ext2_set_bit(nr,addr) \
-	__test_and_set_le_bit((nr), (unsigned long*)addr)
-#define ext2_clear_bit(nr, addr) \
-	__test_and_clear_le_bit((nr), (unsigned long*)addr)
-
-#define ext2_set_bit_atomic(lock, nr, addr) \
-	test_and_set_le_bit((nr), (unsigned long*)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr) \
-	test_and_clear_le_bit((nr), (unsigned long*)addr)
-
-#define ext2_test_bit(nr, addr)      test_le_bit((nr),(unsigned long*)addr)
-
-#define ext2_find_first_zero_bit(addr, size) \
-	find_first_zero_le_bit((unsigned long*)addr, size)
-#define ext2_find_next_zero_bit(addr, size, off) \
-	generic_find_next_zero_le_bit((unsigned long*)addr, size, off)
-
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)addr, size, off)
-/* Bitmap functions for the minix filesystem.  */
-
-#define minix_test_and_set_bit(nr,addr) \
-	__test_and_set_le_bit(nr, (unsigned long *)addr)
-#define minix_set_bit(nr,addr) \
-	__set_le_bit(nr, (unsigned long *)addr)
-#define minix_test_and_clear_bit(nr,addr) \
-	__test_and_clear_le_bit(nr, (unsigned long *)addr)
-#define minix_test_bit(nr,addr) \
-	test_le_bit(nr, (unsigned long *)addr)
-
-#define minix_find_first_zero_bit(addr,size) \
-	find_first_zero_le_bit((unsigned long *)addr, size)
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix-le.h>
 
 #include <asm-generic/bitops/sched.h>
 
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 2e05972..e74bf28 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -732,109 +732,9 @@ static inline int sched_find_first_bit(unsigned long *b)
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
 
-/*
- * ATTENTION: intel byte ordering convention for ext2 and minix !!
- * bit 0 is the LSB of addr; bit 31 is the MSB of addr;
- * bit 32 is the LSB of (addr+4).
- * That combined with the little endian byte order of Intel gives the
- * following bit order in memory:
- *    07 06 05 04 03 02 01 00 15 14 13 12 11 10 09 08 \
- *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
- */
-
-#define ext2_set_bit(nr, addr)       \
-	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_set_bit_atomic(lock, nr, addr)       \
-	test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_clear_bit(nr, addr)     \
-	__test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_clear_bit_atomic(lock, nr, addr)     \
-	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_test_bit(nr, addr)      \
-	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-
-static inline int ext2_find_first_zero_bit(void *vaddr, unsigned int size)
-{
-	unsigned long bytes, bits;
-
-        if (!size)
-                return 0;
-	bytes = __ffz_word_loop(vaddr, size);
-	bits = __ffz_word(bytes*8, __load_ulong_le(vaddr, bytes));
-	return (bits < size) ? bits : size;
-}
-
-static inline int ext2_find_next_zero_bit(void *vaddr, unsigned long size,
-					  unsigned long offset)
-{
-        unsigned long *addr = vaddr, *p;
-	unsigned long bit, set;
-
-        if (offset >= size)
-                return size;
-	bit = offset & (__BITOPS_WORDSIZE - 1);
-	offset -= bit;
-	size -= offset;
-	p = addr + offset / __BITOPS_WORDSIZE;
-        if (bit) {
-		/*
-		 * s390 version of ffz returns __BITOPS_WORDSIZE
-		 * if no zero bit is present in the word.
-		 */
-		set = __ffz_word(bit, __load_ulong_le(p, 0) >> bit);
-		if (set >= size)
-			return size + offset;
-		if (set < __BITOPS_WORDSIZE)
-			return set + offset;
-		offset += __BITOPS_WORDSIZE;
-		size -= __BITOPS_WORDSIZE;
-		p++;
-        }
-	return offset + ext2_find_first_zero_bit(p, size);
-}
-
-static inline unsigned long ext2_find_first_bit(void *vaddr,
-						unsigned long size)
-{
-	unsigned long bytes, bits;
-
-	if (!size)
-		return 0;
-	bytes = __ffs_word_loop(vaddr, size);
-	bits = __ffs_word(bytes*8, __load_ulong_le(vaddr, bytes));
-	return (bits < size) ? bits : size;
-}
-
-static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
-				     unsigned long offset)
-{
-	unsigned long *addr = vaddr, *p;
-	unsigned long bit, set;
-
-	if (offset >= size)
-		return size;
-	bit = offset & (__BITOPS_WORDSIZE - 1);
-	offset -= bit;
-	size -= offset;
-	p = addr + offset / __BITOPS_WORDSIZE;
-	if (bit) {
-		/*
-		 * s390 version of ffz returns __BITOPS_WORDSIZE
-		 * if no zero bit is present in the word.
-		 */
-		set = __ffs_word(0, __load_ulong_le(p, 0) & (~0UL << bit));
-		if (set >= size)
-			return size + offset;
-		if (set < __BITOPS_WORDSIZE)
-			return set + offset;
-		offset += __BITOPS_WORDSIZE;
-		size -= __BITOPS_WORDSIZE;
-		p++;
-	}
-	return offset + ext2_find_first_bit(p, size);
-}
-
-#include <asm-generic/bitops/minix.h>
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sparc/include/asm/bitops_32.h b/arch/sparc/include/asm/bitops_32.h
index 9cf4ae0..f84c6d3 100644
--- a/arch/sparc/include/asm/bitops_32.h
+++ b/arch/sparc/include/asm/bitops_32.h
@@ -105,7 +105,7 @@ static inline void change_bit(unsigned long nr, volatile unsigned long *addr)
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
-#include <asm-generic/bitops/minix.h>
+#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index 766121a..cb42dc6 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -90,13 +90,8 @@ static inline unsigned int __arch_hweight8(unsigned int w)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock,nr,addr) \
-	test_and_set_bit((nr) ^ 0x38,(unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock,nr,addr) \
-	test_and_clear_bit((nr) ^ 0x38,(unsigned long *)(addr))
-
-#include <asm-generic/bitops/minix.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix-le.h>
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 903683b..42b8401 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -457,12 +457,7 @@ static inline int fls(int x)
 #ifdef __KERNEL__
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock, nr, addr)			\
-	test_and_set_bit((nr), (unsigned long *)(addr))
-#define ext2_clear_bit_atomic(lock, nr, addr)			\
-	test_and_clear_bit((nr), (unsigned long *)(addr))
-
+#include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index 6c39303..355af09 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -107,20 +107,7 @@ static inline unsigned long __fls(unsigned long word)
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
-
-#ifdef __XTENSA_EL__
-# define ext2_set_bit_atomic(lock,nr,addr)				\
-	test_and_set_bit((nr), (unsigned long*)(addr))
-# define ext2_clear_bit_atomic(lock,nr,addr)				\
-	test_and_clear_bit((nr), (unsigned long*)(addr))
-#elif defined(__XTENSA_EB__)
-# define ext2_set_bit_atomic(lock,nr,addr)				\
-	test_and_set_bit((nr) ^ 0x18, (unsigned long*)(addr))
-# define ext2_clear_bit_atomic(lock,nr,addr)				\
-	test_and_clear_bit((nr) ^ 0x18, (unsigned long*)(addr))
-#else
-# error processor byte order undefined!
-#endif
+#include <asm-generic/bitops/ext2-atomic.h>
 
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/lock.h>
