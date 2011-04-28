Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360Ab1D1Pob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:44:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43435 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262Ab1D1PnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:17 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: [PATCH v4 4/6] staging: tidspbridge: remove custom mmu code
Date: Thu, 28 Apr 2011 10:31:50 -0500
Message-Id: <1304004712-8487-5-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Guzman Lugo <x0095840@ti.com>

This code is not needed anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/Makefile               |    3 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |    3 -
 drivers/staging/tidspbridge/core/io_sm.c           |    4 -
 drivers/staging/tidspbridge/core/tiomap3430.c      |  427 ---------------
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    4 -
 drivers/staging/tidspbridge/core/tiomap_io.c       |    2 +-
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 --
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 ---
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 --------
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 --
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  562 --------------------
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  163 ------
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 -
 .../staging/tidspbridge/include/dspbridge/drv.h    |    3 -
 .../tidspbridge/include/dspbridge/dspioctl.h       |    7 -
 drivers/staging/tidspbridge/rmgr/drv.c             |    4 -
 16 files changed, 2 insertions(+), 1581 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index fd6a276..9c7f974 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -11,10 +11,9 @@ librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
 		rmgr/nldr.o rmgr/drv_interface.o
 libdload = dynload/cload.o dynload/getsection.o dynload/reloc.o \
 		 dynload/tramp.o
-libhw = hw/hw_mmu.o
 
 bridgedriver-y := $(libgen) $(libservices) $(libcore) $(libpmgr) $(librmgr) \
-			$(libdload) $(libhw)
+			$(libdload)
 
 #Machine dependent
 ccflags-y += -D_TI_ -D_DB_TIOMAP -DTMS32060 \
diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index d493e11..49a035a 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -37,7 +37,6 @@
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 #include <dspbridge/devdefs.h>
-#include <hw_defs.h>
 #include <dspbridge/dspioctl.h>	/* for bridge_ioctl_extproc defn */
 #include <dspbridge/sync.h>
 #include <dspbridge/clk.h>
@@ -340,7 +339,6 @@ struct bridge_dev_context {
 	 */
 	u32 dsp_ext_base_addr;	/* See the comment above */
 	u32 api_reg_base;	/* API mem map'd registers */
-	void __iomem *dsp_mmu_base;	/* DSP MMU Mapped registers */
 	u32 api_clk_base;	/* CLK Registers */
 	u32 dsp_clk_m2_base;	/* DSP Clock Module m2 */
 	u32 public_rhea;	/* Pub Rhea */
@@ -366,7 +364,6 @@ struct bridge_dev_context {
 
 	/* TC Settings */
 	bool tc_word_swap_on;	/* Traffic Controller Word Swap */
-	struct pg_table_attrs *pt_attrs;
 	u32 dsp_per_clks;
 };
 
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 3558658..8408d51 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -40,10 +40,6 @@
 #include <dspbridge/ntfy.h>
 #include <dspbridge/sync.h>
 
-/* Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /* Bridge Driver */
 #include <dspbridge/dspdeh.h>
 #include <dspbridge/dspio.h>
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 692a456..e9b2ce0 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -35,10 +35,6 @@
 #include <dspbridge/drv.h>
 #include <dspbridge/sync.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*  ----------------------------------- Link Driver */
 #include <dspbridge/dspdefs.h>
 #include <dspbridge/dspchnl.h>
@@ -127,56 +123,10 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt);
 static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
 						struct page **usr_pgs);
 static u32 user_va2_pa(struct mm_struct *mm, u32 address);
-static int pte_update(struct bridge_dev_context *dev_ctxt, u32 pa,
-			     u32 va, u32 size,
-			     struct hw_mmu_map_attrs_t *map_attrs);
-static int pte_set(struct pg_table_attrs *pt, u32 pa, u32 va,
-			  u32 size, struct hw_mmu_map_attrs_t *attrs);
-static int mem_map_vmalloc(struct bridge_dev_context *dev_context,
-				  u32 ul_mpu_addr, u32 virt_addr,
-				  u32 ul_num_bytes,
-				  struct hw_mmu_map_attrs_t *hw_attrs);
-
 bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr);
 
 /*  ----------------------------------- Globals */
 
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
-
 /*
  *  This Bridge driver's function interface table.
  */
@@ -252,27 +202,6 @@ static inline u32 dsptlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa,
 }
 #endif /* !ARCH_HAS_SG_CHAIN */
 
-static inline void flush_all(struct bridge_dev_context *dev_context)
-{
-	if (dev_context->brd_state == BRD_DSP_HIBERNATION ||
-	    dev_context->brd_state == BRD_HIBERNATION)
-		wake_dsp(dev_context, NULL);
-
-	hw_mmu_tlb_flush_all(dev_context->dsp_mmu_base);
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
@@ -709,7 +638,6 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 {
 	int status = 0;
 	struct bridge_dev_context *dev_context = dev_ctxt;
-	struct pg_table_attrs *pt_attrs;
 	u32 dsp_pwr_state;
 	int i;
 	struct bridge_ioctl_extproc *tlb = dev_context->atlb_entry;
@@ -748,14 +676,6 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 
 	dsp_wdt_enable(false);
 
-	/* This is a good place to clear the MMU page tables as well */
-	if (dev_context->pt_attrs) {
-		pt_attrs = dev_context->pt_attrs;
-		memset((u8 *) pt_attrs->l1_base_va, 0x00, pt_attrs->l1_size);
-		memset((u8 *) pt_attrs->l2_base_va, 0x00, pt_attrs->l2_size);
-		memset((u8 *) pt_attrs->pg_info, 0x00,
-		       (pt_attrs->l2_num_pages * sizeof(struct page_info)));
-	}
 	/* Reset DSP */
 	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2_MASK,
 		OMAP3430_RST1_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
@@ -855,10 +775,6 @@ static int bridge_dev_create(struct bridge_dev_context
 	struct bridge_dev_context *dev_context = NULL;
 	s32 entry_ndx;
 	struct cfg_hostres *resources = config_param;
-	struct pg_table_attrs *pt_attrs;
-	u32 pg_tbl_pa;
-	u32 pg_tbl_va;
-	u32 align_size;
 	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
 	/* Allocate and initialize a data structure to contain the bridge driver
@@ -889,94 +805,8 @@ static int bridge_dev_create(struct bridge_dev_context
 	if (!dev_context->dsp_base_addr)
 		status = -EPERM;
 
-	pt_attrs = kzalloc(sizeof(struct pg_table_attrs), GFP_KERNEL);
-	if (pt_attrs != NULL) {
-		pt_attrs->l1_size = SZ_16K; /* 4096 entries of 32 bits */
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
 	if (!status) {
-		spin_lock_init(&pt_attrs->pg_lock);
 		dev_context->tc_word_swap_on = drv_datap->tc_wordswapon;
-
-		/* Set the Clock Divisor for the DSP module */
-		udelay(5);
-		/* MMU address is obtained from the host
-		 * resources struct */
-		dev_context->dsp_mmu_base = resources->dmmu_base;
-	}
-	if (!status) {
 		dev_context->dev_obj = hdev_obj;
 		/* Store current board state. */
 		dev_context->brd_state = BRD_UNKNOWN;
@@ -986,23 +816,6 @@ static int bridge_dev_create(struct bridge_dev_context
 		/* Return ptr to our device state to the DSP API for storage */
 		*dev_cntxt = dev_context;
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
@@ -1070,7 +883,6 @@ static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
  */
 static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 {
-	struct pg_table_attrs *pt_attrs;
 	int status = 0;
 	struct bridge_dev_context *dev_context = (struct bridge_dev_context *)
 	    dev_ctxt;
@@ -1084,23 +896,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 
 	/* first put the device to stop state */
 	bridge_brd_stop(dev_context);
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
@@ -1131,8 +926,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 			iounmap((void *)host_res->mem_base[3]);
 		if (host_res->mem_base[4])
 			iounmap((void *)host_res->mem_base[4]);
-		if (host_res->dmmu_base)
-			iounmap(host_res->dmmu_base);
 		if (host_res->per_base)
 			iounmap(host_res->per_base);
 		if (host_res->per_pm_base)
@@ -1144,7 +937,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 		host_res->mem_base[2] = (u32) NULL;
 		host_res->mem_base[3] = (u32) NULL;
 		host_res->mem_base[4] = (u32) NULL;
-		host_res->dmmu_base = NULL;
 
 		kfree(host_res);
 	}
@@ -1430,225 +1222,6 @@ static u32 user_va2_pa(struct mm_struct *mm, u32 address)
 }
 
 /*
- *  ======== pte_update ========
- *      This function calculates the optimum page-aligned addresses and sizes
- *      Caller must pass page-aligned values
- */
-static int pte_update(struct bridge_dev_context *dev_ctxt, u32 pa,
-			     u32 va, u32 size,
-			     struct hw_mmu_map_attrs_t *map_attrs)
-{
-	u32 i;
-	u32 all_bits;
-	u32 pa_curr = pa;
-	u32 va_curr = va;
-	u32 num_bytes = size;
-	struct bridge_dev_context *dev_context = dev_ctxt;
-	int status = 0;
-	u32 page_size[] = { HW_PAGE_SIZE16MB, HW_PAGE_SIZE1MB,
-		HW_PAGE_SIZE64KB, HW_PAGE_SIZE4KB
-	};
-
-	while (num_bytes && !status) {
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
-				;
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
-		if (!status) {
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
-	if (!status) {
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
-				  u32 ul_mpu_addr, u32 virt_addr,
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
-	while (!status && (i < num_pages)) {
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
-		status = pte_update(dev_context, pa_curr, virt_addr +
-				    (va_curr - ul_mpu_addr), size_curr,
-				    hw_attrs);
-		va_curr += size_curr;
-	}
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
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index 0d6bc4f..9aa6fd9 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -31,10 +31,6 @@
 #include <dspbridge/dev.h>
 #include <dspbridge/io.h>
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 #include <dspbridge/pwr.h>
 
 /*  ----------------------------------- Bridge Driver */
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index ab221f1..8c52041 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -143,7 +143,7 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 				    ul_shm_base_virt - ul_tlb_base_virt;
 				ul_shm_offset_virt +=
 				    PG_ALIGN_HIGH(ul_ext_end - ul_dyn_ext_base +
-						  1, HW_PAGE_SIZE64KB);
+						  1, SZ_64K);
 				dw_ext_prog_virt_mem -= ul_shm_offset_virt;
 				dw_ext_prog_virt_mem +=
 				    (ul_ext_base - ul_dyn_ext_base);
diff --git a/drivers/staging/tidspbridge/hw/EasiGlobal.h b/drivers/staging/tidspbridge/hw/EasiGlobal.h
deleted file mode 100644
index e48d7f6..0000000
--- a/drivers/staging/tidspbridge/hw/EasiGlobal.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/*
- * EasiGlobal.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _EASIGLOBAL_H
-#define _EASIGLOBAL_H
-#include <linux/types.h>
-
-/*
- * DEFINE:        READ_ONLY, WRITE_ONLY &  READ_WRITE
- *
- * DESCRIPTION: Defines used to describe register types for EASI-checker tests.
- */
-
-#define READ_ONLY    1
-#define WRITE_ONLY   2
-#define READ_WRITE   3
-
-/*
- * MACRO:        _DEBUG_LEVEL1_EASI
- *
- * DESCRIPTION:  A MACRO which can be used to indicate that a particular beach
- *               register access function was called.
- *
- * NOTE:         We currently dont use this functionality.
- */
-#define _DEBUG_LEVEL1_EASI(easi_num)     ((void)0)
-
-#endif /* _EASIGLOBAL_H */
diff --git a/drivers/staging/tidspbridge/hw/MMUAccInt.h b/drivers/staging/tidspbridge/hw/MMUAccInt.h
deleted file mode 100644
index 1cefca3..0000000
--- a/drivers/staging/tidspbridge/hw/MMUAccInt.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * MMUAccInt.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _MMU_ACC_INT_H
-#define _MMU_ACC_INT_H
-
-/* Mappings of level 1 EASI function numbers to function names */
-
-#define EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32 (MMU_BASE_EASIL1 + 3)
-#define EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32  (MMU_BASE_EASIL1 + 17)
-#define EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32    (MMU_BASE_EASIL1 + 39)
-#define EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 51)
-#define EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32 (MMU_BASE_EASIL1 + 102)
-#define EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32 (MMU_BASE_EASIL1 + 103)
-#define EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32 (MMU_BASE_EASIL1 + 156)
-#define EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32 (MMU_BASE_EASIL1 + 174)
-#define EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32   (MMU_BASE_EASIL1 + 180)
-#define EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32     (MMU_BASE_EASIL1 + 190)
-#define EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32   (MMU_BASE_EASIL1 + 194)
-#define EASIL1_MMUMMU_TTB_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 198)
-#define EASIL1_MMUMMU_LOCK_READ_REGISTER32   (MMU_BASE_EASIL1 + 203)
-#define EASIL1_MMUMMU_LOCK_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 204)
-#define EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32  (MMU_BASE_EASIL1 + 205)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32 (MMU_BASE_EASIL1 + 209)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32 (MMU_BASE_EASIL1 + 211)
-#define EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32  (MMU_BASE_EASIL1 + 212)
-#define EASIL1_MMUMMU_LD_TLB_READ_REGISTER32    (MMU_BASE_EASIL1 + 213)
-#define EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 214)
-#define EASIL1_MMUMMU_CAM_WRITE_REGISTER32   (MMU_BASE_EASIL1 + 226)
-#define EASIL1_MMUMMU_RAM_WRITE_REGISTER32 (MMU_BASE_EASIL1 + 268)
-#define EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32  (MMU_BASE_EASIL1 + 322)
-
-/* Register offset address definitions */
-#define MMU_MMU_SYSCONFIG_OFFSET   0x10
-#define MMU_MMU_IRQSTATUS_OFFSET  0x18
-#define MMU_MMU_IRQENABLE_OFFSET    0x1c
-#define MMU_MMU_WALKING_ST_OFFSET 0x40
-#define MMU_MMU_CNTL_OFFSET   0x44
-#define MMU_MMU_FAULT_AD_OFFSET  0x48
-#define MMU_MMU_TTB_OFFSET  0x4c
-#define MMU_MMU_LOCK_OFFSET   0x50
-#define MMU_MMU_LD_TLB_OFFSET  0x54
-#define MMU_MMU_CAM_OFFSET   0x58
-#define MMU_MMU_RAM_OFFSET   0x5c
-#define MMU_MMU_GFLUSH_OFFSET  0x60
-#define MMU_MMU_FLUSH_ENTRY_OFFSET  0x64
-/* Bitfield mask and offset declarations */
-#define MMU_MMU_SYSCONFIG_IDLE_MODE_MASK  0x18
-#define MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET  3
-#define MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK  0x1
-#define MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET   0
-#define MMU_MMU_WALKING_ST_TWL_RUNNING_MASK 0x1
-#define MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET  0
-#define MMU_MMU_CNTL_TWL_ENABLE_MASK 0x4
-#define MMU_MMU_CNTL_TWL_ENABLE_OFFSET 2
-#define MMU_MMU_CNTL_MMU_ENABLE_MASK    0x2
-#define MMU_MMU_CNTL_MMU_ENABLE_OFFSET   1
-#define MMU_MMU_LOCK_BASE_VALUE_MASK 0xfc00
-#define MMU_MMU_LOCK_BASE_VALUE_OFFSET   10
-#define MMU_MMU_LOCK_CURRENT_VICTIM_MASK   0x3f0
-#define MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET    4
-
-#endif /* _MMU_ACC_INT_H */
diff --git a/drivers/staging/tidspbridge/hw/MMURegAcM.h b/drivers/staging/tidspbridge/hw/MMURegAcM.h
deleted file mode 100644
index ab1a16d..0000000
--- a/drivers/staging/tidspbridge/hw/MMURegAcM.h
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * MMURegAcM.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _MMU_REG_ACM_H
-#define _MMU_REG_ACM_H
-
-#include <linux/io.h>
-#include <EasiGlobal.h>
-
-#include "MMUAccInt.h"
-
-#if defined(USE_LEVEL_1_MACROS)
-
-#define MMUMMU_SYSCONFIG_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_SYSCONFIG_OFFSET))
-
-#define MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_IDLE_MODE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_IDLE_MODE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_IDLE_MODE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_IDLE_MODE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_SYSCONFIG_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_SYSCONFIG_AUTO_IDLE_WRITE32);\
-    data &= ~(MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK);\
-    new_value <<= MMU_MMU_SYSCONFIG_AUTO_IDLE_OFFSET;\
-    new_value &= MMU_MMU_SYSCONFIG_AUTO_IDLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_IRQSTATUS_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(easil1_mmummu_irqstatus_read_register32),\
-      __raw_readl((base_address)+MMU_MMU_IRQSTATUS_OFFSET))
-
-#define MMUMMU_IRQSTATUS_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_IRQSTATUS_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQSTATUS_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_IRQENABLE_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_IRQENABLE_OFFSET))
-
-#define MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_IRQENABLE_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_IRQENABLE_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_WALKING_STTWL_RUNNING_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_WALKING_STTWL_RUNNING_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_WALKING_ST_OFFSET))))\
-      & MMU_MMU_WALKING_ST_TWL_RUNNING_MASK) >>\
-      MMU_MMU_WALKING_ST_TWL_RUNNING_OFFSET))
-
-#define MMUMMU_CNTLTWL_ENABLE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_CNTL_OFFSET)))) &\
-      MMU_MMU_CNTL_TWL_ENABLE_MASK) >>\
-      MMU_MMU_CNTL_TWL_ENABLE_OFFSET))
-
-#define MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLTWL_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_TWL_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_TWL_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_TWL_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_CNTL_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CNTLMMU_ENABLE_WRITE32);\
-    data &= ~(MMU_MMU_CNTL_MMU_ENABLE_MASK);\
-    new_value <<= MMU_MMU_CNTL_MMU_ENABLE_OFFSET;\
-    new_value &= MMU_MMU_CNTL_MMU_ENABLE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_FAULT_AD_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FAULT_AD_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_FAULT_AD_OFFSET))
-
-#define MMUMMU_TTB_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_TTB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_TTB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_LOCK_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LOCK_OFFSET))
-
-#define MMUMMU_LOCK_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_LOCK_BASE_VALUE_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_BASE_VALUE_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_BASE_VALUE_MASK) >>\
-      MMU_MMU_LOCK_BASE_VALUE_OFFSET))
-
-#define MMUMMU_LOCK_BASE_VALUE_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(easil1_mmummu_lock_base_value_write32);\
-    data &= ~(MMU_MMU_LOCK_BASE_VALUE_MASK);\
-    new_value <<= MMU_MMU_LOCK_BASE_VALUE_OFFSET;\
-    new_value &= MMU_MMU_LOCK_BASE_VALUE_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_READ32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_READ32),\
-      (((__raw_readl(((base_address)+(MMU_MMU_LOCK_OFFSET)))) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK) >>\
-      MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET))
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LOCK_OFFSET;\
-    register u32 data = __raw_readl((base_address)+offset);\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_WRITE32);\
-    data &= ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK);\
-    new_value <<= MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET;\
-    new_value &= MMU_MMU_LOCK_CURRENT_VICTIM_MASK;\
-    new_value |= data;\
-    __raw_writel(new_value, base_address+offset);\
-}
-
-#define MMUMMU_LOCK_CURRENT_VICTIM_SET32(var, value)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LOCK_CURRENT_VICTIM_SET32),\
-      (((var) & ~(MMU_MMU_LOCK_CURRENT_VICTIM_MASK)) |\
-      (((value) << MMU_MMU_LOCK_CURRENT_VICTIM_OFFSET) &\
-      MMU_MMU_LOCK_CURRENT_VICTIM_MASK)))
-
-#define MMUMMU_LD_TLB_READ_REGISTER32(base_address)\
-    (_DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_READ_REGISTER32),\
-      __raw_readl((base_address)+MMU_MMU_LD_TLB_OFFSET))
-
-#define MMUMMU_LD_TLB_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_LD_TLB_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_LD_TLB_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_CAM_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_CAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_CAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_RAM_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_RAM_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_RAM_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#define MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(base_address, value)\
-{\
-    const u32 offset = MMU_MMU_FLUSH_ENTRY_OFFSET;\
-    register u32 new_value = (value);\
-    _DEBUG_LEVEL1_EASI(EASIL1_MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32);\
-    __raw_writel(new_value, (base_address)+offset);\
-}
-
-#endif /* USE_LEVEL_1_MACROS */
-
-#endif /* _MMU_REG_ACM_H */
diff --git a/drivers/staging/tidspbridge/hw/hw_defs.h b/drivers/staging/tidspbridge/hw/hw_defs.h
deleted file mode 100644
index d5266d4..0000000
--- a/drivers/staging/tidspbridge/hw/hw_defs.h
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * hw_defs.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Global HW definitions
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _HW_DEFS_H
-#define _HW_DEFS_H
-
-/* Page size */
-#define HW_PAGE_SIZE4KB   0x1000
-#define HW_PAGE_SIZE64KB  0x10000
-#define HW_PAGE_SIZE1MB   0x100000
-#define HW_PAGE_SIZE16MB  0x1000000
-
-/* hw_status:  return type for HW API */
-typedef long hw_status;
-
-/*  Macro used to set and clear any bit */
-#define HW_CLEAR	0
-#define HW_SET		1
-
-/* hw_endianism_t:  Enumerated Type used to specify the endianism
- *		Do NOT change these values. They are used as bit fields. */
-enum hw_endianism_t {
-	HW_LITTLE_ENDIAN,
-	HW_BIG_ENDIAN
-};
-
-/* hw_element_size_t:  Enumerated Type used to specify the element size
- *		Do NOT change these values. They are used as bit fields. */
-enum hw_element_size_t {
-	HW_ELEM_SIZE8BIT,
-	HW_ELEM_SIZE16BIT,
-	HW_ELEM_SIZE32BIT,
-	HW_ELEM_SIZE64BIT
-};
-
-/* hw_idle_mode_t:  Enumerated Type used to specify Idle modes */
-enum hw_idle_mode_t {
-	HW_FORCE_IDLE,
-	HW_NO_IDLE,
-	HW_SMART_IDLE
-};
-
-#endif /* _HW_DEFS_H */
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
deleted file mode 100644
index c214df9..0000000
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ /dev/null
@@ -1,562 +0,0 @@
-/*
- * hw_mmu.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * API definitions to setup MMU TLB and PTE
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#include <linux/io.h>
-#include "MMURegAcM.h"
-#include <hw_defs.h>
-#include <hw_mmu.h>
-#include <linux/types.h>
-#include <linux/err.h>
-
-#define MMU_BASE_VAL_MASK	0xFC00
-#define MMU_PAGE_MAX	     3
-#define MMU_ELEMENTSIZE_MAX      3
-#define MMU_ADDR_MASK	    0xFFFFF000
-#define MMU_TTB_MASK	     0xFFFFC000
-#define MMU_SECTION_ADDR_MASK    0xFFF00000
-#define MMU_SSECTION_ADDR_MASK   0xFF000000
-#define MMU_PAGE_TABLE_MASK      0xFFFFFC00
-#define MMU_LARGE_PAGE_MASK      0xFFFF0000
-#define MMU_SMALL_PAGE_MASK      0xFFFFF000
-
-#define MMU_LOAD_TLB	0x00000001
-#define MMU_GFLUSH	0x60
-
-/*
- * hw_mmu_page_size_t: Enumerated Type used to specify the MMU Page Size(SLSS)
- */
-enum hw_mmu_page_size_t {
-	HW_MMU_SECTION,
-	HW_MMU_LARGE_PAGE,
-	HW_MMU_SMALL_PAGE,
-	HW_MMU_SUPERSECTION
-};
-
-/*
- * FUNCTION	      : mmu_flush_entry
- *
- * INPUTS:
- *
- *       Identifier      : base_address
- *       Type		: const u32
- *       Description     : Base Address of instance of MMU module
- *
- * RETURNS:
- *
- *       Type		: hw_status
- *       Description     : 0		 -- No errors occurred
- *			 RET_BAD_NULL_PARAM     -- A Pointer
- *						Paramater was set to NULL
- *
- * PURPOSE:	      : Flush the TLB entry pointed by the
- *			lock counter register
- *			even if this entry is set protected
- *
- * METHOD:	       : Check the Input parameter and Flush a
- *			 single entry in the TLB.
- */
-static hw_status mmu_flush_entry(const void __iomem *base_address);
-
-/*
- * FUNCTION	      : mmu_set_cam_entry
- *
- * INPUTS:
- *
- *       Identifier      : base_address
- *       TypE		: const u32
- *       Description     : Base Address of instance of MMU module
- *
- *       Identifier      : page_sz
- *       TypE		: const u32
- *       Description     : It indicates the page size
- *
- *       Identifier      : preserved_bit
- *       Type		: const u32
- *       Description     : It indicates the TLB entry is preserved entry
- *							or not
- *
- *       Identifier      : valid_bit
- *       Type		: const u32
- *       Description     : It indicates the TLB entry is valid entry or not
- *
- *
- *       Identifier      : virtual_addr_tag
- *       Type	    	: const u32
- *       Description     : virtual Address
- *
- * RETURNS:
- *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occurred
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *						   was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
- *						   of Range
- *
- * PURPOSE:	      	: Set MMU_CAM reg
- *
- * METHOD:	       	: Check the Input parameters and set the CAM entry.
- */
-static hw_status mmu_set_cam_entry(const void __iomem *base_address,
-				   const u32 page_sz,
-				   const u32 preserved_bit,
-				   const u32 valid_bit,
-				   const u32 virtual_addr_tag);
-
-/*
- * FUNCTION	      : mmu_set_ram_entry
- *
- * INPUTS:
- *
- *       Identifier      : base_address
- *       Type	    	: const u32
- *       Description     : Base Address of instance of MMU module
- *
- *       Identifier      : physical_addr
- *       Type	    	: const u32
- *       Description     : Physical Address to which the corresponding
- *			 virtual   Address shouldpoint
- *
- *       Identifier      : endianism
- *       Type	    	: hw_endianism_t
- *       Description     : endianism for the given page
- *
- *       Identifier      : element_size
- *       Type	    	: hw_element_size_t
- *       Description     : The element size ( 8,16, 32 or 64 bit)
- *
- *       Identifier      : mixed_size
- *       Type	    	: hw_mmu_mixed_size_t
- *       Description     : Element Size to follow CPU or TLB
- *
- * RETURNS:
- *
- *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occurred
- *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
- *							was set to NULL
- *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
- *							out of Range
- *
- * PURPOSE:	      : Set MMU_CAM reg
- *
- * METHOD:	       : Check the Input parameters and set the RAM entry.
- */
-static hw_status mmu_set_ram_entry(const void __iomem *base_address,
-				   const u32 physical_addr,
-				   enum hw_endianism_t endianism,
-				   enum hw_element_size_t element_size,
-				   enum hw_mmu_mixed_size_t mixed_size);
-
-/* HW FUNCTIONS */
-
-hw_status hw_mmu_enable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, HW_SET);
-
-	return status;
-}
-
-hw_status hw_mmu_disable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLMMU_ENABLE_WRITE32(base_address, HW_CLEAR);
-
-	return status;
-}
-
-hw_status hw_mmu_num_locked_set(const void __iomem *base_address,
-				u32 num_locked_entries)
-{
-	hw_status status = 0;
-
-	MMUMMU_LOCK_BASE_VALUE_WRITE32(base_address, num_locked_entries);
-
-	return status;
-}
-
-hw_status hw_mmu_victim_num_set(const void __iomem *base_address,
-				u32 victim_entry_num)
-{
-	hw_status status = 0;
-
-	MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, victim_entry_num);
-
-	return status;
-}
-
-hw_status hw_mmu_event_ack(const void __iomem *base_address, u32 irq_mask)
-{
-	hw_status status = 0;
-
-	MMUMMU_IRQSTATUS_WRITE_REGISTER32(base_address, irq_mask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_disable(const void __iomem *base_address, u32 irq_mask)
-{
-	hw_status status = 0;
-	u32 irq_reg;
-
-	irq_reg = MMUMMU_IRQENABLE_READ_REGISTER32(base_address);
-
-	MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, irq_reg & ~irq_mask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_enable(const void __iomem *base_address, u32 irq_mask)
-{
-	hw_status status = 0;
-	u32 irq_reg;
-
-	irq_reg = MMUMMU_IRQENABLE_READ_REGISTER32(base_address);
-
-	MMUMMU_IRQENABLE_WRITE_REGISTER32(base_address, irq_reg | irq_mask);
-
-	return status;
-}
-
-hw_status hw_mmu_event_status(const void __iomem *base_address, u32 *irq_mask)
-{
-	hw_status status = 0;
-
-	*irq_mask = MMUMMU_IRQSTATUS_READ_REGISTER32(base_address);
-
-	return status;
-}
-
-hw_status hw_mmu_fault_addr_read(const void __iomem *base_address, u32 *addr)
-{
-	hw_status status = 0;
-
-	/* read values from register */
-	*addr = MMUMMU_FAULT_AD_READ_REGISTER32(base_address);
-
-	return status;
-}
-
-hw_status hw_mmu_ttb_set(const void __iomem *base_address, u32 ttb_phys_addr)
-{
-	hw_status status = 0;
-	u32 load_ttb;
-
-	load_ttb = ttb_phys_addr & ~0x7FUL;
-	/* write values to register */
-	MMUMMU_TTB_WRITE_REGISTER32(base_address, load_ttb);
-
-	return status;
-}
-
-hw_status hw_mmu_twl_enable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, HW_SET);
-
-	return status;
-}
-
-hw_status hw_mmu_twl_disable(const void __iomem *base_address)
-{
-	hw_status status = 0;
-
-	MMUMMU_CNTLTWL_ENABLE_WRITE32(base_address, HW_CLEAR);
-
-	return status;
-}
-
-hw_status hw_mmu_tlb_flush(const void __iomem *base_address, u32 virtual_addr,
-			   u32 page_sz)
-{
-	hw_status status = 0;
-	u32 virtual_addr_tag;
-	enum hw_mmu_page_size_t pg_size_bits;
-
-	switch (page_sz) {
-	case HW_PAGE_SIZE4KB:
-		pg_size_bits = HW_MMU_SMALL_PAGE;
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		pg_size_bits = HW_MMU_LARGE_PAGE;
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		pg_size_bits = HW_MMU_SECTION;
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		pg_size_bits = HW_MMU_SUPERSECTION;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	/* Generate the 20-bit tag from virtual address */
-	virtual_addr_tag = ((virtual_addr & MMU_ADDR_MASK) >> 12);
-
-	mmu_set_cam_entry(base_address, pg_size_bits, 0, 0, virtual_addr_tag);
-
-	mmu_flush_entry(base_address);
-
-	return status;
-}
-
-hw_status hw_mmu_tlb_add(const void __iomem *base_address,
-			 u32 physical_addr,
-			 u32 virtual_addr,
-			 u32 page_sz,
-			 u32 entry_num,
-			 struct hw_mmu_map_attrs_t *map_attrs,
-			 s8 preserved_bit, s8 valid_bit)
-{
-	hw_status status = 0;
-	u32 lock_reg;
-	u32 virtual_addr_tag;
-	enum hw_mmu_page_size_t mmu_pg_size;
-
-	/*Check the input Parameters */
-	switch (page_sz) {
-	case HW_PAGE_SIZE4KB:
-		mmu_pg_size = HW_MMU_SMALL_PAGE;
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		mmu_pg_size = HW_MMU_LARGE_PAGE;
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		mmu_pg_size = HW_MMU_SECTION;
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		mmu_pg_size = HW_MMU_SUPERSECTION;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	lock_reg = MMUMMU_LOCK_READ_REGISTER32(base_address);
-
-	/* Generate the 20-bit tag from virtual address */
-	virtual_addr_tag = ((virtual_addr & MMU_ADDR_MASK) >> 12);
-
-	/* Write the fields in the CAM Entry Register */
-	mmu_set_cam_entry(base_address, mmu_pg_size, preserved_bit, valid_bit,
-			  virtual_addr_tag);
-
-	/* Write the different fields of the RAM Entry Register */
-	/* endianism of the page,Element Size of the page (8, 16, 32, 64 bit) */
-	mmu_set_ram_entry(base_address, physical_addr, map_attrs->endianism,
-			  map_attrs->element_size, map_attrs->mixed_size);
-
-	/* Update the MMU Lock Register */
-	/* currentVictim between lockedBaseValue and (MMU_Entries_Number - 1) */
-	MMUMMU_LOCK_CURRENT_VICTIM_WRITE32(base_address, entry_num);
-
-	/* Enable loading of an entry in TLB by writing 1
-	   into LD_TLB_REG register */
-	MMUMMU_LD_TLB_WRITE_REGISTER32(base_address, MMU_LOAD_TLB);
-
-	MMUMMU_LOCK_WRITE_REGISTER32(base_address, lock_reg);
-
-	return status;
-}
-
-hw_status hw_mmu_pte_set(const u32 pg_tbl_va,
-			 u32 physical_addr,
-			 u32 virtual_addr,
-			 u32 page_sz, struct hw_mmu_map_attrs_t *map_attrs)
-{
-	hw_status status = 0;
-	u32 pte_addr, pte_val;
-	s32 num_entries = 1;
-
-	switch (page_sz) {
-	case HW_PAGE_SIZE4KB:
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SMALL_PAGE_MASK);
-		pte_val =
-		    ((physical_addr & MMU_SMALL_PAGE_MASK) |
-		     (map_attrs->endianism << 9) | (map_attrs->
-						    element_size << 4) |
-		     (map_attrs->mixed_size << 11) | 2);
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_LARGE_PAGE_MASK);
-		pte_val =
-		    ((physical_addr & MMU_LARGE_PAGE_MASK) |
-		     (map_attrs->endianism << 9) | (map_attrs->
-						    element_size << 4) |
-		     (map_attrs->mixed_size << 11) | 1);
-		break;
-
-	case HW_PAGE_SIZE1MB:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SECTION_ADDR_MASK);
-		pte_val =
-		    ((((physical_addr & MMU_SECTION_ADDR_MASK) |
-		       (map_attrs->endianism << 15) | (map_attrs->
-						       element_size << 10) |
-		       (map_attrs->mixed_size << 17)) & ~0x40000) | 0x2);
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SSECTION_ADDR_MASK);
-		pte_val =
-		    (((physical_addr & MMU_SSECTION_ADDR_MASK) |
-		      (map_attrs->endianism << 15) | (map_attrs->
-						      element_size << 10) |
-		      (map_attrs->mixed_size << 17)
-		     ) | 0x40000 | 0x2);
-		break;
-
-	case HW_MMU_COARSE_PAGE_SIZE:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SECTION_ADDR_MASK);
-		pte_val = (physical_addr & MMU_PAGE_TABLE_MASK) | 1;
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	while (--num_entries >= 0)
-		((u32 *) pte_addr)[num_entries] = pte_val;
-
-	return status;
-}
-
-hw_status hw_mmu_pte_clear(const u32 pg_tbl_va, u32 virtual_addr, u32 page_size)
-{
-	hw_status status = 0;
-	u32 pte_addr;
-	s32 num_entries = 1;
-
-	switch (page_size) {
-	case HW_PAGE_SIZE4KB:
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SMALL_PAGE_MASK);
-		break;
-
-	case HW_PAGE_SIZE64KB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l2(pg_tbl_va,
-					      virtual_addr &
-					      MMU_LARGE_PAGE_MASK);
-		break;
-
-	case HW_PAGE_SIZE1MB:
-	case HW_MMU_COARSE_PAGE_SIZE:
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SECTION_ADDR_MASK);
-		break;
-
-	case HW_PAGE_SIZE16MB:
-		num_entries = 16;
-		pte_addr = hw_mmu_pte_addr_l1(pg_tbl_va,
-					      virtual_addr &
-					      MMU_SSECTION_ADDR_MASK);
-		break;
-
-	default:
-		return -EINVAL;
-	}
-
-	while (--num_entries >= 0)
-		((u32 *) pte_addr)[num_entries] = 0;
-
-	return status;
-}
-
-/* mmu_flush_entry */
-static hw_status mmu_flush_entry(const void __iomem *base_address)
-{
-	hw_status status = 0;
-	u32 flush_entry_data = 0x1;
-
-	/* write values to register */
-	MMUMMU_FLUSH_ENTRY_WRITE_REGISTER32(base_address, flush_entry_data);
-
-	return status;
-}
-
-/* mmu_set_cam_entry */
-static hw_status mmu_set_cam_entry(const void __iomem *base_address,
-				   const u32 page_sz,
-				   const u32 preserved_bit,
-				   const u32 valid_bit,
-				   const u32 virtual_addr_tag)
-{
-	hw_status status = 0;
-	u32 mmu_cam_reg;
-
-	mmu_cam_reg = (virtual_addr_tag << 12);
-	mmu_cam_reg = (mmu_cam_reg) | (page_sz) | (valid_bit << 2) |
-	    (preserved_bit << 3);
-
-	/* write values to register */
-	MMUMMU_CAM_WRITE_REGISTER32(base_address, mmu_cam_reg);
-
-	return status;
-}
-
-/* mmu_set_ram_entry */
-static hw_status mmu_set_ram_entry(const void __iomem *base_address,
-				   const u32 physical_addr,
-				   enum hw_endianism_t endianism,
-				   enum hw_element_size_t element_size,
-				   enum hw_mmu_mixed_size_t mixed_size)
-{
-	hw_status status = 0;
-	u32 mmu_ram_reg;
-
-	mmu_ram_reg = (physical_addr & MMU_ADDR_MASK);
-	mmu_ram_reg = (mmu_ram_reg) | ((endianism << 9) | (element_size << 7) |
-				       (mixed_size << 6));
-
-	/* write values to register */
-	MMUMMU_RAM_WRITE_REGISTER32(base_address, mmu_ram_reg);
-
-	return status;
-
-}
-
-void hw_mmu_tlb_flush_all(const void __iomem *base)
-{
-	__raw_writeb(1, base + MMU_GFLUSH);
-}
diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.h b/drivers/staging/tidspbridge/hw/hw_mmu.h
deleted file mode 100644
index 1458a2c..0000000
--- a/drivers/staging/tidspbridge/hw/hw_mmu.h
+++ /dev/null
@@ -1,163 +0,0 @@
-/*
- * hw_mmu.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * MMU types and API declarations
- *
- * Copyright (C) 2007 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef _HW_MMU_H
-#define _HW_MMU_H
-
-#include <linux/types.h>
-
-/* Bitmasks for interrupt sources */
-#define HW_MMU_TRANSLATION_FAULT   0x2
-#define HW_MMU_ALL_INTERRUPTS      0x1F
-
-#define HW_MMU_COARSE_PAGE_SIZE 0x400
-
-/* hw_mmu_mixed_size_t:  Enumerated Type used to specify whether to follow
-			CPU/TLB Element size */
-enum hw_mmu_mixed_size_t {
-	HW_MMU_TLBES,
-	HW_MMU_CPUES
-};
-
-/* hw_mmu_map_attrs_t:  Struct containing MMU mapping attributes */
-struct hw_mmu_map_attrs_t {
-	enum hw_endianism_t endianism;
-	enum hw_element_size_t element_size;
-	enum hw_mmu_mixed_size_t mixed_size;
-	bool donotlockmpupage;
-};
-
-extern hw_status hw_mmu_enable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_disable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_num_locked_set(const void __iomem *base_address,
-				       u32 num_locked_entries);
-
-extern hw_status hw_mmu_victim_num_set(const void __iomem *base_address,
-				       u32 victim_entry_num);
-
-/* For MMU faults */
-extern hw_status hw_mmu_event_ack(const void __iomem *base_address,
-				  u32 irq_mask);
-
-extern hw_status hw_mmu_event_disable(const void __iomem *base_address,
-				      u32 irq_mask);
-
-extern hw_status hw_mmu_event_enable(const void __iomem *base_address,
-				     u32 irq_mask);
-
-extern hw_status hw_mmu_event_status(const void __iomem *base_address,
-				     u32 *irq_mask);
-
-extern hw_status hw_mmu_fault_addr_read(const void __iomem *base_address,
-					u32 *addr);
-
-/* Set the TT base address */
-extern hw_status hw_mmu_ttb_set(const void __iomem *base_address,
-				u32 ttb_phys_addr);
-
-extern hw_status hw_mmu_twl_enable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_twl_disable(const void __iomem *base_address);
-
-extern hw_status hw_mmu_tlb_flush(const void __iomem *base_address,
-				  u32 virtual_addr, u32 page_sz);
-
-extern hw_status hw_mmu_tlb_add(const void __iomem *base_address,
-				u32 physical_addr,
-				u32 virtual_addr,
-				u32 page_sz,
-				u32 entry_num,
-				struct hw_mmu_map_attrs_t *map_attrs,
-				s8 preserved_bit, s8 valid_bit);
-
-/* For PTEs */
-extern hw_status hw_mmu_pte_set(const u32 pg_tbl_va,
-				u32 physical_addr,
-				u32 virtual_addr,
-				u32 page_sz,
-				struct hw_mmu_map_attrs_t *map_attrs);
-
-extern hw_status hw_mmu_pte_clear(const u32 pg_tbl_va,
-				  u32 virtual_addr, u32 page_size);
-
-void hw_mmu_tlb_flush_all(const void __iomem *base);
-
-static inline u32 hw_mmu_pte_addr_l1(u32 l1_base, u32 va)
-{
-	u32 pte_addr;
-	u32 va31_to20;
-
-	va31_to20 = va >> (20 - 2);	/* Left-shift by 2 here itself */
-	va31_to20 &= 0xFFFFFFFCUL;
-	pte_addr = l1_base + va31_to20;
-
-	return pte_addr;
-}
-
-static inline u32 hw_mmu_pte_addr_l2(u32 l2_base, u32 va)
-{
-	u32 pte_addr;
-
-	pte_addr = (l2_base & 0xFFFFFC00) | ((va >> 10) & 0x3FC);
-
-	return pte_addr;
-}
-
-static inline u32 hw_mmu_pte_coarse_l1(u32 pte_val)
-{
-	u32 pte_coarse;
-
-	pte_coarse = pte_val & 0xFFFFFC00;
-
-	return pte_coarse;
-}
-
-static inline u32 hw_mmu_pte_size_l1(u32 pte_val)
-{
-	u32 pte_size = 0;
-
-	if ((pte_val & 0x3) == 0x1) {
-		/* Points to L2 PT */
-		pte_size = HW_MMU_COARSE_PAGE_SIZE;
-	}
-
-	if ((pte_val & 0x3) == 0x2) {
-		if (pte_val & (1 << 18))
-			pte_size = HW_PAGE_SIZE16MB;
-		else
-			pte_size = HW_PAGE_SIZE1MB;
-	}
-
-	return pte_size;
-}
-
-static inline u32 hw_mmu_pte_size_l2(u32 pte_val)
-{
-	u32 pte_size = 0;
-
-	if (pte_val & 0x2)
-		pte_size = HW_PAGE_SIZE4KB;
-	else if (pte_val & 0x1)
-		pte_size = HW_PAGE_SIZE64KB;
-
-	return pte_size;
-}
-
-#endif /* _HW_MMU_H */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
index 60a2781..ed4b288 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
@@ -55,7 +55,6 @@ struct cfg_hostres {
 	void __iomem *per_base;
 	u32 per_pm_base;
 	u32 core_pm_base;
-	void __iomem *dmmu_base;
 };
 
 #endif /* CFGDEFS_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index 9cdbd95..ea74dda 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -55,9 +55,6 @@ struct drv_object;
 #define OMAP_CORE_PRM_BASE 0x48306A00
 #define OMAP_CORE_PRM_SIZE 0x1000
 
-#define OMAP_DMMU_BASE 0x5D000000
-#define OMAP_DMMU_SIZE 0x1000
-
 /* GPP PROCESS CLEANUP Data structures */
 
 /* New structure (member of process context) abstracts NODE resource info */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h b/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
index 0c7ec04..b589c1d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspioctl.h
@@ -19,10 +19,6 @@
 #ifndef DSPIOCTL_
 #define DSPIOCTL_
 
-/* ------------------------------------ Hardware Abstraction Layer */
-#include <hw_defs.h>
-#include <hw_mmu.h>
-
 /*
  * Any IOCTLS at or above this value are reserved for standard Bridge driver
  * interfaces.
@@ -60,9 +56,6 @@ struct bridge_ioctl_extproc {
 	/* GPP virtual address. __va does not work for ioremapped addresses */
 	u32 gpp_va;
 	u32 size;		/* Size of the mapped memory in bytes */
-	enum hw_endianism_t endianism;
-	enum hw_mmu_mixed_size_t mixed_mode;
-	enum hw_element_size_t elem_size;
 };
 
 #endif /* DSPIOCTL_ */
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index db8215f..a7c93cf 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -689,7 +689,6 @@ static int request_bridge_resources(struct cfg_hostres *res)
 	/* First window is for DSP internal memory */
 	dev_dbg(bridge, "mem_base[0] 0x%x\n", host_res->mem_base[0]);
 	dev_dbg(bridge, "mem_base[3] 0x%x\n", host_res->mem_base[3]);
-	dev_dbg(bridge, "dmmu_base %p\n", host_res->dmmu_base);
 
 	/* for 24xx base port is not mapping the mamory for DSP
 	 * internal memory TODO Do a ioremap here */
@@ -743,8 +742,6 @@ int drv_request_bridge_res_dsp(void **phost_resources)
 							 OMAP_PER_PRM_SIZE);
 		host_res->core_pm_base = (u32) ioremap(OMAP_CORE_PRM_BASE,
 							  OMAP_CORE_PRM_SIZE);
-		host_res->dmmu_base = ioremap(OMAP_DMMU_BASE,
-						 OMAP_DMMU_SIZE);
 
 		dev_dbg(bridge, "mem_base[0] 0x%x\n",
 			host_res->mem_base[0]);
@@ -756,7 +753,6 @@ int drv_request_bridge_res_dsp(void **phost_resources)
 			host_res->mem_base[3]);
 		dev_dbg(bridge, "mem_base[4] 0x%x\n",
 			host_res->mem_base[4]);
-		dev_dbg(bridge, "dmmu_base %p\n", host_res->dmmu_base);
 
 		shm_size = drv_datap->shm_size;
 		if (shm_size >= 0x10000) {
-- 
1.7.1

