Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792Ab2D0INV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:13:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63568 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab2D0INK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:13:10 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V1 5/5] timekeeping: Use a continuous timescale to tell time.
Date: Fri, 27 Apr 2012 10:12:44 +0200
Message-Id: <35c0c03617503dba8cb4001350c57a6db1be6d29.1335510125.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <cover.1335510125.git.richardcochran@gmail.com>
References: <cover.1335510125.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the core time keeping code to use a continuous
timescale called the Kernel Time Scale (KTS). KTS is based on the
TAI timescale but can be offset from it by an integral number of seconds.
Every function that returns UTC time now coverts the seconds by adding
the current KTS - UTC offset.

As a result of this change, the NTP leap second code is considerably
simplified and hopefully more robust.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/timex.h     |    2 +-
 kernel/time/ntp.c         |   81 ++++++++++----------------------------------
 kernel/time/timekeeping.c |   73 ++++++++++++++++++++++++++++++++--------
 3 files changed, 79 insertions(+), 77 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 99bc88b..9461e6f 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -252,7 +252,7 @@ extern void ntp_clear(void);
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
 extern u64 ntp_tick_length(void);
 
-extern int second_overflow(unsigned long secs);
+void second_overflow(void);
 extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index d0a2183..91de2f8 100644
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
-int second_overflow(unsigned long secs)
+void second_overflow(void)
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
-		time_tai++;
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
@@ -475,8 +424,6 @@ int second_overflow(unsigned long secs)
 
 out:
 	spin_unlock_irqrestore(&ntp_lock, flags);
-
-	return leap;
 }
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
@@ -541,7 +488,6 @@ static inline void notify_cmos_timer(void) { }
 static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 {
 	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
-		time_state = TIME_OK;
 		time_status = STA_UNSYNC;
 		/* restart PPS frequency calibration */
 		pps_reset_freq_interval();
@@ -554,6 +500,18 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
 		time_reftime = get_seconds();
 
+	/*
+	 * Check for new leap second commands.
+	 */
+	if (!(time_status & STA_INS) && (txc->status & STA_INS))
+		timekeeper_insert_leap_second();
+
+	else if (!(time_status & STA_DEL) && (txc->status & STA_DEL))
+		timekeeper_delete_leap_second();
+
+	else if ((time_status & STA_LEAP) && !(txc->status & STA_LEAP))
+		timekeeper_finish_leap_second();
+
 	/* only set allowed bits */
 	time_status &= STA_RONLY;
 	time_status |= txc->status & ~STA_RONLY;
@@ -597,7 +555,7 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 	}
 
 	if (txc->modes & ADJ_TAI && txc->constant > 0)
-		time_tai = txc->constant;
+		timekeeper_tai_offset(txc->constant);
 
 	if (txc->modes & ADJ_OFFSET)
 		ntp_update_offset(txc->offset);
@@ -616,7 +574,7 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
-	int result;
+	int result, tai_offset;
 
 	/* Validate the data before disabling interrupts */
 	if (txc->modes & ADJ_ADJTIME) {
@@ -654,7 +612,7 @@ int do_adjtimex(struct timex *txc)
 			return result;
 	}
 
-	getnstimeofday(&ts);
+	result = timekeeper_gettod_status(&ts, &tai_offset);
 
 	spin_lock_irq(&ntp_lock);
 
@@ -679,7 +637,6 @@ int do_adjtimex(struct timex *txc)
 			txc->offset /= NSEC_PER_USEC;
 	}
 
-	result = time_state;	/* mostly `TIME_OK' */
 	/* check for errors */
 	if (is_error_status(time_status))
 		result = TIME_ERROR;
@@ -693,7 +650,7 @@ int do_adjtimex(struct timex *txc)
 	txc->precision	   = 1;
 	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
 	txc->tick	   = tick_usec;
-	txc->tai	   = time_tai;
+	txc->tai	   = tai_offset;
 
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7941258..6cedf46 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -212,11 +212,14 @@ static inline s64 timekeeping_get_ns_raw(void)
 /* must hold write on timekeeper.lock */
 static void timekeeping_update(bool clearntp)
 {
+	struct timespec ts;
 	if (clearntp) {
 		timekeeper.ntp_error = 0;
 		ntp_clear();
 	}
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+	ts.tv_sec = timekeeper_utc_sec();
+	ts.tv_nsec = timekeeper.xtime.tv_nsec;
+	update_vsyscall(&ts, &timekeeper.wall_to_monotonic,
 			 timekeeper.clock, timekeeper.mult);
 }
 
@@ -267,7 +270,8 @@ void getnstimeofday(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		*ts = timekeeper.xtime;
+		ts->tv_sec = timekeeper_utc_sec();
+		ts->tv_nsec = timekeeper.xtime.tv_nsec;
 		nsecs = timekeeping_get_ns();
 
 		/* If arch requires, add in gettimeoffset() */
@@ -360,7 +364,8 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		seq = read_seqbegin(&timekeeper.lock);
 
 		*ts_raw = timekeeper.raw_time;
-		*ts_real = timekeeper.xtime;
+		ts_real->tv_sec = timekeeper_utc_sec();
+		ts_real->tv_nsec = timekeeper.xtime.tv_nsec;
 
 		nsecs_raw = timekeeping_get_ns_raw();
 		nsecs_real = timekeeping_get_ns();
@@ -404,6 +409,7 @@ EXPORT_SYMBOL(do_gettimeofday);
 int do_settimeofday(const struct timespec *tv)
 {
 	struct timespec ts_delta;
+	time_t kts_seconds;
 	unsigned long flags;
 
 	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
@@ -413,12 +419,16 @@ int do_settimeofday(const struct timespec *tv)
 
 	timekeeping_forward_now();
 
-	ts_delta.tv_sec = tv->tv_sec - timekeeper.xtime.tv_sec;
+	kts_seconds = utc_to_tai(tv->tv_sec, timekeeper.next_leapsecond,
+				 timekeeper.kts_utc_offset, tk_insert);
+
+	ts_delta.tv_sec = kts_seconds - timekeeper.xtime.tv_sec;
 	ts_delta.tv_nsec = tv->tv_nsec - timekeeper.xtime.tv_nsec;
 	timekeeper.wall_to_monotonic =
 			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
 
-	timekeeper.xtime = *tv;
+	timekeeper.xtime.tv_sec = kts_seconds;
+	timekeeper.xtime.tv_nsec = tv->tv_nsec;
 	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
@@ -769,6 +779,21 @@ void __init timekeeping_init(void)
 		clock->enable(clock);
 	timekeeper_setup_internals(clock);
 
+	/*
+	 * If the TAI offset is not set or unreasonable, start with
+	 * the offset as of 1 Jan 2009.
+	 */
+	if (timekeeper.kts_utc_offset < 10)
+		timekeeper.kts_utc_offset = 34;
+
+	timekeeper.next_leapsecond = LONG_MAX;
+
+#ifdef CONFIG_DELETE_LEAP_SECONDS
+	timekeeper.insert_leapsecond = 1;
+#endif
+	now.tv_sec = utc_to_tai(now.tv_sec, timekeeper.next_leapsecond,
+				timekeeper.kts_utc_offset, tk_insert);
+
 	timekeeper.xtime.tv_sec = now.tv_sec;
 	timekeeper.xtime.tv_nsec = now.tv_nsec;
 	timekeeper.raw_time.tv_sec = 0;
@@ -1132,11 +1157,9 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
 	while (timekeeper.xtime_nsec >= nsecps) {
-		int leap;
 		timekeeper.xtime_nsec -= nsecps;
 		timekeeper.xtime.tv_sec++;
-		leap = second_overflow(timekeeper.xtime.tv_sec);
-		timekeeper.xtime.tv_sec += leap;
+		second_overflow();
 	}
 
 	/* Accumulate raw time */
@@ -1247,11 +1270,9 @@ static void update_wall_time(void)
 	 * xtime.tv_nsec isn't larger than NSEC_PER_SEC
 	 */
 	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
-		int leap;
 		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
 		timekeeper.xtime.tv_sec++;
-		leap = second_overflow(timekeeper.xtime.tv_sec);
-		timekeeper.xtime.tv_sec += leap;
+		second_overflow();
 	}
 
 	timekeeping_update(false);
@@ -1346,13 +1367,35 @@ EXPORT_SYMBOL_GPL(monotonic_to_bootbased);
 
 unsigned long get_seconds(void)
 {
-	return timekeeper.xtime.tv_sec;
+	unsigned long seconds, seq;
+
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+		seconds = timekeeper_utc_sec();
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+	return seconds;
 }
 EXPORT_SYMBOL(get_seconds);
 
 struct timespec __current_kernel_time(void)
 {
-	return timekeeper.xtime;
+/*
+ * TODO - What do the two callers really expect?
+ *        Why don't they take the lock?
+ *
+ * linux/arch/x86/kernel/vsyscall_64.c: update_vsyscall[104]
+ *
+ *	vsyscall_gtod_data.wall_time_coarse = __current_kernel_time();
+ *
+ * linux/kernel/debug/kdb/kdb_main.c:   kdb_summary[2570]
+ *
+ *	now = __current_kernel_time();
+ */
+	struct timespec ts;
+	ts.tv_sec = timekeeper_utc_sec();
+	ts.tv_nsec = timekeeper.xtime.tv_nsec;
+	return ts;
 }
 
 struct timespec current_kernel_time(void)
@@ -1363,7 +1406,9 @@ struct timespec current_kernel_time(void)
 	do {
 		seq = read_seqbegin(&timekeeper.lock);
 
-		now = timekeeper.xtime;
+		now.tv_sec = timekeeper_utc_sec();
+		now.tv_nsec = timekeeper.xtime.tv_nsec;
+
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	return now;
-- 
1.7.2.5

