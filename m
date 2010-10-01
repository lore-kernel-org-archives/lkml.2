Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0JACBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:01:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35029 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0JAB7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:59:38 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 02/11] staging: tidspbridge - move shared memory iommu maps to tiomap3430.c
Date: Thu, 30 Sep 2010 21:12:49 -0500
Message-Id: <1285899178-14413-3-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285899178-14413-2-git-send-email-x0095840@ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
 <1285899178-14413-2-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now iommu maps of shared memory segments are done in
bridge_brd_start and unmaped in bridge_brd_stop.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/_tiomap.h    |   13 +++
 drivers/staging/tidspbridge/core/io_sm.c      |  125 +++--------------------
 drivers/staging/tidspbridge/core/tiomap3430.c |  136 +++++++++++++++++++-----
 drivers/staging/tidspbridge/core/tiomap_io.c  |   12 +-
 4 files changed, 139 insertions(+), 147 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index a42c393..c1bf95d 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -308,6 +308,18 @@ static const struct bpwr_clk_t bpwr_clks[] = {
 
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
+
 /* This Bridge driver's device context: */
 struct bridge_dev_context {
 	struct dev_object *hdev_obj;	/* Handle to Bridge device object. */
@@ -331,6 +343,7 @@ struct bridge_dev_context {
 
 	struct omap_mbox *mbox;		/* Mail box handle */
 	struct iommu *dsp_mmu;      /* iommu for iva2 handler */
+	struct shm_segs sh_s;
 	struct cfg_hostres *resources;	/* Host Resources */
 
 	/*
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 842b8db..56856ad 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -291,7 +291,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	struct cod_manager *cod_man;
 	struct chnl_mgr *hchnl_mgr;
 	struct msg_mgr *hmsg_mgr;
-	struct iommu *mmu;
+	struct shm_segs *sm_sg;
 	u32 ul_shm_base;
 	u32 ul_shm_base_offset;
 	u32 ul_shm_limit;
@@ -317,14 +317,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
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
 
 	status = dev_get_bridge_context(hio_mgr->hdev_obj, &pbridge_context);
 	if (!pbridge_context) {
@@ -337,19 +329,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		status = -EFAULT;
 		goto func_end;
 	}
-	mmu = pbridge_context->dsp_mmu;
-
-	if (mmu)
-		iommu_put(mmu);
-	mmu = iommu_get("iva2");
-
-	if (IS_ERR_OR_NULL(mmu)) {
-		dev_err(bridge, "iommu_get failed!\n");
-		pbridge_context->dsp_mmu = NULL;
-		status = -EFAULT;
-		goto func_end;
-	}
-	pbridge_context->dsp_mmu = mmu;
+	sm_sg = &pbridge_context->sh_s;
 
 	status = dev_get_cod_mgr(hio_mgr->hdev_obj, &cod_man);
 	if (!cod_man) {
@@ -485,74 +465,14 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	if (status)
 		goto func_end;
 
-	pa_curr = ul_gpp_pa;
-	va_curr = ul_dyn_ext_base * hio_mgr->word_size;
-	gpp_va_curr = ul_gpp_va;
-	num_bytes = ul_seg1_size;
-
-	va_curr = iommu_kmap(mmu, va_curr, pa_curr, num_bytes,
-					IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
-	if (IS_ERR_VALUE(va_curr)) {
-		status = (int)va_curr;
-		goto func_end;
-	}
-
-	pa_curr += ul_pad_size + num_bytes;
-	va_curr += ul_pad_size + num_bytes;
-	gpp_va_curr += ul_pad_size + num_bytes;
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
-				ae_proc[ndx].ul_gpp_pa = pa_curr;
-				/*
-				 * This is the virtual uncached ioremapped
-				 * address!!!
-				 */
-				ae_proc[ndx].ul_gpp_va = gpp_va_curr;
-				ae_proc[ndx].ul_dsp_va =
-				    va_curr / hio_mgr->word_size;
-				ae_proc[ndx].ul_size = page_size[i];
-				ae_proc[ndx].endianism = HW_LITTLE_ENDIAN;
-				ae_proc[ndx].elem_size = HW_ELEM_SIZE16BIT;
-				ae_proc[ndx].mixed_mode = HW_MMU_CPUES;
-				dev_dbg(bridge, "shm MMU TLB entry PA %x"
-					" VA %x DSP_VA %x Size %x\n",
-					ae_proc[ndx].ul_gpp_pa,
-					ae_proc[ndx].ul_gpp_va,
-					ae_proc[ndx].ul_dsp_va *
-					hio_mgr->word_size, page_size[i]);
-				ndx++;
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
@@ -599,24 +519,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 			goto func_end;
 	}
 
-	/* Map the L4 peripherals */
-	i = 0;
-	while (l4_peripheral_table[i].phys_addr) {
-		status = iommu_kmap(mmu, l4_peripheral_table[i].
-			dsp_virt_addr, l4_peripheral_table[i].phys_addr,
-			PAGE_SIZE, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
-		if (IS_ERR_VALUE(status))
-			break;
-		i++;
-	}
-	if (IS_ERR_VALUE(status)) {
-		while (i--)
-			iommu_kunmap(mmu, l4_peripheral_table[i].
-						dsp_virt_addr);
-		goto func_end;
-	}
-	status = 0;
-
 	for (i = ndx; i < BRDIOCTL_NUMOFMMUTLB; i++) {
 		ae_proc[i].ul_dsp_va = 0;
 		ae_proc[i].ul_gpp_pa = 0;
@@ -639,12 +541,12 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		status = -EFAULT;
 		goto func_end;
 	} else {
-		if (ae_proc[0].ul_dsp_va > ul_shm_base) {
+		if (sm_sg->seg0_da > ul_shm_base) {
 			status = -EPERM;
 			goto func_end;
 		}
 		/* ul_shm_base may not be at ul_dsp_va address */
-		ul_shm_base_offset = (ul_shm_base - ae_proc[0].ul_dsp_va) *
+		ul_shm_base_offset = (ul_shm_base - sm_sg->seg0_da) *
 		    hio_mgr->word_size;
 		/*
 		 * bridge_dev_ctrl() will set dev context dsp-mmu info. In
@@ -668,8 +570,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 			goto func_end;
 		}
 		/* Register SM */
-		status =
-		    register_shm_segs(hio_mgr, cod_man, ae_proc[0].ul_gpp_pa);
+		status = register_shm_segs(hio_mgr, cod_man, sm_sg->seg0_pa);
 	}
 
 	hio_mgr->shared_mem = (struct shm *)ul_shm_base;
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index ec96e28..721116b 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -287,8 +287,7 @@ static int bridge_brd_monitor(struct bridge_dev_context *dev_ctxt)
 		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_DISABLE_AUTO,
 					OMAP3430_IVA2_MOD, OMAP2_CM_CLKSTCTRL);
 	}
-	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
-					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+
 	dsp_clk_enable(DSP_CLK_IVA2);
 
 	/* set the device state to IDLE */
@@ -359,15 +358,17 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 {
 	int status = 0;
 	struct bridge_dev_context *dev_context = dev_ctxt;
-	struct iommu *mmu;
+	struct iommu *mmu = NULL;
+	struct shm_segs *sm_sg;
+	int l4_i = 0, tlb_i = 0;
+	u32 sg0_da = 0, sg1_da = 0;
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
@@ -379,7 +380,6 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	struct dspbridge_platform_data *pdata =
 				omap_dspbridge_dev->dev.platform_data;
 
-	mmu = dev_context->dsp_mmu;
 	/* The device context contains all the mmu setup info from when the
 	 * last dsp base image was loaded. The first entry is always
 	 * SHMMEM base. */
@@ -389,12 +389,12 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	ul_shm_base_virt *= DSPWORDSIZE;
 	DBC_ASSERT(ul_shm_base_virt != 0);
 	/* DSP Virtual address */
-	ul_tlb_base_virt = dev_context->atlb_entry[0].ul_dsp_va;
+	ul_tlb_base_virt = dev_context->sh_s.seg0_da;
 	DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 	ul_shm_offset_virt =
 	    ul_shm_base_virt - (ul_tlb_base_virt * DSPWORDSIZE);
 	/* Kernel logical address */
-	ul_shm_base = dev_context->atlb_entry[0].ul_gpp_va + ul_shm_offset_virt;
+	ul_shm_base = dev_context->sh_s.seg0_va + ul_shm_offset_virt;
 
 	DBC_ASSERT(ul_shm_base != 0);
 	/* 2nd wd is used as sync field */
@@ -429,25 +429,70 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 					OMAP343X_CONTROL_IVA2_BOOTMOD));
 		}
 	}
-	if (!status) {
-		/* Only make TLB entry if both addresses are non-zero */
-		for (entry_ndx = 0; entry_ndx < BRDIOCTL_NUMOFMMUTLB;
-		     entry_ndx++) {
-			struct bridge_ioctl_extproc *e = &dev_context->atlb_entry[entry_ndx];
 
-			if (!e->ul_gpp_pa || !e->ul_dsp_va)
+	if (!status) {
+		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
+					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+		mmu = dev_context->dsp_mmu;
+		if (mmu)
+			iommu_put(mmu);
+		mmu = iommu_get("iva2");
+		if (IS_ERR(mmu)) {
+			dev_err(bridge, "iommu_get failed!\n");
+			dev_context->dsp_mmu = NULL;
+			status = (int)mmu;
+		}
+	}
+	if (!status) {
+		dev_context->dsp_mmu = mmu;
+		sm_sg = &dev_context->sh_s;
+		sg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
+			sm_sg->seg0_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+		if (IS_ERR_VALUE(sg0_da)) {
+			status = (int)sg0_da;
+			sg0_da = 0;
+		}
+	}
+	if (!status) {
+		sg1_da = iommu_kmap(mmu, sm_sg->seg1_da, sm_sg->seg1_pa,
+			sm_sg->seg1_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+		if (IS_ERR_VALUE(sg1_da)) {
+			status = (int)sg1_da;
+			sg1_da = 0;
+		}
+	}
+	if (!status) {
+		u32 da;
+		for (tlb_i = 0; tlb_i < BRDIOCTL_NUMOFMMUTLB; tlb_i++) {
+			if (!tlb[tlb_i].ul_gpp_pa)
 				continue;
 
-			dev_dbg(bridge,
-					"MMU %d, pa: 0x%x, va: 0x%x, size: 0x%x",
-					itmp_entry_ndx,
-					e->ul_gpp_pa,
-					e->ul_dsp_va,
-					e->ul_size);
+			dev_dbg(bridge, "IOMMU %d GppPa: 0x%x DspVa 0x%x Size"
+				" 0x%x\n", tlb_i, tlb[tlb_i].ul_gpp_pa,
+				tlb[tlb_i].ul_dsp_va, tlb[tlb_i].ul_size);
 
-			iommu_kmap(mmu, e->ul_dsp_va, e->ul_gpp_pa, e->ul_size,
+			da = iommu_kmap(mmu, tlb[tlb_i].ul_dsp_va,
+				tlb[tlb_i].ul_gpp_pa, PAGE_SIZE,
+				IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+			if (IS_ERR_VALUE(da)) {
+				status = (int)da;
+				break;
+			}
+		}
+	}
+	if (!status) {
+		u32 da;
+		l4_i = 0;
+		while (l4_peripheral_table[l4_i].phys_addr) {
+			da = iommu_kmap(mmu, l4_peripheral_table[l4_i].
+				dsp_virt_addr, l4_peripheral_table[l4_i].
+				phys_addr, PAGE_SIZE,
 				IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
-			itmp_entry_ndx++;
+			if (IS_ERR_VALUE(da)) {
+				status = (int)da;
+				break;
+			}
+			l4_i++;
 		}
 	}
 
@@ -560,11 +605,23 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 
 			/* update board state */
 			dev_context->dw_brd_state = BRD_RUNNING;
-			/* (void)chnlsm_enable_interrupt(dev_context); */
+			return 0;
 		} else {
 			dev_context->dw_brd_state = BRD_UNKNOWN;
 		}
 	}
+
+	while (tlb_i--) {
+		if (!tlb[tlb_i].ul_gpp_pa)
+			continue;
+		iommu_kunmap(mmu, tlb[tlb_i].ul_gpp_va);
+	}
+	while (l4_i--)
+		iommu_kunmap(mmu, l4_peripheral_table[l4_i].dsp_virt_addr);
+	if (sg0_da)
+		iommu_kunmap(mmu, sg0_da);
+	if (sg1_da)
+		iommu_kunmap(mmu, sg1_da);
 	return status;
 }
 
@@ -582,7 +639,8 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
 	struct bridge_dev_context *dev_context = dev_ctxt;
 	struct pg_table_attrs *pt_attrs;
 	u32 dsp_pwr_state;
-	int clk_status;
+	int clk_status, i;
+	struct bridge_ioctl_extproc *tlb = dev_context->atlb_entry;
 	struct dspbridge_platform_data *pdata =
 				omap_dspbridge_dev->dev.platform_data;
 
@@ -626,17 +684,37 @@ static int bridge_brd_stop(struct bridge_dev_context *dev_ctxt)
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
 		omap_mbox_put(dev_context->mbox);
 		dev_context->mbox = NULL;
 	}
-	if (dev_context->dsp_mmu)
-		dev_context->dsp_mmu = (iommu_put(dev_context->dsp_mmu), NULL);
-	/* Reset IVA2 clocks*/
-	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2_MASK | OMAP3430_RST2_IVA2_MASK |
-			OMAP3430_RST3_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
+	if (dev_context->dsp_mmu) {
+		pr_err("Proc stop mmu if statement\n");
+		for (i = 0; i < BRDIOCTL_NUMOFMMUTLB; i++) {
+			if (!tlb[i].ul_gpp_pa)
+				continue;
+			iommu_kunmap(dev_context->dsp_mmu, tlb[i].ul_gpp_va);
+		}
+		i = 0;
+		while (l4_peripheral_table[i].phys_addr) {
+			iommu_kunmap(dev_context->dsp_mmu,
+				l4_peripheral_table[i].dsp_virt_addr);
+			i++;
+		}
+		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg0_da);
+		iommu_kunmap(dev_context->dsp_mmu, dev_context->sh_s.seg1_da);
+		iommu_put(dev_context->dsp_mmu);
+		dev_context->dsp_mmu = NULL;
+	}
+	/* Reset IVA IOMMU*/
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK,
+		OMAP3430_RST2_IVA2_MASK, OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
 
 	clk_status = dsp_clk_disable(DSP_CLK_IVA2);
 
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index e78a7cd..1300bd3 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -132,10 +132,9 @@ int read_ext_dsp_data(struct bridge_dev_context *dev_ctxt,
 
 		if (!status) {
 			ul_tlb_base_virt =
-			    dev_context->atlb_entry[0].ul_dsp_va * DSPWORDSIZE;
+			    dev_context->sh_s.seg0_da * DSPWORDSIZE;
 			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
-			dw_ext_prog_virt_mem =
-			    dev_context->atlb_entry[0].ul_gpp_va;
+			dw_ext_prog_virt_mem = dev_context->sh_s.seg0_va;
 
 			if (!trace_read) {
 				ul_shm_offset_virt =
@@ -316,8 +315,9 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 			ret = -EPERM;
 
 		if (!ret) {
-			ul_tlb_base_virt =
-			    dev_context->atlb_entry[0].ul_dsp_va * DSPWORDSIZE;
+			ul_tlb_base_virt = dev_context->sh_s.seg0_da *
+								DSPWORDSIZE;
+
 			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 
 			if (symbols_reloaded) {
@@ -335,7 +335,7 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 			    ul_shm_base_virt - ul_tlb_base_virt;
 			if (trace_load) {
 				dw_ext_prog_virt_mem =
-				    dev_context->atlb_entry[0].ul_gpp_va;
+					dev_context->sh_s.seg0_va;
 			} else {
 				dw_ext_prog_virt_mem = host_res->dw_mem_base[1];
 				dw_ext_prog_virt_mem +=
-- 
1.6.3.3

