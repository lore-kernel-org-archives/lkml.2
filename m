Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1K1TUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:20:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1K1TUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:20:33 -0500
Date: Mon, 28 Nov 2011 21:21:44 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Lasse Collin <lasse.collin@tukaani.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>, Jonas Bonn <jonas@southpole.se>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org
Subject: [PATCH-RFC 02/10 v2] lib: add GENERIC_PCI_IOMAP
Message-ID: <20111128192143.GA16459@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5a1327dd8bb38f87cba7ae10b308ec3b63de66a.1322163031.git.mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many architectures want a generic pci_iomap but
not the rest of iomap.c. Split that to a separate .c
file and add a new config symbol. select automatically
by GENERIC_IOMAP.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Here's an updated version (just this one patch was changed).
Changes from v1:
	minor tweaks to address comments by Stephen Rothwell 


 include/asm-generic/io.h        |    4 +-
 include/asm-generic/iomap.h     |    9 ++-----
 include/asm-generic/pci_iomap.h |   25 ++++++++++++++++++++
 lib/Kconfig                     |    4 +++
 lib/Makefile                    |    1 +
 lib/iomap.c                     |   38 +-----------------------------
 lib/pci_iomap.c                 |   48 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 85 insertions(+), 44 deletions(-)
 create mode 100644 include/asm-generic/pci_iomap.h
 create mode 100644 lib/pci_iomap.c

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 9120887..dddc61d 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -19,6 +19,8 @@
 #include <asm-generic/iomap.h>
 #endif
 
+#include <asm-generic/pci_iomap.h>
+
 #ifndef mmiowb
 #define mmiowb() do {} while (0)
 #endif
@@ -283,9 +285,7 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 #define __io_virt(x) ((void __force *) (x))
 
 #ifndef CONFIG_GENERIC_IOMAP
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 98dcd76..8a3d4fd 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -67,18 +67,15 @@ extern void ioport_unmap(void __iomem *);
 #endif
 
 #ifdef CONFIG_PCI
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+/* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 #else
 struct pci_dev;
-static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
-{
-	return NULL;
-}
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 { }
 #endif
 
+#include <asm-generic/pci_iomap.h>
+
 #endif
diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
new file mode 100644
index 0000000..8de4b73
--- /dev/null
+++ b/include/asm-generic/pci_iomap.h
@@ -0,0 +1,25 @@
+/* Generic I/O port emulation, based on MN10300 code
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_PCI_IOMAP_H
+#define __ASM_GENERIC_PCI_IOMAP_H
+
+struct pci_dev;
+#ifdef CONFIG_PCI
+/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+#else
+static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
+{
+	return NULL;
+}
+#endif
+
+#endif /* __ASM_GENERIC_IO_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 0058927..36884b4 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -19,8 +19,12 @@ config RATIONAL
 config GENERIC_FIND_FIRST_BIT
 	bool
 
+config GENERIC_PCI_IOMAP
+	bool
+
 config GENERIC_IOMAP
 	bool
+	select GENERIC_PCI_IOMAP
 
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
diff --git a/lib/Makefile b/lib/Makefile
index a4da283..609b2adc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -33,6 +33,7 @@ endif
 
 lib-$(CONFIG_HOTPLUG) += kobject_uevent.o
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
+obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
diff --git a/lib/iomap.c b/lib/iomap.c
index 5dbcb4b..ada922a 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -242,45 +242,11 @@ EXPORT_SYMBOL(ioport_unmap);
 #endif /* CONFIG_HAS_IOPORT */
 
 #ifdef CONFIG_PCI
-/**
- * pci_iomap - create a virtual mapping cookie for a PCI BAR
- * @dev: PCI device that owns the BAR
- * @bar: BAR number
- * @maxlen: length of the memory to map
- *
- * Using this function you will get a __iomem address to your device BAR.
- * You can access it using ioread*() and iowrite*(). These functions hide
- * the details if this is a MMIO or PIO address space and will just do what
- * you expect from them in the correct way.
- *
- * @maxlen specifies the maximum length to map. If you want to get access to
- * the complete BAR without checking for its length first, pass %0 here.
- * */
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
+/* Hide the details if this is a MMIO or PIO address space and just do what
+ * you expect in the correct way. */
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	IO_COND(addr, /* nothing */, iounmap(addr));
 }
-EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
 #endif /* CONFIG_PCI */
diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
new file mode 100644
index 0000000..4b0fdc2
--- /dev/null
+++ b/lib/pci_iomap.c
@@ -0,0 +1,48 @@
+/*
+ * Implement the default iomap interfaces
+ *
+ * (C) Copyright 2004 Linus Torvalds
+ */
+#include <linux/pci.h>
+#include <linux/io.h>
+
+#include <linux/export.h>
+
+#ifdef CONFIG_PCI
+/**
+ * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * @dev: PCI device that owns the BAR
+ * @bar: BAR number
+ * @maxlen: length of the memory to map
+ *
+ * Using this function you will get a __iomem address to your device BAR.
+ * You can access it using ioread*() and iowrite*(). These functions hide
+ * the details if this is a MMIO or PIO address space and will just do what
+ * you expect from them in the correct way.
+ *
+ * @maxlen specifies the maximum length to map. If you want to get access to
+ * the complete BAR without checking for its length first, pass %0 here.
+ * */
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+{
+	resource_size_t start = pci_resource_start(dev, bar);
+	resource_size_t len = pci_resource_len(dev, bar);
+	unsigned long flags = pci_resource_flags(dev, bar);
+
+	if (!len || !start)
+		return NULL;
+	if (maxlen && len > maxlen)
+		len = maxlen;
+	if (flags & IORESOURCE_IO)
+		return ioport_map(start, len);
+	if (flags & IORESOURCE_MEM) {
+		if (flags & IORESOURCE_CACHEABLE)
+			return ioremap(start, len);
+		return ioremap_nocache(start, len);
+	}
+	/* What? */
+	return NULL;
+}
+
+EXPORT_SYMBOL(pci_iomap);
+#endif /* CONFIG_PCI */
-- 
1.7.5.53.gc233e
