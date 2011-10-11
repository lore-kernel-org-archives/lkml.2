Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1JKRBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:01:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37801 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab1JKRBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:01:47 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <20111011103820.GF2138@amd.com>
References: <20110927100505.GH2138@amd.com> <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com> <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com> <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com> <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com> <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
 <20111011103820.GF2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 11 Oct 2011 19:01:23 +0200
Message-ID: <CAK=WgbYOUZNX0OmRwZNO1mMG+3DZXwff+S60ESWixf04HOcbtw@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 12:38 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> You need to make sure that you don;t pass larger regions then requested
> to the low-level driver. Some logic like in the iommu_map function
> should do it.

You're right. But the solution IMHO should be getting rid of that size
-> order -> size conversion which we do back and forth, as it's kinda
pointless.

> Please use PAGE_SIZE instead of 0x1000UL.

This one would go away too if we remove the size -> order -> size
conversions. In fact, iommu_unmap() just becomes so much simpler when
we do that.

I'm attaching two patches: first one that removes the
size->order->size conversions we have, and then the usual pgsize patch
rebased to it.

Please take a look,

Thanks,
Ohad.

>From 7102bda53a425872591f14f850ab031b1ca5dae1 Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 11 Oct 2011 16:50:38 +0200
Subject: [PATCH 1/2] iommu/core: stop converting bytes to page order
back and forth

Express sizes in bytes rather than in page order, to eliminate the
size->order->size conversions we have whenever the IOMMU API is calling
the low level drivers' map/unmap methods.

Adopt all existing drivers.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
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
@@ -2702,9 +2702,8 @@ static int amd_iommu_attach_device(struct
iommu_domain *dom,
 }

 static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
-			 phys_addr_t paddr, int gfp_order, int iommu_prot)
+			 phys_addr_t paddr, size_t page_size, int iommu_prot)
 {
-	unsigned long page_size = 0x1000UL << gfp_order;
 	struct protection_domain *domain = dom->priv;
 	int prot = 0;
 	int ret;
@@ -2721,13 +2720,11 @@ static int amd_iommu_map(struct iommu_domain
*dom, unsigned long iova,
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
@@ -2735,7 +2732,7 @@ static int amd_iommu_unmap(struct iommu_domain
*dom, unsigned long iova,

 	domain_flush_tlb_pde(domain);

-	return get_order(unmap_size);
+	return unmap_size;
 }

 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 2d53c3d..96a9bd4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3821,12 +3821,11 @@ static void intel_iommu_detach_device(struct
iommu_domain *domain,

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
@@ -168,13 +168,13 @@ int iommu_map(struct iommu_domain *domain,
unsigned long iova,

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
@@ -183,7 +183,9 @@ int iommu_unmap(struct iommu_domain *domain,
unsigned long iova, int gfp_order)

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
@@ -363,7 +363,6 @@ static int msm_iommu_map(struct iommu_domain
*domain, unsigned long va,
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
@@ -474,7 +473,6 @@ static int msm_iommu_unmap(struct iommu_domain
*domain, unsigned long va,
 	unsigned long *sl_table;
 	unsigned long *sl_pte;
 	unsigned long sl_offset;
-	size_t len = 0x1000UL << order;
 	int i, ret = 0;

 	spin_lock_irqsave(&msm_iommu_lock, flags);
@@ -544,15 +542,12 @@ static int msm_iommu_unmap(struct iommu_domain
*domain, unsigned long va,

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
@@ -1049,19 +1048,16 @@ static int omap_iommu_map(struct iommu_domain
*domain, unsigned long da,
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


>From 1ddc6ad8ef8618f9a4d04bdc960c1b0f694beb49 Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Oct 2011 23:50:55 +0200
Subject: [PATCH 2/2] iommu/core: split mapping to page sizes as
supported by the hardware

When mapping a memory region, split it to page sizes as supported
by the iommu hardware. Always prefer bigger pages, when possible,
in order to reduce the TLB pressure.

The logic to do that is now added to the IOMMU core, so neither the iommu
drivers themselves nor users of the IOMMU API have to duplicate it.

This allows a more lenient granularity of mappings; traditionally the
IOMMU API took 'order' (of a page) as a mapping size, and directly let
the low level iommu drivers handle the mapping, but now that the IOMMU
core can split arbitrary memory regions into pages, we can remove this
limitation, so users don't have to split those regions by themselves.

Currently the supported page sizes are advertised once and they then
remain static. That works well for OMAP and MSM but it would probably
not fly well with intel's hardware, where the page size capabilities
seem to have the potential to be different between several DMA
remapping devices.

register_iommu() currently sets a default pgsize behavior, so we can convert
the IOMMU drivers in subsequent patches. After all the drivers
are converted, the temporary default settings will be removed.

Mainline users of the IOMMU API (kvm and omap-iovmm) are adopted
to deal with bytes instead of page order.

Many thanks to Joerg Roedel <Joerg.Roedel@amd.com> for significant review!

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: KyongHo Cho <pullip.cho@samsung.com>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kvm@vger.kernel.org
---
 drivers/iommu/iommu.c      |  112 +++++++++++++++++++++++++++++++++++++++----
 drivers/iommu/omap-iovmm.c |   17 ++----
 include/linux/iommu.h      |   24 ++++++++-
 virt/kvm/iommu.c           |    8 ++--
 4 files changed, 132 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 5d042e8..9355632 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -16,6 +16,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */

+#define pr_fmt(fmt)    "%s: " fmt, __func__
+
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/bug.h>
@@ -47,6 +49,19 @@ int bus_set_iommu(struct bus_type *bus, struct
iommu_ops *ops)
 	if (bus->iommu_ops != NULL)
 		return -EBUSY;

+	/*
+	 * Set the default pgsize values, which retain the existing
+	 * IOMMU API behavior: drivers will be called to map
+	 * regions that are sized/aligned to order of 4KiB pages.
+	 *
+	 * This will be removed once all drivers are migrated.
+	 */
+	if (!ops->pgsize_bitmap)
+		ops->pgsize_bitmap = ~0xFFFUL;
+
+	/* find out the minimum page size only once */
+	ops->min_pagesz = 1 << __ffs(ops->pgsize_bitmap);
+
 	bus->iommu_ops = ops;

 	/* Do IOMMU specific setup for this bus-type */
@@ -157,35 +172,110 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);

 int iommu_map(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, int gfp_order, int prot)
+	      phys_addr_t paddr, size_t size, int prot)
 {
-	size_t size;
+	unsigned long orig_iova = iova;
+	size_t orig_size = size;
+	int ret = 0;

 	if (unlikely(domain->ops->map == NULL))
 		return -ENODEV;

-	size         = PAGE_SIZE << gfp_order;
+	/*
+	 * both the virtual address and the physical one, as well as
+	 * the size of the mapping, must be aligned (at least) to the
+	 * size of the smallest page supported by the hardware
+	 */
+	if (!IS_ALIGNED(iova | paddr | size, domain->ops->min_pagesz)) {
+		pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%x min_pagesz "
+			"0x%x\n", iova, (unsigned long)paddr,
+			size, domain->ops->min_pagesz);
+		return -EINVAL;
+	}
+
+	pr_debug("map: iova 0x%lx pa 0x%lx size 0x%x\n", iova,
+				(unsigned long)paddr, size);
+
+	while (size) {
+		unsigned long pgsize, addr_merge = iova | paddr;
+		unsigned int pgsize_idx;
+
+		/* Max page size that still fits into 'size' */
+		pgsize_idx = __fls(size);
+
+		/* need to consider alignment requirements ? */
+		if (likely(addr_merge)) {
+			/* Max page size allowed by both iova and paddr */
+			unsigned int align_pgsize_idx = __ffs(addr_merge);
+
+			pgsize_idx = min(pgsize_idx, align_pgsize_idx);
+		}
+
+		/* build a mask of acceptable page sizes */
+		pgsize = (1UL << (pgsize_idx + 1)) - 1;

-	BUG_ON(!IS_ALIGNED(iova | paddr, size));
+		/* throw away page sizes not supported by the hardware */
+		pgsize &= domain->ops->pgsize_bitmap;

-	return domain->ops->map(domain, iova, paddr, size, prot);
+		/* make sure we're still sane */
+		BUG_ON(!pgsize);
+
+		/* pick the biggest page */
+		pgsize_idx = __fls(pgsize);
+		pgsize = 1UL << pgsize_idx;
+
+		pr_debug("mapping: iova 0x%lx pa 0x%lx pgsize %lu\n", iova,
+					(unsigned long)paddr, pgsize);
+
+		ret = domain->ops->map(domain, iova, paddr, pgsize, prot);
+		if (ret)
+			break;
+
+		iova += pgsize;
+		paddr += pgsize;
+		size -= pgsize;
+	}
+
+	/* unroll mapping in case something went wrong */
+	if (ret)
+		iommu_unmap(domain, orig_iova, orig_size - size);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_map);

-int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
+size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
size_t size)
 {
-	size_t size, unmapped;
+	size_t unmapped, left = size;

 	if (unlikely(domain->ops->unmap == NULL))
 		return -ENODEV;

-	size         = PAGE_SIZE << gfp_order;
+	/*
+	 * The virtual address, as well as the size of the mapping, must be
+	 * aligned (at least) to the size of the smallest page supported
+	 * by the hardware
+	 */
+	if (!IS_ALIGNED(iova | size, domain->ops->min_pagesz)) {
+		pr_err("unaligned: iova 0x%lx size 0x%x min_pagesz 0x%x\n",
+			iova, size, domain->ops->min_pagesz);
+		return -EINVAL;
+	}
+
+	pr_debug("unmap this: iova 0x%lx size 0x%x\n", iova, size);
+
+	while (left) {
+		unmapped = domain->ops->unmap(domain, iova, left);
+		if (!unmapped)
+			break;

-	BUG_ON(!IS_ALIGNED(iova, size));
+		pr_debug("unmapped: iova 0x%lx size %u\n", iova, unmapped);

-	unmapped = domain->ops->unmap(domain, iova, size);
+		iova += unmapped;
+		left -= unmapped;
+	}

-	return get_order(unmapped);
+	return size - left;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);

diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index e8fdb88..0b7b14c 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -409,7 +409,6 @@ static int map_iovm_area(struct iommu_domain
*domain, struct iovm_struct *new,
 	unsigned int i, j;
 	struct scatterlist *sg;
 	u32 da = new->da_start;
-	int order;

 	if (!domain || !sgt)
 		return -EINVAL;
@@ -428,12 +427,10 @@ static int map_iovm_area(struct iommu_domain
*domain, struct iovm_struct *new,
 		if (bytes_to_iopgsz(bytes) < 0)
 			goto err_out;

-		order = get_order(bytes);
-
 		pr_debug("%s: [%d] %08x %08x(%x)\n", __func__,
 			 i, da, pa, bytes);

-		err = iommu_map(domain, da, pa, order, flags);
+		err = iommu_map(domain, da, pa, bytes, flags);
 		if (err)
 			goto err_out;

@@ -448,10 +445,9 @@ err_out:
 		size_t bytes;

 		bytes = sg->length + sg->offset;
-		order = get_order(bytes);

 		/* ignore failures.. we're already handling one */
-		iommu_unmap(domain, da, order);
+		iommu_unmap(domain, da, bytes);

 		da += bytes;
 	}
@@ -466,7 +462,8 @@ static void unmap_iovm_area(struct iommu_domain
*domain, struct omap_iommu *obj,
 	size_t total = area->da_end - area->da_start;
 	const struct sg_table *sgt = area->sgt;
 	struct scatterlist *sg;
-	int i, err;
+	int i;
+	size_t unmapped;

 	BUG_ON(!sgtable_ok(sgt));
 	BUG_ON((!total) || !IS_ALIGNED(total, PAGE_SIZE));
@@ -474,13 +471,11 @@ static void unmap_iovm_area(struct iommu_domain
*domain, struct omap_iommu *obj,
 	start = area->da_start;
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
 		size_t bytes;
-		int order;

 		bytes = sg->length + sg->offset;
-		order = get_order(bytes);

-		err = iommu_unmap(domain, start, order);
-		if (err < 0)
+		unmapped = iommu_unmap(domain, start, bytes);
+		if (unmapped < bytes)
 			break;

 		dev_dbg(obj->dev, "%s: unmap %08x(%x) %08x\n",
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6b6ed21..76d7ce4 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -48,6 +48,22 @@ struct iommu_domain {

 #ifdef CONFIG_IOMMU_API

+/**
+ * struct iommu_ops - iommu ops and capabilities
+ * @domain_init: init iommu domain
+ * @domain_destroy: destroy iommu domain
+ * @attach_dev: attach device to an iommu domain
+ * @detach_dev: detach device from an iommu domain
+ * @map: map a physically contiguous memory region to an iommu domain
+ * @unmap: unmap a physically contiguous memory region from an iommu domain
+ * @iova_to_phys: translate iova to physical address
+ * @domain_has_cap: domain capabilities query
+ * @commit: commit iommu domain
+ * @pgsize_bitmap: bitmap of supported page sizes
+ * @min_pagesz: smallest page size supported. note: this member is private
+ *		to the IOMMU core, and maintained only for efficiency sake;
+ *		drivers don't need to set it.
+ */
 struct iommu_ops {
 	int (*domain_init)(struct iommu_domain *domain);
 	void (*domain_destroy)(struct iommu_domain *domain);
@@ -62,6 +78,8 @@ struct iommu_ops {
 	int (*domain_has_cap)(struct iommu_domain *domain,
 			      unsigned long cap);
 	void (*commit)(struct iommu_domain *domain);
+	unsigned long pgsize_bitmap;
+	unsigned int min_pagesz;
 };

 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
@@ -73,9 +91,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
-		     phys_addr_t paddr, int gfp_order, int prot);
-extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
-		       int gfp_order);
+		     phys_addr_t paddr, size_t size, int prot);
+extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+		       size_t size);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index ca409be..35ed096 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -111,7 +111,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct
kvm_memory_slot *slot)

 		/* Map into IO address space */
 		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
-			      get_order(page_size), flags);
+			      page_size, flags);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%llx\n", pfn);
@@ -292,15 +292,15 @@ static void kvm_iommu_put_pages(struct kvm *kvm,

 	while (gfn < end_gfn) {
 		unsigned long unmap_pages;
-		int order;
+		size_t size;

 		/* Get physical address */
 		phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
 		pfn  = phys >> PAGE_SHIFT;

 		/* Unmap address from IO address space */
-		order       = iommu_unmap(domain, gfn_to_gpa(gfn), 0);
-		unmap_pages = 1ULL << order;
+		size       = iommu_unmap(domain, gfn_to_gpa(gfn), PAGE_SIZE);
+		unmap_pages = 1ULL << get_order(size);

 		/* Unpin all pages we just unmapped to not leak any memory */
 		kvm_unpin_pages(kvm, pfn, unmap_pages);
-- 
1.7.4.1
