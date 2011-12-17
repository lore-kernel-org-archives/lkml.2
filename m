Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab1LQHz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:55:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60312 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1LQHzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:55:21 -0500
Date: Fri, 16 Dec 2011 23:55:13 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Naveen Yadav <yad.naveen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] rtth: fix 32-bit build
In-Reply-To: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1112162354060.1981@eggly.anvils>
References: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtth has BITS_PER_LONG 64 hard-coded, and so quickly crashes with
Segmentation fault when built 32-bit: fix to depend on sizeof(long).

But then what should we do about the #ifdef BITS_PER_LONG == 64
in linux/bitops/__ffs.h, and the "right shift count >= width of type"
warning we still get if it's a runtime check?  Oh, delete all of that,
the only thing we need is non-atomic.h, which might as well be copied
directly to bitops.h.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 linux/bitops.h            |  122 +++++++++++++++++++++++++++++++-----
 linux/bitops/__ffs.h      |   43 ------------
 linux/bitops/ffs.h        |   41 ------------
 linux/bitops/ffz.h        |   12 ---
 linux/bitops/find.h       |   13 ---
 linux/bitops/fls.h        |   41 ------------
 linux/bitops/fls64.h      |   14 ----
 linux/bitops/hweight.h    |   11 ---
 linux/bitops/le.h         |   53 ---------------
 linux/bitops/non-atomic.h |  111 --------------------------------
 linux/types.h             |    2 
 11 files changed, 108 insertions(+), 355 deletions(-)

--- rtth1/linux/bitops/__ffs.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/__ffs.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,43 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS___FFS_H_
-#define _ASM_GENERIC_BITOPS___FFS_H_
-
-#include <asm/types.h>
-
-/**
- * __ffs - find first bit in word.
- * @word: The word to search
- *
- * Undefined if no bit exists, so code should check against 0 first.
- */
-static inline unsigned long __ffs(unsigned long word)
-{
-	int num = 0;
-
-#if BITS_PER_LONG == 64
-	if ((word & 0xffffffff) == 0) {
-		num += 32;
-		word >>= 32;
-	}
-#endif
-	if ((word & 0xffff) == 0) {
-		num += 16;
-		word >>= 16;
-	}
-	if ((word & 0xff) == 0) {
-		num += 8;
-		word >>= 8;
-	}
-	if ((word & 0xf) == 0) {
-		num += 4;
-		word >>= 4;
-	}
-	if ((word & 0x3) == 0) {
-		num += 2;
-		word >>= 2;
-	}
-	if ((word & 0x1) == 0)
-		num += 1;
-	return num;
-}
-
-#endif /* _ASM_GENERIC_BITOPS___FFS_H_ */
--- rtth1/linux/bitops/ffs.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/ffs.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,41 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_FFS_H_
-#define _ASM_GENERIC_BITOPS_FFS_H_
-
-/**
- * ffs - find first bit set
- * @x: the word to search
- *
- * This is defined the same way as
- * the libc and compiler builtin ffs routines, therefore
- * differs in spirit from the above ffz (man ffs).
- */
-static inline int ffs(int x)
-{
-	int r = 1;
-
-	if (!x)
-		return 0;
-	if (!(x & 0xffff)) {
-		x >>= 16;
-		r += 16;
-	}
-	if (!(x & 0xff)) {
-		x >>= 8;
-		r += 8;
-	}
-	if (!(x & 0xf)) {
-		x >>= 4;
-		r += 4;
-	}
-	if (!(x & 3)) {
-		x >>= 2;
-		r += 2;
-	}
-	if (!(x & 1)) {
-		x >>= 1;
-		r += 1;
-	}
-	return r;
-}
-
-#endif /* _ASM_GENERIC_BITOPS_FFS_H_ */
--- rtth1/linux/bitops/ffz.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/ffz.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,12 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_FFZ_H_
-#define _ASM_GENERIC_BITOPS_FFZ_H_
-
-/*
- * ffz - find first zero in word.
- * @word: The word to search
- *
- * Undefined if no zero exists, so code should check against ~0UL first.
- */
-#define ffz(x)  __ffs(~(x))
-
-#endif /* _ASM_GENERIC_BITOPS_FFZ_H_ */
--- rtth1/linux/bitops/find.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/find.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,13 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_FIND_H_
-#define _ASM_GENERIC_BITOPS_FIND_H_
-
-extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
-		size, unsigned long offset);
-
-extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
-		long size, unsigned long offset);
-
-#define find_first_bit(addr, size) find_next_bit((addr), (size), 0)
-#define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
-
-#endif /*_ASM_GENERIC_BITOPS_FIND_H_ */
--- rtth1/linux/bitops/fls.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/fls.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,41 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_FLS_H_
-#define _ASM_GENERIC_BITOPS_FLS_H_
-
-/**
- * fls - find last (most-significant) bit set
- * @x: the word to search
- *
- * This is defined the same way as ffs.
- * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
- */
-
-static inline int fls(int x)
-{
-	int r = 32;
-
-	if (!x)
-		return 0;
-	if (!(x & 0xffff0000u)) {
-		x <<= 16;
-		r -= 16;
-	}
-	if (!(x & 0xff000000u)) {
-		x <<= 8;
-		r -= 8;
-	}
-	if (!(x & 0xf0000000u)) {
-		x <<= 4;
-		r -= 4;
-	}
-	if (!(x & 0xc0000000u)) {
-		x <<= 2;
-		r -= 2;
-	}
-	if (!(x & 0x80000000u)) {
-		x <<= 1;
-		r -= 1;
-	}
-	return r;
-}
-
-#endif /* _ASM_GENERIC_BITOPS_FLS_H_ */
--- rtth1/linux/bitops/fls64.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/fls64.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,14 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_FLS64_H_
-#define _ASM_GENERIC_BITOPS_FLS64_H_
-
-#include <asm/types.h>
-
-static inline int fls64(__u64 x)
-{
-	__u32 h = x >> 32;
-	if (h)
-		return fls(h) + 32;
-	return fls(x);
-}
-
-#endif /* _ASM_GENERIC_BITOPS_FLS64_H_ */
--- rtth1/linux/bitops/hweight.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/hweight.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,11 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_HWEIGHT_H_
-#define _ASM_GENERIC_BITOPS_HWEIGHT_H_
-
-#include <asm/types.h>
-
-extern unsigned int hweight32(unsigned int w);
-extern unsigned int hweight16(unsigned int w);
-extern unsigned int hweight8(unsigned int w);
-extern unsigned long hweight64(__u64 w);
-
-#endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
--- rtth1/linux/bitops/le.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/le.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,53 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_LE_H_
-#define _ASM_GENERIC_BITOPS_LE_H_
-
-#include <asm/types.h>
-#include <asm/byteorder.h>
-
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
-
-#if defined(__LITTLE_ENDIAN)
-
-#define generic_test_le_bit(nr, addr) test_bit(nr, addr)
-#define generic___set_le_bit(nr, addr) __set_bit(nr, addr)
-#define generic___clear_le_bit(nr, addr) __clear_bit(nr, addr)
-
-#define generic_test_and_set_le_bit(nr, addr) test_and_set_bit(nr, addr)
-#define generic_test_and_clear_le_bit(nr, addr) test_and_clear_bit(nr, addr)
-
-#define generic___test_and_set_le_bit(nr, addr) __test_and_set_bit(nr, addr)
-#define generic___test_and_clear_le_bit(nr, addr) __test_and_clear_bit(nr, addr)
-
-#define generic_find_next_zero_le_bit(addr, size, offset) find_next_zero_bit(addr, size, offset)
-
-#elif defined(__BIG_ENDIAN)
-
-#define generic_test_le_bit(nr, addr) \
-	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___set_le_bit(nr, addr) \
-	__set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___clear_le_bit(nr, addr) \
-	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define generic_test_and_set_le_bit(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic_test_and_clear_le_bit(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-#define generic___test_and_set_le_bit(nr, addr) \
-	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-#define generic___test_and_clear_le_bit(nr, addr) \
-	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
-
-extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
-		unsigned long size, unsigned long offset);
-
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
-
-#define generic_find_first_zero_le_bit(addr, size) \
-        generic_find_next_zero_le_bit((addr), (size), 0)
-
-#endif /* _ASM_GENERIC_BITOPS_LE_H_ */
--- rtth1/linux/bitops/non-atomic.h	2006-04-22 01:40:19.000000000 -0700
+++ rtth2/linux/bitops/non-atomic.h	1969-12-31 16:00:00.000000000 -0800
@@ -1,111 +0,0 @@
-#ifndef _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
-#define _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
-
-#include <asm/types.h>
-
-#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
-
-/**
- * __set_bit - Set a bit in memory
- * @nr: the bit to set
- * @addr: the address to start counting from
- *
- * Unlike set_bit(), this function is non-atomic and may be reordered.
- * If it's called on the same region of memory simultaneously, the effect
- * may be that only one operation succeeds.
- */
-static inline void __set_bit(int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
-
-	*p  |= mask;
-}
-
-static inline void __clear_bit(int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
-
-	*p &= ~mask;
-}
-
-/**
- * __change_bit - Toggle a bit in memory
- * @nr: the bit to change
- * @addr: the address to start counting from
- *
- * Unlike change_bit(), this function is non-atomic and may be reordered.
- * If it's called on the same region of memory simultaneously, the effect
- * may be that only one operation succeeds.
- */
-static inline void __change_bit(int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
-
-	*p ^= mask;
-}
-
-/**
- * __test_and_set_bit - Set a bit and return its old value
- * @nr: Bit to set
- * @addr: Address to count from
- *
- * This operation is non-atomic and can be reordered.
- * If two examples of this operation race, one can appear to succeed
- * but actually fail.  You must protect multiple accesses with a lock.
- */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
-	unsigned long old = *p;
-
-	*p = old | mask;
-	return (old & mask) != 0;
-}
-
-/**
- * __test_and_clear_bit - Clear a bit and return its old value
- * @nr: Bit to clear
- * @addr: Address to count from
- *
- * This operation is non-atomic and can be reordered.
- * If two examples of this operation race, one can appear to succeed
- * but actually fail.  You must protect multiple accesses with a lock.
- */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
-	unsigned long old = *p;
-
-	*p = old & ~mask;
-	return (old & mask) != 0;
-}
-
-/* WARNING: non atomic and it can be reordered! */
-static inline int __test_and_change_bit(int nr,
-					    volatile unsigned long *addr)
-{
-	unsigned long mask = BITOP_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
-	unsigned long old = *p;
-
-	*p = old ^ mask;
-	return (old & mask) != 0;
-}
-
-/**
- * test_bit - Determine whether a bit is set
- * @nr: bit number to test
- * @addr: Address to start counting from
- */
-static inline int test_bit(int nr, const volatile unsigned long *addr)
-{
-	return 1UL & (addr[BITOP_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
-}
-
-#endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */
--- rtth1/linux/bitops.h	2006-04-22 01:39:48.000000000 -0700
+++ rtth2/linux/bitops.h	2011-12-16 18:44:03.515896619 -0800
@@ -1,19 +1,111 @@
-#ifndef _ASM_GENERIC_BITOPS_H_
-#define _ASM_GENERIC_BITOPS_H_
+#ifndef _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
+#define _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
 
-/*
- * For the benefit of those who are trying to port Linux to another
- * architecture, here are some C-language equivalents.  You should
- * recode these in the native assembly language, if at all possible.
- * 
- * C language equivalents written by Theodore Ts'o, 9/26/92
+#include <asm/types.h>
+
+#define BITOP_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
+#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
+
+/**
+ * __set_bit - Set a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * Unlike set_bit(), this function is non-atomic and may be reordered.
+ * If it's called on the same region of memory simultaneously, the effect
+ * may be that only one operation succeeds.
  */
+static inline void __set_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+
+	*p  |= mask;
+}
+
+static inline void __clear_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+
+	*p &= ~mask;
+}
 
-#include <linux/bitops/non-atomic.h>
-#include <linux/bitops/__ffs.h>
-#include <linux/bitops/ffz.h>
-#include <linux/bitops/fls.h>
-#include <linux/bitops/fls64.h>
-#include <linux/bitops/find.h>
+/**
+ * __change_bit - Toggle a bit in memory
+ * @nr: the bit to change
+ * @addr: the address to start counting from
+ *
+ * Unlike change_bit(), this function is non-atomic and may be reordered.
+ * If it's called on the same region of memory simultaneously, the effect
+ * may be that only one operation succeeds.
+ */
+static inline void __change_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+
+	*p ^= mask;
+}
+
+/**
+ * __test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is non-atomic and can be reordered.
+ * If two examples of this operation race, one can appear to succeed
+ * but actually fail.  You must protect multiple accesses with a lock.
+ */
+static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long old = *p;
+
+	*p = old | mask;
+	return (old & mask) != 0;
+}
+
+/**
+ * __test_and_clear_bit - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is non-atomic and can be reordered.
+ * If two examples of this operation race, one can appear to succeed
+ * but actually fail.  You must protect multiple accesses with a lock.
+ */
+static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long old = *p;
+
+	*p = old & ~mask;
+	return (old & mask) != 0;
+}
+
+/* WARNING: non atomic and it can be reordered! */
+static inline int __test_and_change_bit(int nr,
+					    volatile unsigned long *addr)
+{
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+	unsigned long old = *p;
+
+	*p = old ^ mask;
+	return (old & mask) != 0;
+}
+
+/**
+ * test_bit - Determine whether a bit is set
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static inline int test_bit(int nr, const volatile unsigned long *addr)
+{
+	return 1UL & (addr[BITOP_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
+}
 
-#endif /* _ASM_GENERIC_BITOPS_H */
+#endif /* _ASM_GENERIC_BITOPS_NON_ATOMIC_H_ */
--- rtth1/linux/types.h	2010-08-25 13:30:45.000000000 -0700
+++ rtth2/linux/types.h	2011-12-16 18:44:03.515896619 -0800
@@ -4,7 +4,7 @@
 #define __nocast
 #define __read_mostly
 
-#define BITS_PER_LONG 64
+#define BITS_PER_LONG (sizeof(long) * 8)
 
 typedef unsigned __nocast gfp_t;
 
