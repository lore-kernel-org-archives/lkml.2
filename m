Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2IUC1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:27:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8095 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab2IUC1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:27:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="239432289"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 01/10] usb: otg: msm: Convert to clk_prepare/unprepare
Date: Thu, 20 Sep 2012 19:26:49 -0700
Message-Id: <1348194419-11486-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to clk_prepare and unprepare so that MSM can migrate to
the common clock framework.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/usb/otg/msm_otg.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/otg/msm_otg.c b/drivers/usb/otg/msm_otg.c
index 9f5fc90..2ae0639 100644
--- a/drivers/usb/otg/msm_otg.c
+++ b/drivers/usb/otg/msm_otg.c
@@ -514,13 +514,13 @@ static int msm_otg_suspend(struct msm_otg *motg)
 			motg->pdata->otg_control == OTG_PMIC_CONTROL)
 		writel(readl(USB_PHY_CTRL) | PHY_RETEN, USB_PHY_CTRL);
 
-	clk_disable(motg->pclk);
-	clk_disable(motg->clk);
+	clk_disable_unprepare(motg->pclk);
+	clk_disable_unprepare(motg->clk);
 	if (motg->core_clk)
-		clk_disable(motg->core_clk);
+		clk_disable_unprepare(motg->core_clk);
 
 	if (!IS_ERR(motg->pclk_src))
-		clk_disable(motg->pclk_src);
+		clk_disable_unprepare(motg->pclk_src);
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
@@ -552,12 +552,12 @@ static int msm_otg_resume(struct msm_otg *motg)
 		return 0;
 
 	if (!IS_ERR(motg->pclk_src))
-		clk_enable(motg->pclk_src);
+		clk_prepare_enable(motg->pclk_src);
 
-	clk_enable(motg->pclk);
-	clk_enable(motg->clk);
+	clk_prepare_enable(motg->pclk);
+	clk_prepare_enable(motg->clk);
 	if (motg->core_clk)
-		clk_enable(motg->core_clk);
+		clk_prepare_enable(motg->core_clk);
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
@@ -1468,7 +1468,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		if (IS_ERR(motg->pclk_src))
 			goto put_clk;
 		clk_set_rate(motg->pclk_src, INT_MAX);
-		clk_enable(motg->pclk_src);
+		clk_prepare_enable(motg->pclk_src);
 	} else
 		motg->pclk_src = ERR_PTR(-ENOENT);
 
@@ -1511,8 +1511,8 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		goto free_regs;
 	}
 
-	clk_enable(motg->clk);
-	clk_enable(motg->pclk);
+	clk_prepare_enable(motg->clk);
+	clk_prepare_enable(motg->pclk);
 
 	ret = msm_hsusb_init_vddcx(motg, 1);
 	if (ret) {
@@ -1532,7 +1532,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	}
 
 	if (motg->core_clk)
-		clk_enable(motg->core_clk);
+		clk_prepare_enable(motg->core_clk);
 
 	writel(0, USB_USBINTR);
 	writel(0, USB_OTGSC);
@@ -1579,8 +1579,8 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 free_irq:
 	free_irq(motg->irq, motg);
 disable_clks:
-	clk_disable(motg->pclk);
-	clk_disable(motg->clk);
+	clk_disable_unprepare(motg->pclk);
+	clk_disable_unprepare(motg->clk);
 ldo_exit:
 	msm_hsusb_ldo_init(motg, 0);
 vddcx_exit:
@@ -1593,7 +1593,7 @@ put_core_clk:
 	clk_put(motg->pclk);
 put_pclk_src:
 	if (!IS_ERR(motg->pclk_src)) {
-		clk_disable(motg->pclk_src);
+		clk_disable_unprepare(motg->pclk_src);
 		clk_put(motg->pclk_src);
 	}
 put_clk:
@@ -1643,12 +1643,12 @@ static int __devexit msm_otg_remove(struct platform_device *pdev)
 	if (cnt >= PHY_SUSPEND_TIMEOUT_USEC)
 		dev_err(phy->dev, "Unable to suspend PHY\n");
 
-	clk_disable(motg->pclk);
-	clk_disable(motg->clk);
+	clk_disable_unprepare(motg->pclk);
+	clk_disable_unprepare(motg->clk);
 	if (motg->core_clk)
-		clk_disable(motg->core_clk);
+		clk_disable_unprepare(motg->core_clk);
 	if (!IS_ERR(motg->pclk_src)) {
-		clk_disable(motg->pclk_src);
+		clk_disable_unprepare(motg->pclk_src);
 		clk_put(motg->pclk_src);
 	}
 	msm_hsusb_ldo_init(motg, 0);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

