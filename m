Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1JBP6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 11:58:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52540 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab1JBP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 11:58:34 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.135.251]
In-Reply-To: <20110927181438.GM2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com> <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com> <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 2 Oct 2011 17:58:12 +0200
Message-ID: <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the late response; we had a big holiday here and I was
forced away from my keyboard :)

On Tue, Sep 27, 2011 at 9:14 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> No. I suggest a simpler and shorter algorithm using the bit helpers.

Ok, fair enough. I've revised the patches and attached the main one
below; please tell me if it looks ok, and then I'll resubmit the
entire patch set.

The main changes I've done from your pseudo-code are:

1. removed the internal while loop, and used several bits
manipulations to replace it
2. removed the call to get_order(), and instead used the bytes order
we already have to deduct it
3. considered iova alignment requirements too
4. removed the BUG_ON()s, since we're checking for minimal
size/alignment conditions in the beginning of the map function

> And yes, overhead is important when we implement the generic dma-ops
> on-top of the iommu-api because this will make the iommu_map function a
> fast-path. So we really care about overhead here.

Don't get me wrong; I don't underestimate the importance of performance here.

I just think that as long as some code is reasonably efficient and not
badly designed (so it's not too hard to optimize later if needed),
then it's usually better to postpone optimizations until we benchmark
and know for certain that the effort in squeezing away several cpu
cycles is noticeable.

In this case, I'm not entirely convinced that it is, because every map
call anyway ends up flushing the caches, which might take hundreds of
cpu cycles. In addition, at least the ARM version of find_next_bit
doesn't look terribly bad.

YMMV though: I didn't find an optimized assembly implementation of
find_next_bit for x86, and the generic one does look complex. In
addition, the variable page size behavior of the x86 iommu drivers may
have caused much more iterations than any of the ARM drivers would
have had, so the penalty of running that generic find_next_bit
repeatedly could have accumulated into something noticeable.

Anyway, here comes the revised patch.

Thanks for your review!
Ohad.

>From 042690394b1a121202e0eeeb47d267b1a8d65132 Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 31 Aug 2011 16:46:47 +0300
Subject: [PATCH 2/7] iommu/core: split mapping to page sizes as
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
 drivers/iommu/iommu.c      |  138 ++++++++++++++++++++++++++++++++++++++++---
 drivers/iommu/omap-iovmm.c |   12 +---
 include/linux/iommu.h      |    6 +-
 virt/kvm/iommu.c           |    4 +-
 4 files changed, 137 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index a7b0862..f23563f 100644
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
@@ -23,15 +25,54 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/iommu.h>
+#include <linux/bitmap.h>

 static struct iommu_ops *iommu_ops;

+/* bitmap of supported page sizes */
+static unsigned long iommu_pgsize_bitmap;
+
+/* size of the smallest supported page (in bytes) */
+static unsigned int iommu_min_pagesz;
+
+/**
+ * register_iommu() - register an IOMMU hardware
+ * @ops: iommu handlers
+ * @pgsize_bitmap: bitmap of page sizes supported by the hardware
+ *
+ * Note: this is a temporary function, which will be removed once
+ * all IOMMU drivers are converted. The only reason it exists is to
+ * allow splitting the pgsizes changes to several patches in order to ease
+ * the review.
+ */
+void register_iommu_pgsize(struct iommu_ops *ops, unsigned long pgsize_bitmap)
+{
+	if (iommu_ops || iommu_pgsize_bitmap || !pgsize_bitmap)
+		BUG();
+
+	iommu_ops = ops;
+	iommu_pgsize_bitmap = pgsize_bitmap;
+
+	/* find out the minimum page size only once */
+	iommu_min_pagesz = 1 << __ffs(pgsize_bitmap);
+}
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
+	 * regions that are sized/aligned to order of 4KiB pages
+	 */
+	iommu_pgsize_bitmap = ~0xFFFUL;
+
+	/* find out the minimum page size only once */
+	iommu_min_pagesz = 1 << __ffs(iommu_pgsize_bitmap);
 }

 bool iommu_found(void)
@@ -115,26 +156,103 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
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

-	size         = 0x1000UL << gfp_order;
+	pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
+				(unsigned long)paddr, (unsigned long)size);

-	BUG_ON(!IS_ALIGNED(iova | paddr, size));
+	while (size) {
+		unsigned long pgsize, addr_merge = iova | paddr;
+		unsigned int pgsize_idx;

-	return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
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
+		pgsize &= iommu_pgsize_bitmap;
+
+		/* pick the biggest page */
+		pgsize_idx = __fls(pgsize);
+		pgsize = 1UL << pgsize_idx;
+
+		/* convert index to page order */
+		pgsize_idx -= PAGE_SHIFT;
+
+		pr_debug("mapping: iova 0x%lx pa 0x%lx order %u\n", iova,
+					(unsigned long)paddr, pgsize_idx);
+
+		ret = iommu_ops->map(domain, iova, paddr, pgsize_idx, prot);
+		if (ret)
+			break;
+
+		iova += pgsize;
+		paddr += pgsize;
+		size -= pgsize;
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
@@ -474,12 +470,10 @@ static void unmap_iovm_area(struct iommu_domain
*domain, struct omap_iommu *obj,
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
index 2987199..3b34938 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -61,6 +61,8 @@ struct iommu_ops {
 #ifdef CONFIG_IOMMU_API

 extern void register_iommu(struct iommu_ops *ops);
+extern void register_iommu_pgsize(struct iommu_ops *ops,
+				unsigned long pgsize_bitmap);
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
@@ -111,7 +111,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct
kvm_memory_slot *slot)

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
