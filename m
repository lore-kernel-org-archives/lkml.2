Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab0F3XwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:52:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37393 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0F3Xud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:50:33 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyo@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 4/9] dspbridge: remove custom mmu code from tiomap3430.c
Date: Wed, 30 Jun 2010 18:59:56 -0500
Message-Id: <1277942401-3566-5-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277942401-3566-4-git-send-email-x0095840@ti.com>
References: <1277942401-3566-1-git-send-email-x0095840@ti.com>
 <1277942401-3566-2-git-send-email-x0095840@ti.com>
 <1277942401-3566-3-git-send-email-x0095840@ti.com>
 <1277942401-3566-4-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all the custom mmu code remaining in
tiomap3430.c which is not needed anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/dsp/bridge/core/_tiomap.h    |    1 -
 drivers/dsp/bridge/core/tiomap3430.c |  470 ----------------------------------
 2 files changed, 0 insertions(+), 471 deletions(-)

diff --git a/drivers/dsp/bridge/core/_tiomap.h b/drivers/dsp/bridge/core/_tiomap.h
index 4aa2358..c41fd8e 100644
--- a/drivers/dsp/bridge/core/_tiomap.h
+++ b/drivers/dsp/bridge/core/_tiomap.h
@@ -356,7 +356,6 @@ struct bridge_dev_context {
 
 	/* TC Settings */
 	bool tc_word_swap_on;	/* Traffic Controller Word Swap */
-	struct pg_table_attrs *pt_attrs;
 	u32 dsp_per_clks;
 };
 
diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
index 88f5167..96cceea 100644
--- a/drivers/dsp/bridge/core/tiomap3430.c
+++ b/drivers/dsp/bridge/core/tiomap3430.c
@@ -105,56 +105,9 @@ static int bridge_dev_create(OUT struct bridge_dev_context
 static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
 				  u32 dw_cmd, IN OUT void *pargs);
 static int bridge_dev_destroy(struct bridge_dev_context *dev_context);
-static u32 user_va2_pa(struct mm_struct *mm, u32 address);
-static int pte_update(struct bridge_dev_context *hDevContext, u32 pa,
-			     u32 va, u32 size,
-			     struct hw_mmu_map_attrs_t *map_attrs);
-static int pte_set(struct pg_table_attrs *pt, u32 pa, u32 va,
-			  u32 size, struct hw_mmu_map_attrs_t *attrs);
-static int mem_map_vmalloc(struct bridge_dev_context *hDevContext,
-				  u32 ul_mpu_addr, u32 ulVirtAddr,
-				  u32 ul_num_bytes,
-				  struct hw_mmu_map_attrs_t *hw_attrs);
 
 bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr);
 
-/*  ----------------------------------- Globals */
-
-/* Attributes of L2 page tables for DSP MMU */
-struct page_info {
-	u32 num_entries;	/* Number of valid PTEs in the L2 PT */
-};
-
-/* Attributes used to manage the DSP MMU page tables */
-struct pg_table_attrs {
-	spinlock_t pg_lock;	/* Critical section object handle */
-
-	u32 l1_base_pa;		/* Physical address of the L1 PT */
-	u32 l1_base_va;		/* Virtual  address of the L1 PT */
-	u32 l1_size;		/* Size of the L1 PT */
-	u32 l1_tbl_alloc_pa;
-	/* Physical address of Allocated mem for L1 table. May not be aligned */
-	u32 l1_tbl_alloc_va;
-	/* Virtual address of Allocated mem for L1 table. May not be aligned */
-	u32 l1_tbl_alloc_sz;
-	/* Size of consistent memory allocated for L1 table.
-	 * May not be aligned */
-
-	u32 l2_base_pa;		/* Physical address of the L2 PT */
-	u32 l2_base_va;		/* Virtual  address of the L2 PT */
-	u32 l2_size;		/* Size of the L2 PT */
-	u32 l2_tbl_alloc_pa;
-	/* Physical address of Allocated mem for L2 table. May not be aligned */
-	u32 l2_tbl_alloc_va;
-	/* Virtual address of Allocated mem for L2 table. May not be aligned */
-	u32 l2_tbl_alloc_sz;
-	/* Size of consistent memory allocated for L2 table.
-	 * May not be aligned */
-
-	u32 l2_num_pages;	/* Number of allocated L2 PT */
-	/* Array [l2_num_pages] of L2 PT info structs */
-	struct page_info *pg_info;
-};
 
 /*
  *  This Bridge driver's function interface table.
@@ -210,32 +163,6 @@ static struct bridge_drv_interface drv_interface_fxns = {
 	bridge_msg_set_queue_id,
 };
 
-static inline void tlb_flush_all(const void __iomem *base)
-{
-	__raw_writeb(__raw_readb(base + MMU_GFLUSH) | 1, base + MMU_GFLUSH);
-}
-
-static inline void flush_all(struct bridge_dev_context *dev_context)
-{
-	if (dev_context->dw_brd_state == BRD_DSP_HIBERNATION ||
-	    dev_context->dw_brd_state == BRD_HIBERNATION)
-		wake_dsp(dev_context, NULL);
-
-	tlb_flush_all(dev_context->dw_dsp_mmu_base);
-}
-
-static void bad_page_dump(u32 pa, struct page *pg)
-{
-	pr_emerg("DSPBRIDGE: MAP function: COUNT 0 FOR PA 0x%x\n", pa);
-	pr_emerg("Bad page state in process '%s'\n"
-		 "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n"
-		 "Backtrace:\n",
-		 current->comm, pg, (int)(2 * sizeof(unsigned long)),
-		 (unsigned long)pg->flags, pg->mapping,
-		 page_mapcount(pg), page_count(pg));
-	dump_stack();
-}
-
 /*
  *  ======== bridge_drv_entry ========
  *  purpose:
@@ -637,7 +564,6 @@ static int bridge_brd_stop(struct bridge_dev_context *hDevContext)
 {
 	int status = 0;
 	struct bridge_dev_context *dev_context = hDevContext;
-	struct pg_table_attrs *pt_attrs;
 	u32 dsp_pwr_state;
 	int clk_status;
 	struct dspbridge_platform_data *pdata =
@@ -677,15 +603,6 @@ static int bridge_brd_stop(struct bridge_dev_context *hDevContext)
 
 	dsp_wdt_enable(false);
 
-	/* This is a good place to clear the MMU page tables as well */
-	if (dev_context->pt_attrs) {
-		pt_attrs = dev_context->pt_attrs;
-		memset((u8 *) pt_attrs->l1_base_va, 0x00, pt_attrs->l1_size);
-		memset((u8 *) pt_attrs->l2_base_va, 0x00, pt_attrs->l2_size);
-		memset((u8 *) pt_attrs->pg_info, 0x00,
-		       (pt_attrs->l2_num_pages * sizeof(struct page_info)));
-	}
-
 	/* Reset DSP */
 	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2, OMAP3430_RST1_IVA2,
 					OMAP3430_IVA2_MOD, RM_RSTCTRL);
@@ -725,7 +642,6 @@ static int bridge_brd_delete(struct bridge_dev_context *hDevContext)
 {
 	int status = 0;
 	struct bridge_dev_context *dev_context = hDevContext;
-	struct pg_table_attrs *pt_attrs;
 	int clk_status;
 	struct dspbridge_platform_data *pdata =
 				omap_dspbridge_dev->dev.platform_data;
@@ -747,15 +663,6 @@ static int bridge_brd_delete(struct bridge_dev_context *hDevContext)
 
 	dev_context->dw_brd_state = BRD_STOPPED;	/* update board state */
 
-	/* This is a good place to clear the MMU page tables as well */
-	if (dev_context->pt_attrs) {
-		pt_attrs = dev_context->pt_attrs;
-		memset((u8 *) pt_attrs->l1_base_va, 0x00, pt_attrs->l1_size);
-		memset((u8 *) pt_attrs->l2_base_va, 0x00, pt_attrs->l2_size);
-		memset((u8 *) pt_attrs->pg_info, 0x00,
-		       (pt_attrs->l2_num_pages * sizeof(struct page_info)));
-	}
-
 	/* Reset DSP */
 	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2, OMAP3430_RST1_IVA2,
 					OMAP3430_IVA2_MOD, RM_RSTCTRL);
@@ -836,10 +743,6 @@ static int bridge_dev_create(OUT struct bridge_dev_context
 	struct bridge_dev_context *dev_context = NULL;
 	s32 entry_ndx;
 	struct cfg_hostres *resources = pConfig;
-	struct pg_table_attrs *pt_attrs;
-	u32 pg_tbl_pa;
-	u32 pg_tbl_va;
-	u32 align_size;
 	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	/* Allocate and initialize a data structure to contain the bridge driver
@@ -871,97 +774,11 @@ static int bridge_dev_create(OUT struct bridge_dev_context
 	if (!dev_context->dw_dsp_base_addr)
 		status = -EPERM;
 
-	pt_attrs = kzalloc(sizeof(struct pg_table_attrs), GFP_KERNEL);
-	if (pt_attrs != NULL) {
-		/* Assuming that we use only DSP's memory map
-		 * until 0x4000:0000 , we would need only 1024
-		 * L1 enties i.e L1 size = 4K */
-		pt_attrs->l1_size = 0x1000;
-		align_size = pt_attrs->l1_size;
-		/* Align sizes are expected to be power of 2 */
-		/* we like to get aligned on L1 table size */
-		pg_tbl_va = (u32) mem_alloc_phys_mem(pt_attrs->l1_size,
-						     align_size, &pg_tbl_pa);
-
-		/* Check if the PA is aligned for us */
-		if ((pg_tbl_pa) & (align_size - 1)) {
-			/* PA not aligned to page table size ,
-			 * try with more allocation and align */
-			mem_free_phys_mem((void *)pg_tbl_va, pg_tbl_pa,
-					  pt_attrs->l1_size);
-			/* we like to get aligned on L1 table size */
-			pg_tbl_va =
-			    (u32) mem_alloc_phys_mem((pt_attrs->l1_size) * 2,
-						     align_size, &pg_tbl_pa);
-			/* We should be able to get aligned table now */
-			pt_attrs->l1_tbl_alloc_pa = pg_tbl_pa;
-			pt_attrs->l1_tbl_alloc_va = pg_tbl_va;
-			pt_attrs->l1_tbl_alloc_sz = pt_attrs->l1_size * 2;
-			/* Align the PA to the next 'align'  boundary */
-			pt_attrs->l1_base_pa =
-			    ((pg_tbl_pa) +
-			     (align_size - 1)) & (~(align_size - 1));
-			pt_attrs->l1_base_va =
-			    pg_tbl_va + (pt_attrs->l1_base_pa - pg_tbl_pa);
-		} else {
-			/* We got aligned PA, cool */
-			pt_attrs->l1_tbl_alloc_pa = pg_tbl_pa;
-			pt_attrs->l1_tbl_alloc_va = pg_tbl_va;
-			pt_attrs->l1_tbl_alloc_sz = pt_attrs->l1_size;
-			pt_attrs->l1_base_pa = pg_tbl_pa;
-			pt_attrs->l1_base_va = pg_tbl_va;
-		}
-		if (pt_attrs->l1_base_va)
-			memset((u8 *) pt_attrs->l1_base_va, 0x00,
-			       pt_attrs->l1_size);
-
-		/* number of L2 page tables = DMM pool used + SHMMEM +EXTMEM +
-		 * L4 pages */
-		pt_attrs->l2_num_pages = ((DMMPOOLSIZE >> 20) + 6);
-		pt_attrs->l2_size = HW_MMU_COARSE_PAGE_SIZE *
-		    pt_attrs->l2_num_pages;
-		align_size = 4;	/* Make it u32 aligned */
-		/* we like to get aligned on L1 table size */
-		pg_tbl_va = (u32) mem_alloc_phys_mem(pt_attrs->l2_size,
-						     align_size, &pg_tbl_pa);
-		pt_attrs->l2_tbl_alloc_pa = pg_tbl_pa;
-		pt_attrs->l2_tbl_alloc_va = pg_tbl_va;
-		pt_attrs->l2_tbl_alloc_sz = pt_attrs->l2_size;
-		pt_attrs->l2_base_pa = pg_tbl_pa;
-		pt_attrs->l2_base_va = pg_tbl_va;
-
-		if (pt_attrs->l2_base_va)
-			memset((u8 *) pt_attrs->l2_base_va, 0x00,
-			       pt_attrs->l2_size);
-
-		pt_attrs->pg_info = kzalloc(pt_attrs->l2_num_pages *
-					sizeof(struct page_info), GFP_KERNEL);
-		dev_dbg(bridge,
-			"L1 pa %x, va %x, size %x\n L2 pa %x, va "
-			"%x, size %x\n", pt_attrs->l1_base_pa,
-			pt_attrs->l1_base_va, pt_attrs->l1_size,
-			pt_attrs->l2_base_pa, pt_attrs->l2_base_va,
-			pt_attrs->l2_size);
-		dev_dbg(bridge, "pt_attrs %p L2 NumPages %x pg_info %p\n",
-			pt_attrs, pt_attrs->l2_num_pages, pt_attrs->pg_info);
-	}
-	if ((pt_attrs != NULL) && (pt_attrs->l1_base_va != 0) &&
-	    (pt_attrs->l2_base_va != 0) && (pt_attrs->pg_info != NULL))
-		dev_context->pt_attrs = pt_attrs;
-	else
-		status = -ENOMEM;
-
 	if (DSP_SUCCEEDED(status)) {
-		spin_lock_init(&pt_attrs->pg_lock);
 		dev_context->tc_word_swap_on = drv_datap->tc_wordswapon;
-
-		/* Set the Clock Divisor for the DSP module */
-		udelay(5);
 		/* MMU address is obtained from the host
 		 * resources struct */
 		dev_context->dw_dsp_mmu_base = resources->dw_dmmu_base;
-	}
-	if (DSP_SUCCEEDED(status)) {
 		dev_context->hdev_obj = hdev_obj;
 		dev_context->ul_int_mask = 0;
 		/* Store current board state. */
@@ -970,23 +787,6 @@ static int bridge_dev_create(OUT struct bridge_dev_context
 		/* Return ptr to our device state to the DSP API for storage */
 		*ppDevContext = dev_context;
 	} else {
-		if (pt_attrs != NULL) {
-			kfree(pt_attrs->pg_info);
-
-			if (pt_attrs->l2_tbl_alloc_va) {
-				mem_free_phys_mem((void *)
-						  pt_attrs->l2_tbl_alloc_va,
-						  pt_attrs->l2_tbl_alloc_pa,
-						  pt_attrs->l2_tbl_alloc_sz);
-			}
-			if (pt_attrs->l1_tbl_alloc_va) {
-				mem_free_phys_mem((void *)
-						  pt_attrs->l1_tbl_alloc_va,
-						  pt_attrs->l1_tbl_alloc_pa,
-						  pt_attrs->l1_tbl_alloc_sz);
-			}
-		}
-		kfree(pt_attrs);
 		kfree(dev_context);
 	}
 func_end:
@@ -1054,7 +854,6 @@ static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
  */
 static int bridge_dev_destroy(struct bridge_dev_context *hDevContext)
 {
-	struct pg_table_attrs *pt_attrs;
 	int status = 0;
 	struct bridge_dev_context *dev_context = (struct bridge_dev_context *)
 	    hDevContext;
@@ -1068,23 +867,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *hDevContext)
 
 	/* first put the device to stop state */
 	bridge_brd_delete(dev_context);
-	if (dev_context->pt_attrs) {
-		pt_attrs = dev_context->pt_attrs;
-		kfree(pt_attrs->pg_info);
-
-		if (pt_attrs->l2_tbl_alloc_va) {
-			mem_free_phys_mem((void *)pt_attrs->l2_tbl_alloc_va,
-					  pt_attrs->l2_tbl_alloc_pa,
-					  pt_attrs->l2_tbl_alloc_sz);
-		}
-		if (pt_attrs->l1_tbl_alloc_va) {
-			mem_free_phys_mem((void *)pt_attrs->l1_tbl_alloc_va,
-					  pt_attrs->l1_tbl_alloc_pa,
-					  pt_attrs->l1_tbl_alloc_sz);
-		}
-		kfree(pt_attrs);
-
-	}
 
 	if (dev_context->resources) {
 		host_res = dev_context->resources;
@@ -1315,258 +1097,6 @@ int user_to_dsp_unmap(struct iommu *mmu, u32 da)
 }
 
 /*
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
-/*
- *  ======== pte_update ========
- *      This function calculates the optimum page-aligned addresses and sizes
- *      Caller must pass page-aligned values
- */
-static int pte_update(struct bridge_dev_context *hDevContext, u32 pa,
-			     u32 va, u32 size,
-			     struct hw_mmu_map_attrs_t *map_attrs)
-{
-	u32 i;
-	u32 all_bits;
-	u32 pa_curr = pa;
-	u32 va_curr = va;
-	u32 num_bytes = size;
-	struct bridge_dev_context *dev_context = hDevContext;
-	int status = 0;
-	u32 page_size[] = { HW_PAGE_SIZE16MB, HW_PAGE_SIZE1MB,
-		HW_PAGE_SIZE64KB, HW_PAGE_SIZE4KB
-	};
-
-	while (num_bytes && DSP_SUCCEEDED(status)) {
-		/* To find the max. page size with which both PA & VA are
-		 * aligned */
-		all_bits = pa_curr | va_curr;
-
-		for (i = 0; i < 4; i++) {
-			if ((num_bytes >= page_size[i]) && ((all_bits &
-							     (page_size[i] -
-							      1)) == 0)) {
-				status =
-				    pte_set(dev_context->pt_attrs, pa_curr,
-					    va_curr, page_size[i], map_attrs);
-				pa_curr += page_size[i];
-				va_curr += page_size[i];
-				num_bytes -= page_size[i];
-				/* Don't try smaller sizes. Hopefully we have
-				 * reached an address aligned to a bigger page
-				 * size */
-				break;
-			}
-		}
-	}
-
-	return status;
-}
-
-/*
- *  ======== pte_set ========
- *      This function calculates PTE address (MPU virtual) to be updated
- *      It also manages the L2 page tables
- */
-static int pte_set(struct pg_table_attrs *pt, u32 pa, u32 va,
-			  u32 size, struct hw_mmu_map_attrs_t *attrs)
-{
-	u32 i;
-	u32 pte_val;
-	u32 pte_addr_l1;
-	u32 pte_size;
-	/* Base address of the PT that will be updated */
-	u32 pg_tbl_va;
-	u32 l1_base_va;
-	/* Compiler warns that the next three variables might be used
-	 * uninitialized in this function. Doesn't seem so. Working around,
-	 * anyways. */
-	u32 l2_base_va = 0;
-	u32 l2_base_pa = 0;
-	u32 l2_page_num = 0;
-	int status = 0;
-
-	l1_base_va = pt->l1_base_va;
-	pg_tbl_va = l1_base_va;
-	if ((size == HW_PAGE_SIZE64KB) || (size == HW_PAGE_SIZE4KB)) {
-		/* Find whether the L1 PTE points to a valid L2 PT */
-		pte_addr_l1 = hw_mmu_pte_addr_l1(l1_base_va, va);
-		if (pte_addr_l1 <= (pt->l1_base_va + pt->l1_size)) {
-			pte_val = *(u32 *) pte_addr_l1;
-			pte_size = hw_mmu_pte_size_l1(pte_val);
-		} else {
-			return -EPERM;
-		}
-		spin_lock(&pt->pg_lock);
-		if (pte_size == HW_MMU_COARSE_PAGE_SIZE) {
-			/* Get the L2 PA from the L1 PTE, and find
-			 * corresponding L2 VA */
-			l2_base_pa = hw_mmu_pte_coarse_l1(pte_val);
-			l2_base_va =
-			    l2_base_pa - pt->l2_base_pa + pt->l2_base_va;
-			l2_page_num =
-			    (l2_base_pa -
-			     pt->l2_base_pa) / HW_MMU_COARSE_PAGE_SIZE;
-		} else if (pte_size == 0) {
-			/* L1 PTE is invalid. Allocate a L2 PT and
-			 * point the L1 PTE to it */
-			/* Find a free L2 PT. */
-			for (i = 0; (i < pt->l2_num_pages) &&
-			     (pt->pg_info[i].num_entries != 0); i++)
-				;;
-			if (i < pt->l2_num_pages) {
-				l2_page_num = i;
-				l2_base_pa = pt->l2_base_pa + (l2_page_num *
-						HW_MMU_COARSE_PAGE_SIZE);
-				l2_base_va = pt->l2_base_va + (l2_page_num *
-						HW_MMU_COARSE_PAGE_SIZE);
-				/* Endianness attributes are ignored for
-				 * HW_MMU_COARSE_PAGE_SIZE */
-				status =
-				    hw_mmu_pte_set(l1_base_va, l2_base_pa, va,
-						   HW_MMU_COARSE_PAGE_SIZE,
-						   attrs);
-			} else {
-				status = -ENOMEM;
-			}
-		} else {
-			/* Found valid L1 PTE of another size.
-			 * Should not overwrite it. */
-			status = -EPERM;
-		}
-		if (DSP_SUCCEEDED(status)) {
-			pg_tbl_va = l2_base_va;
-			if (size == HW_PAGE_SIZE64KB)
-				pt->pg_info[l2_page_num].num_entries += 16;
-			else
-				pt->pg_info[l2_page_num].num_entries++;
-			dev_dbg(bridge, "PTE: L2 BaseVa %x, BasePa %x, PageNum "
-				"%x, num_entries %x\n", l2_base_va,
-				l2_base_pa, l2_page_num,
-				pt->pg_info[l2_page_num].num_entries);
-		}
-		spin_unlock(&pt->pg_lock);
-	}
-	if (DSP_SUCCEEDED(status)) {
-		dev_dbg(bridge, "PTE: pg_tbl_va %x, pa %x, va %x, size %x\n",
-			pg_tbl_va, pa, va, size);
-		dev_dbg(bridge, "PTE: endianism %x, element_size %x, "
-			"mixed_size %x\n", attrs->endianism,
-			attrs->element_size, attrs->mixed_size);
-		status = hw_mmu_pte_set(pg_tbl_va, pa, va, size, attrs);
-	}
-
-	return status;
-}
-
-/* Memory map kernel VA -- memory allocated with vmalloc */
-static int mem_map_vmalloc(struct bridge_dev_context *dev_context,
-				  u32 ul_mpu_addr, u32 ulVirtAddr,
-				  u32 ul_num_bytes,
-				  struct hw_mmu_map_attrs_t *hw_attrs)
-{
-	int status = 0;
-	struct page *page[1];
-	u32 i;
-	u32 pa_curr;
-	u32 pa_next;
-	u32 va_curr;
-	u32 size_curr;
-	u32 num_pages;
-	u32 pa;
-	u32 num_of4k_pages;
-	u32 temp = 0;
-
-	/*
-	 * Do Kernel va to pa translation.
-	 * Combine physically contiguous regions to reduce TLBs.
-	 * Pass the translated pa to pte_update.
-	 */
-	num_pages = ul_num_bytes / PAGE_SIZE;	/* PAGE_SIZE = OS page size */
-	i = 0;
-	va_curr = ul_mpu_addr;
-	page[0] = vmalloc_to_page((void *)va_curr);
-	pa_next = page_to_phys(page[0]);
-	while (DSP_SUCCEEDED(status) && (i < num_pages)) {
-		/*
-		 * Reuse pa_next from the previous iteraion to avoid
-		 * an extra va2pa call
-		 */
-		pa_curr = pa_next;
-		size_curr = PAGE_SIZE;
-		/*
-		 * If the next page is physically contiguous,
-		 * map it with the current one by increasing
-		 * the size of the region to be mapped
-		 */
-		while (++i < num_pages) {
-			page[0] =
-			    vmalloc_to_page((void *)(va_curr + size_curr));
-			pa_next = page_to_phys(page[0]);
-
-			if (pa_next == (pa_curr + size_curr))
-				size_curr += PAGE_SIZE;
-			else
-				break;
-
-		}
-		if (pa_next == 0) {
-			status = -ENOMEM;
-			break;
-		}
-		pa = pa_curr;
-		num_of4k_pages = size_curr / HW_PAGE_SIZE4KB;
-		while (temp++ < num_of4k_pages) {
-			get_page(PHYS_TO_PAGE(pa));
-			pa += HW_PAGE_SIZE4KB;
-		}
-		status = pte_update(dev_context, pa_curr, ulVirtAddr +
-				    (va_curr - ul_mpu_addr), size_curr,
-				    hw_attrs);
-		va_curr += size_curr;
-	}
-	if (DSP_SUCCEEDED(status))
-		status = 0;
-	else
-		status = -EPERM;
-
-	/*
-	 * In any case, flush the TLB
-	 * This is called from here instead from pte_update to avoid unnecessary
-	 * repetition while mapping non-contiguous physical regions of a virtual
-	 * region
-	 */
-	flush_all(dev_context);
-	dev_dbg(bridge, "%s status %x\n", __func__, status);
-	return status;
-}
-
-/*
  *  ======== wait_for_start ========
  *      Wait for the singal from DSP that it has started, or time out.
  */
-- 
1.7.0.4

