Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2K2CVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:21:16 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:37720 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab2K2CVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:21:14 -0500
From: Chao Xie <chao.xie@marvell.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, xiechao.mail@gmail.com
Subject: [PATCH 1/4] rtc: sa1100: enable/disable rtc when probe/remove the device
Date: Wed, 28 Nov 2012 21:21:07 -0500
Message-Id: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 29 Nov 2012 02:21:01.0484 (UTC) FILETIME=[2CFA3EC0:01CDCDD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original sa1100_rtc_open/sa1100_rtc_release will be called
when the /dev/rtc0 is opened or closed.
In fact, these two functions will enable/disable the clock, and
register/unregister the irqs.
User application will use /dev/rtc0 to read the rtc time or set
the alarm. The rtc should still run indepent of open/close the
rtc device.
So only enable clock and register the irqs when probe the device,
and disable clock and unregister the irqs when remove the device.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/rtc/rtc-sa1100.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 50a5c4a..e933327 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -218,8 +218,6 @@ static int sa1100_rtc_proc(struct device *dev, struct seq_file *seq)
 }
 
 static const struct rtc_class_ops sa1100_rtc_ops = {
-	.open = sa1100_rtc_open,
-	.release = sa1100_rtc_release,
 	.read_time = sa1100_rtc_read_time,
 	.set_time = sa1100_rtc_set_time,
 	.read_alarm = sa1100_rtc_read_alarm,
@@ -253,6 +251,10 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 	spin_lock_init(&info->lock);
 	platform_set_drvdata(pdev, info);
 
+	ret = sa1100_rtc_open(&pdev->dev);
+	if (ret)
+		goto err_open;
+
 	/*
 	 * According to the manual we should be able to let RTTR be zero
 	 * and then a default diviser for a 32.768KHz clock is used.
@@ -305,7 +307,9 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 err_dev:
+	sa1100_rtc_release(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
+err_open:
 	clk_put(info->clk);
 err_clk:
 	kfree(info);
@@ -318,6 +322,7 @@ static int sa1100_rtc_remove(struct platform_device *pdev)
 
 	if (info) {
 		rtc_device_unregister(info->rtc);
+		sa1100_rtc_release(&pdev->dev);
 		clk_put(info->clk);
 		platform_set_drvdata(pdev, NULL);
 		kfree(info);
-- 
1.7.4.1

