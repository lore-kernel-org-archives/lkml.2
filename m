Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2IXUiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:38:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5959 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab2IXUiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:38:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6845"; a="238278928"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 3/3] clk: wm831x: Use devm_clk_register() to simplify code
Date: Mon, 24 Sep 2012 13:38:05 -0700
Message-Id: <1348519085-5888-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348519085-5888-1-git-send-email-sboyd@codeaurora.org>
References: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org>
 <1348519085-5888-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move this driver to use devm_clk_register() to simplify some
error paths and reduce lines of code.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

v2: No changes

 drivers/clk/clk-wm831x.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index eb1afaf..db4fbf2 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -370,43 +370,27 @@ static __devinit int wm831x_clk_probe(struct platform_device *pdev)
 	clkdata->xtal_ena = ret & WM831X_XTAL_ENA;
 
 	clkdata->xtal_hw.init = &wm831x_xtal_init;
-	clkdata->xtal = clk_register(&pdev->dev, &clkdata->xtal_hw);
+	clkdata->xtal = devm_clk_register(&pdev->dev, &clkdata->xtal_hw);
 	if (IS_ERR(clkdata->xtal))
 		return PTR_ERR(clkdata->xtal);
 
 	clkdata->fll_hw.init = &wm831x_fll_init;
-	clkdata->fll = clk_register(&pdev->dev, &clkdata->fll_hw);
-	if (IS_ERR(clkdata->fll)) {
-		ret = PTR_ERR(clkdata->fll);
-		goto err_xtal;
-	}
+	clkdata->fll = devm_clk_register(&pdev->dev, &clkdata->fll_hw);
+	if (IS_ERR(clkdata->fll))
+		return PTR_ERR(clkdata->fll);
 
 	clkdata->clkout_hw.init = &wm831x_clkout_init;
-	clkdata->clkout = clk_register(&pdev->dev, &clkdata->clkout_hw);
-	if (IS_ERR(clkdata->clkout)) {
-		ret = PTR_ERR(clkdata->clkout);
-		goto err_fll;
-	}
+	clkdata->clkout = devm_clk_register(&pdev->dev, &clkdata->clkout_hw);
+	if (IS_ERR(clkdata->clkout))
+		return PTR_ERR(clkdata->clkout);
 
 	dev_set_drvdata(&pdev->dev, clkdata);
 
 	return 0;
-
-err_fll:
-	clk_unregister(clkdata->fll);
-err_xtal:
-	clk_unregister(clkdata->xtal);
-	return ret;
 }
 
 static int __devexit wm831x_clk_remove(struct platform_device *pdev)
 {
-	struct wm831x_clk *clkdata = dev_get_drvdata(&pdev->dev);
-
-	clk_unregister(clkdata->clkout);
-	clk_unregister(clkdata->fll);
-	clk_unregister(clkdata->xtal);
-
 	return 0;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

