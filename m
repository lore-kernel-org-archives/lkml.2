Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab1D1PpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:45:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43433 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231Ab1D1PnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:16 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: [PATCH v4 2/6] staging: tidspbridge: replace custom mmu for omap iommu framework
Date: Thu, 28 Apr 2011 10:31:48 -0500
Message-Id: <1304004712-8487-3-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use omap iommu framework to control IVA mmu and map/unmap buffers
to the dsp.

Changes to select IOMMU module and IVA IOMMU support are needed when
using tidspbridge, Kconfig has been updated for that.

Remove code from proc_reserve/un_reserve which is intended to manage
the available virtual address space, since iovmm does that.

BEWARE: Due to SG_CHAIN not being reviewed/fully-tested within the
ARM architecture, if not selected, sg_alloc_table can't allocate SG
tables representing large buffers (usually ~2MB+), this limitation
translates into a panic if attempted.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/Kconfig                |   10 +
 drivers/staging/tidspbridge/core/_deh.h            |    2 +
 drivers/staging/tidspbridge/core/_tiomap.h         |   16 +-
 drivers/staging/tidspbridge/core/io_sm.c           |  177 +-----
 drivers/staging/tidspbridge/core/tiomap3430.c      |  676 +++++++-------------
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    2 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |   12 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |  100 +--
 .../tidspbridge/include/dspbridge/dspdefs.h        |    3 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   95 +---
 10 files changed, 326 insertions(+), 767 deletions(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 93de4f2..19b1b76 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -6,6 +6,8 @@ menuconfig TIDSPBRIDGE
 	tristate "DSP Bridge driver"
 	depends on ARCH_OMAP3
 	select OMAP_MBOX_FWK
+	select OMAP_IOMMU
+	select OMAP_IOMMU_IVA2
 	help
 	  DSP/BIOS Bridge is designed for platforms that contain a GPP and
 	  one or more attached DSPs.  The GPP is considered the master or
@@ -31,6 +33,14 @@ config TIDSPBRIDGE_MEMPOOL_SIZE
 	  Allocate specified size of memory at booting time to avoid allocation
 	  failure under heavy memory fragmentation after some use time.
 
+config TIDSPBRIDGE_DMM_SIZE
+	hex "DMM capable memory size (Byte)"
+	depends on TIDSPBRIDGE
+	default "0x10000000"
+	help
+	  Memory size of DSP virtual address for Dynamic Memory Mapping.
+	  Please make sure the size is 4K aligned.
+
 config TIDSPBRIDGE_DEBUG
 	bool "Debug Support"
 	depends on TIDSPBRIDGE
diff --git a/drivers/staging/tidspbridge/core/_deh.h b/drivers/staging/tidspbridge/core/_deh.h
index 025d343..85543cf 100644
--- a/drivers/staging/tidspbridge/core/_deh.h
+++ b/drivers/staging/tidspbridge/core/_deh.h
@@ -32,4 +32,6 @@ struct deh_mgr {
 	struct tasklet_struct dpc_tasklet;
 };
 
+int mmu_fault_isr(struct iommu *mmu, u32 da, u32 iommu_errs, void *priv);
+
 #endif /* _DEH_ */
diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index 7cb5871..d493e11 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -34,6 +34,8 @@
 #include <mach-omap2/cm2xxx_3xxx.h>
 #include <mach-omap2/prm-regbits-34xx.h>
 #include <mach-omap2/cm-regbits-34xx.h>
+#include <plat/iommu.h>
+#include <plat/iovmm.h>
 #include <dspbridge/devdefs.h>
 #include <hw_defs.h>
 #include <dspbridge/dspioctl.h>	/* for bridge_ioctl_extproc defn */
@@ -317,6 +319,17 @@ static const struct bpwr_clk_t bpwr_clks[] = {
 
 #define CLEAR_BIT_INDEX(reg, index)   (reg &= ~(1 << (index)))
 
+struct shm_segs {
+	u32 seg0_da;
+	u32 seg0_pa;
+	u32 seg0_va;
+	u32 seg0_size;
+	u32 seg1_da;
+	u32 seg1_pa;
+	u32 seg1_va;
+	u32 seg1_size;
+};
+
 /* This Bridge driver's device context: */
 struct bridge_dev_context {
 	struct dev_object *dev_obj;	/* Handle to Bridge device object. */
@@ -339,7 +352,8 @@ struct bridge_dev_context {
 	u32 internal_size;	/* Internal memory size */
 
 	struct omap_mbox *mbox;		/* Mail box handle */
-
+	struct iommu *dsp_mmu;      /* iommu for iva2 handler */
+	struct shm_segs sh_s;
 	struct cfg_hostres *resources;	/* Host Resources */
 
 	/*
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 694c0e5..3558658 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -271,6 +271,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	struct cod_manager *cod_man;
 	struct chnl_mgr *hchnl_mgr;
 	struct msg_mgr *hmsg_mgr;
+	struct shm_segs *sm_sg;
 	u32 ul_shm_base;
 	u32 ul_shm_base_offset;
 	u32 ul_shm_limit;
@@ -293,18 +294,9 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	struct bridge_ioctl_extproc ae_proc[BRDIOCTL_NUMOFMMUTLB];
 	struct cfg_hostres *host_res;
 	struct bridge_dev_context *pbridge_context;
-	u32 map_attrs;
 	u32 shm0_end;
 	u32 ul_dyn_ext_base;
 	u32 ul_seg1_size = 0;
-	u32 pa_curr = 0;
-	u32 va_curr = 0;
-	u32 gpp_va_curr = 0;
-	u32 num_bytes = 0;
-	u32 all_bits = 0;
-	u32 page_size[] = { HW_PAGE_SIZE16MB, HW_PAGE_SIZE1MB,
-		HW_PAGE_SIZE64KB, HW_PAGE_SIZE4KB
-	};
 
 	status = dev_get_bridge_context(hio_mgr->dev_obj, &pbridge_context);
 	if (!pbridge_context) {
@@ -317,6 +309,9 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		status = -EFAULT;
 		goto func_end;
 	}
+
+	sm_sg = &pbridge_context->sh_s;
+
 	status = dev_get_cod_mgr(hio_mgr->dev_obj, &cod_man);
 	if (!cod_man) {
 		status = -EFAULT;
@@ -451,129 +446,14 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	if (status)
 		goto func_end;
 
-	pa_curr = ul_gpp_pa;
-	va_curr = ul_dyn_ext_base * hio_mgr->word_size;
-	gpp_va_curr = ul_gpp_va;
-	num_bytes = ul_seg1_size;
-
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
-				    brd_mem_map(hio_mgr->bridge_context,
-						    pa_curr, va_curr,
-						    page_size[i], map_attrs,
-						    NULL);
-				if (status)
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
-	}
-	pa_curr += ul_pad_size;
-	va_curr += ul_pad_size;
-	gpp_va_curr += ul_pad_size;
-
-	/* Configure the TLB entries for the next cacheable segment */
-	num_bytes = ul_seg_size;
-	va_curr = ul_dsp_va * hio_mgr->word_size;
-	while (num_bytes) {
-		/*
-		 * To find the max. page size with which both PA & VA are
-		 * aligned.
-		 */
-		all_bits = pa_curr | va_curr;
-		dev_dbg(bridge, "all_bits for Seg1 %x, pa_curr %x, "
-			"va_curr %x, num_bytes %x\n", all_bits, pa_curr,
-			va_curr, num_bytes);
-		for (i = 0; i < 4; i++) {
-			if (!(num_bytes >= page_size[i]) ||
-			    !((all_bits & (page_size[i] - 1)) == 0))
-				continue;
-			if (ndx < MAX_LOCK_TLB_ENTRIES) {
-				/*
-				 * This is the physical address written to
-				 * DSP MMU.
-				 */
-				ae_proc[ndx].gpp_pa = pa_curr;
-				/*
-				 * This is the virtual uncached ioremapped
-				 * address!!!
-				 */
-				ae_proc[ndx].gpp_va = gpp_va_curr;
-				ae_proc[ndx].dsp_va =
-				    va_curr / hio_mgr->word_size;
-				ae_proc[ndx].size = page_size[i];
-				ae_proc[ndx].endianism = HW_LITTLE_ENDIAN;
-				ae_proc[ndx].elem_size = HW_ELEM_SIZE16BIT;
-				ae_proc[ndx].mixed_mode = HW_MMU_CPUES;
-				dev_dbg(bridge, "shm MMU TLB entry PA %x"
-					" VA %x DSP_VA %x Size %x\n",
-					ae_proc[ndx].gpp_pa,
-					ae_proc[ndx].gpp_va,
-					ae_proc[ndx].dsp_va *
-					hio_mgr->word_size, page_size[i]);
-				ndx++;
-			} else {
-				status =
-				    hio_mgr->intf_fxns->
-				    brd_mem_map(hio_mgr->bridge_context,
-						    pa_curr, va_curr,
-						    page_size[i], map_attrs,
-						    NULL);
-				dev_dbg(bridge,
-					"shm MMU PTE entry PA %x"
-					" VA %x DSP_VA %x Size %x\n",
-					ae_proc[ndx].gpp_pa,
-					ae_proc[ndx].gpp_va,
-					ae_proc[ndx].dsp_va *
-					hio_mgr->word_size, page_size[i]);
-				if (status)
-					goto func_end;
-			}
-			pa_curr += page_size[i];
-			va_curr += page_size[i];
-			gpp_va_curr += page_size[i];
-			num_bytes -= page_size[i];
-			/*
-			 * Don't try smaller sizes. Hopefully we have reached
-			 * an address aligned to a bigger page size.
-			 */
-			break;
-		}
-	}
+	sm_sg->seg1_pa = ul_gpp_pa;
+	sm_sg->seg1_da = ul_dyn_ext_base;
+	sm_sg->seg1_va = ul_gpp_va;
+	sm_sg->seg1_size = ul_seg1_size;
+	sm_sg->seg0_pa = ul_gpp_pa + ul_pad_size + ul_seg1_size;
+	sm_sg->seg0_da = ul_dsp_va;
+	sm_sg->seg0_va = ul_gpp_va + ul_pad_size + ul_seg1_size;
+	sm_sg->seg0_size = ul_seg_size;
 
 	/*
 	 * Copy remaining entries from CDB. All entries are 1 MB and
@@ -614,38 +494,12 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 					"DSP_VA 0x%x\n", ae_proc[ndx].gpp_pa,
 					ae_proc[ndx].dsp_va);
 				ndx++;
-			} else {
-				status = hio_mgr->intf_fxns->brd_mem_map
-				    (hio_mgr->bridge_context,
-				     hio_mgr->ext_proc_info.ty_tlb[i].
-				     gpp_phys,
-				     hio_mgr->ext_proc_info.ty_tlb[i].
-				     dsp_virt, 0x100000, map_attrs,
-				     NULL);
 			}
 		}
 		if (status)
 			goto func_end;
 	}
 
-	map_attrs = 0x00000000;
-	map_attrs = DSP_MAPLITTLEENDIAN;
-	map_attrs |= DSP_MAPPHYSICALADDR;
-	map_attrs |= DSP_MAPELEMSIZE32;
-	map_attrs |= DSP_MAPDONOTLOCK;
-
-	/* Map the L4 peripherals */
-	i = 0;
-	while (l4_peripheral_table[i].phys_addr) {
-		status = hio_mgr->intf_fxns->brd_mem_map
-		    (hio_mgr->bridge_context, l4_peripheral_table[i].phys_addr,
-		     l4_peripheral_table[i].dsp_virt_addr, HW_PAGE_SIZE4KB,
-		     map_attrs, NULL);
-		if (status)
-			goto func_end;
-		i++;
-	}
-
 	for (i = ndx; i < BRDIOCTL_NUMOFMMUTLB; i++) {
 		ae_proc[i].dsp_va = 0;
 		ae_proc[i].gpp_pa = 0;
@@ -668,12 +522,12 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		status = -EFAULT;
 		goto func_end;
 	} else {
-		if (ae_proc[0].dsp_va > ul_shm_base) {
+		if (sm_sg->seg0_da > ul_shm_base) {
 			status = -EPERM;
 			goto func_end;
 		}
 		/* ul_shm_base may not be at ul_dsp_va address */
-		ul_shm_base_offset = (ul_shm_base - ae_proc[0].dsp_va) *
+		ul_shm_base_offset = (ul_shm_base - sm_sg->seg0_da) *
 		    hio_mgr->word_size;
 		/*
 		 * bridge_dev_ctrl() will set dev context dsp-mmu info. In
@@ -697,8 +551,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 			goto func_end;
 		}
 		/* Register SM */
-		status =
-		    register_shm_segs(hio_mgr, cod_man, ae_proc[0].gpp_pa);
+		status = register_shm_segs(hio_mgr, cod_man, sm_sg->seg0_pa);
 	}
 
 	hio_mgr->shared_mem = (struct shm *)ul_shm_base;
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index e1c4492..1ca50d9 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -57,6 +57,7 @@
 #include "_tiomap.h"
 #include "_tiomap_pwr.h"
 #include "tiomap_io.h"
+#include "_deh.h"
 
 /* Offset in shared mem to write to in order to synchronize start with DSP */
 #define SHMSYNCOFFSET 4		/* GPP byte offset */
@@ -111,10 +112,9 @@ static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
 				    u32 ul_num_bytes, u32 mem_type);
 static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctxt,
 				  u32 ul_mpu_addr, u32 virt_addr,
-				  u32 ul_num_bytes, u32 ul_map_attr,
-				  struct page **mapped_pages);
+				  u32 ul_num_bytes, struct page **mapped_pages);
 static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctxt,
-				     u32 virt_addr, u32 ul_num_bytes);
+				     u32 da);
 static int bridge_dev_create(struct bridge_dev_context
 					**dev_cntxt,
 					struct dev_object *hdev_obj,
@@ -122,6 +122,8 @@ static int bridge_dev_create(struct bridge_dev_context
 static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
 				  u32 dw_cmd, void *pargs);
 static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt);
+static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
+						struct page **usr_pgs);
 static u32 user_va2_pa(struct mm_struct *mm, u32 address);
 static int pte_update(struct bridge_dev_context *dev_ctxt, u32 pa,
 			     u32 va, u32 size,
@@ -301,8 +303,7 @@ static int bridge_brd_monitor(struct bridge_dev_context *dev_ctxt)
 		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_DISABLE_AUTO,
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);
 	}
-	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
-					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+
 	dsp_clk_enable(DSP_CLK_IVA2);
 
 	/* set the device state to IDLE */
@@ -373,14 +374,18 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 {
 	int status = 0;
 	struct bridge_dev_context *dev_context = dev_ctxt;
+	struct iommu *mmu = NULL;
+	struct shm_segs *sm_sg;
+	int l4_i, tlb_i;
+	u32 sg0_da, sg1_da, da;
+	u32 flags = IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32 | IOVMF_DA_FIXED;
+	struct bridge_ioctl_extproc *tlb = dev_context->atlb_entry;
 	u32 dw_sync_addr = 0;
 	u32 ul_shm_base;	/* Gpp Phys SM base addr(byte) */
 	u32 ul_shm_base_virt;	/* Dsp Virt SM base addr */
 	u32 ul_tlb_base_virt;	/* Base of MMU TLB entry */
 	/* Offset of shm_base_virt from tlb_base_virt */
 	u32 ul_shm_offset_virt;
-	s32 entry_ndx;
-	s32 itmp_entry_ndx = 0;	/* DSP-MMU TLB entry base address */
 	struct cfg_hostres *resources = NULL;
 	u32 temp;
 	u32 ul_dsp_clk_rate;
@@ -401,12 +406,12 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	ul_shm_base_virt *= DSPWORDSIZE;
 	DBC_ASSERT(ul_shm_base_virt != 0);
 	/* DSP Virtual address */
-	ul_tlb_base_virt = dev_context->atlb_entry[0].dsp_va;
+	ul_tlb_base_virt = dev_context->sh_s.seg0_da;
 	DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 	ul_shm_offset_virt =
 	    ul_shm_base_virt - (ul_tlb_base_virt * DSPWORDSIZE);
 	/* Kernel logical address */
-	ul_shm_base = dev_context->atlb_entry[0].gpp_va + ul_shm_offset_virt;
+	ul_shm_base = dev_context->sh_s.seg0_va + ul_shm_offset_virt;
 
 	DBC_ASSERT(ul_shm_base != 0);
 	/* 2nd wd is used as sync field */
@@ -441,78 +446,91 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 					OMAP343X_CONTROL_IVA2_BOOTMOD));
 		}
 	}
-	if (!status) {
-		/* Reset and Unreset the RST2, so that BOOTADDR is copied to
-		 * IVA2 SYSC register */
-		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK,
-			OMAP3430_RST2_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
-		udelay(100);
-		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
+
+	if (status)
+		return status;
+
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
-		udelay(100);
-
-		/* Disbale the DSP MMU */
-		hw_mmu_disable(resources->dmmu_base);
-		/* Disable TWL */
-		hw_mmu_twl_disable(resources->dmmu_base);
-
-		/* Only make TLB entry if both addresses are non-zero */
-		for (entry_ndx = 0; entry_ndx < BRDIOCTL_NUMOFMMUTLB;
-		     entry_ndx++) {
-			struct bridge_ioctl_extproc *e = &dev_context->atlb_entry[entry_ndx];
-			struct hw_mmu_map_attrs_t map_attrs = {
-				.endianism = e->endianism,
-				.element_size = e->elem_size,
-				.mixed_size = e->mixed_mode,
-			};
-
-			if (!e->gpp_pa || !e->dsp_va)
-				continue;
 
-			dev_dbg(bridge,
-					"MMU %d, pa: 0x%x, va: 0x%x, size: 0x%x",
-					itmp_entry_ndx,
-					e->gpp_pa,
-					e->dsp_va,
-					e->size);
-
-			hw_mmu_tlb_add(dev_context->dsp_mmu_base,
-					e->gpp_pa,
-					e->dsp_va,
-					e->size,
-					itmp_entry_ndx,
-					&map_attrs, 1, 1);
-
-			itmp_entry_ndx++;
+	mmu = dev_context->dsp_mmu;
+	if (mmu)
+		iommu_put(mmu);
+
+	mmu = iommu_get("iva2");
+	if (IS_ERR(mmu)) {
+		dev_err(bridge, "iommu_get failed!\n");
+		dev_context->dsp_mmu = NULL;
+		return PTR_ERR(mmu);
+	}
+
+	dev_context->dsp_mmu = mmu;
+	mmu->isr = mmu_fault_isr;
+	sm_sg = &dev_context->sh_s;
+	/* Set valid range to map shared memory */
+	status = iommu_set_da_range(mmu, sm_sg->seg0_da,
+					sm_sg->seg1_da + sm_sg->seg1_size);
+	if (status)
+		return status;
+
+	sg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
+					sm_sg->seg0_size, flags);
+	if (IS_ERR_VALUE(sg0_da))
+		return (int)sg0_da;
+
+	sg1_da = iommu_kmap(mmu, sm_sg->seg1_da, sm_sg->seg1_pa,
+					sm_sg->seg1_size, flags);
+	if (IS_ERR_VALUE(sg1_da)) {
+		status = (int)sg1_da;
+		goto err1;
+	}
+
+	for (tlb_i = 0; tlb_i < BRDIOCTL_NUMOFMMUTLB; tlb_i++) {
+		if (!tlb[tlb_i].gpp_pa)
+			continue;
+
+		da = iommu_kmap(mmu, tlb[tlb_i].dsp_va, tlb[tlb_i].gpp_pa,
+				PAGE_SIZE, flags);
+		if (IS_ERR_VALUE(da)) {
+			status = (int)da;
+			goto err2;
 		}
 	}
 
+	l4_i = 0;
+	while (l4_peripheral_table[l4_i].phys_addr) {
+		da = iommu_kmap(mmu, l4_peripheral_table[l4_i].dsp_virt_addr,
+				l4_peripheral_table[l4_i].phys_addr, PAGE_SIZE,
+				flags);
+		if (IS_ERR_VALUE(da)) {
+			status = (int)da;
+			goto err3;
+		}
+		l4_i++;
+	}
+
+	/* Set valid range for DMM mappings */
+	if (0xFFFFF000 - CONFIG_TIDSPBRIDGE_DMM_SIZE <
+				sm_sg->seg1_da + sm_sg->seg1_size) {
+		dev_err(bridge, "DMM size too big!\n");
+		status = -ENOMEM;
+	} else {
+		status = iommu_set_da_range(mmu,
+					sm_sg->seg1_da + sm_sg->seg1_size,
+					sm_sg->seg1_da + sm_sg->seg1_size +
+					CONFIG_TIDSPBRIDGE_DMM_SIZE);
+	}
+
 	/* Lock the above TLB entries and get the BIOS and load monitor timer
 	 * information */
 	if (!status) {
-		hw_mmu_num_locked_set(resources->dmmu_base, itmp_entry_ndx);
-		hw_mmu_victim_num_set(resources->dmmu_base, itmp_entry_ndx);
-		hw_mmu_ttb_set(resources->dmmu_base,
-			       dev_context->pt_attrs->l1_base_pa);
-		hw_mmu_twl_enable(resources->dmmu_base);
-		/* Enable the SmartIdle and AutoIdle bit for MMU_SYSCONFIG */
-
-		temp = __raw_readl((resources->dmmu_base) + 0x10);
-		temp = (temp & 0xFFFFFFEF) | 0x11;
-		__raw_writel(temp, (resources->dmmu_base) + 0x10);
-
-		/* Let the DSP MMU run */
-		hw_mmu_enable(resources->dmmu_base);
-
 		/* Enable the BIOS clock */
 		(void)dev_get_symbol(dev_context->dev_obj,
 				     BRIDGEINIT_BIOSGPTIMER, &ul_bios_gp_timer);
 		(void)dev_get_symbol(dev_context->dev_obj,
 				     BRIDGEINIT_LOADMON_GPTIMER,
 				     &ul_load_monitor_timer);
-	}
 
-	if (!status) {
 		if (ul_load_monitor_timer != 0xFFFF) {
 			clk_cmd = (BPWR_ENABLE_CLOCK << MBX_PM_CLK_CMDSHIFT) |
 			    ul_load_monitor_timer;
@@ -521,9 +539,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			dev_dbg(bridge, "Not able to get the symbol for Load "
 				"Monitor Timer\n");
 		}
-	}
 
-	if (!status) {
 		if (ul_bios_gp_timer != 0xFFFF) {
 			clk_cmd = (BPWR_ENABLE_CLOCK << MBX_PM_CLK_CMDSHIFT) |
 			    ul_bios_gp_timer;
@@ -532,9 +548,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			dev_dbg(bridge,
 				"Not able to get the symbol for BIOS Timer\n");
 		}
-	}
 
-	if (!status) {
 		/* Set the DSP clock rate */
 		(void)dev_get_symbol(dev_context->dev_obj,
 				     "_BRIDGEINIT_DSP_FREQ", &ul_dsp_clk_addr);
@@ -585,9 +599,6 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 		/* Let DSP go */
 		dev_dbg(bridge, "%s Unreset\n", __func__);
-		/* Enable DSP MMU Interrupts */
-		hw_mmu_event_enable(resources->dmmu_base,
-				    HW_MMU_ALL_INTERRUPTS);
 		/* release the RST1, DSP starts executing now .. */
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2_MASK, 0,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
@@ -617,11 +628,28 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 			/* update board state */
 			dev_context->brd_state = BRD_RUNNING;
-			/* (void)chnlsm_enable_interrupt(dev_context); */
+			return 0;
 		} else {
 			dev_context->brd_state = BRD_UNKNOWN;
 		}
 	}
+
+err3:
+	while (l4_i--)
+		iommu_kunmap(mmu, l4_peripheral_table[l4_i].dsp_virt_addr);
+err2:
+	while (tlb_i--) {
+		if (!tlb[tlb_i].gpp_pa)
+			continue;
+		iommu_kunmap(mmu, tlb[tlb_i].gpp_va);
+	}
+
+	if (sg1_da)
+		iommu_kunmap(mmu, sg1_da);
+err1:
+	if (sg0_da)
+		iommu_kunmap(mmu, sg0_da);
+
 	return status;
 }
 
@@ -639,6 +667,8 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	struct bridge_dev_context *dev_context = dev_ctxt;
 	struct pg_table_attrs *pt_attrs;
 	u32 dsp_pwr_state;
+	int i;
+	struct bridge_ioctl_extproc *tlb = dev_context->atlb_entry;
 	struct omap_dsp_platform_data *pdata =
 		omap_dspbridge_dev->dev.platform_data;
 
@@ -682,15 +712,40 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 		memset((u8 *) pt_attrs->pg_info, 0x00,
 		       (pt_attrs->l2_num_pages * sizeof(struct page_info)));
 	}
+	/* Reset DSP */
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2_MASK,
+		OMAP3430_RST1_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+
 	/* Disable the mailbox interrupts */
 	if (dev_context->mbox) {
 		omap_mbox_disable_irq(dev_context->mbox, IRQ_RX);
 		omap_mbox_put(dev_context->mbox, &dsp_mbox_notifier);
 		dev_context->mbox = NULL;
 	}
-	/* Reset IVA2 clocks*/
-	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2_MASK | OMAP3430_RST2_IVA2_MASK |
-			OMAP3430_RST3_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+
+	if (dev_context->dsp_mmu) {
+		i = 0;
+		while (l4_peripheral_table[i].phys_addr) {
+			iommu_kunmap(dev_context->dsp_mmu,
+				l4_peripheral_table[i].dsp_virt_addr);
+			i++;
+		}
+
+		for (i = 0; i < BRDIOCTL_NUMOFMMUTLB; i++) {
+			if (!tlb[i].gpp_pa)
+				continue;
+			iommu_kunmap(dev_context->dsp_mmu, tlb[i].gpp_va);
+		}
+
+		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg1_da);
+		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg0_da);
+		iommu_put(dev_context->dsp_mmu);
+		dev_context->dsp_mmu = NULL;
+	}
+
+	/* Reset IVA IOMMU */
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK,
+		OMAP3430_RST2_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 
 	dsp_clock_disable_all(dev_context->dsp_per_clks);
 	dsp_clk_disable(DSP_CLK_IVA2);
@@ -1130,217 +1185,82 @@ static int bridge_brd_mem_write(struct bridge_dev_context *dev_ctxt,
  *
  *  TODO: Disable MMU while updating the page tables (but that'll stall DSP)
  */
-static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctxt,
-				  u32 ul_mpu_addr, u32 virt_addr,
-				  u32 ul_num_bytes, u32 ul_map_attr,
-				  struct page **mapped_pages)
+static int bridge_brd_mem_map(struct bridge_dev_context *dev_ctx,
+			u32 uva, u32 da, u32 size, struct page **usr_pgs)
+
 {
-	u32 attrs;
-	int status = 0;
-	struct bridge_dev_context *dev_context = dev_ctxt;
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
-	u32 va = virt_addr;
-	struct task_struct *curr_task = current;
-	u32 pg_i = 0;
-	u32 mpu_addr, pa;
-
-	dev_dbg(bridge,
-		"%s hDevCtxt %p, pa %x, va %x, size %x, ul_map_attr %x\n",
-		__func__, dev_ctxt, ul_mpu_addr, virt_addr, ul_num_bytes,
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
-		return mem_map_vmalloc(dev_ctxt, ul_mpu_addr, virt_addr,
-				       ul_num_bytes, &hw_attrs);
-	}
-	/*
-	 * Do OS-specific user-va to pa translation.
-	 * Combine physically contiguous regions to reduce TLBs.
-	 * Pass the translated pa to pte_update.
-	 */
-	if ((attrs & DSP_MAPPHYSICALADDR)) {
-		status = pte_update(dev_context, ul_mpu_addr, virt_addr,
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
+						__func__, uva, size);
 		up_read(&mm->mmap_sem);
-		goto func_cont;
+		return -EINVAL;
 	}
+	if (vma->vm_flags & (VM_WRITE | VM_MAYWRITE))
+		w = 1;
 
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
-			if (status)
-				break;
+	if (vma->vm_flags & VM_IO)
+		i = get_io_pages(mm, uva, pages, usr_pgs);
+	else
+		i = get_user_pages(current, mm, uva, pages, w, 1,
+							usr_pgs, NULL);
+	up_read(&mm->mmap_sem);
 
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
-				if (status)
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
+	if (i < 0)
+		return i;
+
+	if (i < pages) {
+		res = -EFAULT;
+		goto err_pages;
 	}
-	up_read(&mm->mmap_sem);
-func_cont:
-	if (status) {
-		/*
-		 * Roll out the mapped pages incase it failed in middle of
-		 * mapping
-		 */
-		if (pg_i) {
-			bridge_brd_mem_un_map(dev_context, virt_addr,
-					   (pg_i * PG_SIZE4K));
-		}
-		status = -EPERM;
+
+	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt) {
+		res = -ENOMEM;
+		goto err_pages;
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
+
+	res = sg_alloc_table(sgt, pages, GFP_KERNEL);
+
+	if (res < 0)
+		goto err_sg;
+
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
+
+	wake_dsp(dev_ctx, NULL);
+
+	da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+
+	if (!IS_ERR_VALUE(da))
+		return da;
+	res = (int)da;
+
+	sg_free_table(sgt);
+err_sg:
+	kfree(sgt);
+	i = pages;
+err_pages:
+	while (i--)
+		put_page(usr_pgs[i]);
+	return res;
 }
 
 /*
@@ -1351,194 +1271,46 @@ func_cont:
  *      So, instead of looking up the PTE address for every 4K block,
  *      we clear consecutive PTEs until we unmap all the bytes
  */
-static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctxt,
-				     u32 virt_addr, u32 ul_num_bytes)
+static int bridge_brd_mem_un_map(struct bridge_dev_context *dev_ctx, u32 da)
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
-	struct bridge_dev_context *dev_context = dev_ctxt;
-	struct pg_table_attrs *pt = dev_context->pt_attrs;
-	u32 temp;
-	u32 paddr;
-	u32 numof4k_pages = 0;
+	unsigned i;
+	struct sg_table *sgt;
+	struct scatterlist *sg;
 
-	va_curr = virt_addr;
-	rem_bytes = ul_num_bytes;
-	rem_bytes_l2 = 0;
-	l1_base_va = pt->l1_base_va;
-	pte_addr_l1 = hw_mmu_pte_addr_l1(l1_base_va, va_curr);
-	dev_dbg(bridge, "%s dev_ctxt %p, va %x, NumBytes %x l1_base_va %x, "
-		"pte_addr_l1 %x\n", __func__, dev_ctxt, virt_addr,
-		ul_num_bytes, l1_base_va, pte_addr_l1);
+	wake_dsp(dev_ctx, NULL);
 
-	while (rem_bytes && !status) {
-		u32 va_curr_orig = va_curr;
-		/* Find whether the L1 PTE points to a valid L2 PT */
-		pte_addr_l1 = hw_mmu_pte_addr_l1(l1_base_va, va_curr);
-		pte_val = *(u32 *) pte_addr_l1;
-		pte_size = hw_mmu_pte_size_l1(pte_val);
+	sgt = iommu_vunmap(dev_ctx->dsp_mmu, da);
+	if (!sgt)
+		return -EFAULT;
 
-		if (pte_size != HW_MMU_COARSE_PAGE_SIZE)
-			goto skip_coarse_page;
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+		put_page(sg_page(sg));
 
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
+	sg_free_table(sgt);
+	kfree(sgt);
 
-		/*
-		 * Unmap the VA space on this L2 PT. A quicker way
-		 * would be to clear pte_count entries starting from
-		 * pte_addr_l2. However, below code checks that we don't
-		 * clear invalid entries or less than 64KB for a 64KB
-		 * entry. Similar checking is done for L1 PTEs too
-		 * below
-		 */
-		while (rem_bytes_l2 && !status) {
-			pte_val = *(u32 *) pte_addr_l2;
-			pte_size = hw_mmu_pte_size_l2(pte_val);
-			/* va_curr aligned to pte_size? */
-			if (pte_size == 0 || rem_bytes_l2 < pte_size ||
-			    va_curr & (pte_size - 1)) {
-				status = -EPERM;
-				break;
-			}
+	return 0;
+}
 
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
-					set_page_dirty(pg);
-					page_cache_release(pg);
-				}
-				paddr += HW_PAGE_SIZE4KB;
-			}
-			if (hw_mmu_pte_clear(pte_addr_l2, va_curr, pte_size)) {
-				status = -EPERM;
-				goto EXIT_LOOP;
-			}
 
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
-				if (!hw_mmu_pte_clear(l1_base_va, va_curr_orig,
-						     HW_MMU_COARSE_PAGE_SIZE))
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
+static int get_io_pages(struct mm_struct *mm, u32 uva, unsigned pages,
+						struct page **usr_pgs)
+{
+	u32 pa;
+	int i;
+	struct page *pg;
 
-		spin_unlock(&pt->pg_lock);
-		continue;
-skip_coarse_page:
-		/* va_curr aligned to pte_size? */
-		/* pte_size = 1 MB or 16 MB */
-		if (pte_size == 0 || rem_bytes < pte_size ||
-		    va_curr & (pte_size - 1)) {
-			status = -EPERM;
+	for (i = 0; i < pages; i++) {
+		pa = user_va2_pa(mm, uva);
+
+		if (!pfn_valid(__phys_to_pfn(pa)))
 			break;
-		}
 
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
-					set_page_dirty(pg);
-					page_cache_release(pg);
-				}
-			}
-			paddr += HW_PAGE_SIZE4KB;
-		}
-		if (!hw_mmu_pte_clear(l1_base_va, va_curr, pte_size)) {
-			status = 0;
-			rem_bytes -= pte_size;
-			va_curr += pte_size;
-		} else {
-			status = -EPERM;
-			goto EXIT_LOOP;
-		}
+		pg = PHYS_TO_PAGE(pa);
+		usr_pgs[i] = pg;
+		get_page(pg);
 	}
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
+	return i;
 }
 
 /*
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index fdbf4eb..0d6bc4f 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -333,7 +333,7 @@ int wake_dsp(struct bridge_dev_context *dev_context, void *pargs)
 		omap_mbox_restore_ctx(dev_context->mbox);
 
 		/* Access MMU SYS CONFIG register to generate a short wakeup */
-		readl(resources->dmmu_base + 0x10);
+		iommu_read_reg(dev_context->dsp_mmu, MMU_SYSCONFIG);
 
 		dev_context->brd_state = BRD_RUNNING;
 
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index ff350e5..ab221f1 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -134,10 +134,9 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 
 		if (!status) {
 			ul_tlb_base_virt =
-			    dev_context->atlb_entry[0].dsp_va * DSPWORDSIZE;
+			    dev_context->sh_s.seg0_da * DSPWORDSIZE;
 			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
-			dw_ext_prog_virt_mem =
-			    dev_context->atlb_entry[0].gpp_va;
+			dw_ext_prog_virt_mem = dev_context->sh_s.seg0_va;
 
 			if (!trace_read) {
 				ul_shm_offset_virt =
@@ -318,8 +317,9 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 			ret = -EPERM;
 
 		if (!ret) {
-			ul_tlb_base_virt =
-			    dev_context->atlb_entry[0].dsp_va * DSPWORDSIZE;
+			ul_tlb_base_virt = dev_context->sh_s.seg0_da *
+								DSPWORDSIZE;
+
 			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 
 			if (symbols_reloaded) {
@@ -337,7 +337,7 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 			    ul_shm_base_virt - ul_tlb_base_virt;
 			if (trace_load) {
 				dw_ext_prog_virt_mem =
-				    dev_context->atlb_entry[0].gpp_va;
+					dev_context->sh_s.seg0_va;
 			} else {
 				dw_ext_prog_virt_mem = host_res->mem_base[1];
 				dw_ext_prog_virt_mem +=
diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 006ffd7..317e7f6 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -31,7 +31,7 @@
 #include <dspbridge/drv.h>
 #include <dspbridge/wdt.h>
 
-static u32 fault_addr;
+#define MMU_CNTL_TWL_EN		(1 << 2)
 
 static void mmu_fault_dpc(unsigned long data)
 {
@@ -43,43 +43,19 @@ static void mmu_fault_dpc(unsigned long data)
 	bridge_deh_notify(deh, DSP_MMUFAULT, 0);
 }
 
-static irqreturn_t mmu_fault_isr(int irq, void *data)
+int mmu_fault_isr(struct iommu *mmu, u32 da, u32 iommu_errs, void *priv)
 {
-	struct deh_mgr *deh = data;
-	struct cfg_hostres *resources;
-	u32 event;
+	struct deh_mgr *deh;
+
+	dev_get_deh_mgr(dev_get_first(), &deh);
 
 	if (!deh)
-		return IRQ_HANDLED;
+		return -EPERM;
 
-	resources = deh->bridge_context->resources;
-	if (!resources) {
-		dev_dbg(bridge, "%s: Failed to get Host Resources\n",
-				__func__);
-		return IRQ_HANDLED;
-	}
+	iommu_write_reg(mmu, 0, MMU_IRQENABLE);
+	tasklet_schedule(&deh->dpc_tasklet);
 
-	hw_mmu_event_status(resources->dmmu_base, &event);
-	if (event == HW_MMU_TRANSLATION_FAULT) {
-		hw_mmu_fault_addr_read(resources->dmmu_base, &fault_addr);
-		dev_dbg(bridge, "%s: event=0x%x, fault_addr=0x%x\n", __func__,
-				event, fault_addr);
-		/*
-		 * Schedule a DPC directly. In the future, it may be
-		 * necessary to check if DSP MMU fault is intended for
-		 * Bridge.
-		 */
-		tasklet_schedule(&deh->dpc_tasklet);
-
-		/* Disable the MMU events, else once we clear it will
-		 * start to raise INTs again */
-		hw_mmu_event_disable(resources->dmmu_base,
-				HW_MMU_TRANSLATION_FAULT);
-	} else {
-		hw_mmu_event_disable(resources->dmmu_base,
-				HW_MMU_ALL_INTERRUPTS);
-	}
-	return IRQ_HANDLED;
+	return 0;
 }
 
 int bridge_deh_create(struct deh_mgr **ret_deh,
@@ -115,12 +91,6 @@ int bridge_deh_create(struct deh_mgr **ret_deh,
 	/* Fill in context structure */
 	deh->bridge_context = hbridge_context;
 
-	/* Install ISR function for DSP MMU fault */
-	status = request_irq(INT_DSP_MMU_IRQ, mmu_fault_isr, 0,
-			"DspBridge\tiommu fault", deh);
-	if (status < 0)
-		goto err;
-
 	*ret_deh = deh;
 	return 0;
 
@@ -140,8 +110,6 @@ int bridge_deh_destroy(struct deh_mgr *deh)
 		ntfy_delete(deh->ntfy_obj);
 		kfree(deh->ntfy_obj);
 	}
-	/* Disable DSP MMU fault */
-	free_irq(INT_DSP_MMU_IRQ, deh);
 
 	/* Free DPC object */
 	tasklet_kill(&deh->dpc_tasklet);
@@ -169,42 +137,45 @@ int bridge_deh_register_notify(struct deh_mgr *deh, u32 event_mask,
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 {
-	struct cfg_hostres *resources;
-	struct hw_mmu_map_attrs_t map_attrs = {
-		.endianism = HW_LITTLE_ENDIAN,
-		.element_size = HW_ELEM_SIZE16BIT,
-		.mixed_size = HW_MMU_CPUES,
-	};
-	void *dummy_va_addr;
-
-	resources = dev_context->resources;
-	dummy_va_addr = (void*)__get_free_page(GFP_ATOMIC);
+	void *dummy_addr;
+	u32 fa, tmp;
+	struct iotlb_entry e;
+	struct iommu *mmu = dev_context->dsp_mmu;
+	dummy_addr = (void *)__get_free_page(GFP_ATOMIC);
 
 	/*
 	 * Before acking the MMU fault, let's make sure MMU can only
 	 * access entry #0. Then add a new entry so that the DSP OS
 	 * can continue in order to dump the stack.
 	 */
-	hw_mmu_twl_disable(resources->dmmu_base);
-	hw_mmu_tlb_flush_all(resources->dmmu_base);
-
-	hw_mmu_tlb_add(resources->dmmu_base,
-			virt_to_phys(dummy_va_addr), fault_addr,
-			HW_PAGE_SIZE4KB, 1,
-			&map_attrs, HW_SET, HW_SET);
+	tmp = iommu_read_reg(mmu, MMU_CNTL);
+	tmp &= ~MMU_CNTL_TWL_EN;
+	iommu_write_reg(mmu, tmp, MMU_CNTL);
+	fa = iommu_read_reg(mmu, MMU_FAULT_AD);
+	e.da = fa & PAGE_MASK;
+	e.pa = virt_to_phys(dummy_addr);
+	e.valid = 1;
+	e.prsvd = 1;
+	e.pgsz = IOVMF_PGSZ_4K & MMU_CAM_PGSZ_MASK;
+	e.endian = MMU_RAM_ENDIAN_LITTLE;
+	e.elsz = MMU_RAM_ELSZ_32;
+	e.mixed = 0;
+
+	load_iotlb_entry(dev_context->dsp_mmu, &e);
 
 	dsp_clk_enable(DSP_CLK_GPT8);
 
 	dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
 
 	/* Clear MMU interrupt */
-	hw_mmu_event_ack(resources->dmmu_base,
-			HW_MMU_TRANSLATION_FAULT);
+	tmp = iommu_read_reg(mmu, MMU_IRQSTATUS);
+	iommu_write_reg(mmu, tmp, MMU_IRQSTATUS);
+
 	dump_dsp_stack(dev_context);
 	dsp_clk_disable(DSP_CLK_GPT8);
 
-	hw_mmu_disable(resources->dmmu_base);
-	free_page((unsigned long)dummy_va_addr);
+	iopgtable_clear_entry(mmu, fa);
+	free_page((unsigned long)dummy_addr);
 }
 #endif
 
@@ -223,6 +194,7 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
 {
 	struct bridge_dev_context *dev_context;
 	const char *str = event_to_string(event);
+	u32 fa;
 
 	if (!deh)
 		return;
@@ -240,8 +212,8 @@ void bridge_deh_notify(struct deh_mgr *deh, int event, int info)
 #endif
 		break;
 	case DSP_MMUFAULT:
-		dev_err(bridge, "%s: %s, addr=0x%x", __func__,
-				str, fault_addr);
+		fa = iommu_read_reg(dev_context->dsp_mmu, MMU_FAULT_AD);
+		dev_err(bridge, "%s: %s, addr=0x%x", __func__, str, fa);
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 		print_dsp_trace_buffer(dev_context);
 		dump_dl_modules(dev_context);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index ed32bf3..48f91c9 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -175,7 +175,6 @@ typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
 typedef int(*fxn_brd_memmap) (struct bridge_dev_context
 				     * dev_ctxt, u32 ul_mpu_addr,
 				     u32 virt_addr, u32 ul_num_bytes,
-				     u32 map_attr,
 				     struct page **mapped_pages);
 
 /*
@@ -195,7 +194,7 @@ typedef int(*fxn_brd_memmap) (struct bridge_dev_context
  */
 typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
 				       * dev_ctxt,
-				       u32 virt_addr, u32 ul_num_bytes);
+				       u32 da);
 
 /*
  *  ======== bridge_brd_stop ========
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 214dff8..9049df8 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1393,7 +1393,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
 	struct dmm_map_object *map_obj;
-	u32 tmp_addr = 0;
 
 #ifdef CONFIG_TIDSPBRIDGE_CACHE_LINE_CHECK
 	if ((ul_map_attr & BUFMODE_MASK) != RBUF) {
@@ -1419,32 +1418,31 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 	/* Critical section */
 	mutex_lock(&proc_lock);
 	dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (dmm_mgr)
-		status = dmm_map_memory(dmm_mgr, va_align, size_align);
-	else
+	if (!dmm_mgr)
 		status = -EFAULT;
 
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
-			status = (*p_proc_object->intf_fxns->brd_mem_map)
-			    (p_proc_object->bridge_context, pa_align, va_align,
-			     size_align, ul_map_attr, map_obj->pages);
+		} else {
+			va_align = (*p_proc_object->intf_fxns->brd_mem_map)
+			    (p_proc_object->bridge_context, pa_align, 0,
+			     size_align, map_obj->pages);
+			if (IS_ERR_VALUE(va_align))
+				status = va_align;
+		}
 	}
 	if (!status) {
 		/* Mapped address = MSB of VA | LSB of PA */
-		*pp_map_addr = (void *) tmp_addr;
+		map_obj->dsp_addr =
+				(va_align | ((u32)pmpu_addr & (PG_SIZE4K - 1)));
+		*pp_map_addr = (void *)map_obj->dsp_addr;
 	} else {
-		remove_mapping_information(pr_ctxt, tmp_addr, size_align);
-		dmm_un_map_memory(dmm_mgr, va_align, &size_align);
+		remove_mapping_information(pr_ctxt, va_align, size_align);
 	}
 	mutex_unlock(&proc_lock);
 
@@ -1545,39 +1543,14 @@ int proc_reserve_memory(void *hprocessor, u32 ul_size,
 			       void **pp_rsv_addr,
 			       struct process_context *pr_ctxt)
 {
-	struct dmm_object *dmm_mgr;
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-	struct dmm_rsv_object *rsv_obj;
 
 	if (!p_proc_object) {
 		status = -EFAULT;
 		goto func_end;
 	}
 
-	status = dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (!dmm_mgr) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-	status = dmm_reserve_memory(dmm_mgr, ul_size, (u32 *) pp_rsv_addr);
-	if (status != 0)
-		goto func_end;
-
-	/*
-	 * A successful reserve should be followed by insertion of rsv_obj
-	 * into dmm_rsv_list, so that reserved memory resource tracking
-	 * remains uptodate
-	 */
-	rsv_obj = kmalloc(sizeof(struct dmm_rsv_object), GFP_KERNEL);
-	if (rsv_obj) {
-		rsv_obj->dsp_reserved_addr = (u32) *pp_rsv_addr;
-		spin_lock(&pr_ctxt->dmm_rsv_lock);
-		list_add(&rsv_obj->link, &pr_ctxt->dmm_rsv_list);
-		spin_unlock(&pr_ctxt->dmm_rsv_lock);
-	}
-
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p ul_size: 0x%x pp_rsv_addr: 0x%p "
 		"status 0x%x\n", __func__, hprocessor,
@@ -1736,7 +1709,6 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	struct dmm_object *dmm_mgr;
 	struct dmm_map_object *dmo;
 	u32 va_align;
-	u32 size_align;
 
 	va_align = PG_ALIGN_LOW((u32) map_addr, PG_SIZE4K);
 	if (!p_proc_object) {
@@ -1752,22 +1724,14 @@ int proc_un_map(void *hprocessor, void *map_addr,
 
 	/* Critical section */
 	mutex_lock(&proc_lock);
-	/*
-	 * Update DMM structures. Get the size to unmap.
-	 * This function returns error if the VA is not mapped
-	 */
-	status = dmm_un_map_memory(dmm_mgr, (u32) va_align, &size_align);
 
 	dmo = find_containing_mapping_da(pr_ctxt, (u32)map_addr);
 	if (!dmo)
 		goto unmap_failed;
 
 	/* Remove mapping from the page tables. */
-	if (!status) {
-		status = (*p_proc_object->intf_fxns->brd_mem_un_map)
-		    (p_proc_object->bridge_context, va_align, dmo->size);
-	}
-
+	status = (*p_proc_object->intf_fxns->brd_mem_un_map)
+			(p_proc_object->bridge_context, va_align);
 	if (status)
 		goto unmap_failed;
 
@@ -1795,41 +1759,14 @@ func_end:
 int proc_un_reserve_memory(void *hprocessor, void *prsv_addr,
 				  struct process_context *pr_ctxt)
 {
-	struct dmm_object *dmm_mgr;
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-	struct dmm_rsv_object *rsv_obj;
 
 	if (!p_proc_object) {
 		status = -EFAULT;
 		goto func_end;
 	}
 
-	status = dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (!dmm_mgr) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-	status = dmm_un_reserve_memory(dmm_mgr, (u32) prsv_addr);
-	if (status != 0)
-		goto func_end;
-
-	/*
-	 * A successful unreserve should be followed by removal of rsv_obj
-	 * from dmm_rsv_list, so that reserved memory resource tracking
-	 * remains uptodate
-	 */
-	spin_lock(&pr_ctxt->dmm_rsv_lock);
-	list_for_each_entry(rsv_obj, &pr_ctxt->dmm_rsv_list, link) {
-		if (rsv_obj->dsp_reserved_addr == (u32) prsv_addr) {
-			list_del(&rsv_obj->link);
-			kfree(rsv_obj);
-			break;
-		}
-	}
-	spin_unlock(&pr_ctxt->dmm_rsv_lock);
-
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p prsv_addr: 0x%p status: 0x%x\n",
 		__func__, hprocessor, prsv_addr, status);
-- 
1.7.1

