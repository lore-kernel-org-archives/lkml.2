Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1LUQ10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:27:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab1LUQ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:27:21 -0500
Date: Wed, 21 Dec 2011 18:29:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 03/16] alpha: switch to GENERIC_PCI_IOMAP
Message-ID: <8e603c6c464f654e0df85277ca56c011967ecee8.1324484752.git.mst@redhat.com>
References: <cover.1324484752.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1324484752.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alpha copied pci_iomap from generic code to avoid
pulling the rest of iomap.c in.  Since that's in
a separate file now, we can reuse the common implementation.

The only difference is handling of nocache flag,
that turns out to be done correctly by the
generic code since arch/alpha/include/asm/io.h
defines ioremap_nocache same as ioremap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Raúl Porcel <armin76@gentoo.org>
---
 arch/alpha/Kconfig      |    1 +
 arch/alpha/kernel/pci.c |   26 +-------------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 3636b11..56a4df9 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -315,6 +315,7 @@ config ISA_DMA_API
 config PCI
 	bool
 	depends on !ALPHA_JENSEN
+	select GENERIC_PCI_IOMAP
 	default y
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index c9ab94e..f3cae27 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -508,30 +508,7 @@ sys_pciconfig_iobase(long which, unsigned long bus, unsigned long dfn)
 	return -EOPNOTSUPP;
 }
 
-/* Create an __iomem token from a PCI BAR.  Copied from lib/iomap.c with
-   no changes, since we don't want the other things in that object file.  */
-
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
-		/* Not checking IORESOURCE_CACHEABLE because alpha does
-		   not distinguish between ioremap and ioremap_nocache.  */
-		return ioremap(start, len);
-	}
-	return NULL;
-}
-
-/* Destroy that token.  Not copied from lib/iomap.c.  */
+/* Destroy an __iomem token.  Not copied from lib/iomap.c.  */
 
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
@@ -539,7 +516,6 @@ void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 		iounmap(addr);
 }
 
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
 
 /* FIXME: Some boxes have multiple ISA bridges! */
-- 
1.7.8.382.g3daff

