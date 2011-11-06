Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1KFQrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:47:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59149 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1KFQq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:46:58 -0500
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH 2/2] RTC MXC: Make alarm working
Date: Sun,  6 Nov 2011 19:46:46 +0300
Message-Id: <1320598006-17678-3-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320598006-17678-1-git-send-email-jekhor@gmail.com>
References: <1320598006-17678-1-git-send-email-jekhor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix alarm IRQ handling, make the alarm one-shot. Cleanup black magick with
a validation of already validated time data.

Add ability to wake the system with alarm.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
---
 drivers/rtc/rtc-mxc.c |  112 ++++++++++++++++++++++++++-----------------------
 1 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 1cf6a0b..69a58c4 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -155,7 +155,6 @@ static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
 {
 	struct rtc_time alarm_tm, now_tm;
 	unsigned long now, time;
-	int ret;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
@@ -168,21 +167,33 @@ static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
 	alarm_tm.tm_hour = alrm->tm_hour;
 	alarm_tm.tm_min = alrm->tm_min;
 	alarm_tm.tm_sec = alrm->tm_sec;
-	rtc_tm_to_time(&now_tm, &now);
 	rtc_tm_to_time(&alarm_tm, &time);
 
-	if (time < now) {
-		time += 60 * 60 * 24;
-		rtc_time_to_tm(time, &alarm_tm);
-	}
-
-	ret = rtc_tm_to_time(&alarm_tm, &time);
-
 	/* clear all the interrupt status bits */
 	writew(readw(ioaddr + RTC_RTCISR), ioaddr + RTC_RTCISR);
 	set_alarm_or_time(dev, MXC_RTC_ALARM, time);
 
-	return ret;
+	return 0;
+}
+
+static void mxc_rtc_irq_enable(struct device *dev, unsigned int bit,
+				unsigned int enabled)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
+	void __iomem *ioaddr = pdata->ioaddr;
+	u32 reg;
+
+	spin_lock_irq(&pdata->rtc->irq_lock);
+	reg = readw(ioaddr + RTC_RTCIENR);
+
+	if (enabled)
+		reg |= bit;
+	else
+		reg &= ~bit;
+
+	writew(reg, ioaddr + RTC_RTCIENR);
+	spin_unlock_irq(&pdata->rtc->irq_lock);
 }
 
 /* This function is the RTC interrupt service routine. */
@@ -199,13 +210,12 @@ static irqreturn_t mxc_rtc_interrupt(int irq, void *dev_id)
 	/* clear interrupt sources */
 	writew(status, ioaddr + RTC_RTCISR);
 
-	/* clear alarm interrupt if it has occurred */
-	if (status & RTC_ALM_BIT)
-		status &= ~RTC_ALM_BIT;
-
 	/* update irq data & counter */
-	if (status & RTC_ALM_BIT)
+	if (status & RTC_ALM_BIT) {
 		events |= (RTC_AF | RTC_IRQF);
+		/* RTC alarm should be one-shot */
+		mxc_rtc_irq_enable(&pdev->dev, RTC_ALM_BIT, 0);
+	}
 
 	if (status & RTC_1HZ_BIT)
 		events |= (RTC_UF | RTC_IRQF);
@@ -213,9 +223,6 @@ static irqreturn_t mxc_rtc_interrupt(int irq, void *dev_id)
 	if (status & PIT_ALL_ON)
 		events |= (RTC_PF | RTC_IRQF);
 
-	if ((status & RTC_ALM_BIT) && rtc_valid_tm(&pdata->g_rtc_alarm))
-		rtc_update_alarm(&pdev->dev, &pdata->g_rtc_alarm);
-
 	rtc_update_irq(pdata->rtc, 1, events);
 	spin_unlock_irq(&pdata->rtc->irq_lock);
 
@@ -242,26 +249,6 @@ static void mxc_rtc_release(struct device *dev)
 	spin_unlock_irq(&pdata->rtc->irq_lock);
 }
 
-static void mxc_rtc_irq_enable(struct device *dev, unsigned int bit,
-				unsigned int enabled)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	void __iomem *ioaddr = pdata->ioaddr;
-	u32 reg;
-
-	spin_lock_irq(&pdata->rtc->irq_lock);
-	reg = readw(ioaddr + RTC_RTCIENR);
-
-	if (enabled)
-		reg |= bit;
-	else
-		reg &= ~bit;
-
-	writew(reg, ioaddr + RTC_RTCIENR);
-	spin_unlock_irq(&pdata->rtc->irq_lock);
-}
-
 static int mxc_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	mxc_rtc_irq_enable(dev, RTC_ALM_BIT, enabled);
@@ -335,21 +322,7 @@ static int mxc_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	int ret;
 
-	if (rtc_valid_tm(&alrm->time)) {
-		if (alrm->time.tm_sec > 59 ||
-		    alrm->time.tm_hour > 23 ||
-		    alrm->time.tm_min > 59)
-			return -EINVAL;
-
-		ret = rtc_update_alarm(dev, &alrm->time);
-	} else {
-		ret = rtc_valid_tm(&alrm->time);
-		if (ret)
-			return ret;
-
-		ret = rtc_update_alarm(dev, &alrm->time);
-	}
-
+	ret = rtc_update_alarm(dev, &alrm->time);
 	if (ret)
 		return ret;
 
@@ -435,6 +408,9 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
 		pdata->irq = -1;
 	}
 
+	if (pdata->irq >=0)
+		device_init_wakeup(&pdev->dev, 1);
+
 	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -470,9 +446,39 @@ static int __exit mxc_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int mxc_rtc_suspend(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(pdata->irq);
+
+	return 0;
+}
+
+static int mxc_rtc_resume(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(pdata->irq);
+
+	return 0;
+}
+#endif
+
+static struct dev_pm_ops mxc_rtc_pm_ops = {
+	.suspend	= mxc_rtc_suspend,
+	.resume		= mxc_rtc_resume,
+};
+
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
 		   .name	= "mxc_rtc",
+#ifdef CONFIG_PM
+		   .pm		= &mxc_rtc_pm_ops,
+#endif
 		   .owner	= THIS_MODULE,
 	},
 	.remove		= __exit_p(mxc_rtc_remove),
-- 
1.7.7.1

