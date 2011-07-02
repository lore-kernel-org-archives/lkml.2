Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1GBPxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 11:53:52 -0400
Received: from mail.southpole.se ([193.12.106.18]:44911 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1GBPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 11:53:39 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 2/2] iomap: make IOPORT/PCI mapping functions conditional
Date: Sat,  2 Jul 2011 17:53:26 +0200
Message-Id: <1309622006-28343-2-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309622006-28343-1-git-send-email-jonas@southpole.se>
References: <1309622006-28343-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the CONFIG_HAS_IOPORT and CONFIG_PCI options to decide whether or
not functions for mapping these areas are provided.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 include/asm-generic/io.h    |    2 ++
 include/asm-generic/iomap.h |    4 ++++
 lib/iomap.c                 |    4 ++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 50f4f43..49969c2 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -332,6 +332,7 @@ static inline void iounmap(void *addr)
 }
 #endif /* CONFIG_MMU */
 
+#ifdef CONFIG_HAS_IOPORT
 #ifndef CONFIG_GENERIC_IOMAP
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
@@ -345,6 +346,7 @@ static inline void ioport_unmap(void __iomem *p)
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
+#endif /* CONFIG_HAS_IOPORT */
 
 #define xlate_dev_kmem_ptr(p)	p
 
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 76b0cc5..c74ef2c 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -56,17 +56,21 @@ extern void iowrite8_rep(void __iomem *port, const void *buf, unsigned long coun
 extern void iowrite16_rep(void __iomem *port, const void *buf, unsigned long count);
 extern void iowrite32_rep(void __iomem *port, const void *buf, unsigned long count);
 
+#ifdef CONFIG_HAS_IOPORT
 /* Create a virtual mapping cookie for an IO port range */
 extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
 extern void ioport_unmap(void __iomem *);
+#endif
 
 #ifndef ARCH_HAS_IOREMAP_WC
 #define ioremap_wc ioremap_nocache
 #endif
 
+#ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
+#endif
 
 #endif
diff --git a/lib/iomap.c b/lib/iomap.c
index d322293..5dbcb4b 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -224,6 +224,7 @@ EXPORT_SYMBOL(iowrite8_rep);
 EXPORT_SYMBOL(iowrite16_rep);
 EXPORT_SYMBOL(iowrite32_rep);
 
+#ifdef CONFIG_HAS_IOPORT
 /* Create a virtual mapping cookie for an IO port range */
 void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
@@ -238,7 +239,9 @@ void ioport_unmap(void __iomem *addr)
 }
 EXPORT_SYMBOL(ioport_map);
 EXPORT_SYMBOL(ioport_unmap);
+#endif /* CONFIG_HAS_IOPORT */
 
+#ifdef CONFIG_PCI
 /**
  * pci_iomap - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
@@ -280,3 +283,4 @@ void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 }
 EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
+#endif /* CONFIG_PCI */
-- 
1.7.4.1

