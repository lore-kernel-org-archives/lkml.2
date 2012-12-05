Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2LEGtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 01:49:35 -0500
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:34405 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828Ab2LEGtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 01:49:32 -0500
From: Chao Xie <chao.xie@marvell.com>
To: haojian.zhuang@gmail.com, xiechao.mail@gmail.com, linux@arm.linux.org.uk,
        a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead,
        robert.jarzmik@free.fr
Cc: Chao Xie <chao.xie@marvell.com>
Subject: [V2 PATCH 1/2] rtc: sa1100: move clock enable/disable to probe/remove
Date: Wed,  5 Dec 2012 01:49:08 -0500
Message-Id: <1354690149-3043-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 05 Dec 2012 06:49:12.0417 (UTC) FILETIME=[A2664510:01CDD2B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original sa1100_rtc_open/sa1100_rtc_release will be called
when the /dev/rtc0 is opened or closed.
In fact, these two functions will enable/disable the clock.
Disabling clock will make rtc not work.
So only enable/disable clock when probe/remove the device.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/rtc/rtc-sa1100.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 50a5c4a..34f66b8 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -108,9 +108,6 @@ static int sa1100_rtc_open(struct device *dev)
 	struct rtc_device *rtc = info->rtc;
 	int ret;
 
-	ret = clk_prepare_enable(info->clk);
-	if (ret)
-		goto fail_clk;
 	ret = request_irq(info->irq_1hz, sa1100_rtc_interrupt, 0, "rtc 1Hz", dev);
 	if (ret) {
 		dev_err(dev, "IRQ %d already in use.\n", info->irq_1hz);
@@ -130,7 +127,6 @@ static int sa1100_rtc_open(struct device *dev)
 	free_irq(info->irq_1hz, dev);
  fail_ui:
 	clk_disable_unprepare(info->clk);
- fail_clk:
 	return ret;
 }
 
@@ -144,7 +140,6 @@ static void sa1100_rtc_release(struct device *dev)
 
 	free_irq(info->irq_alarm, dev);
 	free_irq(info->irq_1hz, dev);
-	clk_disable_unprepare(info->clk);
 }
 
 static int sa1100_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
@@ -253,6 +248,9 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 	spin_lock_init(&info->lock);
 	platform_set_drvdata(pdev, info);
 
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		goto err_enable_clk;
 	/*
 	 * According to the manual we should be able to let RTTR be zero
 	 * and then a default diviser for a 32.768KHz clock is used.
@@ -305,6 +303,8 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 err_dev:
+	clk_disable_unprepare(info->clk);
+err_enable_clk:
 	platform_set_drvdata(pdev, NULL);
 	clk_put(info->clk);
 err_clk:
@@ -318,6 +318,7 @@ static int sa1100_rtc_remove(struct platform_device *pdev)
 
 	if (info) {
 		rtc_device_unregister(info->rtc);
+		clk_disable_unprepare(info->clk);
 		clk_put(info->clk);
 		platform_set_drvdata(pdev, NULL);
 		kfree(info);
-- 
1.7.4.1

