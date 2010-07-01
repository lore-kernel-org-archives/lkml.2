Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab0F3XwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:52:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52311 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab0F3Xue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:50:34 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyo@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 8/9] dspbridge: add map support for big buffers
Date: Wed, 30 Jun 2010 19:00:00 -0500
Message-Id: <1277942401-3566-9-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277942401-3566-8-git-send-email-x0095840@ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
 <1277942401-3566-4-git-send-email-x0095840@ti.com>
 <1277942401-3566-5-git-send-email-x0095840@ti.com>
 <1277942401-3566-6-git-send-email-x0095840@ti.com>
 <1277942401-3566-7-git-send-email-x0095840@ti.com>
 <1277942401-3566-8-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

due to a restriction in scatter gather lists, it can
not be created a list for a buffer bigger than 1MB.
This patch is spliting big mappings into 1MB mappings.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/include/dspbridge/dsp-mmu.h |    2 +-
 drivers/dsp/bridge/core/dsp-mmu.c              |   55 ++++++++++++++---------
 drivers/dsp/bridge/rmgr/proc.c                 |    3 +-
 3 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/arch/arm/plat-omap/include/dspbridge/dsp-mmu.h b/arch/arm/plat-omap/include/dspbridge/dsp-mmu.h
index 266f38b..2e4bf6a 100644
--- a/arch/arm/plat-omap/include/dspbridge/dsp-mmu.h
+++ b/arch/arm/plat-omap/include/dspbridge/dsp-mmu.h
@@ -85,6 +85,6 @@ int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
  * This function unmaps a user space buffer into DSP virtual address.
  *
  */
-int user_to_dsp_unmap(struct iommu *mmu, u32 da);
+int user_to_dsp_unmap(struct iommu *mmu, u32 da, unsigned size);
 
 #endif
diff --git a/drivers/dsp/bridge/core/dsp-mmu.c b/drivers/dsp/bridge/core/dsp-mmu.c
index e8da327..9a46206 100644
--- a/drivers/dsp/bridge/core/dsp-mmu.c
+++ b/drivers/dsp/bridge/core/dsp-mmu.c
@@ -133,7 +133,7 @@ int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
 						struct page **usr_pgs)
 {
 	int res, w;
-	unsigned pages, i;
+	unsigned pages, i, j = 0;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	struct sg_table *sgt;
@@ -162,24 +162,31 @@ int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
 	if (res < 0)
 		return res;
 
-	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
+	while (pages) {
+		sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
 
-	if (!sgt)
-		return -ENOMEM;
+		if (!sgt)
+			return -ENOMEM;
 
-	res = sg_alloc_table(sgt, pages, GFP_KERNEL);
+		res = sg_alloc_table(sgt,
+			min((unsigned)SG_MAX_SINGLE_ALLOC, pages), GFP_KERNEL);
+		pages -= min((unsigned)SG_MAX_SINGLE_ALLOC, pages);
 
-	if (res < 0)
-		goto err_sg;
+		if (res < 0)
+			goto err_sg;
+
+		for_each_sg(sgt->sgl, sg, sgt->nents, i)
+			sg_set_page(sg, usr_pgs[j++], PAGE_SIZE, 0);
 
-	for_each_sg(sgt->sgl, sg, sgt->nents, i)
-		sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
+		da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE |
+							IOVMF_ELSZ_32);
 
-	da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+		if (IS_ERR_VALUE(da)) {
+			res = (int)da;
+			goto err_map;
+		}
 
-	if (IS_ERR_VALUE(da)) {
-		res = (int)da;
-		goto err_map;
+		da += SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 	}
 	return 0;
 
@@ -198,21 +205,25 @@ err_sg:
  * This function unmaps a user space buffer into DSP virtual address.
  *
  */
-int user_to_dsp_unmap(struct iommu *mmu, u32 da)
+int user_to_dsp_unmap(struct iommu *mmu, u32 da, unsigned size)
 {
 	unsigned i;
 	struct sg_table *sgt;
 	struct scatterlist *sg;
+	const unsigned max_sz = SG_MAX_SINGLE_ALLOC * PAGE_SIZE;
 
-	sgt = iommu_vunmap(mmu, da);
-	if (!sgt)
-		return -EFAULT;
-
-	for_each_sg(sgt->sgl, sg, sgt->nents, i)
-		put_page(sg_page(sg));
+	while (size) {
+		size -= min(max_sz, size);
+		sgt = iommu_vunmap(mmu, da);
+		if (!sgt)
+			return -EFAULT;
 
-	sg_free_table(sgt);
-	kfree(sgt);
+		for_each_sg(sgt->sgl, sg, sgt->nents, i)
+			put_page(sg_page(sg));
 
+		sg_free_table(sgt);
+		kfree(sgt);
+		da += max_sz;
+	}
 	return 0;
 }
diff --git a/drivers/dsp/bridge/rmgr/proc.c b/drivers/dsp/bridge/rmgr/proc.c
index 4f10a41..997918e 100644
--- a/drivers/dsp/bridge/rmgr/proc.c
+++ b/drivers/dsp/bridge/rmgr/proc.c
@@ -1713,7 +1713,8 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	/* Remove mapping from the page tables. */
 	if (DSP_SUCCEEDED(status)) {
 		status = user_to_dsp_unmap(
-			p_proc_object->hbridge_context->dsp_mmu, va_align);
+			p_proc_object->hbridge_context->dsp_mmu,
+			va_align, size_align);
 	}
 
 	mutex_unlock(&proc_lock);
-- 
1.7.0.4

