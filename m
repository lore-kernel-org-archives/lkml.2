Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1K2Sw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:52:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab1K2Swx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:52:53 -0500
Date: Tue, 29 Nov 2011 20:54:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH-RFC 2/2] tile: switch to GENERIC_PCI_IOMAP
Message-ID: <c5893cb30ae99a7e3c48b3fd209c770cd55c87ef.1322592495.git.mst@redhat.com>
References: <cover.1322592494.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1322592494.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tile now has working stubs for ioport_map and ioremap
such that the generic pci_iomap will DTRT: cast to
pointer on memory and return NULL and log message on IO map.

Switch it over to GENERIC_PCI_IOMAP.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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
index 2a8014c..1b6244e 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -465,27 +465,6 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
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
1.7.5.53.gc233e
