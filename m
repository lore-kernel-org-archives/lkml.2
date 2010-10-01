Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0JAB7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:59:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54949 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab0JAB7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:59:37 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 08/11] staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct
Date: Thu, 30 Sep 2010 21:12:55 -0500
Message-Id: <1285899178-14413-9-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285899178-14413-8-git-send-email-x0095840@ti.com>
References: <1285899178-14413-1-git-send-email-x0095840@ti.com>
 <1285899178-14413-2-git-send-email-x0095840@ti.com>
 <1285899178-14413-3-git-send-email-x0095840@ti.com>
 <1285899178-14413-4-git-send-email-x0095840@ti.com>
 <1285899178-14413-5-git-send-email-x0095840@ti.com>
 <1285899178-14413-6-git-send-email-x0095840@ti.com>
 <1285899178-14413-7-git-send-email-x0095840@ti.com>
 <1285899178-14413-8-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to map iva2 iommu register base address
anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c      |    3 ---
 drivers/staging/tidspbridge/core/tiomap_io.c       |    3 +--
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 -
 drivers/staging/tidspbridge/rmgr/drv.c             |    4 ----
 4 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 789cc5e..f890a0e 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -830,8 +830,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 			iounmap((void *)host_res->dw_mem_base[3]);
 		if (host_res->dw_mem_base[4])
 			iounmap((void *)host_res->dw_mem_base[4]);
-		if (host_res->dw_dmmu_base)
-			iounmap(host_res->dw_dmmu_base);
 		if (host_res->dw_per_base)
 			iounmap(host_res->dw_per_base);
 		if (host_res->dw_per_pm_base)
@@ -845,7 +843,6 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 		host_res->dw_mem_base[2] = (u32) NULL;
 		host_res->dw_mem_base[3] = (u32) NULL;
 		host_res->dw_mem_base[4] = (u32) NULL;
-		host_res->dw_dmmu_base = NULL;
 		host_res->dw_sys_ctrl_base = NULL;
 
 		kfree(host_res);
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index 63d46bc..81a5401 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -391,7 +391,6 @@ int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val)
 		omap_dspbridge_dev->dev.platform_data;
 	struct cfg_hostres *resources = dev_context->resources;
 	int status = 0;
-	u32 temp;
 
 	if (!dev_context->mbox)
 		return 0;
@@ -435,7 +434,7 @@ int sm_interrupt_dsp(struct bridge_dev_context *dev_context, u16 mb_val)
 		omap_mbox_restore_ctx(dev_context->mbox);
 
 		/* Access MMU SYS CONFIG register to generate a short wakeup */
-		temp = readl(resources->dw_dmmu_base + 0x10);
+		iommu_read_reg(dev_context->dsp_mmu, MMU_SYSCONFIG);
 
 		dev_context->dw_brd_state = BRD_RUNNING;
 	} else if (dev_context->dw_brd_state == BRD_RETENTION) {
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
index 38122db..dfb55cc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
@@ -68,7 +68,6 @@ struct cfg_hostres {
 	void __iomem *dw_per_base;
 	u32 dw_per_pm_base;
 	u32 dw_core_pm_base;
-	void __iomem *dw_dmmu_base;
 	void __iomem *dw_sys_ctrl_base;
 };
 
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index 81b1b90..0c857b9 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -743,7 +743,6 @@ static int request_bridge_resources(struct cfg_hostres *res)
 	host_res->dw_sys_ctrl_base = ioremap(OMAP_SYSC_BASE, OMAP_SYSC_SIZE);
 	dev_dbg(bridge, "dw_mem_base[0] 0x%x\n", host_res->dw_mem_base[0]);
 	dev_dbg(bridge, "dw_mem_base[3] 0x%x\n", host_res->dw_mem_base[3]);
-	dev_dbg(bridge, "dw_dmmu_base %p\n", host_res->dw_dmmu_base);
 
 	/* for 24xx base port is not mapping the mamory for DSP
 	 * internal memory TODO Do a ioremap here */
@@ -797,8 +796,6 @@ int drv_request_bridge_res_dsp(void **phost_resources)
 							 OMAP_PER_PRM_SIZE);
 		host_res->dw_core_pm_base = (u32) ioremap(OMAP_CORE_PRM_BASE,
 							  OMAP_CORE_PRM_SIZE);
-		host_res->dw_dmmu_base = ioremap(OMAP_DMMU_BASE,
-						 OMAP_DMMU_SIZE);
 
 		dev_dbg(bridge, "dw_mem_base[0] 0x%x\n",
 			host_res->dw_mem_base[0]);
@@ -810,7 +807,6 @@ int drv_request_bridge_res_dsp(void **phost_resources)
 			host_res->dw_mem_base[3]);
 		dev_dbg(bridge, "dw_mem_base[4] 0x%x\n",
 			host_res->dw_mem_base[4]);
-		dev_dbg(bridge, "dw_dmmu_base %p\n", host_res->dw_dmmu_base);
 
 		shm_size = drv_datap->shm_size;
 		if (shm_size >= 0x10000) {
-- 
1.6.3.3

