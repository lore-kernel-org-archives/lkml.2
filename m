Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1KOEE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:58 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38906 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab1KOEEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 09/16] ntp: Add ntp_lock to replace xtime_locking
Date: Mon, 14 Nov 2011 20:03:59 -0800
Message-Id: <1321329846-14755-10-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-1976-0000-0000-0000037F03CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a ntp_lock seqlock to replace xtime_lock locking in ntp.c

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c |   63 +++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f131ba6..a0756b3 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -22,6 +22,9 @@
  * NTP timekeeping variables:
  */
 
+DEFINE_SEQLOCK(ntp_lock);
+
+
 /* USER_HZ period (usecs): */
 unsigned long			tick_usec = TICK_USEC;
 
@@ -133,7 +136,7 @@ static inline void pps_reset_freq_interval(void)
 /**
  * pps_clear - Clears the PPS state variables
  *
- * Must be called while holding a write on the xtime_lock
+ * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_clear(void)
 {
@@ -149,7 +152,7 @@ static inline void pps_clear(void)
  * the last PPS signal. When it reaches 0, indicate that PPS signal is
  * missing.
  *
- * Must be called while holding a write on the xtime_lock
+ * Must be called while holding a write on the ntp_lock
  */
 static inline void pps_dec_valid(void)
 {
@@ -341,11 +344,13 @@ static void ntp_update_offset(long offset)
 
 /**
  * ntp_clear - Clears the NTP state variables
- *
- * Must be called while holding a write on the xtime_lock
  */
 void ntp_clear(void)
 {
+	unsigned long flags;
+
+	write_seqlock_irqsave(&ntp_lock, flags);
+
 	time_adjust	= 0;		/* stop active adjtime() */
 	time_status	|= STA_UNSYNC;
 	time_maxerror	= NTP_PHASE_LIMIT;
@@ -358,12 +363,21 @@ void ntp_clear(void)
 
 	/* Clear PPS state variables */
 	pps_clear();
+	write_sequnlock_irqrestore(&ntp_lock, flags);
+
 }
 
 
 u64 ntp_tick_length(void)
 {
-	return tick_length;
+	unsigned long seq;
+	s64 ret;
+
+	do {
+		seq = read_seqbegin(&ntp_lock);
+		ret = tick_length;
+	} while (read_seqretry(&ntp_lock, seq));
+	return ret;
 }
 
 
@@ -375,14 +389,14 @@ u64 ntp_tick_length(void)
 static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 {
 	enum hrtimer_restart res = HRTIMER_NORESTART;
+	int leap = 0;
 
-	write_seqlock(&xtime_lock);
-
+	write_seqlock(&ntp_lock);
 	switch (time_state) {
 	case TIME_OK:
 		break;
 	case TIME_INS:
-		timekeeping_leap_insert(-1);
+		leap = -1;
 		time_state = TIME_OOP;
 		printk(KERN_NOTICE
 			"Clock: inserting leap second 23:59:60 UTC\n");
@@ -390,7 +404,7 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 		res = HRTIMER_RESTART;
 		break;
 	case TIME_DEL:
-		timekeeping_leap_insert(1);
+		leap = 1;
 		time_tai--;
 		time_state = TIME_WAIT;
 		printk(KERN_NOTICE
@@ -405,8 +419,14 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 			time_state = TIME_OK;
 		break;
 	}
+	write_sequnlock(&ntp_lock);
 
-	write_sequnlock(&xtime_lock);
+	/*
+	 * We have to call this outside of the ntp_lock to keep
+	 * the proper locking hierarchy
+	 */
+	if (leap)
+		timekeeping_leap_insert(leap);
 
 	return res;
 }
@@ -422,6 +442,9 @@ static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
 void second_overflow(void)
 {
 	s64 delta;
+	unsigned long flags;
+
+	write_seqlock_irqsave(&ntp_lock, flags);
 
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
@@ -441,23 +464,25 @@ void second_overflow(void)
 	pps_dec_valid();
 
 	if (!time_adjust)
-		return;
+		goto out;
 
 	if (time_adjust > MAX_TICKADJ) {
 		time_adjust -= MAX_TICKADJ;
 		tick_length += MAX_TICKADJ_SCALED;
-		return;
+		goto out;
 	}
 
 	if (time_adjust < -MAX_TICKADJ) {
 		time_adjust += MAX_TICKADJ;
 		tick_length -= MAX_TICKADJ_SCALED;
-		return;
+		goto out;
 	}
 
 	tick_length += (s64)(time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
 	time_adjust = 0;
+out:
+	write_sequnlock_irqrestore(&ntp_lock, flags);
 }
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
@@ -681,7 +706,7 @@ int do_adjtimex(struct timex *txc)
 
 	getnstimeofday(&ts);
 
-	write_seqlock_irq(&xtime_lock);
+	write_seqlock_irq(&ntp_lock);
 
 	if (txc->modes & ADJ_ADJTIME) {
 		long save_adjust = time_adjust;
@@ -723,7 +748,7 @@ int do_adjtimex(struct timex *txc)
 	/* fill PPS status fields */
 	pps_fill_timex(txc);
 
-	write_sequnlock_irq(&xtime_lock);
+	write_sequnlock_irq(&ntp_lock);
 
 	txc->time.tv_sec = ts.tv_sec;
 	txc->time.tv_usec = ts.tv_nsec;
@@ -921,7 +946,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-	write_seqlock_irqsave(&xtime_lock, flags);
+	write_seqlock_irqsave(&ntp_lock, flags);
 
 	/* clear the error bits, they will be set again if needed */
 	time_status &= ~(STA_PPSJITTER | STA_PPSWANDER | STA_PPSERROR);
@@ -934,7 +959,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 	 * just start the frequency interval */
 	if (unlikely(pps_fbase.tv_sec == 0)) {
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_sequnlock_irqrestore(&ntp_lock, flags);
 		return;
 	}
 
@@ -949,7 +974,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 		time_status |= STA_PPSJITTER;
 		/* restart the frequency calibration interval */
 		pps_fbase = *raw_ts;
-		write_sequnlock_irqrestore(&xtime_lock, flags);
+		write_sequnlock_irqrestore(&ntp_lock, flags);
 		pr_err("hardpps: PPSJITTER: bad pulse\n");
 		return;
 	}
@@ -966,7 +991,7 @@ void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 
 	hardpps_update_phase(pts_norm.nsec);
 
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+	write_sequnlock_irqrestore(&ntp_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
 
-- 
1.7.3.2.146.gca209

