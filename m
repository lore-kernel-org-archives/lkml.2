Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab1BUXzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:55:55 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58174 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab1BUXzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:53 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com
Subject: [PATCH 05/10] RTC: Clean out UIE icotl implementations
Date: Mon, 21 Feb 2011 15:55:33 -0800
Message-Id: <1298332538-31216-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the generic RTC rework, the UIE mode irqs are handled
in the generic layer, and only hardware specific ioctls
get passed down to the rtc driver layer.

So this patch removes the UIE mode ioctl handling in the rtc
driver layer, which never get used.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-at91rm9200.c |   28 ----------------------
 drivers/rtc/rtc-at91sam9.c   |   28 ----------------------
 drivers/rtc/rtc-bfin.c       |   27 ---------------------
 drivers/rtc/rtc-davinci.c    |    4 ---
 drivers/rtc/rtc-omap.c       |   39 -------------------------------
 drivers/rtc/rtc-pl030.c      |    6 -----
 drivers/rtc/rtc-rs5c372.c    |   52 ------------------------------------------
 drivers/rtc/rtc-sa1100.c     |   19 ---------------
 drivers/rtc/rtc-sh.c         |   22 -----------------
 9 files changed, 0 insertions(+), 225 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 30a48ac..0b35d7c 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -162,33 +162,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return 0;
 }
 
-/*
- * Handle commands from user-space
- */
-static int at91_rtc_ioctl(struct device *dev, unsigned int cmd,
-			unsigned long arg)
-{
-	int ret = 0;
-
-	pr_debug("%s(): cmd=%08x, arg=%08lx.\n", __func__, cmd, arg);
-
-	/* important:  scrub old status before enabling IRQs */
-	switch (cmd) {
-	case RTC_UIE_OFF:	/* update off */
-		at91_sys_write(AT91_RTC_IDR, AT91_RTC_SECEV);
-		break;
-	case RTC_UIE_ON:	/* update on */
-		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
-		at91_sys_write(AT91_RTC_IER, AT91_RTC_SECEV);
-		break;
-	default:
-		ret = -ENOIOCTLCMD;
-		break;
-	}
-
-	return ret;
-}
-
 static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	pr_debug("%s(): cmd=%08x\n", __func__, enabled);
@@ -248,7 +221,6 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 }
 
 static const struct rtc_class_ops at91_rtc_ops = {
-	.ioctl		= at91_rtc_ioctl,
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
 	.set_alarm	= at91_rtc_setalarm,
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 8d954bf..a30056b 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -190,33 +190,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return 0;
 }
 
-/*
- * Handle commands from user-space
- */
-static int at91_rtc_ioctl(struct device *dev, unsigned int cmd,
-			unsigned long arg)
-{
-	struct sam9_rtc *rtc = dev_get_drvdata(dev);
-	int ret = 0;
-	u32 mr = rtt_readl(rtc, MR);
-
-	dev_dbg(dev, "ioctl: cmd=%08x, arg=%08lx, mr %08x\n", cmd, arg, mr);
-
-	switch (cmd) {
-	case RTC_UIE_OFF:		/* update off */
-		rtt_writel(rtc, MR, mr & ~AT91_RTT_RTTINCIEN);
-		break;
-	case RTC_UIE_ON:		/* update on */
-		rtt_writel(rtc, MR, mr | AT91_RTT_RTTINCIEN);
-		break;
-	default:
-		ret = -ENOIOCTLCMD;
-		break;
-	}
-
-	return ret;
-}
-
 static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct sam9_rtc *rtc = dev_get_drvdata(dev);
@@ -277,7 +250,6 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *_rtc)
 }
 
 static const struct rtc_class_ops at91_rtc_ops = {
-	.ioctl		= at91_rtc_ioctl,
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
 	.set_alarm	= at91_rtc_setalarm,
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 9b846e4..f08499e 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -240,32 +240,6 @@ static void bfin_rtc_int_set_alarm(struct bfin_rtc *rtc)
 	 */
 	bfin_rtc_int_set(rtc->rtc_alarm.tm_yday == -1 ? RTC_ISTAT_ALARM : RTC_ISTAT_ALARM_DAY);
 }
-static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
-{
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	int ret = 0;
-
-	dev_dbg_stamp(dev);
-
-	bfin_rtc_sync_pending(dev);
-
-	switch (cmd) {
-	case RTC_UIE_ON:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_set(RTC_ISTAT_SEC);
-		break;
-	case RTC_UIE_OFF:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(~RTC_ISTAT_SEC);
-		break;
-
-	default:
-		dev_dbg_stamp(dev);
-		ret = -ENOIOCTLCMD;
-	}
-
-	return ret;
-}
 
 static int bfin_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
@@ -348,7 +322,6 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 }
 
 static struct rtc_class_ops bfin_rtc_ops = {
-	.ioctl         = bfin_rtc_ioctl,
 	.read_time     = bfin_rtc_read_time,
 	.set_time      = bfin_rtc_set_time,
 	.set_alarm     = bfin_rtc_set_alarm,
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 1fce4e0..5de0f01 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -231,10 +231,6 @@ davinci_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	case RTC_WIE_OFF:
 		rtc_ctrl &= ~PRTCSS_RTC_CTRL_WEN;
 		break;
-	case RTC_UIE_OFF:
-	case RTC_UIE_ON:
-		ret = -ENOTTY;
-		break;
 	default:
 		ret = -ENOIOCTLCMD;
 	}
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index 7e03835..923f34f 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -135,44 +135,6 @@ static irqreturn_t rtc_irq(int irq, void *rtc)
 	return IRQ_HANDLED;
 }
 
-#ifdef	CONFIG_RTC_INTF_DEV
-
-static int
-omap_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
-{
-	u8 reg;
-
-	switch (cmd) {
-	case RTC_UIE_OFF:
-	case RTC_UIE_ON:
-		break;
-	default:
-		return -ENOIOCTLCMD;
-	}
-
-	local_irq_disable();
-	rtc_wait_not_busy();
-	reg = rtc_read(OMAP_RTC_INTERRUPTS_REG);
-	switch (cmd) {
-	/* UIE = Update Interrupt Enable (1/second) */
-	case RTC_UIE_OFF:
-		reg &= ~OMAP_RTC_INTERRUPTS_IT_TIMER;
-		break;
-	case RTC_UIE_ON:
-		reg |= OMAP_RTC_INTERRUPTS_IT_TIMER;
-		break;
-	}
-	rtc_wait_not_busy();
-	rtc_write(reg, OMAP_RTC_INTERRUPTS_REG);
-	local_irq_enable();
-
-	return 0;
-}
-
-#else
-#define	omap_rtc_ioctl	NULL
-#endif
-
 static int omap_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	u8 reg;
@@ -292,7 +254,6 @@ static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 }
 
 static struct rtc_class_ops omap_rtc_ops = {
-	.ioctl		= omap_rtc_ioctl,
 	.read_time	= omap_rtc_read_time,
 	.set_time	= omap_rtc_set_time,
 	.set_alarm	= omap_rtc_set_alarm,
diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index e7d982f..71b8ce6 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -35,11 +35,6 @@ static irqreturn_t pl030_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int pl030_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
-{
-	return -ENOIOCTLCMD;
-}
-
 static int pl030_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pl030_rtc *rtc = dev_get_drvdata(dev);
@@ -88,7 +83,6 @@ static int pl030_set_time(struct device *dev, struct rtc_time *tm)
 }
 
 static const struct rtc_class_ops pl030_ops = {
-	.ioctl		= pl030_ioctl,
 	.read_time	= pl030_read_time,
 	.set_time	= pl030_set_time,
 	.set_alarm	= pl030_set_alarm,
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index ac1e57f..470de78 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -281,57 +281,6 @@ static int rs5c372_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return rs5c372_set_datetime(to_i2c_client(dev), tm);
 }
 
-#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
-
-static int
-rs5c_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
-{
-	struct i2c_client	*client = to_i2c_client(dev);
-	struct rs5c372		*rs5c = i2c_get_clientdata(client);
-	unsigned char		buf;
-	int			status, addr;
-
-	buf = rs5c->regs[RS5C_REG_CTRL1];
-	switch (cmd) {
-	case RTC_UIE_OFF:
-	case RTC_UIE_ON:
-		/* some 327a modes use a different IRQ pin for 1Hz irqs */
-		if (rs5c->type == rtc_rs5c372a
-				&& (buf & RS5C372A_CTRL1_SL1))
-			return -ENOIOCTLCMD;
-	default:
-		return -ENOIOCTLCMD;
-	}
-
-	status = rs5c_get_regs(rs5c);
-	if (status < 0)
-		return status;
-
-	addr = RS5C_ADDR(RS5C_REG_CTRL1);
-	switch (cmd) {
-	case RTC_UIE_OFF:	/* update off */
-		buf &= ~RS5C_CTRL1_CT_MASK;
-		break;
-	case RTC_UIE_ON:	/* update on */
-		buf &= ~RS5C_CTRL1_CT_MASK;
-		buf |= RS5C_CTRL1_CT4;
-		break;
-	}
-
-	if (i2c_smbus_write_byte_data(client, addr, buf) < 0) {
-		printk(KERN_WARNING "%s: can't update alarm\n",
-			rs5c->rtc->name);
-		status = -EIO;
-	} else
-		rs5c->regs[RS5C_REG_CTRL1] = buf;
-
-	return status;
-}
-
-#else
-#define	rs5c_rtc_ioctl	NULL
-#endif
-
 
 static int rs5c_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
@@ -443,7 +392,6 @@ static int rs5c372_rtc_proc(struct device *dev, struct seq_file *seq)
 
 static const struct rtc_class_ops rs5c372_rtc_ops = {
 	.proc		= rs5c372_rtc_proc,
-	.ioctl		= rs5c_rtc_ioctl,
 	.read_time	= rs5c372_rtc_read_time,
 	.set_time	= rs5c372_rtc_set_time,
 	.set_alarm	= rs5c_set_alarm,
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index df1804f..e52e1f5 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -293,24 +293,6 @@ static void sa1100_rtc_release(struct device *dev)
 }
 
 
-static int sa1100_rtc_ioctl(struct device *dev, unsigned int cmd,
-		unsigned long arg)
-{
-	switch (cmd) {
-	case RTC_UIE_OFF:
-		spin_lock_irq(&sa1100_rtc_lock);
-		RTSR &= ~RTSR_HZE;
-		spin_unlock_irq(&sa1100_rtc_lock);
-		return 0;
-	case RTC_UIE_ON:
-		spin_lock_irq(&sa1100_rtc_lock);
-		RTSR |= RTSR_HZE;
-		spin_unlock_irq(&sa1100_rtc_lock);
-		return 0;
-	}
-	return -ENOIOCTLCMD;
-}
-
 static int sa1100_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	spin_lock_irq(&sa1100_rtc_lock);
@@ -375,7 +357,6 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 	.open = sa1100_rtc_open,
 	.read_callback = sa1100_rtc_read_callback,
 	.release = sa1100_rtc_release,
-	.ioctl = sa1100_rtc_ioctl,
 	.read_time = sa1100_rtc_read_time,
 	.set_time = sa1100_rtc_set_time,
 	.set_alarm = sa1100_rtc_set_alarm,
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 956c6fb..427d907 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -344,27 +344,6 @@ static inline void sh_rtc_setcie(struct device *dev, unsigned int enable)
 	spin_unlock_irq(&rtc->lock);
 }
 
-static int sh_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
-{
-	struct sh_rtc *rtc = dev_get_drvdata(dev);
-	unsigned int ret = 0;
-
-	switch (cmd) {
-	case RTC_UIE_OFF:
-		rtc->periodic_freq &= ~PF_OXS;
-		sh_rtc_setcie(dev, 0);
-		break;
-	case RTC_UIE_ON:
-		rtc->periodic_freq |= PF_OXS;
-		sh_rtc_setcie(dev, 1);
-		break;
-	default:
-		ret = -ENOIOCTLCMD;
-	}
-
-	return ret;
-}
-
 static int sh_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	sh_rtc_setaie(dev, enabled);
@@ -559,7 +538,6 @@ static int sh_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 }
 
 static struct rtc_class_ops sh_rtc_ops = {
-	.ioctl		= sh_rtc_ioctl,
 	.read_time	= sh_rtc_read_time,
 	.set_time	= sh_rtc_set_time,
 	.set_alarm	= sh_rtc_set_alarm,
-- 
1.7.3.2.146.gca209

