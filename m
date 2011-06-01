Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1FAGIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:08:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51564 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1FAGH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:07:58 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] rtc: Avoid accumulating time drift in suspend/resume
Date: Tue, 31 May 2011 23:07:49 -0700
Message-Id: <1306908469-15275-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1306908469-15275-1-git-send-email-john.stultz@linaro.org>
References: <1306908469-15275-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the RTC interface is only a second granular interface,
each time we read from the RTC for suspend/resume, we introduce a
half second (on average) of error.

In order to avoid this error accumulating as the system is suspended
over and over, this patch measures the time delta between the RTC
and the system CLOCK_REALTIME.

If the delta is less then 2 seconds from the last suspend, we compensate
by using the previous time delta (keeping it close). If it is larger
then 2 seconds, we assume the clock was set or has been changed, so we
do no correction and update the delta.

Note: If NTP is running, ths could seem to "fight" with the NTP corrected
time, where as if the system time was off by 1 second, and NTP slewed the
value in, a suspend/resume cycle could undo this correction, by trying to
restore the previous offset from the RTC. However, without this patch,
since each read could cause almost a full second worth of error, its
possible to get almost 2 seconds of error just from the suspend/resume
cycle alone, so this about equal to any offset added by the compensation.

Further on systems that suspend/resume frequently, this should keep time
closer then NTP could compensate for if the errors were allowed to
accumulate.

Credits to Arve Hjønnevåg for suggesting this solution.

This patch also improves some of the variable names and adds more clear
comments.

CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/class.c |   65 +++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 4194e59..a619228 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -41,20 +41,41 @@ static void rtc_device_release(struct device *dev)
  * system's wall clock; restore it on resume().
  */
 
-static time_t		oldtime;
-static struct timespec	oldts;
+static struct timespec old_rtc, old_system, old_delta;
+
 
 static int rtc_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-
+	struct timespec		delta, delta_delta;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
+	/* snapshot the current RTC and system time at suspend*/
 	rtc_read_time(rtc, &tm);
-	ktime_get_ts(&oldts);
-	rtc_tm_to_time(&tm, &oldtime);
+	getnstimeofday(&old_system);
+	rtc_tm_to_time(&tm, &old_rtc.tv_sec);
+
+
+	/*
+	 * To avoid drift caused by repeated suspend/resumes,
+	 * which each can add ~1 second drift error,
+	 * try to compensate so the difference in system time
+	 * and rtc time stays close to constant.
+	 */
+	delta = timespec_sub(old_system, old_rtc);
+	delta_delta = timespec_sub(delta, old_delta);
+	if (abs(delta_delta.tv_sec)  >= 2) {
+		/*
+		 * if delta_delta is too large, assume time correction
+		 * has occured and set old_delta to the current delta.
+		 */
+		old_delta = delta;
+	} else {
+		/* Otherwise try to adjust old_system to compensate */
+		old_system = timespec_sub(old_system, delta_delta);
+	}
 
 	return 0;
 }
@@ -63,32 +84,42 @@ static int rtc_resume(struct device *dev)
 {
 	struct rtc_device	*rtc = to_rtc_device(dev);
 	struct rtc_time		tm;
-	time_t			newtime;
-	struct timespec		time;
-	struct timespec		newts;
+	struct timespec		new_system, new_rtc;
+	struct timespec		sleep_time;
 
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
-	ktime_get_ts(&newts);
+	/* snapshot the current rtc and system time at resume */
+	getnstimeofday(&new_system);
 	rtc_read_time(rtc, &tm);
 	if (rtc_valid_tm(&tm) != 0) {
 		pr_debug("%s:  bogus resume time\n", dev_name(&rtc->dev));
 		return 0;
 	}
-	rtc_tm_to_time(&tm, &newtime);
-	if (newtime <= oldtime) {
-		if (newtime < oldtime)
+	rtc_tm_to_time(&tm, &new_rtc.tv_sec);
+	new_rtc.tv_nsec = 0;
+
+	if (new_rtc.tv_sec <= old_rtc.tv_sec) {
+		if (new_rtc.tv_sec < old_rtc.tv_sec)
 			pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
 		return 0;
 	}
-	/* calculate the RTC time delta */
-	set_normalized_timespec(&time, newtime - oldtime, 0);
 
-	/* subtract kernel time between rtc_suspend to rtc_resume */
-	time = timespec_sub(time, timespec_sub(newts, oldts));
+	/* calculate the RTC time delta (sleep time)*/
+	sleep_time = timespec_sub(new_rtc, old_rtc);
+
+	/*
+	 * Since these RTC suspend/resume handlers are not called
+	 * at the very end of suspend or the start of resume,
+	 * some run-time may pass on either sides of the sleep time
+	 * so subtract kernel run-time between rtc_suspend to rtc_resume
+	 * to keep things accurate.
+	 */
+	sleep_time = timespec_sub(sleep_time,
+			timespec_sub(new_system, old_system));
 
-	timekeeping_inject_sleeptime(&time);
+	timekeeping_inject_sleeptime(&sleep_time);
 	return 0;
 }
 
-- 
1.7.3.2.146.gca209

