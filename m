Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1BUXz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:55:59 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58176 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1BUXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com
Subject: [PATCH 02/10] RTC: Cleanup rtc_class_ops->irq_set_freq()
Date: Mon, 21 Feb 2011 15:55:30 -0800
Message-Id: <1298332538-31216-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the generic rtc code now emulating PIE mode irqs via an
hrtimer, no one calls the rtc_class_ops->irq_set_freq call.

This patch removes the hook and deletes the driver functions
if no one else calls them.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-cmos.c    |   26 --------------------------
 drivers/rtc/rtc-davinci.c |   17 -----------------
 drivers/rtc/rtc-pl031.c   |   21 ---------------------
 drivers/rtc/rtc-pxa.c     |   15 ---------------
 drivers/rtc/rtc-s3c.c     |    1 -
 drivers/rtc/rtc-sa1100.c  |    1 -
 drivers/rtc/rtc-sh.c      |    1 -
 drivers/rtc/rtc-vr41xx.c  |   21 ---------------------
 include/linux/rtc.h       |    2 --
 9 files changed, 0 insertions(+), 105 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index de632e7..bdb1f8e 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -375,31 +375,6 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
-static int cmos_irq_set_freq(struct device *dev, int freq)
-{
-	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	int		f;
-	unsigned long	flags;
-
-	if (!is_valid_irq(cmos->irq))
-		return -ENXIO;
-
-	if (!is_power_of_2(freq))
-		return -EINVAL;
-	/* 0 = no irqs; 1 = 2^15 Hz ... 15 = 2^0 Hz */
-	f = ffs(freq);
-	if (f-- > 16)
-		return -EINVAL;
-	f = 16 - f;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	hpet_set_periodic_freq(freq);
-	CMOS_WRITE(RTC_REF_CLCK_32KHZ | f, RTC_FREQ_SELECT);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	return 0;
-}
-
 static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -482,7 +457,6 @@ static const struct rtc_class_ops cmos_rtc_ops = {
 	.read_alarm		= cmos_read_alarm,
 	.set_alarm		= cmos_set_alarm,
 	.proc			= cmos_procfs,
-	.irq_set_freq		= cmos_irq_set_freq,
 	.alarm_irq_enable	= cmos_alarm_irq_enable,
 	.update_irq_enable	= cmos_update_irq_enable,
 };
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 92da73d..dfd98a2 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -473,22 +473,6 @@ static int davinci_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	return 0;
 }
 
-static int davinci_rtc_irq_set_freq(struct device *dev, int freq)
-{
-	struct davinci_rtc *davinci_rtc = dev_get_drvdata(dev);
-	unsigned long flags;
-	u16 tmr_counter = (0x8000 >> (ffs(freq) - 1));
-
-	spin_lock_irqsave(&davinci_rtc_lock, flags);
-
-	rtcss_write(davinci_rtc, tmr_counter & 0xFF, PRTCSS_RTC_TMR0);
-	rtcss_write(davinci_rtc, (tmr_counter & 0xFF00) >> 8, PRTCSS_RTC_TMR1);
-
-	spin_unlock_irqrestore(&davinci_rtc_lock, flags);
-
-	return 0;
-}
-
 static struct rtc_class_ops davinci_rtc_ops = {
 	.ioctl			= davinci_rtc_ioctl,
 	.read_time		= davinci_rtc_read_time,
@@ -496,7 +480,6 @@ static struct rtc_class_ops davinci_rtc_ops = {
 	.alarm_irq_enable	= davinci_rtc_alarm_irq_enable,
 	.read_alarm		= davinci_rtc_read_alarm,
 	.set_alarm		= davinci_rtc_set_alarm,
-	.irq_set_freq		= davinci_rtc_irq_set_freq,
 };
 
 static int __init davinci_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 0e7c15b..d829ea6 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -293,25 +293,6 @@ static int pl031_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	return ret;
 }
 
-static int pl031_irq_set_freq(struct device *dev, int freq)
-{
-	struct pl031_local *ldata = dev_get_drvdata(dev);
-
-	/* Cant set timer if it is already enabled */
-	if (readl(ldata->base + RTC_TCR) & RTC_TCR_EN) {
-		dev_err(dev, "can't change frequency while timer enabled\n");
-		return -EINVAL;
-	}
-
-	/* If self start bit in RTC_TCR is set timer will start here,
-	 * but we never set that bit. Instead we start the timer when
-	 * set_state is called with enabled == 1.
-	 */
-	writel(RTC_TIMER_FREQ / freq, ldata->base + RTC_TLR);
-
-	return 0;
-}
-
 static int pl031_remove(struct amba_device *adev)
 {
 	struct pl031_local *ldata = dev_get_drvdata(&adev->dev);
@@ -408,7 +389,6 @@ static struct rtc_class_ops stv1_pl031_ops = {
 	.read_alarm = pl031_read_alarm,
 	.set_alarm = pl031_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
-	.irq_set_freq = pl031_irq_set_freq,
 };
 
 /* And the second ST derivative */
@@ -418,7 +398,6 @@ static struct rtc_class_ops stv2_pl031_ops = {
 	.read_alarm = pl031_stv2_read_alarm,
 	.set_alarm = pl031_stv2_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
-	.irq_set_freq = pl031_irq_set_freq,
 };
 
 static struct amba_id pl031_ids[] = {
diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index b216ae5..a1fdc80 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -209,20 +209,6 @@ static void pxa_rtc_release(struct device *dev)
 	free_irq(pxa_rtc->irq_1Hz, dev);
 }
 
-static int pxa_periodic_irq_set_freq(struct device *dev, int freq)
-{
-	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
-	int period_ms;
-
-	if (freq < 1 || freq > MAXFREQ_PERIODIC)
-		return -EINVAL;
-
-	period_ms = 1000 / freq;
-	rtc_writel(pxa_rtc, PIAR, period_ms);
-
-	return 0;
-}
-
 static int pxa_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
@@ -336,7 +322,6 @@ static const struct rtc_class_ops pxa_rtc_ops = {
 	.alarm_irq_enable = pxa_alarm_irq_enable,
 	.update_irq_enable = pxa_update_irq_enable,
 	.proc = pxa_rtc_proc,
-	.irq_set_freq = pxa_periodic_irq_set_freq,
 };
 
 static int __init pxa_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 1dd2678..6d60958 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -346,7 +346,6 @@ static const struct rtc_class_ops s3c_rtcops = {
 	.set_time	= s3c_rtc_settime,
 	.read_alarm	= s3c_rtc_getalarm,
 	.set_alarm	= s3c_rtc_setalarm,
-	.irq_set_freq	= s3c_rtc_setfreq,
 	.proc		= s3c_rtc_proc,
 	.alarm_irq_enable = s3c_rtc_setaie,
 };
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index d47b3fc..d1a2b0b 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -392,7 +392,6 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 	.read_alarm = sa1100_rtc_read_alarm,
 	.set_alarm = sa1100_rtc_set_alarm,
 	.proc = sa1100_rtc_proc,
-	.irq_set_freq = sa1100_irq_set_freq,
 	.alarm_irq_enable = sa1100_rtc_alarm_irq_enable,
 };
 
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index ff50a8b..1485449 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -603,7 +603,6 @@ static struct rtc_class_ops sh_rtc_ops = {
 	.set_time	= sh_rtc_set_time,
 	.read_alarm	= sh_rtc_read_alarm,
 	.set_alarm	= sh_rtc_set_alarm,
-	.irq_set_freq	= sh_rtc_irq_set_freq,
 	.proc		= sh_rtc_proc,
 	.alarm_irq_enable = sh_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 86f1490..c5698cd 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -207,26 +207,6 @@ static int vr41xx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	return 0;
 }
 
-static int vr41xx_rtc_irq_set_freq(struct device *dev, int freq)
-{
-	u64 count;
-
-	if (!is_power_of_2(freq))
-		return -EINVAL;
-	count = RTC_FREQUENCY;
-	do_div(count, freq);
-
-	spin_lock_irq(&rtc_lock);
-
-	periodic_count = count;
-	rtc1_write(RTCL1LREG, periodic_count);
-	rtc1_write(RTCL1HREG, periodic_count >> 16);
-
-	spin_unlock_irq(&rtc_lock);
-
-	return 0;
-}
-
 static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -298,7 +278,6 @@ static const struct rtc_class_ops vr41xx_rtc_ops = {
 	.set_time	= vr41xx_rtc_set_time,
 	.read_alarm	= vr41xx_rtc_read_alarm,
 	.set_alarm	= vr41xx_rtc_set_alarm,
-	.irq_set_freq	= vr41xx_rtc_irq_set_freq,
 };
 
 static int __devinit rtc_probe(struct platform_device *pdev)
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 40bbe77..5eb9650 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -133,7 +133,6 @@ extern struct class *rtc_class;
  * The (current) exceptions are mostly filesystem hooks:
  *   - the proc() hook for procfs
  *   - non-ioctl() chardev hooks:  open(), release(), read_callback()
- *   - periodic irq calls:  irq_set_state(), irq_set_freq()
  *
  * REVISIT those periodic irq calls *do* have ops_lock when they're
  * issued through ioctl() ...
@@ -148,7 +147,6 @@ struct rtc_class_ops {
 	int (*set_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*proc)(struct device *, struct seq_file *);
 	int (*set_mmss)(struct device *, unsigned long secs);
-	int (*irq_set_freq)(struct device *, int freq);
 	int (*read_callback)(struct device *, int data);
 	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
 	int (*update_irq_enable)(struct device *, unsigned int enabled);
-- 
1.7.3.2.146.gca209

