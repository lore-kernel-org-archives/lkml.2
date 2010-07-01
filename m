Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0GAALw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 20:11:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38025 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab0GAALo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 20:11:44 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyu@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 9/9] dspbridge: cleanup bridge_dev_context and cfg_hostres structures
Date: Wed, 30 Jun 2010 19:21:00 -0500
Message-Id: <1277943660-4112-10-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1277943660-4112-9-git-send-email-x0095840@ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
 <1277943660-4112-2-git-send-email-x0095840@ti.com>
 <1277943660-4112-3-git-send-email-x0095840@ti.com>
 <1277943660-4112-4-git-send-email-x0095840@ti.com>
 <1277943660-4112-5-git-send-email-x0095840@ti.com>
 <1277943660-4112-6-git-send-email-x0095840@ti.com>
 <1277943660-4112-7-git-send-email-x0095840@ti.com>
 <1277943660-4112-8-git-send-email-x0095840@ti.com>
 <1277943660-4112-9-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch cleans up cfg_hostres and bridge_dev_context
structures of custom mmu code not needed anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/include/dspbridge/cfgdefs.h |    1 -
 drivers/dsp/bridge/core/_tiomap.h              |    5 -----
 drivers/dsp/bridge/core/tiomap3430.c           |    8 --------
 drivers/dsp/bridge/core/tiomap_io.c            |    2 +-
 drivers/dsp/bridge/rmgr/drv.c                  |    4 ----
 5 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/arch/arm/plat-omap/include/dspbridge/cfgdefs.h b/arch/arm/plat-omap/include/dspbridge/cfgdefs.h
index 38122db..dfb55cc 100644
--- a/arch/arm/plat-omap/include/dspbridge/cfgdefs.h
+++ b/arch/arm/plat-omap/include/dspbridge/cfgdefs.h
@@ -68,7 +68,6 @@ struct cfg_hostres {
 	void __iomem *dw_per_base;
 	u32 dw_per_pm_base;
 	u32 dw_core_pm_base;
-	void __iomem *dw_dmmu_base;
 	void __iomem *dw_sys_ctrl_base;
 };
 
diff --git a/drivers/dsp/bridge/core/_tiomap.h b/drivers/dsp/bridge/core/_tiomap.h
index 8a9a822..82bce7d 100644
--- a/drivers/dsp/bridge/core/_tiomap.h
+++ b/drivers/dsp/bridge/core/_tiomap.h
@@ -323,7 +323,6 @@ struct bridge_dev_context {
 	 */
 	u32 dw_dsp_ext_base_addr;	/* See the comment above */
 	u32 dw_api_reg_base;	/* API mem map'd registers */
-	void __iomem *dw_dsp_mmu_base;	/* DSP MMU Mapped registers */
 	u32 dw_api_clk_base;	/* CLK Registers */
 	u32 dw_dsp_clk_m2_base;	/* DSP Clock Module m2 */
 	u32 dw_public_rhea;	/* Pub Rhea */
@@ -347,10 +346,6 @@ struct bridge_dev_context {
 	/* DMMU TLB entries */
 	struct bridge_ioctl_extproc atlb_entry[BRDIOCTL_NUMOFMMUTLB];
 	u32 dw_brd_state;	/* Last known board state. */
-	u32 ul_int_mask;	/* int mask */
-	u16 io_base;		/* Board I/O base */
-	u32 num_tlb_entries;	/* DSP MMU TLB entry counter */
-	u32 fixed_tlb_entries;	/* Fixed DSPMMU TLB entry count */
 
 	/* TC Settings */
 	bool tc_word_swap_on;	/* Traffic Controller Word Swap */
diff --git a/drivers/dsp/bridge/core/tiomap3430.c b/drivers/dsp/bridge/core/tiomap3430.c
index aa6e999..83a9561 100644
--- a/drivers/dsp/bridge/core/tiomap3430.c
+++ b/drivers/dsp/bridge/core/tiomap3430.c
@@ -753,7 +753,6 @@ static int bridge_dev_create(OUT struct bridge_dev_context
 		dev_context->atlb_entry[entry_ndx].ul_gpp_pa =
 		    dev_context->atlb_entry[entry_ndx].ul_dsp_va = 0;
 	}
-	dev_context->num_tlb_entries = 0;
 	dev_context->dw_dsp_base_addr = (u32) MEM_LINEAR_ADDRESS((void *)
 								 (pConfig->
 								  dw_mem_base
@@ -766,11 +765,7 @@ static int bridge_dev_create(OUT struct bridge_dev_context
 
 	if (DSP_SUCCEEDED(status)) {
 		dev_context->tc_word_swap_on = drv_datap->tc_wordswapon;
-		/* MMU address is obtained from the host
-		 * resources struct */
-		dev_context->dw_dsp_mmu_base = resources->dw_dmmu_base;
 		dev_context->hdev_obj = hdev_obj;
-		dev_context->ul_int_mask = 0;
 		/* Store current board state. */
 		dev_context->dw_brd_state = BRD_STOPPED;
 		dev_context->resources = resources;
@@ -887,8 +882,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *hDevContext)
 			iounmap((void *)host_res->dw_mem_base[3]);
 		if (host_res->dw_mem_base[4])
 			iounmap((void *)host_res->dw_mem_base[4]);
-		if (host_res->dw_dmmu_base)
-			iounmap(host_res->dw_dmmu_base);
 		if (host_res->dw_per_base)
 			iounmap(host_res->dw_per_base);
 		if (host_res->dw_per_pm_base)
@@ -902,7 +895,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *hDevContext)
 		host_res->dw_mem_base[2] = (u32) NULL;
 		host_res->dw_mem_base[3] = (u32) NULL;
 		host_res->dw_mem_base[4] = (u32) NULL;
-		host_res->dw_dmmu_base = NULL;
 		host_res->dw_sys_ctrl_base = NULL;
 
 		kfree(host_res);
diff --git a/drivers/dsp/bridge/core/tiomap_io.c b/drivers/dsp/bridge/core/tiomap_io.c
index 3c0d3a3..2f2f8c2 100644
--- a/drivers/dsp/bridge/core/tiomap_io.c
+++ b/drivers/dsp/bridge/core/tiomap_io.c
@@ -437,7 +437,7 @@ int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val)
 		omap_mbox_restore_ctx(dev_context->mbox);
 
 		/* Access MMU SYS CONFIG register to generate a short wakeup */
-		__raw_readl(resources->dw_dmmu_base + 0x10);
+		iommu_read_reg(dev_context->dsp_mmu, MMU_SYSCONFIG);
 
 		dev_context->dw_brd_state = BRD_RUNNING;
 	} else if (dev_context->dw_brd_state == BRD_RETENTION) {
diff --git a/drivers/dsp/bridge/rmgr/drv.c b/drivers/dsp/bridge/rmgr/drv.c
index c6e38e5..7804479 100644
--- a/drivers/dsp/bridge/rmgr/drv.c
+++ b/drivers/dsp/bridge/rmgr/drv.c
@@ -829,7 +829,6 @@ static int request_bridge_resources(struct cfg_hostres *res)
 	host_res->dw_sys_ctrl_base = ioremap(OMAP_SYSC_BASE, OMAP_SYSC_SIZE);
 	dev_dbg(bridge, "dw_mem_base[0] 0x%x\n", host_res->dw_mem_base[0]);
 	dev_dbg(bridge, "dw_mem_base[3] 0x%x\n", host_res->dw_mem_base[3]);
-	dev_dbg(bridge, "dw_dmmu_base %p\n", host_res->dw_dmmu_base);
 
 	/* for 24xx base port is not mapping the mamory for DSP
 	 * internal memory TODO Do a ioremap here */
@@ -883,8 +882,6 @@ int drv_request_bridge_res_dsp(void **phost_resources)
 							 OMAP_PER_PRM_SIZE);
 		host_res->dw_core_pm_base = (u32) ioremap(OMAP_CORE_PRM_BASE,
 							  OMAP_CORE_PRM_SIZE);
-		host_res->dw_dmmu_base = ioremap(OMAP_DMMU_BASE,
-						 OMAP_DMMU_SIZE);
 
 		dev_dbg(bridge, "dw_mem_base[0] 0x%x\n",
 			host_res->dw_mem_base[0]);
@@ -896,7 +893,6 @@ int drv_request_bridge_res_dsp(void **phost_resources)
 			host_res->dw_mem_base[3]);
 		dev_dbg(bridge, "dw_mem_base[4] 0x%x\n",
 			host_res->dw_mem_base[4]);
-		dev_dbg(bridge, "dw_dmmu_base %p\n", host_res->dw_dmmu_base);
 
 		shm_size = drv_datap->shm_size;
 		if (shm_size >= 0x10000) {
-- 
1.6.3.3

