Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2LXJw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 04:52:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16775 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2LXJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 04:52:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 24 Dec 2012 01:49:47 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <a.zummo@towertech.it>
CC: <akpm@linuxfoundation.org>, <broonie@opensource.wolfsonmicro.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] rtc: tps65910: enable/disable wake in suspend/resume
Date: Mon, 24 Dec 2012 15:21:24 +0530
Message-ID: <1356342687-3432-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
References: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making the rtc driver as wakeup capabale and leaving the wake
enable/disable decision to user space through a sysfs attribute.

In suspend, enable wake if device wakeup enabled.
In resume disable wake again.

This change is inline with the Documentation/power/devices.txt#
/sys/devices/.../power/wakeup files

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 22eb4eb..c637fff 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -27,6 +27,7 @@
 
 struct tps65910_rtc {
 	struct rtc_device	*rtc;
+	int irq;
 	/* To store the list of enabled interrupts */
 	u32 irqstat;
 };
@@ -273,7 +274,8 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "IRQ is not free.\n");
 		return ret;
 	}
-	device_init_wakeup(&pdev->dev, 1);
+	tps_rtc->irq = irq;
+	device_set_wakeup_capable(&pdev->dev, 1);
 
 	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 		&tps65910_rtc_ops, THIS_MODULE);
@@ -308,9 +310,13 @@ static int __devexit tps65910_rtc_remove(struct platform_device *pdev)
 static int tps65910_rtc_suspend(struct device *dev)
 {
 	struct tps65910 *tps = dev_get_drvdata(dev->parent);
+	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
 	u8 alarm = TPS65910_RTC_INTERRUPTS_IT_ALARM;
 	int ret;
 
+	if (device_may_wakeup(dev))
+		enable_irq_wake(tps_rtc->irq);
+
 	/* Store current list of enabled interrupts*/
 	ret = regmap_read(tps->regmap, TPS65910_RTC_INTERRUPTS,
 		&tps->rtc->irqstat);
@@ -324,6 +330,10 @@ static int tps65910_rtc_suspend(struct device *dev)
 static int tps65910_rtc_resume(struct device *dev)
 {
 	struct tps65910 *tps = dev_get_drvdata(dev->parent);
+	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(tps_rtc->irq);
 
 	/* Restore list of enabled interrupts before suspend */
 	return regmap_write(tps->regmap, TPS65910_RTC_INTERRUPTS,
-- 
1.7.1.1

