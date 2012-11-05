Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab2KEPMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:12:07 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63729 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab2KEPLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:11:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/8] mfd: ab8500-core: Use devm_* memory/IRQ and allocation/free routines
Date: Mon,  5 Nov 2012 16:10:35 +0100
Message-Id: <1352128236-11554-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
References: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is better to use devm_* calls, as they allow for easier
and more automatic clean-up. Resources are device allocated,
so when a device is freed, so are all associated resources.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c |   62 ++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index e7197fe..2a69dc2 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1233,7 +1233,7 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 	int i;
 	u8 value;
 
-	ab8500 = kzalloc(sizeof *ab8500, GFP_KERNEL);
+	ab8500 = devm_kzalloc(&pdev->dev, sizeof *ab8500, GFP_KERNEL);
 	if (!ab8500)
 		return -ENOMEM;
 
@@ -1243,10 +1243,8 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 	ab8500->dev = &pdev->dev;
 
 	resource = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!resource) {
-		ret = -ENODEV;
-		goto out_free_ab8500;
-	}
+	if (!resource)
+		return -ENODEV;
 
 	ab8500->irq = resource->start;
 
@@ -1269,7 +1267,7 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 		ret = get_register_interruptible(ab8500, AB8500_MISC,
 			AB8500_IC_NAME_REG, &value);
 		if (ret < 0)
-			goto out_free_ab8500;
+			return ret;
 
 		ab8500->version = value;
 	}
@@ -1277,7 +1275,7 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 	ret = get_register_interruptible(ab8500, AB8500_MISC,
 		AB8500_REV_REG, &value);
 	if (ret < 0)
-		goto out_free_ab8500;
+		return ret;
 
 	ab8500->chip_id = value;
 
@@ -1294,14 +1292,13 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 		ab8500->mask_size = AB8500_NUM_IRQ_REGS;
 		ab8500->irq_reg_offset = ab8500_irq_regoffset;
 	}
-	ab8500->mask = kzalloc(ab8500->mask_size, GFP_KERNEL);
+	ab8500->mask = devm_kzalloc(&pdev->dev, ab8500->mask_size, GFP_KERNEL);
 	if (!ab8500->mask)
 		return -ENOMEM;
-	ab8500->oldmask = kzalloc(ab8500->mask_size, GFP_KERNEL);
-	if (!ab8500->oldmask) {
-		ret = -ENOMEM;
-		goto out_freemask;
-	}
+	ab8500->oldmask = devm_kzalloc(&pdev->dev, ab8500->mask_size, GFP_KERNEL);
+	if (!ab8500->oldmask)
+		return -ENOMEM;
+
 	/*
 	 * ab8500 has switched off due to (SWITCH_OFF_STATUS):
 	 * 0x01 Swoff bit programming
@@ -1355,37 +1352,37 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 
 	ret = abx500_register_ops(ab8500->dev, &ab8500_ops);
 	if (ret)
-		goto out_freeoldmask;
+		return ret;
 
 	for (i = 0; i < ab8500->mask_size; i++)
 		ab8500->mask[i] = ab8500->oldmask[i] = 0xff;
 
 	ret = ab8500_irq_init(ab8500, np);
 	if (ret)
-		goto out_freeoldmask;
+		return ret;
 
 	/*  Activate this feature only in ab9540 */
 	/*  till tests are done on ab8500 1p2 or later*/
 	if (is_ab9540(ab8500)) {
-		ret = request_threaded_irq(ab8500->irq, NULL,
-					ab8500_hierarchical_irq,
-					IRQF_ONESHOT | IRQF_NO_SUSPEND,
-					"ab8500", ab8500);
+		ret = devm_request_threaded_irq(&pdev->dev, ab8500->irq, NULL,
+						ab8500_hierarchical_irq,
+						IRQF_ONESHOT | IRQF_NO_SUSPEND,
+						"ab8500", ab8500);
 	}
 	else {
-		ret = request_threaded_irq(ab8500->irq, NULL,
-					ab8500_irq,
-					IRQF_ONESHOT | IRQF_NO_SUSPEND,
-					"ab8500", ab8500);
+		ret = devm_request_threaded_irq(&pdev->dev, ab8500->irq, NULL,
+						ab8500_irq,
+						IRQF_ONESHOT | IRQF_NO_SUSPEND,
+						"ab8500", ab8500);
 		if (ret)
-			goto out_freeoldmask;
+			return ret;
 	}
 
 	ret = mfd_add_devices(ab8500->dev, 0, abx500_common_devs,
 			ARRAY_SIZE(abx500_common_devs), NULL,
 			ab8500->irq_base, ab8500->domain);
 	if (ret)
-		goto out_freeirq;
+		return ret;
 
 	if (is_ab9540(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_devs,
@@ -1396,14 +1393,14 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 				ARRAY_SIZE(ab8500_devs), NULL,
 				ab8500->irq_base, ab8500->domain);
 	if (ret)
-		goto out_freeirq;
+		return ret;
 
 	if (is_ab9540(ab8500) || is_ab8505(ab8500))
 		ret = mfd_add_devices(ab8500->dev, 0, ab9540_ab8505_devs,
 				ARRAY_SIZE(ab9540_ab8505_devs), NULL,
 				ab8500->irq_base, ab8500->domain);
 	if (ret)
-		goto out_freeirq;
+		return ret;
 
 	if (!no_bm) {
 		/* Add battery management devices */
@@ -1424,17 +1421,6 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 		dev_err(ab8500->dev, "error creating sysfs entries\n");
 
 	return ret;
-
-out_freeirq:
-	free_irq(ab8500->irq, ab8500);
-out_freeoldmask:
-	kfree(ab8500->oldmask);
-out_freemask:
-	kfree(ab8500->mask);
-out_free_ab8500:
-	kfree(ab8500);
-
-	return ret;
 }
 
 static int __devexit ab8500_remove(struct platform_device *pdev)
-- 
1.7.9.5

