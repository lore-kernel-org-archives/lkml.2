Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2KFIYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:24:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53495 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521Ab2KFIYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:24:18 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH 1/1] MFD: ti_am335x_tscadc: pass correct error message
Date: Tue, 6 Nov 2012 13:39:03 +0530
Message-ID: <1352189343-23305-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass on the correct error message from platform_get_irq()
instead of hard coding it to "EINVAL".

Also change label from "err" to "ret" for better
readability and update the same in error path.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/mfd/ti_am335x_tscadc.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index e947dd8..8ca3bf0 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -65,7 +65,6 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	struct clk		*clk;
 	struct mfd_tscadc_board	*pdata = pdev->dev.platform_data;
 	struct mfd_cell		*cell;
-	int			irq;
 	int			err, ctrl;
 	int			clk_value, clock_rate;
 	int			tsc_wires, adc_channels = 0, total_channels;
@@ -92,12 +91,6 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "no irq ID is specified.\n");
-		return -EINVAL;
-	}
-
 	/* Allocate memory for device */
 	tscadc = devm_kzalloc(&pdev->dev,
 			sizeof(struct ti_tscadc_dev), GFP_KERNEL);
@@ -106,22 +99,26 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	tscadc->dev = &pdev->dev;
-	tscadc->irq = irq;
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0) {
+		dev_err(&pdev->dev, "no irq ID is specified.\n");
+		goto ret;
+	} else
+		tscadc->irq = err;
 
 	res = devm_request_mem_region(&pdev->dev,
 			res->start, resource_size(res), pdev->name);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to reserve registers.\n");
-		err = -EBUSY;
-		goto err;
+		return -EBUSY;
 	}
 
 	tscadc->tscadc_base = devm_ioremap(&pdev->dev,
 			res->start, resource_size(res));
 	if (!tscadc->tscadc_base) {
 		dev_err(&pdev->dev, "failed to map registers.\n");
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	tscadc->regmap_tscadc = devm_regmap_init_mmio(&pdev->dev,
@@ -129,7 +126,7 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 	if (IS_ERR(tscadc->regmap_tscadc)) {
 		dev_err(&pdev->dev, "regmap init failed\n");
 		err = PTR_ERR(tscadc->regmap_tscadc);
-		goto err;
+		goto ret;
 	}
 
 	pm_runtime_enable(&pdev->dev);
@@ -201,7 +198,7 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
 err_disable_clk:
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-err:
+ret:
 	return err;
 }
 
-- 
1.7.0.4

