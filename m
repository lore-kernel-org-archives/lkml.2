Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0F3Xug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:50:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34189 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0F3Xud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:50:33 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyo@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 3/9] dspbridge: rename bridge_brd_mem_map/unmap to a proper name
Date: Wed, 30 Jun 2010 18:59:55 -0500
Message-Id: <1277942401-3566-4-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277942401-3566-3-git-send-email-x0095840@ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now these functions only map user space addresses to dsp virtual
addresses, so now the functions have a more meaningful name

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/include/dspbridge/dspdefs.h |   44 --------------------
 drivers/dsp/bridge/core/_tiomap.h              |   25 +++++++++++
 drivers/dsp/bridge/core/tiomap3430.c           |   52 ++++++++++--------------
 drivers/dsp/bridge/pmgr/dev.c                  |    2 -
 drivers/dsp/bridge/rmgr/proc.c                 |   12 +++--
 5 files changed, 53 insertions(+), 82 deletions(-)

diff --git a/arch/arm/plat-omap/include/dspbridge/dspdefs.h b/arch/arm/plat-omap/include/dspbridge/dspdefs.h
index 493f62e..4f56ae6 100644
--- a/arch/arm/plat-omap/include/dspbridge/dspdefs.h
+++ b/arch/arm/plat-omap/include/dspbridge/dspdefs.h
@@ -162,48 +162,6 @@ typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
 				       u32 ulMemType);
 
 /*
- *  ======== bridge_brd_mem_map ========
- *  Purpose:
- *      Map a MPU memory region to a DSP/IVA memory space
- *  Parameters:
- *      hDevContext:    Handle to Bridge driver defined device info.
- *      ul_mpu_addr:      MPU memory region start address.
- *      ulVirtAddr:     DSP/IVA memory region u8 address.
- *      ul_num_bytes:     Number of bytes to map.
- *      map_attrs:       Mapping attributes (e.g. endianness).
- *  Returns:
- *      0:        Success.
- *      -EPERM:      Other, unspecified error.
- *  Requires:
- *      hDevContext != NULL;
- *  Ensures:
- */
-typedef int(*fxn_brd_memmap) (struct bridge_dev_context
-				     * hDevContext, u32 ul_mpu_addr,
-				     u32 ulVirtAddr, u32 ul_num_bytes,
-				     u32 ulMapAttrs,
-				     struct page **mapped_pages);
-
-/*
- *  ======== bridge_brd_mem_un_map ========
- *  Purpose:
- *      UnMap an MPU memory region from DSP/IVA memory space
- *  Parameters:
- *      hDevContext:    Handle to Bridge driver defined device info.
- *      ulVirtAddr:     DSP/IVA memory region u8 address.
- *      ul_num_bytes:     Number of bytes to unmap.
- *  Returns:
- *      0:        Success.
- *      -EPERM:      Other, unspecified error.
- *  Requires:
- *      hDevContext != NULL;
- *  Ensures:
- */
-typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
-				       * hDevContext,
-				       u32 ulVirtAddr, u32 ul_num_bytes);
-
-/*
  *  ======== bridge_brd_stop ========
  *  Purpose:
  *      Bring board to the BRD_STOPPED state.
@@ -1061,8 +1019,6 @@ struct bridge_drv_interface {
 	fxn_brd_setstate pfn_brd_set_state;	/* Sets the Board State */
 	fxn_brd_memcopy pfn_brd_mem_copy;	/* Copies DSP Memory */
 	fxn_brd_memwrite pfn_brd_mem_write;	/* Write DSP Memory w/o halt */
-	fxn_brd_memmap pfn_brd_mem_map;	/* Maps MPU mem to DSP mem */
-	fxn_brd_memunmap pfn_brd_mem_un_map;	/* Unmaps MPU mem to DSP mem */
 	fxn_chnl_create pfn_chnl_create;	/* Create channel manager. */
 	fxn_chnl_destroy pfn_chnl_destroy;	/* Destroy channel manager. */
 	fxn_chnl_open pfn_chnl_open;	/* Create a new channel. */
diff --git a/drivers/dsp/bridge/core/_tiomap.h b/drivers/dsp/bridge/core/_tiomap.h
index 6a822c6..4aa2358 100644
--- a/drivers/dsp/bridge/core/_tiomap.h
+++ b/drivers/dsp/bridge/core/_tiomap.h
@@ -396,4 +396,29 @@ static inline void dsp_iotlb_init(struct iotlb_entry *e, u32 da, u32 pa,
 	e->mixed = 0;
 }
 
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
+
+int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
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
diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
index 89d4936..88f5167 100644
--- a/drivers/dsp/bridge/core/tiomap3430.c
+++ b/drivers/dsp/bridge/core/tiomap3430.c
@@ -98,12 +98,6 @@ static int bridge_brd_mem_copy(struct bridge_dev_context *hDevContext,
 static int bridge_brd_mem_write(struct bridge_dev_context *dev_context,
 				    IN u8 *pbHostBuf, u32 dwDSPAddr,
 				    u32 ul_num_bytes, u32 ulMemType);
-static int bridge_brd_mem_map(struct bridge_dev_context *hDevContext,
-				  u32 ul_mpu_addr, u32 ulVirtAddr,
-				  u32 ul_num_bytes, u32 ul_map_attr,
-				  struct page **mapped_pages);
-static int bridge_brd_mem_un_map(struct bridge_dev_context *hDevContext,
-				     u32 ulVirtAddr, u32 ul_num_bytes);
 static int bridge_dev_create(OUT struct bridge_dev_context
 					**ppDevContext,
 					struct dev_object *hdev_obj,
@@ -181,8 +175,6 @@ static struct bridge_drv_interface drv_interface_fxns = {
 	bridge_brd_set_state,
 	bridge_brd_mem_copy,
 	bridge_brd_mem_write,
-	bridge_brd_mem_map,
-	bridge_brd_mem_un_map,
 	/* The following CHNL functions are provided by chnl_io.lib: */
 	bridge_chnl_create,
 	bridge_chnl_destroy,
@@ -1221,22 +1213,24 @@ static int bridge_brd_mem_write(struct bridge_dev_context *hDevContext,
 	return status;
 }
 
-/*
- *  ======== bridge_brd_mem_map ========
- *      This function maps MPU buffer to the DSP address space. It performs
- *  linear to physical address translation if required. It translates each
- *  page since linear addresses can be physically non-contiguous
- *  All address & size arguments are assumed to be page aligned (in proc.c)
+/**
+ * user_to_dsp_map() - maps user to dsp virtual address
+ * @mmu:	Pointer to iommu handle.
+ * @uva:		Virtual user space address.
+ * @da		DSP address
+ * @size		Buffer size to map.
+ * @usr_pgs	struct page array pointer where the user pages will be stored
+ *
+ * This function maps a user space buffer into DSP virtual address.
  *
- *  TODO: Disable MMU while updating the page tables (but that'll stall DSP)
  */
-static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
-			u32 uva, u32 da, u32 size, u32 attr,
-			struct page **usr_pgs)
+
+int user_to_dsp_map(struct iommu *mmu, u32 uva, u32 da, u32 size,
+						struct page **usr_pgs)
+
 {
 	int res, w;
 	unsigned pages, i;
-	struct iommu *mmu = dev_ctx->dsp_mmu;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	struct sg_table *sgt;
@@ -1293,25 +1287,21 @@ err_sg:
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
-static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx,
-				     u32 da, u32 size)
+int user_to_dsp_unmap(struct iommu *mmu, u32 da)
 {
 	unsigned i;
 	struct sg_table *sgt;
 	struct scatterlist *sg;
 
-	if (!size)
-		return -EINVAL;
-
-	sgt = iommu_vunmap(dev_ctx->dsp_mmu, da);
+	sgt = iommu_vunmap(mmu, da);
 	if (!sgt)
 		return -EFAULT;
 
diff --git a/drivers/dsp/bridge/pmgr/dev.c b/drivers/dsp/bridge/pmgr/dev.c
index 50a5d97..39c1faf 100644
--- a/drivers/dsp/bridge/pmgr/dev.c
+++ b/drivers/dsp/bridge/pmgr/dev.c
@@ -1101,8 +1101,6 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 		STORE_FXN(fxn_brd_setstate, pfn_brd_set_state);
 		STORE_FXN(fxn_brd_memcopy, pfn_brd_mem_copy);
 		STORE_FXN(fxn_brd_memwrite, pfn_brd_mem_write);
-		STORE_FXN(fxn_brd_memmap, pfn_brd_mem_map);
-		STORE_FXN(fxn_brd_memunmap, pfn_brd_mem_un_map);
 		STORE_FXN(fxn_chnl_create, pfn_chnl_create);
 		STORE_FXN(fxn_chnl_destroy, pfn_chnl_destroy);
 		STORE_FXN(fxn_chnl_open, pfn_chnl_open);
diff --git a/drivers/dsp/bridge/rmgr/proc.c b/drivers/dsp/bridge/rmgr/proc.c
index c5a8b6b..299bef3 100644
--- a/drivers/dsp/bridge/rmgr/proc.c
+++ b/drivers/dsp/bridge/rmgr/proc.c
@@ -53,6 +53,7 @@
 #include <dspbridge/msg.h>
 #include <dspbridge/dspioctl.h>
 #include <dspbridge/drv.h>
+#include <_tiomap.h>
 
 /*  ----------------------------------- This */
 #include <dspbridge/proc.h>
@@ -1384,9 +1385,10 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 		if (!map_obj)
 			status = -ENOMEM;
 		else
-			status = (*p_proc_object->intf_fxns->pfn_brd_mem_map)
-			    (p_proc_object->hbridge_context, pa_align, va_align,
-			     size_align, ul_map_attr, map_obj->pages);
+			status = user_to_dsp_map(
+				p_proc_object->hbridge_context->dsp_mmu,
+				pa_align, va_align, size_align,
+				map_obj->pages);
 	}
 	if (DSP_SUCCEEDED(status)) {
 		/* Mapped address = MSB of VA | LSB of PA */
@@ -1714,8 +1716,8 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	status = dmm_un_map_memory(dmm_mgr, (u32) va_align, &size_align);
 	/* Remove mapping from the page tables. */
 	if (DSP_SUCCEEDED(status)) {
-		status = (*p_proc_object->intf_fxns->pfn_brd_mem_un_map)
-		    (p_proc_object->hbridge_context, va_align, size_align);
+		status = user_to_dsp_unmap(
+			p_proc_object->hbridge_context->dsp_mmu, va_align);
 	}
 
 	mutex_unlock(&proc_lock);
-- 
1.7.0.4

