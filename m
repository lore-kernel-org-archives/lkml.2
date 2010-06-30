Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab0F3Xuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:50:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34188 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0F3Xud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:50:33 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyo@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 1/9] dspbridge: replace iommu custom for opensource implementation
Date: Wed, 30 Jun 2010 18:59:53 -0500
Message-Id: <1277942401-3566-2-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277942401-3566-1-git-send-email-x0095840@ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace the call to custom dsp mmu implemenation
for the once on iommu module.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/dsp/bridge/core/_tiomap.h    |   16 +
 drivers/dsp/bridge/core/io_sm.c      |  114 ++------
 drivers/dsp/bridge/core/tiomap3430.c |  501 +++++-----------------------------
 drivers/dsp/bridge/core/ue_deh.c     |   10 -
 4 files changed, 118 insertions(+), 523 deletions(-)

diff --git a/drivers/dsp/bridge/core/_tiomap.h b/drivers/dsp/bridge/core/_tiomap.h
index bf0164e..d13677a 100644
--- a/drivers/dsp/bridge/core/_tiomap.h
+++ b/drivers/dsp/bridge/core/_tiomap.h
@@ -23,6 +23,8 @@
 #include <plat/clockdomain.h>
 #include <mach-omap2/prm-regbits-34xx.h>
 #include <mach-omap2/cm-regbits-34xx.h>
+#include <plat/iommu.h>
+#include <plat/iovmm.h>
 #include <dspbridge/devdefs.h>
 #include <hw_defs.h>
 #include <dspbridge/dspioctl.h>	/* for bridge_ioctl_extproc defn */
@@ -330,6 +332,7 @@ struct bridge_dev_context {
 	u32 dw_internal_size;	/* Internal memory size */
 
 	struct omap_mbox *mbox;		/* Mail box handle */
+	struct iommu *dsp_mmu;		/* iommu for iva2 handler */
 
 	struct cfg_hostres *resources;	/* Host Resources */
 
@@ -374,4 +377,17 @@ extern s32 dsp_debug;
  */
 int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val);
 
+static inline void dsp_iotlb_init(struct iotlb_entry *e, u32 da, u32 pa,
+							u32 pgsz)
+{
+	e->da = da;
+	e->pa = pa;
+	e->valid = 1;
+	e->prsvd = 1;
+	e->pgsz = pgsz & MMU_CAM_PGSZ_MASK;
+	e->endian = MMU_RAM_ENDIAN_LITTLE;
+	e->elsz = MMU_RAM_ELSZ_32;
+	e->mixed = 0;
+}
+
 #endif /* _TIOMAP_ */
diff --git a/drivers/dsp/bridge/core/io_sm.c b/drivers/dsp/bridge/core/io_sm.c
index 7fb840d..1f47f8b 100644
--- a/drivers/dsp/bridge/core/io_sm.c
+++ b/drivers/dsp/bridge/core/io_sm.c
@@ -290,6 +290,8 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	struct cod_manager *cod_man;
 	struct chnl_mgr *hchnl_mgr;
 	struct msg_mgr *hmsg_mgr;
+	struct iommu *mmu;
+	struct iotlb_entry e;
 	u32 ul_shm_base;
 	u32 ul_shm_base_offset;
 	u32 ul_shm_limit;
@@ -312,7 +314,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	struct bridge_ioctl_extproc ae_proc[BRDIOCTL_NUMOFMMUTLB];
 	struct cfg_hostres *host_res;
 	struct bridge_dev_context *pbridge_context;
-	u32 map_attrs;
 	u32 shm0_end;
 	u32 ul_dyn_ext_base;
 	u32 ul_seg1_size = 0;
@@ -336,6 +337,21 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		status = -EFAULT;
 		goto func_end;
 	}
+
+	mmu = pbridge_context->dsp_mmu;
+
+	if (mmu)
+		iommu_put(mmu);
+	mmu = iommu_get("iva2");
+
+	if (IS_ERR_OR_NULL(mmu)) {
+		pr_err("Error in iommu_get\n");
+		pbridge_context->dsp_mmu = NULL;
+		status = -EFAULT;
+		goto func_end;
+	}
+	pbridge_context->dsp_mmu = mmu;
+
 	status = dev_get_cod_mgr(hio_mgr->hdev_obj, &cod_man);
 	if (!cod_man) {
 		status = -EFAULT;
@@ -477,55 +493,16 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	gpp_va_curr = ul_gpp_va;
 	num_bytes = ul_seg1_size;
 
-	/*
-	 * Try to fit into TLB entries. If not possible, push them to page
-	 * tables. It is quite possible that if sections are not on
-	 * bigger page boundary, we may end up making several small pages.
-	 * So, push them onto page tables, if that is the case.
-	 */
-	map_attrs = 0x00000000;
-	map_attrs = DSP_MAPLITTLEENDIAN;
-	map_attrs |= DSP_MAPPHYSICALADDR;
-	map_attrs |= DSP_MAPELEMSIZE32;
-	map_attrs |= DSP_MAPDONOTLOCK;
-
-	while (num_bytes) {
-		/*
-		 * To find the max. page size with which both PA & VA are
-		 * aligned.
-		 */
-		all_bits = pa_curr | va_curr;
-		dev_dbg(bridge, "all_bits %x, pa_curr %x, va_curr %x, "
-			"num_bytes %x\n", all_bits, pa_curr, va_curr,
-			num_bytes);
-		for (i = 0; i < 4; i++) {
-			if ((num_bytes >= page_size[i]) && ((all_bits &
-							     (page_size[i] -
-							      1)) == 0)) {
-				status =
-				    hio_mgr->intf_fxns->
-				    pfn_brd_mem_map(hio_mgr->hbridge_context,
-						    pa_curr, va_curr,
-						    page_size[i], map_attrs,
-						    NULL);
-				if (DSP_FAILED(status))
-					goto func_end;
-				pa_curr += page_size[i];
-				va_curr += page_size[i];
-				gpp_va_curr += page_size[i];
-				num_bytes -= page_size[i];
-				/*
-				 * Don't try smaller sizes. Hopefully we have
-				 * reached an address aligned to a bigger page
-				 * size.
-				 */
-				break;
-			}
-		}
+	va_curr = iommu_kmap(mmu, va_curr, pa_curr, num_bytes,
+					IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+	if (IS_ERR_VALUE(va_curr)) {
+		status = (int)va_curr;
+		goto func_end;
 	}
-	pa_curr += ul_pad_size;
-	va_curr += ul_pad_size;
-	gpp_va_curr += ul_pad_size;
+
+	pa_curr += ul_pad_size + num_bytes;
+	va_curr += ul_pad_size + num_bytes;
+	gpp_va_curr += ul_pad_size + num_bytes;
 
 	/* Configure the TLB entries for the next cacheable segment */
 	num_bytes = ul_seg_size;
@@ -567,22 +544,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 					ae_proc[ndx].ul_dsp_va *
 					hio_mgr->word_size, page_size[i]);
 				ndx++;
-			} else {
-				status =
-				    hio_mgr->intf_fxns->
-				    pfn_brd_mem_map(hio_mgr->hbridge_context,
-						    pa_curr, va_curr,
-						    page_size[i], map_attrs,
-						    NULL);
-				dev_dbg(bridge,
-					"shm MMU PTE entry PA %x"
-					" VA %x DSP_VA %x Size %x\n",
-					ae_proc[ndx].ul_gpp_pa,
-					ae_proc[ndx].ul_gpp_va,
-					ae_proc[ndx].ul_dsp_va *
-					hio_mgr->word_size, page_size[i]);
-				if (DSP_FAILED(status))
-					goto func_end;
 			}
 			pa_curr += page_size[i];
 			va_curr += page_size[i];
@@ -635,35 +596,20 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 					"DSP_VA 0x%x\n", ae_proc[ndx].ul_gpp_pa,
 					ae_proc[ndx].ul_dsp_va);
 				ndx++;
-			} else {
-				status = hio_mgr->intf_fxns->pfn_brd_mem_map
-				    (hio_mgr->hbridge_context,
-				     hio_mgr->ext_proc_info.ty_tlb[i].
-				     ul_gpp_phys,
-				     hio_mgr->ext_proc_info.ty_tlb[i].
-				     ul_dsp_virt, 0x100000, map_attrs,
-				     NULL);
 			}
 		}
 		if (DSP_FAILED(status))
 			goto func_end;
 	}
 
-	map_attrs = 0x00000000;
-	map_attrs = DSP_MAPLITTLEENDIAN;
-	map_attrs |= DSP_MAPPHYSICALADDR;
-	map_attrs |= DSP_MAPELEMSIZE32;
-	map_attrs |= DSP_MAPDONOTLOCK;
+	dsp_iotlb_init(&e, 0, 0, IOVMF_PGSZ_4K);
 
 	/* Map the L4 peripherals */
 	i = 0;
 	while (l4_peripheral_table[i].phys_addr) {
-		status = hio_mgr->intf_fxns->pfn_brd_mem_map
-		    (hio_mgr->hbridge_context, l4_peripheral_table[i].phys_addr,
-		     l4_peripheral_table[i].dsp_virt_addr, HW_PAGE_SIZE4KB,
-		     map_attrs, NULL);
-		if (DSP_FAILED(status))
-			goto func_end;
+		e.da = l4_peripheral_table[i].dsp_virt_addr;
+		e.pa = l4_peripheral_table[i].phys_addr;
+		iopgtable_store_entry(mmu, &e);
 		i++;
 	}
 
diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
index 35c6678..e750767 100644
--- a/drivers/dsp/bridge/core/tiomap3430.c
+++ b/drivers/dsp/bridge/core/tiomap3430.c
@@ -373,6 +373,8 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 {
 	int status = 0;
 	struct bridge_dev_context *dev_context = hDevContext;
+	struct iommu *mmu;
+	struct iotlb_entry en;
 	u32 dw_sync_addr = 0;
 	u32 ul_shm_base;	/* Gpp Phys SM base addr(byte) */
 	u32 ul_shm_base_virt;	/* Dsp Virt SM base addr */
@@ -392,6 +394,8 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 	struct dspbridge_platform_data *pdata =
 				omap_dspbridge_dev->dev.platform_data;
 
+	mmu = dev_context->dsp_mmu;
+
 	/* The device context contains all the mmu setup info from when the
 	 * last dsp base image was loaded. The first entry is always
 	 * SHMMEM base. */
@@ -442,30 +446,10 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 		}
 	}
 	if (DSP_SUCCEEDED(status)) {
-		/* Reset and Unreset the RST2, so that BOOTADDR is copied to
-		 * IVA2 SYSC register */
-		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2,
-			OMAP3430_RST2_IVA2, OMAP3430_IVA2_MOD, RM_RSTCTRL);
-		udelay(100);
-		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2, 0,
-					OMAP3430_IVA2_MOD, RM_RSTCTRL);
-		udelay(100);
-
-		/* Disbale the DSP MMU */
-		hw_mmu_disable(resources->dw_dmmu_base);
-		/* Disable TWL */
-		hw_mmu_twl_disable(resources->dw_dmmu_base);
-
 		/* Only make TLB entry if both addresses are non-zero */
 		for (entry_ndx = 0; entry_ndx < BRDIOCTL_NUMOFMMUTLB;
 		     entry_ndx++) {
 			struct bridge_ioctl_extproc *e = &dev_context->atlb_entry[entry_ndx];
-			struct hw_mmu_map_attrs_t map_attrs = {
-				.endianism = e->endianism,
-				.element_size = e->elem_size,
-				.mixed_size = e->mixed_mode,
-			};
-
 			if (!e->ul_gpp_pa || !e->ul_dsp_va)
 				continue;
 
@@ -476,13 +460,9 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 					e->ul_dsp_va,
 					e->ul_size);
 
-			hw_mmu_tlb_add(dev_context->dw_dsp_mmu_base,
-					e->ul_gpp_pa,
-					e->ul_dsp_va,
-					e->ul_size,
-					itmp_entry_ndx,
-					&map_attrs, 1, 1);
-
+			dsp_iotlb_init(&en, e->ul_dsp_va, e->ul_gpp_pa,
+					bytes_to_iopgsz(e->ul_size));
+			iopgtable_store_entry(mmu, &en);
 			itmp_entry_ndx++;
 		}
 	}
@@ -490,19 +470,6 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 	/* Lock the above TLB entries and get the BIOS and load monitor timer
 	 * information */
 	if (DSP_SUCCEEDED(status)) {
-		hw_mmu_num_locked_set(resources->dw_dmmu_base, itmp_entry_ndx);
-		hw_mmu_victim_num_set(resources->dw_dmmu_base, itmp_entry_ndx);
-		hw_mmu_ttb_set(resources->dw_dmmu_base,
-			       dev_context->pt_attrs->l1_base_pa);
-		hw_mmu_twl_enable(resources->dw_dmmu_base);
-		/* Enable the SmartIdle and AutoIdle bit for MMU_SYSCONFIG */
-
-		temp = __raw_readl((resources->dw_dmmu_base) + 0x10);
-		temp = (temp & 0xFFFFFFEF) | 0x11;
-		__raw_writel(temp, (resources->dw_dmmu_base) + 0x10);
-
-		/* Let the DSP MMU run */
-		hw_mmu_enable(resources->dw_dmmu_base);
 
 		/* Enable the BIOS clock */
 		(void)dev_get_symbol(dev_context->hdev_obj,
@@ -510,9 +477,6 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 		(void)dev_get_symbol(dev_context->hdev_obj,
 				     BRIDGEINIT_LOADMON_GPTIMER,
 				     &ul_load_monitor_timer);
-	}
-
-	if (DSP_SUCCEEDED(status)) {
 		if (ul_load_monitor_timer != 0xFFFF) {
 			clk_cmd = (BPWR_ENABLE_CLOCK << MBX_PM_CLK_CMDSHIFT) |
 			    ul_load_monitor_timer;
@@ -593,9 +557,6 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 
 		/* Let DSP go */
 		dev_dbg(bridge, "%s Unreset\n", __func__);
-		/* Enable DSP MMU Interrupts */
-		hw_mmu_event_enable(resources->dw_dmmu_base,
-				    HW_MMU_ALL_INTERRUPTS);
 		/* release the RST1, DSP starts executing now .. */
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2, 0,
 					OMAP3430_IVA2_MOD, RM_RSTCTRL);
@@ -754,6 +715,9 @@ static int bridge_brd_delete(struct bridge_dev_context *hDevContext)
 		omap_mbox_put(dev_context->mbox);
 		dev_context->mbox = NULL;
 	}
+
+	if (dev_context->dsp_mmu)
+		dev_context->dsp_mmu = (iommu_put(dev_context->dsp_mmu), NULL);
 	/* Reset IVA2 clocks*/
 	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2 | OMAP3430_RST2_IVA2 |
 			OMAP3430_RST3_IVA2, OMAP3430_IVA2_MOD, RM_RSTCTRL);
@@ -1199,219 +1163,67 @@ static int bridge_brd_mem_write(struct bridge_dev_context *hDevContext,
  *
  *  TODO: Disable MMU while updating the page tables (but that'll stall DSP)
  */
-static int bridge_brd_mem_map(struct bridge_dev_context *hDevContext,
-				  u32 ul_mpu_addr, u32 ulVirtAddr,
-				  u32 ul_num_bytes, u32 ul_map_attr,
-				  struct page **mapped_pages)
+static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
+			u32 uva, u32 da, u32 size, u32 attr,
+			struct page **usr_pgs)
 {
-	u32 attrs;
-	int status = 0;
-	struct bridge_dev_context *dev_context = hDevContext;
-	struct hw_mmu_map_attrs_t hw_attrs;
+	int res, w;
+	unsigned pages, i;
+	struct iommu *mmu = dev_ctx->dsp_mmu;
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	u32 write = 0;
-	u32 num_usr_pgs = 0;
-	struct page *mapped_page, *pg;
-	s32 pg_num;
-	u32 va = ulVirtAddr;
-	struct task_struct *curr_task = current;
-	u32 pg_i = 0;
-	u32 mpu_addr, pa;
-
-	dev_dbg(bridge,
-		"%s hDevCtxt %p, pa %x, va %x, size %x, ul_map_attr %x\n",
-		__func__, hDevContext, ul_mpu_addr, ulVirtAddr, ul_num_bytes,
-		ul_map_attr);
-	if (ul_num_bytes == 0)
-		return -EINVAL;
+	struct sg_table *sgt;
+	struct scatterlist *sg;
 
-	if (ul_map_attr & DSP_MAP_DIR_MASK) {
-		attrs = ul_map_attr;
-	} else {
-		/* Assign default attributes */
-		attrs = ul_map_attr | (DSP_MAPVIRTUALADDR | DSP_MAPELEMSIZE16);
-	}
-	/* Take mapping properties */
-	if (attrs & DSP_MAPBIGENDIAN)
-		hw_attrs.endianism = HW_BIG_ENDIAN;
-	else
-		hw_attrs.endianism = HW_LITTLE_ENDIAN;
-
-	hw_attrs.mixed_size = (enum hw_mmu_mixed_size_t)
-	    ((attrs & DSP_MAPMIXEDELEMSIZE) >> 2);
-	/* Ignore element_size if mixed_size is enabled */
-	if (hw_attrs.mixed_size == 0) {
-		if (attrs & DSP_MAPELEMSIZE8) {
-			/* Size is 8 bit */
-			hw_attrs.element_size = HW_ELEM_SIZE8BIT;
-		} else if (attrs & DSP_MAPELEMSIZE16) {
-			/* Size is 16 bit */
-			hw_attrs.element_size = HW_ELEM_SIZE16BIT;
-		} else if (attrs & DSP_MAPELEMSIZE32) {
-			/* Size is 32 bit */
-			hw_attrs.element_size = HW_ELEM_SIZE32BIT;
-		} else if (attrs & DSP_MAPELEMSIZE64) {
-			/* Size is 64 bit */
-			hw_attrs.element_size = HW_ELEM_SIZE64BIT;
-		} else {
-			/*
-			 * Mixedsize isn't enabled, so size can't be
-			 * zero here
-			 */
-			return -EINVAL;
-		}
-	}
-	if (attrs & DSP_MAPDONOTLOCK)
-		hw_attrs.donotlockmpupage = 1;
-	else
-		hw_attrs.donotlockmpupage = 0;
+	if (!size || !usr_pgs)
+		return -EINVAL;
 
-	if (attrs & DSP_MAPVMALLOCADDR) {
-		return mem_map_vmalloc(hDevContext, ul_mpu_addr, ulVirtAddr,
-				       ul_num_bytes, &hw_attrs);
-	}
-	/*
-	 * Do OS-specific user-va to pa translation.
-	 * Combine physically contiguous regions to reduce TLBs.
-	 * Pass the translated pa to pte_update.
-	 */
-	if ((attrs & DSP_MAPPHYSICALADDR)) {
-		status = pte_update(dev_context, ul_mpu_addr, ulVirtAddr,
-				    ul_num_bytes, &hw_attrs);
-		goto func_cont;
-	}
+	pages = size / PG_SIZE4K;
 
-	/*
-	 * Important Note: ul_mpu_addr is mapped from user application process
-	 * to current process - it must lie completely within the current
-	 * virtual memory address space in order to be of use to us here!
-	 */
 	down_read(&mm->mmap_sem);
-	vma = find_vma(mm, ul_mpu_addr);
-	if (vma)
-		dev_dbg(bridge,
-			"VMAfor UserBuf: ul_mpu_addr=%x, ul_num_bytes=%x, "
-			"vm_start=%lx, vm_end=%lx, vm_flags=%lx\n", ul_mpu_addr,
-			ul_num_bytes, vma->vm_start, vma->vm_end,
-			vma->vm_flags);
-
-	/*
-	 * It is observed that under some circumstances, the user buffer is
-	 * spread across several VMAs. So loop through and check if the entire
-	 * user buffer is covered
-	 */
-	while ((vma) && (ul_mpu_addr + ul_num_bytes > vma->vm_end)) {
-		/* jump to the next VMA region */
+	vma = find_vma(mm, uva);
+	while (vma && (uva + size > vma->vm_end))
 		vma = find_vma(mm, vma->vm_end + 1);
-		dev_dbg(bridge,
-			"VMA for UserBuf ul_mpu_addr=%x ul_num_bytes=%x, "
-			"vm_start=%lx, vm_end=%lx, vm_flags=%lx\n", ul_mpu_addr,
-			ul_num_bytes, vma->vm_start, vma->vm_end,
-			vma->vm_flags);
-	}
+
 	if (!vma) {
 		pr_err("%s: Failed to get VMA region for 0x%x (%d)\n",
-		       __func__, ul_mpu_addr, ul_num_bytes);
-		status = -EINVAL;
+						       __func__, uva, size);
 		up_read(&mm->mmap_sem);
-		goto func_cont;
+		return -EINVAL;
 	}
+	if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
+		w = 1;
+	res = get_user_pages(current, mm, uva, pages, w, 1, usr_pgs, NULL);
+	up_read(&mm->mmap_sem);
+	if (res < 0)
+		return res;
 
-	if (vma->vm_flags & VM_IO) {
-		num_usr_pgs = ul_num_bytes / PG_SIZE4K;
-		mpu_addr = ul_mpu_addr;
-
-		/* Get the physical addresses for user buffer */
-		for (pg_i = 0; pg_i < num_usr_pgs; pg_i++) {
-			pa = user_va2_pa(mm, mpu_addr);
-			if (!pa) {
-				status = -EPERM;
-				pr_err("DSPBRIDGE: VM_IO mapping physical"
-				       "address is invalid\n");
-				break;
-			}
-			if (pfn_valid(__phys_to_pfn(pa))) {
-				pg = PHYS_TO_PAGE(pa);
-				get_page(pg);
-				if (page_count(pg) < 1) {
-					pr_err("Bad page in VM_IO buffer\n");
-					bad_page_dump(pa, pg);
-				}
-			}
-			status = pte_set(dev_context->pt_attrs, pa,
-					 va, HW_PAGE_SIZE4KB, &hw_attrs);
-			if (DSP_FAILED(status))
-				break;
+	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
 
-			va += HW_PAGE_SIZE4KB;
-			mpu_addr += HW_PAGE_SIZE4KB;
-			pa += HW_PAGE_SIZE4KB;
-		}
-	} else {
-		num_usr_pgs = ul_num_bytes / PG_SIZE4K;
-		if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
-			write = 1;
-
-		for (pg_i = 0; pg_i < num_usr_pgs; pg_i++) {
-			pg_num = get_user_pages(curr_task, mm, ul_mpu_addr, 1,
-						write, 1, &mapped_page, NULL);
-			if (pg_num > 0) {
-				if (page_count(mapped_page) < 1) {
-					pr_err("Bad page count after doing"
-					       "get_user_pages on"
-					       "user buffer\n");
-					bad_page_dump(page_to_phys(mapped_page),
-						      mapped_page);
-				}
-				status = pte_set(dev_context->pt_attrs,
-						 page_to_phys(mapped_page), va,
-						 HW_PAGE_SIZE4KB, &hw_attrs);
-				if (DSP_FAILED(status))
-					break;
-
-				if (mapped_pages)
-					mapped_pages[pg_i] = mapped_page;
-
-				va += HW_PAGE_SIZE4KB;
-				ul_mpu_addr += HW_PAGE_SIZE4KB;
-			} else {
-				pr_err("DSPBRIDGE: get_user_pages FAILED,"
-				       "MPU addr = 0x%x,"
-				       "vma->vm_flags = 0x%lx,"
-				       "get_user_pages Err"
-				       "Value = %d, Buffer"
-				       "size=0x%x\n", ul_mpu_addr,
-				       vma->vm_flags, pg_num, ul_num_bytes);
-				status = -EPERM;
-				break;
-			}
-		}
-	}
-	up_read(&mm->mmap_sem);
-func_cont:
-	if (DSP_SUCCEEDED(status)) {
-		status = 0;
-	} else {
-		/*
-		 * Roll out the mapped pages incase it failed in middle of
-		 * mapping
-		 */
-		if (pg_i) {
-			bridge_brd_mem_un_map(dev_context, ulVirtAddr,
-					   (pg_i * PG_SIZE4K));
-		}
-		status = -EPERM;
+	if (!sgt)
+		return -ENOMEM;
+
+	res = sg_alloc_table(sgt, pages, GFP_KERNEL);
+
+	if (res < 0)
+		goto err_sg;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
+
+	da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+
+	if (IS_ERR_VALUE(da)) {
+		res = (int)da;
+		goto err_map;
 	}
-	/*
-	 * In any case, flush the TLB
-	 * This is called from here instead from pte_update to avoid unnecessary
-	 * repetition while mapping non-contiguous physical regions of a virtual
-	 * region
-	 */
-	flush_all(dev_context);
-	dev_dbg(bridge, "%s status %x\n", __func__, status);
-	return status;
+	return 0;
+
+err_map:
+	sg_free_table(sgt);
+err_sg:
+	kfree(sgt);
+	return res;
 }
 
 /*
@@ -1422,196 +1234,27 @@ func_cont:
  *      So, instead of looking up the PTE address for every 4K block,
  *      we clear consecutive PTEs until we unmap all the bytes
  */
-static int bridge_brd_mem_un_map(struct bridge_dev_context *hDevContext,
-				     u32 ulVirtAddr, u32 ul_num_bytes)
+static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx,
+				     u32 da, u32 size)
 {
-	u32 l1_base_va;
-	u32 l2_base_va;
-	u32 l2_base_pa;
-	u32 l2_page_num;
-	u32 pte_val;
-	u32 pte_size;
-	u32 pte_count;
-	u32 pte_addr_l1;
-	u32 pte_addr_l2 = 0;
-	u32 rem_bytes;
-	u32 rem_bytes_l2;
-	u32 va_curr;
-	struct page *pg = NULL;
-	int status = 0;
-	struct bridge_dev_context *dev_context = hDevContext;
-	struct pg_table_attrs *pt = dev_context->pt_attrs;
-	u32 temp;
-	u32 paddr;
-	u32 numof4k_pages = 0;
-
-	va_curr = ulVirtAddr;
-	rem_bytes = ul_num_bytes;
-	rem_bytes_l2 = 0;
-	l1_base_va = pt->l1_base_va;
-	pte_addr_l1 = hw_mmu_pte_addr_l1(l1_base_va, va_curr);
-	dev_dbg(bridge, "%s hDevContext %p, va %x, NumBytes %x l1_base_va %x, "
-		"pte_addr_l1 %x\n", __func__, hDevContext, ulVirtAddr,
-		ul_num_bytes, l1_base_va, pte_addr_l1);
+	unsigned i;
+	struct sg_table *sgt;
+	struct scatterlist *sg;
 
-	while (rem_bytes && (DSP_SUCCEEDED(status))) {
-		u32 va_curr_orig = va_curr;
-		/* Find whether the L1 PTE points to a valid L2 PT */
-		pte_addr_l1 = hw_mmu_pte_addr_l1(l1_base_va, va_curr);
-		pte_val = *(u32 *) pte_addr_l1;
-		pte_size = hw_mmu_pte_size_l1(pte_val);
-
-		if (pte_size != HW_MMU_COARSE_PAGE_SIZE)
-			goto skip_coarse_page;
-
-		/*
-		 * Get the L2 PA from the L1 PTE, and find
-		 * corresponding L2 VA
-		 */
-		l2_base_pa = hw_mmu_pte_coarse_l1(pte_val);
-		l2_base_va = l2_base_pa - pt->l2_base_pa + pt->l2_base_va;
-		l2_page_num =
-		    (l2_base_pa - pt->l2_base_pa) / HW_MMU_COARSE_PAGE_SIZE;
-		/*
-		 * Find the L2 PTE address from which we will start
-		 * clearing, the number of PTEs to be cleared on this
-		 * page, and the size of VA space that needs to be
-		 * cleared on this L2 page
-		 */
-		pte_addr_l2 = hw_mmu_pte_addr_l2(l2_base_va, va_curr);
-		pte_count = pte_addr_l2 & (HW_MMU_COARSE_PAGE_SIZE - 1);
-		pte_count = (HW_MMU_COARSE_PAGE_SIZE - pte_count) / sizeof(u32);
-		if (rem_bytes < (pte_count * PG_SIZE4K))
-			pte_count = rem_bytes / PG_SIZE4K;
-		rem_bytes_l2 = pte_count * PG_SIZE4K;
-
-		/*
-		 * Unmap the VA space on this L2 PT. A quicker way
-		 * would be to clear pte_count entries starting from
-		 * pte_addr_l2. However, below code checks that we don't
-		 * clear invalid entries or less than 64KB for a 64KB
-		 * entry. Similar checking is done for L1 PTEs too
-		 * below
-		 */
-		while (rem_bytes_l2 && (DSP_SUCCEEDED(status))) {
-			pte_val = *(u32 *) pte_addr_l2;
-			pte_size = hw_mmu_pte_size_l2(pte_val);
-			/* va_curr aligned to pte_size? */
-			if (pte_size == 0 || rem_bytes_l2 < pte_size ||
-			    va_curr & (pte_size - 1)) {
-				status = -EPERM;
-				break;
-			}
+	if (!size)
+		return -EINVAL;
 
-			/* Collect Physical addresses from VA */
-			paddr = (pte_val & ~(pte_size - 1));
-			if (pte_size == HW_PAGE_SIZE64KB)
-				numof4k_pages = 16;
-			else
-				numof4k_pages = 1;
-			temp = 0;
-			while (temp++ < numof4k_pages) {
-				if (!pfn_valid(__phys_to_pfn(paddr))) {
-					paddr += HW_PAGE_SIZE4KB;
-					continue;
-				}
-				pg = PHYS_TO_PAGE(paddr);
-				if (page_count(pg) < 1) {
-					pr_info("DSPBRIDGE: UNMAP function: "
-						"COUNT 0 FOR PA 0x%x, size = "
-						"0x%x\n", paddr, ul_num_bytes);
-					bad_page_dump(paddr, pg);
-				} else {
-					SetPageDirty(pg);
-					page_cache_release(pg);
-				}
-				paddr += HW_PAGE_SIZE4KB;
-			}
-			if (hw_mmu_pte_clear(pte_addr_l2, va_curr, pte_size)
-			    == RET_FAIL) {
-				status = -EPERM;
-				goto EXIT_LOOP;
-			}
+	sgt = iommu_vunmap(dev_ctx->dsp_mmu, da);
+	if (!sgt)
+		return -EFAULT;
 
-			status = 0;
-			rem_bytes_l2 -= pte_size;
-			va_curr += pte_size;
-			pte_addr_l2 += (pte_size >> 12) * sizeof(u32);
-		}
-		spin_lock(&pt->pg_lock);
-		if (rem_bytes_l2 == 0) {
-			pt->pg_info[l2_page_num].num_entries -= pte_count;
-			if (pt->pg_info[l2_page_num].num_entries == 0) {
-				/*
-				 * Clear the L1 PTE pointing to the L2 PT
-				 */
-				if (hw_mmu_pte_clear(l1_base_va, va_curr_orig,
-						     HW_MMU_COARSE_PAGE_SIZE) ==
-				    RET_OK)
-					status = 0;
-				else {
-					status = -EPERM;
-					spin_unlock(&pt->pg_lock);
-					goto EXIT_LOOP;
-				}
-			}
-			rem_bytes -= pte_count * PG_SIZE4K;
-		} else
-			status = -EPERM;
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		put_page(sg_page(sg));
 
-		spin_unlock(&pt->pg_lock);
-		continue;
-skip_coarse_page:
-		/* va_curr aligned to pte_size? */
-		/* pte_size = 1 MB or 16 MB */
-		if (pte_size == 0 || rem_bytes < pte_size ||
-		    va_curr & (pte_size - 1)) {
-			status = -EPERM;
-			break;
-		}
+	sg_free_table(sgt);
+	kfree(sgt);
 
-		if (pte_size == HW_PAGE_SIZE1MB)
-			numof4k_pages = 256;
-		else
-			numof4k_pages = 4096;
-		temp = 0;
-		/* Collect Physical addresses from VA */
-		paddr = (pte_val & ~(pte_size - 1));
-		while (temp++ < numof4k_pages) {
-			if (pfn_valid(__phys_to_pfn(paddr))) {
-				pg = PHYS_TO_PAGE(paddr);
-				if (page_count(pg) < 1) {
-					pr_info("DSPBRIDGE: UNMAP function: "
-						"COUNT 0 FOR PA 0x%x, size = "
-						"0x%x\n", paddr, ul_num_bytes);
-					bad_page_dump(paddr, pg);
-				} else {
-					SetPageDirty(pg);
-					page_cache_release(pg);
-				}
-			}
-			paddr += HW_PAGE_SIZE4KB;
-		}
-		if (hw_mmu_pte_clear(l1_base_va, va_curr, pte_size) == RET_OK) {
-			status = 0;
-			rem_bytes -= pte_size;
-			va_curr += pte_size;
-		} else {
-			status = -EPERM;
-			goto EXIT_LOOP;
-		}
-	}
-	/*
-	 * It is better to flush the TLB here, so that any stale old entries
-	 * get flushed
-	 */
-EXIT_LOOP:
-	flush_all(dev_context);
-	dev_dbg(bridge,
-		"%s: va_curr %x, pte_addr_l1 %x pte_addr_l2 %x rem_bytes %x,"
-		" rem_bytes_l2 %x status %x\n", __func__, va_curr, pte_addr_l1,
-		pte_addr_l2, rem_bytes, rem_bytes_l2, status);
-	return status;
+	return 0;
 }
 
 /*
diff --git a/drivers/dsp/bridge/core/ue_deh.c b/drivers/dsp/bridge/core/ue_deh.c
index 64e9366..ce13e6c 100644
--- a/drivers/dsp/bridge/core/ue_deh.c
+++ b/drivers/dsp/bridge/core/ue_deh.c
@@ -99,14 +99,6 @@ int bridge_deh_create(struct deh_mgr **ret_deh_mgr,
 	deh_mgr->err_info.dw_val2 = 0L;
 	deh_mgr->err_info.dw_val3 = 0L;
 
-	/* Install ISR function for DSP MMU fault */
-	if ((request_irq(INT_DSP_MMU_IRQ, mmu_fault_isr, 0,
-					"DspBridge\tiommu fault",
-					(void *)deh_mgr)) == 0)
-		status = 0;
-	else
-		status = -EPERM;
-
 err:
 	if (DSP_FAILED(status)) {
 		/* If create failed, cleanup */
@@ -131,8 +123,6 @@ int bridge_deh_destroy(struct deh_mgr *deh_mgr)
 		ntfy_delete(deh_mgr->ntfy_obj);
 		kfree(deh_mgr->ntfy_obj);
 	}
-	/* Disable DSP MMU fault */
-	free_irq(INT_DSP_MMU_IRQ, deh_mgr);
 
 	/* Free DPC object */
 	tasklet_kill(&deh_mgr->dpc_tasklet);
-- 
1.7.0.4

