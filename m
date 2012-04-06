Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab2DFVDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:03:24 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:53688 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab2DFVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:02:03 -0400
Message-Id: <201204062101.q36L1tuT011403@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 6 Apr 2012 13:52:07 -0400
Subject: [PATCH 3/6] arch/tile: support MMIO-based readb/writeb etc.
To: linux-kernel@vger.kernel.org
In-Reply-To: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
X-OriginalArrivalTime: 06 Apr 2012 21:01:56.0073 (UTC) FILETIME=[7FEF5D90:01CD1438]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MMIO read/write on tilegx to support GXIO IORPC access.
Similar to the asm-generic version, but we include memory fences on
the writes to be conservative.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/io.h |  110 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 82 insertions(+), 28 deletions(-)

diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index d2152de..d923841 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -62,6 +62,58 @@ extern void iounmap(volatile void __iomem *addr);
 #define mm_ptov(addr)		((void *)phys_to_virt(addr))
 #define mm_vtop(addr)		((unsigned long)virt_to_phys(addr))
 
+#if CHIP_HAS_MMIO()
+
+static inline u8 __raw_readb(const volatile void __iomem *addr)
+{
+	return *(const volatile u8 __force *)addr;
+}
+
+static inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	return le16_to_cpu(*(const volatile u16 __force *)addr);
+}
+
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	return le32_to_cpu(*(const volatile u32 __force *)addr);
+}
+
+static inline u64 __raw_readq(const volatile void __iomem *addr)
+{
+	return le64_to_cpu(*(const volatile u64 __force *)addr);
+}
+
+static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
+{
+	__insn_mf();
+	*(volatile u8 __force *)addr = val;
+	__insn_mf();
+}
+
+static inline void __raw_writew(u16 val, volatile void __iomem *addr)
+{
+	__insn_mf();
+	*(volatile u16 __force *)addr = cpu_to_le16(val);
+	__insn_mf();
+}
+
+static inline void __raw_writel(u32 val, volatile void __iomem *addr)
+{
+	__insn_mf();
+	*(volatile u32 __force *)addr = cpu_to_le32(val);
+	__insn_mf();
+}
+
+static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
+{
+	__insn_mf();
+	*(volatile u64 __force *)addr = cpu_to_le64(val);
+	__insn_mf();
+}
+
+#else /* CHIP_HAS_MMIO() */
+
 #ifdef CONFIG_PCI
 
 extern u8 _tile_readb(unsigned long addr);
@@ -73,10 +125,19 @@ extern void _tile_writew(u16 val, unsigned long addr);
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
@@ -88,65 +149,58 @@ static inline int iomem_panic(void)
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

