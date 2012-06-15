Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2FOKWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:22:07 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:42946 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544Ab2FOKWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:22:06 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        peter.ujfalusi@ti.com
Subject: [PATCH 2/2] Input: twl6040-vibra: Code cleanup in probe with devm_* conversion
Date: Fri, 15 Jun 2012 13:22:12 +0300
Message-Id: <1339755732-23774-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339755732-23774-1-git-send-email-peter.ujfalusi@ti.com>
References: <1339755732-23774-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the probe to use devm_*. At the same time reorder the calls
so we will register the input device as the last step when the driver
is loaded.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c |   99 ++++++++++++++++-------------------
 1 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index e8f3f5f..488cb61 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -276,7 +276,7 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "couldn't allocate memory\n");
 		return -ENOMEM;
@@ -310,53 +310,23 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 	if ((!info->vibldrv_res && !info->viblmotor_res) ||
 	    (!info->vibrdrv_res && !info->vibrmotor_res)) {
 		dev_err(info->dev, "invalid vibra driver/motor resistance\n");
-		ret = -EINVAL;
-		goto err_kzalloc;
+		return -EINVAL;
 	}
 
 	info->irq = platform_get_irq(pdev, 0);
 	if (info->irq < 0) {
 		dev_err(info->dev, "invalid irq\n");
-		ret = -EINVAL;
-		goto err_kzalloc;
+		return -EINVAL;
 	}
 
 	mutex_init(&info->mutex);
 
-	info->input_dev = input_allocate_device();
-	if (info->input_dev == NULL) {
-		dev_err(info->dev, "couldn't allocate input device\n");
-		ret = -ENOMEM;
-		goto err_kzalloc;
-	}
-
-	input_set_drvdata(info->input_dev, info);
-
-	info->input_dev->name = "twl6040:vibrator";
-	info->input_dev->id.version = 1;
-	info->input_dev->dev.parent = pdev->dev.parent;
-	info->input_dev->close = twl6040_vibra_close;
-	__set_bit(FF_RUMBLE, info->input_dev->ffbit);
-
-	ret = input_ff_create_memless(info->input_dev, NULL, vibra_play);
-	if (ret < 0) {
-		dev_err(info->dev, "couldn't register vibrator to FF\n");
-		goto err_ialloc;
-	}
-
-	ret = input_register_device(info->input_dev);
-	if (ret < 0) {
-		dev_err(info->dev, "couldn't register input device\n");
-		goto err_iff;
-	}
-
-	platform_set_drvdata(pdev, info);
-
-	ret = request_threaded_irq(info->irq, NULL, twl6040_vib_irq_handler, 0,
-				   "twl6040_irq_vib", info);
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
+					twl6040_vib_irq_handler, 0,
+					"twl6040_irq_vib", info);
 	if (ret) {
 		dev_err(info->dev, "VIB IRQ request failed: %d\n", ret);
-		goto err_irq;
+		return ret;
 	}
 
 	info->supplies[0].supply = "vddvibl";
@@ -374,7 +344,7 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 					 info->supplies);
 	if (ret) {
 		dev_err(info->dev, "couldn't get regulators %d\n", ret);
-		goto err_regulator;
+		return ret;
 	}
 
 	if (vddvibl_uV) {
@@ -383,7 +353,7 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(info->dev, "failed to set VDDVIBL volt %d\n",
 				ret);
-			goto err_voltage;
+			goto err_regulator;
 		}
 	}
 
@@ -393,7 +363,7 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(info->dev, "failed to set VDDVIBR volt %d\n",
 				ret);
-			goto err_voltage;
+			goto err_regulator;
 		}
 	}
 
@@ -401,26 +371,49 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 	if (info->workqueue == NULL) {
 		dev_err(info->dev, "couldn't create workqueue\n");
 		ret = -ENOMEM;
-		goto err_voltage;
+		goto err_regulator;
 	}
 	INIT_WORK(&info->play_work, vibra_play_work);
 
+	info->input_dev = input_allocate_device();
+	if (info->input_dev == NULL) {
+		dev_err(info->dev, "couldn't allocate input device\n");
+		ret = -ENOMEM;
+		goto err_wq;
+	}
+
+	input_set_drvdata(info->input_dev, info);
+
+	info->input_dev->name = "twl6040:vibrator";
+	info->input_dev->id.version = 1;
+	info->input_dev->dev.parent = pdev->dev.parent;
+	info->input_dev->close = twl6040_vibra_close;
+	__set_bit(FF_RUMBLE, info->input_dev->ffbit);
+
+	ret = input_ff_create_memless(info->input_dev, NULL, vibra_play);
+	if (ret < 0) {
+		dev_err(info->dev, "couldn't register vibrator to FF\n");
+		goto err_ialloc;
+	}
+
+	ret = input_register_device(info->input_dev);
+	if (ret < 0) {
+		dev_err(info->dev, "couldn't register input device\n");
+		goto err_iff;
+	}
+
+	platform_set_drvdata(pdev, info);
+
 	return 0;
 
-err_voltage:
-	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
-err_regulator:
-	free_irq(info->irq, info);
-err_irq:
-	input_unregister_device(info->input_dev);
-	info->input_dev = NULL;
 err_iff:
-	if (info->input_dev)
-		input_ff_destroy(info->input_dev);
+	input_ff_destroy(info->input_dev);
 err_ialloc:
 	input_free_device(info->input_dev);
-err_kzalloc:
-	kfree(info);
+err_wq:
+	destroy_workqueue(info->workqueue);
+err_regulator:
+	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
 	return ret;
 }
 
@@ -429,10 +422,8 @@ static int __devexit twl6040_vibra_remove(struct platform_device *pdev)
 	struct vibra_info *info = platform_get_drvdata(pdev);
 
 	input_unregister_device(info->input_dev);
-	free_irq(info->irq, info);
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
 	destroy_workqueue(info->workqueue);
-	kfree(info);
 
 	return 0;
 }
-- 
1.7.8.6

