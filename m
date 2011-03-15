Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab1COUPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:15:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48170 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756Ab1COUPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:15:16 -0400
Date: Tue, 15 Mar 2011 21:14:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/rtc changes for v2.6.39
Message-ID: <20110315201453.GA18930@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-rtc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-rtc-for-linus

 Thanks,

	Ingo

------------------>
John Stultz (6):
      RTC: Initialize kernel state from RTC
      RTC: Cleanup rtc_class_ops->irq_set_state
      RTC: Cleanup rtc_class_ops->irq_set_freq()
      RTC: Cleanup rtc_class_ops->update_irq_enable()
      RTC: Clean out UIE icotl implementations
      RTC: Fix up rtc.txt documentation to reflect changes to generic rtc layer

Marcelo Roberto Jimenez (4):
      RTC: Include information about UIE and PIE in RTC driver proc.
      RTC: Remove UIE and PIE information from the sa1100 driver proc.
      RTC: Fix the cross interrupt issue on rtc-test.
      RTC: sa1100: Update the sa1100 RTC driver.


 Documentation/rtc.txt        |   29 +++-----
 drivers/rtc/class.c          |    7 ++
 drivers/rtc/interface.c      |  180 ++++++++++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-at91rm9200.c |   28 -------
 drivers/rtc/rtc-at91sam9.c   |   28 -------
 drivers/rtc/rtc-bfin.c       |   27 ------
 drivers/rtc/rtc-cmos.c       |   66 ---------------
 drivers/rtc/rtc-davinci.c    |   55 -------------
 drivers/rtc/rtc-ds1511.c     |   17 ----
 drivers/rtc/rtc-ds1553.c     |   17 ----
 drivers/rtc/rtc-ds3232.c     |   18 ----
 drivers/rtc/rtc-jz4740.c     |    7 --
 drivers/rtc/rtc-mc13xxx.c    |    7 --
 drivers/rtc/rtc-mpc5121.c    |   20 -----
 drivers/rtc/rtc-mrst.c       |   20 -----
 drivers/rtc/rtc-mxc.c        |    7 --
 drivers/rtc/rtc-nuc900.c     |   15 ----
 drivers/rtc/rtc-omap.c       |   39 ---------
 drivers/rtc/rtc-pcap.c       |    6 --
 drivers/rtc/rtc-pcf50633.c   |   22 +-----
 drivers/rtc/rtc-pl030.c      |    6 --
 drivers/rtc/rtc-pl031.c      |   55 -------------
 drivers/rtc/rtc-proc.c       |    8 ++
 drivers/rtc/rtc-pxa.c        |   44 ----------
 drivers/rtc/rtc-rs5c372.c    |   52 ------------
 drivers/rtc/rtc-rx8025.c     |   25 ------
 drivers/rtc/rtc-s3c.c        |   33 --------
 drivers/rtc/rtc-sa1100.c     |  160 +------------------------------------
 drivers/rtc/rtc-sh.c         |   24 ------
 drivers/rtc/rtc-stmp3xxx.c   |   15 ----
 drivers/rtc/rtc-test.c       |   13 ++-
 drivers/rtc/rtc-twl.c        |   13 ---
 drivers/rtc/rtc-vr41xx.c     |   32 --------
 drivers/rtc/rtc-wm831x.c     |   16 ----
 drivers/rtc/rtc-wm8350.c     |   21 -----
 include/linux/rtc.h          |    5 +-
 36 files changed, 221 insertions(+), 916 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 9104c10..2501604 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -178,38 +178,29 @@ RTC class framework, but can't be supported by the older driver.
 	setting the longer alarm time and enabling its IRQ using a single
 	request (using the same model as EFI firmware).
 
-    *	RTC_UIE_ON, RTC_UIE_OFF ... if the RTC offers IRQs, it probably
-	also offers update IRQs whenever the "seconds" counter changes.
-	If needed, the RTC framework can emulate this mechanism.
+    *	RTC_UIE_ON, RTC_UIE_OFF ... if the RTC offers IRQs, the RTC framework
+	will emulate this mechanism.
 
-    *	RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET, RTC_IRQP_READ ... another
-	feature often accessible with an IRQ line is a periodic IRQ, issued
-	at settable frequencies (usually 2^N Hz).
+    *	RTC_PIE_ON, RTC_PIE_OFF, RTC_IRQP_SET, RTC_IRQP_READ ... these icotls
+	are emulated via a kernel hrtimer.
 
 In many cases, the RTC alarm can be a system wake event, used to force
 Linux out of a low power sleep state (or hibernation) back to a fully
 operational state.  For example, a system could enter a deep power saving
 state until it's time to execute some scheduled tasks.
 
-Note that many of these ioctls need not actually be implemented by your
-driver.  The common rtc-dev interface handles many of these nicely if your
-driver returns ENOIOCTLCMD.  Some common examples:
+Note that many of these ioctls are handled by the common rtc-dev interface.
+Some common examples:
 
     *	RTC_RD_TIME, RTC_SET_TIME: the read_time/set_time functions will be
 	called with appropriate values.
 
-    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: the
-	set_alarm/read_alarm functions will be called.
+    *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: gets or sets
+	the alarm rtc_timer. May call the set_alarm driver function.
 
-    *	RTC_IRQP_SET, RTC_IRQP_READ: the irq_set_freq function will be called
-	to set the frequency while the framework will handle the read for you
-	since the frequency is stored in the irq_freq member of the rtc_device
-	structure.  Your driver needs to initialize the irq_freq member during
-	init.  Make sure you check the requested frequency is in range of your
-	hardware in the irq_set_freq function.  If it isn't, return -EINVAL.  If
-	you cannot actually change the frequency, do not define irq_set_freq.
+    *	RTC_IRQP_SET, RTC_IRQP_READ: These are emulated by the generic code.
 
-    *	RTC_PIE_ON, RTC_PIE_OFF: the irq_set_state function will be called.
+    *	RTC_PIE_ON, RTC_PIE_OFF: These are also emulated by the generic code.
 
 If all else fails, check out the rtc-test.c driver!
 
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index c404b61..09b4437 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -117,6 +117,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 					struct module *owner)
 {
 	struct rtc_device *rtc;
+	struct rtc_wkalrm alrm;
 	int id, err;
 
 	if (idr_pre_get(&rtc_idr, GFP_KERNEL) == 0) {
@@ -166,6 +167,12 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	rtc->pie_timer.function = rtc_pie_update_irq;
 	rtc->pie_enabled = 0;
 
+	/* Check to see if there is an ALARM already set in hw */
+	err = __rtc_read_alarm(rtc, &alrm);
+
+	if (!err && !rtc_valid_tm(&alrm.time))
+		rtc_set_alarm(rtc, &alrm);
+
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	dev_set_name(&rtc->dev, "rtc%d", id);
 
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index cb2f072..8ec6b06 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -116,6 +116,186 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 }
 EXPORT_SYMBOL_GPL(rtc_set_mmss);
 
+static int rtc_read_alarm_internal(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+{
+	int err;
+
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+
+	if (rtc->ops == NULL)
+		err = -ENODEV;
+	else if (!rtc->ops->read_alarm)
+		err = -EINVAL;
+	else {
+		memset(alarm, 0, sizeof(struct rtc_wkalrm));
+		err = rtc->ops->read_alarm(rtc->dev.parent, alarm);
+	}
+
+	mutex_unlock(&rtc->ops_lock);
+	return err;
+}
+
+int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+{
+	int err;
+	struct rtc_time before, now;
+	int first_time = 1;
+	unsigned long t_now, t_alm;
+	enum { none, day, month, year } missing = none;
+	unsigned days;
+
+	/* The lower level RTC driver may return -1 in some fields,
+	 * creating invalid alarm->time values, for reasons like:
+	 *
+	 *   - The hardware may not be capable of filling them in;
+	 *     many alarms match only on time-of-day fields, not
+	 *     day/month/year calendar data.
+	 *
+	 *   - Some hardware uses illegal values as "wildcard" match
+	 *     values, which non-Linux firmware (like a BIOS) may try
+	 *     to set up as e.g. "alarm 15 minutes after each hour".
+	 *     Linux uses only oneshot alarms.
+	 *
+	 * When we see that here, we deal with it by using values from
+	 * a current RTC timestamp for any missing (-1) values.  The
+	 * RTC driver prevents "periodic alarm" modes.
+	 *
+	 * But this can be racey, because some fields of the RTC timestamp
+	 * may have wrapped in the interval since we read the RTC alarm,
+	 * which would lead to us inserting inconsistent values in place
+	 * of the -1 fields.
+	 *
+	 * Reading the alarm and timestamp in the reverse sequence
+	 * would have the same race condition, and not solve the issue.
+	 *
+	 * So, we must first read the RTC timestamp,
+	 * then read the RTC alarm value,
+	 * and then read a second RTC timestamp.
+	 *
+	 * If any fields of the second timestamp have changed
+	 * when compared with the first timestamp, then we know
+	 * our timestamp may be inconsistent with that used by
+	 * the low-level rtc_read_alarm_internal() function.
+	 *
+	 * So, when the two timestamps disagree, we just loop and do
+	 * the process again to get a fully consistent set of values.
+	 *
+	 * This could all instead be done in the lower level driver,
+	 * but since more than one lower level RTC implementation needs it,
+	 * then it's probably best best to do it here instead of there..
+	 */
+
+	/* Get the "before" timestamp */
+	err = rtc_read_time(rtc, &before);
+	if (err < 0)
+		return err;
+	do {
+		if (!first_time)
+			memcpy(&before, &now, sizeof(struct rtc_time));
+		first_time = 0;
+
+		/* get the RTC alarm values, which may be incomplete */
+		err = rtc_read_alarm_internal(rtc, alarm);
+		if (err)
+			return err;
+
+		/* full-function RTCs won't have such missing fields */
+		if (rtc_valid_tm(&alarm->time) == 0)
+			return 0;
+
+		/* get the "after" timestamp, to detect wrapped fields */
+		err = rtc_read_time(rtc, &now);
+		if (err < 0)
+			return err;
+
+		/* note that tm_sec is a "don't care" value here: */
+	} while (   before.tm_min   != now.tm_min
+		 || before.tm_hour  != now.tm_hour
+		 || before.tm_mon   != now.tm_mon
+		 || before.tm_year  != now.tm_year);
+
+	/* Fill in the missing alarm fields using the timestamp; we
+	 * know there's at least one since alarm->time is invalid.
+	 */
+	if (alarm->time.tm_sec == -1)
+		alarm->time.tm_sec = now.tm_sec;
+	if (alarm->time.tm_min == -1)
+		alarm->time.tm_min = now.tm_min;
+	if (alarm->time.tm_hour == -1)
+		alarm->time.tm_hour = now.tm_hour;
+
+	/* For simplicity, only support date rollover for now */
+	if (alarm->time.tm_mday == -1) {
+		alarm->time.tm_mday = now.tm_mday;
+		missing = day;
+	}
+	if (alarm->time.tm_mon == -1) {
+		alarm->time.tm_mon = now.tm_mon;
+		if (missing == none)
+			missing = month;
+	}
+	if (alarm->time.tm_year == -1) {
+		alarm->time.tm_year = now.tm_year;
+		if (missing == none)
+			missing = year;
+	}
+
+	/* with luck, no rollover is needed */
+	rtc_tm_to_time(&now, &t_now);
+	rtc_tm_to_time(&alarm->time, &t_alm);
+	if (t_now < t_alm)
+		goto done;
+
+	switch (missing) {
+
+	/* 24 hour rollover ... if it's now 10am Monday, an alarm that
+	 * that will trigger at 5am will do so at 5am Tuesday, which
+	 * could also be in the next month or year.  This is a common
+	 * case, especially for PCs.
+	 */
+	case day:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "day");
+		t_alm += 24 * 60 * 60;
+		rtc_time_to_tm(t_alm, &alarm->time);
+		break;
+
+	/* Month rollover ... if it's the 31th, an alarm on the 3rd will
+	 * be next month.  An alarm matching on the 30th, 29th, or 28th
+	 * may end up in the month after that!  Many newer PCs support
+	 * this type of alarm.
+	 */
+	case month:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "month");
+		do {
+			if (alarm->time.tm_mon < 11)
+				alarm->time.tm_mon++;
+			else {
+				alarm->time.tm_mon = 0;
+				alarm->time.tm_year++;
+			}
+			days = rtc_month_days(alarm->time.tm_mon,
+					alarm->time.tm_year);
+		} while (days < alarm->time.tm_mday);
+		break;
+
+	/* Year rollover ... easy except for leap years! */
+	case year:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
+		do {
+			alarm->time.tm_year++;
+		} while (rtc_valid_tm(&alarm->time) != 0);
+		break;
+
+	default:
+		dev_warn(&rtc->dev, "alarm rollover not handled\n");
+	}
+
+done:
+	return 0;
+}
+
 int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	int err;
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 26d1cf5..518a76e 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -183,33 +183,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
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
@@ -269,7 +242,6 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
 }
 
 static const struct rtc_class_ops at91_rtc_ops = {
-	.ioctl		= at91_rtc_ioctl,
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
 	.read_alarm	= at91_rtc_readalarm,
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 5469c52..a3ad957 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -216,33 +216,6 @@ static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
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
@@ -303,7 +276,6 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *_rtc)
 }
 
 static const struct rtc_class_ops at91_rtc_ops = {
-	.ioctl		= at91_rtc_ioctl,
 	.read_time	= at91_rtc_readtime,
 	.set_time	= at91_rtc_settime,
 	.read_alarm	= at91_rtc_readalarm,
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 17971d9..ca9cff8 100644
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
@@ -358,7 +332,6 @@ static int bfin_rtc_proc(struct device *dev, struct seq_file *seq)
 }
 
 static struct rtc_class_ops bfin_rtc_ops = {
-	.ioctl         = bfin_rtc_ioctl,
 	.read_time     = bfin_rtc_read_time,
 	.set_time      = bfin_rtc_set_time,
 	.read_alarm    = bfin_rtc_read_alarm,
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index c7ff8df..dc2a0ba 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -375,50 +375,6 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
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
@@ -438,25 +394,6 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
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
@@ -501,10 +438,7 @@ static const struct rtc_class_ops cmos_rtc_ops = {
 	.read_alarm		= cmos_read_alarm,
 	.set_alarm		= cmos_set_alarm,
 	.proc			= cmos_procfs,
-	.irq_set_freq		= cmos_irq_set_freq,
-	.irq_set_state		= cmos_irq_set_state,
 	.alarm_irq_enable	= cmos_alarm_irq_enable,
-	.update_irq_enable	= cmos_update_irq_enable,
 };
 
 /*----------------------------------------------------------------*/
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 34647fc..8d46838 100644
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
@@ -473,55 +469,6 @@ static int davinci_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
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
@@ -529,8 +476,6 @@ static struct rtc_class_ops davinci_rtc_ops = {
 	.alarm_irq_enable	= davinci_rtc_alarm_irq_enable,
 	.read_alarm		= davinci_rtc_read_alarm,
 	.set_alarm		= davinci_rtc_set_alarm,
-	.irq_set_state		= davinci_rtc_irq_set_state,
-	.irq_set_freq		= davinci_rtc_irq_set_freq,
 };
 
 static int __init davinci_rtc_probe(struct platform_device *pdev)
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
index 9507354..27b7bf6 100644
--- a/drivers/rtc/rtc-ds3232.c
+++ b/drivers/rtc/rtc-ds3232.c
@@ -339,23 +339,6 @@ static int ds3232_alarm_irq_enable(struct device *dev, unsigned int enabled)
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
@@ -406,7 +389,6 @@ static const struct rtc_class_ops ds3232_rtc_ops = {
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
diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
index b4dbf3a..de0dd7b 100644
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
@@ -313,7 +275,6 @@ static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 }
 
 static struct rtc_class_ops omap_rtc_ops = {
-	.ioctl		= omap_rtc_ioctl,
 	.read_time	= omap_rtc_read_time,
 	.set_time	= omap_rtc_set_time,
 	.read_alarm	= omap_rtc_read_alarm,
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
diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index bbdb2f0..d554368 100644
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
 static int pl030_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pl030_rtc *rtc = dev_get_drvdata(dev);
@@ -96,7 +91,6 @@ static int pl030_set_time(struct device *dev, struct rtc_time *tm)
 }
 
 static const struct rtc_class_ops pl030_ops = {
-	.ioctl		= pl030_ioctl,
 	.read_time	= pl030_read_time,
 	.set_time	= pl030_set_time,
 	.read_alarm	= pl030_read_alarm,
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index b7a6690..d829ea6 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -293,57 +293,6 @@ static int pl031_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
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
@@ -440,8 +389,6 @@ static struct rtc_class_ops stv1_pl031_ops = {
 	.read_alarm = pl031_read_alarm,
 	.set_alarm = pl031_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
-	.irq_set_state = pl031_irq_set_state,
-	.irq_set_freq = pl031_irq_set_freq,
 };
 
 /* And the second ST derivative */
@@ -451,8 +398,6 @@ static struct rtc_class_ops stv2_pl031_ops = {
 	.read_alarm = pl031_stv2_read_alarm,
 	.set_alarm = pl031_stv2_set_alarm,
 	.alarm_irq_enable = pl031_alarm_irq_enable,
-	.irq_set_state = pl031_irq_set_state,
-	.irq_set_freq = pl031_irq_set_freq,
 };
 
 static struct amba_id pl031_ids[] = {
diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index 242bbf8..0a59fda 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -69,6 +69,14 @@ static int rtc_proc_show(struct seq_file *seq, void *offset)
 				alrm.enabled ? "yes" : "no");
 		seq_printf(seq, "alrm_pending\t: %s\n",
 				alrm.pending ? "yes" : "no");
+		seq_printf(seq, "update IRQ enabled\t: %s\n",
+			(rtc->uie_rtctimer.enabled) ? "yes" : "no");
+		seq_printf(seq, "periodic IRQ enabled\t: %s\n",
+			(rtc->pie_enabled) ? "yes" : "no");
+		seq_printf(seq, "periodic IRQ frequency\t: %d\n",
+			rtc->irq_freq);
+		seq_printf(seq, "max user IRQ frequency\t: %d\n",
+			rtc->max_user_freq);
 	}
 
 	seq_printf(seq, "24hr\t\t: yes\n");
diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index 29e867a..fc9f499 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -209,32 +209,6 @@ static void pxa_rtc_release(struct device *dev)
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
@@ -250,21 +224,6 @@ static int pxa_alarm_irq_enable(struct device *dev, unsigned int enabled)
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
@@ -346,10 +305,7 @@ static const struct rtc_class_ops pxa_rtc_ops = {
 	.read_alarm = pxa_rtc_read_alarm,
 	.set_alarm = pxa_rtc_set_alarm,
 	.alarm_irq_enable = pxa_alarm_irq_enable,
-	.update_irq_enable = pxa_update_irq_enable,
 	.proc = pxa_rtc_proc,
-	.irq_set_state = pxa_periodic_irq_set_state,
-	.irq_set_freq = pxa_periodic_irq_set_freq,
 };
 
 static int __init pxa_rtc_probe(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 6aaa155..85c1b84 100644
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
@@ -480,7 +429,6 @@ static int rs5c372_rtc_proc(struct device *dev, struct seq_file *seq)
 
 static const struct rtc_class_ops rs5c372_rtc_ops = {
 	.proc		= rs5c372_rtc_proc,
-	.ioctl		= rs5c_rtc_ioctl,
 	.read_time	= rs5c372_rtc_read_time,
 	.set_time	= rs5c372_rtc_set_time,
 	.read_alarm	= rs5c_read_alarm,
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
index b80fa28..7149649 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -93,37 +93,6 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 	return 0;
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
@@ -379,8 +348,6 @@ static const struct rtc_class_ops s3c_rtcops = {
 	.set_time	= s3c_rtc_settime,
 	.read_alarm	= s3c_rtc_getalarm,
 	.set_alarm	= s3c_rtc_setalarm,
-	.irq_set_freq	= s3c_rtc_setfreq,
-	.irq_set_state	= s3c_rtc_setpie,
 	.proc		= s3c_rtc_proc,
 	.alarm_irq_enable = s3c_rtc_setaie,
 };
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 5dfe5ff..0b40bb8 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -43,7 +43,6 @@
 #define RTC_DEF_TRIM		0
 
 static const unsigned long RTC_FREQ = 1024;
-static unsigned long timer_freq;
 static struct rtc_time rtc_alarm;
 static DEFINE_SPINLOCK(sa1100_rtc_lock);
 
@@ -156,114 +155,11 @@ static irqreturn_t sa1100_rtc_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int sa1100_irq_set_freq(struct device *dev, int freq)
-{
-	if (freq < 1 || freq > timer_freq) {
-		return -EINVAL;
-	} else {
-		struct rtc_device *rtc = (struct rtc_device *)dev;
-
-		rtc->irq_freq = freq;
-
-		return 0;
-	}
-}
-
-static int rtc_timer1_count;
-
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
-static inline int sa1100_timer1_retrigger(struct rtc_device *rtc)
-{
-	unsigned long diff;
-	unsigned long period = timer_freq / rtc->irq_freq;
-
-	spin_lock_irq(&sa1100_rtc_lock);
-
-	do {
-		OSMR1 += period;
-		diff = OSMR1 - OSCR;
-		/* If OSCR > OSMR1, diff is a very large number (unsigned
-		 * math). This means we have a lost interrupt. */
-	} while (diff > period);
-	OIER |= OIER_E1;
-
-	spin_unlock_irq(&sa1100_rtc_lock);
-
-	return 0;
-}
-
-static irqreturn_t timer1_interrupt(int irq, void *dev_id)
-{
-	struct platform_device *pdev = to_platform_device(dev_id);
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	/*
-	 * If we match for the first time, rtc_timer1_count will be 1.
-	 * Otherwise, we wrapped around (very unlikely but
-	 * still possible) so compute the amount of missed periods.
-	 * The match reg is updated only when the data is actually retrieved
-	 * to avoid unnecessary interrupts.
-	 */
-	OSSR = OSSR_M1;	/* clear match on timer1 */
-
-	rtc_update_irq(rtc, rtc_timer1_count, RTC_PF | RTC_IRQF);
-
-	if (rtc_timer1_count == 1)
-		rtc_timer1_count =
-			(rtc->irq_freq * ((1 << 30) / (timer_freq >> 2)));
-
-	/* retrigger. */
-	sa1100_timer1_retrigger(rtc);
-
-	return IRQ_HANDLED;
-}
-
-static int sa1100_rtc_read_callback(struct device *dev, int data)
-{
-	if (data & RTC_PF) {
-		struct rtc_device *rtc = (struct rtc_device *)dev;
-
-		/* interpolate missed periods and set match for the next */
-		unsigned long period = timer_freq / rtc->irq_freq;
-		unsigned long oscr = OSCR;
-		unsigned long osmr1 = OSMR1;
-		unsigned long missed = (oscr - osmr1)/period;
-		data += missed << 8;
-		OSSR = OSSR_M1;	/* clear match on timer 1 */
-		OSMR1 = osmr1 + (missed + 1)*period;
-		/* Ensure we didn't miss another match in the mean time.
-		 * Here we compare (match - OSCR) 8 instead of 0 --
-		 * see comment in pxa_timer_interrupt() for explanation.
-		 */
-		while ((signed long)((osmr1 = OSMR1) - OSCR) <= 8) {
-			data += 0x100;
-			OSSR = OSSR_M1;	/* clear match on timer 1 */
-			OSMR1 = osmr1 + period;
-		}
-	}
-	return data;
-}
-
 static int sa1100_rtc_open(struct device *dev)
 {
 	int ret;
-	struct rtc_device *rtc = (struct rtc_device *)dev;
+	struct platform_device *plat_dev = to_platform_device(dev);
+	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
 	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, IRQF_DISABLED,
 		"rtc 1Hz", dev);
@@ -277,19 +173,11 @@ static int sa1100_rtc_open(struct device *dev)
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTCAlrm);
 		goto fail_ai;
 	}
-	ret = request_irq(IRQ_OST1, timer1_interrupt, IRQF_DISABLED,
-		"rtc timer", dev);
-	if (ret) {
-		dev_err(dev, "IRQ %d already in use.\n", IRQ_OST1);
-		goto fail_pi;
-	}
 	rtc->max_user_freq = RTC_FREQ;
-	sa1100_irq_set_freq(dev, RTC_FREQ);
+	rtc_irq_set_freq(rtc, NULL, RTC_FREQ);
 
 	return 0;
 
- fail_pi:
-	free_irq(IRQ_RTCAlrm, dev);
  fail_ai:
 	free_irq(IRQ_RTC1Hz, dev);
  fail_ui:
@@ -304,30 +192,10 @@ static void sa1100_rtc_release(struct device *dev)
 	OSSR = OSSR_M1;
 	spin_unlock_irq(&sa1100_rtc_lock);
 
-	free_irq(IRQ_OST1, dev);
 	free_irq(IRQ_RTCAlrm, dev);
 	free_irq(IRQ_RTC1Hz, dev);
 }
 
-
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
@@ -386,31 +254,20 @@ static int sa1100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int sa1100_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	struct rtc_device *rtc = (struct rtc_device *)dev;
-
-	seq_printf(seq, "trim/divider\t: 0x%08x\n", (u32) RTTR);
-	seq_printf(seq, "update_IRQ\t: %s\n",
-			(RTSR & RTSR_HZE) ? "yes" : "no");
-	seq_printf(seq, "periodic_IRQ\t: %s\n",
-			(OIER & OIER_E1) ? "yes" : "no");
-	seq_printf(seq, "periodic_freq\t: %d\n", rtc->irq_freq);
-	seq_printf(seq, "RTSR\t\t: 0x%08x\n", (u32)RTSR);
+	seq_printf(seq, "trim/divider\t\t: 0x%08x\n", (u32) RTTR);
+	seq_printf(seq, "RTSR\t\t\t: 0x%08x\n", (u32)RTSR);
 
 	return 0;
 }
 
 static const struct rtc_class_ops sa1100_rtc_ops = {
 	.open = sa1100_rtc_open,
-	.read_callback = sa1100_rtc_read_callback,
 	.release = sa1100_rtc_release,
-	.ioctl = sa1100_rtc_ioctl,
 	.read_time = sa1100_rtc_read_time,
 	.set_time = sa1100_rtc_set_time,
 	.read_alarm = sa1100_rtc_read_alarm,
 	.set_alarm = sa1100_rtc_set_alarm,
 	.proc = sa1100_rtc_proc,
-	.irq_set_freq = sa1100_irq_set_freq,
-	.irq_set_state = sa1100_irq_set_state,
 	.alarm_irq_enable = sa1100_rtc_alarm_irq_enable,
 };
 
@@ -418,8 +275,6 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 
-	timer_freq = get_clock_tick_rate();
-
 	/*
 	 * According to the manual we should be able to let RTTR be zero
 	 * and then a default diviser for a 32.768KHz clock is used.
@@ -445,11 +300,6 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
-	/* Set the irq_freq */
-	/*TODO: Find out who is messing with this value after we initialize
-	 * it here.*/
-	rtc->irq_freq = RTC_FREQ;
-
 	/* Fix for a nasty initialization problem the in SA11xx RTSR register.
 	 * See also the comments in sa1100_rtc_interrupt().
 	 *
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 93314a9..e55dc1a 100644
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
@@ -598,13 +577,10 @@ static int sh_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 }
 
 static struct rtc_class_ops sh_rtc_ops = {
-	.ioctl		= sh_rtc_ioctl,
 	.read_time	= sh_rtc_read_time,
 	.set_time	= sh_rtc_set_time,
 	.read_alarm	= sh_rtc_read_alarm,
 	.set_alarm	= sh_rtc_set_alarm,
-	.irq_set_state	= sh_rtc_irq_set_state,
-	.irq_set_freq	= sh_rtc_irq_set_freq,
 	.proc		= sh_rtc_proc,
 	.alarm_irq_enable = sh_rtc_alarm_irq_enable,
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
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index a82d6fe..7e96254 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -78,11 +78,16 @@ static ssize_t test_irq_store(struct device *dev,
 	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
 	retval = count;
-	if (strncmp(buf, "tick", 4) == 0)
+	if (strncmp(buf, "tick", 4) == 0 && rtc->pie_enabled)
 		rtc_update_irq(rtc, 1, RTC_PF | RTC_IRQF);
-	else if (strncmp(buf, "alarm", 5) == 0)
-		rtc_update_irq(rtc, 1, RTC_AF | RTC_IRQF);
-	else if (strncmp(buf, "update", 6) == 0)
+	else if (strncmp(buf, "alarm", 5) == 0) {
+		struct rtc_wkalrm alrm;
+		int err = rtc_read_alarm(rtc, &alrm);
+
+		if (!err && alrm.enabled)
+			rtc_update_irq(rtc, 1, RTC_AF | RTC_IRQF);
+
+	} else if (strncmp(buf, "update", 6) == 0 && rtc->uie_rtctimer.enabled)
 		rtc_update_irq(rtc, 1, RTC_UF | RTC_IRQF);
 	else
 		retval = -EINVAL;
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
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 769190a..c5698cd 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -207,36 +207,6 @@ static int vr41xx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
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
@@ -308,8 +278,6 @@ static const struct rtc_class_ops vr41xx_rtc_ops = {
 	.set_time	= vr41xx_rtc_set_time,
 	.read_alarm	= vr41xx_rtc_read_alarm,
 	.set_alarm	= vr41xx_rtc_set_alarm,
-	.irq_set_freq	= vr41xx_rtc_irq_set_freq,
-	.irq_set_state	= vr41xx_rtc_irq_set_state,
 };
 
 static int __devinit rtc_probe(struct platform_device *pdev)
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
index 89c3e51..2ca7e8a 100644
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
@@ -148,11 +147,8 @@ struct rtc_class_ops {
 	int (*set_alarm)(struct device *, struct rtc_wkalrm *);
 	int (*proc)(struct device *, struct seq_file *);
 	int (*set_mmss)(struct device *, unsigned long secs);
-	int (*irq_set_state)(struct device *, int enabled);
-	int (*irq_set_freq)(struct device *, int freq);
 	int (*read_callback)(struct device *, int data);
 	int (*alarm_irq_enable)(struct device *, unsigned int enabled);
-	int (*update_irq_enable)(struct device *, unsigned int enabled);
 };
 
 #define RTC_DEVICE_NAME_SIZE 20
@@ -227,6 +223,7 @@ extern void rtc_device_unregister(struct rtc_device *rtc);
 extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs);
+int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm);
 extern int rtc_read_alarm(struct rtc_device *rtc,
 			struct rtc_wkalrm *alrm);
 extern int rtc_set_alarm(struct rtc_device *rtc,
