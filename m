Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2IGQeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:34:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34390 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2IGQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:54 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 13/31] arm64: Device specific operations
Date: Fri,  7 Sep 2012 17:26:48 +0100
Message-Id: <1347035226-18649-14-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:52.0550 (UTC) FILETIME=[BA726060:01CD8D15]
X-MC-Unique: 112090717275212001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GZ5Ee008455

This patch adds several definitions for device communication, including
I/O accessors and ioremap(). The __raw_* accessors are implemented as
inline asm to avoid compiler generation of post-indexed accesses (less
efficient to emulate in a virtualised environment).

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/device.h |   26 ++++
 arch/arm64/include/asm/fb.h     |   34 +++++
 arch/arm64/include/asm/io.h     |  263 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/io.c          |   64 ++++++++++
 arch/arm64/mm/ioremap.c         |   84 +++++++++++++
 5 files changed, 471 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/device.h
 create mode 100644 arch/arm64/include/asm/fb.h
 create mode 100644 arch/arm64/include/asm/io.h
 create mode 100644 arch/arm64/kernel/io.c
 create mode 100644 arch/arm64/mm/ioremap.c

diff --git a/arch/arm64/include/asm/device.h b/arch/arm64/include/asm/device.h
new file mode 100644
index 0000000..0d8453c
--- /dev/null
+++ b/arch/arm64/include/asm/device.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_DEVICE_H
+#define __ASM_DEVICE_H
+
+struct dev_archdata {
+	struct dma_map_ops *dma_ops;
+};
+
+struct pdev_archdata {
+};
+
+#endif
diff --git a/arch/arm64/include/asm/fb.h b/arch/arm64/include/asm/fb.h
new file mode 100644
index 0000000..adb88a6
--- /dev/null
+++ b/arch/arm64/include/asm/fb.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_FB_H_
+#define __ASM_FB_H_
+
+#include <linux/fb.h>
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
+				unsigned long off)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
+#endif /* __ASM_FB_H_ */
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
new file mode 100644
index 0000000..48fa83f
--- /dev/null
+++ b/arch/arm64/include/asm/io.h
@@ -0,0 +1,263 @@
+/*
+ * Based on arch/arm/include/asm/io.h
+ *
+ * Copyright (C) 1996-2000 Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_IO_H
+#define __ASM_IO_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+
+#include <asm/byteorder.h>
+#include <asm/barrier.h>
+#include <asm/pgtable.h>
+
+/*
+ * Generic IO read/write.  These perform native-endian accesses.
+ */
+static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
+{
+	asm volatile("strb %w0, [%1]" : : "r" (val), "r" (addr));
+}
+
+static inline void __raw_writew(u16 val, volatile void __iomem *addr)
+{
+	asm volatile("strh %w0, [%1]" : : "r" (val), "r" (addr));
+}
+
+static inline void __raw_writel(u32 val, volatile void __iomem *addr)
+{
+	asm volatile("str %w0, [%1]" : : "r" (val), "r" (addr));
+}
+
+static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
+{
+	asm volatile("str %0, [%1]" : : "r" (val), "r" (addr));
+}
+
+static inline u8 __raw_readb(const volatile void __iomem *addr)
+{
+	u8 val;
+	asm volatile("ldrb %w0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
+static inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	u16 val;
+	asm volatile("ldrh %w0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	u32 val;
+	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
+static inline u64 __raw_readq(const volatile void __iomem *addr)
+{
+	u64 val;
+	asm volatile("ldr %0, [%1]" : "=r" (val) : "r" (addr));
+	return val;
+}
+
+/* IO barriers */
+#define __iormb()		rmb()
+#define __iowmb()		wmb()
+
+#define mmiowb()		do { } while (0)
+
+/*
+ * Relaxed I/O memory access primitives. These follow the Device memory
+ * ordering rules but do not guarantee any ordering relative to Normal memory
+ * accesses.
+ */
+#define readb_relaxed(c)	({ u8  __v = __raw_readb(c); __v; })
+#define readw_relaxed(c)	({ u16 __v = le16_to_cpu((__force __le16)__raw_readw(c)); __v; })
+#define readl_relaxed(c)	({ u32 __v = le32_to_cpu((__force __le32)__raw_readl(c)); __v; })
+
+#define writeb_relaxed(v,c)	((void)__raw_writeb((v),(c)))
+#define writew_relaxed(v,c)	((void)__raw_writew((__force u16)cpu_to_le16(v),(c)))
+#define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
+
+/*
+ * I/O memory access primitives. Reads are ordered relative to any
+ * following Normal memory access. Writes are ordered relative to any prior
+ * Normal memory access.
+ */
+#define readb(c)		({ u8  __v = readb_relaxed(c); __iormb(); __v; })
+#define readw(c)		({ u16 __v = readw_relaxed(c); __iormb(); __v; })
+#define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(); __v; })
+
+#define writeb(v,c)		({ __iowmb(); writeb_relaxed((v),(c)); })
+#define writew(v,c)		({ __iowmb(); writew_relaxed((v),(c)); })
+#define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c)); })
+
+/*
+ *  I/O port access primitives.
+ */
+#define IO_SPACE_LIMIT		0xffff
+
+/*
+ * We currently don't have any platform with PCI support, so just leave this
+ * defined to 0 until needed.
+ */
+#define PCI_IOBASE		((void __iomem *)0)
+
+static inline u8 inb(unsigned long addr)
+{
+	return readb(addr + PCI_IOBASE);
+}
+
+static inline u16 inw(unsigned long addr)
+{
+	return readw(addr + PCI_IOBASE);
+}
+
+static inline u32 inl(unsigned long addr)
+{
+	return readl(addr + PCI_IOBASE);
+}
+
+static inline void outb(u8 b, unsigned long addr)
+{
+	writeb(b, addr + PCI_IOBASE);
+}
+
+static inline void outw(u16 b, unsigned long addr)
+{
+	writew(b, addr + PCI_IOBASE);
+}
+
+static inline void outl(u32 b, unsigned long addr)
+{
+	writel(b, addr + PCI_IOBASE);
+}
+
+#define inb_p(addr)	inb(addr)
+#define inw_p(addr)	inw(addr)
+#define inl_p(addr)	inl(addr)
+
+#define outb_p(x, addr)	outb((x), (addr))
+#define outw_p(x, addr)	outw((x), (addr))
+#define outl_p(x, addr)	outl((x), (addr))
+
+static inline void insb(unsigned long addr, void *buffer, int count)
+{
+	u8 *buf = buffer;
+	while (count--)
+		*buf++ = __raw_readb(addr + PCI_IOBASE);
+}
+
+static inline void insw(unsigned long addr, void *buffer, int count)
+{
+	u16 *buf = buffer;
+	while (count--)
+		*buf++ = __raw_readw(addr + PCI_IOBASE);
+}
+
+static inline void insl(unsigned long addr, void *buffer, int count)
+{
+	u32 *buf = buffer;
+	while (count--)
+		*buf++ = __raw_readl(addr + PCI_IOBASE);
+}
+
+static inline void outsb(unsigned long addr, const void *buffer, int count)
+{
+	const u8 *buf = buffer;
+	while (count--)
+		__raw_writeb(*buf++, addr + PCI_IOBASE);
+}
+
+static inline void outsw(unsigned long addr, const void *buffer, int count)
+{
+	const u16 *buf = buffer;
+	while (count--)
+		__raw_writew(*buf++, addr + PCI_IOBASE);
+}
+
+static inline void outsl(unsigned long addr, const void *buffer, int count)
+{
+	const u32 *buf = buffer;
+	while (count--)
+		__raw_writel(*buf++, addr + PCI_IOBASE);
+}
+
+#define insb_p(port,to,len)	insb(port,to,len)
+#define insw_p(port,to,len)	insw(port,to,len)
+#define insl_p(port,to,len)	insl(port,to,len)
+
+#define outsb_p(port,from,len)	outsb(port,from,len)
+#define outsw_p(port,from,len)	outsw(port,from,len)
+#define outsl_p(port,from,len)	outsl(port,from,len)
+
+/*
+ * String version of I/O memory access operations.
+ */
+extern void __memcpy_fromio(void *, const volatile void __iomem *, size_t);
+extern void __memcpy_toio(volatile void __iomem *, const void *, size_t);
+extern void __memset_io(volatile void __iomem *, int, size_t);
+
+#define memset_io(c,v,l)	__memset_io((c),(v),(l))
+#define memcpy_fromio(a,c,l)	__memcpy_fromio((a),(c),(l))
+#define memcpy_toio(c,a,l)	__memcpy_toio((c),(a),(l))
+
+/*
+ * I/O memory mapping functions.
+ */
+extern void __iomem *__ioremap(phys_addr_t phys_addr, size_t size, pgprot_t prot);
+extern void __iounmap(volatile void __iomem *addr);
+
+#define PROT_DEFAULT		(PTE_TYPE_PAGE | PTE_AF | PTE_DIRTY)
+#define PROT_DEVICE_nGnRE	(PROT_DEFAULT | PTE_XN | PTE_ATTRINDX(MT_DEVICE_nGnRE))
+#define PROT_NORMAL_NC		(PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL_NC))
+
+#define ioremap(addr, size)		__ioremap((addr), (size), PROT_DEVICE_nGnRE)
+#define ioremap_nocache(addr, size)	__ioremap((addr), (size), PROT_DEVICE_nGnRE)
+#define ioremap_wc(addr, size)		__ioremap((addr), (size), PROT_NORMAL_NC)
+#define iounmap				__iounmap
+
+#define ARCH_HAS_IOREMAP_WC
+#include <asm-generic/iomap.h>
+
+/*
+ * More restrictive address range checking than the default implementation
+ * (PHYS_OFFSET and PHYS_MASK taken into account).
+ */
+#define ARCH_HAS_VALID_PHYS_ADDR_RANGE
+extern int valid_phys_addr_range(unsigned long addr, size_t size);
+extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
+
+extern int devmem_is_allowed(unsigned long pfn);
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+#endif	/* __KERNEL__ */
+#endif	/* __ASM_IO_H */
diff --git a/arch/arm64/kernel/io.c b/arch/arm64/kernel/io.c
new file mode 100644
index 0000000..7d37ead
--- /dev/null
+++ b/arch/arm64/kernel/io.c
@@ -0,0 +1,64 @@
+/*
+ * Based on arch/arm/kernel/io.c
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/io.h>
+
+/*
+ * Copy data from IO memory space to "real" memory space.
+ */
+void __memcpy_fromio(void *to, const volatile void __iomem *from, size_t count)
+{
+	unsigned char *t = to;
+	while (count) {
+		count--;
+		*t = readb(from);
+		t++;
+		from++;
+	}
+}
+EXPORT_SYMBOL(__memcpy_fromio);
+
+/*
+ * Copy data from "real" memory space to IO memory space.
+ */
+void __memcpy_toio(volatile void __iomem *to, const void *from, size_t count)
+{
+	const unsigned char *f = from;
+	while (count) {
+		count--;
+		writeb(*f, to);
+		f++;
+		to++;
+	}
+}
+EXPORT_SYMBOL(__memcpy_toio);
+
+/*
+ * "memset" on IO memory space.
+ */
+void __memset_io(volatile void __iomem *dst, int c, size_t count)
+{
+	while (count) {
+		count--;
+		writeb(c, dst);
+		dst++;
+	}
+}
+EXPORT_SYMBOL(__memset_io);
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
new file mode 100644
index 0000000..1725cd6
--- /dev/null
+++ b/arch/arm64/mm/ioremap.c
@@ -0,0 +1,84 @@
+/*
+ * Based on arch/arm/mm/ioremap.c
+ *
+ * (C) Copyright 1995 1996 Linus Torvalds
+ * Hacked for ARM by Phil Blundell <philb@gnu.org>
+ * Hacked to allow all architectures to build, and various cleanups
+ * by Russell King
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+
+static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
+				      pgprot_t prot, void *caller)
+{
+	unsigned long last_addr;
+	unsigned long offset = phys_addr & ~PAGE_MASK;
+	int err;
+	unsigned long addr;
+	struct vm_struct *area;
+
+	/*
+	 * Page align the mapping address and size, taking account of any
+	 * offset.
+	 */
+	phys_addr &= PAGE_MASK;
+	size = PAGE_ALIGN(size + offset);
+
+	/*
+	 * Don't allow wraparound, zero size or outside PHYS_MASK.
+	 */
+	last_addr = phys_addr + size - 1;
+	if (!size || last_addr < phys_addr || (last_addr & ~PHYS_MASK))
+		return NULL;
+
+	/*
+	 * Don't allow RAM to be mapped.
+	 */
+	if (WARN_ON(pfn_valid(__phys_to_pfn(phys_addr))))
+		return NULL;
+
+	area = get_vm_area_caller(size, VM_IOREMAP, caller);
+	if (!area)
+		return NULL;
+	addr = (unsigned long)area->addr;
+
+	err = ioremap_page_range(addr, addr + size, phys_addr, prot);
+	if (err) {
+		vunmap((void *)addr);
+		return NULL;
+	}
+
+	return (void __iomem *)(offset + addr);
+}
+
+void __iomem *__ioremap(phys_addr_t phys_addr, size_t size, pgprot_t prot)
+{
+	return __ioremap_caller(phys_addr, size, prot,
+				__builtin_return_address(0));
+}
+EXPORT_SYMBOL(__ioremap);
+
+void __iounmap(volatile void __iomem *io_addr)
+{
+	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
+
+	vunmap(addr);
+}
+EXPORT_SYMBOL(__iounmap);

