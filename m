Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0JAB7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:59:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42285 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0JAB7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:59:37 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 03/11] staging: tidspbridge - rename bridge_brd_mem_map/unmap to a proper name
Date: Thu, 30 Sep 2010 21:12:50 -0500
Message-Id: <1285899178-14413-4-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285899178-14413-3-git-send-email-x0095840@ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
 <1285899178-14413-2-git-send-email-x0095840@ti.com>
 <1285899178-14413-3-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now these functions only map user space addresses to dsp virtual
addresses, so now the functions have a more meaningful name.
Also now user_to_dsp_map returns the mapped address.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/_tiomap.h         |   24 +++
 drivers/staging/tidspbridge/core/tiomap3430.c      |  153 ++++++++++----------
 .../tidspbridge/include/dspbridge/dspdefs.h        |   44 ------
 drivers/staging/tidspbridge/pmgr/dev.c             |    2 -
 drivers/staging/tidspbridge/rmgr/proc.c            |   34 +++--
 5 files changed, 116 insertions(+), 141 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index c1bf95d..8777492 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -383,4 +383,28 @@ extern s32 dsp_debug;
  */
 int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val);
 
+/**
+ * user_to_dsp_map() - maps user to dsp virtual address
+ * @mmu:	Pointer to iommu handle.
+ * @uva:		Virtual user space address.
+ * @da		DSP address
+ * @size		Buffer size to map.
+ * @usr_pgs	struct page array pointer where the user pages will be stored
+ *
+ * This function maps a user space buffer into DSP virtual address.
+ *
+ */
+u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
+						struct page **usr_pgs);
+
+/**
+ * user_to_dsp_unmap() - unmaps DSP virtual buffer.
+ * @mmu:	Pointer to iommu handle.
+ * @da		DSP address
+ *
+ * This function unmaps a user space buffer into DSP virtual address.
+ *
+ */
+int user_to_dsp_unmap(struct iommu *mmu, u32 da);
+
 #endif /* _TIOMAP_ */
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 721116b..8825700 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -95,12 +95,6 @@ static int bridge_brd_mem_copy(struct bridge_dev_context *dev_ctxt,
 static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
 				    u8 *host_buff, u32 dsp_addr,
 				    u32 ul_num_bytes, u32 mem_type);
-static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctxt,
-				  u32 ul_mpu_addr, u32 virt_addr,
-				  u32 ul_num_bytes, u32 ul_map_attr,
-				  struct page **mapped_pages);
-static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctxt,
-				     u32 da);
 static int bridge_dev_create(struct bridge_dev_context
 					**dev_cntxt,
 					struct dev_object *hdev_obj,
@@ -108,9 +102,6 @@ static int bridge_dev_create(struct bridge_dev_context
 static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
 				  u32 dw_cmd, void *pargs);
 static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt);
-static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
-						struct page **usr_pgs);
-static u32 user_va2_pa(struct mm_struct *mm, u32 address);
 static int pte_update(struct bridge_dev_context *dev_ctxt, u32 pa,
 			     u32 va, u32 size,
 			     struct hw_mmu_map_attrs_t *map_attrs);
@@ -180,8 +171,6 @@ static struct bridge_drv_interface drv_interface_fxns = {
 	bridge_brd_set_state,
 	bridge_brd_mem_copy,
 	bridge_brd_mem_write,
-	bridge_brd_mem_map,
-	bridge_brd_mem_un_map,
 	/* The following CHNL functions are provided by chnl_io.lib: */
 	bridge_chnl_create,
 	bridge_chnl_destroy,
@@ -1151,22 +1140,77 @@ static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
 }
 
 /*
- *  ======== bridge_brd_mem_map ========
- *      This function maps MPU buffer to the DSP address space. It performs
- *  linear to physical address translation if required. It translates each
- *  page since linear addresses can be physically non-contiguous
- *  All address & size arguments are assumed to be page aligned (in proc.c)
+ *  ======== user_va2_pa ========
+ *  Purpose:
+ *      This function walks through the page tables to convert a userland
+ *      virtual address to physical address
+ */
+static u32 user_va2_pa(struct mm_struct *mm, u32 address)
+{
+	pgd_t *pgd;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+
+	pgd = pgd_offset(mm, address);
+	if (!(pgd_none(*pgd) || pgd_bad(*pgd))) {
+		pmd = pmd_offset(pgd, address);
+		if (!(pmd_none(*pmd) || pmd_bad(*pmd))) {
+			ptep = pte_offset_map(pmd, address);
+			if (ptep) {
+				pte = *ptep;
+				if (pte_present(pte))
+					return pte & PAGE_MASK;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * get_io_pages() - pin and get pages of io user's buffer.
+ * @mm:		mm_struct Pointer of the process.
+ * @uva:		Virtual user space address.
+ * @pages	Pages to be pined.
+ * @usr_pgs	struct page array pointer where the user pages will be stored
  *
- *  TODO: Disable MMU while updating the page tables (but that'll stall DSP)
  */
-static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
-			u32 uva, u32 da, u32 size, u32 attr,
-			struct page **usr_pgs)
+static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
+						struct page **usr_pgs)
+{
+	u32 pa;
+	int i;
+	struct page *pg;
+
+	for (i = 0; i < pages; i++) {
+		pa = user_va2_pa(mm, uva);
 
+		if (!pfn_valid(__phys_to_pfn(pa)))
+			break;
+
+		pg = PHYS_TO_PAGE(pa);
+		usr_pgs[i] = pg;
+		get_page(pg);
+	}
+	return i;
+}
+
+/**
+ * user_to_dsp_map() - maps user to dsp virtual address
+ * @mmu:	Pointer to iommu handle.
+ * @uva:		Virtual user space address.
+ * @da		DSP address
+ * @size		Buffer size to map.
+ * @usr_pgs	struct page array pointer where the user pages will be stored
+ *
+ * This function maps a user space buffer into DSP virtual address.
+ *
+ */
+u32 user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
+				struct page **usr_pgs)
 {
 	int res, w;
 	unsigned pages, i;
-	struct iommu *mmu = dev_ctx->dsp_mmu;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	struct sg_table *sgt;
@@ -1223,7 +1267,7 @@ static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
 	da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
 
 	if (!IS_ERR_VALUE(da))
-		return 0;
+		return da;
 	res = (int)da;
 
 	sg_free_table(sgt);
@@ -1236,21 +1280,21 @@ err_pages:
 	return res;
 }
 
-/*
- *  ======== bridge_brd_mem_un_map ========
- *      Invalidate the PTEs for the DSP VA block to be unmapped.
+/**
+ * user_to_dsp_unmap() - unmaps DSP virtual buffer.
+ * @mmu:	Pointer to iommu handle.
+ * @da		DSP address
+ *
+ * This function unmaps a user space buffer into DSP virtual address.
  *
- *      PTEs of a mapped memory block are contiguous in any page table
- *      So, instead of looking up the PTE address for every 4K block,
- *      we clear consecutive PTEs until we unmap all the bytes
  */
-static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx, u32 da)
+int user_to_dsp_unmap(struct iommu *mmu, u32 da)
 {
 	unsigned i;
 	struct sg_table *sgt;
 	struct scatterlist *sg;
 
-	sgt = iommu_vunmap(dev_ctx->dsp_mmu, da);
+	sgt = iommu_vunmap(mmu, da);
 	if (!sgt)
 		return -EFAULT;
 
@@ -1262,55 +1306,6 @@ static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx, u32 da)
 	return 0;
 }
 
-
-static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
-						struct page **usr_pgs)
-{
-	u32 pa;
-	int i;
-	struct page *pg;
-
-	for (i = 0; i < pages; i++) {
-		pa = user_va2_pa(mm, uva);
-
-		if (!pfn_valid(__phys_to_pfn(pa)))
-			break;
-
-		pg = PHYS_TO_PAGE(pa);
-		usr_pgs[i] = pg;
-		get_page(pg);
-	}
-	return i;
-}
-
-/*
- *  ======== user_va2_pa ========
- *  Purpose:
- *      This function walks through the page tables to convert a userland
- *      virtual address to physical address
- */
-static u32 user_va2_pa(struct mm_struct *mm, u32 address)
-{
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-
-	pgd = pgd_offset(mm, address);
-	if (!(pgd_none(*pgd) || pgd_bad(*pgd))) {
-		pmd = pmd_offset(pgd, address);
-		if (!(pmd_none(*pmd) || pmd_bad(*pmd))) {
-			ptep = pte_offset_map(pmd, address);
-			if (ptep) {
-				pte = *ptep;
-				if (pte_present(pte))
-					return pte & PAGE_MASK;
-			}
-		}
-	}
-
-	return 0;
-}
-
 /*
  *  ======== pte_update ========
  *      This function calculates the optimum page-aligned addresses and sizes
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 173dfbb..6153634 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -162,48 +162,6 @@ typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
 				       u32 mem_type);
 
 /*
- *  ======== bridge_brd_mem_map ========
- *  Purpose:
- *      Map a MPU memory region to a DSP/IVA memory space
- *  Parameters:
- *      dev_ctxt:    Handle to Bridge driver defined device info.
- *      ul_mpu_addr:      MPU memory region start address.
- *      virt_addr:      DSP/IVA memory region u8 address.
- *      ul_num_bytes:     Number of bytes to map.
- *      map_attrs:       Mapping attributes (e.g. endianness).
- *  Returns:
- *      0:        Success.
- *      -EPERM:      Other, unspecified error.
- *  Requires:
- *      dev_ctxt != NULL;
- *  Ensures:
- */
-typedef int(*fxn_brd_memmap) (struct bridge_dev_context
-				     * dev_ctxt, u32 ul_mpu_addr,
-				     u32 virt_addr, u32 ul_num_bytes,
-				     u32 map_attr,
-				     struct page **mapped_pages);
-
-/*
- *  ======== bridge_brd_mem_un_map ========
- *  Purpose:
- *      UnMap an MPU memory region from DSP/IVA memory space
- *  Parameters:
- *      dev_ctxt:    Handle to Bridge driver defined device info.
- *      virt_addr:      DSP/IVA memory region u8 address.
- *      ul_num_bytes:     Number of bytes to unmap.
- *  Returns:
- *      0:        Success.
- *      -EPERM:      Other, unspecified error.
- *  Requires:
- *      dev_ctxt != NULL;
- *  Ensures:
- */
-typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
-				       * dev_ctxt,
-				       u32 da);
-
-/*
  *  ======== bridge_brd_stop ========
  *  Purpose:
  *      Bring board to the BRD_STOPPED state.
@@ -993,8 +951,6 @@ struct bridge_drv_interface {
 	fxn_brd_setstate pfn_brd_set_state;	/* Sets the Board State */
 	fxn_brd_memcopy pfn_brd_mem_copy;	/* Copies DSP Memory */
 	fxn_brd_memwrite pfn_brd_mem_write;	/* Write DSP Memory w/o halt */
-	fxn_brd_memmap pfn_brd_mem_map;	/* Maps MPU mem to DSP mem */
-	fxn_brd_memunmap pfn_brd_mem_un_map;	/* Unmaps MPU mem to DSP mem */
 	fxn_chnl_create pfn_chnl_create;	/* Create channel manager. */
 	fxn_chnl_destroy pfn_chnl_destroy;	/* Destroy channel manager. */
 	fxn_chnl_open pfn_chnl_open;	/* Create a new channel. */
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 132e960..e3c78fb 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -1118,8 +1118,6 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 		STORE_FXN(fxn_brd_setstate, pfn_brd_set_state);
 		STORE_FXN(fxn_brd_memcopy, pfn_brd_mem_copy);
 		STORE_FXN(fxn_brd_memwrite, pfn_brd_mem_write);
-		STORE_FXN(fxn_brd_memmap, pfn_brd_mem_map);
-		STORE_FXN(fxn_brd_memunmap, pfn_brd_mem_un_map);
 		STORE_FXN(fxn_chnl_create, pfn_chnl_create);
 		STORE_FXN(fxn_chnl_destroy, pfn_chnl_destroy);
 		STORE_FXN(fxn_chnl_open, pfn_chnl_open);
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 97c5b61..59c946b 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -52,6 +52,7 @@
 #include <dspbridge/msg.h>
 #include <dspbridge/dspioctl.h>
 #include <dspbridge/drv.h>
+#include <_tiomap.h>
 
 /*  ----------------------------------- This */
 #include <dspbridge/proc.h>
@@ -1357,7 +1358,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
 	struct dmm_map_object *map_obj;
-	u32 tmp_addr = 0;
 
 #ifdef CONFIG_TIDSPBRIDGE_CACHE_LINE_CHECK
 	if ((ul_map_attr & BUFMODE_MASK) != RBUF) {
@@ -1390,24 +1390,27 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 
 	/* Add mapping to the page tables. */
 	if (!status) {
-
-		/* Mapped address = MSB of VA | LSB of PA */
-		tmp_addr = (va_align | ((u32) pmpu_addr & (PG_SIZE4K - 1)));
 		/* mapped memory resource tracking */
-		map_obj = add_mapping_info(pr_ctxt, pa_align, tmp_addr,
+		map_obj = add_mapping_info(pr_ctxt, pa_align, va_align,
 						size_align);
-		if (!map_obj)
+		if (!map_obj) {
 			status = -ENOMEM;
-		else
-			status = (*p_proc_object->intf_fxns->pfn_brd_mem_map)
-			    (p_proc_object->hbridge_context, pa_align, va_align,
-			     size_align, ul_map_attr, map_obj->pages);
+		} else {
+			va_align = user_to_dsp_map(
+				p_proc_object->hbridge_context->dsp_mmu,
+				pa_align, va_align, size_align,
+				map_obj->pages);
+			if (IS_ERR_VALUE(va_align))
+				status = (int)va_align;
+		}
 	}
 	if (!status) {
 		/* Mapped address = MSB of VA | LSB of PA */
-		*pp_map_addr = (void *) tmp_addr;
+		map_obj->dsp_addr = (va_align |
+					((u32)pmpu_addr & (PG_SIZE4K - 1)));
+		*pp_map_addr = (void *)map_obj->dsp_addr;
 	} else {
-		remove_mapping_information(pr_ctxt, tmp_addr, size_align);
+		remove_mapping_information(pr_ctxt, va_align, size_align);
 		dmm_un_map_memory(dmm_mgr, va_align, &size_align);
 	}
 	mutex_unlock(&proc_lock);
@@ -1721,10 +1724,9 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	 */
 	status = dmm_un_map_memory(dmm_mgr, (u32) va_align, &size_align);
 	/* Remove mapping from the page tables. */
-	if (!status) {
-		status = (*p_proc_object->intf_fxns->pfn_brd_mem_un_map)
-		    (p_proc_object->hbridge_context, va_align);
-	}
+	if (!status)
+		status = user_to_dsp_unmap(
+			p_proc_object->hbridge_context->dsp_mmu, va_align);
 
 	mutex_unlock(&proc_lock);
 	if (status)
-- 
1.6.3.3

