Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab1EBJUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:20:36 -0400
Received: from smtp-out-187.synserver.de ([212.40.185.187]:1080 "HELO
	smtp-out-184.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754816Ab1EBJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:20:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 25605
From: Lars-Peter Clausen <lars@metafoo.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] RTC: PCF50633: Don't request update IRQ
Date: Mon,  2 May 2011 11:20:11 +0200
Message-Id: <1304328011-31184-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 51ba60c5(RTC: Cleanup rtc_class_ops->update_irq_enable()) removed the
only user of the update IRQ, so there is no need to manage it anymore.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/rtc/rtc-pcf50633.c |   23 +++--------------------
 1 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index f90c574..0c42389 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -58,7 +58,6 @@ struct pcf50633_time {
 
 struct pcf50633_rtc {
 	int alarm_enabled;
-	int second_enabled;
 	int alarm_pending;
 
 	struct pcf50633 *pcf;
@@ -143,7 +142,7 @@ static int pcf50633_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct pcf50633_rtc *rtc;
 	struct pcf50633_time pcf_tm;
-	int second_masked, alarm_masked, ret = 0;
+	int alarm_masked, ret = 0;
 
 	rtc = dev_get_drvdata(dev);
 
@@ -162,11 +161,8 @@ static int pcf50633_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		pcf_tm.time[PCF50633_TI_SEC]);
 
 
-	second_masked = pcf50633_irq_mask_get(rtc->pcf, PCF50633_IRQ_SECOND);
 	alarm_masked = pcf50633_irq_mask_get(rtc->pcf, PCF50633_IRQ_ALARM);
 
-	if (!second_masked)
-		pcf50633_irq_mask(rtc->pcf, PCF50633_IRQ_SECOND);
 	if (!alarm_masked)
 		pcf50633_irq_mask(rtc->pcf, PCF50633_IRQ_ALARM);
 
@@ -175,8 +171,6 @@ static int pcf50633_rtc_set_time(struct device *dev, struct rtc_time *tm)
 					     PCF50633_TI_EXTENT,
 					     &pcf_tm.time[0]);
 
-	if (!second_masked)
-		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_SECOND);
 	if (!alarm_masked)
 		pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_ALARM);
 
@@ -250,15 +244,8 @@ static void pcf50633_rtc_irq(int irq, void *data)
 {
 	struct pcf50633_rtc *rtc = data;
 
-	switch (irq) {
-	case PCF50633_IRQ_ALARM:
-		rtc_update_irq(rtc->rtc_dev, 1, RTC_AF | RTC_IRQF);
-		rtc->alarm_pending = 1;
-		break;
-	case PCF50633_IRQ_SECOND:
-		rtc_update_irq(rtc->rtc_dev, 1, RTC_UF | RTC_IRQF);
-		break;
-	}
+	rtc_update_irq(rtc->rtc_dev, 1, RTC_AF | RTC_IRQF);
+	rtc->alarm_pending = 1;
 }
 
 static int __devinit pcf50633_rtc_probe(struct platform_device *pdev)
@@ -282,9 +269,6 @@ static int __devinit pcf50633_rtc_probe(struct platform_device *pdev)
 
 	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_ALARM,
 					pcf50633_rtc_irq, rtc);
-	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_SECOND,
-					pcf50633_rtc_irq, rtc);
-
 	return 0;
 }
 
@@ -295,7 +279,6 @@ static int __devexit pcf50633_rtc_remove(struct platform_device *pdev)
 	rtc = platform_get_drvdata(pdev);
 
 	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_ALARM);
-	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_SECOND);
 
 	rtc_device_unregister(rtc->rtc_dev);
 	kfree(rtc);
-- 
1.7.2.5

