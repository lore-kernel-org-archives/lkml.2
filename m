Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1E2KvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:51:03 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57569 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1E2KvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:51:01 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, richard.cochran@omicron.at, tglx@linutronix.de,
        arnd@arndb.de, peterz@infradead.org, toralf.foerster@gmx.de,
        Richard Weinberger <richard@nod.at>
Subject: [RFC][PATCH] timers: Make alarmtimer depend on CONFIG_RTC_CLASS
Date: Sun, 29 May 2011 12:48:51 +0200
Message-Id: <1306666131-6161-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alarmtimer interface makes IMHO only sense when a RTC device
is available.
On systems with !CONFIG_RTC_CLASS (like UML) the warning
"Kernel not built with RTC support, ALARM timers will not wake from suspend"
is annoying.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 kernel/time/Makefile     |    3 ++-
 kernel/time/alarmtimer.c |   19 +------------------
 2 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index e2fd74b..224f833 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,6 +1,7 @@
 obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o
-obj-y += timeconv.o posix-clock.o alarmtimer.o
+obj-y += timeconv.o posix-clock.o
 
+obj-$(CONFIG_RTC_CLASS) += alarmtimer.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 2d96624..c1f2898 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -42,11 +42,9 @@ static struct alarm_base {
 	clockid_t		base_clockid;
 } alarm_bases[ALARM_NUMTYPE];
 
-#ifdef CONFIG_RTC_CLASS
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer		rtctimer;
 static struct rtc_device	*rtcdev;
-#endif
 
 /* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
 static ktime_t freezer_delta;
@@ -150,7 +148,6 @@ static enum hrtimer_restart alarmtimer_fired(struct hrtimer *timer)
 
 }
 
-#ifdef CONFIG_RTC_CLASS
 /**
  * alarmtimer_suspend - Suspend time callback
  * @dev: unused
@@ -208,12 +205,6 @@ static int alarmtimer_suspend(struct device *dev)
 
 	return 0;
 }
-#else
-static int alarmtimer_suspend(struct device *dev)
-{
-	return 0;
-}
-#endif
 
 static void alarmtimer_freezerset(ktime_t absexp, enum alarmtimer_type type)
 {
@@ -638,7 +629,6 @@ static int __init alarmtimer_init(void)
 }
 device_initcall(alarmtimer_init);
 
-#ifdef CONFIG_RTC_CLASS
 /**
  * has_wakealarm - check rtc device has wakealarm ability
  * @dev: current device
@@ -691,12 +681,5 @@ static int __init alarmtimer_init_late(void)
 
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
+
 late_initcall(alarmtimer_init_late);
-- 
1.7.5.3

