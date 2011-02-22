Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1BVUu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:50:29 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:49486 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1BVUu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:50:28 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        patches@linaro.org
Subject: [PATCH][RFC] RTC: Initialize kernel state from RTC
Date: Tue, 22 Feb 2011 12:49:56 -0800
Message-Id: <1298407796-28010-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to send this out for initial comment. It would be
great if someone with RTC hardware that preserves alarm state
across resets could test this. I've tested with cmos and we
correctly preserve the alarm time value, but because of the
hardware the alarm is not enabled after reset.

If there's no objections, I'll try to squeeze this fix into
2.6.38 (although its frustratingly large for this late in the
cycle, so it might have to wait until 2.6.38.1).

thanks
-john


Mark Brown pointed out a coner case: that RTC alarms should
be allowed to be persistent across reboots if the hardware
supported it.

The rework of the generic layer to virtualize the RTC alarm
virtualized much of the alarm handling, and removed the
code used to read the alarm time from the hardware.

Mark noted if we want the alarm to be persistent across
reboots, we need to re-read the alarm value into the
virtualized generic layer at boot up, so that the generic
layer properly exposes that value.

This patch restores much of the earlier removed
rtc_read_alarm code and wires it in so that we
set the kernel's alarm value to what we find in the
hardware at boot time.

NOTE: Not all hardware supports persistent RTC alarm state across
system reset. rtc-cmos for example will keep the alarm time, but
disables the AIE mode irq. Applications should not expect the RTC
alarm to be valid after a system reset. We will preserve what
we can, to represent the hardware state at boot, but its not
guarenteed.

Further, in the future, with multiplexed RTC alarms, the
soonest alarm to fire may not be the one set via the /dev/rt
ioctls. So an application may set the alarm with RTC_ALM_SET,
but after a reset find that RTC_ALM_READ returns an earlier
time. Again, we preserve what we can, but applications should
not expect the RTC alarm state to persist across a system reset.

Big thanks to Mark for pointing out the issue!
Thanks also to Marcelo for helping think through the solution.

CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: rtc-linux@googlegroups.com
CC: patches@linaro.org
Reported-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/class.c     |    7 ++
 drivers/rtc/interface.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc.h     |    1 +
 3 files changed, 188 insertions(+), 0 deletions(-)

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
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 89c3e51..db3832d 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -227,6 +227,7 @@ extern void rtc_device_unregister(struct rtc_device *rtc);
 extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs);
+int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm);
 extern int rtc_read_alarm(struct rtc_device *rtc,
 			struct rtc_wkalrm *alrm);
 extern int rtc_set_alarm(struct rtc_device *rtc,
-- 
1.7.3.2.146.gca209

