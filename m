Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1BUX4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:56:45 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:57127 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab1BUXz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:58 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com
Subject: [PATCH 04/10] RTC: Cleanup rtc_class_ops->read_alarm()
Date: Mon, 21 Feb 2011 15:55:32 -0800
Message-Id: <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the generic rtc code managing the now virtualized alarm timer,
no one actually calls rtc_clas_ops->read_alarm().

We do check that it exists in rtc_read_alarm(), but that is only
to verify that the hardware supports irqs. The same test can
be done by checking set_alarm instead.

This patch changes the the read_alarm check to set_alarm, and then
removes the read_alarm method and its implementations in the rt
drivers.

NOTE: I'm not 100% sure we won't later use this functionality from
the generic layer, so this patch should only go in after some
additional thought and discussion.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/interface.c      |    3 +-
 drivers/rtc/rtc-ab3100.c     |   34 -------------------
 drivers/rtc/rtc-ab8500.c     |   40 -----------------------
 drivers/rtc/rtc-at32ap700x.c |   14 --------
 drivers/rtc/rtc-at91rm9200.c |   22 ------------
 drivers/rtc/rtc-at91sam9.c   |   27 ---------------
 drivers/rtc/rtc-bfin.c       |   11 ------
 drivers/rtc/rtc-cmos.c       |   73 ------------------------------------------
 drivers/rtc/rtc-coh901331.c  |   14 --------
 drivers/rtc/rtc-davinci.c    |   38 ----------------------
 drivers/rtc/rtc-ds1286.c     |   24 --------------
 drivers/rtc/rtc-ds1305.c     |   62 +-----------------------------------
 drivers/rtc/rtc-ds1307.c     |   52 ------------------------------
 drivers/rtc/rtc-ds1374.c     |   43 ------------------------
 drivers/rtc/rtc-ds1511.c     |   18 ----------
 drivers/rtc/rtc-ds1553.c     |   16 ---------
 drivers/rtc/rtc-ds3232.c     |   48 ---------------------------
 drivers/rtc/rtc-efi.c        |   20 -----------
 drivers/rtc/rtc-fm3130.c     |   59 ----------------------------------
 drivers/rtc/rtc-imxdi.c      |   27 ---------------
 drivers/rtc/rtc-isl1208.c    |   40 -----------------------
 drivers/rtc/rtc-jz4740.c     |   19 -----------
 drivers/rtc/rtc-lpc32xx.c    |   14 --------
 drivers/rtc/rtc-m41t80.c     |   50 ----------------------------
 drivers/rtc/rtc-m48t59.c     |   48 ---------------------------
 drivers/rtc/rtc-max8925.c    |   31 ------------------
 drivers/rtc/rtc-max8998.c    |   32 ------------------
 drivers/rtc/rtc-mc13xxx.c    |   43 ------------------------
 drivers/rtc/rtc-mpc5121.c    |   13 -------
 drivers/rtc/rtc-mrst.c       |   32 ------------------
 drivers/rtc/rtc-mv.c         |   38 ----------------------
 drivers/rtc/rtc-mxc.c        |   18 ----------
 drivers/rtc/rtc-nuc900.c     |   12 -------
 drivers/rtc/rtc-omap.c       |   22 ------------
 drivers/rtc/rtc-pcap.c       |   21 ------------
 drivers/rtc/rtc-pcf50633.c   |   24 --------------
 drivers/rtc/rtc-pl030.c      |    9 -----
 drivers/rtc/rtc-pl031.c      |   29 ----------------
 drivers/rtc/rtc-pxa.c        |   16 ---------
 drivers/rtc/rtc-rs5c372.c    |   38 ----------------------
 drivers/rtc/rtc-rx8025.c     |   46 --------------------------
 drivers/rtc/rtc-s3c.c        |   61 -----------------------------------
 drivers/rtc/rtc-sa1100.c     |   12 -------
 drivers/rtc/rtc-sh.c         |   40 -----------------------
 drivers/rtc/rtc-stk17ta8.c   |   16 ---------
 drivers/rtc/rtc-stmp3xxx.c   |    9 -----
 drivers/rtc/rtc-test.c       |    7 ----
 drivers/rtc/rtc-twl.c        |   31 ------------------
 drivers/rtc/rtc-tx4939.c     |   30 -----------------
 drivers/rtc/rtc-vr41xx.c     |   20 -----------
 drivers/rtc/rtc-wm831x.c     |   36 --------------------
 drivers/rtc/rtc-wm8350.c     |   50 ----------------------------
 drivers/rtc/rtc-x1205.c      |   26 ---------------
 include/linux/rtc.h          |    1 -
 54 files changed, 3 insertions(+), 1576 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index cb2f072..14a43f5 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -125,7 +125,8 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		return err;
 	if (rtc->ops == NULL)
 		err = -ENODEV;
-	else if (!rtc->ops->read_alarm)
+	/* Here we check set_alarm to make sure irq support exists */
+	else if (!rtc->ops->set_alarm)
 		err = -EINVAL;
 	else {
 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index 261a07e..603e90b 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -110,39 +110,6 @@ static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return rtc_valid_tm(tm);
 }
 
-static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	unsigned long time;
-	u64 fat_time;
-	u8 buf[6];
-	u8 rtcval;
-	int err;
-
-	/* Figure out if alarm is enabled or not */
-	err = abx500_get_register_interruptible(dev, 0,
-						AB3100_RTC, &rtcval);
-	if (err)
-		return err;
-	if (rtcval & 0x04)
-		alarm->enabled = 1;
-	else
-		alarm->enabled = 0;
-	/* No idea how this could be represented */
-	alarm->pending = 0;
-	/* Read out alarm registers, only 4 bytes */
-	err = abx500_get_register_page_interruptible(dev, 0,
-						     AB3100_AL0, buf, 4);
-	if (err)
-		return err;
-	fat_time = ((u64) buf[3] << 40) | ((u64) buf[2] << 32) |
-		((u64) buf[1] << 24) | ((u64) buf[0] << 16);
-	time = (unsigned long) (fat_time / (u64) (AB3100_RTC_CLOCK_RATE * 2));
-
-	rtc_time_to_tm(time, &alarm->time);
-
-	return rtc_valid_tm(&alarm->time);
-}
-
 static int ab3100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	u8 regs[] = {AB3100_AL0, AB3100_AL1, AB3100_AL2, AB3100_AL3};
@@ -194,7 +161,6 @@ static int ab3100_rtc_irq_enable(struct device *dev, unsigned int enabled)
 static const struct rtc_class_ops ab3100_rtc_ops = {
 	.read_time	= ab3100_rtc_read_time,
 	.set_mmss	= ab3100_rtc_set_mmss,
-	.read_alarm	= ab3100_rtc_read_alarm,
 	.set_alarm	= ab3100_rtc_set_alarm,
 	.alarm_irq_enable = ab3100_rtc_irq_enable,
 };
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index e346705..67fea89 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -174,45 +174,6 @@ static int ab8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		AB8500_RTC_READ_REQ_REG, RTC_WRITE_REQUEST);
 }
 
-static int ab8500_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	int retval, i;
-	u8 rtc_ctrl, value;
-	unsigned char buf[ARRAY_SIZE(ab8500_rtc_alarm_regs)];
-	unsigned long secs, mins;
-
-	/* Check if the alarm is enabled or not */
-	retval = abx500_get_register_interruptible(dev, AB8500_RTC,
-		AB8500_RTC_STAT_REG, &rtc_ctrl);
-	if (retval < 0)
-		return retval;
-
-	if (rtc_ctrl & RTC_ALARM_ENA)
-		alarm->enabled = 1;
-	else
-		alarm->enabled = 0;
-
-	alarm->pending = 0;
-
-	for (i = 0; i < ARRAY_SIZE(ab8500_rtc_alarm_regs); i++) {
-		retval = abx500_get_register_interruptible(dev, AB8500_RTC,
-			ab8500_rtc_alarm_regs[i], &value);
-		if (retval < 0)
-			return retval;
-		buf[i] = value;
-	}
-
-	mins = (buf[0] << 16) | (buf[1] << 8) | (buf[2]);
-	secs = mins * 60;
-
-	/* Add back the initially subtracted number of seconds */
-	secs += get_elapsed_seconds(AB8500_RTC_EPOCH);
-
-	rtc_time_to_tm(secs, &alarm->time);
-
-	return rtc_valid_tm(&alarm->time);
-}
-
 static int ab8500_rtc_irq_enable(struct device *dev, unsigned int enabled)
 {
 	return abx500_mask_and_set_register_interruptible(dev, AB8500_RTC,
@@ -272,7 +233,6 @@ static irqreturn_t rtc_alarm_handler(int irq, void *data)
 static const struct rtc_class_ops ab8500_rtc_ops = {
 	.read_time		= ab8500_rtc_read_time,
 	.set_time		= ab8500_rtc_set_time,
-	.read_alarm		= ab8500_rtc_read_alarm,
 	.set_alarm		= ab8500_rtc_set_alarm,
 	.alarm_irq_enable	= ab8500_rtc_irq_enable,
 };
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index e725d51..6f6863d 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -91,19 +91,6 @@ static int at32_rtc_settime(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int at32_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
-
-	spin_lock_irq(&rtc->lock);
-	rtc_time_to_tm(rtc->alarm_time, &alrm->time);
-	alrm->enabled = rtc_readl(rtc, IMR) & RTC_BIT(IMR_TOPI) ? 1 : 0;
-	alrm->pending = rtc_readl(rtc, ISR) & RTC_BIT(ISR_TOPI) ? 1 : 0;
-	spin_unlock_irq(&rtc->lock);
-
-	return 0;
-}
-
 static int at32_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
@@ -190,7 +177,6 @@ static irqreturn_t at32_rtc_interrupt(int irq, void *dev_id)
 static struct rtc_class_ops at32_rtc_ops = {
 	.read_time	= at32_rtc_readtime,
 	.set_time	= at32_rtc_settime,
-	.read_alarm	= at32_rtc_readalarm,
 	.set_alarm	= at32_rtc_setalarm,
 	.alarm_irq_enable = at32_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 26d1cf5..30a48ac 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -125,27 +125,6 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 }
 
 /*
- * Read alarm time and date in RTC
- */
-static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct rtc_time *tm = &alrm->time;
-
-	at91_rtc_decodetime(AT91_RTC_TIMALR, AT91_RTC_CALALR, tm);
-	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
-	tm->tm_year = at91_alarm_year - 1900;
-
-	alrm->enabled = (at91_sys_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
-			? 1 : 0;
-
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
-		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
-		tm->tm_hour, tm->tm_min, tm->tm_sec);
-
-	return 0;
-}
-
-/*
  * Set alarm time and date in RTC
  */
 static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -272,7 +251,6 @@ static const struct rtc_class_ops at91_rtc_ops = {
 	.ioctl		= at91_rtc_ioctl,
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
-	.read_alarm	= at91_rtc_readalarm,
 	.set_alarm	= at91_rtc_setalarm,
 	.proc		= at91_rtc_proc,
 	.alarm_irq_enable = at91_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index c36749e..8d954bf 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -151,32 +151,6 @@ static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct sam9_rtc *rtc = dev_get_drvdata(dev);
-	struct rtc_time *tm = &alrm->time;
-	u32 alarm = rtt_readl(rtc, AR);
-	u32 offset;
-
-	offset = gpbr_readl(rtc);
-	if (offset == 0)
-		return -EILSEQ;
-
-	memset(alrm, 0, sizeof(*alrm));
-	if (alarm != ALARM_DISABLED && offset != 0) {
-		rtc_time_to_tm(offset + alarm, tm);
-
-		dev_dbg(dev, "%s: %4d-%02d-%02d %02d:%02d:%02d\n", "readalarm",
-			1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
-			tm->tm_hour, tm->tm_min, tm->tm_sec);
-
-		if (rtt_readl(rtc, MR) & AT91_RTT_ALMIEN)
-			alrm->enabled = 1;
-	}
-
-	return 0;
-}
-
 static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct sam9_rtc *rtc = dev_get_drvdata(dev);
@@ -306,7 +280,6 @@ static const struct rtc_class_ops at91_rtc_ops = {
 	.ioctl		= at91_rtc_ioctl,
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
-	.read_alarm	= at91_rtc_readalarm,
 	.set_alarm	= at91_rtc_setalarm,
 	.proc		= at91_rtc_proc,
 	.alarm_irq_enabled = at91_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 17971d9..9b846e4 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -311,16 +311,6 @@ static int bfin_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int bfin_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct bfin_rtc *rtc = dev_get_drvdata(dev);
-	dev_dbg_stamp(dev);
-	alrm->time = rtc->rtc_alarm;
-	bfin_rtc_sync_pending(dev);
-	alrm->enabled = !!(bfin_read_RTC_ICTL() & (RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
-	return 0;
-}
-
 static int bfin_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct bfin_rtc *rtc = dev_get_drvdata(dev);
@@ -361,7 +351,6 @@ static struct rtc_class_ops bfin_rtc_ops = {
 	.ioctl         = bfin_rtc_ioctl,
 	.read_time     = bfin_rtc_read_time,
 	.set_time      = bfin_rtc_set_time,
-	.read_alarm    = bfin_rtc_read_alarm,
 	.set_alarm     = bfin_rtc_set_alarm,
 	.proc          = bfin_rtc_proc,
 	.alarm_irq_enable = bfin_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index dc2a0ba..281af32 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -203,78 +203,6 @@ static int cmos_set_time(struct device *dev, struct rtc_time *t)
 	return set_rtc_time(t);
 }
 
-static int cmos_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char	rtc_control;
-
-	if (!is_valid_irq(cmos->irq))
-		return -EIO;
-
-	/* Basic alarms only support hour, minute, and seconds fields.
-	 * Some also support day and month, for alarms up to a year in
-	 * the future.
-	 */
-	t->time.tm_mday = -1;
-	t->time.tm_mon = -1;
-
-	spin_lock_irq(&rtc_lock);
-	t->time.tm_sec = CMOS_READ(RTC_SECONDS_ALARM);
-	t->time.tm_min = CMOS_READ(RTC_MINUTES_ALARM);
-	t->time.tm_hour = CMOS_READ(RTC_HOURS_ALARM);
-
-	if (cmos->day_alrm) {
-		/* ignore upper bits on readback per ACPI spec */
-		t->time.tm_mday = CMOS_READ(cmos->day_alrm) & 0x3f;
-		if (!t->time.tm_mday)
-			t->time.tm_mday = -1;
-
-		if (cmos->mon_alrm) {
-			t->time.tm_mon = CMOS_READ(cmos->mon_alrm);
-			if (!t->time.tm_mon)
-				t->time.tm_mon = -1;
-		}
-	}
-
-	rtc_control = CMOS_READ(RTC_CONTROL);
-	spin_unlock_irq(&rtc_lock);
-
-	if (!(rtc_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		if (((unsigned)t->time.tm_sec) < 0x60)
-			t->time.tm_sec = bcd2bin(t->time.tm_sec);
-		else
-			t->time.tm_sec = -1;
-		if (((unsigned)t->time.tm_min) < 0x60)
-			t->time.tm_min = bcd2bin(t->time.tm_min);
-		else
-			t->time.tm_min = -1;
-		if (((unsigned)t->time.tm_hour) < 0x24)
-			t->time.tm_hour = bcd2bin(t->time.tm_hour);
-		else
-			t->time.tm_hour = -1;
-
-		if (cmos->day_alrm) {
-			if (((unsigned)t->time.tm_mday) <= 0x31)
-				t->time.tm_mday = bcd2bin(t->time.tm_mday);
-			else
-				t->time.tm_mday = -1;
-
-			if (cmos->mon_alrm) {
-				if (((unsigned)t->time.tm_mon) <= 0x12)
-					t->time.tm_mon = bcd2bin(t->time.tm_mon)-1;
-				else
-					t->time.tm_mon = -1;
-			}
-		}
-	}
-	t->time.tm_year = -1;
-
-	t->enabled = !!(rtc_control & RTC_AIE);
-	t->pending = 0;
-
-	return 0;
-}
-
 static void cmos_checkintr(struct cmos_rtc *cmos, unsigned char rtc_control)
 {
 	unsigned char	rtc_intr;
@@ -435,7 +363,6 @@ static int cmos_procfs(struct device *dev, struct seq_file *seq)
 static const struct rtc_class_ops cmos_rtc_ops = {
 	.read_time		= cmos_read_time,
 	.set_time		= cmos_set_time,
-	.read_alarm		= cmos_read_alarm,
 	.set_alarm		= cmos_set_alarm,
 	.proc			= cmos_procfs,
 	.alarm_irq_enable	= cmos_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 316f484..a631853 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -101,19 +101,6 @@ static int coh901331_set_mmss(struct device *dev, unsigned long secs)
 	return 0;
 }
 
-static int coh901331_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct coh901331_port *rtap = dev_get_drvdata(dev);
-
-	clk_enable(rtap->clk);
-	rtc_time_to_tm(readl(rtap->virtbase + COH901331_ALARM), &alarm->time);
-	alarm->pending = readl(rtap->virtbase + COH901331_IRQ_EVENT) & 1U;
-	alarm->enabled = readl(rtap->virtbase + COH901331_IRQ_MASK) & 1U;
-	clk_disable(rtap->clk);
-
-	return 0;
-}
-
 static int coh901331_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct coh901331_port *rtap = dev_get_drvdata(dev);
@@ -145,7 +132,6 @@ static int coh901331_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static struct rtc_class_ops coh901331_ops = {
 	.read_time = coh901331_read_time,
 	.set_mmss = coh901331_set_mmss,
-	.read_alarm = coh901331_read_alarm,
 	.set_alarm = coh901331_set_alarm,
 	.alarm_irq_enable = coh901331_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index dfd98a2..1fce4e0 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -387,43 +387,6 @@ static int davinci_rtc_alarm_irq_enable(struct device *dev,
 	return 0;
 }
 
-static int davinci_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
-{
-	struct davinci_rtc *davinci_rtc = dev_get_drvdata(dev);
-	u16 days = 0;
-	u8 day0, day1;
-	unsigned long flags;
-
-	spin_lock_irqsave(&davinci_rtc_lock, flags);
-
-	davinci_rtcss_calendar_wait(davinci_rtc);
-	alm->time.tm_min = bcd2bin(rtcss_read(davinci_rtc, PRTCSS_RTC_AMIN));
-
-	davinci_rtcss_calendar_wait(davinci_rtc);
-	alm->time.tm_hour = bcd2bin(rtcss_read(davinci_rtc, PRTCSS_RTC_AHOUR));
-
-	davinci_rtcss_calendar_wait(davinci_rtc);
-	day0 = rtcss_read(davinci_rtc, PRTCSS_RTC_ADAY0);
-
-	davinci_rtcss_calendar_wait(davinci_rtc);
-	day1 = rtcss_read(davinci_rtc, PRTCSS_RTC_ADAY1);
-
-	spin_unlock_irqrestore(&davinci_rtc_lock, flags);
-	days |= day1;
-	days <<= 8;
-	days |= day0;
-
-	if (convertfromdays(days, &alm->time) < 0)
-		return -EINVAL;
-
-	alm->pending = !!(rtcss_read(davinci_rtc,
-			  PRTCSS_RTC_CCTRL) &
-			PRTCSS_RTC_CCTRL_AIEN);
-	alm->enabled = alm->pending && device_may_wakeup(dev);
-
-	return 0;
-}
-
 static int davinci_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct davinci_rtc *davinci_rtc = dev_get_drvdata(dev);
@@ -478,7 +441,6 @@ static struct rtc_class_ops davinci_rtc_ops = {
 	.read_time		= davinci_rtc_read_time,
 	.set_time		= davinci_rtc_set_time,
 	.alarm_irq_enable	= davinci_rtc_alarm_irq_enable,
-	.read_alarm		= davinci_rtc_read_alarm,
 	.set_alarm		= davinci_rtc_set_alarm,
 };
 
diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index 60ce696..4646417 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -267,29 +267,6 @@ static int ds1286_set_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int ds1286_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
-{
-	struct ds1286_priv *priv = dev_get_drvdata(dev);
-	unsigned char cmd;
-	unsigned long flags;
-
-	/*
-	 * Only the values that we read from the RTC are set. That
-	 * means only tm_wday, tm_hour, tm_min.
-	 */
-	spin_lock_irqsave(&priv->lock, flags);
-	alm->time.tm_min = ds1286_rtc_read(priv, RTC_MINUTES_ALARM) & 0x7f;
-	alm->time.tm_hour = ds1286_rtc_read(priv, RTC_HOURS_ALARM)  & 0x1f;
-	alm->time.tm_wday = ds1286_rtc_read(priv, RTC_DAY_ALARM)    & 0x07;
-	cmd = ds1286_rtc_read(priv, RTC_CMD);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	alm->time.tm_min = bcd2bin(alm->time.tm_min);
-	alm->time.tm_hour = bcd2bin(alm->time.tm_hour);
-	alm->time.tm_sec = 0;
-	return 0;
-}
-
 static int ds1286_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct ds1286_priv *priv = dev_get_drvdata(dev);
@@ -324,7 +301,6 @@ static const struct rtc_class_ops ds1286_ops = {
 	.proc		= ds1286_proc,
 	.read_time	= ds1286_read_time,
 	.set_time	= ds1286_set_time,
-	.read_alarm	= ds1286_read_alarm,
 	.set_alarm	= ds1286_set_alarm,
 	.alarm_irq_enable = ds1286_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
index 57fbcc1..8189b1b 100644
--- a/drivers/rtc/rtc-ds1305.c
+++ b/drivers/rtc/rtc-ds1305.c
@@ -241,7 +241,7 @@ static int ds1305_set_time(struct device *dev, struct rtc_time *time)
 }
 
 /*
- * Get/set of alarm is a bit funky:
+ * Set of alarm is a bit funky:
  *
  * - First there's the inherent raciness of getting the (partitioned)
  *   status of an alarm that could trigger while we're reading parts
@@ -271,65 +271,6 @@ static int ds1305_set_time(struct device *dev, struct rtc_time *time)
 /*
  * Context: caller holds rtc->ops_lock (to protect ds1305->ctrl)
  */
-static int ds1305_get_alarm(struct device *dev, struct rtc_wkalrm *alm)
-{
-	struct ds1305	*ds1305 = dev_get_drvdata(dev);
-	struct spi_device *spi = ds1305->spi;
-	u8		addr;
-	int		status;
-	u8		buf[DS1305_ALM_LEN];
-
-	/* Refresh control register cache BEFORE reading ALM0 registers,
-	 * since reading alarm registers acks any pending IRQ.  That
-	 * makes returning "pending" status a bit of a lie, but that bit
-	 * of EFI status is at best fragile anyway (given IRQ handlers).
-	 */
-	addr = DS1305_CONTROL;
-	status = spi_write_then_read(spi, &addr, sizeof addr,
-			ds1305->ctrl, sizeof ds1305->ctrl);
-	if (status < 0)
-		return status;
-
-	alm->enabled = !!(ds1305->ctrl[0] & DS1305_AEI0);
-	alm->pending = !!(ds1305->ctrl[1] & DS1305_AEI0);
-
-	/* get and check ALM0 registers */
-	addr = DS1305_ALM0(DS1305_SEC);
-	status = spi_write_then_read(spi, &addr, sizeof addr,
-			buf, sizeof buf);
-	if (status < 0)
-		return status;
-
-	dev_vdbg(dev, "%s: %02x %02x %02x %02x\n",
-		"alm0 read", buf[DS1305_SEC], buf[DS1305_MIN],
-		buf[DS1305_HOUR], buf[DS1305_WDAY]);
-
-	if ((DS1305_ALM_DISABLE & buf[DS1305_SEC])
-			|| (DS1305_ALM_DISABLE & buf[DS1305_MIN])
-			|| (DS1305_ALM_DISABLE & buf[DS1305_HOUR]))
-		return -EIO;
-
-	/* Stuff these values into alm->time and let RTC framework code
-	 * fill in the rest ... and also handle rollover to tomorrow when
-	 * that's needed.
-	 */
-	alm->time.tm_sec = bcd2bin(buf[DS1305_SEC]);
-	alm->time.tm_min = bcd2bin(buf[DS1305_MIN]);
-	alm->time.tm_hour = bcd2hour(buf[DS1305_HOUR]);
-	alm->time.tm_mday = -1;
-	alm->time.tm_mon = -1;
-	alm->time.tm_year = -1;
-	/* next three fields are unused by Linux */
-	alm->time.tm_wday = -1;
-	alm->time.tm_mday = -1;
-	alm->time.tm_isdst = -1;
-
-	return 0;
-}
-
-/*
- * Context: caller holds rtc->ops_lock (to protect ds1305->ctrl)
- */
 static int ds1305_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct ds1305	*ds1305 = dev_get_drvdata(dev);
@@ -445,7 +386,6 @@ done:
 static const struct rtc_class_ops ds1305_ops = {
 	.read_time	= ds1305_get_time,
 	.set_time	= ds1305_set_time,
-	.read_alarm	= ds1305_get_alarm,
 	.set_alarm	= ds1305_set_alarm,
 	.proc		= ds1305_proc,
 	.alarm_irq_enable = ds1305_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 4724ba3..798cb1d 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -381,57 +381,6 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 	return 0;
 }
 
-static int ds1337_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct i2c_client       *client = to_i2c_client(dev);
-	struct ds1307		*ds1307 = i2c_get_clientdata(client);
-	int			ret;
-
-	if (!test_bit(HAS_ALARM, &ds1307->flags))
-		return -EINVAL;
-
-	/* read all ALARM1, ALARM2, and status registers at once */
-	ret = ds1307->read_block_data(client,
-			DS1339_REG_ALARM1_SECS, 9, ds1307->regs);
-	if (ret != 9) {
-		dev_err(dev, "%s error %d\n", "alarm read", ret);
-		return -EIO;
-	}
-
-	dev_dbg(dev, "%s: %02x %02x %02x %02x, %02x %02x %02x, %02x %02x\n",
-			"alarm read",
-			ds1307->regs[0], ds1307->regs[1],
-			ds1307->regs[2], ds1307->regs[3],
-			ds1307->regs[4], ds1307->regs[5],
-			ds1307->regs[6], ds1307->regs[7],
-			ds1307->regs[8]);
-
-	/* report alarm time (ALARM1); assume 24 hour and day-of-month modes,
-	 * and that all four fields are checked matches
-	 */
-	t->time.tm_sec = bcd2bin(ds1307->regs[0] & 0x7f);
-	t->time.tm_min = bcd2bin(ds1307->regs[1] & 0x7f);
-	t->time.tm_hour = bcd2bin(ds1307->regs[2] & 0x3f);
-	t->time.tm_mday = bcd2bin(ds1307->regs[3] & 0x3f);
-	t->time.tm_mon = -1;
-	t->time.tm_year = -1;
-	t->time.tm_wday = -1;
-	t->time.tm_yday = -1;
-	t->time.tm_isdst = -1;
-
-	/* ... and status */
-	t->enabled = !!(ds1307->regs[7] & DS1337_BIT_A1IE);
-	t->pending = !!(ds1307->regs[8] & DS1337_BIT_A1I);
-
-	dev_dbg(dev, "%s secs=%d, mins=%d, "
-		"hours=%d, mday=%d, enabled=%d, pending=%d\n",
-		"alarm read", t->time.tm_sec, t->time.tm_min,
-		t->time.tm_hour, t->time.tm_mday,
-		t->enabled, t->pending);
-
-	return 0;
-}
-
 static int ds1337_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client       *client = to_i2c_client(dev);
@@ -523,7 +472,6 @@ static int ds1307_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static const struct rtc_class_ops ds13xx_rtc_ops = {
 	.read_time	= ds1307_get_time,
 	.set_time	= ds1307_set_time,
-	.read_alarm	= ds1337_read_alarm,
 	.set_alarm	= ds1337_set_alarm,
 	.alarm_irq_enable = ds1307_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index d834a63..976a795 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -162,48 +162,6 @@ static int ds1374_set_time(struct device *dev, struct rtc_time *time)
 	return ds1374_write_rtc(client, itime, DS1374_REG_TOD0, 4);
 }
 
-/* The ds1374 has a decrementer for an alarm, rather than a comparator.
- * If the time of day is changed, then the alarm will need to be
- * reset.
- */
-static int ds1374_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds1374 *ds1374 = i2c_get_clientdata(client);
-	u32 now, cur_alarm;
-	int cr, sr;
-	int ret = 0;
-
-	if (client->irq <= 0)
-		return -EINVAL;
-
-	mutex_lock(&ds1374->mutex);
-
-	cr = ret = i2c_smbus_read_byte_data(client, DS1374_REG_CR);
-	if (ret < 0)
-		goto out;
-
-	sr = ret = i2c_smbus_read_byte_data(client, DS1374_REG_SR);
-	if (ret < 0)
-		goto out;
-
-	ret = ds1374_read_rtc(client, &now, DS1374_REG_TOD0, 4);
-	if (ret)
-		goto out;
-
-	ret = ds1374_read_rtc(client, &cur_alarm, DS1374_REG_WDALM0, 3);
-	if (ret)
-		goto out;
-
-	rtc_time_to_tm(now + cur_alarm, &alarm->time);
-	alarm->enabled = !!(cr & DS1374_REG_CR_WACE);
-	alarm->pending = !!(sr & DS1374_REG_SR_AF);
-
-out:
-	mutex_unlock(&ds1374->mutex);
-	return ret;
-}
-
 static int ds1374_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -335,7 +293,6 @@ out:
 static const struct rtc_class_ops ds1374_rtc_ops = {
 	.read_time = ds1374_read_time,
 	.set_time = ds1374_set_time,
-	.read_alarm = ds1374_read_alarm,
 	.set_alarm = ds1374_set_alarm,
 	.alarm_irq_enable = ds1374_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 3fffd70..98288a6 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -341,23 +341,6 @@ ds1511_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return 0;
 }
 
- static int
-ds1511_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq <= 0)
-		return -EINVAL;
-
-	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
-	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
-	alrm->time.tm_min = pdata->alrm_min < 0 ? 0 : pdata->alrm_min;
-	alrm->time.tm_sec = pdata->alrm_sec < 0 ? 0 : pdata->alrm_sec;
-	alrm->enabled = (pdata->irqen & RTC_AF) ? 1 : 0;
-	return 0;
-}
-
  static irqreturn_t
 ds1511_interrupt(int irq, void *dev_id)
 {
@@ -400,7 +383,6 @@ static int ds1511_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static const struct rtc_class_ops ds1511_rtc_ops = {
 	.read_time		= ds1511_rtc_read_time,
 	.set_time		= ds1511_rtc_set_time,
-	.read_alarm		= ds1511_rtc_read_alarm,
 	.set_alarm		= ds1511_rtc_set_alarm,
 	.alarm_irq_enable	= ds1511_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index fee41b9..43d6763 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -175,21 +175,6 @@ static int ds1553_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return 0;
 }
 
-static int ds1553_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq <= 0)
-		return -EINVAL;
-	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
-	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
-	alrm->time.tm_min = pdata->alrm_min < 0 ? 0 : pdata->alrm_min;
-	alrm->time.tm_sec = pdata->alrm_sec < 0 ? 0 : pdata->alrm_sec;
-	alrm->enabled = (pdata->irqen & RTC_AF) ? 1 : 0;
-	return 0;
-}
-
 static irqreturn_t ds1553_rtc_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
@@ -230,7 +215,6 @@ static int ds1553_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static const struct rtc_class_ops ds1553_rtc_ops = {
 	.read_time		= ds1553_rtc_read_time,
 	.set_time		= ds1553_rtc_set_time,
-	.read_alarm		= ds1553_rtc_read_alarm,
 	.set_alarm		= ds1553_rtc_set_alarm,
 	.alarm_irq_enable	= ds1553_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-ds3232.c b/drivers/rtc/rtc-ds3232.c
index 7608b1b..57c00b8 100644
--- a/drivers/rtc/rtc-ds3232.c
+++ b/drivers/rtc/rtc-ds3232.c
@@ -177,53 +177,6 @@ static int ds3232_set_time(struct device *dev, struct rtc_time *time)
 }
 
 /*
- * DS3232 has two alarm, we only use alarm1
- * According to linux specification, only support one-shot alarm
- * no periodic alarm mode
- */
-static int ds3232_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct ds3232 *ds3232 = i2c_get_clientdata(client);
-	int control, stat;
-	int ret;
-	u8 buf[4];
-
-	mutex_lock(&ds3232->mutex);
-
-	ret = i2c_smbus_read_byte_data(client, DS3232_REG_SR);
-	if (ret < 0)
-		goto out;
-	stat = ret;
-	ret = i2c_smbus_read_byte_data(client, DS3232_REG_CR);
-	if (ret < 0)
-		goto out;
-	control = ret;
-	ret = i2c_smbus_read_i2c_block_data(client, DS3232_REG_ALARM1, 4, buf);
-	if (ret < 0)
-		goto out;
-
-	alarm->time.tm_sec = bcd2bin(buf[0] & 0x7F);
-	alarm->time.tm_min = bcd2bin(buf[1] & 0x7F);
-	alarm->time.tm_hour = bcd2bin(buf[2] & 0x7F);
-	alarm->time.tm_mday = bcd2bin(buf[3] & 0x7F);
-
-	alarm->time.tm_mon = -1;
-	alarm->time.tm_year = -1;
-	alarm->time.tm_wday = -1;
-	alarm->time.tm_yday = -1;
-	alarm->time.tm_isdst = -1;
-
-	alarm->enabled = !!(control & DS3232_REG_CR_A1IE);
-	alarm->pending = !!(stat & DS3232_REG_SR_A1F);
-
-	ret = 0;
-out:
-	mutex_unlock(&ds3232->mutex);
-	return ret;
-}
-
-/*
  * linux rtc-module does not support wday alarm
  * and only 24h time mode supported indeed
  */
@@ -382,7 +335,6 @@ unlock:
 static const struct rtc_class_ops ds3232_rtc_ops = {
 	.read_time = ds3232_read_time,
 	.set_time = ds3232_set_time,
-	.read_alarm = ds3232_read_alarm,
 	.set_alarm = ds3232_set_alarm,
 	.alarm_irq_enable = ds3232_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 5502923..7c3c10b 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -106,25 +106,6 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	}
 }
 
-static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
-{
-	efi_time_t eft;
-	efi_status_t status;
-
-	/*
-	 * As of EFI v1.10, this call always returns an unsupported status
-	 */
-	status = efi.get_wakeup_time((efi_bool_t *)&wkalrm->enabled,
-				     (efi_bool_t *)&wkalrm->pending, &eft);
-
-	if (status != EFI_SUCCESS)
-		return -EINVAL;
-
-	convert_from_efi_time(&eft, &wkalrm->time);
-
-	return rtc_valid_tm(&wkalrm->time);
-}
-
 static int efi_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 {
 	efi_time_t eft;
@@ -181,7 +162,6 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
 static const struct rtc_class_ops efi_rtc_ops = {
 	.read_time = efi_read_time,
 	.set_time = efi_set_time,
-	.read_alarm = efi_read_alarm,
 	.set_alarm = efi_set_alarm,
 };
 
diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index 4cf2e70..d3832e2 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -199,64 +199,6 @@ static int fm3130_set_time(struct device *dev, struct rtc_time *t)
 	return 0;
 }
 
-static int fm3130_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct fm3130 *fm3130 = dev_get_drvdata(dev);
-	int tmp;
-	struct rtc_time *tm = &alrm->time;
-
-	if (!fm3130->alarm_valid) {
-		/*
-		 * We have invalid alarm in RTC, probably due to battery faults
-		 * or other problems. Return EIO for now, it will allow us to
-		 * set alarm value later instead of error during probing which
-		 * disables device
-		 */
-		return -EIO;
-	}
-
-	/* read the RTC alarm registers all at once */
-	tmp = i2c_transfer(to_i2c_adapter(fm3130->client->dev.parent),
-			&fm3130->msg[2], 2);
-	if (tmp != 2) {
-		dev_err(dev, "%s error %d\n", "read", tmp);
-		return -EIO;
-	}
-	dev_dbg(dev, "alarm read %02x %02x %02x %02x %02x\n",
-			fm3130->regs[FM3130_ALARM_SECONDS],
-			fm3130->regs[FM3130_ALARM_MINUTES],
-			fm3130->regs[FM3130_ALARM_HOURS],
-			fm3130->regs[FM3130_ALARM_DATE],
-			fm3130->regs[FM3130_ALARM_MONTHS]);
-
-	tm->tm_sec	= bcd2bin(fm3130->regs[FM3130_ALARM_SECONDS] & 0x7F);
-	tm->tm_min	= bcd2bin(fm3130->regs[FM3130_ALARM_MINUTES] & 0x7F);
-	tm->tm_hour	= bcd2bin(fm3130->regs[FM3130_ALARM_HOURS] & 0x3F);
-	tm->tm_mday	= bcd2bin(fm3130->regs[FM3130_ALARM_DATE] & 0x3F);
-	tm->tm_mon	= bcd2bin(fm3130->regs[FM3130_ALARM_MONTHS] & 0x1F);
-
-	if (tm->tm_mon > 0)
-		tm->tm_mon -= 1; /* RTC is 1-12, tm_mon is 0-11 */
-
-	dev_dbg(dev, "%s secs=%d, mins=%d, "
-		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
-		"read alarm", tm->tm_sec, tm->tm_min,
-		tm->tm_hour, tm->tm_mday,
-		tm->tm_mon, tm->tm_year, tm->tm_wday);
-
-	/* check if alarm enabled */
-	fm3130->regs[FM3130_RTC_CONTROL] =
-		i2c_smbus_read_byte_data(fm3130->client, FM3130_RTC_CONTROL);
-
-	if ((fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_AEN) &&
-		(~fm3130->regs[FM3130_RTC_CONTROL] &
-			FM3130_RTC_CONTROL_BIT_CAL)) {
-		alrm->enabled = 1;
-	}
-
-	return 0;
-}
-
 static int fm3130_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct fm3130 *fm3130 = dev_get_drvdata(dev);
@@ -354,7 +296,6 @@ static int fm3130_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static const struct rtc_class_ops fm3130_rtc_ops = {
 	.read_time	= fm3130_get_time,
 	.set_time	= fm3130_set_time,
-	.read_alarm	= fm3130_read_alarm,
 	.set_alarm	= fm3130_set_alarm,
 	.alarm_irq_enable = fm3130_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 2dd3c01..d4bb555 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -233,32 +233,6 @@ static int dryice_rtc_alarm_irq_enable(struct device *dev,
 }
 
 /*
- * read the seconds portion of the alarm register.
- * the fractional part of the alarm register is always zero.
- */
-static int dryice_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct imxdi_dev *imxdi = dev_get_drvdata(dev);
-	u32 dcamr;
-
-	dcamr = __raw_readl(imxdi->ioaddr + DCAMR);
-	rtc_time_to_tm(dcamr, &alarm->time);
-
-	/* alarm is enabled if the interrupt is enabled */
-	alarm->enabled = (__raw_readl(imxdi->ioaddr + DIER) & DIER_CAIE) != 0;
-
-	/* don't allow the DSR read to mess up DSR_WCF */
-	mutex_lock(&imxdi->write_mutex);
-
-	/* alarm is pending if the alarm flag is set */
-	alarm->pending = (__raw_readl(imxdi->ioaddr + DSR) & DSR_CAF) != 0;
-
-	mutex_unlock(&imxdi->write_mutex);
-
-	return 0;
-}
-
-/*
  * set the seconds portion of dryice alarm register
  */
 static int dryice_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
@@ -294,7 +268,6 @@ static struct rtc_class_ops dryice_rtc_ops = {
 	.read_time		= dryice_rtc_read_time,
 	.set_mmss		= dryice_rtc_set_mmss,
 	.alarm_irq_enable	= dryice_rtc_alarm_irq_enable,
-	.read_alarm		= dryice_rtc_read_alarm,
 	.set_alarm		= dryice_rtc_set_alarm,
 };
 
diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index 468200c..53ad598 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -284,39 +284,6 @@ isl1208_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
 }
 
 static int
-isl1208_i2c_read_alarm(struct i2c_client *client, struct rtc_wkalrm *alarm)
-{
-	struct rtc_time *const tm = &alarm->time;
-	u8 regs[ISL1208_ALARM_SECTION_LEN] = { 0, };
-	int sr;
-
-	sr = isl1208_i2c_get_sr(client);
-	if (sr < 0) {
-		dev_err(&client->dev, "%s: reading SR failed\n", __func__);
-		return sr;
-	}
-
-	sr = isl1208_i2c_read_regs(client, ISL1208_REG_SCA, regs,
-				   ISL1208_ALARM_SECTION_LEN);
-	if (sr < 0) {
-		dev_err(&client->dev, "%s: reading alarm section failed\n",
-			__func__);
-		return sr;
-	}
-
-	/* MSB of each alarm register is an enable bit */
-	tm->tm_sec = bcd2bin(regs[ISL1208_REG_SCA - ISL1208_REG_SCA] & 0x7f);
-	tm->tm_min = bcd2bin(regs[ISL1208_REG_MNA - ISL1208_REG_SCA] & 0x7f);
-	tm->tm_hour = bcd2bin(regs[ISL1208_REG_HRA - ISL1208_REG_SCA] & 0x3f);
-	tm->tm_mday = bcd2bin(regs[ISL1208_REG_DTA - ISL1208_REG_SCA] & 0x3f);
-	tm->tm_mon =
-		bcd2bin(regs[ISL1208_REG_MOA - ISL1208_REG_SCA] & 0x1f) - 1;
-	tm->tm_wday = bcd2bin(regs[ISL1208_REG_DWA - ISL1208_REG_SCA] & 0x03);
-
-	return 0;
-}
-
-static int
 isl1208_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	return isl1208_i2c_read_time(to_i2c_client(dev), tm);
@@ -385,17 +352,10 @@ isl1208_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return isl1208_i2c_set_time(to_i2c_client(dev), tm);
 }
 
-static int
-isl1208_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	return isl1208_i2c_read_alarm(to_i2c_client(dev), alarm);
-}
-
 static const struct rtc_class_ops isl1208_rtc_ops = {
 	.proc = isl1208_rtc_proc,
 	.read_time = isl1208_rtc_read_time,
 	.set_time = isl1208_rtc_set_time,
-	.read_alarm = isl1208_rtc_read_alarm,
 	/*.set_alarm    = isl1208_rtc_set_alarm, */
 };
 
diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index b647363..37608e2 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -134,24 +134,6 @@ static int jz4740_rtc_set_mmss(struct device *dev, unsigned long secs)
 	return jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC, secs);
 }
 
-static int jz4740_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct jz4740_rtc *rtc = dev_get_drvdata(dev);
-	uint32_t secs;
-	uint32_t ctrl;
-
-	secs = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SEC_ALARM);
-
-	ctrl = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_CTRL);
-
-	alrm->enabled = !!(ctrl & JZ_RTC_CTRL_AE);
-	alrm->pending = !!(ctrl & JZ_RTC_CTRL_AF);
-
-	rtc_time_to_tm(secs, &alrm->time);
-
-	return rtc_valid_tm(&alrm->time);
-}
-
 static int jz4740_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	int ret;
@@ -177,7 +159,6 @@ static int jz4740_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 static struct rtc_class_ops jz4740_rtc_ops = {
 	.read_time	= jz4740_rtc_read_time,
 	.set_mmss	= jz4740_rtc_set_mmss,
-	.read_alarm	= jz4740_rtc_read_alarm,
 	.set_alarm	= jz4740_rtc_set_alarm,
 	.alarm_irq_enable = jz4740_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index ec8701c..2ee02939 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -91,19 +91,6 @@ static int lpc32xx_rtc_set_mmss(struct device *dev, unsigned long secs)
 	return 0;
 }
 
-static int lpc32xx_rtc_read_alarm(struct device *dev,
-	struct rtc_wkalrm *wkalrm)
-{
-	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
-
-	rtc_time_to_tm(rtc_readl(rtc, LPC32XX_RTC_MATCH0), &wkalrm->time);
-	wkalrm->enabled = rtc->alarm_enabled;
-	wkalrm->pending = !!(rtc_readl(rtc, LPC32XX_RTC_INTSTAT) &
-		LPC32XX_RTC_INTSTAT_MATCH0);
-
-	return rtc_valid_tm(&wkalrm->time);
-}
-
 static int lpc32xx_rtc_set_alarm(struct device *dev,
 	struct rtc_wkalrm *wkalrm)
 {
@@ -191,7 +178,6 @@ static irqreturn_t lpc32xx_rtc_alarm_interrupt(int irq, void *dev)
 static const struct rtc_class_ops lpc32xx_rtc_ops = {
 	.read_time		= lpc32xx_rtc_read_time,
 	.set_mmss		= lpc32xx_rtc_set_mmss,
-	.read_alarm		= lpc32xx_rtc_read_alarm,
 	.set_alarm		= lpc32xx_rtc_set_alarm,
 	.alarm_irq_enable	= lpc32xx_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 69fe664..16b27ed 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -305,59 +305,9 @@ static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
-static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE + 1,
-			.buf	= buf,
-		},
-	};
-
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
-	}
-	t->time.tm_sec = -1;
-	t->time.tm_min = -1;
-	t->time.tm_hour = -1;
-	t->time.tm_mday = -1;
-	t->time.tm_mon = -1;
-	if (!(reg[M41T80_REG_ALARM_SEC] & 0x80))
-		t->time.tm_sec = bcd2bin(reg[M41T80_REG_ALARM_SEC] & 0x7f);
-	if (!(reg[M41T80_REG_ALARM_MIN] & 0x80))
-		t->time.tm_min = bcd2bin(reg[M41T80_REG_ALARM_MIN] & 0x7f);
-	if (!(reg[M41T80_REG_ALARM_HOUR] & 0x80))
-		t->time.tm_hour = bcd2bin(reg[M41T80_REG_ALARM_HOUR] & 0x3f);
-	if (!(reg[M41T80_REG_ALARM_DAY] & 0x80))
-		t->time.tm_mday = bcd2bin(reg[M41T80_REG_ALARM_DAY] & 0x3f);
-	if (!(reg[M41T80_REG_ALARM_DAY] & 0x40))
-		t->time.tm_mon = bcd2bin(reg[M41T80_REG_ALARM_MON] & 0x1f) - 1;
-	t->time.tm_year = -1;
-	t->time.tm_wday = -1;
-	t->time.tm_yday = -1;
-	t->time.tm_isdst = -1;
-	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
-	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
-	return 0;
-}
-
 static struct rtc_class_ops m41t80_rtc_ops = {
 	.read_time = m41t80_rtc_read_time,
 	.set_time = m41t80_rtc_set_time,
-	.read_alarm = m41t80_rtc_read_alarm,
 	.set_alarm = m41t80_rtc_set_alarm,
 	.proc = m41t80_rtc_proc,
 	.alarm_irq_enable = m41t80_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 3978f4c..1b34c88 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -153,53 +153,6 @@ static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
 }
 
 /*
- * Read alarm time and date in RTC
- */
-static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
-	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
-	struct rtc_time *tm = &alrm->time;
-	unsigned long flags;
-	u8 val;
-
-	/* If no irq, we don't support ALARM */
-	if (m48t59->irq == NO_IRQ)
-		return -EIO;
-
-	spin_lock_irqsave(&m48t59->lock, flags);
-	/* Issue the READ command */
-	M48T59_SET_BITS(M48T59_CNTL_READ, M48T59_CNTL);
-
-	tm->tm_year = bcd2bin(M48T59_READ(M48T59_YEAR));
-#ifdef CONFIG_SPARC
-	/* Sun SPARC machines count years since 1968 */
-	tm->tm_year += 68;
-#endif
-	/* tm_mon is 0-11 */
-	tm->tm_mon = bcd2bin(M48T59_READ(M48T59_MONTH)) - 1;
-
-	val = M48T59_READ(M48T59_WDAY);
-	if ((val & M48T59_WDAY_CEB) && (val & M48T59_WDAY_CB))
-		tm->tm_year += 100;	/* one century */
-
-	tm->tm_mday = bcd2bin(M48T59_READ(M48T59_ALARM_DATE));
-	tm->tm_hour = bcd2bin(M48T59_READ(M48T59_ALARM_HOUR));
-	tm->tm_min = bcd2bin(M48T59_READ(M48T59_ALARM_MIN));
-	tm->tm_sec = bcd2bin(M48T59_READ(M48T59_ALARM_SEC));
-
-	/* Clear the READ bit */
-	M48T59_CLEAR_BITS(M48T59_CNTL_READ, M48T59_CNTL);
-	spin_unlock_irqrestore(&m48t59->lock, flags);
-
-	dev_dbg(dev, "RTC read alarm time %04d-%02d-%02d %02d/%02d/%02d\n",
-		tm->tm_year + 1900, tm->tm_mon, tm->tm_mday,
-		tm->tm_hour, tm->tm_min, tm->tm_sec);
-	return rtc_valid_tm(tm);
-}
-
-/*
  * Set alarm time and date in RTC
  */
 static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -323,7 +276,6 @@ static irqreturn_t m48t59_rtc_interrupt(int irq, void *dev_id)
 static const struct rtc_class_ops m48t59_rtc_ops = {
 	.read_time	= m48t59_rtc_read_time,
 	.set_time	= m48t59_rtc_set_time,
-	.read_alarm	= m48t59_rtc_readalarm,
 	.set_alarm	= m48t59_rtc_setalarm,
 	.proc		= m48t59_rtc_proc,
 	.alarm_irq_enable = m48t59_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 174036d..4d18ea6 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -178,36 +178,6 @@ out:
 	return ret;
 }
 
-static int max8925_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct max8925_rtc_info *info = dev_get_drvdata(dev);
-	unsigned char buf[TIME_NUM];
-	int ret;
-
-	ret = max8925_bulk_read(info->rtc, MAX8925_ALARM0_SEC, TIME_NUM, buf);
-	if (ret < 0)
-		goto out;
-	ret = tm_calc(&alrm->time, buf, TIME_NUM);
-	if (ret < 0)
-		goto out;
-	ret = max8925_reg_read(info->rtc, MAX8925_RTC_IRQ_MASK);
-	if (ret < 0)
-		goto out;
-	if ((ret & ALARM0_IRQ) == 0)
-		alrm->enabled = 1;
-	else
-		alrm->enabled = 0;
-	ret = max8925_reg_read(info->rtc, MAX8925_RTC_STATUS);
-	if (ret < 0)
-		goto out;
-	if (ret & ALARM0_STATUS)
-		alrm->pending = 1;
-	else
-		alrm->pending = 0;
-out:
-	return ret;
-}
-
 static int max8925_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct max8925_rtc_info *info = dev_get_drvdata(dev);
@@ -231,7 +201,6 @@ out:
 static const struct rtc_class_ops max8925_rtc_ops = {
 	.read_time	= max8925_rtc_read_time,
 	.set_time	= max8925_rtc_set_time,
-	.read_alarm	= max8925_rtc_read_alarm,
 	.set_alarm	= max8925_rtc_set_alarm,
 };
 
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index 3f7bc6b..a0a6bbf 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -138,37 +138,6 @@ static int max8998_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int max8998_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct max8998_rtc_info *info = dev_get_drvdata(dev);
-	u8 data[8];
-	u8 val;
-	int ret;
-
-	ret = max8998_bulk_read(info->rtc, MAX8998_ALARM0_SEC, 8, data);
-	if (ret < 0)
-		return ret;
-
-	max8998_data_to_tm(data, &alrm->time);
-
-	ret = max8998_read_reg(info->rtc, MAX8998_ALARM0_CONF, &val);
-	if (ret < 0)
-		return ret;
-
-	alrm->enabled = !!val;
-
-	ret = max8998_read_reg(info->rtc, MAX8998_RTC_STATUS, &val);
-	if (ret < 0)
-		return ret;
-
-	if (val & ALARM0_STATUS)
-		alrm->pending = 1;
-	else
-		alrm->pending = 0;
-
-	return 0;
-}
-
 static int max8998_rtc_stop_alarm(struct max8998_rtc_info *info)
 {
 	int ret = max8998_write_reg(info->rtc, MAX8998_ALARM0_CONF, 0);
@@ -244,7 +213,6 @@ static irqreturn_t max8998_rtc_alarm_irq(int irq, void *data)
 static const struct rtc_class_ops max8998_rtc_ops = {
 	.read_time = max8998_rtc_read_time,
 	.set_time = max8998_rtc_set_time,
-	.read_alarm = max8998_rtc_read_alarm,
 	.set_alarm = max8998_rtc_set_alarm,
 	.alarm_irq_enable = max8998_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index c420064..974eaeb 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -167,48 +167,6 @@ out:
 	return ret;
 }
 
-static int mc13xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
-	unsigned seconds, days;
-	unsigned long s1970;
-	int enabled, pending;
-	int ret;
-
-	mc13xxx_lock(priv->mc13xxx);
-
-	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTODA, &seconds);
-	if (unlikely(ret))
-		goto out;
-	if (seconds >= 86400) {
-		ret = -ENODATA;
-		goto out;
-	}
-
-	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13xxx_irq_status(priv->mc13xxx, MC13XXX_IRQ_TODA,
-			&enabled, &pending);
-
-out:
-	mc13xxx_unlock(priv->mc13xxx);
-
-	if (ret)
-		return ret;
-
-	alarm->enabled = enabled;
-	alarm->pending = pending;
-
-	s1970 = days * 86400 + seconds;
-
-	rtc_time_to_tm(s1970, &alarm->time);
-	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
-
-	return 0;
-}
-
 static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
@@ -291,7 +249,6 @@ static int mc13xxx_rtc_alarm_irq_enable(struct device *dev,
 static const struct rtc_class_ops mc13xxx_rtc_ops = {
 	.read_time = mc13xxx_rtc_read_time,
 	.set_mmss = mc13xxx_rtc_set_mmss,
-	.read_alarm = mc13xxx_rtc_read_alarm,
 	.set_alarm = mc13xxx_rtc_set_alarm,
 	.alarm_irq_enable = mc13xxx_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index b40c1ff..7f2de4c 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -145,18 +145,6 @@ static int mpc5121_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int mpc5121_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
-	struct mpc5121_rtc_regs __iomem *regs = rtc->regs;
-
-	*alarm = rtc->wkalarm;
-
-	alarm->pending = in_8(&regs->alm_status);
-
-	return 0;
-}
-
 static int mpc5121_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct mpc5121_rtc_data *rtc = dev_get_drvdata(dev);
@@ -243,7 +231,6 @@ static int mpc5121_rtc_alarm_irq_enable(struct device *dev,
 static const struct rtc_class_ops mpc5121_rtc_ops = {
 	.read_time = mpc5121_rtc_read_time,
 	.set_time = mpc5121_rtc_set_time,
-	.read_alarm = mpc5121_rtc_read_alarm,
 	.set_alarm = mpc5121_rtc_set_alarm,
 	.alarm_irq_enable = mpc5121_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 4db96fa..e317d1e 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -127,37 +127,6 @@ static int mrst_set_time(struct device *dev, struct rtc_time *time)
 	return ret;
 }
 
-static int mrst_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct mrst_rtc	*mrst = dev_get_drvdata(dev);
-	unsigned char rtc_control;
-
-	if (mrst->irq <= 0)
-		return -EIO;
-
-	/* Basic alarms only support hour, minute, and seconds fields.
-	 * Some also support day and month, for alarms up to a year in
-	 * the future.
-	 */
-	t->time.tm_mday = -1;
-	t->time.tm_mon = -1;
-	t->time.tm_year = -1;
-
-	/* vRTC only supports binary mode */
-	spin_lock_irq(&rtc_lock);
-	t->time.tm_sec = vrtc_cmos_read(RTC_SECONDS_ALARM);
-	t->time.tm_min = vrtc_cmos_read(RTC_MINUTES_ALARM);
-	t->time.tm_hour = vrtc_cmos_read(RTC_HOURS_ALARM);
-
-	rtc_control = vrtc_cmos_read(RTC_CONTROL);
-	spin_unlock_irq(&rtc_lock);
-
-	t->enabled = !!(rtc_control & RTC_AIE);
-	t->pending = 0;
-
-	return 0;
-}
-
 static void mrst_checkintr(struct mrst_rtc *mrst, unsigned char rtc_control)
 {
 	unsigned char	rtc_intr;
@@ -279,7 +248,6 @@ static int mrst_procfs(struct device *dev, struct seq_file *seq)
 static const struct rtc_class_ops mrst_rtc_ops = {
 	.read_time	= mrst_read_time,
 	.set_time	= mrst_set_time,
-	.read_alarm	= mrst_read_alarm,
 	.set_alarm	= mrst_set_alarm,
 	.proc		= mrst_procfs,
 	.alarm_irq_enable = mrst_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index 60627a7..e9acc8b 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -92,43 +92,6 @@ static int mv_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return rtc_valid_tm(tm);
 }
 
-static int mv_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
-{
-	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
-	void __iomem *ioaddr = pdata->ioaddr;
-	u32	rtc_time, rtc_date;
-	unsigned int year, month, day, hour, minute, second, wday;
-
-	rtc_time = readl(ioaddr + RTC_ALARM_TIME_REG_OFFS);
-	rtc_date = readl(ioaddr + RTC_ALARM_DATE_REG_OFFS);
-
-	second = rtc_time & 0x7f;
-	minute = (rtc_time >> RTC_MINUTES_OFFS) & 0x7f;
-	hour = (rtc_time >> RTC_HOURS_OFFS) & 0x3f; /* assume 24 hours mode */
-	wday = (rtc_time >> RTC_WDAY_OFFS) & 0x7;
-
-	day = rtc_date & 0x3f;
-	month = (rtc_date >> RTC_MONTH_OFFS) & 0x3f;
-	year = (rtc_date >> RTC_YEAR_OFFS) & 0xff;
-
-	alm->time.tm_sec = bcd2bin(second);
-	alm->time.tm_min = bcd2bin(minute);
-	alm->time.tm_hour = bcd2bin(hour);
-	alm->time.tm_mday = bcd2bin(day);
-	alm->time.tm_wday = bcd2bin(wday);
-	alm->time.tm_mon = bcd2bin(month) - 1;
-	/* hw counts from year 2000, but tm_year is relative to 1900 */
-	alm->time.tm_year = bcd2bin(year) + 100;
-
-	if (rtc_valid_tm(&alm->time) < 0) {
-		dev_err(dev, "retrieved alarm date/time is not valid.\n");
-		rtc_time_to_tm(0, &alm->time);
-	}
-
-	alm->enabled = !!readl(ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
-	return 0;
-}
-
 static int mv_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
@@ -208,7 +171,6 @@ static const struct rtc_class_ops mv_rtc_ops = {
 static const struct rtc_class_ops mv_rtc_alarm_ops = {
 	.read_time	= mv_rtc_read_time,
 	.set_time	= mv_rtc_set_time,
-	.read_alarm	= mv_rtc_read_alarm,
 	.set_alarm	= mv_rtc_set_alarm,
 	.alarm_irq_enable = mv_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 826ab64..0c7fbff 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -305,23 +305,6 @@ static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 }
 
 /*
- * This function reads the current alarm value into the passed in 'alrm'
- * argument. It updates the alrm's pending field value based on the whether
- * an alarm interrupt occurs or not.
- */
-static int mxc_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-	void __iomem *ioaddr = pdata->ioaddr;
-
-	rtc_time_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
-	alrm->pending = ((readw(ioaddr + RTC_RTCISR) & RTC_ALM_BIT)) ? 1 : 0;
-
-	return 0;
-}
-
-/*
  * This function sets the RTC alarm based on passed in alrm.
  */
 static int mxc_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
@@ -359,7 +342,6 @@ static struct rtc_class_ops mxc_rtc_ops = {
 	.release		= mxc_rtc_release,
 	.read_time		= mxc_rtc_read_time,
 	.set_mmss		= mxc_rtc_set_mmss,
-	.read_alarm		= mxc_rtc_read_alarm,
 	.set_alarm		= mxc_rtc_set_alarm,
 	.alarm_irq_enable	= mxc_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 781068d..5aa7e3d 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -181,17 +181,6 @@ static int nuc900_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int nuc900_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
-	unsigned int timeval, carval;
-
-	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TAR);
-	carval	= __raw_readl(rtc->rtc_reg + REG_RTC_CAR);
-
-	return nuc900_rtc_bcd2bin(timeval, carval, &alrm->time);
-}
-
 static int nuc900_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct nuc900_rtc *rtc = dev_get_drvdata(dev);
@@ -217,7 +206,6 @@ static int nuc900_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 static struct rtc_class_ops nuc900_rtc_ops = {
 	.read_time = nuc900_rtc_read_time,
 	.set_time = nuc900_rtc_set_time,
-	.read_alarm = nuc900_rtc_read_alarm,
 	.set_alarm = nuc900_rtc_set_alarm,
 	.alarm_irq_enable = nuc900_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index b4dbf3a..7e03835 100644
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@ -262,27 +262,6 @@ static int omap_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int omap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
-{
-	local_irq_disable();
-	rtc_wait_not_busy();
-
-	alm->time.tm_sec = rtc_read(OMAP_RTC_ALARM_SECONDS_REG);
-	alm->time.tm_min = rtc_read(OMAP_RTC_ALARM_MINUTES_REG);
-	alm->time.tm_hour = rtc_read(OMAP_RTC_ALARM_HOURS_REG);
-	alm->time.tm_mday = rtc_read(OMAP_RTC_ALARM_DAYS_REG);
-	alm->time.tm_mon = rtc_read(OMAP_RTC_ALARM_MONTHS_REG);
-	alm->time.tm_year = rtc_read(OMAP_RTC_ALARM_YEARS_REG);
-
-	local_irq_enable();
-
-	bcd2tm(&alm->time);
-	alm->enabled = !!(rtc_read(OMAP_RTC_INTERRUPTS_REG)
-			& OMAP_RTC_INTERRUPTS_IT_ALARM);
-
-	return 0;
-}
-
 static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	u8 reg;
@@ -316,7 +295,6 @@ static struct rtc_class_ops omap_rtc_ops = {
 	.ioctl		= omap_rtc_ioctl,
 	.read_time	= omap_rtc_read_time,
 	.set_time	= omap_rtc_set_time,
-	.read_alarm	= omap_rtc_read_alarm,
 	.set_alarm	= omap_rtc_set_alarm,
 	.alarm_irq_enable = omap_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index a633abc..f91e20f 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -41,26 +41,6 @@ static irqreturn_t pcap_rtc_irq(int irq, void *_pcap_rtc)
 	return IRQ_HANDLED;
 }
 
-static int pcap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
-	struct rtc_time *tm = &alrm->time;
-	unsigned long secs;
-	u32 tod;	/* time of day, seconds since midnight */
-	u32 days;	/* days since 1/1/1970 */
-
-	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_TODA, &tod);
-	secs = tod & PCAP_RTC_TOD_MASK;
-
-	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, &days);
-	secs += (days & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
-
-	rtc_time_to_tm(secs, tm);
-
-	return 0;
-}
-
 static int pcap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -133,7 +113,6 @@ static int pcap_rtc_alarm_irq_enable(struct device *dev, unsigned int en)
 
 static const struct rtc_class_ops pcap_rtc_ops = {
 	.read_time = pcap_rtc_read_time,
-	.read_alarm = pcap_rtc_read_alarm,
 	.set_alarm = pcap_rtc_set_alarm,
 	.set_mmss = pcap_rtc_set_mmss,
 	.alarm_irq_enable = pcap_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index f90c574..bbf90b8 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -183,29 +183,6 @@ static int pcf50633_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int pcf50633_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct pcf50633_rtc *rtc;
-	struct pcf50633_time pcf_tm;
-	int ret = 0;
-
-	rtc = dev_get_drvdata(dev);
-
-	alrm->enabled = rtc->alarm_enabled;
-	alrm->pending = rtc->alarm_pending;
-
-	ret = pcf50633_read_block(rtc->pcf, PCF50633_REG_RTCSCA,
-				PCF50633_TI_EXTENT, &pcf_tm.time[0]);
-	if (ret != PCF50633_TI_EXTENT) {
-		dev_err(dev, "Failed to read time\n");
-		return -EIO;
-	}
-
-	pcf2rtc_time(&alrm->time, &pcf_tm);
-
-	return rtc_valid_tm(&alrm->time);
-}
-
 static int pcf50633_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pcf50633_rtc *rtc;
@@ -241,7 +218,6 @@ static int pcf50633_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 static struct rtc_class_ops pcf50633_rtc_ops = {
 	.read_time		= pcf50633_rtc_read_time,
 	.set_time		= pcf50633_rtc_set_time,
-	.read_alarm		= pcf50633_rtc_read_alarm,
 	.set_alarm		= pcf50633_rtc_set_alarm,
 	.alarm_irq_enable	= pcf50633_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index bbdb2f0..e7d982f 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -40,14 +40,6 @@ static int pl030_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 	return -ENOIOCTLCMD;
 }
 
-static int pl030_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct pl030_rtc *rtc = dev_get_drvdata(dev);
-
-	rtc_time_to_tm(readl(rtc->base + RTC_MR), &alrm->time);
-	return 0;
-}
-
 static int pl030_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pl030_rtc *rtc = dev_get_drvdata(dev);
@@ -99,7 +91,6 @@ static const struct rtc_class_ops pl030_ops = {
 	.ioctl		= pl030_ioctl,
 	.read_time	= pl030_read_time,
 	.set_time	= pl030_set_time,
-	.read_alarm	= pl030_read_alarm,
 	.set_alarm	= pl030_set_alarm,
 };
 
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index d829ea6..c2a9cdd 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -176,20 +176,6 @@ static int pl031_stv2_set_time(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int pl031_stv2_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct pl031_local *ldata = dev_get_drvdata(dev);
-	int ret;
-
-	ret = pl031_stv2_time_to_tm(readl(ldata->base + RTC_MR),
-			readl(ldata->base + RTC_YMR), &alarm->time);
-
-	alarm->pending = readl(ldata->base + RTC_RIS) & RTC_BIT_AI;
-	alarm->enabled = readl(ldata->base + RTC_IMSC) & RTC_BIT_AI;
-
-	return ret;
-}
-
 static int pl031_stv2_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
@@ -262,18 +248,6 @@ static int pl031_set_time(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int pl031_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
-{
-	struct pl031_local *ldata = dev_get_drvdata(dev);
-
-	rtc_time_to_tm(readl(ldata->base + RTC_MR), &alarm->time);
-
-	alarm->pending = readl(ldata->base + RTC_RIS) & RTC_BIT_AI;
-	alarm->enabled = readl(ldata->base + RTC_IMSC) & RTC_BIT_AI;
-
-	return 0;
-}
-
 static int pl031_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
@@ -377,7 +351,6 @@ err_req:
 static struct rtc_class_ops arm_pl031_ops = {
 	.read_time = pl031_read_time,
 	.set_time = pl031_set_time,
-	.read_alarm = pl031_read_alarm,
 	.set_alarm = pl031_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
 };
@@ -386,7 +359,6 @@ static struct rtc_class_ops arm_pl031_ops = {
 static struct rtc_class_ops stv1_pl031_ops = {
 	.read_time = pl031_read_time,
 	.set_time = pl031_set_time,
-	.read_alarm = pl031_read_alarm,
 	.set_alarm = pl031_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
 };
@@ -395,7 +367,6 @@ static struct rtc_class_ops stv1_pl031_ops = {
 static struct rtc_class_ops stv2_pl031_ops = {
 	.read_time = pl031_stv2_read_time,
 	.set_time = pl031_stv2_set_time,
-	.read_alarm = pl031_stv2_read_alarm,
 	.set_alarm = pl031_stv2_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index fc9f499..6e31dc3 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -246,21 +246,6 @@ static int pxa_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int pxa_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
-	u32 rtsr, ryar, rdar;
-
-	ryar = rtc_readl(pxa_rtc, RYAR1);
-	rdar = rtc_readl(pxa_rtc, RDAR1);
-	tm_calc(ryar, rdar, &alrm->time);
-
-	rtsr = rtc_readl(pxa_rtc, RTSR);
-	alrm->enabled = (rtsr & RTSR_RDALE1) ? 1 : 0;
-	alrm->pending = (rtsr & RTSR_RDAL1) ? 1 : 0;
-	return 0;
-}
-
 static int pxa_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
@@ -302,7 +287,6 @@ static const struct rtc_class_ops pxa_rtc_ops = {
 	.release = pxa_rtc_release,
 	.read_time = pxa_rtc_read_time,
 	.set_time = pxa_rtc_set_time,
-	.read_alarm = pxa_rtc_read_alarm,
 	.set_alarm = pxa_rtc_set_alarm,
 	.alarm_irq_enable = pxa_alarm_irq_enable,
 	.proc = pxa_rtc_proc,
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 6aaa155..ac1e57f 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -366,43 +366,6 @@ static int rs5c_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 }
 
 
-/* NOTE:  Since RTC_WKALM_{RD,SET} were originally defined for EFI,
- * which only exposes a polled programming interface; and since
- * these calls map directly to those EFI requests; we don't demand
- * we have an IRQ for this chip when we go through this API.
- *
- * The older x86_pc derived RTC_ALM_{READ,SET} calls require irqs
- * though, managed through RTC_AIE_{ON,OFF} requests.
- */
-
-static int rs5c_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct i2c_client	*client = to_i2c_client(dev);
-	struct rs5c372		*rs5c = i2c_get_clientdata(client);
-	int			status;
-
-	status = rs5c_get_regs(rs5c);
-	if (status < 0)
-		return status;
-
-	/* report alarm time */
-	t->time.tm_sec = 0;
-	t->time.tm_min = bcd2bin(rs5c->regs[RS5C_REG_ALARM_A_MIN] & 0x7f);
-	t->time.tm_hour = rs5c_reg2hr(rs5c, rs5c->regs[RS5C_REG_ALARM_A_HOURS]);
-	t->time.tm_mday = -1;
-	t->time.tm_mon = -1;
-	t->time.tm_year = -1;
-	t->time.tm_wday = -1;
-	t->time.tm_yday = -1;
-	t->time.tm_isdst = -1;
-
-	/* ... and status */
-	t->enabled = !!(rs5c->regs[RS5C_REG_CTRL1] & RS5C_CTRL1_AALE);
-	t->pending = !!(rs5c->regs[RS5C_REG_CTRL2] & RS5C_CTRL2_AAFG);
-
-	return 0;
-}
-
 static int rs5c_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client	*client = to_i2c_client(dev);
@@ -483,7 +446,6 @@ static const struct rtc_class_ops rs5c372_rtc_ops = {
 	.ioctl		= rs5c_rtc_ioctl,
 	.read_time	= rs5c372_rtc_read_time,
 	.set_time	= rs5c372_rtc_set_time,
-	.read_alarm	= rs5c_read_alarm,
 	.set_alarm	= rs5c_set_alarm,
 	.alarm_irq_enable = rs5c_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index fde172f..01fa5c7 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -315,51 +315,6 @@ out:
 }
 
 /* Alarm support */
-static int rx8025_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct rx8025_data *rx8025 = dev_get_drvdata(dev);
-	struct i2c_client *client = rx8025->client;
-	u8 ctrl2, ald[2];
-	int err;
-
-	if (client->irq <= 0)
-		return -EINVAL;
-
-	err = rx8025_read_regs(client, RX8025_REG_ALDMIN, 2, ald);
-	if (err)
-		return err;
-
-	err = rx8025_read_reg(client, RX8025_REG_CTRL2, &ctrl2);
-	if (err)
-		return err;
-
-	dev_dbg(dev, "%s: read alarm 0x%02x 0x%02x ctrl2 %02x\n",
-		__func__, ald[0], ald[1], ctrl2);
-
-	/* Hardware alarms precision is 1 minute! */
-	t->time.tm_sec = 0;
-	t->time.tm_min = bcd2bin(ald[0] & 0x7f);
-	if (rx8025->ctrl1 & RX8025_BIT_CTRL1_1224)
-		t->time.tm_hour = bcd2bin(ald[1] & 0x3f);
-	else
-		t->time.tm_hour = bcd2bin(ald[1] & 0x1f) % 12
-			+ (ald[1] & 0x20 ? 12 : 0);
-
-	t->time.tm_wday = -1;
-	t->time.tm_mday = -1;
-	t->time.tm_mon = -1;
-	t->time.tm_year = -1;
-
-	dev_dbg(dev, "%s: date: %ds %dm %dh %dmd %dm %dy\n",
-		__func__,
-		t->time.tm_sec, t->time.tm_min, t->time.tm_hour,
-		t->time.tm_mday, t->time.tm_mon, t->time.tm_year);
-	t->enabled = !!(rx8025->ctrl1 & RX8025_BIT_CTRL1_DALE);
-	t->pending = (ctrl2 & RX8025_BIT_CTRL2_DAFG) && t->enabled;
-
-	return err;
-}
-
 static int rx8025_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -427,7 +382,6 @@ static int rx8025_alarm_irq_enable(struct device *dev, unsigned int enabled)
 static struct rtc_class_ops rx8025_rtc_ops = {
 	.read_time = rx8025_get_time,
 	.set_time = rx8025_set_time,
-	.read_alarm = rx8025_read_alarm,
 	.set_alarm = rx8025_set_alarm,
 	.alarm_irq_enable = rx8025_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 6d60958..9239c2f 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -183,66 +183,6 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct rtc_time *alm_tm = &alrm->time;
-	void __iomem *base = s3c_rtc_base;
-	unsigned int alm_en;
-
-	alm_tm->tm_sec  = readb(base + S3C2410_ALMSEC);
-	alm_tm->tm_min  = readb(base + S3C2410_ALMMIN);
-	alm_tm->tm_hour = readb(base + S3C2410_ALMHOUR);
-	alm_tm->tm_mon  = readb(base + S3C2410_ALMMON);
-	alm_tm->tm_mday = readb(base + S3C2410_ALMDATE);
-	alm_tm->tm_year = readb(base + S3C2410_ALMYEAR);
-
-	alm_en = readb(base + S3C2410_RTCALM);
-
-	alrm->enabled = (alm_en & S3C2410_RTCALM_ALMEN) ? 1 : 0;
-
-	pr_debug("read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
-		 alm_en,
-		 1900 + alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
-		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
-
-
-	/* decode the alarm enable field */
-
-	if (alm_en & S3C2410_RTCALM_SECEN)
-		alm_tm->tm_sec = bcd2bin(alm_tm->tm_sec);
-	else
-		alm_tm->tm_sec = -1;
-
-	if (alm_en & S3C2410_RTCALM_MINEN)
-		alm_tm->tm_min = bcd2bin(alm_tm->tm_min);
-	else
-		alm_tm->tm_min = -1;
-
-	if (alm_en & S3C2410_RTCALM_HOUREN)
-		alm_tm->tm_hour = bcd2bin(alm_tm->tm_hour);
-	else
-		alm_tm->tm_hour = -1;
-
-	if (alm_en & S3C2410_RTCALM_DAYEN)
-		alm_tm->tm_mday = bcd2bin(alm_tm->tm_mday);
-	else
-		alm_tm->tm_mday = -1;
-
-	if (alm_en & S3C2410_RTCALM_MONEN) {
-		alm_tm->tm_mon = bcd2bin(alm_tm->tm_mon);
-		alm_tm->tm_mon -= 1;
-	} else {
-		alm_tm->tm_mon = -1;
-	}
-
-	if (alm_en & S3C2410_RTCALM_YEAREN)
-		alm_tm->tm_year = bcd2bin(alm_tm->tm_year);
-	else
-		alm_tm->tm_year = -1;
-
-	return 0;
-}
-
 static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct rtc_time *tm = &alrm->time;
@@ -344,7 +284,6 @@ static const struct rtc_class_ops s3c_rtcops = {
 	.release	= s3c_rtc_release,
 	.read_time	= s3c_rtc_gettime,
 	.set_time	= s3c_rtc_settime,
-	.read_alarm	= s3c_rtc_getalarm,
 	.set_alarm	= s3c_rtc_setalarm,
 	.proc		= s3c_rtc_proc,
 	.alarm_irq_enable = s3c_rtc_setaie,
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index d1a2b0b..df1804f 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -339,17 +339,6 @@ static int sa1100_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-static int sa1100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	u32	rtsr;
-
-	memcpy(&alrm->time, &rtc_alarm, sizeof(struct rtc_time));
-	rtsr = RTSR;
-	alrm->enabled = (rtsr & RTSR_ALE) ? 1 : 0;
-	alrm->pending = (rtsr & RTSR_AL) ? 1 : 0;
-	return 0;
-}
-
 static int sa1100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	int ret;
@@ -389,7 +378,6 @@ static const struct rtc_class_ops sa1100_rtc_ops = {
 	.ioctl = sa1100_rtc_ioctl,
 	.read_time = sa1100_rtc_read_time,
 	.set_time = sa1100_rtc_set_time,
-	.read_alarm = sa1100_rtc_read_alarm,
 	.set_alarm = sa1100_rtc_set_alarm,
 	.proc = sa1100_rtc_proc,
 	.alarm_irq_enable = sa1100_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 1485449..956c6fb 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -473,45 +473,6 @@ static int sh_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return 0;
 }
 
-static inline int sh_rtc_read_alarm_value(struct sh_rtc *rtc, int reg_off)
-{
-	unsigned int byte;
-	int value = 0xff;	/* return 0xff for ignored values */
-
-	byte = readb(rtc->regbase + reg_off);
-	if (byte & AR_ENB) {
-		byte &= ~AR_ENB;	/* strip the enable bit */
-		value = bcd2bin(byte);
-	}
-
-	return value;
-}
-
-static int sh_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct sh_rtc *rtc = platform_get_drvdata(pdev);
-	struct rtc_time *tm = &wkalrm->time;
-
-	spin_lock_irq(&rtc->lock);
-
-	tm->tm_sec	= sh_rtc_read_alarm_value(rtc, RSECAR);
-	tm->tm_min	= sh_rtc_read_alarm_value(rtc, RMINAR);
-	tm->tm_hour	= sh_rtc_read_alarm_value(rtc, RHRAR);
-	tm->tm_wday	= sh_rtc_read_alarm_value(rtc, RWKAR);
-	tm->tm_mday	= sh_rtc_read_alarm_value(rtc, RDAYAR);
-	tm->tm_mon	= sh_rtc_read_alarm_value(rtc, RMONAR);
-	if (tm->tm_mon > 0)
-		tm->tm_mon -= 1; /* RTC is 1-12, tm_mon is 0-11 */
-	tm->tm_year     = 0xffff;
-
-	wkalrm->enabled = (readb(rtc->regbase + RCR1) & RCR1_AIE) ? 1 : 0;
-
-	spin_unlock_irq(&rtc->lock);
-
-	return 0;
-}
-
 static inline void sh_rtc_write_alarm_value(struct sh_rtc *rtc,
 					    int value, int reg_off)
 {
@@ -601,7 +562,6 @@ static struct rtc_class_ops sh_rtc_ops = {
 	.ioctl		= sh_rtc_ioctl,
 	.read_time	= sh_rtc_read_time,
 	.set_time	= sh_rtc_set_time,
-	.read_alarm	= sh_rtc_read_alarm,
 	.set_alarm	= sh_rtc_set_alarm,
 	.proc		= sh_rtc_proc,
 	.alarm_irq_enable = sh_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 3b94367..2a945fa 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -183,21 +183,6 @@ static int stk17ta8_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return 0;
 }
 
-static int stk17ta8_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	if (pdata->irq <= 0)
-		return -EINVAL;
-	alrm->time.tm_mday = pdata->alrm_mday < 0 ? 0 : pdata->alrm_mday;
-	alrm->time.tm_hour = pdata->alrm_hour < 0 ? 0 : pdata->alrm_hour;
-	alrm->time.tm_min = pdata->alrm_min < 0 ? 0 : pdata->alrm_min;
-	alrm->time.tm_sec = pdata->alrm_sec < 0 ? 0 : pdata->alrm_sec;
-	alrm->enabled = (pdata->irqen & RTC_AF) ? 1 : 0;
-	return 0;
-}
-
 static irqreturn_t stk17ta8_rtc_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
@@ -239,7 +224,6 @@ static int stk17ta8_rtc_alarm_irq_enable(struct device *dev,
 static const struct rtc_class_ops stk17ta8_rtc_ops = {
 	.read_time		= stk17ta8_rtc_read_time,
 	.set_time		= stk17ta8_rtc_set_time,
-	.read_alarm		= stk17ta8_rtc_read_alarm,
 	.set_alarm		= stk17ta8_rtc_set_alarm,
 	.alarm_irq_enable	= stk17ta8_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 572e953..035c67c 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -115,14 +115,6 @@ static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int stmp3xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
-{
-	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
-
-	rtc_time_to_tm(__raw_readl(rtc_data->io + HW_RTC_ALARM), &alm->time);
-	return 0;
-}
-
 static int stmp3xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	unsigned long t;
@@ -138,7 +130,6 @@ static struct rtc_class_ops stmp3xxx_rtc_ops = {
 			  stmp3xxx_alarm_irq_enable,
 	.read_time	= stmp3xxx_rtc_gettime,
 	.set_mmss	= stmp3xxx_rtc_set_mmss,
-	.read_alarm	= stmp3xxx_rtc_read_alarm,
 	.set_alarm	= stmp3xxx_rtc_set_alarm,
 };
 
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index a82d6fe..61ad5ab 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -15,12 +15,6 @@
 
 static struct platform_device *test0 = NULL, *test1 = NULL;
 
-static int test_rtc_read_alarm(struct device *dev,
-	struct rtc_wkalrm *alrm)
-{
-	return 0;
-}
-
 static int test_rtc_set_alarm(struct device *dev,
 	struct rtc_wkalrm *alrm)
 {
@@ -58,7 +52,6 @@ static int test_rtc_alarm_irq_enable(struct device *dev, unsigned int enable)
 static const struct rtc_class_ops test_rtc_ops = {
 	.proc = test_rtc_proc,
 	.read_time = test_rtc_read_time,
-	.read_alarm = test_rtc_read_alarm,
 	.set_alarm = test_rtc_set_alarm,
 	.set_mmss = test_rtc_set_mmss,
 	.alarm_irq_enable = test_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index f9a2799..51e5dd2 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -295,36 +295,6 @@ out:
 	return ret;
 }
 
-/*
- * Gets current TWL RTC alarm time.
- */
-static int twl_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
-{
-	unsigned char rtc_data[ALL_TIME_REGS + 1];
-	int ret;
-
-	ret = twl_i2c_read(TWL_MODULE_RTC, rtc_data,
-			(rtc_reg_map[REG_ALARM_SECONDS_REG]), ALL_TIME_REGS);
-	if (ret < 0) {
-		dev_err(dev, "rtc_read_alarm error %d\n", ret);
-		return ret;
-	}
-
-	/* some of these fields may be wildcard/"match all" */
-	alm->time.tm_sec = bcd2bin(rtc_data[0]);
-	alm->time.tm_min = bcd2bin(rtc_data[1]);
-	alm->time.tm_hour = bcd2bin(rtc_data[2]);
-	alm->time.tm_mday = bcd2bin(rtc_data[3]);
-	alm->time.tm_mon = bcd2bin(rtc_data[4]) - 1;
-	alm->time.tm_year = bcd2bin(rtc_data[5]) + 100;
-
-	/* report cached alarm enable state */
-	if (rtc_irq_bits & BIT_RTC_INTERRUPTS_REG_IT_ALARM_M)
-		alm->enabled = 1;
-
-	return ret;
-}
-
 static int twl_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	unsigned char alarm_data[ALL_TIME_REGS + 1];
@@ -418,7 +388,6 @@ out:
 static struct rtc_class_ops twl_rtc_ops = {
 	.read_time	= twl_rtc_read_time,
 	.set_time	= twl_rtc_set_time,
-	.read_alarm	= twl_rtc_read_alarm,
 	.set_alarm	= twl_rtc_set_alarm,
 	.alarm_irq_enable = twl_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index ec6313d..8732231 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -122,35 +122,6 @@ static int tx4939_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	return ret;
 }
 
-static int tx4939_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	int i, ret;
-	unsigned long sec;
-	unsigned char buf[6];
-	u32 ctl;
-
-	spin_lock_irq(&pdata->lock);
-	ret = tx4939_rtc_cmd(rtcreg,
-			     TX4939_RTCCTL_COMMAND_GETALARM |
-			     (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALME));
-	if (ret) {
-		spin_unlock_irq(&pdata->lock);
-		return ret;
-	}
-	__raw_writel(2, &rtcreg->adr);
-	for (i = 2; i < 6; i++)
-		buf[i] = __raw_readl(&rtcreg->dat);
-	ctl = __raw_readl(&rtcreg->ctl);
-	alrm->enabled = (ctl & TX4939_RTCCTL_ALME) ? 1 : 0;
-	alrm->pending = (ctl & TX4939_RTCCTL_ALMD) ? 1 : 0;
-	spin_unlock_irq(&pdata->lock);
-	sec = (buf[5] << 24) | (buf[4] << 16) | (buf[3] << 8) | buf[2];
-	rtc_time_to_tm(sec, &alrm->time);
-	return rtc_valid_tm(&alrm->time);
-}
-
 static int tx4939_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
@@ -182,7 +153,6 @@ static irqreturn_t tx4939_rtc_interrupt(int irq, void *dev_id)
 
 static const struct rtc_class_ops tx4939_rtc_ops = {
 	.read_time		= tx4939_rtc_read_time,
-	.read_alarm		= tx4939_rtc_read_alarm,
 	.set_alarm		= tx4939_rtc_set_alarm,
 	.set_mmss		= tx4939_rtc_set_mmss,
 	.alarm_irq_enable	= tx4939_rtc_alarm_irq_enable,
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index c5698cd..3264a74 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -161,25 +161,6 @@ static int vr41xx_rtc_set_time(struct device *dev, struct rtc_time *time)
 	return 0;
 }
 
-static int vr41xx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
-{
-	unsigned long low, mid, high;
-	struct rtc_time *time = &wkalrm->time;
-
-	spin_lock_irq(&rtc_lock);
-
-	low = rtc1_read(ECMPLREG);
-	mid = rtc1_read(ECMPMREG);
-	high = rtc1_read(ECMPHREG);
-	wkalrm->enabled = alarm_enabled;
-
-	spin_unlock_irq(&rtc_lock);
-
-	rtc_time_to_tm((high << 17) | (mid << 1) | (low >> 15), time);
-
-	return 0;
-}
-
 static int vr41xx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 {
 	unsigned long alarm_sec;
@@ -276,7 +257,6 @@ static const struct rtc_class_ops vr41xx_rtc_ops = {
 	.ioctl		= vr41xx_rtc_ioctl,
 	.read_time	= vr41xx_rtc_read_time,
 	.set_time	= vr41xx_rtc_set_time,
-	.read_alarm	= vr41xx_rtc_read_alarm,
 	.set_alarm	= vr41xx_rtc_set_alarm,
 };
 
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index bdc909b..4962982 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -210,41 +210,6 @@ static int wm831x_rtc_set_mmss(struct device *dev, unsigned long time)
 	return 0;
 }
 
-/*
- * Read alarm time and date in RTC
- */
-static int wm831x_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct wm831x_rtc *wm831x_rtc = dev_get_drvdata(dev);
-	int ret;
-	u16 data[2];
-	u32 time;
-
-	ret = wm831x_bulk_read(wm831x_rtc->wm831x, WM831X_RTC_ALARM_1,
-			       2, data);
-	if (ret != 0) {
-		dev_err(dev, "Failed to read alarm time: %d\n", ret);
-		return ret;
-	}
-
-	time = (data[0] << 16) | data[1];
-
-	rtc_time_to_tm(time, &alrm->time);
-
-	ret = wm831x_reg_read(wm831x_rtc->wm831x, WM831X_RTC_CONTROL);
-	if (ret < 0) {
-		dev_err(dev, "Failed to read RTC control: %d\n", ret);
-		return ret;
-	}
-
-	if (ret & WM831X_RTC_ALM_ENA)
-		alrm->enabled = 1;
-	else
-		alrm->enabled = 0;
-
-	return 0;
-}
-
 static int wm831x_rtc_stop_alarm(struct wm831x_rtc *wm831x_rtc)
 {
 	wm831x_rtc->alarm_enabled = 0;
@@ -336,7 +301,6 @@ static irqreturn_t wm831x_per_irq(int irq, void *data)
 static const struct rtc_class_ops wm831x_rtc_ops = {
 	.read_time = wm831x_rtc_readtime,
 	.set_mmss = wm831x_rtc_set_mmss,
-	.read_alarm = wm831x_rtc_readalarm,
 	.set_alarm = wm831x_rtc_setalarm,
 	.alarm_irq_enable = wm831x_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 6642142..e48c9f1 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -140,55 +140,6 @@ static int wm8350_rtc_settime(struct device *dev, struct rtc_time *tm)
 	return ret;
 }
 
-/*
- * Read alarm time and date in RTC
- */
-static int wm8350_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct wm8350 *wm8350 = dev_get_drvdata(dev);
-	struct rtc_time *tm = &alrm->time;
-	u16 time[4];
-	int ret;
-
-	ret = wm8350_block_read(wm8350, WM8350_ALARM_SECONDS_MINUTES, 4, time);
-	if (ret < 0)
-		return ret;
-
-	tm->tm_sec = time[0] & WM8350_RTC_ALMSECS_MASK;
-	if (tm->tm_sec == WM8350_RTC_ALMSECS_MASK)
-		tm->tm_sec = -1;
-
-	tm->tm_min = time[0] & WM8350_RTC_ALMMINS_MASK;
-	if (tm->tm_min == WM8350_RTC_ALMMINS_MASK)
-		tm->tm_min = -1;
-	else
-		tm->tm_min >>= WM8350_RTC_ALMMINS_SHIFT;
-
-	tm->tm_hour = time[1] & WM8350_RTC_ALMHRS_MASK;
-	if (tm->tm_hour == WM8350_RTC_ALMHRS_MASK)
-		tm->tm_hour = -1;
-
-	tm->tm_wday = ((time[1] >> WM8350_RTC_ALMDAY_SHIFT) & 0x7) - 1;
-	if (tm->tm_wday > 7)
-		tm->tm_wday = -1;
-
-	tm->tm_mon = time[2] & WM8350_RTC_ALMMTH_MASK;
-	if (tm->tm_mon == WM8350_RTC_ALMMTH_MASK)
-		tm->tm_mon = -1;
-	else
-		tm->tm_mon = (tm->tm_mon >> WM8350_RTC_ALMMTH_SHIFT) - 1;
-
-	tm->tm_mday = (time[2] & WM8350_RTC_ALMDATE_MASK);
-	if (tm->tm_mday == WM8350_RTC_ALMDATE_MASK)
-		tm->tm_mday = -1;
-
-	tm->tm_year = -1;
-
-	alrm->enabled = !(time[3] & WM8350_RTC_ALMSTS);
-
-	return 0;
-}
-
 static int wm8350_rtc_stop_alarm(struct wm8350 *wm8350)
 {
 	int retries = WM8350_SET_ALM_RETRIES;
@@ -334,7 +285,6 @@ static irqreturn_t wm8350_rtc_update_handler(int irq, void *data)
 static const struct rtc_class_ops wm8350_rtc_ops = {
 	.read_time = wm8350_rtc_readtime,
 	.set_time = wm8350_rtc_settime,
-	.read_alarm = wm8350_rtc_readalarm,
 	.set_alarm = wm8350_rtc_setalarm,
 	.alarm_irq_enable = wm8350_rtc_alarm_irq_enable,
 };
diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index 9aae491..ac9f31e 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -436,31 +436,6 @@ static int x1205_validate_client(struct i2c_client *client)
 	return 0;
 }
 
-static int x1205_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	int err;
-	unsigned char intreg, status;
-	static unsigned char int_addr[2] = { 0, X1205_REG_INT };
-	struct i2c_client *client = to_i2c_client(dev);
-	struct i2c_msg msgs[] = {
-		{ client->addr, 0, 2, int_addr },        /* setup read ptr */
-		{ client->addr, I2C_M_RD, 1, &intreg },  /* read INT register */
-	};
-
-	/* read interrupt register and status register */
-	if (i2c_transfer(client->adapter, &msgs[0], 2) != 2) {
-		dev_err(&client->dev, "%s: read error\n", __func__);
-		return -EIO;
-	}
-	err = x1205_get_status(client, &status);
-	if (err == 0) {
-		alrm->pending = (status & X1205_SR_AL0) ? 1 : 0;
-		alrm->enabled = (intreg & X1205_INT_AL0E) ? 1 : 0;
-		err = x1205_get_datetime(client, &alrm->time, X1205_ALM0_BASE);
-	}
-	return err;
-}
-
 static int x1205_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	return x1205_set_datetime(to_i2c_client(dev),
@@ -496,7 +471,6 @@ static const struct rtc_class_ops x1205_rtc_ops = {
 	.proc		= x1205_rtc_proc,
 	.read_time	= x1205_rtc_read_time,
 	.set_time	= x1205_rtc_set_time,
-	.read_alarm	= x1205_rtc_read_alarm,
 	.set_alarm	= x1205_rtc_set_alarm,
 };
 
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index a69249d..7327376 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -143,7 +143,6 @@ struct rtc_class_ops {
 	int (*ioctl)(struct device *, unsigned int, unsigned long);
 	int (*read_time)(struct device *, struct rtc_time *);
 	int (*set_time)(struct device *, struct rtc_time *);
-	int (*read_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*set_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*proc)(struct device *, struct seq_file *);
 	int (*set_mmss)(struct device *, unsigned long secs);
-- 
1.7.3.2.146.gca209

