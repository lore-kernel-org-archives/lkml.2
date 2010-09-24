Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0IXQx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:53:56 -0400
Received: from kroah.org ([198.145.64.141]:38347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672Ab0IXQ21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:27 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:18 2010
Message-Id: <20100924162618.273518132@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [39/80] drivers/pci/intel-iommu.c: fix build with older gccs
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit df08cdc7ef606509debe7677c439be0ca48790e4 upstream.

drivers/pci/intel-iommu.c: In function `__iommu_calculate_agaw':
drivers/pci/intel-iommu.c:437: sorry, unimplemented: inlining failed in call to 'width_to_agaw': function body not available
drivers/pci/intel-iommu.c:445: sorry, unimplemented: called from here

Move the offending function (and its siblings) to top-of-file, remove the
forward declaration.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=17441

Reported-by: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   90 +++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 47 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -71,6 +71,49 @@
 #define DMA_32BIT_PFN		IOVA_PFN(DMA_BIT_MASK(32))
 #define DMA_64BIT_PFN		IOVA_PFN(DMA_BIT_MASK(64))
 
+/* page table handling */
+#define LEVEL_STRIDE		(9)
+#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
+
+static inline int agaw_to_level(int agaw)
+{
+	return agaw + 2;
+}
+
+static inline int agaw_to_width(int agaw)
+{
+	return 30 + agaw * LEVEL_STRIDE;
+}
+
+static inline int width_to_agaw(int width)
+{
+	return (width - 30) / LEVEL_STRIDE;
+}
+
+static inline unsigned int level_to_offset_bits(int level)
+{
+	return (level - 1) * LEVEL_STRIDE;
+}
+
+static inline int pfn_level_offset(unsigned long pfn, int level)
+{
+	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
+}
+
+static inline unsigned long level_mask(int level)
+{
+	return -1UL << level_to_offset_bits(level);
+}
+
+static inline unsigned long level_size(int level)
+{
+	return 1UL << level_to_offset_bits(level);
+}
+
+static inline unsigned long align_to_level(unsigned long pfn, int level)
+{
+	return (pfn + level_size(level) - 1) & level_mask(level);
+}
 
 /* VT-d pages must always be _smaller_ than MM pages. Otherwise things
    are never going to work. */
@@ -434,8 +477,6 @@ void free_iova_mem(struct iova *iova)
 }
 
 
-static inline int width_to_agaw(int width);
-
 static int __iommu_calculate_agaw(struct intel_iommu *iommu, int max_gaw)
 {
 	unsigned long sagaw;
@@ -646,51 +687,6 @@ out:
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-/* page table handling */
-#define LEVEL_STRIDE		(9)
-#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
-
-static inline int agaw_to_level(int agaw)
-{
-	return agaw + 2;
-}
-
-static inline int agaw_to_width(int agaw)
-{
-	return 30 + agaw * LEVEL_STRIDE;
-
-}
-
-static inline int width_to_agaw(int width)
-{
-	return (width - 30) / LEVEL_STRIDE;
-}
-
-static inline unsigned int level_to_offset_bits(int level)
-{
-	return (level - 1) * LEVEL_STRIDE;
-}
-
-static inline int pfn_level_offset(unsigned long pfn, int level)
-{
-	return (pfn >> level_to_offset_bits(level)) & LEVEL_MASK;
-}
-
-static inline unsigned long level_mask(int level)
-{
-	return -1UL << level_to_offset_bits(level);
-}
-
-static inline unsigned long level_size(int level)
-{
-	return 1UL << level_to_offset_bits(level);
-}
-
-static inline unsigned long align_to_level(unsigned long pfn, int level)
-{
-	return (pfn + level_size(level) - 1) & level_mask(level);
-}
-
 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				      unsigned long pfn)
 {


