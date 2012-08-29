Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2H2G41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:56:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5058 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2H2G4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:56:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Aug 2012 23:56:08 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <m.szyprowski@samsung.com>
CC: <iommu@lists.linux-foundation.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <arnd@arndb.de>, <linux@arm.linux.org.uk>, <chunsang.jeong@linaro.org>,
        <vdumpa@nvidia.com>, <subashrp@gmail.com>, <minchan@kernel.org>,
        <pullip.cho@samsung.com>, <konrad.wilk@oracle.com>,
        <linux-tegra@vger.kernel.org>
Subject: [RFC 3/5] ARM: dma-mapping: New dma_map_ops->iova_alloc*_at* function
Date: Wed, 29 Aug 2012 09:55:33 +0300
Message-ID: <1346223335-31455-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allocate IOVA area at specified address

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/include/asm/dma-mapping.h |    9 +++++++++
 arch/arm/mm/dma-mapping.c          |   35 +++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h        |    2 ++
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 5b86600..f04a533 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -187,6 +187,15 @@ static inline void dma_iova_free(struct device *dev, dma_addr_t addr,
 	ops->iova_free(dev, addr, size);
 }
 
+static inline dma_addr_t dma_iova_alloc_at(struct device *dev, dma_addr_t addr,
+					   size_t size)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	BUG_ON(!ops);
+
+	return ops->iova_alloc_at(dev, addr, size);
+}
+
 static inline size_t dma_iova_get_free_total(struct device *dev)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index c18522a..8ca2d1a 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1080,6 +1080,40 @@ static inline dma_addr_t __alloc_iova(struct dma_iommu_mapping *mapping,
 	return mapping->base + (start << (mapping->order + PAGE_SHIFT));
 }
 
+static dma_addr_t __alloc_iova_at(struct dma_iommu_mapping *mapping,
+				  dma_addr_t iova, size_t size)
+{
+	unsigned int count, start, orig;
+	unsigned long flags;
+
+	count = ((PAGE_ALIGN(size) >> PAGE_SHIFT) +
+		 (1 << mapping->order) - 1) >> mapping->order;
+
+	spin_lock_irqsave(&mapping->lock, flags);
+
+	orig = (iova - mapping->base) >> (mapping->order + PAGE_SHIFT);
+	start = bitmap_find_next_zero_area(mapping->bitmap, mapping->bits,
+					   orig, count, 0);
+
+	if ((start > mapping->bits) || (orig != start)) {
+		spin_unlock_irqrestore(&mapping->lock, flags);
+		return DMA_ERROR_CODE;
+	}
+
+	bitmap_set(mapping->bitmap, start, count);
+	spin_unlock_irqrestore(&mapping->lock, flags);
+
+	return mapping->base + (start << (mapping->order + PAGE_SHIFT));
+}
+
+static dma_addr_t arm_iommu_iova_alloc_at(struct device *dev, dma_addr_t iova,
+				size_t size)
+{
+	struct dma_iommu_mapping *mapping = dev->archdata.mapping;
+
+	return __alloc_iova_at(mapping, iova, size);
+}
+
 static dma_addr_t arm_iommu_iova_alloc(struct device *dev, size_t size)
 {
 	struct dma_iommu_mapping *mapping = dev->archdata.mapping;
@@ -1789,6 +1823,7 @@ struct dma_map_ops iommu_ops = {
 	.sync_sg_for_device	= arm_iommu_sync_sg_for_device,
 
 	.iova_alloc		= arm_iommu_iova_alloc,
+	.iova_alloc_at		= arm_iommu_iova_alloc_at,
 	.iova_free		= arm_iommu_iova_free,
 	.iova_get_free_total	= arm_iommu_iova_get_free_total,
 	.iova_get_free_max	= arm_iommu_iova_get_free_max,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index e85aa04..4cf4427 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -54,6 +54,8 @@ struct dma_map_ops {
 	u64 (*get_required_mask)(struct device *dev);
 #endif
 	dma_addr_t (*iova_alloc)(struct device *dev, size_t size);
+	dma_addr_t (*iova_alloc_at)(struct device *dev, dma_addr_t dma_addr,
+				    size_t size);
 	void (*iova_free)(struct device *dev, dma_addr_t addr, size_t size);
 	size_t (*iova_get_free_total)(struct device *dev);
 	size_t (*iova_get_free_max)(struct device *dev);
-- 
1.7.5.4

