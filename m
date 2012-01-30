Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2A3MQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 07:16:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab2A3MQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 07:16:46 -0500
Date: Mon, 30 Jan 2012 14:18:39 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael Witten <mfwitten@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 1/3] lib: add NO_GENERIC_PCI_IOPORT_MAP
Message-ID: <d78d91d0166651700cf662a50c87d84da4bdab88.1327877053.git.mst@redhat.com>
References: <cover.1327877053.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1327877053.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures need to override the way
IO port mapping is does not PCI devices.
Supply a generic function that calls
ioport_map, and make it possible for architectures
to override.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/asm-generic/pci_iomap.h |    5 +++++
 lib/Kconfig                     |    3 +++
 lib/pci_iomap.c                 |   12 +++++++++++-
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
index 8de4b73..2aff58e 100644
--- a/include/asm-generic/pci_iomap.h
+++ b/include/asm-generic/pci_iomap.h
@@ -15,6 +15,11 @@ struct pci_dev;
 #ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+/* Create a virtual mapping cookie for a port on a given PCI device.
+ * Do not call this directly, it exists to make it easier for architectures
+ * to override. */
+extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
+				      unsigned int nr);
 #else
 static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
diff --git a/lib/Kconfig b/lib/Kconfig
index 169eb7c..1df1388 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -19,6 +19,9 @@ config RATIONAL
 config GENERIC_FIND_FIRST_BIT
 	bool
 
+config NO_GENERIC_PCI_IOPORT_MAP
+	bool
+
 config GENERIC_PCI_IOMAP
 	bool
 
diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index 4b0fdc2..1dfda29 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -9,6 +9,16 @@
 #include <linux/export.h>
 
 #ifdef CONFIG_PCI
+#ifndef CONFIG_NO_GENERIC_PCI_IOPORT_MAP
+/* Architectures can override ioport mapping while
+ * still using the rest of the generic infrastructure. */
+void __iomem *__pci_ioport_map(struct pci_dev *dev,
+			       unsigned long port,
+			       unsigned int nr)
+{
+	return ioport_map(port, nr);
+}
+#endif
 /**
  * pci_iomap - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
@@ -34,7 +44,7 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 	if (maxlen && len > maxlen)
 		len = maxlen;
 	if (flags & IORESOURCE_IO)
-		return ioport_map(start, len);
+		return __pci_ioport_map(dev, start, len);
 	if (flags & IORESOURCE_MEM) {
 		if (flags & IORESOURCE_CACHEABLE)
 			return ioremap(start, len);
-- 
1.7.8.2.325.g247f9

