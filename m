Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1HRIUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:20:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38613 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab1HRIU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:20:26 -0400
X-AuditID: cbfee61b-b7b7fae000005864-e7-4e4ccb45477c
Date: Thu, 18 Aug 2011 17:20:20 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 2/2] rtc: rtc-s3c: Allow multiple open / allow
 no-ioctl-open'ed rtc to have irq.
In-reply-to: <1313655620-1046-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Changhwan Youn <chaos.youn@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1313655620-1046-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1313655620-1046-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 18 Aug 2011 08:21:04.0501 (UTC)
 FILETIME=[C5A44A50:01CC5D7F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous rtc-s3c had two issues related with its IRQ.
1. Users cannot open rtc multiple times because an open operation calls
request_irq on the same IRQ. (e.g., two user processes wants to open and
read RTC time from rtc-s3c at the same time)
2. If alarm is set and no one has the rtc opened with filesystem
(either the alarm is set by kernel/boot-loader or user set an alarm
and closed rtc dev file), the pending bit is not cleared and no further
interrupt is invoked. When the alarm is used by the system itself such
as a resume from suspend-to-RAM or other Low-power modes/idle, this is a
critical issue.

This patch mitigates these issues by calling request_irq at probe and
free_irq at remove.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

--
Changes from v1
- Error handling in probe function added.
---
 drivers/rtc/rtc-s3c.c |   67 ++++++++++++++++++------------------------------
 1 files changed, 25 insertions(+), 42 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 067207a..4e7c04e 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -319,49 +319,7 @@ static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 	return 0;
 }
 
-static int s3c_rtc_open(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
-			  IRQF_DISABLED,  "s3c2410-rtc alarm", rtc_dev);
-
-	if (ret) {
-		dev_err(dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
-		return ret;
-	}
-
-	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
-			  IRQF_DISABLED,  "s3c2410-rtc tick", rtc_dev);
-
-	if (ret) {
-		dev_err(dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
-		goto tick_err;
-	}
-
-	return ret;
-
- tick_err:
-	free_irq(s3c_rtc_alarmno, rtc_dev);
-	return ret;
-}
-
-static void s3c_rtc_release(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
-
-	/* do not clear AIE here, it may be needed for wake */
-
-	free_irq(s3c_rtc_alarmno, rtc_dev);
-	free_irq(s3c_rtc_tickno, rtc_dev);
-}
-
 static const struct rtc_class_ops s3c_rtcops = {
-	.open		= s3c_rtc_open,
-	.release	= s3c_rtc_release,
 	.read_time	= s3c_rtc_gettime,
 	.set_time	= s3c_rtc_settime,
 	.read_alarm	= s3c_rtc_getalarm,
@@ -425,6 +383,9 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
+	free_irq(s3c_rtc_alarmno, rtc);
+	free_irq(s3c_rtc_tickno, rtc);
+
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
@@ -548,10 +509,32 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
+	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
+			  IRQF_DISABLED,  "s3c2410-rtc alarm", rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
+		goto err_alarm_irq;
+	}
+
+	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
+			  IRQF_DISABLED,  "s3c2410-rtc tick", rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
+		free_irq(s3c_rtc_alarmno, rtc);
+		goto err_tick_irq;
+	}
+
 	clk_disable(rtc_clk);
 
 	return 0;
 
+ err_tick_irq:
+	free_irq(s3c_rtc_alarmno, rtc);
+
+ err_alarm_irq:
+	platform_set_drvdata(pdev, NULL);
+	rtc_device_unregister(rtc);
+
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
 	clk_disable(rtc_clk);
-- 
1.7.4.1

