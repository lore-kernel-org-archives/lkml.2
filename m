Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946098Ab2EROKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:10:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34586 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031240Ab2EROKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:21 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V2 5/6] time: move leap second management into time keeping core
Date: Fri, 18 May 2012 16:09:57 +0200
Message-Id: <5f60e1921361bc58ff4c3ed252528bc0914a7b35.1337348892.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors the timekeeping and ntp code in order to
improve leap second handling and to provide a TAI based clock.
The change has a number of aspects.

* remove the NTP time_status variable

Instead, compute this value on demand in adjtimex.

* move TAI managment into timekeeping core from ntp

Currently NTP manages the TAI offset. Since there's plans for a
CLOCK_TAI clockid, push the TAI management into the timekeeping
core.

[ Original idea from: John Stultz <john.stultz@linaro.org> ]
[ Changed by RC: ]

  - replace u32 with time_t
  - fixup second call site of second_overflow()

* replace modulus with integer test and schedule leap second

On the day of a leap second, the NTP code performs a division on every
tick in order to know when to leap. This patch replaces the division
with an integer comparison, making the code faster and easier to
understand.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/time.h      |    1 +
 kernel/time/ntp.c         |   86 +++++++++++++-------------------------------
 kernel/time/timekeeping.c |   54 ++++++++++++++++++++++++----
 3 files changed, 73 insertions(+), 68 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 179f4d6..b6034b0 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -168,6 +168,7 @@ extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern int timekeeping_inject_offset(struct timespec *ts);
+extern void timekeeping_set_tai_offset(time_t tai_offset);
 
 struct tms;
 extern void do_sys_times(struct tms *);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d4d48b0..53c3227 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 
+#include "leap-seconds.h"
 #include "tick-internal.h"
 
 /*
@@ -24,6 +25,7 @@
 
 DEFINE_SPINLOCK(ntp_lock);
 
+#define STA_LEAP		(STA_INS | STA_DEL)
 
 /* USER_HZ period (usecs): */
 unsigned long			tick_usec = TICK_USEC;
@@ -42,19 +44,9 @@ static u64			tick_length_base;
  * phase-lock loop variables
  */
 
-/*
- * clock synchronization status
- *
- * (TIME_ERROR prevents overwriting the CMOS clock)
- */
-static int			time_state = TIME_OK;
-
 /* clock status bits:							*/
 static int			time_status = STA_UNSYNC;
 
-/* TAI offset (secs):							*/
-static long			time_tai;
-
 /* time adjustment (nsecs):						*/
 static s64			time_offset;
 
@@ -386,57 +378,14 @@ u64 ntp_tick_length(void)
  * They were originally developed for SUN and DEC kernels.
  * All the kudos should go to Dave for this stuff.
  *
- * Also handles leap second processing, and returns leap offset
  */
 int second_overflow(unsigned long secs)
 {
 	s64 delta;
-	int leap = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ntp_lock, flags);
 
-	/*
-	 * Leap second processing. If in leap-insert state at the end of the
-	 * day, the system clock is set back one second; if in leap-delete
-	 * state, the system clock is set ahead one second.
-	 */
-	switch (time_state) {
-	case TIME_OK:
-		if (time_status & STA_INS)
-			time_state = TIME_INS;
-		else if (time_status & STA_DEL)
-			time_state = TIME_DEL;
-		break;
-	case TIME_INS:
-		if (secs % 86400 == 0) {
-			leap = -1;
-			time_state = TIME_OOP;
-			time_tai++;
-			printk(KERN_NOTICE
-				"Clock: inserting leap second 23:59:60 UTC\n");
-		}
-		break;
-	case TIME_DEL:
-		if ((secs + 1) % 86400 == 0) {
-			leap = 1;
-			time_tai--;
-			time_state = TIME_WAIT;
-			printk(KERN_NOTICE
-				"Clock: deleting leap second 23:59:59 UTC\n");
-		}
-		break;
-	case TIME_OOP:
-		time_state = TIME_WAIT;
-		break;
-
-	case TIME_WAIT:
-		if (!(time_status & (STA_INS | STA_DEL)))
-			time_state = TIME_OK;
-		break;
-	}
-
-
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
 	if (time_maxerror > NTP_PHASE_LIMIT) {
@@ -478,7 +427,7 @@ int second_overflow(unsigned long secs)
 out:
 	spin_unlock_irqrestore(&ntp_lock, flags);
 
-	return leap;
+	return 0;
 }
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
@@ -543,7 +492,6 @@ static inline void notify_cmos_timer(void) { }
 static inline void process_adj_status(struct timex *txc)
 {
 	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
-		time_state = TIME_OK;
 		time_status = STA_UNSYNC;
 		/* restart PPS frequency calibration */
 		pps_reset_freq_interval();
@@ -565,7 +513,7 @@ static inline void process_adj_status(struct timex *txc)
  * Called with the xtime lock held, so we can access and modify
  * all the global NTP state:
  */
-static inline void process_adjtimex_modes(struct timex *txc)
+static inline void process_adjtimex_modes(struct timex *txc, time_t *time_tai)
 {
 	if (txc->modes & ADJ_STATUS)
 		process_adj_status(txc);
@@ -599,7 +547,7 @@ static inline void process_adjtimex_modes(struct timex *txc)
 	}
 
 	if (txc->modes & ADJ_TAI && txc->constant > 0)
-		time_tai = txc->constant;
+		*time_tai = txc->constant;
 
 	if (txc->modes & ADJ_OFFSET)
 		ntp_update_offset(txc->offset);
@@ -618,6 +566,7 @@ static inline void process_adjtimex_modes(struct timex *txc)
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
+	time_t time_tai, orig_tai;
 	int result;
 
 	/* Validate the data before disabling interrupts */
@@ -656,7 +605,22 @@ int do_adjtimex(struct timex *txc)
 			return result;
 	}
 
-	getnstimeofday(&ts);
+	result = timekeeping_gettod_status(&ts, &orig_tai);
+	time_tai = orig_tai;
+
+	if (txc->modes & ADJ_STATUS) {
+		/*
+		 * Check for new leap second commands.
+		 */
+		if (!(time_status & STA_INS) && (txc->status & STA_INS))
+			timekeeping_insert_leap_second();
+
+		else if (!(time_status & STA_DEL) && (txc->status & STA_DEL))
+			timekeeping_delete_leap_second();
+
+		else if ((time_status & STA_LEAP) && !(txc->status & STA_LEAP))
+			timekeeping_finish_leap_second();
+	}
 
 	spin_lock_irq(&ntp_lock);
 
@@ -673,7 +637,7 @@ int do_adjtimex(struct timex *txc)
 
 		/* If there are input parameters, then process them: */
 		if (txc->modes)
-			process_adjtimex_modes(txc);
+			process_adjtimex_modes(txc, &time_tai);
 
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 				  NTP_SCALE_SHIFT);
@@ -681,7 +645,6 @@ int do_adjtimex(struct timex *txc)
 			txc->offset /= NSEC_PER_USEC;
 	}
 
-	result = time_state;	/* mostly `TIME_OK' */
 	/* check for errors */
 	if (is_error_status(time_status))
 		result = TIME_ERROR;
@@ -702,6 +665,9 @@ int do_adjtimex(struct timex *txc)
 
 	spin_unlock_irq(&ntp_lock);
 
+	if (time_tai != orig_tai && result == TIME_OK)
+		timekeeping_set_tai_offset(time_tai);
+
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
 	if (!(time_status & STA_NANO))
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index eab03fb..fdd1a48 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -444,6 +444,18 @@ int timekeeping_inject_offset(struct timespec *ts)
 EXPORT_SYMBOL(timekeeping_inject_offset);
 
 /**
+ * timekeeping_set_tai_offset - Sets the current TAI offset from UTC
+ */
+void timekeeping_set_tai_offset(time_t tai_offset)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+	timekeeper.tai_offset = tai_offset;
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+}
+
+/**
  * change_clocksource - Swaps clocksources if a new one is available
  *
  * Accumulates current time interval and initializes new clocksource
@@ -950,6 +962,38 @@ static void timekeeping_adjust(s64 offset)
 				timekeeper.ntp_error_shift;
 }
 
+static void timekeeper_overflow(void)
+{
+	timekeeper.xtime.tv_sec++;
+
+	switch (timekeeper.leap_state) {
+
+	case LEAP_IDLE:
+	case LEAP_INS_DONE:
+	case LEAP_DEL_DONE:
+		break;
+
+	case LEAP_INS_PENDING:
+		if (timekeeper.xtime.tv_sec == timekeeper.utc_epoch) {
+			pr_notice("Clock: inserting leap second 23:59:60 UTC\n");
+			timekeeper.xtime.tv_sec--;
+			timekeeper.tai_offset++;
+			timekeeper.leap_state = LEAP_INS_DONE;
+		}
+		break;
+
+	case LEAP_DEL_PENDING:
+		if (timekeeper.xtime.tv_sec + 1 == timekeeper.utc_epoch) {
+			pr_notice("Clock: deleting leap second 23:59:59 UTC\n");
+			timekeeper.xtime.tv_sec++;
+			timekeeper.tai_offset--;
+			timekeeper.leap_state = LEAP_DEL_DONE;
+		}
+		break;
+	}
+
+	second_overflow(timekeeper.xtime.tv_sec);
+}
 
 /**
  * logarithmic_accumulation - shifted accumulation of cycles
@@ -975,11 +1019,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
 	while (timekeeper.xtime_nsec >= nsecps) {
-		int leap;
 		timekeeper.xtime_nsec -= nsecps;
-		timekeeper.xtime.tv_sec++;
-		leap = second_overflow(timekeeper.xtime.tv_sec);
-		timekeeper.xtime.tv_sec += leap;
+		timekeeper_overflow();
 	}
 
 	/* Accumulate raw time */
@@ -1090,11 +1131,8 @@ static void update_wall_time(void)
 	 * xtime.tv_nsec isn't larger than NSEC_PER_SEC
 	 */
 	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
-		int leap;
 		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
-		timekeeper.xtime.tv_sec++;
-		leap = second_overflow(timekeeper.xtime.tv_sec);
-		timekeeper.xtime.tv_sec += leap;
+		timekeeper_overflow();
 	}
 
 	timekeeping_update(false);
-- 
1.7.2.5

