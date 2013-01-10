Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3AJPlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:41:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56857 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab3AJPcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:39 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 14/44] metag: Memory handling
Date: Thu, 10 Jan 2013 15:30:42 +0000
Message-ID: <1357831872-29451-15-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meta has instructions for accessing:
 - bytes        - GETB (1 byte)
 - words        - GETW (2 bytes)
 - doublewords  - GETD (4 bytes)
 - longwords    - GETL (8 bytes)

All accesses must be aligned. Unaligned accesses can be detected and
made to fault on Meta2, however it isn't possible to fix up unaligned
writes so we don't bother fixing up reads either.

This patch adds metag memory handling code including:
 - I/O memory (io.h, ioremap.c): Actually any virtual memory can be
   accessed with these helpers. A part of the non-MMUable address space
   is used for memory mapped I/O. The ioremap() function is implemented
   one to one for non-MMUable addresses.
 - User memory (uaccess.h, usercopy.c): User memory is directly
   accessible from privileged code.
 - Kernel memory (maccess.c): probe_kernel_write() needs to be
   overwridden to use the I/O functions when doing a simple aligned
   write to non-writecombined memory, otherwise the write may be split
   by the generic version.

Note that due to the fact that a portion of the virtual address space is
non-MMUable, and therefore always maps directly to the physical address
space, metag specific I/O functions are made available (metag_in32,
metag_out32 etc). These cast the address argument to a pointer so that
they can be used with raw physical addresses. These accessors are only
to be used for accessing fixed core Meta architecture registers in the
non-MMU region, and not for any SoC/peripheral registers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/io.h      |  165 +++++
 arch/metag/include/asm/uaccess.h |  241 +++++++
 arch/metag/lib/usercopy.c        | 1341 ++++++++++++++++++++++++++++++++++++++
 arch/metag/mm/ioremap.c          |   89 +++
 arch/metag/mm/maccess.c          |   68 ++
 5 files changed, 1904 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/io.h
 create mode 100644 arch/metag/include/asm/uaccess.h
 create mode 100644 arch/metag/lib/usercopy.c
 create mode 100644 arch/metag/mm/ioremap.c
 create mode 100644 arch/metag/mm/maccess.c

diff --git a/arch/metag/include/asm/io.h b/arch/metag/include/asm/io.h
new file mode 100644
index 0000000..9359e50
--- /dev/null
+++ b/arch/metag/include/asm/io.h
@@ -0,0 +1,165 @@
+#ifndef _ASM_METAG_IO_H
+#define _ASM_METAG_IO_H
+
+#include <linux/types.h>
+
+#define IO_SPACE_LIMIT  0
+
+#define page_to_bus page_to_phys
+#define bus_to_page phys_to_page
+
+/*
+ * Generic I/O
+ */
+
+#define __raw_readb __raw_readb
+static inline u8 __raw_readb(const volatile void __iomem *addr)
+{
+	u8 ret;
+	asm volatile("GETB %0,[%1]"
+		     : "=da" (ret)
+		     : "da" (addr)
+		     : "memory");
+	return ret;
+}
+
+#define __raw_readw __raw_readw
+static inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	u16 ret;
+	asm volatile("GETW %0,[%1]"
+		     : "=da" (ret)
+		     : "da" (addr)
+		     : "memory");
+	return ret;
+}
+
+#define __raw_readl __raw_readl
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	u32 ret;
+	asm volatile("GETD %0,[%1]"
+		     : "=da" (ret)
+		     : "da" (addr)
+		     : "memory");
+	return ret;
+}
+
+#define __raw_readq __raw_readq
+static inline u64 __raw_readq(const volatile void __iomem *addr)
+{
+	u64 ret;
+	asm volatile("GETL %0,%t0,[%1]"
+		     : "=da" (ret)
+		     : "da" (addr)
+		     : "memory");
+	return ret;
+}
+
+#define __raw_writeb __raw_writeb
+static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
+{
+	asm volatile("SETB [%0],%1"
+		     :
+		     : "da" (addr),
+		       "da" (b)
+		     : "memory");
+}
+
+#define __raw_writew __raw_writew
+static inline void __raw_writew(u16 b, volatile void __iomem *addr)
+{
+	asm volatile("SETW [%0],%1"
+		     :
+		     : "da" (addr),
+		       "da" (b)
+		     : "memory");
+}
+
+#define __raw_writel __raw_writel
+static inline void __raw_writel(u32 b, volatile void __iomem *addr)
+{
+	asm volatile("SETD [%0],%1"
+		     :
+		     : "da" (addr),
+		       "da" (b)
+		     : "memory");
+}
+
+#define __raw_writeq __raw_writeq
+static inline void __raw_writeq(u64 b, volatile void __iomem *addr)
+{
+	asm volatile("SETL [%0],%1,%t1"
+		     :
+		     : "da" (addr),
+		       "da" (b)
+		     : "memory");
+}
+
+/*
+ * The generic io.h can define all the other generic accessors
+ */
+
+#include <asm-generic/io.h>
+
+/*
+ * Despite being a 32bit architecture, Meta can do 64bit memory accesses
+ * (assuming the bus supports it).
+ */
+
+#define readq	__raw_readq
+#define writeq	__raw_writeq
+
+/*
+ * Meta specific I/O for accessing non-MMU areas.
+ *
+ * These can be provided with a physical address rather than an __iomem pointer
+ * and should only be used by core architecture code for accessing fixed core
+ * registers. Generic drivers should use ioremap and the generic I/O accessors.
+ */
+
+#define metag_in8(addr)		__raw_readb((volatile void __iomem *)(addr))
+#define metag_in16(addr)	__raw_readw((volatile void __iomem *)(addr))
+#define metag_in32(addr)	__raw_readl((volatile void __iomem *)(addr))
+#define metag_in64(addr)	__raw_readq((volatile void __iomem *)(addr))
+
+#define metag_out8(b, addr)	__raw_writeb(b, (volatile void __iomem *)(addr))
+#define metag_out16(b, addr)	__raw_writew(b, (volatile void __iomem *)(addr))
+#define metag_out32(b, addr)	__raw_writel(b, (volatile void __iomem *)(addr))
+#define metag_out64(b, addr)	__raw_writeq(b, (volatile void __iomem *)(addr))
+
+/*
+ * io remapping functions
+ */
+
+extern void __iomem *__ioremap(unsigned long offset,
+			       size_t size, unsigned long flags);
+extern void __iounmap(void __iomem *addr);
+
+/**
+ *	ioremap		-	map bus memory into CPU space
+ *	@offset:	bus address of the memory
+ *	@size:		size of the resource to map
+ *
+ *	ioremap performs a platform specific sequence of operations to
+ *	make bus memory CPU accessible via the readb/readw/readl/writeb/
+ *	writew/writel functions and the other mmio helpers. The returned
+ *	address is not guaranteed to be usable directly as a virtual
+ *	address.
+ */
+#define ioremap(offset, size)                   \
+	__ioremap((offset), (size), 0)
+
+#define ioremap_nocache(offset, size)           \
+	__ioremap((offset), (size), 0)
+
+#define ioremap_cached(offset, size)            \
+	__ioremap((offset), (size), _PAGE_CACHEABLE)
+
+#define ioremap_wc(offset, size)                \
+	__ioremap((offset), (size), _PAGE_WR_COMBINE)
+
+#define iounmap(addr)                           \
+	__iounmap(addr)
+
+#endif  /* _ASM_METAG_IO_H */
diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/uaccess.h
new file mode 100644
index 0000000..0748b0a
--- /dev/null
+++ b/arch/metag/include/asm/uaccess.h
@@ -0,0 +1,241 @@
+#ifndef __METAG_UACCESS_H
+#define __METAG_UACCESS_H
+
+/*
+ * User space memory access functions
+ */
+#include <linux/sched.h>
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not.  If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ */
+
+#define MAKE_MM_SEG(s)  ((mm_segment_t) { (s) })
+
+#define KERNEL_DS       MAKE_MM_SEG(0xFFFFFFFF)
+#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
+
+#define get_ds()	(KERNEL_DS)
+#define get_fs()        (current_thread_info()->addr_limit)
+#define set_fs(x)       (current_thread_info()->addr_limit = (x))
+
+#define segment_eq(a, b)	((a).seg == (b).seg)
+
+#define __kernel_ok (segment_eq(get_fs(), KERNEL_DS))
+/*
+ * Explicitly allow NULL pointers here. Parts of the kernel such
+ * as readv/writev use access_ok to validate pointers, but want
+ * to allow NULL pointers for various reasons. NULL pointers are
+ * safe to allow through because the first page is not mappable on
+ * Meta.
+ *
+ * We also wish to avoid letting user code access the system area
+ * and the kernel half of the address space.
+ */
+#define __user_bad(addr, size) (((addr) > 0 && (addr) < META_MEMORY_BASE) || \
+				((addr) > PAGE_OFFSET &&		\
+				 (addr) < LINCORE_BASE))
+
+static inline int __access_ok(unsigned long addr, unsigned long size)
+{
+	return __kernel_ok || !__user_bad(addr, size);
+}
+
+#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),	\
+						(unsigned long)(size))
+
+static inline int verify_area(int type, const void *addr, unsigned long size)
+{
+	return access_ok(type, addr, size) ? 0 : -EFAULT;
+}
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ */
+
+#define put_user(x, ptr) \
+	__put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+#define __put_user(x, ptr) \
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+
+extern void __put_user_bad(void);
+
+#define __put_user_nocheck(x, ptr, size)		\
+({                                                      \
+	long __pu_err;                                  \
+	__put_user_size((x), (ptr), (size), __pu_err);	\
+	__pu_err;                                       \
+})
+
+#define __put_user_check(x, ptr, size)				\
+({                                                              \
+	long __pu_err = -EFAULT;                                \
+	__typeof__(*(ptr)) __user *__pu_addr = (ptr);           \
+	if (access_ok(VERIFY_WRITE, __pu_addr, size))		\
+		__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	__pu_err;                                               \
+})
+
+extern long __put_user_asm_b(unsigned int x, void __user *addr);
+extern long __put_user_asm_w(unsigned int x, void __user *addr);
+extern long __put_user_asm_d(unsigned int x, void __user *addr);
+extern long __put_user_asm_l(unsigned long long x, void __user *addr);
+
+#define __put_user_size(x, ptr, size, retval)			\
+do {                                                            \
+	retval = 0;                                             \
+	switch (size) {                                         \
+	case 1:								\
+		retval = __put_user_asm_b((unsigned int)x, ptr); break;	\
+	case 2:								\
+		retval = __put_user_asm_w((unsigned int)x, ptr); break;	\
+	case 4:								\
+		retval = __put_user_asm_d((unsigned int)x, ptr); break;	\
+	case 8:								\
+		retval = __put_user_asm_l((unsigned long long)x, ptr); break; \
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
+#define get_user(x, ptr) \
+	__get_user_check((x), (ptr), sizeof(*(ptr)))
+#define __get_user(x, ptr) \
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+extern long __get_user_bad(void);
+
+#define __get_user_nocheck(x, ptr, size)			\
+({                                                              \
+	long __gu_err, __gu_val;                                \
+	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
+	(x) = (__typeof__(*(ptr)))__gu_val;                     \
+	__gu_err;                                               \
+})
+
+#define __get_user_check(x, ptr, size)					\
+({                                                                      \
+	long __gu_err = -EFAULT, __gu_val = 0;                          \
+	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
+	if (access_ok(VERIFY_READ, __gu_addr, size))			\
+		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+	(x) = (__typeof__(*(ptr)))__gu_val;                             \
+	__gu_err;                                                       \
+})
+
+extern unsigned char __get_user_asm_b(const void __user *addr, long *err);
+extern unsigned short __get_user_asm_w(const void __user *addr, long *err);
+extern unsigned int __get_user_asm_d(const void __user *addr, long *err);
+
+#define __get_user_size(x, ptr, size, retval)			\
+do {                                                            \
+	retval = 0;                                             \
+	switch (size) {                                         \
+	case 1:							\
+		x = __get_user_asm_b(ptr, &retval); break;	\
+	case 2:							\
+		x = __get_user_asm_w(ptr, &retval); break;	\
+	case 4:							\
+		x = __get_user_asm_d(ptr, &retval); break;	\
+	default:						\
+		(x) = __get_user_bad();				\
+	}                                                       \
+} while (0)
+
+/*
+ * Copy a null terminated string from userspace.
+ *
+ * Must return:
+ * -EFAULT		for an exception
+ * count		if we hit the buffer limit
+ * bytes copied		if we hit a null byte
+ * (without the null byte)
+ */
+
+extern long __must_check __strncpy_from_user(char *dst, const char __user *src,
+					     long count);
+
+#define strncpy_from_user(dst, src, count) __strncpy_from_user(dst, src, count)
+
+/*
+ * Return the size of a string (including the ending 0)
+ *
+ * Return 0 on exception, a value greater than N if too long
+ */
+extern long __must_check strnlen_user(const char __user *src, long count);
+
+#define strlen_user(str) strnlen_user(str, 32767)
+
+extern unsigned long __must_check __copy_user_zeroing(void *to,
+						      const void __user *from,
+						      unsigned long n);
+
+static inline unsigned long
+copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n))
+		return __copy_user_zeroing(to, from, n);
+	return n;
+}
+
+#define __copy_from_user(to, from, n) __copy_user_zeroing(to, from, n)
+#define __copy_from_user_inatomic __copy_from_user
+
+extern unsigned long __must_check __copy_user(void __user *to,
+					      const void *from,
+					      unsigned long n);
+
+static inline unsigned long copy_to_user(void __user *to, const void *from,
+					 unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		return __copy_user(to, from, n);
+	return n;
+}
+
+#define __copy_to_user(to, from, n) __copy_user(to, from, n)
+#define __copy_to_user_inatomic __copy_to_user
+
+/*
+ * Zero Userspace
+ */
+
+extern unsigned long __must_check __do_clear_user(void __user *to,
+						  unsigned long n);
+
+static inline unsigned long clear_user(void __user *to, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		return __do_clear_user(to, n);
+	return n;
+}
+
+#define __clear_user(to, n)            __do_clear_user(to, n)
+
+#endif /* _METAG_UACCESS_H */
diff --git a/arch/metag/lib/usercopy.c b/arch/metag/lib/usercopy.c
new file mode 100644
index 0000000..92f6dbb
--- /dev/null
+++ b/arch/metag/lib/usercopy.c
@@ -0,0 +1,1341 @@
+/*
+ * User address space access functions.
+ * The non-inlined parts of asm-metag/uaccess.h are here.
+ *
+ * Copyright (C) 2006, Imagination Technologies.
+ * Copyright (C) 2000, Axis Communications AB.
+ *
+ * Written by Hans-Peter Nilsson.
+ * Pieces used from memcpy, originally by Kenny Ranerup long time ago.
+ * Modified for Meta by Will Newton.
+ */
+
+#include <linux/uaccess.h>
+#include <asm/cache.h>			/* def of L1_CACHE_BYTES */
+
+#define USE_RAPF
+#define RAPF_MIN_BUF_SIZE	(3*L1_CACHE_BYTES)
+
+
+/* The "double write" in this code is because the Meta will not fault
+ * immediately unless the memory pipe is forced to by e.g. a data stall or
+ * another memory op. The second write should be discarded by the write
+ * combiner so should have virtually no cost.
+ */
+
+#define __asm_copy_user_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	asm volatile (						 \
+		COPY						 \
+		"1:\n"						 \
+		"	.section .fixup,\"ax\"\n"		 \
+		"	MOV D1Ar1,#0\n"				 \
+		FIXUP						 \
+		"	MOVT    D1Ar1,#HI(1b)\n"		 \
+		"	JUMP    D1Ar1,#LO(1b)\n"		 \
+		"	.previous\n"				 \
+		"	.section __ex_table,\"a\"\n"		 \
+		TENTRY						 \
+		"	.previous\n"				 \
+		: "=r" (to), "=r" (from), "=r" (ret)		 \
+		: "0" (to), "1" (from), "2" (ret)		 \
+		: "D1Ar1", "memory")
+
+
+#define __asm_copy_to_user_1(to, from, ret)	\
+	__asm_copy_user_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"	\
+		"	SETB [%0],D1Ar1\n"	\
+		"2:	SETB [%0++],D1Ar1\n",	\
+		"3:	ADD  %2,%2,#1\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_copy_to_user_2x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"2:	SETW [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_to_user_2(to, from, ret) \
+	__asm_copy_to_user_2x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_3(to, from, ret) \
+	__asm_copy_to_user_2x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_to_user_4x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"2:	SETD [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#4\n" FIXUP,		\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_to_user_4(to, from, ret) \
+	__asm_copy_to_user_4x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_5(to, from, ret) \
+	__asm_copy_to_user_4x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_to_user_6x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_4x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"4:	SETW [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_to_user_6(to, from, ret) \
+	__asm_copy_to_user_6x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_7(to, from, ret) \
+	__asm_copy_to_user_6x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_to_user_8x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_4x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"4:	SETD [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#4\n"  FIXUP,	\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_to_user_8(to, from, ret) \
+	__asm_copy_to_user_8x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_9(to, from, ret) \
+	__asm_copy_to_user_8x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_to_user_10x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_8x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"6:	SETW [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_copy_to_user_10(to, from, ret) \
+	__asm_copy_to_user_10x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_11(to, from, ret) \
+	__asm_copy_to_user_10x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_to_user_12x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_8x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"6:	SETD [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#4\n" FIXUP,		\
+		"	.long 6b,7b\n" TENTRY)
+#define __asm_copy_to_user_12(to, from, ret) \
+	__asm_copy_to_user_12x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_13(to, from, ret) \
+	__asm_copy_to_user_12x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_to_user_14x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_12x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"8:	SETW [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_to_user_14(to, from, ret) \
+	__asm_copy_to_user_14x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_15(to, from, ret) \
+	__asm_copy_to_user_14x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"10:	SETB [%0++],D1Ar1\n",		\
+		"11:	ADD  %2,%2,#1\n",		\
+		"	.long 10b,11b\n")
+
+#define __asm_copy_to_user_16x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_12x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"8:	SETD [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#4\n" FIXUP,		\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_to_user_16(to, from, ret) \
+		__asm_copy_to_user_16x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_8x64(to, from, ret) \
+	asm volatile (					\
+		"	GETL D0Ar2,D1Ar1,[%1++]\n"	\
+		"	SETL [%0],D0Ar2,D1Ar1\n"	\
+		"2:	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"3:	ADD  %2,%2,#8\n"		\
+		"	MOVT    D0Ar2,#HI(1b)\n"	\
+		"	JUMP    D0Ar2,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.long 2b,3b\n"			\
+		"	.previous\n"			\
+		: "=r" (to), "=r" (from), "=r" (ret)	\
+		: "0" (to), "1" (from), "2" (ret)	\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*
+ *	optimized copying loop using RAPF when 64 bit aligned
+ *
+ *	n		will be automatically decremented inside the loop
+ *	ret		will be left intact. if error occurs we will rewind
+ *			so that the original non optimized code will fill up
+ *			this value correctly.
+ *
+ *	on fault:
+ *		>	n will hold total number of uncopied bytes
+ *
+ *		>	{'to','from'} will be rewind back so that
+ *			the non-optimized code will do the proper fix up
+ *
+ *	DCACHE drops the cacheline which helps in reducing cache
+ *	pollution.
+ *
+ *	We introduce an extra SETL at the end of the loop to
+ *	ensure we don't fall off the loop before we catch all
+ *	erros.
+ *
+ *	NOTICE:
+ *		LSM_STEP in TXSTATUS must be cleared in fix up code.
+ *		since we're using M{S,G}ETL, a fault might happen at
+ *		any address in the middle of M{S,G}ETL causing
+ *		the value of LSM_STEP to be incorrect which can
+ *		cause subsequent use of M{S,G}ET{L,D} to go wrong.
+ *		ie: if LSM_STEP was 1 when a fault occurs, the
+ *		next call to M{S,G}ET{L,D} will skip the first
+ *		copy/getting as it think that the first 1 has already
+ *		been done.
+ *
+ */
+#define __asm_copy_user_64bit_rapf_loop(				\
+		to, from, ret, n, id, FIXUP)				\
+	asm volatile (							\
+		".balign 8\n"						\
+		"MOV	RAPF, %1\n"					\
+		"MSETL	[A0StP++], D0Ar6, D0FrT, D0.5, D0.6, D0.7\n"	\
+		"MOV	D0Ar6, #0\n"					\
+		"LSR	D1Ar5, %3, #6\n"				\
+		"SUB	TXRPT, D1Ar5, #2\n"				\
+		"MOV	RAPF, %1\n"					\
+		"$Lloop"id":\n"						\
+		"ADD	RAPF, %1, #64\n"				\
+		"21:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"22:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #32\n"					\
+		"23:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"24:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #32\n"					\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"BR	$Lloop"id"\n"					\
+									\
+		"MOV	RAPF, %1\n"					\
+		"25:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"26:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #32\n"					\
+		"27:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"28:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%0, %0, #8\n"					\
+		"29:\n"							\
+		"SETL	[%0++], D0.7, D1.7\n"				\
+		"SUB	%3, %3, #32\n"					\
+		"1:"							\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"GETL    D0Ar6, D1Ar5, [A0StP+#-40]\n"			\
+		"GETL    D0FrT, D1RtP, [A0StP+#-32]\n"			\
+		"GETL    D0.5, D1.5, [A0StP+#-24]\n"			\
+		"GETL    D0.6, D1.6, [A0StP+#-16]\n"			\
+		"GETL    D0.7, D1.7, [A0StP+#-8]\n"			\
+		"SUB A0StP, A0StP, #40\n"				\
+		"	.section .fixup,\"ax\"\n"			\
+		"4:\n"							\
+		"	ADD	%0, %0, #8\n"				\
+		"3:\n"							\
+		"	MOV	D0Ar2, TXSTATUS\n"			\
+		"	MOV	D1Ar1, TXSTATUS\n"			\
+		"	AND	D1Ar1, D1Ar1, #0xFFFFF8FF\n"		\
+		"	MOV	TXSTATUS, D1Ar1\n"			\
+			FIXUP						\
+		"	MOVT    D0Ar2,#HI(1b)\n"			\
+		"	JUMP    D0Ar2,#LO(1b)\n"			\
+		"	.previous\n"					\
+		"	.section __ex_table,\"a\"\n"			\
+		"	.long 21b,3b\n"					\
+		"	.long 22b,3b\n"					\
+		"	.long 23b,3b\n"					\
+		"	.long 24b,3b\n"					\
+		"	.long 25b,3b\n"					\
+		"	.long 26b,3b\n"					\
+		"	.long 27b,3b\n"					\
+		"	.long 28b,3b\n"					\
+		"	.long 29b,4b\n"					\
+		"	.previous\n"					\
+		: "=r" (to), "=r" (from), "=r" (ret), "=d" (n)		\
+		: "0" (to), "1" (from), "2" (ret), "3" (n)		\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*	rewind 'to' and 'from'  pointers when a fault occurs
+ *
+ *	Rationale:
+ *		A fault always occurs on writing to user buffer. A fault
+ *		is at a single address, so we need to rewind by only 4
+ *		bytes.
+ *		Since we do a complete read from kernel buffer before
+ *		writing, we need to rewind it also. The amount to be
+ *		rewind equals the number of faulty writes in MSETD
+ *		which is: [4 - (LSM_STEP-1)]*8
+ *		LSM_STEP is bits 10:8 in TXSTATUS which is already read
+ *		and stored in D0Ar2
+ *
+ *		NOTE: If a fault occurs at the last operation in M{G,S}ETL
+ *			LSM_STEP will be 0. ie: we do 4 writes in our case, if
+ *			a fault happens at the 4th write, LSM_STEP will be 0
+ *			instead of 4. The code copes with that.
+ *
+ *		n is updated by the number of successful writes, which is:
+ *		n = n - (LSM_STEP-1)*8
+ */
+#define __asm_copy_to_user_64bit_rapf_loop(to,	from, ret, n, id)\
+	__asm_copy_user_64bit_rapf_loop(to, from, ret, n, id,		\
+		"LSR	D0Ar2, D0Ar2, #8\n"				\
+		"AND	D0Ar2, D0Ar2, #0x7\n"				\
+		"ADDZ	D0Ar2, D0Ar2, #4\n"				\
+		"SUB	D0Ar2, D0Ar2, #1\n"				\
+		"MOV	D1Ar1, #4\n"					\
+		"SUB	D0Ar2, D1Ar1, D0Ar2\n"				\
+		"LSL	D0Ar2, D0Ar2, #3\n"				\
+		"LSL	D1Ar1, D1Ar1, #3\n"				\
+		"SUB	D1Ar1, D1Ar1, D0Ar2\n"				\
+		"SUB	%0, %0, #8\n"					\
+		"SUB	%1,	%1,D0Ar2\n"				\
+		"SUB	%3, %3, D1Ar1\n")
+
+/*
+ *	optimized copying loop using RAPF when 32 bit aligned
+ *
+ *	n		will be automatically decremented inside the loop
+ *	ret		will be left intact. if error occurs we will rewind
+ *			so that the original non optimized code will fill up
+ *			this value correctly.
+ *
+ *	on fault:
+ *		>	n will hold total number of uncopied bytes
+ *
+ *		>	{'to','from'} will be rewind back so that
+ *			the non-optimized code will do the proper fix up
+ *
+ *	DCACHE drops the cacheline which helps in reducing cache
+ *	pollution.
+ *
+ *	We introduce an extra SETD at the end of the loop to
+ *	ensure we don't fall off the loop before we catch all
+ *	erros.
+ *
+ *	NOTICE:
+ *		LSM_STEP in TXSTATUS must be cleared in fix up code.
+ *		since we're using M{S,G}ETL, a fault might happen at
+ *		any address in the middle of M{S,G}ETL causing
+ *		the value of LSM_STEP to be incorrect which can
+ *		cause subsequent use of M{S,G}ET{L,D} to go wrong.
+ *		ie: if LSM_STEP was 1 when a fault occurs, the
+ *		next call to M{S,G}ET{L,D} will skip the first
+ *		copy/getting as it think that the first 1 has already
+ *		been done.
+ *
+ */
+#define __asm_copy_user_32bit_rapf_loop(				\
+			to,	from, ret, n, id, FIXUP)		\
+	asm volatile (							\
+		".balign 8\n"						\
+		"MOV	RAPF, %1\n"					\
+		"MSETL	[A0StP++], D0Ar6, D0FrT, D0.5, D0.6, D0.7\n"	\
+		"MOV	D0Ar6, #0\n"					\
+		"LSR	D1Ar5, %3, #6\n"				\
+		"SUB	TXRPT, D1Ar5, #2\n"				\
+		"MOV	RAPF, %1\n"					\
+	"$Lloop"id":\n"							\
+		"ADD	RAPF, %1, #64\n"				\
+		"21:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"22:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"23:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"24:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"25:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"26:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"27:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"28:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"BR	$Lloop"id"\n"					\
+									\
+		"MOV	RAPF, %1\n"					\
+		"29:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"30:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"31:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"32:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"33:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"34:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"35:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"36:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%0, %0, #4\n"					\
+		"37:\n"							\
+		"SETD	[%0++], D0.7\n"					\
+		"SUB	%3, %3, #16\n"					\
+		"1:"							\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"GETL    D0Ar6, D1Ar5, [A0StP+#-40]\n"			\
+		"GETL    D0FrT, D1RtP, [A0StP+#-32]\n"			\
+		"GETL    D0.5, D1.5, [A0StP+#-24]\n"			\
+		"GETL    D0.6, D1.6, [A0StP+#-16]\n"			\
+		"GETL    D0.7, D1.7, [A0StP+#-8]\n"			\
+		"SUB A0StP, A0StP, #40\n"				\
+		"	.section .fixup,\"ax\"\n"			\
+		"4:\n"							\
+		"	ADD		%0, %0, #4\n"			\
+		"3:\n"							\
+		"	MOV	D0Ar2, TXSTATUS\n"			\
+		"	MOV	D1Ar1, TXSTATUS\n"			\
+		"	AND	D1Ar1, D1Ar1, #0xFFFFF8FF\n"		\
+		"	MOV	TXSTATUS, D1Ar1\n"			\
+			FIXUP						\
+		"	MOVT    D0Ar2,#HI(1b)\n"			\
+		"	JUMP    D0Ar2,#LO(1b)\n"			\
+		"	.previous\n"					\
+		"	.section __ex_table,\"a\"\n"			\
+		"	.long 21b,3b\n"					\
+		"	.long 22b,3b\n"					\
+		"	.long 23b,3b\n"					\
+		"	.long 24b,3b\n"					\
+		"	.long 25b,3b\n"					\
+		"	.long 26b,3b\n"					\
+		"	.long 27b,3b\n"					\
+		"	.long 28b,3b\n"					\
+		"	.long 29b,3b\n"					\
+		"	.long 30b,3b\n"					\
+		"	.long 31b,3b\n"					\
+		"	.long 32b,3b\n"					\
+		"	.long 33b,3b\n"					\
+		"	.long 34b,3b\n"					\
+		"	.long 35b,3b\n"					\
+		"	.long 36b,3b\n"					\
+		"	.long 37b,4b\n"					\
+		"	.previous\n"					\
+		: "=r" (to), "=r" (from), "=r" (ret), "=d" (n)		\
+		: "0" (to), "1" (from), "2" (ret), "3" (n)		\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*	rewind 'to' and 'from'  pointers when a fault occurs
+ *
+ *	Rationale:
+ *		A fault always occurs on writing to user buffer. A fault
+ *		is at a single address, so we need to rewind by only 4
+ *		bytes.
+ *		Since we do a complete read from kernel buffer before
+ *		writing, we need to rewind it also. The amount to be
+ *		rewind equals the number of faulty writes in MSETD
+ *		which is: [4 - (LSM_STEP-1)]*4
+ *		LSM_STEP is bits 10:8 in TXSTATUS which is already read
+ *		and stored in D0Ar2
+ *
+ *		NOTE: If a fault occurs at the last operation in M{G,S}ETL
+ *			LSM_STEP will be 0. ie: we do 4 writes in our case, if
+ *			a fault happens at the 4th write, LSM_STEP will be 0
+ *			instead of 4. The code copes with that.
+ *
+ *		n is updated by the number of successful writes, which is:
+ *		n = n - (LSM_STEP-1)*4
+ */
+#define __asm_copy_to_user_32bit_rapf_loop(to, from, ret, n, id)\
+	__asm_copy_user_32bit_rapf_loop(to, from, ret, n, id,		\
+		"LSR	D0Ar2, D0Ar2, #8\n"				\
+		"AND	D0Ar2, D0Ar2, #0x7\n"				\
+		"ADDZ	D0Ar2, D0Ar2, #4\n"				\
+		"SUB	D0Ar2, D0Ar2, #1\n"				\
+		"MOV	D1Ar1, #4\n"					\
+		"SUB	D0Ar2, D1Ar1, D0Ar2\n"				\
+		"LSL	D0Ar2, D0Ar2, #2\n"				\
+		"LSL	D1Ar1, D1Ar1, #2\n"				\
+		"SUB	D1Ar1, D1Ar1, D0Ar2\n"				\
+		"SUB	%0, %0, #4\n"					\
+		"SUB	%1,	%1,	D0Ar2\n"			\
+		"SUB	%3, %3, D1Ar1\n")
+
+unsigned long __copy_user(void __user *pdst, const void *psrc,
+			  unsigned long n)
+{
+	register char __user *dst asm ("A0.2") = pdst;
+	register const char *src asm ("A1.2") = psrc;
+	unsigned long retn = 0;
+
+	if (n == 0)
+		return 0;
+
+	if ((unsigned long) src & 1) {
+		__asm_copy_to_user_1(dst, src, retn);
+		n--;
+	}
+	if ((unsigned long) dst & 1) {
+		/* Worst case - byte copy */
+		while (n > 0) {
+			__asm_copy_to_user_1(dst, src, retn);
+			n--;
+		}
+	}
+	if (((unsigned long) src & 2) && n >= 2) {
+		__asm_copy_to_user_2(dst, src, retn);
+		n -= 2;
+	}
+	if ((unsigned long) dst & 2) {
+		/* Second worst case - word copy */
+		while (n >= 2) {
+			__asm_copy_to_user_2(dst, src, retn);
+			n -= 2;
+		}
+	}
+
+#ifdef USE_RAPF
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (__force unsigned long) dst) & 7)) {
+		if (n >= RAPF_MIN_BUF_SIZE) {
+			/* copy user using 64 bit rapf copy */
+			__asm_copy_to_user_64bit_rapf_loop(dst, src, retn,
+							n, "64cu");
+		}
+		while (n >= 8) {
+			__asm_copy_to_user_8x64(dst, src, retn);
+			n -= 8;
+		}
+	}
+	if (n >= RAPF_MIN_BUF_SIZE) {
+		/* copy user using 32 bit rapf copy */
+		__asm_copy_to_user_32bit_rapf_loop(dst, src, retn, n, "32cu");
+	}
+#else
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (__force unsigned long) dst) & 7)) {
+		while (n >= 8) {
+			__asm_copy_to_user_8x64(dst, src, retn);
+			n -= 8;
+		}
+	}
+#endif
+
+	while (n >= 16) {
+		__asm_copy_to_user_16(dst, src, retn);
+		n -= 16;
+	}
+
+	while (n >= 4) {
+		__asm_copy_to_user_4(dst, src, retn);
+		n -= 4;
+	}
+
+	switch (n) {
+	case 0:
+		break;
+	case 1:
+		__asm_copy_to_user_1(dst, src, retn);
+		break;
+	case 2:
+		__asm_copy_to_user_2(dst, src, retn);
+		break;
+	case 3:
+		__asm_copy_to_user_3(dst, src, retn);
+		break;
+	}
+
+	return retn;
+}
+
+#define __asm_copy_from_user_1(to, from, ret) \
+	__asm_copy_user_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"	\
+		"2:	SETB [%0++],D1Ar1\n",	\
+		"3:	ADD  %2,%2,#1\n"	\
+		"	SETB [%0++],D1Ar1\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_copy_from_user_2x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"2:	SETW [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_from_user_2(to, from, ret) \
+	__asm_copy_from_user_2x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_3(to, from, ret)		\
+	__asm_copy_from_user_2x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_from_user_4x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"2:	SETD [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#4\n"		\
+		"	SETD [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_from_user_4(to, from, ret) \
+	__asm_copy_from_user_4x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_5(to, from, ret) \
+	__asm_copy_from_user_4x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_from_user_6x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_4x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"4:	SETW [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_from_user_6(to, from, ret) \
+	__asm_copy_from_user_6x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_7(to, from, ret) \
+	__asm_copy_from_user_6x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_from_user_8x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_4x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"4:	SETD [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#4\n"			\
+		"	SETD [%0++],D1Ar1\n" FIXUP,		\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_from_user_8(to, from, ret) \
+	__asm_copy_from_user_8x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_9(to, from, ret) \
+	__asm_copy_from_user_8x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_from_user_10x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_8x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"6:	SETW [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_copy_from_user_10(to, from, ret) \
+	__asm_copy_from_user_10x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_11(to, from, ret)		\
+	__asm_copy_from_user_10x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_from_user_12x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_8x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"6:	SETD [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#4\n"		\
+		"	SETD [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_copy_from_user_12(to, from, ret) \
+	__asm_copy_from_user_12x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_13(to, from, ret) \
+	__asm_copy_from_user_12x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_from_user_14x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_12x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"8:	SETW [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_from_user_14(to, from, ret) \
+	__asm_copy_from_user_14x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_15(to, from, ret) \
+	__asm_copy_from_user_14x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"10:	SETB [%0++],D1Ar1\n",		\
+		"11:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 10b,11b\n")
+
+#define __asm_copy_from_user_16x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_12x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"8:	SETD [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#4\n"		\
+		"	SETD [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_from_user_16(to, from, ret) \
+	__asm_copy_from_user_16x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_8x64(to, from, ret) \
+	asm volatile (				\
+		"	GETL D0Ar2,D1Ar1,[%1++]\n"	\
+		"2:	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"	MOV D1Ar1,#0\n"			\
+		"	MOV D0Ar2,#0\n"			\
+		"3:	ADD  %2,%2,#8\n"		\
+		"	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"	MOVT    D0Ar2,#HI(1b)\n"	\
+		"	JUMP    D0Ar2,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.long 2b,3b\n"			\
+		"	.previous\n"			\
+		: "=a" (to), "=r" (from), "=r" (ret)	\
+		: "0" (to), "1" (from), "2" (ret)	\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*	rewind 'from' pointer when a fault occurs
+ *
+ *	Rationale:
+ *		A fault occurs while reading from user buffer, which is the
+ *		source. Since the fault is at a single address, we only
+ *		need to rewind by 8 bytes.
+ *		Since we don't write to kernel buffer until we read first,
+ *		the kernel buffer is at the right state and needn't be
+ *		corrected.
+ */
+#define __asm_copy_from_user_64bit_rapf_loop(to, from, ret, n, id)	\
+	__asm_copy_user_64bit_rapf_loop(to, from, ret, n, id,		\
+		"SUB	%1, %1, #8\n")
+
+/*	rewind 'from' pointer when a fault occurs
+ *
+ *	Rationale:
+ *		A fault occurs while reading from user buffer, which is the
+ *		source. Since the fault is at a single address, we only
+ *		need to rewind by 4 bytes.
+ *		Since we don't write to kernel buffer until we read first,
+ *		the kernel buffer is at the right state and needn't be
+ *		corrected.
+ */
+#define __asm_copy_from_user_32bit_rapf_loop(to, from, ret, n, id)	\
+	__asm_copy_user_32bit_rapf_loop(to, from, ret, n, id,		\
+		"SUB	%1, %1, #4\n")
+
+
+/* Copy from user to kernel, zeroing the bytes that were inaccessible in
+   userland.  The return-value is the number of bytes that were
+   inaccessible.  */
+unsigned long __copy_user_zeroing(void *pdst, const void __user *psrc,
+				  unsigned long n)
+{
+	register char *dst asm ("A0.2") = pdst;
+	register const char __user *src asm ("A1.2") = psrc;
+	unsigned long retn = 0;
+
+	if (n == 0)
+		return 0;
+
+	if ((unsigned long) src & 1) {
+		__asm_copy_from_user_1(dst, src, retn);
+		n--;
+	}
+	if ((unsigned long) dst & 1) {
+		/* Worst case - byte copy */
+		while (n > 0) {
+			__asm_copy_from_user_1(dst, src, retn);
+			n--;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+	if (((unsigned long) src & 2) && n >= 2) {
+		__asm_copy_from_user_2(dst, src, retn);
+		n -= 2;
+	}
+	if ((unsigned long) dst & 2) {
+		/* Second worst case - word copy */
+		while (n >= 2) {
+			__asm_copy_from_user_2(dst, src, retn);
+			n -= 2;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+
+	/* We only need one check after the unalignment-adjustments,
+	   because if both adjustments were done, either both or
+	   neither reference had an exception.  */
+	if (retn != 0)
+		goto copy_exception_bytes;
+
+#ifdef USE_RAPF
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (unsigned long) dst) & 7)) {
+		if (n >= RAPF_MIN_BUF_SIZE) {
+			/* Copy using fast 64bit rapf */
+			__asm_copy_from_user_64bit_rapf_loop(dst, src, retn,
+							n, "64cuz");
+		}
+		while (n >= 8) {
+			__asm_copy_from_user_8x64(dst, src, retn);
+			n -= 8;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+
+	if (n >= RAPF_MIN_BUF_SIZE) {
+		/* Copy using fast 32bit rapf */
+		__asm_copy_from_user_32bit_rapf_loop(dst, src, retn,
+						n, "32cuz");
+	}
+#else
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (unsigned long) dst) & 7)) {
+		while (n >= 8) {
+			__asm_copy_from_user_8x64(dst, src, retn);
+			n -= 8;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+#endif
+
+	while (n >= 4) {
+		__asm_copy_from_user_4(dst, src, retn);
+		n -= 4;
+
+		if (retn)
+			goto copy_exception_bytes;
+	}
+
+	/* If we get here, there were no memory read faults.  */
+	switch (n) {
+		/* These copies are at least "naturally aligned" (so we don't
+		   have to check each byte), due to the src alignment code.
+		   The *_3 case *will* get the correct count for retn.  */
+	case 0:
+		/* This case deliberately left in (if you have doubts check the
+		   generated assembly code).  */
+		break;
+	case 1:
+		__asm_copy_from_user_1(dst, src, retn);
+		break;
+	case 2:
+		__asm_copy_from_user_2(dst, src, retn);
+		break;
+	case 3:
+		__asm_copy_from_user_3(dst, src, retn);
+		break;
+	}
+
+	/* If we get here, retn correctly reflects the number of failing
+	   bytes.  */
+	return retn;
+
+ copy_exception_bytes:
+	/* We already have "retn" bytes cleared, and need to clear the
+	   remaining "n" bytes.  A non-optimized simple byte-for-byte in-line
+	   memset is preferred here, since this isn't speed-critical code and
+	   we'd rather have this a leaf-function than calling memset.  */
+	{
+		char *endp;
+		for (endp = dst + n; dst < endp; dst++)
+			*dst = 0;
+	}
+
+	return retn + n;
+}
+
+#define __asm_clear_8x64(to, ret) \
+	asm volatile (					\
+		"	MOV  D0Ar2,#0\n"		\
+		"	MOV  D1Ar1,#0\n"		\
+		"	SETL [%0],D0Ar2,D1Ar1\n"	\
+		"2:	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"3:	ADD  %1,%1,#8\n"		\
+		"	MOVT    D0Ar2,#HI(1b)\n"	\
+		"	JUMP    D0Ar2,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.long 2b,3b\n"			\
+		"	.previous\n"			\
+		: "=r" (to), "=r" (ret)	\
+		: "0" (to), "1" (ret)	\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/* Zero userspace.  */
+
+#define __asm_clear(to, ret, CLEAR, FIXUP, TENTRY) \
+	asm volatile (					\
+		"	MOV D1Ar1,#0\n"			\
+			CLEAR				\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+			FIXUP				\
+		"	MOVT    D1Ar1,#HI(1b)\n"	\
+		"	JUMP    D1Ar1,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+			TENTRY				\
+		"	.previous"			\
+		: "=r" (to), "=r" (ret)			\
+		: "0" (to), "1" (ret)			\
+		: "D1Ar1", "memory")
+
+#define __asm_clear_1(to, ret) \
+	__asm_clear(to, ret,			\
+		"	SETB [%0],D1Ar1\n"	\
+		"2:	SETB [%0++],D1Ar1\n",	\
+		"3:	ADD  %1,%1,#1\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_clear_2(to, ret) \
+	__asm_clear(to, ret,			\
+		"	SETW [%0],D1Ar1\n"	\
+		"2:	SETW [%0++],D1Ar1\n",	\
+		"3:	ADD  %1,%1,#2\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_clear_3(to, ret) \
+	__asm_clear(to, ret,			\
+		 "2:	SETW [%0++],D1Ar1\n"	\
+		 "	SETB [%0],D1Ar1\n"	\
+		 "3:	SETB [%0++],D1Ar1\n",	\
+		 "4:	ADD  %1,%1,#2\n"	\
+		 "5:	ADD  %1,%1,#1\n",	\
+		 "	.long 2b,4b\n"		\
+		 "	.long 3b,5b\n")
+
+#define __asm_clear_4x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear(to, ret,				\
+		"	SETD [%0],D1Ar1\n"		\
+		"2:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"3:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_clear_4(to, ret) \
+	__asm_clear_4x_cont(to, ret, "", "", "")
+
+#define __asm_clear_8x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear_4x_cont(to, ret,			\
+		"	SETD [%0],D1Ar1\n"		\
+		"4:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"5:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_clear_8(to, ret) \
+	__asm_clear_8x_cont(to, ret, "", "", "")
+
+#define __asm_clear_12x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear_8x_cont(to, ret,			\
+		"	SETD [%0],D1Ar1\n"		\
+		"6:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"7:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_clear_12(to, ret) \
+	__asm_clear_12x_cont(to, ret, "", "", "")
+
+#define __asm_clear_16x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear_12x_cont(to, ret,			\
+		"	SETD [%0],D1Ar1\n"		\
+		"8:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"9:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_clear_16(to, ret) \
+	__asm_clear_16x_cont(to, ret, "", "", "")
+
+unsigned long __do_clear_user(void __user *pto, unsigned long pn)
+{
+	register char __user *dst asm ("D0Re0") = pto;
+	register unsigned long n asm ("D1Re0") = pn;
+	register unsigned long retn asm ("D0Ar6") = 0;
+
+	if ((unsigned long) dst & 1) {
+		__asm_clear_1(dst, retn);
+		n--;
+	}
+
+	if ((unsigned long) dst & 2) {
+		__asm_clear_2(dst, retn);
+		n -= 2;
+	}
+
+	/* 64 bit copy loop */
+	if (!((__force unsigned long) dst & 7)) {
+		while (n >= 8) {
+			__asm_clear_8x64(dst, retn);
+			n -= 8;
+		}
+	}
+
+	while (n >= 16) {
+		__asm_clear_16(dst, retn);
+		n -= 16;
+	}
+
+	while (n >= 4) {
+		__asm_clear_4(dst, retn);
+		n -= 4;
+	}
+
+	switch (n) {
+	case 0:
+		break;
+	case 1:
+		__asm_clear_1(dst, retn);
+		break;
+	case 2:
+		__asm_clear_2(dst, retn);
+		break;
+	case 3:
+		__asm_clear_3(dst, retn);
+		break;
+	}
+
+	return retn;
+}
+
+unsigned char __get_user_asm_b(const void __user *addr, long *err)
+{
+	register unsigned char x asm ("D0Re0") = 0;
+	asm volatile (
+		"	GETB %0,[%2]\n"
+		"1:\n"
+		"	GETB %0,[%2]\n"
+		"2:\n"
+		"	.section .fixup,\"ax\"\n"
+		"3:	MOV     D0FrT,%3\n"
+		"	SETD    [%1],D0FrT\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		"	.previous\n"
+		"	.section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		"	.previous\n"
+		: "=r" (x)
+		: "r" (err), "r" (addr), "P" (-EFAULT)
+		: "D0FrT");
+	return x;
+}
+
+unsigned short __get_user_asm_w(const void __user *addr, long *err)
+{
+	register unsigned short x asm ("D0Re0") = 0;
+	asm volatile (
+		"	GETW %0,[%2]\n"
+		"1:\n"
+		"	GETW %0,[%2]\n"
+		"2:\n"
+		"	.section .fixup,\"ax\"\n"
+		"3:	MOV     D0FrT,%3\n"
+		"	SETD    [%1],D0FrT\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		"	.previous\n"
+		"	.section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		"	.previous\n"
+		: "=r" (x)
+		: "r" (err), "r" (addr), "P" (-EFAULT)
+		: "D0FrT");
+	return x;
+}
+
+unsigned int __get_user_asm_d(const void __user *addr, long *err)
+{
+	register unsigned int x asm ("D0Re0") = 0;
+	asm volatile (
+		"	GETD %0,[%2]\n"
+		"1:\n"
+		"	GETD %0,[%2]\n"
+		"2:\n"
+		"	.section .fixup,\"ax\"\n"
+		"3:	MOV     D0FrT,%3\n"
+		"	SETD    [%1],D0FrT\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		"	.previous\n"
+		"	.section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		"	.previous\n"
+		: "=r" (x)
+		: "r" (err), "r" (addr), "P" (-EFAULT)
+		: "D0FrT");
+	return x;
+}
+
+long __put_user_asm_b(unsigned int x, void __user *addr)
+{
+	register unsigned int err asm ("D0Re0") = 0;
+	asm volatile (
+		"	MOV  %0,#0\n"
+		"	SETB [%2],%1\n"
+		"1:\n"
+		"	SETB [%2],%1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long __put_user_asm_w(unsigned int x, void __user *addr)
+{
+	register unsigned int err asm ("D0Re0") = 0;
+	asm volatile (
+		"	MOV  %0,#0\n"
+		"	SETW [%2],%1\n"
+		"1:\n"
+		"	SETW [%2],%1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long __put_user_asm_d(unsigned int x, void __user *addr)
+{
+	register unsigned int err asm ("D0Re0") = 0;
+	asm volatile (
+		"	MOV  %0,#0\n"
+		"	SETD [%2],%1\n"
+		"1:\n"
+		"	SETD [%2],%1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long __put_user_asm_l(unsigned long long x, void __user *addr)
+{
+	register unsigned int err asm ("D0Re0") = 0;
+	asm volatile (
+		"	MOV  %0,#0\n"
+		"	SETL [%2],%1,%t1\n"
+		"1:\n"
+		"	SETL [%2],%1,%t1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long strnlen_user(const char __user *src, long count)
+{
+	long res;
+
+	if (!access_ok(VERIFY_READ, src, 0))
+		return 0;
+
+	asm volatile ("	MOV     D0Ar4, %1\n"
+		      "	MOV     D0Ar6, %2\n"
+		      "0:\n"
+		      "	SUBS    D0FrT, D0Ar6, #0\n"
+		      "	SUB     D0Ar6, D0Ar6, #1\n"
+		      "	BLE     2f\n"
+		      "	GETB    D0FrT, [D0Ar4+#1++]\n"
+		      "1:\n"
+		      "	TST     D0FrT, #255\n"
+		      "	BNE     0b\n"
+		      "2:\n"
+		      "	SUB     %0, %2, D0Ar6\n"
+		      "3:\n"
+		      "	.section .fixup,\"ax\"\n"
+		      "4:\n"
+		      "	MOV     %0, #0\n"
+		      "	MOVT    D0FrT,#HI(3b)\n"
+		      "	JUMP    D0FrT,#LO(3b)\n"
+		      "	.previous\n"
+		      "	.section __ex_table,\"a\"\n"
+		      "	.long 1b,4b\n"
+		      "	.previous\n"
+		      : "=r" (res)
+		      : "r" (src), "r" (count)
+		      : "D0FrT", "D0Ar4", "D0Ar6", "cc");
+
+	return res;
+}
+
+long __strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res;
+
+	if (count == 0)
+		return 0;
+
+	/*
+	 * Currently, in 2.4.0-test9, most ports use a simple byte-copy loop.
+	 *  So do we.
+	 *
+	 *  This code is deduced from:
+	 *
+	 *      char tmp2;
+	 *      long tmp1, tmp3;
+	 *      tmp1 = count;
+	 *      while ((*dst++ = (tmp2 = *src++)) != 0
+	 *             && --tmp1)
+	 *        ;
+	 *
+	 *      res = count - tmp1;
+	 *
+	 *  with tweaks.
+	 */
+
+	asm volatile ("	MOV  %0,%3\n"
+		      "1:\n"
+		      "	GETB D0FrT,[%2++]\n"
+		      "2:\n"
+		      "	CMP  D0FrT,#0\n"
+		      "	SETB [%1++],D0FrT\n"
+		      "	BEQ  3f\n"
+		      "	SUBS %0,%0,#1\n"
+		      "	BNZ  1b\n"
+		      "3:\n"
+		      "	SUB  %0,%3,%0\n"
+		      "4:\n"
+		      "	.section .fixup,\"ax\"\n"
+		      "5:\n"
+		      "	MOV  %0,%7\n"
+		      "	MOVT    D0FrT,#HI(4b)\n"
+		      "	JUMP    D0FrT,#LO(4b)\n"
+		      "	.previous\n"
+		      "	.section __ex_table,\"a\"\n"
+		      "	.long 2b,5b\n"
+		      "	.previous"
+		      : "=r" (res), "=r" (dst), "=r" (src), "=r" (count)
+		      : "3" (count), "1" (dst), "2" (src), "P" (-EFAULT)
+		      : "D0FrT", "memory", "cc");
+
+	return res;
+}
diff --git a/arch/metag/mm/ioremap.c b/arch/metag/mm/ioremap.c
new file mode 100644
index 0000000..a136a43
--- /dev/null
+++ b/arch/metag/mm/ioremap.c
@@ -0,0 +1,89 @@
+/*
+ * Re-map IO memory to kernel address space so that we can access it.
+ * Needed for memory-mapped I/O devices mapped outside our normal DRAM
+ * window (that is, all memory-mapped I/O devices).
+ *
+ * Copyright (C) 1995,1996 Linus Torvalds
+ *
+ * Meta port based on CRIS-port by Axis Communications AB
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+
+#include <asm/pgtable.h>
+
+/*
+ * Remap an arbitrary physical address space into the kernel virtual
+ * address space. Needed when the kernel wants to access high addresses
+ * directly.
+ *
+ * NOTE! We need to allow non-page-aligned mappings too: we will obviously
+ * have to convert them into an offset in a page-aligned mapping, but the
+ * caller shouldn't need to know that small detail.
+ */
+void __iomem *__ioremap(unsigned long phys_addr, size_t size,
+			unsigned long flags)
+{
+	unsigned long addr;
+	struct vm_struct *area;
+	unsigned long offset, last_addr;
+	pgprot_t prot;
+
+	/* Don't allow wraparound or zero size */
+	last_addr = phys_addr + size - 1;
+	if (!size || last_addr < phys_addr)
+		return NULL;
+
+	/* Custom region addresses are accessible and uncached by default. */
+	if (phys_addr >= LINSYSCUSTOM_BASE &&
+	    phys_addr < (LINSYSCUSTOM_BASE + LINSYSCUSTOM_LIMIT))
+		return (__force void __iomem *) phys_addr;
+
+	/*
+	 * Mappings have to be page-aligned
+	 */
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(last_addr+1) - phys_addr;
+	prot = __pgprot(_PAGE_PRESENT | _PAGE_WRITE | _PAGE_DIRTY |
+			_PAGE_ACCESSED | _PAGE_KERNEL | _PAGE_CACHE_WIN0 |
+			flags);
+
+	/*
+	 * Ok, go for it..
+	 */
+	area = get_vm_area(size, VM_IOREMAP);
+	if (!area)
+		return NULL;
+	area->phys_addr = phys_addr;
+	addr = (unsigned long) area->addr;
+	if (ioremap_page_range(addr, addr + size, phys_addr, prot)) {
+		vunmap((void *) addr);
+		return NULL;
+	}
+	return (__force void __iomem *) (offset + (char *)addr);
+}
+EXPORT_SYMBOL(__ioremap);
+
+void __iounmap(void __iomem *addr)
+{
+	struct vm_struct *p;
+
+	if ((__force unsigned long)addr >= LINSYSCUSTOM_BASE &&
+	    (__force unsigned long)addr < (LINSYSCUSTOM_BASE +
+					   LINSYSCUSTOM_LIMIT))
+		return;
+
+	p = remove_vm_area((void *)(PAGE_MASK & (unsigned long __force)addr));
+	if (unlikely(!p)) {
+		pr_err("iounmap: bad address %p\n", addr);
+		return;
+	}
+
+	kfree(p);
+}
+EXPORT_SYMBOL(__iounmap);
diff --git a/arch/metag/mm/maccess.c b/arch/metag/mm/maccess.c
new file mode 100644
index 0000000..eba2cfc
--- /dev/null
+++ b/arch/metag/mm/maccess.c
@@ -0,0 +1,68 @@
+/*
+ * safe read and write memory routines callable while atomic
+ *
+ * Copyright 2012 Imagination Technologies
+ */
+
+#include <linux/uaccess.h>
+#include <asm/io.h>
+
+/*
+ * The generic probe_kernel_write() uses the user copy code which can split the
+ * writes if the source is unaligned, and repeats writes to make exceptions
+ * precise. We override it here to avoid these things happening to memory mapped
+ * IO memory where they could have undesired effects.
+ * Due to the use of CACHERD instruction this only works on Meta2 onwards.
+ */
+#ifdef CONFIG_METAG_META21
+long probe_kernel_write(void *dst, const void *src, size_t size)
+{
+	unsigned long ldst = (unsigned long)dst;
+	void __iomem *iodst = (void __iomem *)dst;
+	unsigned long lsrc = (unsigned long)src;
+	const u8 *psrc = (u8 *)src;
+	unsigned int pte, i;
+	u8 bounce[8] __aligned(8);
+
+	if (!size)
+		return 0;
+
+	/* Use the write combine bit to decide is the destination is MMIO. */
+	pte = __builtin_meta2_cacherd(dst);
+
+	/* Check the mapping is valid and writeable. */
+	if ((pte & (MMCU_ENTRY_WR_BIT | MMCU_ENTRY_VAL_BIT))
+	    != (MMCU_ENTRY_WR_BIT | MMCU_ENTRY_VAL_BIT))
+		return -EFAULT;
+
+	/* Fall back to generic version for cases we're not interested in. */
+	if (pte & MMCU_ENTRY_WRC_BIT	|| /* write combined memory */
+	    (ldst & (size - 1))		|| /* destination unaligned */
+	    size > 8			|| /* more than max write size */
+	    (size & (size - 1)))	   /* non power of 2 size */
+		return __probe_kernel_write(dst, src, size);
+
+	/* If src is unaligned, copy to the aligned bounce buffer first. */
+	if (lsrc & (size - 1)) {
+		for (i = 0; i < size; ++i)
+			bounce[i] = psrc[i];
+		psrc = bounce;
+	}
+
+	switch (size) {
+	case 1:
+		writeb(*psrc, iodst);
+		break;
+	case 2:
+		writew(*(const u16 *)psrc, iodst);
+		break;
+	case 4:
+		writel(*(const u32 *)psrc, iodst);
+		break;
+	case 8:
+		writeq(*(const u64 *)psrc, iodst);
+		break;
+	}
+	return 0;
+}
+#endif
-- 
1.7.7.6


