Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1ABHtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:49:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:35846 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1ABHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 132/260] drivers/pci/intel-iommu.c: fix build with older gcc's
Date: Sun,  2 Jan 2011 02:17:08 -0500
Message-Id: <1293952756-15010-133-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:34.0696 (UTC) FILETIME=[D3738C80:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/intel-iommu.c |   90 +++++++++++++++++++++-----------------------
 1 files changed, 43 insertions(+), 47 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4173125..fff8832 100644
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
@@ -650,51 +691,6 @@ out:
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
-- 
1.7.3.3

