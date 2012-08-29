Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2H2G4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:56:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11907 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2H2G4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:56:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Aug 2012 23:49:45 -0700
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
Subject: [RFC 1/5] ARM: dma-mapping: New dma_map_ops->iova_get_free_{total,max} functions
Date: Wed, 29 Aug 2012 09:55:31 +0300
Message-ID: <1346223335-31455-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->iova>_get_free_total() returns the sum of available free areas.
->iova>_get_free_max() returns the largest available free area size.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/include/asm/dma-mapping.h |   16 ++++++++++
 arch/arm/mm/dma-mapping.c          |   54 ++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h        |    3 ++
 3 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 2300484..1cbd279 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -170,6 +170,22 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
 	ops->free(dev, size, cpu_addr, dma_handle, attrs);
 }
 
+static inline size_t dma_iova_get_free_total(struct device *dev)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	BUG_ON(!ops);
+
+	return ops->iova_get_free_total(dev);
+}
+
+static inline size_t dma_iova_get_free_max(struct device *dev)
+{
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	BUG_ON(!ops);
+
+	return ops->iova_get_free_max(dev);
+}
+
 /**
  * arm_dma_mmap - map a coherent DMA allocation into user space
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e4746b7..db17338 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1001,6 +1001,57 @@ fs_initcall(dma_debug_do_init);
 
 /* IOMMU */
 
+static size_t arm_iommu_iova_get_free_total(struct device *dev)
+{
+	struct dma_iommu_mapping *mapping = dev->archdata.mapping;
+	unsigned long flags;
+	size_t size = 0;
+	unsigned long start = 0;
+
+	BUG_ON(!dev);
+	BUG_ON(!mapping);
+
+	spin_lock_irqsave(&mapping->lock, flags);
+	while (1) {
+		unsigned long end;
+
+		start = bitmap_find_next_zero_area(mapping->bitmap,
+						   mapping->bits, start, 1, 0);
+		if (start > mapping->bits)
+			break;
+
+		end = find_next_bit(mapping->bitmap, mapping->bits, start);
+		size += end - start;
+		start = end;
+	}
+	spin_unlock_irqrestore(&mapping->lock, flags);
+	return size << (mapping->order + PAGE_SHIFT);
+}
+
+static size_t arm_iommu_iova_get_free_max(struct device *dev)
+{
+	struct dma_iommu_mapping *mapping = dev->archdata.mapping;
+	unsigned long flags;
+	size_t max_free = 0;
+	unsigned long start = 0;
+
+	spin_lock_irqsave(&mapping->lock, flags);
+	while (1) {
+		unsigned long end;
+
+		start = bitmap_find_next_zero_area(mapping->bitmap,
+						   mapping->bits, start, 1, 0);
+		if (start > mapping->bits)
+			break;
+
+		end = find_next_bit(mapping->bitmap, mapping->bits, start);
+		max_free = max_t(size_t, max_free, end - start);
+		start = end;
+	}
+	spin_unlock_irqrestore(&mapping->lock, flags);
+	return max_free << (mapping->order + PAGE_SHIFT);
+}
+
 static inline dma_addr_t __alloc_iova(struct dma_iommu_mapping *mapping,
 				      size_t size)
 {
@@ -1721,6 +1772,9 @@ struct dma_map_ops iommu_ops = {
 	.unmap_sg		= arm_iommu_unmap_sg,
 	.sync_sg_for_cpu	= arm_iommu_sync_sg_for_cpu,
 	.sync_sg_for_device	= arm_iommu_sync_sg_for_device,
+
+	.iova_get_free_total	= arm_iommu_iova_get_free_total,
+	.iova_get_free_max	= arm_iommu_iova_get_free_max,
 };
 
 struct dma_map_ops iommu_coherent_ops = {
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 94af418..0337182 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -53,6 +53,9 @@ struct dma_map_ops {
 #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
 	u64 (*get_required_mask)(struct device *dev);
 #endif
+	size_t (*iova_get_free_total)(struct device *dev);
+	size_t (*iova_get_free_max)(struct device *dev);
+
 	int is_phys;
 };
 
-- 
1.7.5.4

