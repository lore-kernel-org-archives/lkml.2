Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1BUX4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:56:00 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51746 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab1BUXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com
Subject: [PATCH 03/10] RTC: Cleanup rtc_class_ops->update_irq_enable()
Date: Mon, 21 Feb 2011 15:55:31 -0800
Message-Id: <1298332538-31216-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the generic code handles UIE mode irqs via periodic
alarm interrupts, no one calls the
rtc_class_ops->update_irq_enable() method anymore.

This patch removes the driver hooks and implementations of
update_irq_enable if no one else is calling it.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-cmos.c     |   20 --------------------
 drivers/rtc/rtc-ds1511.c   |   17 -----------------
 drivers/rtc/rtc-ds1553.c   |   17 -----------------
 drivers/rtc/rtc-ds3232.c   |   18 ------------------
 drivers/rtc/rtc-jz4740.c   |    7 -------
 drivers/rtc/rtc-mc13xxx.c  |    7 -------
 drivers/rtc/rtc-mpc5121.c  |   20 --------------------
 drivers/rtc/rtc-mxc.c      |    7 -------
 drivers/rtc/rtc-nuc900.c   |   15 ---------------
 drivers/rtc/rtc-pcap.c     |    6 ------
 drivers/rtc/rtc-pcf50633.c |   22 +---------------------
 drivers/rtc/rtc-pxa.c      |   16 ----------------
 drivers/rtc/rtc-stmp3xxx.c |   15 ---------------
 drivers/rtc/rtc-twl.c      |   13 -------------
 drivers/rtc/rtc-wm831x.c   |   16 ----------------
 drivers/rtc/rtc-wm8350.c   |   21 ---------------------
 include/linux/rtc.h        |    1 -
 17 files changed, 1 insertions(+), 237 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index bdb1f8e..dc2a0ba 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -394,25 +394,6 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int cmos_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned long	flags;
-
-	if (!is_valid_irq(cmos->irq))
-		return -EINVAL;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-
-	if (enabled)
-		cmos_irq_enable(cmos, RTC_UIE);
-	else
-		cmos_irq_disable(cmos, RTC_UIE);
-
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return 0;
-}
-
 #if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
 
 static int cmos_procfs(struct device *dev, struct seq_file *seq)
@@ -458,7 +439,6 @@ static const struct rtc_class_ops cmos_rtc_ops = {
 	.set_alarm		= cmos_set_alarm,
 	.proc			= cmos_procfs,
 	.alarm_irq_enable	= cmos_alarm_irq_enable,
-	.update_irq_enable	= cmos_update_irq_enable,
 };
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 37268e9..3fffd70 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -397,29 +397,12 @@ static int ds1511_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int ds1511_rtc_update_irq_enable(struct device *dev,
-	unsigned int enabled)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq <= 0)
-		return -EINVAL;
-	if (enabled)
-		pdata->irqen |= RTC_UF;
-	else
-		pdata->irqen &= ~RTC_UF;
-	ds1511_rtc_update_alarm(pdata);
-	return 0;
-}
-
 static const struct rtc_class_ops ds1511_rtc_ops = {
 	.read_time		= ds1511_rtc_read_time,
 	.set_time		= ds1511_rtc_set_time,
 	.read_alarm		= ds1511_rtc_read_alarm,
 	.set_alarm		= ds1511_rtc_set_alarm,
 	.alarm_irq_enable	= ds1511_rtc_alarm_irq_enable,
-	.update_irq_enable	= ds1511_rtc_update_irq_enable,
 };
 
  static ssize_t
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index ff432e2..fee41b9 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -227,29 +227,12 @@ static int ds1553_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int ds1553_rtc_update_irq_enable(struct device *dev,
-	unsigned int enabled)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq <= 0)
-		return -EINVAL;
-	if (enabled)
-		pdata->irqen |= RTC_UF;
-	else
-		pdata->irqen &= ~RTC_UF;
-	ds1553_rtc_update_alarm(pdata);
-	return 0;
-}
-
 static const struct rtc_class_ops ds1553_rtc_ops = {
 	.read_time		= ds1553_rtc_read_time,
 	.set_time		= ds1553_rtc_set_time,
 	.read_alarm		= ds1553_rtc_read_alarm,
 	.set_alarm		= ds1553_rtc_set_alarm,
 	.alarm_irq_enable	= ds1553_rtc_alarm_irq_enable,
-	.update_irq_enable	= ds1553_rtc_update_irq_enable,
 };
 
 static ssize_t ds1553_nvram_read(struct file *filp, struct kobject *kobj,
diff --git a/drivers/rtc/rtc-ds3232.c b/drivers/rtc/rtc-ds3232.c
index 23a9ee1..7608b1b 100644
--- a/drivers/rtc/rtc-ds3232.c
+++ b/drivers/rtc/rtc-ds3232.c
@@ -335,23 +335,6 @@ static int ds3232_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int ds3232_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds3232 *ds3232 = i2c_get_clientdata(client);
-
-	if (client->irq <= 0)
-		return -EINVAL;
-
-	if (enabled)
-		ds3232->rtc->irq_data |= RTC_UF;
-	else
-		ds3232->rtc->irq_data &= ~RTC_UF;
-
-	ds3232_update_alarm(client);
-	return 0;
-}
-
 static irqreturn_t ds3232_irq(int irq, void *dev_id)
 {
 	struct i2c_client *client = dev_id;
@@ -402,7 +385,6 @@ static const struct rtc_class_ops ds3232_rtc_ops = {
 	.read_alarm = ds3232_read_alarm,
 	.set_alarm = ds3232_set_alarm,
 	.alarm_irq_enable = ds3232_alarm_irq_enable,
-	.update_irq_enable = ds3232_update_irq_enable,
 };
 
 static int __devinit ds3232_probe(struct i2c_client *client,
diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 2e16f72..b647363 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -168,12 +168,6 @@ static int jz4740_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return ret;
 }
 
-static int jz4740_rtc_update_irq_enable(struct device *dev, unsigned int enable)
-{
-	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
-	return jz4740_rtc_ctrl_set_bits(rtc, JZ_RTC_CTRL_1HZ_IRQ, enable);
-}
-
 static int jz4740_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 {
 	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
@@ -185,7 +179,6 @@ static struct rtc_class_ops jz4740_rtc_ops = {
 	.set_mmss	= jz4740_rtc_set_mmss,
 	.read_alarm	= jz4740_rtc_read_alarm,
 	.set_alarm	= jz4740_rtc_set_alarm,
-	.update_irq_enable = jz4740_rtc_update_irq_enable,
 	.alarm_irq_enable = jz4740_rtc_alarm_irq_enable,
 };
 
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 5314b15..c420064 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -282,12 +282,6 @@ static irqreturn_t mc13xxx_rtc_update_handler(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int mc13xxx_rtc_update_irq_enable(struct device *dev,
-		unsigned int enabled)
-{
-	return mc13xxx_rtc_irq_enable(dev, enabled, MC13XXX_IRQ_1HZ);
-}
-
 static int mc13xxx_rtc_alarm_irq_enable(struct device *dev,
 		unsigned int enabled)
 {
@@ -300,7 +294,6 @@ static const struct rtc_class_ops mc13xxx_rtc_ops = {
 	.read_alarm = mc13xxx_rtc_read_alarm,
 	.set_alarm = mc13xxx_rtc_set_alarm,
 	.alarm_irq_enable = mc13xxx_rtc_alarm_irq_enable,
-	.update_irq_enable = mc13xxx_rtc_update_irq_enable,
 };
 
 static irqreturn_t mc13xxx_rtc_reset_handler(int irq, void *dev)
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index dfcdf09..b40c1ff 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -240,32 +240,12 @@ static int mpc5121_rtc_alarm_irq_enable(struct device *dev,
 	return 0;
 }
 
-static int mpc5121_rtc_update_irq_enable(struct device *dev,
-					 unsigned int enabled)
-{
-	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
-	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
-	int val;
-
-	val = in_8(&regs->int_enable);
-
-	if (enabled)
-		val = (val & ~0x8) | 0x1;
-	else
-		val &= ~0x1;
-
-	out_8(&regs->int_enable, val);
-
-	return 0;
-}
-
 static const struct rtc_class_ops mpc5121_rtc_ops = {
 	.read_time = mpc5121_rtc_read_time,
 	.set_time = mpc5121_rtc_set_time,
 	.read_alarm = mpc5121_rtc_read_alarm,
 	.set_alarm = mpc5121_rtc_set_alarm,
 	.alarm_irq_enable = mpc5121_rtc_alarm_irq_enable,
-	.update_irq_enable = mpc5121_rtc_update_irq_enable,
 };
 
 static int __devinit mpc5121_rtc_probe(struct platform_device *op,
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 0b06c1e..826ab64 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -274,12 +274,6 @@ static int mxc_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int mxc_rtc_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	mxc_rtc_irq_enable(dev, RTC_1HZ_BIT, enabled);
-	return 0;
-}
-
 /*
  * This function reads the current RTC time into tm in Gregorian date.
  */
@@ -368,7 +362,6 @@ static struct rtc_class_ops mxc_rtc_ops = {
 	.read_alarm		= mxc_rtc_read_alarm,
 	.set_alarm		= mxc_rtc_set_alarm,
 	.alarm_irq_enable	= mxc_rtc_alarm_irq_enable,
-	.update_irq_enable	= mxc_rtc_update_irq_enable,
 };
 
 static int __init mxc_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index ddb0857..781068d 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -134,20 +134,6 @@ static void nuc900_rtc_bin2bcd(struct device *dev, struct rtc_time *settm,
 	gettm->bcd_hour = bin2bcd(settm->tm_hour) << 16;
 }
 
-static int nuc900_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
-
-	if (enabled)
-		__raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)|
-				(TICKINTENB), rtc->rtc_reg + REG_RTC_RIER);
-	else
-		__raw_writel(__raw_readl(rtc->rtc_reg + REG_RTC_RIER)&
-				(~TICKINTENB), rtc->rtc_reg + REG_RTC_RIER);
-
-	return 0;
-}
-
 static int nuc900_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
@@ -234,7 +220,6 @@ static struct rtc_class_ops nuc900_rtc_ops = {
 	.read_alarm = nuc900_rtc_read_alarm,
 	.set_alarm = nuc900_rtc_set_alarm,
 	.alarm_irq_enable = nuc900_alarm_irq_enable,
-	.update_irq_enable = nuc900_update_irq_enable,
 };
 
 static int __devinit nuc900_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index 25c0b3f..a633abc 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -131,18 +131,12 @@ static int pcap_rtc_alarm_irq_enable(struct device *dev, unsigned int en)
 	return pcap_rtc_irq_enable(dev, PCAP_IRQ_TODA, en);
 }
 
-static int pcap_rtc_update_irq_enable(struct device *dev, unsigned int en)
-{
-	return pcap_rtc_irq_enable(dev, PCAP_IRQ_1HZ, en);
-}
-
 static const struct rtc_class_ops pcap_rtc_ops = {
 	.read_time = pcap_rtc_read_time,
 	.read_alarm = pcap_rtc_read_alarm,
 	.set_alarm = pcap_rtc_set_alarm,
 	.set_mmss = pcap_rtc_set_mmss,
 	.alarm_irq_enable = pcap_rtc_alarm_irq_enable,
-	.update_irq_enable = pcap_rtc_update_irq_enable,
 };
 
 static int __devinit pcap_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index 16edf94..f90c574 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -106,25 +106,6 @@ pcf50633_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int
-pcf50633_rtc_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct pcf50633_rtc *rtc = dev_get_drvdata(dev);
-	int err;
-
-	if (enabled)
-		err = pcf50633_irq_unmask(rtc->pcf, PCF50633_IRQ_SECOND);
-	else
-		err = pcf50633_irq_mask(rtc->pcf, PCF50633_IRQ_SECOND);
-
-	if (err < 0)
-		return err;
-
-	rtc->second_enabled = enabled;
-
-	return 0;
-}
-
 static int pcf50633_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct pcf50633_rtc *rtc;
@@ -262,8 +243,7 @@ static struct rtc_class_ops pcf50633_rtc_ops = {
 	.set_time		= pcf50633_rtc_set_time,
 	.read_alarm		= pcf50633_rtc_read_alarm,
 	.set_alarm		= pcf50633_rtc_set_alarm,
-	.alarm_irq_enable 	= pcf50633_rtc_alarm_irq_enable,
-	.update_irq_enable 	= pcf50633_rtc_update_irq_enable,
+	.alarm_irq_enable	= pcf50633_rtc_alarm_irq_enable,
 };
 
 static void pcf50633_rtc_irq(int irq, void *data)
diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index a1fdc80..fc9f499 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -224,21 +224,6 @@ static int pxa_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int pxa_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
-
-	spin_lock_irq(&pxa_rtc->lock);
-
-	if (enabled)
-		rtsr_set_bits(pxa_rtc, RTSR_HZE);
-	else
-		rtsr_clear_bits(pxa_rtc, RTSR_HZE);
-
-	spin_unlock_irq(&pxa_rtc->lock);
-	return 0;
-}
-
 static int pxa_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
@@ -320,7 +305,6 @@ static const struct rtc_class_ops pxa_rtc_ops = {
 	.read_alarm = pxa_rtc_read_alarm,
 	.set_alarm = pxa_rtc_set_alarm,
 	.alarm_irq_enable = pxa_alarm_irq_enable,
-	.update_irq_enable = pxa_update_irq_enable,
 	.proc = pxa_rtc_proc,
 };
 
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 7e7d0c8..572e953 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -115,19 +115,6 @@ static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int stmp3xxx_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
-
-	if (enabled)
-		stmp3xxx_setl(BM_RTC_CTRL_ONEMSEC_IRQ_EN,
-				rtc_data->io + HW_RTC_CTRL);
-	else
-		stmp3xxx_clearl(BM_RTC_CTRL_ONEMSEC_IRQ_EN,
-				rtc_data->io + HW_RTC_CTRL);
-	return 0;
-}
-
 static int stmp3xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
@@ -149,8 +136,6 @@ static int stmp3xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 static struct rtc_class_ops stmp3xxx_rtc_ops = {
 	.alarm_irq_enable =
 			  stmp3xxx_alarm_irq_enable,
-	.update_irq_enable =
-			  stmp3xxx_update_irq_enable,
 	.read_time	= stmp3xxx_rtc_gettime,
 	.set_mmss	= stmp3xxx_rtc_set_mmss,
 	.read_alarm	= stmp3xxx_rtc_read_alarm,
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index ed1b868..f9a2799 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -213,18 +213,6 @@ static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
 	return ret;
 }
 
-static int twl_rtc_update_irq_enable(struct device *dev, unsigned enabled)
-{
-	int ret;
-
-	if (enabled)
-		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
-	else
-		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
-
-	return ret;
-}
-
 /*
  * Gets current TWL RTC time and date parameters.
  *
@@ -433,7 +421,6 @@ static struct rtc_class_ops twl_rtc_ops = {
 	.read_alarm	= twl_rtc_read_alarm,
 	.set_alarm	= twl_rtc_set_alarm,
 	.alarm_irq_enable = twl_rtc_alarm_irq_enable,
-	.update_irq_enable = twl_rtc_update_irq_enable,
 };
 
 /*----------------------------------------------------------------------*/
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 82931dc..bdc909b 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -315,21 +315,6 @@ static int wm831x_rtc_alarm_irq_enable(struct device *dev,
 		return wm831x_rtc_stop_alarm(wm831x_rtc);
 }
 
-static int wm831x_rtc_update_irq_enable(struct device *dev,
-					unsigned int enabled)
-{
-	struct wm831x_rtc *wm831x_rtc = dev_get_drvdata(dev);
-	int val;
-
-	if (enabled)
-		val = 1 << WM831X_RTC_PINT_FREQ_SHIFT;
-	else
-		val = 0;
-
-	return wm831x_set_bits(wm831x_rtc->wm831x, WM831X_RTC_CONTROL,
-			       WM831X_RTC_PINT_FREQ_MASK, val);
-}
-
 static irqreturn_t wm831x_alm_irq(int irq, void *data)
 {
 	struct wm831x_rtc *wm831x_rtc = data;
@@ -354,7 +339,6 @@ static const struct rtc_class_ops wm831x_rtc_ops = {
 	.read_alarm = wm831x_rtc_readalarm,
 	.set_alarm = wm831x_rtc_setalarm,
 	.alarm_irq_enable = wm831x_rtc_alarm_irq_enable,
-	.update_irq_enable = wm831x_rtc_update_irq_enable,
 };
 
 #ifdef CONFIG_PM
diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 3d0dc76..6642142 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -302,26 +302,6 @@ static int wm8350_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return ret;
 }
 
-static int wm8350_rtc_update_irq_enable(struct device *dev,
-					unsigned int enabled)
-{
-	struct wm8350 *wm8350 = dev_get_drvdata(dev);
-
-	/* Suppress duplicate changes since genirq nests enable and
-	 * disable calls. */
-	if (enabled == wm8350->rtc.update_enabled)
-		return 0;
-
-	if (enabled)
-		wm8350_unmask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-	else
-		wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
-
-	wm8350->rtc.update_enabled = enabled;
-
-	return 0;
-}
-
 static irqreturn_t wm8350_rtc_alarm_handler(int irq, void *data)
 {
 	struct wm8350 *wm8350 = data;
@@ -357,7 +337,6 @@ static const struct rtc_class_ops wm8350_rtc_ops = {
 	.read_alarm = wm8350_rtc_readalarm,
 	.set_alarm = wm8350_rtc_setalarm,
 	.alarm_irq_enable = wm8350_rtc_alarm_irq_enable,
-	.update_irq_enable = wm8350_rtc_update_irq_enable,
 };
 
 #ifdef CONFIG_PM
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 5eb9650..a69249d 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -149,7 +149,6 @@ struct rtc_class_ops {
 	int (*set_mmss)(struct device *, unsigned long secs);
 	int (*read_callback)(struct device *, int data);
 	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
-	int (*update_irq_enable)(struct device *, unsigned int enabled);
 };
 
 #define RTC_DEVICE_NAME_SIZE 20
-- 
1.7.3.2.146.gca209

