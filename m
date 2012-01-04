Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2ADHH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:07:56 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:59283 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752624Ab2ADHHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:07:48 -0500
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, a.zummo@towertech.it, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Kevin Liu <kliu5@marvell.com>, Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: [PATCH 3/3] rtc: max8925: add function to work as wakeup source
Date: Wed,  4 Jan 2012 15:14:26 +0800
Message-Id: <1325661266-7982-3-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325661266-7982-1-git-send-email-haojian.zhuang@marvell.com>
References: <1325661266-7982-1-git-send-email-haojian.zhuang@marvell.com>
X-OriginalArrivalTime: 04 Jan 2012 07:07:16.0350 (UTC) FILETIME=[7DAD51E0:01CCCAAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Liu <kliu5@marvell.com>

Signed-off-by: Kevin Liu <kliu5@marvell.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/rtc/rtc-max8925.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 3bc046f..b281bae 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -261,6 +261,8 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 	/* XXX - isn't this redundant? */
 	platform_set_drvdata(pdev, info);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
 					&max8925_rtc_ops, THIS_MODULE);
 	ret = PTR_ERR(info->rtc_dev);
@@ -290,10 +292,34 @@ static int __devexit max8925_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int max8925_rtc_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
+
+	if (device_may_wakeup(dev))
+		chip->wakeup_flag |= 1 << MAX8925_IRQ_RTC_ALARM0;
+	return 0;
+}
+static int max8925_rtc_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
+
+	if (device_may_wakeup(dev))
+		chip->wakeup_flag &= ~(1 << MAX8925_IRQ_RTC_ALARM0);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(max8925_rtc_pm_ops, max8925_rtc_suspend, max8925_rtc_resume);
+
 static struct platform_driver max8925_rtc_driver = {
 	.driver		= {
 		.name	= "max8925-rtc",
 		.owner	= THIS_MODULE,
+		.pm     = &max8925_rtc_pm_ops,
 	},
 	.probe		= max8925_rtc_probe,
 	.remove		= __devexit_p(max8925_rtc_remove),
-- 
1.7.0.4

