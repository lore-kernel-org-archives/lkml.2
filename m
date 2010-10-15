Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0JOTkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:40:13 -0400
Received: from marvin.crapouillou.net ([82.233.222.246]:42330 "EHLO
	marvin.crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab0JOTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:40:11 -0400
X-Greylist: delayed 2894 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Oct 2010 15:40:11 EDT
From: Paul Cercueil <paul@crapouillou.net>
To: a.zummo@towertech.it
Cc: gortmaker@yahoo.com, lars@metafoo.de, mcuos.com@gmail.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH] Add the possibility to use the "alarm" function of the jz4740 RTC. Interrupts will now be raised when the "alarm" time is reached.
Date: Fri, 15 Oct 2010 20:51:11 +0200
Message-Id: <1287168671-5378-1-git-send-email-paul@crapouillou.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/rtc/rtc-jz4740.c |   45 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 2619d57..3ce8a42 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -1,5 +1,6 @@
 /*
  *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
+ *  Copyright (C) 2010, Paul Cercueil <paul@crapouillou.net>
  *	 JZ4740 SoC RTC driver
  *
  *  This program is free software; you can redistribute it and/or modify it
@@ -161,7 +162,8 @@ static int jz4740_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	ret = jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC_ALARM, secs);
 	if (!ret)
-		ret = jz4740_rtc_ctrl_set_bits(rtc, JZ_RTC_CTRL_AE, alrm->enabled);
+		ret = jz4740_rtc_ctrl_set_bits(rtc,
+			JZ_RTC_CTRL_AE | JZ_RTC_CTRL_AF_IRQ, alrm->enabled);
 
 	return ret;
 }
@@ -258,6 +260,8 @@ static int __devinit jz4740_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev, &jz4740_rtc_ops,
 					THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
@@ -318,12 +322,43 @@ static int __devexit jz4740_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+
+#ifdef CONFIG_PM
+static int jz4740_rtc_suspend(struct device *dev)
+{
+	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(rtc->irq);
+	return 0;
+}
+
+static int jz4740_rtc_resume(struct device *dev)
+{
+	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(rtc->irq);
+	return 0;
+}
+
+static const struct dev_pm_ops jz4740_pm_ops = {
+    .suspend = jz4740_rtc_suspend,
+    .resume  = jz4740_rtc_resume,
+};
+#define JZ4740_RTC_PM_OPS (&jz4740_pm_ops)
+
+#else
+#define JZ4740_RTC_PM_OPS NULL
+#endif  /* CONFIG_PM */
+
 struct platform_driver jz4740_rtc_driver = {
-	.probe = jz4740_rtc_probe,
-	.remove = __devexit_p(jz4740_rtc_remove),
-	.driver = {
-		.name = "jz4740-rtc",
+	.probe	 = jz4740_rtc_probe,
+	.remove	 = __devexit_p(jz4740_rtc_remove),
+	.driver	 = {
+		.name  = "jz4740-rtc",
 		.owner = THIS_MODULE,
+		.pm    = JZ4740_RTC_PM_OPS,
 	},
 };
 
-- 
1.7.0.4

