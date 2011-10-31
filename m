Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1KAAR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:17:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35201 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab1KAARU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:17:20 -0400
Message-Id: <093448$3uejr0@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132599648"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:27:45 -0500
Subject: [PATCH v5 03/36] Hexagon: Add bitops support
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/bitops.h |  301 +++++++++++++++++++++++++++++++++++++
 1 files changed, 301 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/bitops.h

diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
new file mode 100644
index 0000000..d23461e
--- /dev/null
+++ b/arch/hexagon/include/asm/bitops.h
@@ -0,0 +1,301 @@
+/*
+ * Bit operations for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_BITOPS_H
+#define _ASM_BITOPS_H
+
+#include <linux/compiler.h>
+#include <asm/byteorder.h>
+#include <asm/system.h>
+#include <asm/atomic.h>
+
+#ifdef __KERNEL__
+
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+/*
+ * The offset calculations for these are based on BITS_PER_LONG == 32
+ * (i.e. I get to shift by #5-2 (32 bits per long, 4 bytes per access),
+ * mask by 0x0000001F)
+ *
+ * Typically, R10 is clobbered for address, R11 bit nr, and R12 is temp
+ */
+
+/**
+ * test_and_clear_bit - clear a bit and return its old value
+ * @nr:  bit number to clear
+ * @addr:  pointer to memory
+ */
+static inline int test_and_clear_bit(int nr, volatile void *addr)
+{
+	int oldval;
+
+	__asm__ __volatile__ (
+	"	{R10 = %1; R11 = asr(%2,#5); }\n"
+	"	{R10 += asl(R11,#2); R11 = and(%2,#0x1f)}\n"
+	"1:	R12 = memw_locked(R10);\n"
+	"	{ P0 = tstbit(R12,R11); R12 = clrbit(R12,R11); }\n"
+	"	memw_locked(R10,P1) = R12;\n"
+	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
+	: "=&r" (oldval)
+	: "r" (addr), "r" (nr)
+	: "r10", "r11", "r12", "p0", "p1", "memory"
+	);
+
+	return oldval;
+}
+
+/**
+ * test_and_set_bit - set a bit and return its old value
+ * @nr:  bit number to set
+ * @addr:  pointer to memory
+ */
+static inline int test_and_set_bit(int nr, volatile void *addr)
+{
+	int oldval;
+
+	__asm__ __volatile__ (
+	"	{R10 = %1; R11 = asr(%2,#5); }\n"
+	"	{R10 += asl(R11,#2); R11 = and(%2,#0x1f)}\n"
+	"1:	R12 = memw_locked(R10);\n"
+	"	{ P0 = tstbit(R12,R11); R12 = setbit(R12,R11); }\n"
+	"	memw_locked(R10,P1) = R12;\n"
+	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
+	: "=&r" (oldval)
+	: "r" (addr), "r" (nr)
+	: "r10", "r11", "r12", "p0", "p1", "memory"
+	);
+
+
+	return oldval;
+
+}
+
+/**
+ * test_and_change_bit - toggle a bit and return its old value
+ * @nr:  bit number to set
+ * @addr:  pointer to memory
+ */
+static inline int test_and_change_bit(int nr, volatile void *addr)
+{
+	int oldval;
+
+	__asm__ __volatile__ (
+	"	{R10 = %1; R11 = asr(%2,#5); }\n"
+	"	{R10 += asl(R11,#2); R11 = and(%2,#0x1f)}\n"
+	"1:	R12 = memw_locked(R10);\n"
+	"	{ P0 = tstbit(R12,R11); R12 = togglebit(R12,R11); }\n"
+	"	memw_locked(R10,P1) = R12;\n"
+	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
+	: "=&r" (oldval)
+	: "r" (addr), "r" (nr)
+	: "r10", "r11", "r12", "p0", "p1", "memory"
+	);
+
+	return oldval;
+
+}
+
+/*
+ * Atomic, but doesn't care about the return value.
+ * Rewrite later to save a cycle or two.
+ */
+
+static inline void clear_bit(int nr, volatile void *addr)
+{
+	test_and_clear_bit(nr, addr);
+}
+
+static inline void set_bit(int nr, volatile void *addr)
+{
+	test_and_set_bit(nr, addr);
+}
+
+static inline void change_bit(int nr, volatile void *addr)
+{
+	test_and_change_bit(nr, addr);
+}
+
+
+/*
+ * These are allowed to be non-atomic.  In fact the generic flavors are
+ * in non-atomic.h.  Would it be better to use intrinsics for this?
+ *
+ * OK, writes in our architecture do not invalidate LL/SC, so this has to
+ * be atomic, particularly for things like slab_lock and slab_unlock.
+ *
+ */
+static inline void __clear_bit(int nr, volatile unsigned long *addr)
+{
+	test_and_clear_bit(nr, addr);
+}
+
+static inline void __set_bit(int nr, volatile unsigned long *addr)
+{
+	test_and_set_bit(nr, addr);
+}
+
+static inline void __change_bit(int nr, volatile unsigned long *addr)
+{
+	test_and_change_bit(nr, addr);
+}
+
+/*  Apparently, at least some of these are allowed to be non-atomic  */
+static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+{
+	return test_and_clear_bit(nr, addr);
+}
+
+static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+{
+	return test_and_set_bit(nr, addr);
+}
+
+static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
+{
+	return test_and_change_bit(nr, addr);
+}
+
+static inline int __test_bit(int nr, const volatile unsigned long *addr)
+{
+	int retval;
+
+	asm volatile(
+	"{P0 = tstbit(%1,%2); if (P0.new) %0 = #1; if (!P0.new) %0 = #0;}\n"
+	: "=&r" (retval)
+	: "r" (addr[BIT_WORD(nr)]), "r" (nr % BITS_PER_LONG)
+	: "p0"
+	);
+
+	return retval;
+}
+
+#define test_bit(nr, addr) __test_bit(nr, addr)
+
+/*
+ * ffz - find first zero in word.
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static inline long ffz(int x)
+{
+	int r;
+
+	asm("%0 = ct1(%1);\n"
+		: "=&r" (r)
+		: "r" (x));
+	return r;
+}
+
+/*
+ * fls - find last (most-significant) bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as ffs.
+ * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
+ */
+static inline long fls(int x)
+{
+	int r;
+
+	asm("{ %0 = cl0(%1);}\n"
+		"%0 = sub(#32,%0);\n"
+		: "=&r" (r)
+		: "r" (x)
+		: "p0");
+
+	return r;
+}
+
+/*
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as
+ * the libc and compiler builtin ffs routines, therefore
+ * differs in spirit from the above ffz (man ffs).
+ */
+static inline long ffs(int x)
+{
+	int r;
+
+	asm("{ P0 = cmp.eq(%1,#0); %0 = ct0(%1);}\n"
+		"{ if P0 %0 = #0; if !P0 %0 = add(%0,#1);}\n"
+		: "=&r" (r)
+		: "r" (x)
+		: "p0");
+
+	return r;
+}
+
+/*
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ *
+ * bits_per_long assumed to be 32
+ * numbering starts at 0 I think (instead of 1 like ffs)
+ */
+static inline unsigned long __ffs(unsigned long word)
+{
+	int num;
+
+	asm("%0 = ct0(%1);\n"
+		: "=&r" (num)
+		: "r" (word));
+
+	return num;
+}
+
+/*
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ * bits_per_long assumed to be 32
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	int num;
+
+	asm("%0 = cl0(%1);\n"
+		"%0 = sub(#31,%0);\n"
+		: "=&r" (num)
+		: "r" (word));
+
+	return num;
+}
+
+#include <asm-generic/bitops/lock.h>
+#include <asm-generic/bitops/find.h>
+
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+
+#include <asm-generic/bitops/le.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+
+#endif /* __KERNEL__ */
+#endif
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
