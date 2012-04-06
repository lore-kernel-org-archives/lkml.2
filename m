Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2D2TAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 15:00:24 -0400
Received: from [12.216.194.151] ([12.216.194.151]:53761 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2D2S7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 14:59:07 -0400
Message-ID: <201204291859.q3TIx67B007271@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 6 Apr 2012 13:52:07 -0400
Subject: [PATCH v2 2/6] arch/tile: support MMIO-based readb/writeb etc.
To: Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com> <201204101042.39877.arnd@arndb.de> <4F8763E1.1020605@tilera.com> <201204131034.03544.arnd@arndb.de> <4F9C6A0A.5090109@tilera.com> <201204291856.q3TIusXq007168@farm-0027.internal.tilera.com>
In-Reply-To: <201204291856.q3TIusXq007168@farm-0027.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MMIO read/write on tilegx to support GXIO IORPC access.
Similar to the asm-generic version, but we include memory fences on
the writes to be conservative.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/io.h |  144 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 116 insertions(+), 28 deletions(-)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index d2152de..2a9b293 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -62,6 +62,92 @@ extern void iounmap(volatile void __iomem *addr);
 #define mm_ptov(addr)		((void *)phys_to_virt(addr))
 #define mm_vtop(addr)		((unsigned long)virt_to_phys(addr))
 
+#if CHIP_HAS_MMIO()
+
+/*
+ * We use inline assembly to guarantee that the compiler does not
+ * split an access into multiple byte-sized accesses as it might
+ * sometimes do if a register data structure is marked "packed".
+ * Obviously on tile we can't tolerate such an access being
+ * actually unaligned, but we want to avoid the case where the
+ * compiler conservatively would generate multiple accesses even
+ * for an aligned read or write.
+ */
+
+static inline u8 __raw_readb(const volatile void __iomem *addr)
+{
+	return *(const volatile u8 __force *)addr;
+}
+
+static inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	u16 ret;
+	asm volatile("ld2u %0, %1" : "=r" (ret) : "r" (addr));
+	barrier();
+	return le16_to_cpu(ret);
+}
+
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	u32 ret;
+	/* Sign-extend to conform to u32 ABI sign-extension convention. */
+	asm volatile("ld4s %0, %1" : "=r" (ret) : "r" (addr));
+	barrier();
+	return le32_to_cpu(ret);
+}
+
+static inline u64 __raw_readq(const volatile void __iomem *addr)
+{
+	u64 ret;
+	asm volatile("ld %0, %1" : "=r" (ret) : "r" (addr));
+	barrier();
+	return le64_to_cpu(ret);
+}
+
+static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
+{
+	*(volatile u8 __force *)addr = val;
+}
+
+static inline void __raw_writew(u16 val, volatile void __iomem *addr)
+{
+	asm volatile("st2 %0, %1" :: "r" (addr), "r" (cpu_to_le16(val)));
+}
+
+static inline void __raw_writel(u32 val, volatile void __iomem *addr)
+{
+	asm volatile("st4 %0, %1" :: "r" (addr), "r" (cpu_to_le32(val)));
+}
+
+static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
+{
+	asm volatile("st %0, %1" :: "r" (addr), "r" (cpu_to_le64(val)));
+}
+
+/*
+ * The on-chip I/O hardware on tilegx is configured with VA=PA for the
+ * kernel's PA range.  The low-level APIs and field names use "va" and
+ * "void *" nomenclature, to be consistent with the general notion
+ * that the addresses in question are virtualizable, but in the kernel
+ * context we are actually manipulating PA values.  (In other contexts,
+ * e.g. access from user space, we do in fact use real virtual addresses
+ * in the va fields.)  To allow readers of the code to understand what's
+ * happening, we direct their attention to this comment by using the
+ * following two functions that just duplicate __va() and __pa().
+ */
+typedef unsigned long tile_io_addr_t;
+static inline tile_io_addr_t va_to_tile_io_addr(void *va)
+{
+	BUILD_BUG_ON(sizeof(phys_addr_t) != sizeof(tile_io_addr_t));
+	return __pa(va);
+}
+static inline void *tile_io_addr_to_va(tile_io_addr_t tile_io_addr)
+{
+	return __va(tile_io_addr);
+}
+
+#else /* CHIP_HAS_MMIO() */
+
 #ifdef CONFIG_PCI
 
 extern u8 _tile_readb(unsigned long addr);
@@ -73,10 +159,19 @@ extern void _tile_writew(u16 val, unsigned long addr);
 extern void _tile_writel(u32 val, unsigned long addr);
 extern void _tile_writeq(u64 val, unsigned long addr);
 
-#else
+#define __raw_readb(addr) _tile_readb((unsigned long)addr)
+#define __raw_readw(addr) _tile_readw((unsigned long)addr)
+#define __raw_readl(addr) _tile_readl((unsigned long)addr)
+#define __raw_readq(addr) _tile_readq((unsigned long)addr)
+#define __raw_writeb(val, addr) _tile_writeb(val, (unsigned long)addr)
+#define __raw_writew(val, addr) _tile_writew(val, (unsigned long)addr)
+#define __raw_writel(val, addr) _tile_writel(val, (unsigned long)addr)
+#define __raw_writeq(val, addr) _tile_writeq(val, (unsigned long)addr)
+
+#else /* CONFIG_PCI */
 
 /*
- * The Tile architecture does not support IOMEM unless PCI is enabled.
+ * The tilepro architecture does not support IOMEM unless PCI is enabled.
  * Unfortunately we can't yet simply not declare these methods,
  * since some generic code that compiles into the kernel, but
  * we never run, uses them unconditionally.
@@ -88,65 +183,58 @@ static inline int iomem_panic(void)
 	return 0;
 }
 
-static inline u8 _tile_readb(unsigned long addr)
+static inline u8 readb(unsigned long addr)
 {
 	return iomem_panic();
 }
 
-static inline u16 _tile_readw(unsigned long addr)
+static inline u16 _readw(unsigned long addr)
 {
 	return iomem_panic();
 }
 
-static inline u32 _tile_readl(unsigned long addr)
+static inline u32 readl(unsigned long addr)
 {
 	return iomem_panic();
 }
 
-static inline u64 _tile_readq(unsigned long addr)
+static inline u64 readq(unsigned long addr)
 {
 	return iomem_panic();
 }
 
-static inline void _tile_writeb(u8  val, unsigned long addr)
+static inline void writeb(u8  val, unsigned long addr)
 {
 	iomem_panic();
 }
 
-static inline void _tile_writew(u16 val, unsigned long addr)
+static inline void writew(u16 val, unsigned long addr)
 {
 	iomem_panic();
 }
 
-static inline void _tile_writel(u32 val, unsigned long addr)
+static inline void writel(u32 val, unsigned long addr)
 {
 	iomem_panic();
 }
 
-static inline void _tile_writeq(u64 val, unsigned long addr)
+static inline void writeq(u64 val, unsigned long addr)
 {
 	iomem_panic();
 }
 
-#endif
+#endif /* CONFIG_PCI */
+
+#endif /* CHIP_HAS_MMIO() */
 
-#define readb(addr) _tile_readb((unsigned long)addr)
-#define readw(addr) _tile_readw((unsigned long)addr)
-#define readl(addr) _tile_readl((unsigned long)addr)
-#define readq(addr) _tile_readq((unsigned long)addr)
-#define writeb(val, addr) _tile_writeb(val, (unsigned long)addr)
-#define writew(val, addr) _tile_writew(val, (unsigned long)addr)
-#define writel(val, addr) _tile_writel(val, (unsigned long)addr)
-#define writeq(val, addr) _tile_writeq(val, (unsigned long)addr)
-
-#define __raw_readb readb
-#define __raw_readw readw
-#define __raw_readl readl
-#define __raw_readq readq
-#define __raw_writeb writeb
-#define __raw_writew writew
-#define __raw_writel writel
-#define __raw_writeq writeq
+#define readb __raw_readb
+#define readw __raw_readw
+#define readl __raw_readl
+#define readq __raw_readq
+#define writeb __raw_writeb
+#define writew __raw_writew
+#define writel __raw_writel
+#define writeq __raw_writeq
 
 #define readb_relaxed readb
 #define readw_relaxed readw
-- 
1.6.5.2

