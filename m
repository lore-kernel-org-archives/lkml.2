Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861Ab0J0CDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 22:03:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35645 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab0J0CDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 22:03:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2] Blackfin: switch to asm-generic/io.h
Date: Tue, 26 Oct 2010 22:03:25 -0400
Message-Id: <1288145006-31108-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/io.h |  238 ++++++---------------------------------
 1 files changed, 37 insertions(+), 201 deletions(-)

diff --git a/arch/blackfin/include/asm/io.h b/arch/blackfin/include/asm/io.h
index 234fbac..a1e1fc7 100644
--- a/arch/blackfin/include/asm/io.h
+++ b/arch/blackfin/include/asm/io.h
@@ -1,5 +1,5 @@
 /*
- * Copyright 2004-2009 Analog Devices Inc.
+ * Copyright 2004-2010 Analog Devices Inc.
  *
  * Licensed under the GPL-2 or later.
  */
@@ -7,148 +7,48 @@
 #ifndef _BFIN_IO_H
 #define _BFIN_IO_H
 
-#ifdef __KERNEL__
-
-#ifndef __ASSEMBLY__
-#include <linux/types.h>
-#endif
 #include <linux/compiler.h>
-
-/*
- * These are for ISA/PCI shared memory _only_ and should never be used
- * on any other type of memory, including Zorro memory. They are meant to
- * access the bus in the bus byte order which is little-endian!.
- *
- * readX/writeX() are used to access memory mapped devices. On some
- * architectures the memory mapped IO stuff needs to be accessed
- * differently. On the bfin architecture, we just read/write the
- * memory location directly.
- */
-#ifndef __ASSEMBLY__
-
-static inline unsigned char readb(const volatile void __iomem *addr)
-{
-	unsigned int val;
-	int tmp;
-
-	__asm__ __volatile__ (
-		"cli %1;"
-		"NOP; NOP; SSYNC;"
-		"%0 = b [%2] (z);"
-		"sti %1;"
-		: "=d"(val), "=d"(tmp)
-		: "a"(addr)
-	);
-
-	return (unsigned char) val;
-}
-
-static inline unsigned short readw(const volatile void __iomem *addr)
-{
-	unsigned int val;
-	int tmp;
-
-	__asm__ __volatile__ (
-		"cli %1;"
-		"NOP; NOP; SSYNC;"
-		"%0 = w [%2] (z);"
-		"sti %1;"
-		: "=d"(val), "=d"(tmp)
-		: "a"(addr)
-	);
-
-	return (unsigned short) val;
-}
-
-static inline unsigned int readl(const volatile void __iomem *addr)
-{
-	unsigned int val;
-	int tmp;
-
-	__asm__ __volatile__ (
-		"cli %1;"
-		"NOP; NOP; SSYNC;"
-		"%0 = [%2];"
-		"sti %1;"
-		: "=d"(val), "=d"(tmp)
-		: "a"(addr)
-	);
-
-	return val;
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#define DECLARE_BFIN_RAW_READX(size, type, asm, asm_sign) \
+static inline type __raw_read##size(const volatile void __iomem *addr) \
+{ \
+	unsigned int val; \
+	int tmp; \
+	__asm__ __volatile__ ( \
+		"cli %1;" \
+		"NOP; NOP; SSYNC;" \
+		"%0 = "#asm" [%2] "#asm_sign";" \
+		"sti %1;" \
+		: "=d"(val), "=d"(tmp) \
+		: "a"(addr) \
+	); \
+	return (type) val; \
 }
-
-#endif /*  __ASSEMBLY__ */
-
-#define writeb(b, addr) (void)((*(volatile unsigned char *) (addr)) = (b))
-#define writew(b, addr) (void)((*(volatile unsigned short *) (addr)) = (b))
-#define writel(b, addr) (void)((*(volatile unsigned int *) (addr)) = (b))
-
-#define __raw_readb readb
-#define __raw_readw readw
-#define __raw_readl readl
-#define __raw_writeb writeb
-#define __raw_writew writew
-#define __raw_writel writel
-#define memset_io(a, b, c)	memset((void *)(a), (b), (c))
-#define memcpy_fromio(a, b, c)	memcpy((a), (void *)(b), (c))
-#define memcpy_toio(a, b, c)	memcpy((void *)(a), (b), (c))
-
-/* Convert "I/O port addresses" to actual addresses.  i.e. ugly casts. */
-#define __io(port) ((void *)(unsigned long)(port))
-
-#define inb(port)    readb(__io(port))
-#define inw(port)    readw(__io(port))
-#define inl(port)    readl(__io(port))
-#define outb(x, port) writeb(x, __io(port))
-#define outw(x, port) writew(x, __io(port))
-#define outl(x, port) writel(x, __io(port))
-
-#define inb_p(port)    inb(__io(port))
-#define inw_p(port)    inw(__io(port))
-#define inl_p(port)    inl(__io(port))
-#define outb_p(x, port) outb(x, __io(port))
-#define outw_p(x, port) outw(x, __io(port))
-#define outl_p(x, port) outl(x, __io(port))
-
-#define ioread8_rep(a, d, c)	readsb(a, d, c)
-#define ioread16_rep(a, d, c)	readsw(a, d, c)
-#define ioread32_rep(a, d, c)	readsl(a, d, c)
-#define iowrite8_rep(a, s, c)	writesb(a, s, c)
-#define iowrite16_rep(a, s, c)	writesw(a, s, c)
-#define iowrite32_rep(a, s, c)	writesl(a, s, c)
-
-#define ioread8(x)			readb(x)
-#define ioread16(x)			readw(x)
-#define ioread32(x)			readl(x)
-#define iowrite8(val, x)		writeb(val, x)
-#define iowrite16(val, x)		writew(val, x)
-#define iowrite32(val, x)		writel(val, x)
-
-/**
- * I/O write barrier
- *
- * Ensure ordering of I/O space writes. This will make sure that writes
- * following the barrier will arrive after all previous writes.
- */
-#define mmiowb() do { SSYNC(); wmb(); } while (0)
-
-#define IO_SPACE_LIMIT 0xffffffff
-
-/* Values for nocacheflag and cmode */
-#define IOMAP_NOCACHE_SER		1
-
-#ifndef __ASSEMBLY__
+DECLARE_BFIN_RAW_READX(b, u8, b, (z))
+#define __raw_readb __raw_readb
+DECLARE_BFIN_RAW_READX(w, u16, w, (z))
+#define __raw_readw __raw_readw
+DECLARE_BFIN_RAW_READX(l, u32, , )
+#define __raw_readl __raw_readl
 
 extern void outsb(unsigned long port, const void *addr, unsigned long count);
 extern void outsw(unsigned long port, const void *addr, unsigned long count);
 extern void outsw_8(unsigned long port, const void *addr, unsigned long count);
 extern void outsl(unsigned long port, const void *addr, unsigned long count);
+#define outsb outsb
+#define outsw outsw
+#define outsl outsl
 
 extern void insb(unsigned long port, void *addr, unsigned long count);
 extern void insw(unsigned long port, void *addr, unsigned long count);
 extern void insw_8(unsigned long port, void *addr, unsigned long count);
 extern void insl(unsigned long port, void *addr, unsigned long count);
 extern void insl_16(unsigned long port, void *addr, unsigned long count);
+#define insb insb
+#define insw insw
+#define insl insl
 
 extern void dma_outsb(unsigned long port, const void *addr, unsigned short count);
 extern void dma_outsw(unsigned long port, const void *addr, unsigned short count);
@@ -188,78 +88,14 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 	outsb((unsigned long)addr, buf, len);
 }
 
-/*
- * Map some physical address range into the kernel address space.
- */
-static inline void __iomem *__ioremap(unsigned long physaddr, unsigned long size,
-				int cacheflag)
-{
-	return (void __iomem *)physaddr;
-}
-
-/*
- * Unmap a ioremap()ed region again
- */
-static inline void iounmap(void *addr)
-{
-}
-
-/*
- * __iounmap unmaps nearly everything, so be careful
- * it doesn't free currently pointer/page tables anymore but it
- * wans't used anyway and might be added later.
- */
-static inline void __iounmap(void *addr, unsigned long size)
-{
-}
-
-/*
- * Set new cache mode for some kernel address space.
- * The caller must push data for that range itself, if such data may already
- * be in the cache.
+/**
+ * I/O write barrier
+ *
+ * Ensure ordering of I/O space writes. This will make sure that writes
+ * following the barrier will arrive after all previous writes.
  */
-static inline void kernel_set_cachemode(void *addr, unsigned long size,
-					int cmode)
-{
-}
-
-static inline void __iomem *ioremap(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
-}
-static inline void __iomem *ioremap_nocache(unsigned long physaddr,
-					    unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
-}
+#define mmiowb() do { SSYNC(); wmb(); } while (0)
 
-extern void blkfin_inv_cache_all(void);
+#include <asm-generic/io.h>
 
 #endif
-
-#define	ioport_map(port, nr)		((void __iomem*)(port))
-#define	ioport_unmap(addr)
-
-/* Pages to physical address... */
-#define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
-
-#define phys_to_virt(vaddr)	((void *) (vaddr))
-#define virt_to_phys(vaddr)	((unsigned long) (vaddr))
-
-#define virt_to_bus virt_to_phys
-#define bus_to_virt phys_to_virt
-
-/*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-#endif				/* __KERNEL__ */
-
-#endif				/* _BFIN_IO_H */
-- 
1.7.3.2

