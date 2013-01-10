Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3AJNgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:36:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41969 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3AJNgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:36:13 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dtor@mail.ru>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH resend 2/2] Input: twl6040-vibra: Code cleanup in probe with devm_* conversion
Date: Thu, 10 Jan 2013 14:36:05 +0100
Message-ID: <1357824965-30614-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357824965-30614-1-git-send-email-peter.ujfalusi@ti.com>
References: <1357824965-30614-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the probe to use devm_*. At the same time reorder the calls
so we will register the input device as the last step when the driver
is loaded.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c | 99 +++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 54 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 71a28ee..d1e31b8 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -275,7 +275,7 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "couldn't allocate memory\n");
 		return -ENOMEM;
@@ -309,53 +309,23 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
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
@@ -368,7 +338,7 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 				 ARRAY_SIZE(info->supplies), info->supplies);
 	if (ret) {
 		dev_err(info->dev, "couldn't get regulators %d\n", ret);
-		goto err_regulator;
+		return ret;
 	}
 
 	if (vddvibl_uV) {
@@ -377,7 +347,7 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(info->dev, "failed to set VDDVIBL volt %d\n",
 				ret);
-			goto err_voltage;
+			goto err_regulator;
 		}
 	}
 
@@ -387,7 +357,7 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(info->dev, "failed to set VDDVIBR volt %d\n",
 				ret);
-			goto err_voltage;
+			goto err_regulator;
 		}
 	}
 
@@ -395,26 +365,49 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
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
 
@@ -423,10 +416,8 @@ static int twl6040_vibra_remove(struct platform_device *pdev)
 	struct vibra_info *info = platform_get_drvdata(pdev);
 
 	input_unregister_device(info->input_dev);
-	free_irq(info->irq, info);
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
 	destroy_workqueue(info->workqueue);
-	kfree(info);
 
 	return 0;
 }
-- 
1.8.1

