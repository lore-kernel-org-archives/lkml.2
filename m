Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab1JQL3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:29:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42213 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1JQL26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:28:58 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v4 1/7] iommu/core: stop converting bytes to page order back and forth
Date: Mon, 17 Oct 2011 13:27:20 +0200
Message-Id: <1318850846-16066-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318850846-16066-1-git-send-email-ohad@wizery.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Express sizes in bytes rather than in page order, to eliminate the
size->order->size conversions we have whenever the IOMMU API is calling
the low level drivers' map/unmap methods.

Adopt all existing drivers.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: KyongHo Cho <pullip.cho@samsung.com>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/iommu/amd_iommu.c   |   13 +++++--------
 drivers/iommu/intel-iommu.c |   11 ++++-------
 drivers/iommu/iommu.c       |    8 +++++---
 drivers/iommu/msm_iommu.c   |   19 +++++++------------
 drivers/iommu/omap-iommu.c  |   14 +++++---------
 include/linux/iommu.h       |    6 +++---
 6 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 764e3da..32d502e 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2702,9 +2702,8 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 }
 
 static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
-			 phys_addr_t paddr, int gfp_order, int iommu_prot)
+			 phys_addr_t paddr, size_t page_size, int iommu_prot)
 {
-	unsigned long page_size = 0x1000UL << gfp_order;
 	struct protection_domain *domain = dom->priv;
 	int prot = 0;
 	int ret;
@@ -2721,13 +2720,11 @@ static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 	return ret;
 }
 
-static int amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
-			   int gfp_order)
+static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
+			   size_t page_size)
 {
 	struct protection_domain *domain = dom->priv;
-	unsigned long page_size, unmap_size;
-
-	page_size  = 0x1000UL << gfp_order;
+	size_t unmap_size;
 
 	mutex_lock(&domain->api_lock);
 	unmap_size = iommu_unmap_page(domain, iova, page_size);
@@ -2735,7 +2732,7 @@ static int amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 
 	domain_flush_tlb_pde(domain);
 
-	return get_order(unmap_size);
+	return unmap_size;
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 2d53c3d..96a9bd4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3821,12 +3821,11 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 
 static int intel_iommu_map(struct iommu_domain *domain,
 			   unsigned long iova, phys_addr_t hpa,
-			   int gfp_order, int iommu_prot)
+			   size_t size, int iommu_prot)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
 	int prot = 0;
-	size_t size;
 	int ret;
 
 	if (iommu_prot & IOMMU_READ)
@@ -3836,7 +3835,6 @@ static int intel_iommu_map(struct iommu_domain *domain,
 	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
 		prot |= DMA_PTE_SNP;
 
-	size     = PAGE_SIZE << gfp_order;
 	max_addr = iova + size;
 	if (dmar_domain->max_addr < max_addr) {
 		u64 end;
@@ -3859,11 +3857,10 @@ static int intel_iommu_map(struct iommu_domain *domain,
 	return ret;
 }
 
-static int intel_iommu_unmap(struct iommu_domain *domain,
-			     unsigned long iova, int gfp_order)
+static size_t intel_iommu_unmap(struct iommu_domain *domain,
+			     unsigned long iova, size_t size)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
-	size_t size = PAGE_SIZE << gfp_order;
 
 	dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
 			    (iova + size - 1) >> VTD_PAGE_SHIFT);
@@ -3871,7 +3868,7 @@ static int intel_iommu_unmap(struct iommu_domain *domain,
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
-	return gfp_order;
+	return size;
 }
 
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 63ca9ba..5d042e8 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -168,13 +168,13 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 
 	BUG_ON(!IS_ALIGNED(iova | paddr, size));
 
-	return domain->ops->map(domain, iova, paddr, gfp_order, prot);
+	return domain->ops->map(domain, iova, paddr, size, prot);
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
 int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 {
-	size_t size;
+	size_t size, unmapped;
 
 	if (unlikely(domain->ops->unmap == NULL))
 		return -ENODEV;
@@ -183,7 +183,9 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 
 	BUG_ON(!IS_ALIGNED(iova, size));
 
-	return domain->ops->unmap(domain, iova, gfp_order);
+	unmapped = domain->ops->unmap(domain, iova, size);
+
+	return get_order(unmapped);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
 
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 5865dd2..13718d9 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -352,7 +352,7 @@ fail:
 }
 
 static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
-			 phys_addr_t pa, int order, int prot)
+			 phys_addr_t pa, size_t len, int prot)
 {
 	struct msm_priv *priv;
 	unsigned long flags;
@@ -363,7 +363,6 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 	unsigned long *sl_pte;
 	unsigned long sl_offset;
 	unsigned int pgprot;
-	size_t len = 0x1000UL << order;
 	int ret = 0, tex, sh;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
@@ -463,8 +462,8 @@ fail:
 	return ret;
 }
 
-static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
-			    int order)
+static size_t msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
+			    size_t len)
 {
 	struct msm_priv *priv;
 	unsigned long flags;
@@ -474,7 +473,6 @@ static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
 	unsigned long *sl_table;
 	unsigned long *sl_pte;
 	unsigned long sl_offset;
-	size_t len = 0x1000UL << order;
 	int i, ret = 0;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
@@ -544,15 +542,12 @@ static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
 
 	ret = __flush_iotlb(domain);
 
-	/*
-	 * the IOMMU API requires us to return the order of the unmapped
-	 * page (on success).
-	 */
-	if (!ret)
-		ret = order;
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
-	return ret;
+
+	/* the IOMMU API requires us to return how many bytes were unmapped */
+	len = ret ? 0 : len;
+	return len;
 }
 
 static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 9ee2c38..1bb2971 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1019,12 +1019,11 @@ static void iopte_cachep_ctor(void *iopte)
 }
 
 static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
-			 phys_addr_t pa, int order, int prot)
+			 phys_addr_t pa, size_t bytes, int prot)
 {
 	struct omap_iommu_domain *omap_domain = domain->priv;
 	struct omap_iommu *oiommu = omap_domain->iommu_dev;
 	struct device *dev = oiommu->dev;
-	size_t bytes = PAGE_SIZE << order;
 	struct iotlb_entry e;
 	int omap_pgsz;
 	u32 ret, flags;
@@ -1049,19 +1048,16 @@ static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
 	return ret;
 }
 
-static int omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
-			    int order)
+static size_t omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
+			    size_t size)
 {
 	struct omap_iommu_domain *omap_domain = domain->priv;
 	struct omap_iommu *oiommu = omap_domain->iommu_dev;
 	struct device *dev = oiommu->dev;
-	size_t unmap_size;
 
-	dev_dbg(dev, "unmapping da 0x%lx order %d\n", da, order);
+	dev_dbg(dev, "unmapping da 0x%lx size %u\n", da, size);
 
-	unmap_size = iopgtable_clear_entry(oiommu, da);
-
-	return unmap_size ? get_order(unmap_size) : -EINVAL;
+	return iopgtable_clear_entry(oiommu, da);
 }
 
 static int
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 710291f..6b6ed21 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -54,9 +54,9 @@ struct iommu_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
 	int (*map)(struct iommu_domain *domain, unsigned long iova,
-		   phys_addr_t paddr, int gfp_order, int prot);
-	int (*unmap)(struct iommu_domain *domain, unsigned long iova,
-		     int gfp_order);
+		   phys_addr_t paddr, size_t size, int prot);
+	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
+		     size_t size);
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    unsigned long iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
-- 
1.7.4.1

