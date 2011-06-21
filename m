Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab1FUXxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:53:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40718 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab1FUXxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:53:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] alarmtimers: Return -ENOTSUPP if no RTC device is present
Date: Tue, 21 Jun 2011 16:52:53 -0700
Message-Id: <1308700373-18415-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1308700373-18415-1-git-send-email-john.stultz@linaro.org>
References: <1308700373-18415-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster and Richard Weinberger noted that if there is
no RTC device, the alarm timers core prints out an annoying
"ALARM timers will not wake from suspend" message.

This warning has been removed in a previous patch, however
the issue still remains:  The original idea was to support
alarm timers even if there was no rtc device, as long as the
system didn't go into suspend.

However, after further consideration, communicating to the application
that alarmtimers are not fully functional seems like the better
solution.

So this patch makes it so we return -ENOTSUPP to any posix _ALARM
clockid calls if there is no backing RTC device on the system.

Further this changes the behavior where when there is no rtc device
we will check for one on clock_getres, clock_gettime, timer_create,
and timer_nsleep instead of on suspend.

CC: Toralf Förster <toralf.foerster@gmx.de>
CC: Richard Weinberger <richard@nod.at
CC: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Reported by: Richard Weinberger <richard@nod.at>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 98ecf4e..59f369f 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -107,6 +107,9 @@ static struct rtc_device *alarmtimer_get_rtcdev(void)
 
 	return ret;
 }
+#else
+#define alarmtimer_get_rtcdev() (0)
+#define rtcdev (0)
 #endif
 
 
@@ -231,7 +234,7 @@ static int alarmtimer_suspend(struct device *dev)
 	freezer_delta = ktime_set(0, 0);
 	spin_unlock_irqrestore(&freezer_delta_lock, flags);
 
-	rtc = alarmtimer_get_rtcdev();
+	rtc = rtcdev;
 	/* If we have no rtcdev, just return */
 	if (!rtc)
 		return 0;
@@ -381,6 +384,9 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	return hrtimer_get_res(baseid, tp);
 }
 
@@ -395,6 +401,9 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 {
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;
 }
@@ -410,6 +419,9 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 	enum  alarmtimer_type type;
 	struct alarm_base *base;
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
@@ -444,6 +456,9 @@ static void alarm_timer_get(struct k_itimer *timr,
  */
 static int alarm_timer_del(struct k_itimer *timr)
 {
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	alarm_cancel(&timr->it.alarmtimer);
 	return 0;
 }
@@ -461,6 +476,9 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 				struct itimerspec *new_setting,
 				struct itimerspec *old_setting)
 {
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	/* Save old values */
 	old_setting->it_interval =
 			ktime_to_timespec(timr->it.alarmtimer.period);
@@ -600,6 +618,9 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 	int ret = 0;
 	struct restart_block *restart;
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
-- 
1.7.3.2.146.gca209

