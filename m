Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1FOInZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:43:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9513 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1FOInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:43:22 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-9d-4df870a87927
Date: Wed, 15 Jun 2011 17:42:51 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH][RESEND] rtc: rtc-s3c: Update RTC driver for supporting clock
 gating
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org, ben-linux@fluff.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com
Message-id: <1308127371-12926-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 15 Jun 2011 08:43:12.0823 (UTC)
 FILETIME=[42F22470:01CC2B38]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports clock gating.
Power consumption can be reduced by
setting rtc_clk disabled state except for when RTC related registers are accessed.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>

Resend to fix clock usage counter related error in s3c_rtc_remove function.
---
 drivers/rtc/rtc-s3c.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 16512ec..53c99b1 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -57,11 +57,13 @@ static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
 {
 	struct rtc_device *rdev = id;
 
+	clk_enable(rtc_clk);
 	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 		writeb(S3C2410_INTP_ALM, s3c_rtc_base + S3C2410_INTP);
 
+	clk_disable(rtc_clk);
 	return IRQ_HANDLED;
 }
 
@@ -69,11 +71,13 @@ static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
 {
 	struct rtc_device *rdev = id;
 
+	clk_enable(rtc_clk);
 	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 		writeb(S3C2410_INTP_TIC, s3c_rtc_base + S3C2410_INTP);
 
+	clk_disable(rtc_clk);
 	return IRQ_HANDLED;
 }
 
@@ -84,12 +88,14 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 
 	pr_debug("%s: aie=%d\n", __func__, enabled);
 
+	clk_enable(rtc_clk);
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
 	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -103,6 +109,7 @@ static int s3c_rtc_setfreq(struct device *dev, int freq)
 	if (!is_power_of_2(freq))
 		return -EINVAL;
 
+	clk_enable(rtc_clk);
 	spin_lock_irq(&s3c_rtc_pie_lock);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C2410) {
@@ -114,6 +121,7 @@ static int s3c_rtc_setfreq(struct device *dev, int freq)
 
 	writel(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -125,6 +133,7 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	unsigned int have_retried = 0;
 	void __iomem *base = s3c_rtc_base;
 
+	clk_enable(rtc_clk);
  retry_get_time:
 	rtc_tm->tm_min  = readb(base + S3C2410_RTCMIN);
 	rtc_tm->tm_hour = readb(base + S3C2410_RTCHOUR);
@@ -157,6 +166,7 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	rtc_tm->tm_year += 100;
 	rtc_tm->tm_mon -= 1;
 
+	clk_disable(rtc_clk);
 	return rtc_valid_tm(rtc_tm);
 }
 
@@ -165,6 +175,7 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
+	clk_enable(rtc_clk);
 	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -182,6 +193,7 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	writeb(bin2bcd(tm->tm_mday), base + S3C2410_RTCDATE);
 	writeb(bin2bcd(tm->tm_mon + 1), base + S3C2410_RTCMON);
 	writeb(bin2bcd(year), base + S3C2410_RTCYEAR);
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -192,6 +204,7 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	void __iomem *base = s3c_rtc_base;
 	unsigned int alm_en;
 
+	clk_enable(rtc_clk);
 	alm_tm->tm_sec  = readb(base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(base + S3C2410_ALMMIN);
 	alm_tm->tm_hour = readb(base + S3C2410_ALMHOUR);
@@ -243,6 +256,7 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	else
 		alm_tm->tm_year = -1;
 
+	clk_disable(rtc_clk);
 	return 0;
 }
 
@@ -252,6 +266,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	void __iomem *base = s3c_rtc_base;
 	unsigned int alrm_en;
 
+	clk_enable(rtc_clk);
 	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
@@ -282,6 +297,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	s3c_rtc_setaie(dev, alrm->enabled);
 
+	clk_disable(rtc_clk);
 	return 0;
 }
 
@@ -289,6 +305,7 @@ static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	unsigned int ticnt;
 
+	clk_enable(rtc_clk);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
 		ticnt = readw(s3c_rtc_base + S3C2410_RTCCON);
 		ticnt &= S3C64XX_RTCCON_TICEN;
@@ -298,6 +315,7 @@ static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 	}
 
 	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
+	clk_disable(rtc_clk);
 	return 0;
 }
 
@@ -360,6 +378,7 @@ static void s3c_rtc_enable(struct platform_device *pdev, int en)
 	if (s3c_rtc_base == NULL)
 		return;
 
+	clk_enable(rtc_clk);
 	if (!en) {
 		tmp = readw(base + S3C2410_RTCCON);
 		if (s3c_rtc_cpu_type == TYPE_S3C64XX)
@@ -399,6 +418,7 @@ static void s3c_rtc_enable(struct platform_device *pdev, int en)
 				base + S3C2410_RTCCON);
 		}
 	}
+	clk_disable(rtc_clk);
 }
 
 static int __devexit s3c_rtc_remove(struct platform_device *dev)
@@ -410,7 +430,6 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
-	clk_disable(rtc_clk);
 	clk_put(rtc_clk);
 	rtc_clk = NULL;
 
@@ -530,6 +549,8 @@ static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
+	clk_disable(rtc_clk);
+
 	return 0;
 
  err_nortc:
@@ -555,6 +576,7 @@ static int ticnt_save, ticnt_en_save;
 
 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
+	clk_enable(rtc_clk);
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
@@ -569,6 +591,7 @@ static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 		else
 			dev_err(&pdev->dev, "enable_irq_wake failed\n");
 	}
+	clk_disable(rtc_clk);
 
 	return 0;
 }
@@ -577,6 +600,7 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 {
 	unsigned int tmp;
 
+	clk_enable(rtc_clk);
 	s3c_rtc_enable(pdev, 1);
 	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX && ticnt_en_save) {
@@ -588,6 +612,7 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 		disable_irq_wake(s3c_rtc_alarmno);
 		wake_en = false;
 	}
+	clk_disable(rtc_clk);
 
 	return 0;
 }
-- 
1.7.4.1

