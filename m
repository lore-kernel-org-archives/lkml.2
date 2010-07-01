Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0GAANm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:13:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38022 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab0GAALl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:11:41 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyu@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 2/9] dspbridge: move shared memory iommu maps to tiomap3430.c
Date: Wed, 30 Jun 2010 19:20:53 -0500
Message-Id: <1277943660-4112-3-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277943660-4112-2-git-send-email-x0095840@ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
 <1277943660-4112-2-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the iommu map of shared memory segments are done in
bridge_brd_start and unmaped in bridge_brd_stop.

NOTE: video sequencer reset is not done in dspbridge anymore,
due to dspbridge does not manage it.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/dsp/bridge/core/_tiomap.h    |    6 +
 drivers/dsp/bridge/core/io_sm.c      |  117 ++----------
 drivers/dsp/bridge/core/tiomap3430.c |  353 ++++++++++++++++++++--------------
 drivers/dsp/bridge/core/tiomap_io.c  |   11 +-
 4 files changed, 237 insertions(+), 250 deletions(-)

diff --git a/drivers/dsp/bridge/core/_tiomap.h b/drivers/dsp/bridge/core/_tiomap.h
index d13677a..6a822c6 100644
--- a/drivers/dsp/bridge/core/_tiomap.h
+++ b/drivers/dsp/bridge/core/_tiomap.h
@@ -310,6 +310,11 @@ static const struct bpwr_clk_t bpwr_clks[] = {
 
 #define CLEAR_BIT_INDEX(reg, index)   (reg &= ~(1 << (index)))
 
+struct shm_segs {
+	u32 seg0_da, seg0_pa, seg0_va, seg0_size;
+	u32 seg1_da, seg1_pa, seg1_va, seg1_size;
+};
+
 /* This Bridge driver's device context: */
 struct bridge_dev_context {
 	struct dev_object *hdev_obj;	/* Handle to Bridge device object. */
@@ -333,6 +338,7 @@ struct bridge_dev_context {
 
 	struct omap_mbox *mbox;		/* Mail box handle */
 	struct iommu *dsp_mmu;		/* iommu for iva2 handler */
+	struct shm_segs *sh_s;
 
 	struct cfg_hostres *resources;	/* Host Resources */
 
diff --git a/drivers/dsp/bridge/core/io_sm.c b/drivers/dsp/bridge/core/io_sm.c
index 1f47f8b..aca9854 100644
--- a/drivers/dsp/bridge/core/io_sm.c
+++ b/drivers/dsp/bridge/core/io_sm.c
@@ -290,8 +290,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	struct cod_manager *cod_man;
 	struct chnl_mgr *hchnl_mgr;
 	struct msg_mgr *hmsg_mgr;
-	struct iommu *mmu;
-	struct iotlb_entry e;
+	struct shm_segs *sm_sg;
 	u32 ul_shm_base;
 	u32 ul_shm_base_offset;
 	u32 ul_shm_limit;
@@ -317,14 +316,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
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
@@ -338,19 +329,12 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		goto func_end;
 	}
 
-	mmu = pbridge_context->dsp_mmu;
+	sm_sg = kmalloc(sizeof(*sm_sg), GFP_KERNEL);
 
-	if (mmu)
-		iommu_put(mmu);
-	mmu = iommu_get("iva2");
-
-	if (IS_ERR_OR_NULL(mmu)) {
-		pr_err("Error in iommu_get\n");
-		pbridge_context->dsp_mmu = NULL;
-		status = -EFAULT;
+	if (!sm_sg) {
+		status = -ENOMEM;
 		goto func_end;
 	}
-	pbridge_context->dsp_mmu = mmu;
 
 	status = dev_get_cod_mgr(hio_mgr->hdev_obj, &cod_man);
 	if (!cod_man) {
@@ -488,74 +472,16 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 	if (DSP_FAILED(status))
 		goto func_end;
 
-	pa_curr = ul_gpp_pa;
-	va_curr = ul_dyn_ext_base * hio_mgr->word_size;
-	gpp_va_curr = ul_gpp_va;
-	num_bytes = ul_seg1_size;
+	sm_sg->seg1_pa = ul_gpp_pa;
+	sm_sg->seg1_da = ul_dyn_ext_base;
+	sm_sg->seg1_va = ul_gpp_va;
+	sm_sg->seg1_size = ul_seg1_size;
+	sm_sg->seg0_pa = ul_gpp_pa + ul_pad_size + ul_seg1_size;
+	sm_sg->seg0_da = ul_dsp_va;
+	sm_sg->seg0_va = ul_gpp_va + ul_pad_size + ul_seg1_size;
+	sm_sg->seg0_size = ul_seg_size;
 
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
+	pbridge_context->sh_s = sm_sg;
 
 	/*
 	 * Copy remaining entries from CDB. All entries are 1 MB and
@@ -602,17 +528,6 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 			goto func_end;
 	}
 
-	dsp_iotlb_init(&e, 0, 0, IOVMF_PGSZ_4K);
-
-	/* Map the L4 peripherals */
-	i = 0;
-	while (l4_peripheral_table[i].phys_addr) {
-		e.da = l4_peripheral_table[i].dsp_virt_addr;
-		e.pa = l4_peripheral_table[i].phys_addr;
-		iopgtable_store_entry(mmu, &e);
-		i++;
-	}
-
 	for (i = ndx; i < BRDIOCTL_NUMOFMMUTLB; i++) {
 		ae_proc[i].ul_dsp_va = 0;
 		ae_proc[i].ul_gpp_pa = 0;
@@ -635,12 +550,12 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
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
@@ -665,7 +580,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 		}
 		/* Register SM */
 		status =
-		    register_shm_segs(hio_mgr, cod_man, ae_proc[0].ul_gpp_pa);
+		    register_shm_segs(hio_mgr, cod_man, sm_sg->seg0_pa);
 	}
 
 	hio_mgr->shared_mem = (struct shm *)ul_shm_base;
diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
index e750767..89d4936 100644
--- a/drivers/dsp/bridge/core/tiomap3430.c
+++ b/drivers/dsp/bridge/core/tiomap3430.c
@@ -300,8 +300,7 @@ static int bridge_brd_monitor(struct bridge_dev_context *hDevContext)
 		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_DISABLE_AUTO,
 					OMAP3430_IVA2_MOD, CM_CLKSTCTRL);
 	}
-	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2, 0,
-					OMAP3430_IVA2_MOD, RM_RSTCTRL);
+
 	dsp_clk_enable(DSP_CLK_IVA2);
 
 	if (DSP_SUCCEEDED(status)) {
@@ -374,15 +373,16 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 	int status = 0;
 	struct bridge_dev_context *dev_context = hDevContext;
 	struct iommu *mmu;
-	struct iotlb_entry en;
+	struct iotlb_entry e;
+	struct shm_segs *sm_sg;
+	int i;
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
@@ -394,8 +394,6 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 	struct dspbridge_platform_data *pdata =
 				omap_dspbridge_dev->dev.platform_data;
 
-	mmu = dev_context->dsp_mmu;
-
 	/* The device context contains all the mmu setup info from when the
 	 * last dsp base image was loaded. The first entry is always
 	 * SHMMEM base. */
@@ -405,12 +403,12 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 	ul_shm_base_virt *= DSPWORDSIZE;
 	DBC_ASSERT(ul_shm_base_virt != 0);
 	/* DSP Virtual address */
-	ul_tlb_base_virt = dev_context->atlb_entry[0].ul_dsp_va;
+	ul_tlb_base_virt = dev_context->sh_s->seg0_da;
 	DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 	ul_shm_offset_virt =
 	    ul_shm_base_virt - (ul_tlb_base_virt * DSPWORDSIZE);
 	/* Kernel logical address */
-	ul_shm_base = dev_context->atlb_entry[0].ul_gpp_va + ul_shm_offset_virt;
+	ul_shm_base = dev_context->sh_s->seg0_va + ul_shm_offset_virt;
 
 	DBC_ASSERT(ul_shm_base != 0);
 	/* 2nd wd is used as sync field */
@@ -445,152 +443,193 @@ static int bridge_brd_start(struct bridge_dev_context *hDevContext,
 					OMAP343X_CONTROL_IVA2_BOOTMOD));
 		}
 	}
-	if (DSP_SUCCEEDED(status)) {
-		/* Only make TLB entry if both addresses are non-zero */
-		for (entry_ndx = 0; entry_ndx < BRDIOCTL_NUMOFMMUTLB;
-		     entry_ndx++) {
-			struct bridge_ioctl_extproc *e = &dev_context->atlb_entry[entry_ndx];
-			if (!e->ul_gpp_pa || !e->ul_dsp_va)
-				continue;
-
-			dev_dbg(bridge,
-					"MMU %d, pa: 0x%x, va: 0x%x, size: 0x%x",
-					itmp_entry_ndx,
-					e->ul_gpp_pa,
-					e->ul_dsp_va,
-					e->ul_size);
-
-			dsp_iotlb_init(&en, e->ul_dsp_va, e->ul_gpp_pa,
-					bytes_to_iopgsz(e->ul_size));
-			iopgtable_store_entry(mmu, &en);
-			itmp_entry_ndx++;
-		}
+
+	if (status)
+		goto err1;
+
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2, 0,
+					OMAP3430_IVA2_MOD, RM_RSTCTRL);
+
+	mmu = dev_context->dsp_mmu;
+
+	if (mmu)
+		iommu_put(mmu);
+	mmu = iommu_get("iva2");
+
+	if (IS_ERR(mmu)) {
+		pr_err("Error in iommu_get %ld\n", PTR_ERR(mmu));
+		dev_context->dsp_mmu = NULL;
+		status = (int)mmu;
+		goto end;
 	}
+	dev_context->dsp_mmu = mmu;
+	sm_sg = dev_context->sh_s;
 
-	/* Lock the above TLB entries and get the BIOS and load monitor timer
-	 * information */
-	if (DSP_SUCCEEDED(status)) {
+	sm_sg->seg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
+			sm_sg->seg0_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
 
-		/* Enable the BIOS clock */
-		(void)dev_get_symbol(dev_context->hdev_obj,
-				     BRIDGEINIT_BIOSGPTIMER, &ul_bios_gp_timer);
-		(void)dev_get_symbol(dev_context->hdev_obj,
-				     BRIDGEINIT_LOADMON_GPTIMER,
-				     &ul_load_monitor_timer);
-		if (ul_load_monitor_timer != 0xFFFF) {
-			clk_cmd = (BPWR_ENABLE_CLOCK << MBX_PM_CLK_CMDSHIFT) |
-			    ul_load_monitor_timer;
-			dsp_peripheral_clk_ctrl(dev_context, &clk_cmd);
-		} else {
-			dev_dbg(bridge, "Not able to get the symbol for Load "
-				"Monitor Timer\n");
-		}
+	if (IS_ERR_VALUE(sm_sg->seg0_da)) {
+		status = (int)sm_sg->seg0_da;
+		goto err1;
 	}
 
-	if (DSP_SUCCEEDED(status)) {
-		if (ul_bios_gp_timer != 0xFFFF) {
-			clk_cmd = (BPWR_ENABLE_CLOCK << MBX_PM_CLK_CMDSHIFT) |
-			    ul_bios_gp_timer;
-			dsp_peripheral_clk_ctrl(dev_context, &clk_cmd);
-		} else {
-			dev_dbg(bridge,
-				"Not able to get the symbol for BIOS Timer\n");
-		}
+	sm_sg->seg1_da = iommu_kmap(mmu, sm_sg->seg1_da, sm_sg->seg1_pa,
+			sm_sg->seg1_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
+
+	if (IS_ERR_VALUE(sm_sg->seg1_da)) {
+		iommu_kunmap(mmu, sm_sg->seg0_da);
+		status = (int)sm_sg->seg1_da;
+		goto err2;
 	}
 
-	if (DSP_SUCCEEDED(status)) {
-		/* Set the DSP clock rate */
-		(void)dev_get_symbol(dev_context->hdev_obj,
-				     "_BRIDGEINIT_DSP_FREQ", &ul_dsp_clk_addr);
-		/*Set Autoidle Mode for IVA2 PLL */
-		(*pdata->dsp_cm_write)(1 << OMAP3430_AUTO_IVA2_DPLL_SHIFT,
-				OMAP3430_IVA2_MOD, OMAP3430_CM_AUTOIDLE_PLL);
-
-		if ((unsigned int *)ul_dsp_clk_addr != NULL) {
-			/* Get the clock rate */
-			ul_dsp_clk_rate = dsp_clk_get_iva2_rate();
-			dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x \n",
-				__func__, ul_dsp_clk_rate);
-			(void)bridge_brd_write(dev_context,
-					       (u8 *) &ul_dsp_clk_rate,
-					       ul_dsp_clk_addr, sizeof(u32), 0);
-		}
-		/*
-		 * Enable Mailbox events and also drain any pending
-		 * stale messages.
-		 */
-		dev_context->mbox = omap_mbox_get("dsp");
-		if (IS_ERR(dev_context->mbox)) {
-			dev_context->mbox = NULL;
-			pr_err("%s: Failed to get dsp mailbox handle\n",
-								__func__);
-			status = -EPERM;
-		}
+	dsp_iotlb_init(&e, 0, 0, IOVMF_PGSZ_4K);
 
+	/* Map the L4 peripherals */
+	i = 0;
+	while (l4_peripheral_table[i].phys_addr) {
+		e.da = l4_peripheral_table[i].dsp_virt_addr;
+		e.pa = l4_peripheral_table[i].phys_addr;
+		iopgtable_store_entry(mmu, &e);
+		i++;
+	}
+
+	for (i = 0; i < BRDIOCTL_NUMOFMMUTLB; i++) {
+		if (!tlb[i].ul_gpp_pa)
+			continue;
+
+		dev_dbg(bridge, "(proc) MMU %d GppPa: 0x%x DspVa 0x%x Size"
+			" 0x%x\n", i, tlb[i].ul_gpp_pa, tlb[i].ul_dsp_va,
+			tlb[i].ul_size);
+
+		dsp_iotlb_init(&e, tlb[i].ul_dsp_va, tlb[i].ul_gpp_pa,
+					bytes_to_iopgsz(tlb[i].ul_size));
+		iopgtable_store_entry(mmu, &e);
 	}
-	if (DSP_SUCCEEDED(status)) {
-		dev_context->mbox->rxq->callback = (int (*)(void *))io_mbox_msg;
+
+	/* Get the BIOS and load monitor timer information */
+	/* Enable the BIOS clock */
+	(void)dev_get_symbol(dev_context->hdev_obj,
+			     BRIDGEINIT_BIOSGPTIMER, &ul_bios_gp_timer);
+	(void)dev_get_symbol(dev_context->hdev_obj,
+			     BRIDGEINIT_LOADMON_GPTIMER,
+			     &ul_load_monitor_timer);
+	if (ul_load_monitor_timer != 0xFFFF) {
+		clk_cmd = (BPWR_ENABLE_CLOCK << MBX_PM_CLK_CMDSHIFT) |
+		    ul_load_monitor_timer;
+		dsp_peripheral_clk_ctrl(dev_context, &clk_cmd);
+	} else {
+		dev_dbg(bridge, "Not able to get the symbol for Load "
+			"Monitor Timer\n");
+	}
+
+	if (ul_bios_gp_timer != 0xFFFF) {
+		clk_cmd = (BPWR_ENABLE_CLOCK << MBX_PM_CLK_CMDSHIFT) |
+		    ul_bios_gp_timer;
+		dsp_peripheral_clk_ctrl(dev_context, &clk_cmd);
+	} else {
+		dev_dbg(bridge,
+			"Not able to get the symbol for BIOS Timer\n");
+	}
+
+	/* Set the DSP clock rate */
+	(void)dev_get_symbol(dev_context->hdev_obj,
+			     "_BRIDGEINIT_DSP_FREQ", &ul_dsp_clk_addr);
+	/*Set Autoidle Mode for IVA2 PLL */
+	(*pdata->dsp_cm_write)(1 << OMAP3430_AUTO_IVA2_DPLL_SHIFT,
+			OMAP3430_IVA2_MOD, OMAP3430_CM_AUTOIDLE_PLL);
+
+	if ((unsigned int *)ul_dsp_clk_addr != NULL) {
+		/* Get the clock rate */
+		ul_dsp_clk_rate = dsp_clk_get_iva2_rate();
+		dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x \n",
+			__func__, ul_dsp_clk_rate);
+		(void)bridge_brd_write(dev_context,
+				       (u8 *) &ul_dsp_clk_rate,
+				       ul_dsp_clk_addr, sizeof(u32), 0);
+	}
+	/*
+	 * Enable Mailbox events and also drain any pending
+	 * stale messages.
+	 */
+	dev_context->mbox = omap_mbox_get("dsp");
+	if (IS_ERR(dev_context->mbox)) {
+		dev_context->mbox = NULL;
+		pr_err("%s: Failed to get dsp mailbox handle\n", __func__);
+		status = -EPERM;
+		goto err3;
+	}
+
+	dev_context->mbox->rxq->callback = (int (*)(void *))io_mbox_msg;
 
 /*PM_IVA2GRPSEL_PER = 0xC0;*/
-		temp = (u32) *((reg_uword32 *)
-				((u32) (resources->dw_per_pm_base) + 0xA8));
-		temp = (temp & 0xFFFFFF30) | 0xC0;
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8)) =
-		    (u32) temp;
+	temp = (u32) *((reg_uword32 *)
+			((u32) (resources->dw_per_pm_base) + 0xA8));
+	temp = (temp & 0xFFFFFF30) | 0xC0;
+	*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA8)) =
+	    (u32) temp;
 
 /*PM_MPUGRPSEL_PER &= 0xFFFFFF3F; */
-		temp = (u32) *((reg_uword32 *)
-				((u32) (resources->dw_per_pm_base) + 0xA4));
-		temp = (temp & 0xFFFFFF3F);
-		*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4)) =
-		    (u32) temp;
+	temp = (u32) *((reg_uword32 *)
+			((u32) (resources->dw_per_pm_base) + 0xA4));
+	temp = (temp & 0xFFFFFF3F);
+	*((reg_uword32 *) ((u32) (resources->dw_per_pm_base) + 0xA4)) =
+	    (u32) temp;
 /*CM_SLEEPDEP_PER |= 0x04; */
-		temp = (u32) *((reg_uword32 *)
-				((u32) (resources->dw_per_base) + 0x44));
-		temp = (temp & 0xFFFFFFFB) | 0x04;
-		*((reg_uword32 *) ((u32) (resources->dw_per_base) + 0x44)) =
-		    (u32) temp;
+	temp = (u32) *((reg_uword32 *)
+			((u32) (resources->dw_per_base) + 0x44));
+	temp = (temp & 0xFFFFFFFB) | 0x04;
+	*((reg_uword32 *) ((u32) (resources->dw_per_base) + 0x44)) =
+	    (u32) temp;
 
 /*CM_CLKSTCTRL_IVA2 = 0x00000003 -To Allow automatic transitions */
-		(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_ENABLE_AUTO,
-					OMAP3430_IVA2_MOD, CM_CLKSTCTRL);
-
-		/* Let DSP go */
-		dev_dbg(bridge, "%s Unreset\n", __func__);
-		/* release the RST1, DSP starts executing now .. */
-		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2, 0,
-					OMAP3430_IVA2_MOD, RM_RSTCTRL);
-
-		dev_dbg(bridge, "Waiting for Sync @ 0x%x\n", dw_sync_addr);
-		dev_dbg(bridge, "DSP c_int00 Address =  0x%x\n", dwDSPAddr);
-		if (dsp_debug)
-			while (*((volatile u16 *)dw_sync_addr))
-				;;
-
-		/* Wait for DSP to clear word in shared memory */
-		/* Read the Location */
-		if (!wait_for_start(dev_context, dw_sync_addr))
-			status = -ETIMEDOUT;
+	(*pdata->dsp_cm_write)(OMAP34XX_CLKSTCTRL_ENABLE_AUTO,
+				OMAP3430_IVA2_MOD, CM_CLKSTCTRL);
+
+	/* Let DSP go */
+	dev_dbg(bridge, "%s Unreset\n", __func__);
+	/* release the RST1, DSP starts executing now .. */
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2, 0,
+				OMAP3430_IVA2_MOD, RM_RSTCTRL);
+
+	dev_dbg(bridge, "Waiting for Sync @ 0x%x\n", dw_sync_addr);
+	dev_dbg(bridge, "DSP c_int00 Address =  0x%x\n", dwDSPAddr);
+	if (dsp_debug)
+		while (*((volatile u16 *)dw_sync_addr))
+			;;
+
+	/* Wait for DSP to clear word in shared memory */
+	/* Read the Location */
+	if (!wait_for_start(dev_context, dw_sync_addr)) {
+		status = -ETIMEDOUT;
+		goto err3;
+	}
 
-		/* Start wdt */
-		dsp_wdt_sm_set((void *)ul_shm_base);
-		dsp_wdt_enable(true);
+	/* Start wdt */
+	dsp_wdt_sm_set((void *)ul_shm_base);
+	dsp_wdt_enable(true);
 
-		status = dev_get_io_mgr(dev_context->hdev_obj, &hio_mgr);
-		if (hio_mgr) {
-			io_sh_msetting(hio_mgr, SHM_OPPINFO, NULL);
-			/* Write the synchronization bit to indicate the
-			 * completion of OPP table update to DSP
-			 */
-			*((volatile u32 *)dw_sync_addr) = 0XCAFECAFE;
+	status = dev_get_io_mgr(dev_context->hdev_obj, &hio_mgr);
+	if (hio_mgr) {
+		io_sh_msetting(hio_mgr, SHM_OPPINFO, NULL);
+		/* Write the synchronization bit to indicate the
+		 * completion of OPP table update to DSP
+		 */
+		*((volatile u32 *)dw_sync_addr) = 0XCAFECAFE;
 
-			/* update board state */
-			dev_context->dw_brd_state = BRD_RUNNING;
-			/* (void)chnlsm_enable_interrupt(dev_context); */
-		} else {
-			dev_context->dw_brd_state = BRD_UNKNOWN;
-		}
+		/* update board state */
+		dev_context->dw_brd_state = BRD_RUNNING;
+		/* (void)chnlsm_enable_interrupt(dev_context); */
+	} else {
+		dev_context->dw_brd_state = BRD_UNKNOWN;
+		goto err3;
 	}
+end:
+	return 0;
+err3:
+	iommu_kunmap(mmu, sm_sg->seg0_da);
+err2:
+	iommu_kunmap(mmu, sm_sg->seg1_da);
+err1:
 	return status;
 }
 
@@ -654,15 +693,30 @@ static int bridge_brd_stop(struct bridge_dev_context *hDevContext)
 		memset((u8 *) pt_attrs->pg_info, 0x00,
 		       (pt_attrs->l2_num_pages * sizeof(struct page_info)));
 	}
+
+	/* Reset DSP */
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2, OMAP3430_RST1_IVA2,
+					OMAP3430_IVA2_MOD, RM_RSTCTRL);
 	/* Disable the mailbox interrupts */
 	if (dev_context->mbox) {
 		omap_mbox_disable_irq(dev_context->mbox, IRQ_RX);
 		omap_mbox_put(dev_context->mbox);
 		dev_context->mbox = NULL;
 	}
-	/* Reset IVA2 clocks*/
-	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2 | OMAP3430_RST2_IVA2 |
-			OMAP3430_RST3_IVA2, OMAP3430_IVA2_MOD, RM_RSTCTRL);
+
+	if (dev_context->dsp_mmu) {
+		if (dev_context->sh_s) {
+			iommu_kunmap(dev_context->dsp_mmu,
+						dev_context->sh_s->seg0_da);
+			iommu_kunmap(dev_context->dsp_mmu,
+						dev_context->sh_s->seg1_da);
+		}
+		iommu_put(dev_context->dsp_mmu);
+		dev_context->dsp_mmu = NULL;
+	}
+
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2, OMAP3430_RST2_IVA2,
+					OMAP3430_IVA2_MOD, RM_RSTCTRL);
 
 	return status;
 }
@@ -709,6 +763,11 @@ static int bridge_brd_delete(struct bridge_dev_context *hDevContext)
 		memset((u8 *) pt_attrs->pg_info, 0x00,
 		       (pt_attrs->l2_num_pages * sizeof(struct page_info)));
 	}
+
+	/* Reset DSP */
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST1_IVA2, OMAP3430_RST1_IVA2,
+					OMAP3430_IVA2_MOD, RM_RSTCTRL);
+
 	/* Disable the mail box interrupts */
 	if (dev_context->mbox) {
 		omap_mbox_disable_irq(dev_context->mbox, IRQ_RX);
@@ -716,11 +775,19 @@ static int bridge_brd_delete(struct bridge_dev_context *hDevContext)
 		dev_context->mbox = NULL;
 	}
 
-	if (dev_context->dsp_mmu)
-		dev_context->dsp_mmu = (iommu_put(dev_context->dsp_mmu), NULL);
-	/* Reset IVA2 clocks*/
-	(*pdata->dsp_prm_write)(OMAP3430_RST1_IVA2 | OMAP3430_RST2_IVA2 |
-			OMAP3430_RST3_IVA2, OMAP3430_IVA2_MOD, RM_RSTCTRL);
+	if (dev_context->dsp_mmu) {
+		if (dev_context->sh_s) {
+			iommu_kunmap(dev_context->dsp_mmu,
+						dev_context->sh_s->seg0_da);
+			iommu_kunmap(dev_context->dsp_mmu,
+						dev_context->sh_s->seg1_da);
+		}
+		iommu_put(dev_context->dsp_mmu);
+		dev_context->dsp_mmu = NULL;
+	}
+
+	(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2, OMAP3430_RST2_IVA2,
+					OMAP3430_IVA2_MOD, RM_RSTCTRL);
 
 	return status;
 }
diff --git a/drivers/dsp/bridge/core/tiomap_io.c b/drivers/dsp/bridge/core/tiomap_io.c
index 3b2ea70..c23ca66 100644
--- a/drivers/dsp/bridge/core/tiomap_io.c
+++ b/drivers/dsp/bridge/core/tiomap_io.c
@@ -133,10 +133,9 @@ int read_ext_dsp_data(struct bridge_dev_context *hDevContext,
 
 		if (DSP_SUCCEEDED(status)) {
 			ul_tlb_base_virt =
-			    dev_context->atlb_entry[0].ul_dsp_va * DSPWORDSIZE;
+			    dev_context->sh_s->seg0_da * DSPWORDSIZE;
 			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
-			dw_ext_prog_virt_mem =
-			    dev_context->atlb_entry[0].ul_gpp_va;
+			dw_ext_prog_virt_mem = dev_context->sh_s->seg0_va;
 
 			if (!trace_read) {
 				ul_shm_offset_virt =
@@ -317,8 +316,8 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 			ret = -EPERM;
 
 		if (DSP_SUCCEEDED(ret)) {
-			ul_tlb_base_virt =
-			    dev_context->atlb_entry[0].ul_dsp_va * DSPWORDSIZE;
+			ul_tlb_base_virt = dev_context->sh_s->seg0_da *
+								DSPWORDSIZE;
 			DBC_ASSERT(ul_tlb_base_virt <= ul_shm_base_virt);
 
 			if (symbols_reloaded) {
@@ -339,7 +338,7 @@ int write_ext_dsp_data(struct bridge_dev_context *dev_context,
 			    ul_shm_base_virt - ul_tlb_base_virt;
 			if (trace_load) {
 				dw_ext_prog_virt_mem =
-				    dev_context->atlb_entry[0].ul_gpp_va;
+						dev_context->sh_s->seg0_va;
 			} else {
 				dw_ext_prog_virt_mem = host_res->dw_mem_base[1];
 				dw_ext_prog_virt_mem +=
-- 
1.6.3.3

