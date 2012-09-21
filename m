Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab2IULAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 07:00:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5968 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab2IULAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:00:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 21 Sep 2012 03:52:02 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <akpm@linux-foundation.org>, <a.zummo@towertech.it>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq details
Date: Fri, 21 Sep 2012 16:30:23 +0530
Message-ID: <1348225223-32156-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As RTC driver needs only irq number from platform data,
using platform_get_irq(), instead of generic dev_get_platdata().

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 691ab96..e3ffae0 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -226,7 +226,6 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 {
 	struct tps65910 *tps65910 = NULL;
 	struct tps65910_rtc *tps_rtc = NULL;
-	struct tps65910_board *pmic_plat_data;
 	int ret;
 	int irq;
 	u32 rtc_reg;
@@ -247,28 +246,27 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	dev_dbg(&pdev->dev, "Enabling rtc-tps65910.\n");
+	dev_dbg(&pdev->dev, "Enabling tps65910 rtc.\n");
 	rtc_reg = TPS65910_RTC_CTRL_STOP_RTC;
 	ret = regmap_write(tps65910->regmap, TPS65910_RTC_CTRL, rtc_reg);
 	if (ret < 0)
 		return ret;
 
-	pmic_plat_data = dev_get_platdata(tps65910->dev);
-	irq = pmic_plat_data->irq_base;
+	irq  = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_warn(&pdev->dev, "Wake up is not possible as irq = %d\n",
 			irq);
 		return ret;
 	}
 
-	irq += TPS65910_IRQ_RTC_ALARM;
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
-		"rtc-tps65910", &pdev->dev);
+		"tps65910-rtc", &pdev->dev);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "IRQ is not free.\n");
+		dev_err(&pdev->dev, "IRQ %d is not free.\n", irq);
 		return ret;
 	}
+
 	device_init_wakeup(&pdev->dev, 1);
 
 	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
@@ -341,7 +339,7 @@ static struct platform_driver tps65910_rtc_driver = {
 	.remove		= __devexit_p(tps65910_rtc_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
-		.name	= "rtc-tps65910",
+		.name	= "tps65910-rtc",
 		.pm	= DEV_PM_OPS,
 	},
 };
-- 
1.7.1.1

