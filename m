Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2LXJwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 04:52:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16792 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2LXJw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 04:52:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 24 Dec 2012 01:51:43 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <a.zummo@towertech.it>
CC: <akpm@linuxfoundation.org>, <broonie@opensource.wolfsonmicro.com>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] rtc: tps65910: remove un-necessary irq stat save and restore
Date: Mon, 24 Dec 2012 15:21:25 +0530
Message-ID: <1356342687-3432-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
References: <1356342687-3432-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver stores the interrupt enable register before going to
suspend and restore in resume. Also it enables alarm before going
to suspend.

The driver only write the Interrupt enable register for enabling ALARM
and does not enable any other bits. So it is not require to save complete
register and enable ALARM interrupt before suspend and restore in resume.

Also ALARM interrupt already enable if alarm is enabled before going to
suspend and hence it is not require to enable explictly in suspend.

Removing such above code.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/rtc/rtc-tps65910.c |   21 ++-------------------
 1 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index c637fff..728bb8b 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -28,8 +28,6 @@
 struct tps65910_rtc {
 	struct rtc_device	*rtc;
 	int irq;
-	/* To store the list of enabled interrupts */
-	u32 irqstat;
 };
 
 /* Total number of RTC registers needed to set time*/
@@ -309,35 +307,20 @@ static int __devexit tps65910_rtc_remove(struct platform_device *pdev)
 
 static int tps65910_rtc_suspend(struct device *dev)
 {
-	struct tps65910 *tps = dev_get_drvdata(dev->parent);
 	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
-	u8 alarm = TPS65910_RTC_INTERRUPTS_IT_ALARM;
-	int ret;
 
 	if (device_may_wakeup(dev))
 		enable_irq_wake(tps_rtc->irq);
-
-	/* Store current list of enabled interrupts*/
-	ret = regmap_read(tps->regmap, TPS65910_RTC_INTERRUPTS,
-		&tps->rtc->irqstat);
-	if (ret < 0)
-		return ret;
-
-	/* Enable RTC ALARM interrupt only */
-	return regmap_write(tps->regmap, TPS65910_RTC_INTERRUPTS, alarm);
+	return 0;
 }
 
 static int tps65910_rtc_resume(struct device *dev)
 {
-	struct tps65910 *tps = dev_get_drvdata(dev->parent);
 	struct tps65910_rtc *tps_rtc = dev_get_drvdata(dev);
 
 	if (device_may_wakeup(dev))
 		disable_irq_wake(tps_rtc->irq);
-
-	/* Restore list of enabled interrupts before suspend */
-	return regmap_write(tps->regmap, TPS65910_RTC_INTERRUPTS,
-		tps->rtc->irqstat);
+	return 0;
 }
 
 static const struct dev_pm_ops tps65910_rtc_pm_ops = {
-- 
1.7.1.1

