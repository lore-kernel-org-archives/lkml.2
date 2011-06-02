Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab1FBWch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:32:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51772 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1FBWbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:31:05 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <laurent.pinchart@ideasonboard.com>, <Hiroshi.DOYU@nokia.com>,
        <arnd@arndb.de>, <davidb@codeaurora.org>, <Joerg.Roedel@amd.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC 2/6] omap: iovmm: generic iommu api migration
Date: Fri,  3 Jun 2011 01:27:39 +0300
Message-Id: <1307053663-24572-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307053663-24572-1-git-send-email-ohad@wizery.com>
References: <1307053663-24572-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate omap's iovmm (virtual memory manager) to the generic iommu api.

This brings iovmm a step forward towards being completely non
omap-specific (it's still assuming omap's iommu page sizes, and also
maintaining state inside omap's internal iommu structure, but it no
longer calls omap-specific iommu map/unmap api).

Further generalizing of iovmm (or complete removal) should take place
together with broader plans of providing a generic virtual memory manager
and allocation framework (de-coupled from specific mappers).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/plat-omap/include/plat/iovmm.h |   27 +++++---
 arch/arm/plat-omap/iovmm.c              |  111 ++++++++++++++++++-------------
 2 files changed, 82 insertions(+), 56 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/iovmm.h b/arch/arm/plat-omap/include/plat/iovmm.h
index 32a2f6c..56ee2b9 100644
--- a/arch/arm/plat-omap/include/plat/iovmm.h
+++ b/arch/arm/plat-omap/include/plat/iovmm.h
@@ -13,6 +13,8 @@
 #ifndef __IOMMU_MMAP_H
 #define __IOMMU_MMAP_H
 
+#include <linux/iommu.h>
+
 struct iovm_struct {
 	struct iommu		*iommu;	/* iommu object which this belongs to */
 	u32			da_start; /* area definition */
@@ -74,18 +76,21 @@ struct iovm_struct {
 
 
 extern struct iovm_struct *find_iovm_area(struct iommu *obj, u32 da);
-extern u32 iommu_vmap(struct iommu *obj, u32 da,
+extern u32 iommu_vmap(struct iommu_domain *domain, struct iommu *obj, u32 da,
 			const struct sg_table *sgt, u32 flags);
-extern struct sg_table *iommu_vunmap(struct iommu *obj, u32 da);
-extern u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes,
-			   u32 flags);
-extern void iommu_vfree(struct iommu *obj, const u32 da);
-extern u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
-			u32 flags);
-extern void iommu_kunmap(struct iommu *obj, u32 da);
-extern u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes,
-			   u32 flags);
-extern void iommu_kfree(struct iommu *obj, u32 da);
+extern struct sg_table *iommu_vunmap(struct iommu_domain *domain,
+				struct iommu *obj, u32 da);
+extern u32 iommu_vmalloc(struct iommu_domain *domain, struct iommu *obj,
+				u32 da, size_t bytes, u32 flags);
+extern void iommu_vfree(struct iommu_domain *domain, struct iommu *obj,
+				const u32 da);
+extern u32 iommu_kmap(struct iommu_domain *domain, struct iommu *obj, u32 da,
+				u32 pa, size_t bytes, u32 flags);
+extern void iommu_kunmap(struct iommu_domain *domain, struct iommu *obj,
+				u32 da);
+extern u32 iommu_kmalloc(struct iommu_domain *domain, struct iommu *obj,
+				u32 da, size_t bytes, u32 flags);
+extern void iommu_kfree(struct iommu_domain *domain, struct iommu *obj, u32 da);
 
 extern void *da_to_va(struct iommu *obj, u32 da);
 
diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 51ef43e..80bb2b6 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -15,6 +15,7 @@
 #include <linux/vmalloc.h>
 #include <linux/device.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu.h>
 
 #include <asm/cacheflush.h>
 #include <asm/mach/map.h>
@@ -456,15 +457,16 @@ static inline void sgtable_drain_kmalloc(struct sg_table *sgt)
 }
 
 /* create 'da' <-> 'pa' mapping from 'sgt' */
-static int map_iovm_area(struct iommu *obj, struct iovm_struct *new,
-			 const struct sg_table *sgt, u32 flags)
+static int map_iovm_area(struct iommu_domain *domain, struct iovm_struct *new,
+			const struct sg_table *sgt, u32 flags)
 {
 	int err;
 	unsigned int i, j;
 	struct scatterlist *sg;
 	u32 da = new->da_start;
+	int order;
 
-	if (!obj || !sgt)
+	if (!domain || !sgt)
 		return -EINVAL;
 
 	BUG_ON(!sgtable_ok(sgt));
@@ -473,22 +475,22 @@ static int map_iovm_area(struct iommu *obj, struct iovm_struct *new,
 		u32 pa;
 		int pgsz;
 		size_t bytes;
-		struct iotlb_entry e;
 
 		pa = sg_phys(sg);
 		bytes = sg_dma_len(sg);
 
 		flags &= ~IOVMF_PGSZ_MASK;
+
 		pgsz = bytes_to_iopgsz(bytes);
 		if (pgsz < 0)
 			goto err_out;
-		flags |= pgsz;
+
+		order = get_order(bytes);
 
 		pr_debug("%s: [%d] %08x %08x(%x)\n", __func__,
 			 i, da, pa, bytes);
 
-		iotlb_init_entry(&e, da, pa, flags);
-		err = iopgtable_store_entry(obj, &e);
+		err = iommu_map(domain, da, pa, order, flags);
 		if (err)
 			goto err_out;
 
@@ -502,9 +504,11 @@ err_out:
 	for_each_sg(sgt->sgl, sg, i, j) {
 		size_t bytes;
 
-		bytes = iopgtable_clear_entry(obj, da);
+		bytes = sg_dma_len(sg);
+		order = get_order(bytes);
 
-		BUG_ON(!iopgsz_ok(bytes));
+		/* ignore failures.. we're already handling one */
+		iommu_unmap(domain, da, order);
 
 		da += bytes;
 	}
@@ -512,22 +516,31 @@ err_out:
 }
 
 /* release 'da' <-> 'pa' mapping */
-static void unmap_iovm_area(struct iommu *obj, struct iovm_struct *area)
+static void unmap_iovm_area(struct iommu_domain *domain, struct iommu *obj,
+						struct iovm_struct *area)
 {
 	u32 start;
 	size_t total = area->da_end - area->da_start;
+	const struct sg_table *sgt = area->sgt;
+	struct scatterlist *sg;
+	int i, err;
 
+	BUG_ON(!sgtable_ok(sgt));
 	BUG_ON((!total) || !IS_ALIGNED(total, PAGE_SIZE));
 
 	start = area->da_start;
-	while (total > 0) {
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
 		size_t bytes;
+		int order;
+
+		bytes = sg_dma_len(sg);
+		order = get_order(bytes);
+
+		err = iommu_unmap(domain, start, order);
+		if (err)
+			break;
 
-		bytes = iopgtable_clear_entry(obj, start);
-		if (bytes == 0)
-			bytes = PAGE_SIZE;
-		else
-			dev_dbg(obj->dev, "%s: unmap %08x(%x) %08x\n",
+		dev_dbg(obj->dev, "%s: unmap %08x(%x) %08x\n",
 				__func__, start, bytes, area->flags);
 
 		BUG_ON(!IS_ALIGNED(bytes, PAGE_SIZE));
@@ -539,7 +552,8 @@ static void unmap_iovm_area(struct iommu *obj, struct iovm_struct *area)
 }
 
 /* template function for all unmapping */
-static struct sg_table *unmap_vm_area(struct iommu *obj, const u32 da,
+static struct sg_table *unmap_vm_area(struct iommu_domain *domain,
+				      struct iommu *obj, const u32 da,
 				      void (*fn)(const void *), u32 flags)
 {
 	struct sg_table *sgt = NULL;
@@ -565,7 +579,7 @@ static struct sg_table *unmap_vm_area(struct iommu *obj, const u32 da,
 	}
 	sgt = (struct sg_table *)area->sgt;
 
-	unmap_iovm_area(obj, area);
+	unmap_iovm_area(domain, obj, area);
 
 	fn(area->va);
 
@@ -580,8 +594,9 @@ out:
 	return sgt;
 }
 
-static u32 map_iommu_region(struct iommu *obj, u32 da,
-	      const struct sg_table *sgt, void *va, size_t bytes, u32 flags)
+static u32 map_iommu_region(struct iommu_domain *domain, struct iommu *obj,
+				u32 da, const struct sg_table *sgt, void *va,
+				size_t bytes, u32 flags)
 {
 	int err = -ENOMEM;
 	struct iovm_struct *new;
@@ -596,7 +611,7 @@ static u32 map_iommu_region(struct iommu *obj, u32 da,
 	new->va = va;
 	new->sgt = sgt;
 
-	if (map_iovm_area(obj, new, sgt, new->flags))
+	if (map_iovm_area(domain, new, sgt, new->flags))
 		goto err_map;
 
 	mutex_unlock(&obj->mmap_lock);
@@ -613,10 +628,11 @@ err_alloc_iovma:
 	return err;
 }
 
-static inline u32 __iommu_vmap(struct iommu *obj, u32 da,
-		 const struct sg_table *sgt, void *va, size_t bytes, u32 flags)
+static inline u32 __iommu_vmap(struct iommu_domain *domain, struct iommu *obj,
+				u32 da, const struct sg_table *sgt,
+				void *va, size_t bytes, u32 flags)
 {
-	return map_iommu_region(obj, da, sgt, va, bytes, flags);
+	return map_iommu_region(domain, obj, da, sgt, va, bytes, flags);
 }
 
 /**
@@ -628,8 +644,8 @@ static inline u32 __iommu_vmap(struct iommu *obj, u32 da,
  * Creates 1-n-1 mapping with given @sgt and returns @da.
  * All @sgt element must be io page size aligned.
  */
-u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
-		 u32 flags)
+u32 iommu_vmap(struct iommu_domain *domain, struct iommu *obj, u32 da,
+		const struct sg_table *sgt, u32 flags)
 {
 	size_t bytes;
 	void *va = NULL;
@@ -652,7 +668,7 @@ u32 iommu_vmap(struct iommu *obj, u32 da, const struct sg_table *sgt,
 	flags |= IOVMF_DISCONT;
 	flags |= IOVMF_MMIO;
 
-	da = __iommu_vmap(obj, da, sgt, va, bytes, flags);
+	da = __iommu_vmap(domain, obj, da, sgt, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
 		vunmap_sg(va);
 
@@ -668,14 +684,16 @@ EXPORT_SYMBOL_GPL(iommu_vmap);
  * Free the iommu virtually contiguous memory area starting at
  * @da, which was returned by 'iommu_vmap()'.
  */
-struct sg_table *iommu_vunmap(struct iommu *obj, u32 da)
+struct sg_table *
+iommu_vunmap(struct iommu_domain *domain, struct iommu *obj, u32 da)
 {
 	struct sg_table *sgt;
 	/*
 	 * 'sgt' is allocated before 'iommu_vmalloc()' is called.
 	 * Just returns 'sgt' to the caller to free
 	 */
-	sgt = unmap_vm_area(obj, da, vunmap_sg, IOVMF_DISCONT | IOVMF_MMIO);
+	sgt = unmap_vm_area(domain, obj, da, vunmap_sg,
+					IOVMF_DISCONT | IOVMF_MMIO);
 	if (!sgt)
 		dev_dbg(obj->dev, "%s: No sgt\n", __func__);
 	return sgt;
@@ -692,7 +710,8 @@ EXPORT_SYMBOL_GPL(iommu_vunmap);
  * Allocate @bytes linearly and creates 1-n-1 mapping and returns
  * @da again, which might be adjusted if 'IOVMF_DA_FIXED' is not set.
  */
-u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
+u32 iommu_vmalloc(struct iommu_domain *domain, struct iommu *obj, u32 da,
+						size_t bytes, u32 flags)
 {
 	void *va;
 	struct sg_table *sgt;
@@ -717,7 +736,7 @@ u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 	}
 	sgtable_fill_vmalloc(sgt, va);
 
-	da = __iommu_vmap(obj, da, sgt, va, bytes, flags);
+	da = __iommu_vmap(domain, obj, da, sgt, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
 		goto err_iommu_vmap;
 
@@ -740,19 +759,20 @@ EXPORT_SYMBOL_GPL(iommu_vmalloc);
  * Frees the iommu virtually continuous memory area starting at
  * @da, as obtained from 'iommu_vmalloc()'.
  */
-void iommu_vfree(struct iommu *obj, const u32 da)
+void iommu_vfree(struct iommu_domain *domain, struct iommu *obj, const u32 da)
 {
 	struct sg_table *sgt;
 
-	sgt = unmap_vm_area(obj, da, vfree, IOVMF_DISCONT | IOVMF_ALLOC);
+	sgt = unmap_vm_area(domain, obj, da, vfree,
+						IOVMF_DISCONT | IOVMF_ALLOC);
 	if (!sgt)
 		dev_dbg(obj->dev, "%s: No sgt\n", __func__);
 	sgtable_free(sgt);
 }
 EXPORT_SYMBOL_GPL(iommu_vfree);
 
-static u32 __iommu_kmap(struct iommu *obj, u32 da, u32 pa, void *va,
-			  size_t bytes, u32 flags)
+static u32 __iommu_kmap(struct iommu_domain *domain, struct iommu *obj,
+			u32 da, u32 pa, void *va, size_t bytes, u32 flags)
 {
 	struct sg_table *sgt;
 
@@ -762,7 +782,7 @@ static u32 __iommu_kmap(struct iommu *obj, u32 da, u32 pa, void *va,
 
 	sgtable_fill_kmalloc(sgt, pa, da, bytes);
 
-	da = map_iommu_region(obj, da, sgt, va, bytes, flags);
+	da = map_iommu_region(domain, obj, da, sgt, va, bytes, flags);
 	if (IS_ERR_VALUE(da)) {
 		sgtable_drain_kmalloc(sgt);
 		sgtable_free(sgt);
@@ -781,8 +801,8 @@ static u32 __iommu_kmap(struct iommu *obj, u32 da, u32 pa, void *va,
  * Creates 1-1-1 mapping and returns @da again, which can be
  * adjusted if 'IOVMF_DA_FIXED' is not set.
  */
-u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
-		 u32 flags)
+u32 iommu_kmap(struct iommu_domain *domain, struct iommu *obj, u32 da, u32 pa,
+						size_t bytes, u32 flags)
 {
 	void *va;
 
@@ -799,7 +819,7 @@ u32 iommu_kmap(struct iommu *obj, u32 da, u32 pa, size_t bytes,
 	flags |= IOVMF_LINEAR;
 	flags |= IOVMF_MMIO;
 
-	da = __iommu_kmap(obj, da, pa, va, bytes, flags);
+	da = __iommu_kmap(domain, obj, da, pa, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
 		iounmap(va);
 
@@ -815,12 +835,12 @@ EXPORT_SYMBOL_GPL(iommu_kmap);
  * Frees the iommu virtually contiguous memory area starting at
  * @da, which was passed to and was returned by'iommu_kmap()'.
  */
-void iommu_kunmap(struct iommu *obj, u32 da)
+void iommu_kunmap(struct iommu_domain *domain, struct iommu *obj, u32 da)
 {
 	struct sg_table *sgt;
 	typedef void (*func_t)(const void *);
 
-	sgt = unmap_vm_area(obj, da, (func_t)iounmap,
+	sgt = unmap_vm_area(domain, obj, da, (func_t)iounmap,
 			    IOVMF_LINEAR | IOVMF_MMIO);
 	if (!sgt)
 		dev_dbg(obj->dev, "%s: No sgt\n", __func__);
@@ -838,7 +858,8 @@ EXPORT_SYMBOL_GPL(iommu_kunmap);
  * Allocate @bytes linearly and creates 1-1-1 mapping and returns
  * @da again, which might be adjusted if 'IOVMF_DA_FIXED' is not set.
  */
-u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
+u32 iommu_kmalloc(struct iommu_domain *domain, struct iommu *obj, u32 da,
+						size_t bytes, u32 flags)
 {
 	void *va;
 	u32 pa;
@@ -857,7 +878,7 @@ u32 iommu_kmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 	flags |= IOVMF_LINEAR;
 	flags |= IOVMF_ALLOC;
 
-	da = __iommu_kmap(obj, da, pa, va, bytes, flags);
+	da = __iommu_kmap(domain, obj, da, pa, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
 		kfree(va);
 
@@ -873,11 +894,11 @@ EXPORT_SYMBOL_GPL(iommu_kmalloc);
  * Frees the iommu virtually contiguous memory area starting at
  * @da, which was passed to and was returned by'iommu_kmalloc()'.
  */
-void iommu_kfree(struct iommu *obj, u32 da)
+void iommu_kfree(struct iommu_domain *domain, struct iommu *obj, u32 da)
 {
 	struct sg_table *sgt;
 
-	sgt = unmap_vm_area(obj, da, kfree, IOVMF_LINEAR | IOVMF_ALLOC);
+	sgt = unmap_vm_area(domain, obj, da, kfree, IOVMF_LINEAR | IOVMF_ALLOC);
 	if (!sgt)
 		dev_dbg(obj->dev, "%s: No sgt\n", __func__);
 	sgtable_free(sgt);
-- 
1.7.1

