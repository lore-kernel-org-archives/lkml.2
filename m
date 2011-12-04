Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1LDOdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 09:33:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1LDOdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 09:33:10 -0500
Date: Sun, 4 Dec 2011 16:34:49 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sam Ravnborg <sam.ravnborg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH-RFC v2 10/10] sparc: switch to GENERIC_PCI_IOMAP
Message-ID: <20111204143448.GA21535@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63292221aef2eb299e7dba860b3ee38c2ed05eb8.1322163031.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparc copied pci_iomap from generic code, probably to avoid
pulling the rest of iomap.c in.  Since that's in
a separate file now, we can reuse the common implementation.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Changes from v1:
	remove ifdef __KERNEL__ from files
	not exported to userspace.

 arch/sparc/Kconfig             |    1 +
 arch/sparc/include/asm/io_32.h |    2 +-
 arch/sparc/include/asm/io_64.h |    2 +-
 arch/sparc/lib/iomap.c         |   23 -----------------------
 4 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index f92602e..a4644f5 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -28,6 +28,7 @@ config SPARC
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select USE_GENERIC_SMP_HELPERS if SMP
+	select GENERIC_PCI_IOMAP
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index c2ced21..2006e5d 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -7,6 +7,7 @@
 
 #include <asm/page.h>      /* IO address mapping routines need this */
 #include <asm/system.h>
+#include <asm-generic/pci_iomap.h>
 
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
@@ -324,7 +325,6 @@ extern void ioport_unmap(void __iomem *);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
 /*
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 9c89654..9481e5a 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -8,6 +8,7 @@
 #include <asm/page.h>      /* IO address mapping routines need this */
 #include <asm/system.h>
 #include <asm/asi.h>
+#include <asm-generic/pci_iomap.h>
 
 /* PC crapola... */
 #define __SLOW_DOWN_IO	do { } while (0)
@@ -514,7 +515,6 @@ extern void ioport_unmap(void __iomem *);
 
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
 static inline int sbus_can_dma_64bit(void)
diff --git a/arch/sparc/lib/iomap.c b/arch/sparc/lib/iomap.c
index 9ef37e1..c4d42a5 100644
--- a/arch/sparc/lib/iomap.c
+++ b/arch/sparc/lib/iomap.c
@@ -18,31 +18,8 @@ void ioport_unmap(void __iomem *addr)
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
 
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
 	/* nothing to do */
 }
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
-- 
1.7.5.53.gc233e
