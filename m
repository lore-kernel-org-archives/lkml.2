Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1LUQ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:27:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1LUQ1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:27:30 -0500
Date: Wed, 21 Dec 2011 18:29:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 05/16] microblaze: switch to GENERIC_PCI_IOMAP
Message-ID: <fddd6579701c79e63a20e35691f0918adc0df961.1324484752.git.mst@redhat.com>
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

microblaze copied pci_iomap from generic code, probably to avoid
pulling the rest of iomap.c in.  Since that's in
a separate file now, we can reuse the common implementation.

The only difference is handling of nocache flag,
that turns out to be done correctly by the
generic code since arch/microblaze/include/asm/io.h
defines ioremap_nocache same as ioremap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/microblaze/Kconfig     |    1 +
 arch/microblaze/pci/iomap.c |   19 -------------------
 2 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index e446bab..f0eead7 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -17,6 +17,7 @@ config MICROBLAZE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_PCI_IOMAP
 
 config SWAP
 	def_bool n
diff --git a/arch/microblaze/pci/iomap.c b/arch/microblaze/pci/iomap.c
index 57acda8..b07abba 100644
--- a/arch/microblaze/pci/iomap.c
+++ b/arch/microblaze/pci/iomap.c
@@ -10,25 +10,6 @@
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
 
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
-{
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
-
-	if (!len)
-		return NULL;
-	if (max && len > max)
-		len = max;
-	if (flags & IORESOURCE_IO)
-		return ioport_map(start, len);
-	if (flags & IORESOURCE_MEM)
-		return ioremap(start, len);
-	/* What? */
-	return NULL;
-}
-EXPORT_SYMBOL(pci_iomap);
-
 void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 {
 	if (isa_vaddr_is_ioport(addr))
-- 
1.7.8.382.g3daff

