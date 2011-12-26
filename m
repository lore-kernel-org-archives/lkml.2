Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1LZOEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 09:04:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1LZOED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 09:04:03 -0500
Date: Mon, 26 Dec 2011 16:05:55 +0200
From: Michael S Tsirkin <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jonas Bonn <jonas@southpole.se>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCHv2 RFC] pci: add pci_iomap_range
Message-ID: <20111226140449.GA18077@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wr9xp9cr.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtio drivers should map the part of the range they need, not necessarily
all of it. They also need non-cacheable mapping even for
prefetchable BARs.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---

>Rusty Russell wrote:
>> I think that we should add a forcenocache flag.
>> This will let devices put the cap structure in
>> the prefetcheable BAR. That has an advantage that
>> it can be located anywhere in the 2^64 space,
>> while non-prefetcheable BARs are limited to lower 4G
>> for devices behind a PCI-to-PCI bridge.
>OK, want to respin that patch (or patch on top and I'll fold?)

Here comes (warning - untested). This is on top of master.
As I'm moving this function for portability into
a separate file, it might be a good idea for this
to be rebased on top of my linux-next tree?

The whole mmio rework is not 3.3 material yes, is it?

 include/asm-generic/io.h    |    5 ++++
 include/asm-generic/iomap.h |   13 ++++++++++++
 lib/iomap.c                 |   46 +++++++++++++++++++++++++++++++++++++-----
 3 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 9120887..78aa159 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -286,6 +286,11 @@ static inline void writesb(const void __iomem *addr, const void *buf, int len)
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+				     unsigned offset,
+				     unsigned long minlen,
+				     unsigned long maxlen,
+				     bool force_nocache);
 static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
 {
 }
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 98dcd76..584a2b6 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -70,8 +70,21 @@ extern void ioport_unmap(void __iomem *);
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+				     unsigned offset,
+				     unsigned long minlen,
+				     unsigned long maxlen,
+				     bool force_nocache);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 #else
+static inline void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+					    unsigned offset,
+					    unsigned long minlen,
+					    unsigned long maxlen,
+					    bool force_nocache);
+{
+	return NULL;
+}
 struct pci_dev;
 static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
diff --git a/lib/iomap.c b/lib/iomap.c
index 5dbcb4b..efa7c29 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -243,33 +243,47 @@ EXPORT_SYMBOL(ioport_unmap);
 
 #ifdef CONFIG_PCI
 /**
- * pci_iomap - create a virtual mapping cookie for a PCI BAR
+ * pci_iomap_range - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
  * @bar: BAR number
- * @maxlen: length of the memory to map
+ * @offset: map memory at the given offset in BAR
+ * @minlen: min length of the memory to map
+ * @maxlen: max length of the memory to map
  *
  * Using this function you will get a __iomem address to your device BAR.
  * You can access it using ioread*() and iowrite*(). These functions hide
  * the details if this is a MMIO or PIO address space and will just do what
  * you expect from them in the correct way.
  *
+ * @minlen specifies the minimum length to map. We check that BAR is
+ * large enough.
  * @maxlen specifies the maximum length to map. If you want to get access to
- * the complete BAR without checking for its length first, pass %0 here.
+ * the complete BAR from offset to the end, pass %0 here.
+ * @force_nocache makes the mapping noncacheable even if the BAR
+ * is prefetcheable. It has no effect otherwise.
  * */
-void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
+void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
+			      unsigned offset,
+			      unsigned long minlen,
+			      unsigned long maxlen,
+			      bool force_nocache)
 {
 	resource_size_t start = pci_resource_start(dev, bar);
 	resource_size_t len = pci_resource_len(dev, bar);
 	unsigned long flags = pci_resource_flags(dev, bar);
 
-	if (!len || !start)
+	if (len <= offset || !start)
+		return NULL;
+	len -= offset;
+	start += offset;
+	if (len < minlen)
 		return NULL;
 	if (maxlen && len > maxlen)
 		len = maxlen;
 	if (flags & IORESOURCE_IO)
 		return ioport_map(start, len);
 	if (flags & IORESOURCE_MEM) {
-		if (flags & IORESOURCE_CACHEABLE)
+		if (!force_nocache && (flags & IORESOURCE_CACHEABLE))
 			return ioremap(start, len);
 		return ioremap_nocache(start, len);
 	}
@@ -277,10 +291,30 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
 	return NULL;
 }
 
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
+	return pci_iomap_range(dev, bar, 0, 0, maxlen, false);
+}
+
 void pci_iounmap(struct pci_dev *dev, void __iomem * addr)
 {
 	IO_COND(addr, /* nothing */, iounmap(addr));
 }
 EXPORT_SYMBOL(pci_iomap);
+EXPORT_SYMBOL(pci_iomap_range);
 EXPORT_SYMBOL(pci_iounmap);
 #endif /* CONFIG_PCI */
-- 
1.7.8.382.g3daff
