Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1LUQ2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:28:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab1LUQ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:28:19 -0500
Date: Wed, 21 Dec 2011 18:30:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 15/16] mn10300: switch to GENERIC_PCI_IOMAP
Message-ID: <9184442ba70c5cf145010c219f8a011c1d64f226.1324484752.git.mst@redhat.com>
References: <cover.1324484752.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1324484752.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci_iomap variant that arch/mn10300/unit-asb2305/pci-iomap.c
uses differs from the generic one in that it does
not use ioremap_nocache for PCI addresses.
However, it turns out that PCI addresses are
automatically noncached, so switching to ioremap_nocache
and to the generic implementation is safe.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/mn10300/Kconfig                  |    1 +
 arch/mn10300/include/asm/io.h         |    1 -
 arch/mn10300/unit-asb2305/Makefile    |    2 +-
 arch/mn10300/unit-asb2305/pci-iomap.c |   31 -------------------------------
 4 files changed, 2 insertions(+), 33 deletions(-)
 delete mode 100644 arch/mn10300/unit-asb2305/pci-iomap.c

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 438db84..8f1c40d 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -252,6 +252,7 @@ config PCI
 	bool "Use PCI"
 	depends on MN10300_UNIT_ASB2305
 	default y
+	select GENERIC_PCI_IOMAP
 	help
 	  Some systems (such as the ASB2305) have PCI onboard. If you have one
 	  of these boards and you wish to use the PCI facilities, say Y here.
diff --git a/arch/mn10300/include/asm/io.h b/arch/mn10300/include/asm/io.h
index 0d6d54f..139df8c 100644
--- a/arch/mn10300/include/asm/io.h
+++ b/arch/mn10300/include/asm/io.h
@@ -229,7 +229,6 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
diff --git a/arch/mn10300/unit-asb2305/Makefile b/arch/mn10300/unit-asb2305/Makefile
index 0551022..cbc5aba 100644
--- a/arch/mn10300/unit-asb2305/Makefile
+++ b/arch/mn10300/unit-asb2305/Makefile
@@ -5,4 +5,4 @@
 ###############################################################################
 obj-y   := unit-init.o leds.o
 
-obj-$(CONFIG_PCI) += pci.o pci-asb2305.o pci-irq.o pci-iomap.o
+obj-$(CONFIG_PCI) += pci.o pci-asb2305.o pci-irq.o
diff --git a/arch/mn10300/unit-asb2305/pci-iomap.c b/arch/mn10300/unit-asb2305/pci-iomap.c
deleted file mode 100644
index c1a8d8f..0000000
--- a/arch/mn10300/unit-asb2305/pci-iomap.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/* ASB2305 PCI I/O mapping handler
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/pci.h>
-#include <linux/module.h>
-
-/*
- * Create a virtual mapping cookie for a PCI BAR (memory or IO)
- */
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
-EXPORT_SYMBOL(pci_iomap);
-- 
1.7.8.382.g3daff

