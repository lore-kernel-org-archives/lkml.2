Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab1BUX4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:56:11 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36667 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab1BUX4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:56:08 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com
Subject: [PATCH 01/10] RTC: Cleanup rtc_class_ops->irq_set_state
Date: Mon, 21 Feb 2011 15:55:29 -0800
Message-Id: <1298332538-31216-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With PIE mode interrupts now emulated in generic code via an hrtimer,
no one calls rtc_class_ops->irq_set_state(), so this patch removes it
along with driver implementations.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-cmos.c    |   20 --------------------
 drivers/rtc/rtc-davinci.c |   34 ----------------------------------
 drivers/rtc/rtc-mrst.c    |   20 --------------------
 drivers/rtc/rtc-pl031.c   |   34 ----------------------------------
 drivers/rtc/rtc-pxa.c     |   13 -------------
 drivers/rtc/rtc-rx8025.c  |   25 -------------------------
 drivers/rtc/rtc-s3c.c     |   32 --------------------------------
 drivers/rtc/rtc-sa1100.c  |   18 ------------------
 drivers/rtc/rtc-sh.c      |    1 -
 drivers/rtc/rtc-vr41xx.c  |   11 -----------
 include/linux/rtc.h       |    1 -
 11 files changed, 0 insertions(+), 209 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index c7ff8df..de632e7 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -400,25 +400,6 @@ static int cmos_irq_set_freq(struct device *dev, int freq)
 	return 0;
 }
 
-static int cmos_irq_set_state(struct device *dev, int enabled)
-{
-	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned long	flags;
-
-	if (!is_valid_irq(cmos->irq))
-		return -ENXIO;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-
-	if (enabled)
-		cmos_irq_enable(cmos, RTC_PIE);
-	else
-		cmos_irq_disable(cmos, RTC_PIE);
-
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return 0;
-}
-
 static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -502,7 +483,6 @@ static const struct rtc_class_ops cmos_rtc_ops = {
 	.set_alarm		= cmos_set_alarm,
 	.proc			= cmos_procfs,
 	.irq_set_freq		= cmos_irq_set_freq,
-	.irq_set_state		= cmos_irq_set_state,
 	.alarm_irq_enable	= cmos_alarm_irq_enable,
 	.update_irq_enable	= cmos_update_irq_enable,
 };
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 34647fc..92da73d 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -473,39 +473,6 @@ static int davinci_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	return 0;
 }
 
-static int davinci_rtc_irq_set_state(struct device *dev, int enabled)
-{
-	struct davinci_rtc *davinci_rtc = dev_get_drvdata(dev);
-	unsigned long flags;
-	u8 rtc_ctrl;
-
-	spin_lock_irqsave(&davinci_rtc_lock, flags);
-
-	rtc_ctrl = rtcss_read(davinci_rtc, PRTCSS_RTC_CTRL);
-
-	if (enabled) {
-		while (rtcss_read(davinci_rtc, PRTCSS_RTC_CTRL)
-		       & PRTCSS_RTC_CTRL_WDTBUS)
-			cpu_relax();
-
-		rtc_ctrl |= PRTCSS_RTC_CTRL_TE;
-		rtcss_write(davinci_rtc, rtc_ctrl, PRTCSS_RTC_CTRL);
-
-		rtcss_write(davinci_rtc, 0x0, PRTCSS_RTC_CLKC_CNT);
-
-		rtc_ctrl |= PRTCSS_RTC_CTRL_TIEN |
-			    PRTCSS_RTC_CTRL_TMMD |
-			    PRTCSS_RTC_CTRL_TMRFLG;
-	} else
-		rtc_ctrl &= ~PRTCSS_RTC_CTRL_TIEN;
-
-	rtcss_write(davinci_rtc, rtc_ctrl, PRTCSS_RTC_CTRL);
-
-	spin_unlock_irqrestore(&davinci_rtc_lock, flags);
-
-	return 0;
-}
-
 static int davinci_rtc_irq_set_freq(struct device *dev, int freq)
 {
 	struct davinci_rtc *davinci_rtc = dev_get_drvdata(dev);
@@ -529,7 +496,6 @@ static struct rtc_class_ops davinci_rtc_ops = {
 	.alarm_irq_enable	= davinci_rtc_alarm_irq_enable,
 	.read_alarm		= davinci_rtc_read_alarm,
 	.set_alarm		= davinci_rtc_set_alarm,
-	.irq_set_state		= davinci_rtc_irq_set_state,
 	.irq_set_freq		= davinci_rtc_irq_set_freq,
 };
 
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 1db62db..4db96fa 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -236,25 +236,6 @@ static int mrst_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
-static int mrst_irq_set_state(struct device *dev, int enabled)
-{
-	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
-	unsigned long	flags;
-
-	if (!mrst->irq)
-		return -ENXIO;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-
-	if (enabled)
-		mrst_irq_enable(mrst, RTC_PIE);
-	else
-		mrst_irq_disable(mrst, RTC_PIE);
-
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return 0;
-}
-
 /* Currently, the vRTC doesn't support UIE ON/OFF */
 static int mrst_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
@@ -301,7 +282,6 @@ static const struct rtc_class_ops mrst_rtc_ops = {
 	.read_alarm	= mrst_read_alarm,
 	.set_alarm	= mrst_set_alarm,
 	.proc		= mrst_procfs,
-	.irq_set_state	= mrst_irq_set_state,
 	.alarm_irq_enable = mrst_rtc_alarm_irq_enable,
 };
 
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index b7a6690..0e7c15b 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -293,38 +293,6 @@ static int pl031_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	return ret;
 }
 
-/* Periodic interrupt is only available in ST variants. */
-static int pl031_irq_set_state(struct device *dev, int enabled)
-{
-	struct pl031_local *ldata = dev_get_drvdata(dev);
-
-	if (enabled == 1) {
-		/* Clear any pending timer interrupt. */
-		writel(RTC_BIT_PI, ldata->base + RTC_ICR);
-
-		writel(readl(ldata->base + RTC_IMSC) | RTC_BIT_PI,
-			ldata->base + RTC_IMSC);
-
-		/* Now start the timer */
-		writel(readl(ldata->base + RTC_TCR) | RTC_TCR_EN,
-			ldata->base + RTC_TCR);
-
-	} else {
-		writel(readl(ldata->base + RTC_IMSC) & (~RTC_BIT_PI),
-			ldata->base + RTC_IMSC);
-
-		/* Also stop the timer */
-		writel(readl(ldata->base + RTC_TCR) & (~RTC_TCR_EN),
-			ldata->base + RTC_TCR);
-	}
-	/* Wait at least 1 RTC32 clock cycle to ensure next access
-	 * to RTC_TCR will succeed.
-	 */
-	udelay(40);
-
-	return 0;
-}
-
 static int pl031_irq_set_freq(struct device *dev, int freq)
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
@@ -440,7 +408,6 @@ static struct rtc_class_ops stv1_pl031_ops = {
 	.read_alarm = pl031_read_alarm,
 	.set_alarm = pl031_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
-	.irq_set_state = pl031_irq_set_state,
 	.irq_set_freq = pl031_irq_set_freq,
 };
 
@@ -451,7 +418,6 @@ static struct rtc_class_ops stv2_pl031_ops = {
 	.read_alarm = pl031_stv2_read_alarm,
 	.set_alarm = pl031_stv2_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
-	.irq_set_state = pl031_irq_set_state,
 	.irq_set_freq = pl031_irq_set_freq,
 };
 
diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index 29e867a..b216ae5 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -223,18 +223,6 @@ static int pxa_periodic_irq_set_freq(struct device *dev, int freq)
 	return 0;
 }
 
-static int pxa_periodic_irq_set_state(struct device *dev, int enabled)
-{
-	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
-
-	if (enabled)
-		rtsr_set_bits(pxa_rtc, RTSR_PIALE | RTSR_PICE);
-	else
-		rtsr_clear_bits(pxa_rtc, RTSR_PIALE | RTSR_PICE);
-
-	return 0;
-}
-
 static int pxa_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
@@ -348,7 +336,6 @@ static const struct rtc_class_ops pxa_rtc_ops = {
 	.alarm_irq_enable = pxa_alarm_irq_enable,
 	.update_irq_enable = pxa_update_irq_enable,
 	.proc = pxa_rtc_proc,
-	.irq_set_state = pxa_periodic_irq_set_state,
 	.irq_set_freq = pxa_periodic_irq_set_freq,
 };
 
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index af32a62..fde172f 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -424,37 +424,12 @@ static int rx8025_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int rx8025_irq_set_state(struct device *dev, int enabled)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct rx8025_data *rx8025 = i2c_get_clientdata(client);
-	int ctrl1;
-	int err;
-
-	if (client->irq <= 0)
-		return -ENXIO;
-
-	ctrl1 = rx8025->ctrl1 & ~RX8025_BIT_CTRL1_CT;
-	if (enabled)
-		ctrl1 |= RX8025_BIT_CTRL1_CT_1HZ;
-	if (ctrl1 != rx8025->ctrl1) {
-		rx8025->ctrl1 = ctrl1;
-		err = rx8025_write_reg(rx8025->client, RX8025_REG_CTRL1,
-				       rx8025->ctrl1);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 static struct rtc_class_ops rx8025_rtc_ops = {
 	.read_time = rx8025_get_time,
 	.set_time = rx8025_set_time,
 	.read_alarm = rx8025_read_alarm,
 	.set_alarm = rx8025_set_alarm,
 	.alarm_irq_enable = rx8025_alarm_irq_enable,
-	.irq_set_state  = rx8025_irq_set_state,
 };
 
 /*
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index cf953ec..1dd2678 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -91,37 +91,6 @@ static void s3c_rtc_setaie(int to)
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
 }
 
-static int s3c_rtc_setpie(struct device *dev, int enabled)
-{
-	unsigned int tmp;
-
-	pr_debug("%s: pie=%d\n", __func__, enabled);
-
-	spin_lock_irq(&s3c_rtc_pie_lock);
-
-	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
-		tmp = readw(s3c_rtc_base + S3C2410_RTCCON);
-		tmp &= ~S3C64XX_RTCCON_TICEN;
-
-		if (enabled)
-			tmp |= S3C64XX_RTCCON_TICEN;
-
-		writew(tmp, s3c_rtc_base + S3C2410_RTCCON);
-	} else {
-		tmp = readb(s3c_rtc_base + S3C2410_TICNT);
-		tmp &= ~S3C2410_TICNT_ENABLE;
-
-		if (enabled)
-			tmp |= S3C2410_TICNT_ENABLE;
-
-		writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
-	}
-
-	spin_unlock_irq(&s3c_rtc_pie_lock);
-
-	return 0;
-}
-
 static int s3c_rtc_setfreq(struct device *dev, int freq)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -378,7 +347,6 @@ static const struct rtc_class_ops s3c_rtcops = {
 	.read_alarm	= s3c_rtc_getalarm,
 	.set_alarm	= s3c_rtc_setalarm,
 	.irq_set_freq	= s3c_rtc_setfreq,
-	.irq_set_state	= s3c_rtc_setpie,
 	.proc		= s3c_rtc_proc,
 	.alarm_irq_enable = s3c_rtc_setaie,
 };
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 5dfe5ff..d47b3fc 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -171,23 +171,6 @@ static int sa1100_irq_set_freq(struct device *dev, int freq)
 
 static int rtc_timer1_count;
 
-static int sa1100_irq_set_state(struct device *dev, int enabled)
-{
-	spin_lock_irq(&sa1100_rtc_lock);
-	if (enabled) {
-		struct rtc_device *rtc = (struct rtc_device *)dev;
-
-		OSMR1 = timer_freq / rtc->irq_freq + OSCR;
-		OIER |= OIER_E1;
-		rtc_timer1_count = 1;
-	} else {
-		OIER &= ~OIER_E1;
-	}
-	spin_unlock_irq(&sa1100_rtc_lock);
-
-	return 0;
-}
-
 static inline int sa1100_timer1_retrigger(struct rtc_device *rtc)
 {
 	unsigned long diff;
@@ -410,7 +393,6 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 	.set_alarm = sa1100_rtc_set_alarm,
 	.proc = sa1100_rtc_proc,
 	.irq_set_freq = sa1100_irq_set_freq,
-	.irq_set_state = sa1100_irq_set_state,
 	.alarm_irq_enable = sa1100_rtc_alarm_irq_enable,
 };
 
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 93314a9..ff50a8b 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -603,7 +603,6 @@ static struct rtc_class_ops sh_rtc_ops = {
 	.set_time	= sh_rtc_set_time,
 	.read_alarm	= sh_rtc_read_alarm,
 	.set_alarm	= sh_rtc_set_alarm,
-	.irq_set_state	= sh_rtc_irq_set_state,
 	.irq_set_freq	= sh_rtc_irq_set_freq,
 	.proc		= sh_rtc_proc,
 	.alarm_irq_enable = sh_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 769190a..86f1490 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -227,16 +227,6 @@ static int vr41xx_rtc_irq_set_freq(struct device *dev, int freq)
 	return 0;
 }
 
-static int vr41xx_rtc_irq_set_state(struct device *dev, int enabled)
-{
-	if (enabled)
-		enable_irq(pie_irq);
-	else
-		disable_irq(pie_irq);
-
-	return 0;
-}
-
 static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -309,7 +299,6 @@ static const struct rtc_class_ops vr41xx_rtc_ops = {
 	.read_alarm	= vr41xx_rtc_read_alarm,
 	.set_alarm	= vr41xx_rtc_set_alarm,
 	.irq_set_freq	= vr41xx_rtc_irq_set_freq,
-	.irq_set_state	= vr41xx_rtc_irq_set_state,
 };
 
 static int __devinit rtc_probe(struct platform_device *pdev)
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 89c3e51..40bbe77 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -148,7 +148,6 @@ struct rtc_class_ops {
 	int (*set_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*proc)(struct device *, struct seq_file *);
 	int (*set_mmss)(struct device *, unsigned long secs);
-	int (*irq_set_state)(struct device *, int enabled);
 	int (*irq_set_freq)(struct device *, int freq);
 	int (*read_callback)(struct device *, int data);
 	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
-- 
1.7.3.2.146.gca209

