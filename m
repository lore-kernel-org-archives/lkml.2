Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1BNIcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 03:32:25 -0500
Received: from www.tglx.de ([62.245.132.106]:58061 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab1BNIcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 03:32:22 -0500
Date: Mon, 14 Feb 2011 09:29:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: [GIT pull] RTC fixes for 2.6.38
Message-ID: <alpine.LFD.2.00.1102140902400.26192@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest rtc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rtc-for-linus

This is rather large, but there is no simpler way to fix the fallout
from the RTC rework which went into .38 except doing a rather ugly
and huge revert.

It went unnoticed that the affected drivers did not have a separate
alarm_irq_enable method, so with the conversion to the new framework
the alarm interrupt does not work anymore. The patches implement the
missing bits for each driver and make them work again.

Thanks,

	tglx

------------------>
John Stultz (3):
      RTC: Fix rtc driver ioctl specific shortcutting
      RTC: Convert rtc drivers to use the alarm_irq_enable method
      RTC: Fix minor compile warning


 drivers/rtc/rtc-at32ap700x.c |   19 +++++-----------
 drivers/rtc/rtc-at91rm9200.c |   20 +++++++++++------
 drivers/rtc/rtc-at91sam9.c   |   20 ++++++++++++-----
 drivers/rtc/rtc-bfin.c       |   21 ++++++++++-------
 drivers/rtc/rtc-dev.c        |   21 ++++++------------
 drivers/rtc/rtc-ds1286.c     |   41 +++++++++++++++++++---------------
 drivers/rtc/rtc-ds1305.c     |   43 +++++++++++-------------------------
 drivers/rtc/rtc-ds1307.c     |   49 +++++++++++------------------------------
 drivers/rtc/rtc-ds1374.c     |   37 ++++++++-----------------------
 drivers/rtc/rtc-m41t80.c     |   30 ++++++------------------
 drivers/rtc/rtc-m48t59.c     |   21 +++++------------
 drivers/rtc/rtc-mrst.c       |   31 ++++----------------------
 drivers/rtc/rtc-msm6242.c    |    2 +-
 drivers/rtc/rtc-mv.c         |   20 ++++++-----------
 drivers/rtc/rtc-omap.c       |   28 ++++++++++++++++-------
 drivers/rtc/rtc-rp5c01.c     |    2 +-
 drivers/rtc/rtc-rs5c372.c    |   48 +++++++++++++++++++++++++++++------------
 drivers/rtc/rtc-sa1100.c     |   22 ++++++++++--------
 drivers/rtc/rtc-sh.c         |   11 ++++++---
 drivers/rtc/rtc-test.c       |   21 ++---------------
 drivers/rtc/rtc-vr41xx.c     |   38 +++++++++++++++-----------------
 21 files changed, 232 insertions(+), 313 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index b2752b6..e725d51 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -134,36 +134,29 @@ static int at32_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return ret;
 }
 
-static int at32_rtc_ioctl(struct device *dev, unsigned int cmd,
-			unsigned long arg)
+static int at32_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
 	int ret = 0;
 
 	spin_lock_irq(&rtc->lock);
 
-	switch (cmd) {
-	case RTC_AIE_ON:
+	if(enabled) {
 		if (rtc_readl(rtc, VAL) > rtc->alarm_time) {
 			ret = -EINVAL;
-			break;
+			goto out;
 		}
 		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
 				| RTC_BIT(CTRL_TOPEN));
 		rtc_writel(rtc, ICR, RTC_BIT(ICR_TOPI));
 		rtc_writel(rtc, IER, RTC_BIT(IER_TOPI));
-		break;
-	case RTC_AIE_OFF:
+	} else {
 		rtc_writel(rtc, CTRL, rtc_readl(rtc, CTRL)
 				& ~RTC_BIT(CTRL_TOPEN));
 		rtc_writel(rtc, IDR, RTC_BIT(IDR_TOPI));
 		rtc_writel(rtc, ICR, RTC_BIT(ICR_TOPI));
-		break;
-	default:
-		ret = -ENOIOCTLCMD;
-		break;
 	}
-
+out:
 	spin_unlock_irq(&rtc->lock);
 
 	return ret;
@@ -195,11 +188,11 @@ static irqreturn_t at32_rtc_interrupt(int irq, void *dev_id)
 }
 
 static struct rtc_class_ops at32_rtc_ops = {
-	.ioctl		= at32_rtc_ioctl,
 	.read_time	= at32_rtc_readtime,
 	.set_time	= at32_rtc_settime,
 	.read_alarm	= at32_rtc_readalarm,
 	.set_alarm	= at32_rtc_setalarm,
+	.alarm_irq_enable = at32_rtc_alarm_irq_enable,
 };
 
 static int __init at32_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index bc8bbca..26d1cf5 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -195,13 +195,6 @@ static int at91_rtc_ioctl(struct device *dev, unsigned int cmd,
 
 	/* important:  scrub old status before enabling IRQs */
 	switch (cmd) {
-	case RTC_AIE_OFF:	/* alarm off */
-		at91_sys_write(AT91_RTC_IDR, AT91_RTC_ALARM);
-		break;
-	case RTC_AIE_ON:	/* alarm on */
-		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
-		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
-		break;
 	case RTC_UIE_OFF:	/* update off */
 		at91_sys_write(AT91_RTC_IDR, AT91_RTC_SECEV);
 		break;
@@ -217,6 +210,18 @@ static int at91_rtc_ioctl(struct device *dev, unsigned int cmd,
 	return ret;
 }
 
+static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	pr_debug("%s(): cmd=%08x\n", __func__, enabled);
+
+	if (enabled) {
+		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
+		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
+	} else
+		at91_sys_write(AT91_RTC_IDR, AT91_RTC_ALARM);
+
+	return 0;
+}
 /*
  * Provide additional RTC information in /proc/driver/rtc
  */
@@ -270,6 +275,7 @@ static const struct rtc_class_ops at91_rtc_ops = {
 	.read_alarm	= at91_rtc_readalarm,
 	.set_alarm	= at91_rtc_setalarm,
 	.proc		= at91_rtc_proc,
+	.alarm_irq_enable = at91_rtc_alarm_irq_enable,
 };
 
 /*
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index f677e07..c36749e 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -229,12 +229,6 @@ static int at91_rtc_ioctl(struct device *dev, unsigned int cmd,
 	dev_dbg(dev, "ioctl: cmd=%08x, arg=%08lx, mr %08x\n", cmd, arg, mr);
 
 	switch (cmd) {
-	case RTC_AIE_OFF:		/* alarm off */
-		rtt_writel(rtc, MR, mr & ~AT91_RTT_ALMIEN);
-		break;
-	case RTC_AIE_ON:		/* alarm on */
-		rtt_writel(rtc, MR, mr | AT91_RTT_ALMIEN);
-		break;
 	case RTC_UIE_OFF:		/* update off */
 		rtt_writel(rtc, MR, mr & ~AT91_RTT_RTTINCIEN);
 		break;
@@ -249,6 +243,19 @@ static int at91_rtc_ioctl(struct device *dev, unsigned int cmd,
 	return ret;
 }
 
+static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct sam9_rtc *rtc = dev_get_drvdata(dev);
+	u32 mr = rtt_readl(rtc, MR);
+
+	dev_dbg(dev, "alarm_irq_enable: enabled=%08x, mr %08x\n", enabled, mr);
+	if (enabled)
+		rtt_writel(rtc, MR, mr | AT91_RTT_ALMIEN);
+	else
+		rtt_writel(rtc, MR, mr & ~AT91_RTT_ALMIEN);
+	return 0;
+}
+
 /*
  * Provide additional RTC information in /proc/driver/rtc
  */
@@ -302,6 +309,7 @@ static const struct rtc_class_ops at91_rtc_ops = {
 	.read_alarm	= at91_rtc_readalarm,
 	.set_alarm	= at91_rtc_setalarm,
 	.proc		= at91_rtc_proc,
+	.alarm_irq_enabled = at91_rtc_alarm_irq_enable,
 };
 
 /*
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index b4b6087..17971d9 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -259,15 +259,6 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 		bfin_rtc_int_clear(~RTC_ISTAT_SEC);
 		break;
 
-	case RTC_AIE_ON:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_set_alarm(rtc);
-		break;
-	case RTC_AIE_OFF:
-		dev_dbg_stamp(dev);
-		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
-		break;
-
 	default:
 		dev_dbg_stamp(dev);
 		ret = -ENOIOCTLCMD;
@@ -276,6 +267,17 @@ static int bfin_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long ar
 	return ret;
 }
 
+static int bfin_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct bfin_rtc *rtc = dev_get_drvdata(dev);
+
+	dev_dbg_stamp(dev);
+	if (enabled)
+		bfin_rtc_int_set_alarm(rtc);
+	else
+		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+}
+
 static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
@@ -362,6 +364,7 @@ static struct rtc_class_ops bfin_rtc_ops = {
 	.read_alarm    = bfin_rtc_read_alarm,
 	.set_alarm     = bfin_rtc_set_alarm,
 	.proc          = bfin_rtc_proc,
+	.alarm_irq_enable = bfin_rtc_alarm_irq_enable,
 };
 
 static int __devinit bfin_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 212b16e..37c3cc1 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -154,19 +154,7 @@ static long rtc_dev_ioctl(struct file *file,
 	if (err)
 		goto done;
 
-	/* try the driver's ioctl interface */
-	if (ops->ioctl) {
-		err = ops->ioctl(rtc->dev.parent, cmd, arg);
-		if (err != -ENOIOCTLCMD) {
-			mutex_unlock(&rtc->ops_lock);
-			return err;
-		}
-	}
-
-	/* if the driver does not provide the ioctl interface
-	 * or if that particular ioctl was not implemented
-	 * (-ENOIOCTLCMD), we will try to emulate here.
-	 *
+	/*
 	 * Drivers *SHOULD NOT* provide ioctl implementations
 	 * for these requests.  Instead, provide methods to
 	 * support the following code, so that the RTC's main
@@ -329,7 +317,12 @@ static long rtc_dev_ioctl(struct file *file,
 		return err;
 
 	default:
-		err = -ENOTTY;
+		/* Finally try the driver's ioctl interface */
+		if (ops->ioctl) {
+			err = ops->ioctl(rtc->dev.parent, cmd, arg);
+			if (err == -ENOIOCTLCMD)
+				err = -ENOTTY;
+		}
 		break;
 	}
 
diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index bf430f9..60ce696 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -40,6 +40,26 @@ static inline void ds1286_rtc_write(struct ds1286_priv *priv, u8 data, int reg)
 	__raw_writel(data, &priv->rtcregs[reg]);
 }
 
+
+static int ds1286_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct ds1286_priv *priv = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned char val;
+
+	/* Allow or mask alarm interrupts */
+	spin_lock_irqsave(&priv->lock, flags);
+	val = ds1286_rtc_read(priv, RTC_CMD);
+	if (enabled)
+		val &=  ~RTC_TDM;
+	else
+		val |=  RTC_TDM;
+	ds1286_rtc_write(priv, val, RTC_CMD);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
 #ifdef CONFIG_RTC_INTF_DEV
 
 static int ds1286_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
@@ -49,22 +69,6 @@ static int ds1286_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	unsigned char val;
 
 	switch (cmd) {
-	case RTC_AIE_OFF:
-		/* Mask alarm int. enab. bit	*/
-		spin_lock_irqsave(&priv->lock, flags);
-		val = ds1286_rtc_read(priv, RTC_CMD);
-		val |=  RTC_TDM;
-		ds1286_rtc_write(priv, val, RTC_CMD);
-		spin_unlock_irqrestore(&priv->lock, flags);
-		break;
-	case RTC_AIE_ON:
-		/* Allow alarm interrupts.	*/
-		spin_lock_irqsave(&priv->lock, flags);
-		val = ds1286_rtc_read(priv, RTC_CMD);
-		val &=  ~RTC_TDM;
-		ds1286_rtc_write(priv, val, RTC_CMD);
-		spin_unlock_irqrestore(&priv->lock, flags);
-		break;
 	case RTC_WIE_OFF:
 		/* Mask watchdog int. enab. bit	*/
 		spin_lock_irqsave(&priv->lock, flags);
@@ -316,12 +320,13 @@ static int ds1286_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 }
 
 static const struct rtc_class_ops ds1286_ops = {
-	.ioctl   	= ds1286_ioctl,
-	.proc   	= ds1286_proc,
+	.ioctl		= ds1286_ioctl,
+	.proc		= ds1286_proc,
 	.read_time	= ds1286_read_time,
 	.set_time	= ds1286_set_time,
 	.read_alarm	= ds1286_read_alarm,
 	.set_alarm	= ds1286_set_alarm,
+	.alarm_irq_enable = ds1286_alarm_irq_enable,
 };
 
 static int __devinit ds1286_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 077af1d..57fbcc1 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -139,49 +139,32 @@ static u8 hour2bcd(bool hr12, int hour)
  * Interface to RTC framework
  */
 
-#ifdef CONFIG_RTC_INTF_DEV
-
-/*
- * Context: caller holds rtc->ops_lock (to protect ds1305->ctrl)
- */
-static int ds1305_ioctl(struct device *dev, unsigned cmd, unsigned long arg)
+static int ds1305_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct ds1305	*ds1305 = dev_get_drvdata(dev);
 	u8		buf[2];
-	int		status = -ENOIOCTLCMD;
+	long		err = -EINVAL;
 
 	buf[0] = DS1305_WRITE | DS1305_CONTROL;
 	buf[1] = ds1305->ctrl[0];
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		status = 0;
-		if (!(buf[1] & DS1305_AEI0))
-			goto done;
-		buf[1] &= ~DS1305_AEI0;
-		break;
-
-	case RTC_AIE_ON:
-		status = 0;
+	if (enabled) {
 		if (ds1305->ctrl[0] & DS1305_AEI0)
 			goto done;
 		buf[1] |= DS1305_AEI0;
-		break;
-	}
-	if (status == 0) {
-		status = spi_write_then_read(ds1305->spi, buf, sizeof buf,
-				NULL, 0);
-		if (status >= 0)
-			ds1305->ctrl[0] = buf[1];
+	} else {
+		if (!(buf[1] & DS1305_AEI0))
+			goto done;
+		buf[1] &= ~DS1305_AEI0;
 	}
-
+	err = spi_write_then_read(ds1305->spi, buf, sizeof buf, NULL, 0);
+	if (err >= 0)
+		ds1305->ctrl[0] = buf[1];
 done:
-	return status;
+	return err;
+
 }
 
-#else
-#define ds1305_ioctl	NULL
-#endif
 
 /*
  * Get/set of date and time is pretty normal.
@@ -460,12 +443,12 @@ done:
 #endif
 
 static const struct rtc_class_ops ds1305_ops = {
-	.ioctl		= ds1305_ioctl,
 	.read_time	= ds1305_get_time,
 	.set_time	= ds1305_set_time,
 	.read_alarm	= ds1305_get_alarm,
 	.set_alarm	= ds1305_set_alarm,
 	.proc		= ds1305_proc,
+	.alarm_irq_enable = ds1305_alarm_irq_enable,
 };
 
 static void ds1305_work(struct work_struct *work)
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 0d559b6..4724ba3 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -495,50 +495,27 @@ static int ds1337_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
-static int ds1307_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int ds1307_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
 	struct ds1307		*ds1307 = i2c_get_clientdata(client);
 	int			ret;
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		if (!test_bit(HAS_ALARM, &ds1307->flags))
-			return -ENOTTY;
-
-		ret = i2c_smbus_read_byte_data(client, DS1337_REG_CONTROL);
-		if (ret < 0)
-			return ret;
-
-		ret &= ~DS1337_BIT_A1IE;
-
-		ret = i2c_smbus_write_byte_data(client,
-						DS1337_REG_CONTROL, ret);
-		if (ret < 0)
-			return ret;
-
-		break;
-
-	case RTC_AIE_ON:
-		if (!test_bit(HAS_ALARM, &ds1307->flags))
-			return -ENOTTY;
+	if (!test_bit(HAS_ALARM, &ds1307->flags))
+		return -ENOTTY;
 
-		ret = i2c_smbus_read_byte_data(client, DS1337_REG_CONTROL);
-		if (ret < 0)
-			return ret;
+	ret = i2c_smbus_read_byte_data(client, DS1337_REG_CONTROL);
+	if (ret < 0)
+		return ret;
 
+	if (enabled)
 		ret |= DS1337_BIT_A1IE;
+	else
+		ret &= ~DS1337_BIT_A1IE;
 
-		ret = i2c_smbus_write_byte_data(client,
-						DS1337_REG_CONTROL, ret);
-		if (ret < 0)
-			return ret;
-
-		break;
-
-	default:
-		return -ENOIOCTLCMD;
-	}
+	ret = i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL, ret);
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }
@@ -548,7 +525,7 @@ static const struct rtc_class_ops ds13xx_rtc_ops = {
 	.set_time	= ds1307_set_time,
 	.read_alarm	= ds1337_read_alarm,
 	.set_alarm	= ds1337_set_alarm,
-	.ioctl		= ds1307_ioctl,
+	.alarm_irq_enable = ds1307_alarm_irq_enable,
 };
 
 /*----------------------------------------------------------------------*/
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 47fb635..d834a63 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -307,42 +307,25 @@ unlock:
 	mutex_unlock(&ds1374->mutex);
 }
 
-static int ds1374_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int ds1374_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct ds1374 *ds1374 = i2c_get_clientdata(client);
-	int ret = -ENOIOCTLCMD;
+	int ret;
 
 	mutex_lock(&ds1374->mutex);
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		ret = i2c_smbus_read_byte_data(client, DS1374_REG_CR);
-		if (ret < 0)
-			goto out;
-
-		ret &= ~DS1374_REG_CR_WACE;
-
-		ret = i2c_smbus_write_byte_data(client, DS1374_REG_CR, ret);
-		if (ret < 0)
-			goto out;
-
-		break;
-
-	case RTC_AIE_ON:
-		ret = i2c_smbus_read_byte_data(client, DS1374_REG_CR);
-		if (ret < 0)
-			goto out;
+	ret = i2c_smbus_read_byte_data(client, DS1374_REG_CR);
+	if (ret < 0)
+		goto out;
 
+	if (enabled) {
 		ret |= DS1374_REG_CR_WACE | DS1374_REG_CR_AIE;
 		ret &= ~DS1374_REG_CR_WDALM;
-
-		ret = i2c_smbus_write_byte_data(client, DS1374_REG_CR, ret);
-		if (ret < 0)
-			goto out;
-
-		break;
+	} else {
+		ret &= ~DS1374_REG_CR_WACE;
 	}
+	ret = i2c_smbus_write_byte_data(client, DS1374_REG_CR, ret);
 
 out:
 	mutex_unlock(&ds1374->mutex);
@@ -354,7 +337,7 @@ static const struct rtc_class_ops ds1374_rtc_ops = {
 	.set_time = ds1374_set_time,
 	.read_alarm = ds1374_read_alarm,
 	.set_alarm = ds1374_set_alarm,
-	.ioctl = ds1374_ioctl,
+	.alarm_irq_enable = ds1374_alarm_irq_enable,
 };
 
 static int ds1374_probe(struct i2c_client *client,
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 5a8daa3..69fe664 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -213,41 +213,27 @@ static int m41t80_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return m41t80_set_datetime(to_i2c_client(dev), tm);
 }
 
-#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
-static int
-m41t80_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int m41t80_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	int rc;
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-		break;
-	default:
-		return -ENOIOCTLCMD;
-	}
-
 	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
 	if (rc < 0)
 		goto err;
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		rc &= ~M41T80_ALMON_AFE;
-		break;
-	case RTC_AIE_ON:
+
+	if (enabled)
 		rc |= M41T80_ALMON_AFE;
-		break;
-	}
+	else
+		rc &= ~M41T80_ALMON_AFE;
+
 	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON, rc) < 0)
 		goto err;
+
 	return 0;
 err:
 	return -EIO;
 }
-#else
-#define	m41t80_rtc_ioctl NULL
-#endif
 
 static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
@@ -374,7 +360,7 @@ static struct rtc_class_ops m41t80_rtc_ops = {
 	.read_alarm = m41t80_rtc_read_alarm,
 	.set_alarm = m41t80_rtc_set_alarm,
 	.proc = m41t80_rtc_proc,
-	.ioctl = m41t80_rtc_ioctl,
+	.alarm_irq_enable = m41t80_rtc_alarm_irq_enable,
 };
 
 #if defined(CONFIG_RTC_INTF_SYSFS) || defined(CONFIG_RTC_INTF_SYSFS_MODULE)
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index a99a0b5..3978f4c 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -263,30 +263,21 @@ static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 /*
  * Handle commands from user-space
  */
-static int m48t59_rtc_ioctl(struct device *dev, unsigned int cmd,
-			unsigned long arg)
+static int m48t59_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
-	int ret = 0;
 
 	spin_lock_irqsave(&m48t59->lock, flags);
-	switch (cmd) {
-	case RTC_AIE_OFF:	/* alarm interrupt off */
-		M48T59_WRITE(0x00, M48T59_INTR);
-		break;
-	case RTC_AIE_ON:	/* alarm interrupt on */
+	if (enabled)
 		M48T59_WRITE(M48T59_INTR_AFE, M48T59_INTR);
-		break;
-	default:
-		ret = -ENOIOCTLCMD;
-		break;
-	}
+	else
+		M48T59_WRITE(0x00, M48T59_INTR);
 	spin_unlock_irqrestore(&m48t59->lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static int m48t59_rtc_proc(struct device *dev, struct seq_file *seq)
@@ -330,12 +321,12 @@ static irqreturn_t m48t59_rtc_interrupt(int irq, void *dev_id)
 }
 
 static const struct rtc_class_ops m48t59_rtc_ops = {
-	.ioctl		= m48t59_rtc_ioctl,
 	.read_time	= m48t59_rtc_read_time,
 	.set_time	= m48t59_rtc_set_time,
 	.read_alarm	= m48t59_rtc_readalarm,
 	.set_alarm	= m48t59_rtc_setalarm,
 	.proc		= m48t59_rtc_proc,
+	.alarm_irq_enable = m48t59_rtc_alarm_irq_enable,
 };
 
 static const struct rtc_class_ops m48t02_rtc_ops = {
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index bcd0cf6..1db62db 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -255,42 +255,21 @@ static int mrst_irq_set_state(struct device *dev, int enabled)
 	return 0;
 }
 
-#if defined(CONFIG_RTC_INTF_DEV) || defined(CONFIG_RTC_INTF_DEV_MODULE)
-
 /* Currently, the vRTC doesn't support UIE ON/OFF */
-static int
-mrst_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+static int mrst_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
 	unsigned long	flags;
 
-	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-		if (!mrst->irq)
-			return -EINVAL;
-		break;
-	default:
-		/* PIE ON/OFF is handled by mrst_irq_set_state() */
-		return -ENOIOCTLCMD;
-	}
-
 	spin_lock_irqsave(&rtc_lock, flags);
-	switch (cmd) {
-	case RTC_AIE_OFF:	/* alarm off */
-		mrst_irq_disable(mrst, RTC_AIE);
-		break;
-	case RTC_AIE_ON:	/* alarm on */
+	if (enabled)
 		mrst_irq_enable(mrst, RTC_AIE);
-		break;
-	}
+	else
+		mrst_irq_disable(mrst, RTC_AIE);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return 0;
 }
 
-#else
-#define	mrst_rtc_ioctl	NULL
-#endif
 
 #if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
 
@@ -317,13 +296,13 @@ static int mrst_procfs(struct device *dev, struct seq_file *seq)
 #endif
 
 static const struct rtc_class_ops mrst_rtc_ops = {
-	.ioctl		= mrst_rtc_ioctl,
 	.read_time	= mrst_read_time,
 	.set_time	= mrst_set_time,
 	.read_alarm	= mrst_read_alarm,
 	.set_alarm	= mrst_set_alarm,
 	.proc		= mrst_procfs,
 	.irq_set_state	= mrst_irq_set_state,
+	.alarm_irq_enable = mrst_rtc_alarm_irq_enable,
 };
 
 static struct mrst_rtc	mrst_rtc;
diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index b2fff0c..6782062 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -82,7 +82,7 @@ static inline unsigned int msm6242_read(struct msm6242_priv *priv,
 static inline void msm6242_write(struct msm6242_priv *priv, unsigned int val,
 				unsigned int reg)
 {
-	return __raw_writel(val, &priv->regs[reg]);
+	__raw_writel(val, &priv->regs[reg]);
 }
 
 static inline void msm6242_set(struct msm6242_priv *priv, unsigned int val,
diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index bcca472..60627a7 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -169,25 +169,19 @@ static int mv_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	return 0;
 }
 
-static int mv_rtc_ioctl(struct device *dev, unsigned int cmd,
-			unsigned long arg)
+static int mv_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
 	if (pdata->irq < 0)
-		return -ENOIOCTLCMD; /* fall back into rtc-dev's emulation */
-	switch (cmd) {
-	case RTC_AIE_OFF:
-		writel(0, ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
-		break;
-	case RTC_AIE_ON:
+		return -EINVAL; /* fall back into rtc-dev's emulation */
+
+	if (enabled)
 		writel(1, ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
-		break;
-	default:
-		return -ENOIOCTLCMD;
-	}
+	else
+		writel(0, ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
 	return 0;
 }
 
@@ -216,7 +210,7 @@ static const struct rtc_class_ops mv_rtc_alarm_ops = {
 	.set_time	= mv_rtc_set_time,
 	.read_alarm	= mv_rtc_read_alarm,
 	.set_alarm	= mv_rtc_set_alarm,
-	.ioctl		= mv_rtc_ioctl,
+	.alarm_irq_enable = mv_rtc_alarm_irq_enable,
 };
 
 static int __devinit mv_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index e72b523..b4dbf3a 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -143,8 +143,6 @@ omap_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	u8 reg;
 
 	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
 	case RTC_UIE_OFF:
 	case RTC_UIE_ON:
 		break;
@@ -156,13 +154,6 @@ omap_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	rtc_wait_not_busy();
 	reg = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 	switch (cmd) {
-	/* AIE = Alarm Interrupt Enable */
-	case RTC_AIE_OFF:
-		reg &= ~OMAP_RTC_INTERRUPTS_IT_ALARM;
-		break;
-	case RTC_AIE_ON:
-		reg |= OMAP_RTC_INTERRUPTS_IT_ALARM;
-		break;
 	/* UIE = Update Interrupt Enable (1/second) */
 	case RTC_UIE_OFF:
 		reg &= ~OMAP_RTC_INTERRUPTS_IT_TIMER;
@@ -182,6 +173,24 @@ omap_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 #define	omap_rtc_ioctl	NULL
 #endif
 
+static int omap_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	u8 reg;
+
+	local_irq_disable();
+	rtc_wait_not_busy();
+	reg = rtc_read(OMAP_RTC_INTERRUPTS_REG);
+	if (enabled)
+		reg |= OMAP_RTC_INTERRUPTS_IT_ALARM;
+	else
+		reg &= ~OMAP_RTC_INTERRUPTS_IT_ALARM;
+	rtc_wait_not_busy();
+	rtc_write(reg, OMAP_RTC_INTERRUPTS_REG);
+	local_irq_enable();
+
+	return 0;
+}
+
 /* this hardware doesn't support "don't care" alarm fields */
 static int tm2bcd(struct rtc_time *tm)
 {
@@ -309,6 +318,7 @@ static struct rtc_class_ops omap_rtc_ops = {
 	.set_time	= omap_rtc_set_time,
 	.read_alarm	= omap_rtc_read_alarm,
 	.set_alarm	= omap_rtc_set_alarm,
+	.alarm_irq_enable = omap_rtc_alarm_irq_enable,
 };
 
 static int omap_rtc_alarm;
diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index 36eb661..694da39 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -76,7 +76,7 @@ static inline unsigned int rp5c01_read(struct rp5c01_priv *priv,
 static inline void rp5c01_write(struct rp5c01_priv *priv, unsigned int val,
 				unsigned int reg)
 {
-	return __raw_writel(val, &priv->regs[reg]);
+	__raw_writel(val, &priv->regs[reg]);
 }
 
 static void rp5c01_lock(struct rp5c01_priv *priv)
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index dd14e20..6aaa155 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -299,14 +299,6 @@ rs5c_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 		if (rs5c->type == rtc_rs5c372a
 				&& (buf & RS5C372A_CTRL1_SL1))
 			return -ENOIOCTLCMD;
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-		/* these irq management calls only make sense for chips
-		 * which are wired up to an IRQ.
-		 */
-		if (!rs5c->has_irq)
-			return -ENOIOCTLCMD;
-		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -317,12 +309,6 @@ rs5c_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 
 	addr = RS5C_ADDR(RS5C_REG_CTRL1);
 	switch (cmd) {
-	case RTC_AIE_OFF:	/* alarm off */
-		buf &= ~RS5C_CTRL1_AALE;
-		break;
-	case RTC_AIE_ON:	/* alarm on */
-		buf |= RS5C_CTRL1_AALE;
-		break;
 	case RTC_UIE_OFF:	/* update off */
 		buf &= ~RS5C_CTRL1_CT_MASK;
 		break;
@@ -347,6 +333,39 @@ rs5c_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 #endif
 
 
+static int rs5c_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct i2c_client	*client = to_i2c_client(dev);
+	struct rs5c372		*rs5c = i2c_get_clientdata(client);
+	unsigned char		buf;
+	int			status, addr;
+
+	buf = rs5c->regs[RS5C_REG_CTRL1];
+
+	if (!rs5c->has_irq)
+		return -EINVAL;
+
+	status = rs5c_get_regs(rs5c);
+	if (status < 0)
+		return status;
+
+	addr = RS5C_ADDR(RS5C_REG_CTRL1);
+	if (enabled)
+		buf |= RS5C_CTRL1_AALE;
+	else
+		buf &= ~RS5C_CTRL1_AALE;
+
+	if (i2c_smbus_write_byte_data(client, addr, buf) < 0) {
+		printk(KERN_WARNING "%s: can't update alarm\n",
+			rs5c->rtc->name);
+		status = -EIO;
+	} else
+		rs5c->regs[RS5C_REG_CTRL1] = buf;
+
+	return status;
+}
+
+
 /* NOTE:  Since RTC_WKALM_{RD,SET} were originally defined for EFI,
  * which only exposes a polled programming interface; and since
  * these calls map directly to those EFI requests; we don't demand
@@ -466,6 +485,7 @@ static const struct rtc_class_ops rs5c372_rtc_ops = {
 	.set_time	= rs5c372_rtc_set_time,
 	.read_alarm	= rs5c_read_alarm,
 	.set_alarm	= rs5c_set_alarm,
+	.alarm_irq_enable = rs5c_rtc_alarm_irq_enable,
 };
 
 #if defined(CONFIG_RTC_INTF_SYSFS) || defined(CONFIG_RTC_INTF_SYSFS_MODULE)
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 88ea52b..5dfe5ff 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -314,16 +314,6 @@ static int sa1100_rtc_ioctl(struct device *dev, unsigned int cmd,
 		unsigned long arg)
 {
 	switch (cmd) {
-	case RTC_AIE_OFF:
-		spin_lock_irq(&sa1100_rtc_lock);
-		RTSR &= ~RTSR_ALE;
-		spin_unlock_irq(&sa1100_rtc_lock);
-		return 0;
-	case RTC_AIE_ON:
-		spin_lock_irq(&sa1100_rtc_lock);
-		RTSR |= RTSR_ALE;
-		spin_unlock_irq(&sa1100_rtc_lock);
-		return 0;
 	case RTC_UIE_OFF:
 		spin_lock_irq(&sa1100_rtc_lock);
 		RTSR &= ~RTSR_HZE;
@@ -338,6 +328,17 @@ static int sa1100_rtc_ioctl(struct device *dev, unsigned int cmd,
 	return -ENOIOCTLCMD;
 }
 
+static int sa1100_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	spin_lock_irq(&sa1100_rtc_lock);
+	if (enabled)
+		RTSR |= RTSR_ALE;
+	else
+		RTSR &= ~RTSR_ALE;
+	spin_unlock_irq(&sa1100_rtc_lock);
+	return 0;
+}
+
 static int sa1100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	rtc_time_to_tm(RCNR, tm);
@@ -410,6 +411,7 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 	.proc = sa1100_rtc_proc,
 	.irq_set_freq = sa1100_irq_set_freq,
 	.irq_set_state = sa1100_irq_set_state,
+	.alarm_irq_enable = sa1100_rtc_alarm_irq_enable,
 };
 
 static int sa1100_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 06e41ed..93314a9 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -350,10 +350,6 @@ static int sh_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	unsigned int ret = 0;
 
 	switch (cmd) {
-	case RTC_AIE_OFF:
-	case RTC_AIE_ON:
-		sh_rtc_setaie(dev, cmd == RTC_AIE_ON);
-		break;
 	case RTC_UIE_OFF:
 		rtc->periodic_freq &= ~PF_OXS;
 		sh_rtc_setcie(dev, 0);
@@ -369,6 +365,12 @@ static int sh_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
+static int sh_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	sh_rtc_setaie(dev, enabled);
+	return 0;
+}
+
 static int sh_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -604,6 +606,7 @@ static struct rtc_class_ops sh_rtc_ops = {
 	.irq_set_state	= sh_rtc_irq_set_state,
 	.irq_set_freq	= sh_rtc_irq_set_freq,
 	.proc		= sh_rtc_proc,
+	.alarm_irq_enable = sh_rtc_alarm_irq_enable,
 };
 
 static int __init sh_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 51725f7..a82d6fe 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -50,24 +50,9 @@ static int test_rtc_proc(struct device *dev, struct seq_file *seq)
 	return 0;
 }
 
-static int test_rtc_ioctl(struct device *dev, unsigned int cmd,
-	unsigned long arg)
+static int test_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 {
-	/* We do support interrupts, they're generated
-	 * using the sysfs interface.
-	 */
-	switch (cmd) {
-	case RTC_PIE_ON:
-	case RTC_PIE_OFF:
-	case RTC_UIE_ON:
-	case RTC_UIE_OFF:
-	case RTC_AIE_ON:
-	case RTC_AIE_OFF:
-		return 0;
-
-	default:
-		return -ENOIOCTLCMD;
-	}
+	return 0;
 }
 
 static const struct rtc_class_ops test_rtc_ops = {
@@ -76,7 +61,7 @@ static const struct rtc_class_ops test_rtc_ops = {
 	.read_alarm = test_rtc_read_alarm,
 	.set_alarm = test_rtc_set_alarm,
 	.set_mmss = test_rtc_set_mmss,
-	.ioctl = test_rtc_ioctl,
+	.alarm_irq_enable = test_rtc_alarm_irq_enable,
 };
 
 static ssize_t test_irq_show(struct device *dev,
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index c324424..769190a 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -240,26 +240,6 @@ static int vr41xx_rtc_irq_set_state(struct device *dev, int enabled)
 static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
-	case RTC_AIE_ON:
-		spin_lock_irq(&rtc_lock);
-
-		if (!alarm_enabled) {
-			enable_irq(aie_irq);
-			alarm_enabled = 1;
-		}
-
-		spin_unlock_irq(&rtc_lock);
-		break;
-	case RTC_AIE_OFF:
-		spin_lock_irq(&rtc_lock);
-
-		if (alarm_enabled) {
-			disable_irq(aie_irq);
-			alarm_enabled = 0;
-		}
-
-		spin_unlock_irq(&rtc_lock);
-		break;
 	case RTC_EPOCH_READ:
 		return put_user(epoch, (unsigned long __user *)arg);
 	case RTC_EPOCH_SET:
@@ -275,6 +255,24 @@ static int vr41xx_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long
 	return 0;
 }
 
+static int vr41xx_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	spin_lock_irq(&rtc_lock);
+	if (enabled) {
+		if (!alarm_enabled) {
+			enable_irq(aie_irq);
+			alarm_enabled = 1;
+		}
+	} else {
+		if (alarm_enabled) {
+			disable_irq(aie_irq);
+			alarm_enabled = 0;
+		}
+	}
+	spin_unlock_irq(&rtc_lock);
+	return 0;
+}
+
 static irqreturn_t elapsedtime_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = (struct platform_device *)dev_id;
