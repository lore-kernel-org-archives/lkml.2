Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1LUQ2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:28:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab1LUQ2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:28:08 -0500
Date: Wed, 21 Dec 2011 18:30:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 12/16] tile: switch to GENERIC_PCI_IOMAP
Message-ID: <e1640e60e2762b7171a1523698745a0d4a91ab0c.1324484752.git.mst@redhat.com>
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

tile now has working stubs for ioport_map and ioremap
such that the generic pci_iomap will DTRT: cast to
pointer on memory and return NULL and log message on IO map.

Switch it over to GENERIC_PCI_IOMAP.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig           |    1 +
 arch/tile/include/asm/pci.h |    2 +-
 arch/tile/kernel/pci.c      |   21 ---------------------
 3 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 70a0de4..11270ca 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -321,6 +321,7 @@ config PCI
 	bool "PCI support"
 	default y
 	select PCI_DOMAINS
+	select GENERIC_PCI_IOMAP
 	---help---
 	  Enable PCI root complex support, so PCIe endpoint devices can
 	  be attached to the Tile chip.  Many, but not all, PCI devices
diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index 7f03cef..1d25fea 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -16,6 +16,7 @@
 #define _ASM_TILE_PCI_H
 
 #include <linux/pci.h>
+#include <asm-generic/pci_iomap.h>
 
 /*
  * Structure of a PCI controller (host bridge)
@@ -49,7 +50,6 @@ struct pci_controller {
 int __devinit tile_pci_init(void);
 int __devinit pcibios_init(void);
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr) {}
 
 void __devinit pcibios_fixup_bus(struct pci_bus *bus);
diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 9d610d3..2556793 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -466,27 +466,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	return 0;
 }
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
-{
-	unsigned long start = pci_resource_start(dev, bar);
-	unsigned long len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len)
-		return NULL;
-	if (max && len > max)
-		len = max;
-
-	if (!(flags & IORESOURCE_MEM)) {
-		pr_info("PCI: Trying to map invalid resource %#lx\n", flags);
-		start = 0;
-	}
-
-	return (void __iomem *)start;
-}
-EXPORT_SYMBOL(pci_iomap);
-
-
 /****************************************************************
  *
  * Tile PCI config space read/write routines
-- 
1.7.8.382.g3daff

