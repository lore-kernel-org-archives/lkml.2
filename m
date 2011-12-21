Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1LUQ2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:28:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab1LUQ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:27:56 -0500
Date: Wed, 21 Dec 2011 18:29:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 07/16] parisc: switch to GENERIC_PCI_IOMAP
Message-ID: <cc7ac97aaa52fa5184ec9e17e7b7b86e3aab219d.1324484752.git.mst@redhat.com>
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

parisc copied pci_iomap from generic code, probably to avoid
pulling the rest of iomap.c in.  Since that's in
a separate file now, we can reuse the common implementation.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/parisc/Kconfig     |    1 +
 arch/parisc/lib/iomap.c |   23 -----------------------
 2 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index fdfd8be..242a1b7 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -14,6 +14,7 @@ config PARISC
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_PCI_IOMAP
 	select IRQ_PER_CPU
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
diff --git a/arch/parisc/lib/iomap.c b/arch/parisc/lib/iomap.c
index 8f470c9..fb8e10a 100644
--- a/arch/parisc/lib/iomap.c
+++ b/arch/parisc/lib/iomap.c
@@ -436,28 +436,6 @@ void ioport_unmap(void __iomem *addr)
 	}
 }
 
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
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
-	/* What? */
-	return NULL;
-}
-
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	if (!INDIRECT_ADDR(addr)) {
@@ -483,5 +461,4 @@ EXPORT_SYMBOL(iowrite16_rep);
 EXPORT_SYMBOL(iowrite32_rep);
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
-- 
1.7.8.382.g3daff

