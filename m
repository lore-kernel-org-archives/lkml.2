Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2LEQUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:20:31 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55566 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab2LEQJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:30 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 15/44] metag: Memory handling
Date: Wed, 5 Dec 2012 16:08:33 +0000
Message-ID: <1354723742-6195-16-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_21
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
 - User memory (uaccess.h): User memory is directly accessible from
   privileged code.
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
 arch/metag/include/asm/io.h      |  165 ++++++++++++++++++++++++++
 arch/metag/include/asm/uaccess.h |  241 ++++++++++++++++++++++++++++++++++++++
 arch/metag/mm/ioremap.c          |   89 ++++++++++++++
 arch/metag/mm/maccess.c          |   68 +++++++++++
 4 files changed, 563 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/io.h
 create mode 100644 arch/metag/include/asm/uaccess.h
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
index 0000000..632b461
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
+	pte = TBIXCACHE_RD(dst);
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


