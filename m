Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1K2T2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:28:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab1K2T2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:28:08 -0500
Date: Tue, 29 Nov 2011 21:29:45 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH-RFC] frv: switch to GENERIC_PCI_IOMAP
Message-ID: <20111129192945.GA2870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

frv uses a version of pci_iomap that simply
casts and returns back the start address.
Looking closely, both ioremap and ioport_map seem to
do this on this platform, so the generic pci_iomap
will DTRT automatically.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is a completely untested patch to switch frv
over to the new pci_iomap (in -mm).

This is on top of pci: use generic pci_iomap in most architectures,
and converts just the frvc architecture.

 arch/frv/Kconfig                  |    1 +
 arch/frv/include/asm/io.h         |    1 -
 arch/frv/mb93090-mb00/Makefile    |    2 +-
 arch/frv/mb93090-mb00/pci-iomap.c |   29 -----------------------------
 4 files changed, 2 insertions(+), 31 deletions(-)
 delete mode 100644 arch/frv/mb93090-mb00/pci-iomap.c

diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index bad27a6..dfde78b 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -317,6 +317,7 @@ config PCI
 	bool "Use PCI"
 	depends on MB93090_MB00
 	default y
+	select GENERIC_PCI_IOMAP
 	help
 	  Some FR-V systems (such as the MB93090-MB00 VDK) have PCI
 	  onboard. If you have one of these boards and you wish to use the PCI
diff --git a/arch/frv/include/asm/io.h b/arch/frv/include/asm/io.h
index ca7475e..0cb64db 100644
--- a/arch/frv/include/asm/io.h
+++ b/arch/frv/include/asm/io.h
@@ -370,7 +370,6 @@ static inline void iowrite32_rep(void __iomem *p, const void *src, unsigned long
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
diff --git a/arch/frv/mb93090-mb00/Makefile b/arch/frv/mb93090-mb00/Makefile
index b73b542..21f1df1 100644
--- a/arch/frv/mb93090-mb00/Makefile
+++ b/arch/frv/mb93090-mb00/Makefile
@@ -3,7 +3,7 @@
 #
 
 ifeq "$(CONFIG_PCI)" "y"
-obj-y := pci-frv.o pci-irq.o pci-vdk.o pci-iomap.o
+obj-y := pci-frv.o pci-irq.o pci-vdk.o
 
 ifeq "$(CONFIG_MMU)" "y"
 obj-y += pci-dma.o
diff --git a/arch/frv/mb93090-mb00/pci-iomap.c b/arch/frv/mb93090-mb00/pci-iomap.c
deleted file mode 100644
index 35f6df2..0000000
--- a/arch/frv/mb93090-mb00/pci-iomap.c
+++ /dev/null
@@ -1,29 +0,0 @@
-/* pci-iomap.c: description
- *
- * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#include <linux/pci.h>
-#include <linux/module.h>
-
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len || !start)
-		return NULL;
-
-	if ((flags & IORESOURCE_IO) || (flags & IORESOURCE_MEM))
-		return (void __iomem *) start;
-
-	return NULL;
-}
-
-EXPORT_SYMBOL(pci_iomap);
-- 
1.7.5.53.gc233e
