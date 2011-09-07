Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab1IGSzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:55:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50370 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IGSzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:55:37 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>, kvm@vger.kernel.org
Subject: [PATCH 3/3] iommu/core: split mapping to page sizes as supported by the hardware
Date: Wed,  7 Sep 2011 21:53:24 +0300
Message-Id: <1315421604-12286-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315421604-12286-1-git-send-email-ohad@wizery.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
remain static. That works well for OMAP (and seemingly MSM too) but
it might not fly with intel's hardware, where the page size
capabilities seem to have the potential to be different between
several DMA remapping devices.

To simplify the migration, this patch retains the existing behavior
for the x86 IOMMU drivers, by having them advertise support for
all page sizes that are an order of 4KB.

OMAP and MSM iommu drivers are migrated to advertise support
for 4KB, 64KB, 1MB and 16MB (as supported by their hardware).

Mainline users of the IOMMU API (kvm and omap-iovmm) are adopted
to send the mapping size in bytes instead of in page order.

Tested with OMAP3 and OMAP4. Compile tested on X86-64.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kvm@vger.kernel.org
---
 drivers/iommu/amd_iommu.c   |   20 ++++++-
 drivers/iommu/intel-iommu.c |   20 ++++++-
 drivers/iommu/iommu.c       |  129 +++++++++++++++++++++++++++++++++++++++----
 drivers/iommu/msm_iommu.c   |    8 ++-
 drivers/iommu/omap-iommu.c  |    6 ++-
 drivers/iommu/omap-iovmm.c  |   12 +---
 include/linux/iommu.h       |    7 +-
 virt/kvm/iommu.c            |    4 +-
 8 files changed, 176 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a14f8dc..5cdfa91 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2488,12 +2488,30 @@ static unsigned device_dma_ops_init(void)
 }
 
 /*
+ * This bitmap is used to advertise the page sizes our hardware support
+ * to the IOMMU core, which will then use this information to split
+ * physically contiguous memory regions it is mapping into page sizes
+ * that we support.
+ *
+ * Traditionally the IOMMU core just handed us the mappings directly,
+ * after making sure the size is an order of a 4KB page and that the
+ * mapping has natural alignment.
+ *
+ * To retain this behavior, we currently advertise that we support
+ * all page sizes that are an order of 4KB.
+ *
+ * If at some point we'd like to utilize the IOMMU core's new behavior,
+ * we could change this to advertise the real page sizes we support.
+ */
+static unsigned long amd_iommu_pgsizes = ~0xFFFUL;
+
+/*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
 
 void __init amd_iommu_init_api(void)
 {
-	register_iommu(&amd_iommu_ops);
+	register_iommu(&amd_iommu_ops, &amd_iommu_pgsizes, BITS_PER_LONG);
 }
 
 int __init amd_iommu_init_dma_ops(void)
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c621c98..a8c91a6 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3426,6 +3426,24 @@ static struct notifier_block device_nb = {
 	.notifier_call = device_notifier,
 };
 
+/*
+ * This bitmap is used to advertise the page sizes our hardware support
+ * to the IOMMU core, which will then use this information to split
+ * physically contiguous memory regions it is mapping into page sizes
+ * that we support.
+ *
+ * Traditionally the IOMMU core just handed us the mappings directly,
+ * after making sure the size is an order of a 4KB page and that the
+ * mapping has natural alignment.
+ *
+ * To retain this behavior, we currently advertise that we support
+ * all page sizes that are an order of 4KB.
+ *
+ * If at some point we'd like to utilize the IOMMU core's new behavior,
+ * we could change this to advertise the real page sizes we support.
+ */
+static unsigned long intel_iommu_pgsizes = ~0xFFFUL;
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
@@ -3486,7 +3504,7 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
-	register_iommu(&intel_iommu_ops);
+	register_iommu(&intel_iommu_ops, &intel_iommu_pgsizes, BITS_PER_LONG);
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c68ff29..e07ea03 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -16,6 +16,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#define pr_fmt(fmt)    "%s: " fmt, __func__
+
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/types.h>
@@ -23,15 +25,41 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
+#include <linux/bitmap.h>
 
 static struct iommu_ops *iommu_ops;
 
-void register_iommu(struct iommu_ops *ops)
+/* bitmap of supported page sizes */
+static unsigned long *iommu_pgsize_bitmap;
+
+/* number of bits used to represent the supported pages */
+static unsigned int iommu_nr_page_bits;
+
+/* size of the smallest supported page (in bytes) */
+static unsigned int iommu_min_pagesz;
+
+/* bit number of the smallest supported page */
+static unsigned int iommu_min_page_idx;
+
+/**
+ * register_iommu() - register an IOMMU hardware
+ * @ops: iommu handlers
+ * @pgsize_bitmap: bitmap of page sizes supported by the hardware
+ * @nr_page_bits: size of @pgsize_bitmap (in bits)
+ */
+void register_iommu(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
+					unsigned int nr_page_bits)
 {
-	if (iommu_ops)
+	if (iommu_ops || iommu_pgsize_bitmap || !nr_page_bits)
 		BUG();
 
 	iommu_ops = ops;
+	iommu_pgsize_bitmap = pgsize_bitmap;
+	iommu_nr_page_bits = nr_page_bits;
+
+	/* find the minimum page size and its index only once */
+	iommu_min_page_idx = find_first_bit(pgsize_bitmap, nr_page_bits);
+	iommu_min_pagesz = 1 << iommu_min_page_idx;
 }
 
 bool iommu_found(void)
@@ -109,26 +137,103 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
 
 int iommu_map(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, int gfp_order, int prot)
+	      phys_addr_t paddr, size_t size, int prot)
 {
-	size_t size;
+	int ret = 0;
+
+	/*
+	 * both the virtual address and the physical one, as well as
+	 * the size of the mapping, must be aligned (at least) to the
+	 * size of the smallest page supported by the hardware
+	 */
+	if (!IS_ALIGNED(iova | paddr | size, iommu_min_pagesz)) {
+		pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%lx min_pagesz "
+			"0x%x\n", iova, (unsigned long)paddr, size,
+			iommu_min_pagesz);
+		return -EINVAL;
+	}
+
+	pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
+					(unsigned long)paddr, size);
+
+	while (size) {
+		unsigned long pgsize = iommu_min_pagesz;
+		unsigned long idx = iommu_min_page_idx;
+		unsigned long addr_merge = iova | paddr;
+		int order;
+
+		/* find the max page size with which iova, paddr are aligned */
+		for (;;) {
+			unsigned long try_pgsize;
 
-	size         = 0x1000UL << gfp_order;
+			idx = find_next_bit(iommu_pgsize_bitmap,
+						iommu_nr_page_bits, idx + 1);
 
-	BUG_ON(!IS_ALIGNED(iova | paddr, size));
+			/* no more pages to check ? */
+			if (idx >= iommu_nr_page_bits)
+				break;
 
-	return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
+			try_pgsize = 1 << idx;
+
+			/* page too big ? addresses not aligned ? */
+			if (size < try_pgsize ||
+					!IS_ALIGNED(addr_merge, try_pgsize))
+				break;
+
+			pgsize = try_pgsize;
+		}
+
+		order = get_order(pgsize);
+
+		pr_debug("mapping: iova 0x%lx pa 0x%lx order %d\n", iova,
+					(unsigned long)paddr, order);
+
+		ret = iommu_ops->map(domain, iova, paddr, order, prot);
+		if (ret)
+			break;
+
+		size -= pgsize;
+		iova += pgsize;
+		paddr += pgsize;
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
-int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
+int iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 {
-	size_t size;
+	int order, unmapped_size, unmapped_order, total_unmapped = 0;
+
+	/*
+	 * The virtual address, as well as the size of the mapping, must be
+	 * aligned (at least) to the size of the smallest page supported
+	 * by the hardware
+	 */
+	if (!IS_ALIGNED(iova | size, iommu_min_pagesz)) {
+		pr_err("unaligned: iova 0x%lx size 0x%lx min_pagesz 0x%x\n",
+				iova, size, iommu_min_pagesz);
+		return -EINVAL;
+	}
+
+	pr_debug("unmap this: iova 0x%lx size 0x%lx\n", iova, size);
+
+	while (size > total_unmapped) {
+		order = get_order(size - total_unmapped);
+
+		unmapped_order = iommu_ops->unmap(domain, iova, order);
+		if (unmapped_order < 0)
+			return unmapped_order;
+
+		pr_debug("unmapped: iova 0x%lx order %d\n", iova,
+							unmapped_order);
 
-	size         = 0x1000UL << gfp_order;
+		unmapped_size = 0x1000UL << unmapped_order;
 
-	BUG_ON(!IS_ALIGNED(iova, size));
+		iova += unmapped_size;
+		total_unmapped += unmapped_size;
+	}
 
-	return iommu_ops->unmap(domain, iova, gfp_order);
+	return get_order(total_unmapped);
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index d1733f6..e59ced9 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -676,6 +676,9 @@ fail:
 	return 0;
 }
 
+/* bitmap of the page sizes currently supported */
+static unsigned long msm_iommu_pgsizes = SZ_4K | SZ_64K | SZ_1M | SZ_16M;
+
 static struct iommu_ops msm_iommu_ops = {
 	.domain_init = msm_iommu_domain_init,
 	.domain_destroy = msm_iommu_domain_destroy,
@@ -728,7 +731,10 @@ static void __init setup_iommu_tex_classes(void)
 static int __init msm_iommu_init(void)
 {
 	setup_iommu_tex_classes();
-	register_iommu(&msm_iommu_ops);
+
+	/* we're only using the first 25 bits of the pgsizes bitmap */
+	register_iommu(&msm_iommu_ops, &msm_iommu_pgsizes, 25);
+
 	return 0;
 }
 
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index ef70a08..3e8b815 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1202,6 +1202,9 @@ static int omap_iommu_domain_has_cap(struct iommu_domain *domain,
 	return 0;
 }
 
+/* bitmap of the page sizes supported by the OMAP IOMMU hardware */
+static unsigned long omap_iommu_pgsizes = SZ_4K | SZ_64K | SZ_1M | SZ_16M;
+
 static struct iommu_ops omap_iommu_ops = {
 	.domain_init	= omap_iommu_domain_init,
 	.domain_destroy	= omap_iommu_domain_destroy,
@@ -1225,7 +1228,8 @@ static int __init omap_iommu_init(void)
 		return -ENOMEM;
 	iopte_cachep = p;
 
-	register_iommu(&omap_iommu_ops);
+	/* we're only using the first 25 bits of the pgsizes bitmap */
+	register_iommu(&omap_iommu_ops, &omap_iommu_pgsizes, 25);
 
 	return platform_driver_register(&omap_iommu_driver);
 }
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index e8fdb88..f4dea5a 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -409,7 +409,6 @@ static int map_iovm_area(struct iommu_domain *domain, struct iovm_struct *new,
 	unsigned int i, j;
 	struct scatterlist *sg;
 	u32 da = new->da_start;
-	int order;
 
 	if (!domain || !sgt)
 		return -EINVAL;
@@ -428,12 +427,10 @@ static int map_iovm_area(struct iommu_domain *domain, struct iovm_struct *new,
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
@@ -474,12 +470,10 @@ static void unmap_iovm_area(struct iommu_domain *domain, struct omap_iommu *obj,
 	start = area->da_start;
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
 		size_t bytes;
-		int order;
 
 		bytes = sg->length + sg->offset;
-		order = get_order(bytes);
 
-		err = iommu_unmap(domain, start, order);
+		err = iommu_unmap(domain, start, bytes);
 		if (err < 0)
 			break;
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index d67bf8c..074acbd 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -73,7 +73,8 @@ struct iommu_ops {
 
 #ifdef CONFIG_IOMMU_API
 
-extern void register_iommu(struct iommu_ops *ops);
+extern void register_iommu(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
+					unsigned int nr_page_bits);
 extern bool iommu_found(void);
 extern struct iommu_domain *iommu_domain_alloc(void);
 extern void iommu_domain_free(struct iommu_domain *domain);
@@ -82,9 +83,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
-		     phys_addr_t paddr, int gfp_order, int prot);
+		     phys_addr_t paddr, size_t size, int prot);
 extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
-		       int gfp_order);
+		       size_t size);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 78c80f6..ea142d3 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -111,7 +111,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 
 		/* Map into IO address space */
 		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
-			      get_order(page_size), flags);
+			      page_size, flags);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%llx\n", pfn);
@@ -293,7 +293,7 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 		pfn  = phys >> PAGE_SHIFT;
 
 		/* Unmap address from IO address space */
-		order       = iommu_unmap(domain, gfn_to_gpa(gfn), 0);
+		order       = iommu_unmap(domain, gfn_to_gpa(gfn), PAGE_SIZE);
 		unmap_pages = 1ULL << order;
 
 		/* Unpin all pages we just unmapped to not leak any memory */
-- 
1.7.4.1

