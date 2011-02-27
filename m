Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1B0QCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:02:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:58608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1B0QCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:02:25 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 17/17] unicore32: replace unicore32-specific iomap functions with generic lib implementation
Date: Sun, 27 Feb 2011 15:59:45 +0000
Message-Id: <80a44ac4ac769b464094511bb66732d0d1e7d6d9.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

1. define and enable CONFIG_GENERIC_IOMAP
2. define unicore32-specific PCI_IOBASE for asm-generic/io.h
3. define HAVE_ARCH_PIO_SIZE and unicore32-specific PIO_* macros
4. remove all unicore32-specific iomap functions

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig          |    3 ++
 arch/unicore32/include/asm/io.h |    9 ++++--
 arch/unicore32/mm/Makefile      |    2 +-
 arch/unicore32/mm/iomap.c       |   56 ---------------------------------------
 4 files changed, 10 insertions(+), 60 deletions(-)
 delete mode 100644 arch/unicore32/mm/iomap.c

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 7f65018..4a36db4 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -30,6 +30,9 @@ config GENERIC_CLOCKEVENTS
 config GENERIC_CSUM
 	def_bool y
 
+config GENERIC_IOMAP
+	def_bool y
+
 config NO_IOPORT
 	bool
 
diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index d73457c..2483fcb 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -18,6 +18,7 @@
 #include <asm/memory.h>
 #include <asm/system.h>
 
+#define PCI_IOBASE	io_p2v(PKUNITY_PCILIO_BASE)
 #include <asm-generic/io.h>
 
 /*
@@ -38,9 +39,6 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
 #define ioremap_cached(cookie, size)	__uc32_ioremap_cached(cookie, size)
 #define iounmap(cookie)			__uc32_iounmap(cookie)
 
-extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
-extern void ioport_unmap(void __iomem *addr);
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
@@ -48,5 +46,10 @@ extern void ioport_unmap(void __iomem *addr);
 #undef xlate_dev_mem_ptr
 #define xlate_dev_mem_ptr(p)	__va(p)
 
+#define HAVE_ARCH_PIO_SIZE
+#define PIO_OFFSET		(unsigned int)(PCI_IOBASE)
+#define PIO_MASK		(unsigned int)(IO_SPACE_LIMIT)
+#define PIO_RESERVED		(PIO_OFFSET + PIO_MASK + 1)
+
 #endif	/* __KERNEL__ */
 #endif	/* __UNICORE_IO_H__ */
diff --git a/arch/unicore32/mm/Makefile b/arch/unicore32/mm/Makefile
index f3ff410..46c1666 100644
--- a/arch/unicore32/mm/Makefile
+++ b/arch/unicore32/mm/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-y				:= extable.o fault.o init.o pgd.o mmu.o
-obj-y				+= iomap.o flush.o ioremap.o
+obj-y				+= flush.o ioremap.o
 
 obj-$(CONFIG_SWIOTLB)		+= dma-swiotlb.o
 
diff --git a/arch/unicore32/mm/iomap.c b/arch/unicore32/mm/iomap.c
deleted file mode 100644
index a7e1a3d..0000000
--- a/arch/unicore32/mm/iomap.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * linux/arch/unicore32/mm/iomap.c
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Map IO port and PCI memory spaces so that {read,write}[bwl] can
- * be used to access this memory.
- */
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/ioport.h>
-#include <linux/io.h>
-
-#ifdef __io
-void __iomem *ioport_map(unsigned long port, unsigned int nr)
-{
-	/* we map PC lagcy 64K IO port to PCI IO space 0x80030000 */
-	return (void __iomem *) (unsigned long)
-			io_p2v((port & 0xffff) + PKUNITY_PCILIO_BASE);
-}
-EXPORT_SYMBOL(ioport_map);
-
-void ioport_unmap(void __iomem *addr)
-{
-}
-EXPORT_SYMBOL(ioport_unmap);
-#endif
-
-#ifdef CONFIG_PCI
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len   = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len || !start)
-		return NULL;
-	if (maxlen && len > maxlen)
-		len = maxlen;
-	if (flags & IORESOURCE_IO)
-		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
-			return ioremap(start, len);
-		return ioremap_nocache(start, len);
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(pci_iomap);
-#endif
-- 
1.7.4.1

