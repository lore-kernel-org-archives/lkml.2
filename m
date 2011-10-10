Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1JJWtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:49:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63253 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1JJWtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:49:53 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.27.118]
In-Reply-To: <20111010153609.GB2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com> <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com> <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com> <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com> <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 11 Oct 2011 00:49:32 +0200
Message-ID: <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
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

Hi Joerg,

On Mon, Oct 10, 2011 at 5:36 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> The master branch is best to base your patches on for generic work.

Done. I've revised the patches and attached the main one
below; please tell me if it looks ok, and then I'll resubmit the
entire patch set.

Thanks,
Ohad.

commit bf1d730b5f4f7631becfcd4be52693d85bfea36b
Author: Ohad Ben-Cohen <ohad@wizery.com>
Date:   Mon Oct 10 23:50:55 2011 +0200

    iommu/core: split mapping to page sizes as supported by the hardware

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
    the IOMMU drivers in subsequent patches, and after all the drivers
    are converted, register_iommu will be changed (and the temporary
    default settings will be removed).

    Mainline users of the IOMMU API (kvm and omap-iovmm) are adopted
    to send the mapping size in bytes instead of in page order.

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

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 73778b7..909b0d2 100644
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
@@ -157,33 +172,117 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);

 int iommu_map(struct iommu_domain *domain, unsigned long iova,
-	      phys_addr_t paddr, int gfp_order, int prot)
+	      phys_addr_t paddr, int size, int prot)
 {
-	size_t size;
+	unsigned long orig_iova = iova;
+	int ret = 0, orig_size = size;

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
+
+		/* throw away page sizes not supported by the hardware */
+		pgsize &= domain->ops->pgsize_bitmap;
+
+		/* make sure we're still sane */
+		BUG_ON(!pgsize);

-	BUG_ON(!IS_ALIGNED(iova | paddr, size));
+		/* pick the biggest page */
+		pgsize_idx = __fls(pgsize);
+		pgsize = 1UL << pgsize_idx;

-	return domain->ops->map(domain, iova, paddr, gfp_order, prot);
+		/* convert index to page order */
+		pgsize_idx -= PAGE_SHIFT;
+
+		pr_debug("mapping: iova 0x%lx pa 0x%lx order %u\n", iova,
+					(unsigned long)paddr, pgsize_idx);
+
+		ret = domain->ops->map(domain, iova, paddr, pgsize_idx, prot);
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
+		iommu_unmap(domain, orig_iova, orig_size);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_map);

-int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
+int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int size)
 {
-	size_t size;
+	int order, unmapped_size, unmapped_order, total_unmapped = 0;

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
+	while (size > total_unmapped) {
+		order = get_order(size - total_unmapped);
+
+		unmapped_order = domain->ops->unmap(domain, iova, order);
+		if (unmapped_order < 0)
+			break;
+
+		pr_debug("unmapped: iova 0x%lx order %d\n", iova,
+							unmapped_order);
+
+		unmapped_size = 0x1000UL << unmapped_order;

-	BUG_ON(!IS_ALIGNED(iova, size));
+		iova += unmapped_size;
+		total_unmapped += unmapped_size;
+	}

-	return domain->ops->unmap(domain, iova, gfp_order);
+	return total_unmapped;
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);

diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index e8fdb88..4a8f761 100644
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
@@ -474,13 +470,11 @@ static void unmap_iovm_area(struct iommu_domain
*domain, struct omap_iommu *obj,
 	start = area->da_start;
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
 		size_t bytes;
-		int order;

 		bytes = sg->length + sg->offset;
-		order = get_order(bytes);

-		err = iommu_unmap(domain, start, order);
-		if (err < 0)
+		err = iommu_unmap(domain, start, bytes);
+		if (err < bytes)
 			break;

 		dev_dbg(obj->dev, "%s: unmap %08x(%x) %08x\n",
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 710291f..a10a86c 100644
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
+		     phys_addr_t paddr, int size, int prot);
 extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
-		       int gfp_order);
+		       int size);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index ca409be..26b3199 100644
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
+		int size;

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
