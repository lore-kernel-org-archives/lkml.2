Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab1IMTcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:32:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55279 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1IMTcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:32:04 -0400
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
Subject: [PATCH v2 1/6] iommu/core: split mapping to page sizes as supported by the hardware
Date: Tue, 13 Sep 2011 22:31:23 +0300
Message-Id: <1315942288-17297-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
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
it would probably not fly with intel's hardware, where the page size
capabilities seem to have the potential to be different between
several DMA remapping devices. This limitation can be dealt with
later, if desired. For now, the existing IOMMU API behavior is retained
(see: "iommu/intel: announce supported page sizes").

As requested, register_iommu() isn't changed yet, so we can convert
the IOMMU drivers in subsequent patches, and after all the drivers
are converted, register_iommu will be changed (and the temporary
register_iommu_pgsize() will be removed).

Mainline users of the IOMMU API (kvm and omap-iovmm) are adopted
to send the mapping size in bytes instead of in page order.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kvm@vger.kernel.org
---
v1->v2: keep old code around until all drivers are converted

 drivers/iommu/iommu.c      |  158 +++++++++++++++++++++++++++++++++++++++++---
 drivers/iommu/omap-iovmm.c |   12 +---
 include/linux/iommu.h      |    6 +-
 virt/kvm/iommu.c           |    4 +-
 4 files changed, 157 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c68ff29..c848f14 100644
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
@@ -23,15 +25,73 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
+#include <linux/bitmap.h>
 
 static struct iommu_ops *iommu_ops;
 
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
+ *
+ * Note: this is a temporary function, which will be removed once
+ * all IOMMU drivers are converted. The only reason it exists is to
+ * allow splitting the pgsizes changes to several patches in order to ease
+ * the review.
+ */
+void register_iommu_pgsize(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
+					unsigned int nr_page_bits)
+{
+	if (iommu_ops || iommu_pgsize_bitmap || !nr_page_bits)
+		BUG();
+
+	iommu_ops = ops;
+	iommu_pgsize_bitmap = pgsize_bitmap;
+	iommu_nr_page_bits = nr_page_bits;
+
+	/* find the minimum page size and its index only once */
+	iommu_min_page_idx = find_first_bit(pgsize_bitmap, nr_page_bits);
+	iommu_min_pagesz = 1 << iommu_min_page_idx;
+}
+
+/*
+ * default pagesize bitmap, will be removed once all IOMMU drivers
+ * are converted
+ */
+static unsigned long default_iommu_pgsizes = ~0xFFFUL;
+
 void register_iommu(struct iommu_ops *ops)
 {
 	if (iommu_ops)
 		BUG();
 
 	iommu_ops = ops;
+
+	/*
+	 * set default pgsize values, which retain the existing
+	 * IOMMU API behavior: drivers will be called to map
+	 * regions that are sized/aligned to order of 4KB pages
+	 */
+	iommu_pgsize_bitmap = &default_iommu_pgsizes;
+	iommu_nr_page_bits = BITS_PER_LONG;
+
+	/* find the minimum page size and its index only once */
+	iommu_min_page_idx = find_first_bit(iommu_pgsize_bitmap,
+						iommu_nr_page_bits);
+	iommu_min_pagesz = 1 << iommu_min_page_idx;
 }
 
 bool iommu_found(void)
@@ -109,26 +169,104 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
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
+			"0x%x\n", iova, (unsigned long)paddr,
+			(unsigned long)size, iommu_min_pagesz);
+		return -EINVAL;
+	}
+
+	pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
+				(unsigned long)paddr, (unsigned long)size);
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
+
+			idx = find_next_bit(iommu_pgsize_bitmap,
+						iommu_nr_page_bits, idx + 1);
+
+			/* no more pages to check ? */
+			if (idx >= iommu_nr_page_bits)
+				break;
+
+			try_pgsize = 1 << idx;
 
-	size         = 0x1000UL << gfp_order;
+			/* page too big ? addresses not aligned ? */
+			if (size < try_pgsize ||
+					!IS_ALIGNED(addr_merge, try_pgsize))
+				break;
 
-	BUG_ON(!IS_ALIGNED(iova | paddr, size));
+			pgsize = try_pgsize;
+		}
 
-	return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
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
+				iova, (unsigned long)size, iommu_min_pagesz);
+		return -EINVAL;
+	}
+
+	pr_debug("unmap this: iova 0x%lx size 0x%lx\n", iova,
+							(unsigned long)size);
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
index d084e87..1806956 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -61,6 +61,8 @@ struct iommu_ops {
 #ifdef CONFIG_IOMMU_API
 
 extern void register_iommu(struct iommu_ops *ops);
+extern void register_iommu_pgsize(struct iommu_ops *ops,
+		unsigned long *pgsize_bitmap, unsigned int nr_page_bits);
 extern bool iommu_found(void);
 extern struct iommu_domain *iommu_domain_alloc(void);
 extern void iommu_domain_free(struct iommu_domain *domain);
@@ -69,9 +71,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
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

