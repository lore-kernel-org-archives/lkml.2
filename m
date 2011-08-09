Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1HIQhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:37:16 -0400
Received: from relay.pcl-ipout02.plus.net ([212.159.7.100]:7265 "EHLO
	relay.pcl-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab1HIQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:37:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMdABpfQU5UXebj/2dsb2JhbABCgh2CbJJmj093gW5ScTUYE4dvrXECh1OJLQ6GOASYDoRmhnw
Subject: [PATCH] mfd: asic3: Add LED suspend/resume handlers
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <philipp.zabel@gmail.com>, <sameo@linux.intel.com>, <mad_soft@inbox.ru>,
        <koen@dominion.thruhere.net>
Date: Tue, 09 Aug 2011 16:27:33 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.39 x86_64 [http://email.cleancode.org])
Message-Id: <E1Qqp9T-000104-Ly@outmx01.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added led suspend/resume handlers to the leds/leds-asic3 and mfd/asic3 drivers.
On suspend the leds will be turned off and their clocks disabled. On resume the
reverse.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---

diff -uprN clean-3.0.1/drivers/leds/leds-asic3.c linux-3.0.1/drivers/leds/leds-asic3.c
--- clean-3.0.1/drivers/leds/leds-asic3.c	2011-08-05 05:59:21.000000000 +0100
+++ linux-3.0.1/drivers/leds/leds-asic3.c	2011-08-08 10:46:03.164860492 +0100
@@ -107,9 +107,10 @@ static int __devinit asic3_led_probe(str
 	}
 
 	led->cdev->name = led->name;
-	led->cdev->default_trigger = led->default_trigger;
+	led->cdev->flags = LED_CORE_SUSPENDRESUME;
 	led->cdev->brightness_set = brightness_set;
 	led->cdev->blink_set = blink_set;
+	led->cdev->default_trigger = led->default_trigger;
 
 	ret = led_classdev_register(&pdev->dev, led->cdev);
 	if (ret < 0)
@@ -136,12 +137,44 @@ static int __devexit asic3_led_remove(st
 	return mfd_cell_disable(pdev);
 }
 
+static int asic3_led_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	int ret;
+
+	ret = 0;
+	if (cell->suspend)
+		ret = (*cell->suspend)(pdev);
+
+	return ret;
+}
+
+static int asic3_led_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	int ret;
+
+	ret = 0;
+	if (cell->resume)
+		ret = (*cell->resume)(pdev);
+
+	return ret;
+}
+
+static const struct dev_pm_ops asic3_led_pm_ops = {
+	.suspend	= asic3_led_suspend,
+	.resume		= asic3_led_resume,
+};
+
 static struct platform_driver asic3_led_driver = {
 	.probe		= asic3_led_probe,
 	.remove		= __devexit_p(asic3_led_remove),
 	.driver		= {
 		.name	= "leds-asic3",
 		.owner	= THIS_MODULE,
+		.pm	= &asic3_led_pm_ops,
 	},
 };
 
diff -uprN clean-3.0.1/drivers/mfd/asic3.c linux-3.0.1/drivers/mfd/asic3.c
--- clean-3.0.1/drivers/mfd/asic3.c	2011-08-05 05:59:21.000000000 +0100
+++ linux-3.0.1/drivers/mfd/asic3.c	2011-08-08 10:46:03.164860492 +0100
@@ -811,24 +813,43 @@ static int asic3_leds_disable(struct pla
 	return 0;
 }
 
+static int asic3_leds_suspend(struct platform_device *pdev)
+{
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct asic3 *asic = dev_get_drvdata(pdev->dev.parent);
+
+	while (asic3_gpio_get(&asic->gpio, ASIC3_GPIO(C, cell->id)) != 0)
+		msleep(1);
+
+	asic3_clk_disable(asic, &asic->clocks[clock_ledn[cell->id]]);
+
+	return 0;
+}
+
 static struct mfd_cell asic3_cell_leds[ASIC3_NUM_LEDS] = {
 	[0] = {
 		.name          = "leds-asic3",
 		.id            = 0,
 		.enable        = asic3_leds_enable,
 		.disable       = asic3_leds_disable,
+		.suspend       = asic3_leds_suspend,
+		.resume        = asic3_leds_enable,
 	},
 	[1] = {
 		.name          = "leds-asic3",
 		.id            = 1,
 		.enable        = asic3_leds_enable,
 		.disable       = asic3_leds_disable,
+		.suspend       = asic3_leds_suspend,
+		.resume        = asic3_leds_enable,
 	},
 	[2] = {
 		.name          = "leds-asic3",
 		.id            = 2,
 		.enable        = asic3_leds_enable,
 		.disable       = asic3_leds_disable,
+		.suspend       = asic3_leds_suspend,
+		.resume        = asic3_leds_enable,
 	},
 };
 

