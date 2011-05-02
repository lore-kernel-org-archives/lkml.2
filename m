Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab1EBXJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:41 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab1EBXJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:34 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsRm8030358@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 16:06:42 -0400
Subject: [PATCH] arch/tile: various header improvements for building drivers
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:27.0174 (UTC) FILETIME=[E374A060:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds a number of missing headers in asm (fb.h, parport.h,
serial.h, and vga.h) using the minimal generic versions.

It also adds a number of missing interfaces that showed up as build
failures when trying to build various drivers not normally included in the
"tile" distribution: ioremap_wc(), memset_io(), io{read,write}{16,32}be(),
virt_to_bus(), bus_to_virt(), irq_canonicalize(), __pte(), __pgd(),
and __pmd().  I also added a cast in virt_to_page() since not all callers
pass a pointer.

I fixed <asm/stat.h> to properly include a __KERNEL__ guard for the
__ARCH_WANT_STAT64 symbol, and <asm/swab.h> to use __builtin_bswap32()
even for our 64-bit architecture, since the same code is produced.

I added an export for get_cycles(), since it's used in some modules.

And I made <arch/spr_def.h> properly include the __KERNEL__ guard,
even though it's not yet exported, since it likely will be soon.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/spr_def.h |   13 ++++++++++-
 arch/tile/include/asm/fb.h       |    1 +
 arch/tile/include/asm/io.h       |   18 +++++++++++++++++
 arch/tile/include/asm/irq.h      |    2 +
 arch/tile/include/asm/page.h     |    8 ++++++-
 arch/tile/include/asm/parport.h  |    1 +
 arch/tile/include/asm/serial.h   |    1 +
 arch/tile/include/asm/stat.h     |    2 +-
 arch/tile/include/asm/swab.h     |    6 -----
 arch/tile/include/asm/vga.h      |   39 ++++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/time.c          |    2 +
 11 files changed, 83 insertions(+), 10 deletions(-)
 create mode 100644 arch/tile/include/asm/fb.h
 create mode 100644 arch/tile/include/asm/parport.h
 create mode 100644 arch/tile/include/asm/serial.h
 create mode 100644 arch/tile/include/asm/vga.h

diff --git a/arch/tile/include/arch/spr_def.h b/arch/tile/include/arch/spr_def.h
index 442fcba..f548efe 100644
--- a/arch/tile/include/arch/spr_def.h
+++ b/arch/tile/include/arch/spr_def.h
@@ -12,6 +12,15 @@
  *   more details.
  */
 
+/* Include the proper base SPR definition file. */
+#ifdef __tilegx__
+#include <arch/spr_def_64.h>
+#else
+#include <arch/spr_def_32.h>
+#endif
+
+#ifdef __KERNEL__
+
 /*
  * In addition to including the proper base SPR definition file, depending
  * on machine architecture, this file defines several macros which allow
@@ -29,7 +38,6 @@
 #define _concat4(a, b, c, d)  __concat4(a, b, c, d)
 
 #ifdef __tilegx__
-#include <arch/spr_def_64.h>
 
 /* TILE-Gx dependent, protection-level dependent SPRs. */
 
@@ -65,7 +73,6 @@
 	_concat4(INT_SINGLE_STEP_, CONFIG_KERNEL_PL,,)
 
 #else
-#include <arch/spr_def_32.h>
 
 /* TILEPro dependent, protection-level dependent SPRs. */
 
@@ -102,3 +109,5 @@
 	_concat4(SPR_INTCTRL_, CONFIG_KERNEL_PL, _STATUS,)
 #define INT_INTCTRL_K \
 	_concat4(INT_INTCTRL_, CONFIG_KERNEL_PL,,)
+
+#endif /* __KERNEL__ */
diff --git a/arch/tile/include/asm/fb.h b/arch/tile/include/asm/fb.h
new file mode 100644
index 0000000..3a4988e
--- /dev/null
+++ b/arch/tile/include/asm/fb.h
@@ -0,0 +1 @@
+#include <asm-generic/fb.h>
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index d3cbb9b..c9ea165 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -52,6 +52,7 @@ extern void iounmap(volatile void __iomem *addr);
 #endif
 
 #define ioremap_nocache(physaddr, size)		ioremap(physaddr, size)
+#define ioremap_wc(physaddr, size)		ioremap(physaddr, size)
 #define ioremap_writethrough(physaddr, size)	ioremap(physaddr, size)
 #define ioremap_fullcache(physaddr, size)	ioremap(physaddr, size)
 
@@ -161,6 +162,15 @@ static inline void _tile_writeq(u64 val, unsigned long addr)
 #define iowrite32 writel
 #define iowrite64 writeq
 
+static inline void memset_io(void *dst, int val, size_t len)
+{
+	int x;
+	BUG_ON((unsigned long)dst & 0x3);
+	val = (val & 0xff) * 0x01010101;
+	for (x = 0; x < len; x += 4)
+		writel(val, dst + x);
+}
+
 static inline void memcpy_fromio(void *dst, const volatile void __iomem *src,
 				 size_t len)
 {
@@ -269,6 +279,11 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 	ioport_panic();
 }
 
+#define ioread16be(addr)	be16_to_cpu(ioread16(addr))
+#define ioread32be(addr)	be32_to_cpu(ioread32(addr))
+#define iowrite16be(v, addr)	iowrite16(be16_to_cpu(v), (addr))
+#define iowrite32be(v, addr)	iowrite32(be32_to_cpu(v), (addr))
+
 #define ioread8_rep(p, dst, count) \
 	insb((unsigned long) (p), (dst), (count))
 #define ioread16_rep(p, dst, count) \
@@ -283,4 +298,7 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 #define iowrite32_rep(p, src, count) \
 	outsl((unsigned long) (p), (src), (count))
 
+#define virt_to_bus     virt_to_phys
+#define bus_to_virt     phys_to_virt
+
 #endif /* _ASM_TILE_IO_H */
diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
index 572fd3e..94e9a51 100644
--- a/arch/tile/include/asm/irq.h
+++ b/arch/tile/include/asm/irq.h
@@ -23,6 +23,8 @@
 /* IRQ numbers used for linux IPIs. */
 #define IRQ_RESCHEDULE 1
 
+#define irq_canonicalize(irq)   (irq)
+
 void ack_bad_irq(unsigned int irq);
 
 /*
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index 3eb5352..7105629 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -91,6 +91,10 @@ typedef struct page *pgtable_t;
 /* Must be a macro since it is used to create constants. */
 #define __pgprot(val) hv_pte(val)
 
+/* Rarely-used initializers, typically with a "zero" value. */
+#define __pte(x) hv_pte(x)
+#define __pgd(x) hv_pte(x)
+
 static inline u64 pgprot_val(pgprot_t pgprot)
 {
 	return hv_pte_val(pgprot);
@@ -110,6 +114,8 @@ static inline u64 pgd_val(pgd_t pgd)
 
 typedef HV_PTE pmd_t;
 
+#define __pmd(x) hv_pte(x)
+
 static inline u64 pmd_val(pmd_t pmd)
 {
 	return hv_pte_val(pmd);
@@ -318,7 +324,7 @@ static inline int pfn_valid(unsigned long pfn)
 
 /* Provide as macros since these require some other headers included. */
 #define page_to_pa(page) ((phys_addr_t)(page_to_pfn(page)) << PAGE_SHIFT)
-#define virt_to_page(kaddr) pfn_to_page(kaddr_to_pfn(kaddr))
+#define virt_to_page(kaddr) pfn_to_page(kaddr_to_pfn((void *)(kaddr)))
 #define page_to_virt(page) pfn_to_kaddr(page_to_pfn(page))
 
 struct mm_struct;
diff --git a/arch/tile/include/asm/parport.h b/arch/tile/include/asm/parport.h
new file mode 100644
index 0000000..cf252af
--- /dev/null
+++ b/arch/tile/include/asm/parport.h
@@ -0,0 +1 @@
+#include <asm-generic/parport.h>
diff --git a/arch/tile/include/asm/serial.h b/arch/tile/include/asm/serial.h
new file mode 100644
index 0000000..a0cb0ca
--- /dev/null
+++ b/arch/tile/include/asm/serial.h
@@ -0,0 +1 @@
+#include <asm-generic/serial.h>
diff --git a/arch/tile/include/asm/stat.h b/arch/tile/include/asm/stat.h
index b16e5db..c0db34d 100644
--- a/arch/tile/include/asm/stat.h
+++ b/arch/tile/include/asm/stat.h
@@ -1,4 +1,4 @@
-#ifdef CONFIG_COMPAT
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 #define __ARCH_WANT_STAT64	/* Used for compat_sys_stat64() etc. */
 #endif
 #include <asm-generic/stat.h>
diff --git a/arch/tile/include/asm/swab.h b/arch/tile/include/asm/swab.h
index 25c686a..7c37b38 100644
--- a/arch/tile/include/asm/swab.h
+++ b/arch/tile/include/asm/swab.h
@@ -18,12 +18,6 @@
 /* Tile gcc is always >= 4.3.0, so we use __builtin_bswap. */
 #define __arch_swab32(x) __builtin_bswap32(x)
 #define __arch_swab64(x) __builtin_bswap64(x)
-
-/* Use the variant that is natural for the wordsize. */
-#ifdef CONFIG_64BIT
-#define __arch_swab16(x) (__builtin_bswap64(x) >> 48)
-#else
 #define __arch_swab16(x) (__builtin_bswap32(x) >> 16)
-#endif
 
 #endif /* _ASM_TILE_SWAB_H */
diff --git a/arch/tile/include/asm/vga.h b/arch/tile/include/asm/vga.h
new file mode 100644
index 0000000..7b46e75
--- /dev/null
+++ b/arch/tile/include/asm/vga.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Access to VGA videoram.
+ */
+
+#ifndef _ASM_TILE_VGA_H
+#define _ASM_TILE_VGA_H
+
+#include <asm/io.h>
+
+#define VT_BUF_HAVE_RW
+
+static inline void scr_writew(u16 val, volatile u16 *addr)
+{
+	__raw_writew(val, (volatile u16 __iomem *) addr);
+}
+
+static inline u16 scr_readw(volatile const u16 *addr)
+{
+	return __raw_readw((volatile const u16 __iomem *) addr);
+}
+
+#define vga_readb(a)	readb((u8 __iomem *)(a))
+#define vga_writeb(v,a)	writeb(v, (u8 __iomem *)(a))
+
+#define VGA_MAP_MEM(x,s)	((unsigned long) ioremap(x, s))
+
+#endif
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 49a605b..c4be58c 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -22,6 +22,7 @@
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include <asm/irq_regs.h>
 #include <asm/traps.h>
 #include <hv/hypervisor.h>
@@ -56,6 +57,7 @@ cycles_t get_cycles(void)
 
 	return (((cycles_t)high) << 32) | low;
 }
+EXPORT_SYMBOL(get_cycles);
 #endif
 
 /*
-- 
1.6.5.2

