Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0KARC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:02:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60552 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab0KARC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:02:27 -0400
From: Armando Uribe <x0095078@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@gmail.com>, <nm@ti.com>, <omar.ramirez@ti.com>,
        <ohad@wizery.com>, <x0095840@ti.com>, <rene.sapiens@ti.com>,
        <ameya.palande@nokia.com>, <x0095078@ti.com>, <ivan.gomez@ti.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <ernesto@ti.com>
Subject: [PATCH] staging: tidspbridge - Eliminate direct manipulation of OMAP_SYSC_BASE
Date: Mon,  1 Nov 2010 12:15:50 -0500
Message-Id: <1288631750-2218-1-git-send-email-x0095078@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminates Bridge direct manipulation of OMAP_SYSC_BASE registers

Signed-off-by: Armando Uribe <x0095078@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-clock.c       |   52 +-------------------
 drivers/staging/tidspbridge/core/tiomap3430.c      |    3 -
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 -
 .../staging/tidspbridge/include/dspbridge/drv.h    |    3 -
 drivers/staging/tidspbridge/rmgr/drv.c             |    1 -
 5 files changed, 2 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 46d17c7..589a055 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -146,54 +146,6 @@ void dsp_clk_init(void)
 					ssi.sst_fck, ssi.ssr_fck, ssi.ick);
 }
 
-#ifdef CONFIG_OMAP_MCBSP
-static void mcbsp_clk_prepare(bool flag, u8 id)
-{
-	struct cfg_hostres *resources;
-	struct dev_object *hdev_object = NULL;
-	struct bridge_dev_context *bridge_context = NULL;
-	u32 val;
-
-	hdev_object = (struct dev_object *)drv_get_first_dev_object();
-	if (!hdev_object)
-		return;
-
-	dev_get_bridge_context(hdev_object, &bridge_context);
-	if (!bridge_context)
-		return;
-
-	resources = bridge_context->resources;
-	if (!resources)
-		return;
-
-	if (flag) {
-		if (id == DSP_CLK_MCBSP1) {
-			/* set MCBSP1_CLKS, on McBSP1 ON */
-			val = __raw_readl(resources->dw_sys_ctrl_base + 0x274);
-			val |= 1 << 2;
-			__raw_writel(val, resources->dw_sys_ctrl_base + 0x274);
-		} else if (id == DSP_CLK_MCBSP2) {
-			/* set MCBSP2_CLKS, on McBSP2 ON */
-			val = __raw_readl(resources->dw_sys_ctrl_base + 0x274);
-			val |= 1 << 6;
-			__raw_writel(val, resources->dw_sys_ctrl_base + 0x274);
-		}
-	} else {
-		if (id == DSP_CLK_MCBSP1) {
-			/* clear MCBSP1_CLKS, on McBSP1 OFF */
-			val = __raw_readl(resources->dw_sys_ctrl_base + 0x274);
-			val &= ~(1 << 2);
-			__raw_writel(val, resources->dw_sys_ctrl_base + 0x274);
-		} else if (id == DSP_CLK_MCBSP2) {
-			/* clear MCBSP2_CLKS, on McBSP2 OFF */
-			val = __raw_readl(resources->dw_sys_ctrl_base + 0x274);
-			val &= ~(1 << 6);
-			__raw_writel(val, resources->dw_sys_ctrl_base + 0x274);
-		}
-	}
-}
-#endif
-
 /**
  * dsp_gpt_wait_overflow - set gpt overflow and wait for fixed timeout
  * @clk_id:      GP Timer clock id.
@@ -257,9 +209,9 @@ int dsp_clk_enable(enum dsp_clk_id clk_id)
 		break;
 #ifdef CONFIG_OMAP_MCBSP
 	case MCBSP_CLK:
-		mcbsp_clk_prepare(true, clk_id);
 		omap_mcbsp_set_io_type(MCBSP_ID(clk_id), OMAP_MCBSP_POLL_IO);
 		omap_mcbsp_request(MCBSP_ID(clk_id));
+		omap2_mcbsp_set_clks_src(MCBSP_ID(clk_id), MCBSP_CLKS_PAD_SRC);
 		break;
 #endif
 	case WDT_CLK:
@@ -334,7 +286,7 @@ int dsp_clk_disable(enum dsp_clk_id clk_id)
 		break;
 #ifdef CONFIG_OMAP_MCBSP
 	case MCBSP_CLK:
-		mcbsp_clk_prepare(false, clk_id);
+		omap2_mcbsp_set_clks_src(MCBSP_ID(clk_id), MCBSP_CLKS_PRCM_SRC);
 		omap_mcbsp_free(MCBSP_ID(clk_id));
 		break;
 #endif
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index c28dcf1..29dd497 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -838,14 +838,11 @@ static int bridge_dev_destroy(struct bridge_dev_context *dev_ctxt)
 			iounmap((void *)host_res->dw_per_pm_base);
 		if (host_res->dw_core_pm_base)
 			iounmap((void *)host_res->dw_core_pm_base);
-		if (host_res->dw_sys_ctrl_base)
-			iounmap(host_res->dw_sys_ctrl_base);
 
 		host_res->dw_mem_base[0] = (u32) NULL;
 		host_res->dw_mem_base[2] = (u32) NULL;
 		host_res->dw_mem_base[3] = (u32) NULL;
 		host_res->dw_mem_base[4] = (u32) NULL;
-		host_res->dw_sys_ctrl_base = NULL;
 
 		kfree(host_res);
 	}
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
index dfb55cc..8d9ed33 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfgdefs.h
@@ -68,7 +68,6 @@ struct cfg_hostres {
 	void __iomem *dw_per_base;
 	u32 dw_per_pm_base;
 	u32 dw_core_pm_base;
-	void __iomem *dw_sys_ctrl_base;
 };
 
 struct cfg_dspmemdesc {
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index 75a2c9b..113d57a 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -65,9 +65,6 @@
 #define OMAP_CORE_PRM_BASE 0x48306A00
 #define OMAP_CORE_PRM_SIZE 0x1000
 
-#define OMAP_SYSC_BASE 0x48002000
-#define OMAP_SYSC_SIZE 0x1000
-
 #define OMAP_DMMU_BASE 0x5D000000
 #define OMAP_DMMU_SIZE 0x1000
 
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index 91cc168..b70bc0a 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -729,7 +729,6 @@ static int request_bridge_resources(struct cfg_hostres *res)
 	host_res->num_mem_windows = 2;
 
 	/* First window is for DSP internal memory */
-	host_res->dw_sys_ctrl_base = ioremap(OMAP_SYSC_BASE, OMAP_SYSC_SIZE);
 	dev_dbg(bridge, "dw_mem_base[0] 0x%x\n", host_res->dw_mem_base[0]);
 	dev_dbg(bridge, "dw_mem_base[3] 0x%x\n", host_res->dw_mem_base[3]);
 
-- 
1.6.3.3

