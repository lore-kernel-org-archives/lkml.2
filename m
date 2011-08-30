Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1H3TTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:19:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42353 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab1H3TPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113875183"
Message-Id: <20110830190801.995980546@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:07:53 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch v2 24/35] Hexagon: Provide basic implementation and/or stubs for I/O routines.
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=io.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed read/write to use inline assembly.

Rearranged the file and put all the ioport stuff at the bottom.  For now
I'd like to just leave the stubs in there in case they need to be
filled out later; plus things don't compile.

We still seem to need IO_SPACE_LIMIT to be defined, particularly to something
large, as we have drivers that request resources with IORESOURCE_IO that
are memory mapped IO.  The ioread/iowrites work as they select the correct
routine to use.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/include/asm/io.h |  297 ++++++++++++++++++++++++++++++++++++++++++
 arch/hexagon/lib/io.c         |   91 ++++++++++++
 2 files changed, 388 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/io.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/io.h	2011-08-24 18:45:48.323877271 -0500
@@ -0,0 +1,297 @@
+/*
+ * IO definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
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
+#ifndef _ASM_IO_H
+#define _ASM_IO_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/vmalloc.h>
+#include <asm/string.h>
+#include <asm/mem-layout.h>
+#include <asm/iomap.h>
+#include <asm/page.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
+
+/*
+ * We don't have PCI yet.
+ */
+#define IO_SPACE_LIMIT 0xffffffff
+#define _IO_BASE 0x0
+
+extern int remap_area_pages(unsigned long start, unsigned long phys_addr,
+				unsigned long end, unsigned long flags);
+
+extern void __iounmap(const volatile void __iomem *addr);
+
+/* Defined in lib/io.c, needed for smc91x driver. */
+extern void __raw_readsw(const void __iomem *addr, void *data, int wordlen);
+extern void __raw_writesw(void __iomem *addr, const void *data, int wordlen);
+
+extern void __raw_readsl(const void __iomem *addr, void *data, int wordlen);
+extern void __raw_writesl(void __iomem *addr, const void *data, int wordlen);
+
+#define readsw(p, d, l)	__raw_readsw(p, d, l)
+#define writesw(p, d, l) __raw_writesw(p, d, l)
+
+#define readsl(p, d, l)   __raw_readsl(p, d, l)
+#define writesl(p, d, l)  __raw_writesl(p, d, l)
+
+/*
+ * virt_to_phys - map virtual address to physical
+ * @address:  address to map
+ */
+static inline unsigned long virt_to_phys(volatile void *address)
+{
+	return __pa(address);
+}
+
+/*
+ * phys_to_virt - map physical address to virtual
+ * @address: address to map
+ */
+static inline void *phys_to_virt(unsigned long address)
+{
+	return __va(address);
+}
+
+/*
+ * convert a physical pointer to a virtual kernel pointer for
+ * /dev/mem access.
+ */
+#define xlate_dev_kmem_ptr(p)    __va(p)
+#define xlate_dev_mem_ptr(p)    __va(p)
+
+/*
+ * IO port access primitives.  Hexagon doesn't have special IO access
+ * instructions; all I/O is memory mapped.
+ *
+ * in/out are used for "ports", but we don't have "port instructions",
+ * so these are really just memory mapped too.
+ */
+
+/*
+ * readb - read byte from memory mapped device
+ * @addr:  pointer to memory
+ *
+ * Operates on "I/O bus memory space"
+ */
+static inline u8 readb(const volatile void __iomem *addr)
+{
+	u8 val;
+	asm volatile(
+		"%0 = memb(%1);"
+		: "=&r" (val)
+		: "r" (addr)
+	);
+	return val;
+}
+
+static inline u16 readw(const volatile void __iomem *addr)
+{
+	u16 val;
+	asm volatile(
+		"%0 = memh(%1);"
+		: "=&r" (val)
+		: "r" (addr)
+	);
+	return val;
+}
+
+static inline u32 readl(const volatile void __iomem *addr)
+{
+	u32 val;
+	asm volatile(
+		"%0 = memw(%1);"
+		: "=&r" (val)
+		: "r" (addr)
+	);
+	return val;
+}
+
+/*
+ * writeb - write a byte to a memory location
+ * @data: data to write to
+ * @addr:  pointer to memory
+ *
+ */
+static inline void writeb(u8 data, volatile void __iomem *addr)
+{
+	asm volatile(
+		"memb(%0) = %1;"
+		:
+		: "r" (addr), "r" (data)
+	);
+}
+
+static inline void writew(u16 data, volatile void __iomem *addr)
+{
+	asm volatile(
+		"memh(%0) = %1;"
+		:
+		: "r" (addr), "r" (data)
+	);
+
+}
+
+static inline void writel(u32 data, volatile void __iomem *addr)
+{
+	asm volatile(
+		"memw(%0) = %1;"
+		:
+		: "r" (addr), "r" (data)
+	);
+}
+
+#define __raw_writeb writeb
+#define __raw_writew writew
+#define __raw_writel writel
+
+#define __raw_readb readb
+#define __raw_readw readw
+#define __raw_readl readl
+
+/*
+ * Need an mtype somewhere in here, for cache type deals?
+ * This is probably too long for an inline.
+ */
+void __iomem *ioremap_nocache(unsigned long phys_addr, unsigned long size);
+
+static inline void __iomem *ioremap(unsigned long phys_addr, unsigned long size)
+{
+	return ioremap_nocache(phys_addr, size);
+}
+
+static inline void iounmap(volatile void __iomem *addr)
+{
+	__iounmap(addr);
+}
+
+#define __raw_writel writel
+
+static inline void memcpy_fromio(void *dst, const volatile void __iomem *src,
+	int count)
+{
+	memcpy(dst, (void *) src, count);
+}
+
+static inline void memcpy_toio(volatile void __iomem *dst, const void *src,
+	int count)
+{
+	memcpy((void *) dst, src, count);
+}
+
+#define PCI_IO_ADDR	volatile void __iomem *
+
+/*
+ * inb - read byte from I/O port or something
+ * @port:  address in I/O space
+ *
+ * Operates on "I/O bus I/O space"
+ */
+static inline u8 inb(unsigned long port)
+{
+	printk(KERN_INFO "inb not implemented\n");
+	return 0;
+}
+
+static inline u16 inw(unsigned long port)
+{
+	printk(KERN_INFO "inw not implemented\n");
+	return 0;
+}
+
+static inline u32 inl(unsigned long port)
+{
+	printk(KERN_INFO "inl not implemented\n");
+	return 0;
+}
+
+/*
+ * outb - write a byte to a memory location
+ * @data: data to write to
+ * @addr:  address in I/O space
+ */
+static inline void outb(u8 data, unsigned long port)
+{
+	writeb(data, (PCI_IO_ADDR)_IO_BASE+port);
+}
+
+static inline void outw(u16 data, unsigned long port)
+{
+	writew(data, (PCI_IO_ADDR)_IO_BASE+port);
+}
+
+static inline void outl(u32 data, unsigned long port)
+{
+	writel(data, (PCI_IO_ADDR)_IO_BASE+port);
+}
+
+/*  _p means "pause until the I/O completes"  */
+#define outb_p outb
+#define outw_p outw
+#define outl_p outl
+
+#define inb_p inb
+#define inw_p inw
+#define inl_p inl
+
+static inline void insb(unsigned long addr, void *buffer, int count)
+{
+	printk(KERN_INFO "insb not implemented\n");
+}
+
+static inline void insw(unsigned long addr, void *buffer, int count)
+{
+	printk(KERN_INFO "insw not implemented\n");
+}
+
+static inline void insl(unsigned long addr, void *buffer, int count)
+{
+	printk(KERN_INFO "insl not implemented\n");
+}
+
+static inline void outsb(unsigned long addr, const void *buffer, int count)
+{
+	printk(KERN_INFO "outsb not implemented\n");
+}
+
+static inline void outsw(unsigned long addr, const void *buffer, int count)
+{
+	printk(KERN_INFO "outsw not implemented\n");
+}
+
+static inline void outsl(unsigned long addr, const void *buffer, int count)
+{
+	printk(KERN_INFO "outsl not implemented\n");
+}
+
+/*  generic versions defined in lib/iomap.c  */
+extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomem *addr);
+
+#define flush_write_buffers() do { } while (0)
+
+#endif /* __KERNEL__ */
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/lib/io.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/lib/io.c	2011-08-24 18:45:48.323877271 -0500
@@ -0,0 +1,91 @@
+/*
+ * I/O access functions for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
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
+#include <asm/io.h>
+
+/*  These are all FIFO routines!  */
+
+/*
+ * __raw_readsw - read words a short at a time
+ * @addr:  source address
+ * @data:  data address
+ * @len: number of shorts to read
+ */
+void __raw_readsw(const void __iomem *addr, void *data, int len)
+{
+	const volatile short int *src = (short int *) addr;
+	short int *dst = (short int *) data;
+
+	if ((u32)data & 0x1)
+		panic("unaligned pointer to readsw");
+
+	while (len-- > 0)
+		*dst++ = *src;
+
+}
+
+/*
+ * __raw_writesw - read words a short at a time
+ * @addr:  source address
+ * @data:  data address
+ * @len: number of shorts to read
+ */
+void __raw_writesw(void __iomem *addr, const void *data, int len)
+{
+	const short int *src = (short int *)data;
+	volatile short int *dst = (short int *)addr;
+
+	if ((u32)data & 0x1)
+		panic("unaligned pointer to writesw");
+
+	while (len-- > 0)
+		*dst = *src++;
+
+
+}
+
+/*  Pretty sure len is pre-adjusted for the length of the access already */
+void __raw_readsl(const void __iomem *addr, void *data, int len)
+{
+	const volatile long *src = (long *) addr;
+	long *dst = (long *) data;
+
+	if ((u32)data & 0x3)
+		panic("unaligned pointer to readsl");
+
+	while (len-- > 0)
+		*dst++ = *src;
+
+
+}
+
+void __raw_writesl(void __iomem *addr, const void *data, int len)
+{
+	const long *src = (long *)data;
+	volatile long *dst = (long *)addr;
+
+	if ((u32)data & 0x3)
+		panic("unaligned pointer to writesl");
+
+	while (len-- > 0)
+		*dst = *src++;
+
+
+}

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

