Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2AJKWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:22:24 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:57735 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755833Ab2AJKWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:22:21 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, a.zummo@towertech.it, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, kliu5@marvell.com
Subject: [PATCH 2/3] misc: max8925_onkey: add function to work as wakeup source
Date: Tue, 10 Jan 2012 18:24:40 +0800
Message-Id: <1326191080-24524-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20120109002946.GJ13679@sortiz-mobl>
References: <20120109002946.GJ13679@sortiz-mobl>
X-OriginalArrivalTime: 10 Jan 2012 10:16:16.0099 (UTC) FILETIME=[E32C3330:01CCCF80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Liu <kliu5@marvell.com>

Signed-off-by: Kevin Liu <kliu5@marvell.com>
---
 drivers/input/misc/max8925_onkey.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/max8925_onkey.c b/drivers/input/misc/max8925_onkey.c
index 7de0ded..b0fe395 100644
--- a/drivers/input/misc/max8925_onkey.c
+++ b/drivers/input/misc/max8925_onkey.c
@@ -122,6 +122,7 @@ static int __devinit max8925_onkey_probe(struct platform_device *pdev)
 	info->idev->evbit[0] = BIT_MASK(EV_KEY);
 	info->idev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
 
+	device_init_wakeup(&pdev->dev, 1);
 
 	error = input_register_device(info->idev);
 	if (error) {
@@ -158,10 +159,41 @@ static int __devexit max8925_onkey_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int max8925_onkey_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct max8925_onkey_info *info = platform_get_drvdata(pdev);
+	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
+
+	if (device_may_wakeup(dev)) {
+		chip->wakeup_flag |= 1 << (info->irq[0] - chip->irq_base);
+		chip->wakeup_flag |= 1 << (info->irq[1] - chip->irq_base);
+	}
+	return 0;
+}
+
+static int max8925_onkey_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct max8925_onkey_info *info = platform_get_drvdata(pdev);
+	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
+
+	if (device_may_wakeup(dev)) {
+		chip->wakeup_flag &= ~(1 << (info->irq[0] - chip->irq_base));
+		chip->wakeup_flag &= ~(1 << (info->irq[1] - chip->irq_base));
+	}
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(max8925_onkey_pm_ops, max8925_onkey_suspend, max8925_onkey_resume);
+
 static struct platform_driver max8925_onkey_driver = {
 	.driver		= {
 		.name	= "max8925-onkey",
 		.owner	= THIS_MODULE,
+		.pm	= &max8925_onkey_pm_ops,
 	},
 	.probe		= max8925_onkey_probe,
 	.remove		= __devexit_p(max8925_onkey_remove),
-- 
1.7.0.4

