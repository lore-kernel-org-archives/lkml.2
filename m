Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1FNCE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:04:59 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43897 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1FNCE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:04:57 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC][PATCH] alarmtimers: Return -ENOTSUPP if no RTC device is present
Date: Mon, 13 Jun 2011 19:04:48 -0700
Message-Id: <1308017088-8233-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, all:
I wanted to send this out for initial feedback, but I think
it would be good to get this in for the final 3.0 release.

Let me know your thoughts here.

thanks
-john


Toralf Förster and Richard Weinberger noted that if there is
no RTC device, the alarm timers core prints out an annoying
"ALARM timers will not wake from suspend" message.

The original idea was to support alarm timers even if there
was no rtc device, as long as the system didn't go into suspend.

However, after further consideration, communicating to the application
that alarmtimers are not fully functional seems like the better
solution.

So this patch makes it so we return -ENOTSUPP to any posix _ALARM
clockid calls if there is no backing RTC device on the system.

CC: Toralf Förster <toralf.foerster@gmx.de>
CC: Richard Weinberger <richard@nod.at
CC: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Reported by: Richard Weinberger <richard@nod.at>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/alarmtimer.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 2d96624..aee3e53 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -46,6 +46,8 @@ static struct alarm_base {
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer		rtctimer;
 static struct rtc_device	*rtcdev;
+#else
+#define rtcdev 0
 #endif
 
 /* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
@@ -322,6 +324,8 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
+	if (!rtcdev)
+		return -ENOTSUPP;
 	return hrtimer_get_res(baseid, tp);
 }
 
@@ -336,6 +340,9 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 {
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;
 }
@@ -351,6 +358,9 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 	enum  alarmtimer_type type;
 	struct alarm_base *base;
 
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
@@ -385,6 +395,9 @@ static void alarm_timer_get(struct k_itimer *timr,
  */
 static int alarm_timer_del(struct k_itimer *timr)
 {
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	alarm_cancel(&timr->it.alarmtimer);
 	return 0;
 }
@@ -402,6 +415,9 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 				struct itimerspec *new_setting,
 				struct itimerspec *old_setting)
 {
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	/* Save old values */
 	old_setting->it_interval =
 			ktime_to_timespec(timr->it.alarmtimer.period);
@@ -541,6 +557,9 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 	int ret = 0;
 	struct restart_block *restart;
 
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
@@ -683,20 +702,9 @@ static int __init alarmtimer_init_late(void)
 		 */
 		put_device(dev);
 	}
-	if (!rtcdev) {
-		printk(KERN_WARNING "No RTC device found, ALARM timers will"
-			" not wake from suspend");
-	}
 	rtc_timer_init(&rtctimer, NULL, NULL);
 
 	return 0;
 }
-#else
-static int __init alarmtimer_init_late(void)
-{
-	printk(KERN_WARNING "Kernel not built with RTC support, ALARM timers"
-		" will not wake from suspend");
-	return 0;
-}
-#endif
 late_initcall(alarmtimer_init_late);
+#endif
-- 
1.7.3.2.146.gca209

