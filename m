Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab2HWKYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:24:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:53474 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab2HWKY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:24:28 -0400
Date: Thu, 23 Aug 2012 12:24:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: [GIT pull] timer fixes for 3.6
Message-ID: <alpine.LFD.2.02.1208231220000.2856@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Mostly small fixes for the fallout of the timekeeping overhaul in 3.6
along with stable fixes to address an accumulation problem and missing
sanity checks for RTC readouts and user space provided values.

Thanks,

	tglx

------------------>
Andreas Schwab (1):
      time: Fix casting issue in timekeeping_forward_now

John Stultz (4):
      time: Improve sanity checking of timekeeping inputs
      time: Ensure we normalize the timekeeper in tk_xtime_add
      time: Avoid potential shift overflow with large shift values
      time: Avoid making adjustments if we haven't accumulated anything


 include/linux/ktime.h     |    7 -------
 include/linux/time.h      |   22 ++++++++++++++++++++--
 kernel/time/timekeeping.c |   37 ++++++++++++++++++++++++++++++++-----
 3 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index 603bec2..06177ba10 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -58,13 +58,6 @@ union ktime {
 
 typedef union ktime ktime_t;		/* Kill this */
 
-#define KTIME_MAX			((s64)~((u64)1 << 63))
-#if (BITS_PER_LONG == 64)
-# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
-#else
-# define KTIME_SEC_MAX			LONG_MAX
-#endif
-
 /*
  * ktime_t definitions when using the 64-bit scalar representation:
  */
diff --git a/include/linux/time.h b/include/linux/time.h
index c81c5e4..b0bbd8f 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -107,11 +107,29 @@ static inline struct timespec timespec_sub(struct timespec lhs,
 	return ts_delta;
 }
 
+#define KTIME_MAX			((s64)~((u64)1 << 63))
+#if (BITS_PER_LONG == 64)
+# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#else
+# define KTIME_SEC_MAX			LONG_MAX
+#endif
+
 /*
  * Returns true if the timespec is norm, false if denorm:
  */
-#define timespec_valid(ts) \
-	(((ts)->tv_sec >= 0) && (((unsigned long) (ts)->tv_nsec) < NSEC_PER_SEC))
+static inline bool timespec_valid(const struct timespec *ts)
+{
+	/* Dates before 1970 are bogus */
+	if (ts->tv_sec < 0)
+		return false;
+	/* Can't have more nanoseconds then a second */
+	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
+		return false;
+	/* Disallow values that could overflow ktime_t */
+	if ((unsigned long long)ts->tv_sec >= KTIME_SEC_MAX)
+		return false;
+	return true;
+}
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e16af19..0c1485e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -115,6 +115,7 @@ static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)
 {
 	tk->xtime_sec += ts->tv_sec;
 	tk->xtime_nsec += (u64)ts->tv_nsec << tk->shift;
+	tk_normalize_xtime(tk);
 }
 
 static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
@@ -276,7 +277,7 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
 	/* If arch requires, add in gettimeoffset() */
-	tk->xtime_nsec += arch_gettimeoffset() << tk->shift;
+	tk->xtime_nsec += (u64)arch_gettimeoffset() << tk->shift;
 
 	tk_normalize_xtime(tk);
 
@@ -427,7 +428,7 @@ int do_settimeofday(const struct timespec *tv)
 	struct timespec ts_delta, xt;
 	unsigned long flags;
 
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
+	if (!timespec_valid(tv))
 		return -EINVAL;
 
 	write_seqlock_irqsave(&tk->lock, flags);
@@ -463,6 +464,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
+	struct timespec tmp;
+	int ret = 0;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
@@ -471,10 +474,17 @@ int timekeeping_inject_offset(struct timespec *ts)
 
 	timekeeping_forward_now(tk);
 
+	/* Make sure the proposed value is valid */
+	tmp = timespec_add(tk_xtime(tk),  *ts);
+	if (!timespec_valid(&tmp)) {
+		ret = -EINVAL;
+		goto error;
+	}
 
 	tk_xtime_add(tk, ts);
 	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, *ts));
 
+error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(tk, true);
 
 	write_sequnlock_irqrestore(&tk->lock, flags);
@@ -482,7 +492,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	/* signal hrtimers about time change */
 	clock_was_set();
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(timekeeping_inject_offset);
 
@@ -649,7 +659,20 @@ void __init timekeeping_init(void)
 	struct timespec now, boot, tmp;
 
 	read_persistent_clock(&now);
+	if (!timespec_valid(&now)) {
+		pr_warn("WARNING: Persistent clock returned invalid value!\n"
+			"         Check your CMOS/BIOS settings.\n");
+		now.tv_sec = 0;
+		now.tv_nsec = 0;
+	}
+
 	read_boot_clock(&boot);
+	if (!timespec_valid(&boot)) {
+		pr_warn("WARNING: Boot clock returned invalid value!\n"
+			"         Check your CMOS/BIOS settings.\n");
+		boot.tv_sec = 0;
+		boot.tv_nsec = 0;
+	}
 
 	seqlock_init(&tk->lock);
 
@@ -1129,6 +1152,10 @@ static void update_wall_time(void)
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 
+	/* Check if there's really nothing to do */
+	if (offset < tk->cycle_interval)
+		goto out;
+
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
@@ -1161,9 +1188,9 @@ static void update_wall_time(void)
 	* the vsyscall implementations are converted to use xtime_nsec
 	* (shifted nanoseconds), this can be killed.
 	*/
-	remainder = tk->xtime_nsec & ((1 << tk->shift) - 1);
+	remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
 	tk->xtime_nsec -= remainder;
-	tk->xtime_nsec += 1 << tk->shift;
+	tk->xtime_nsec += 1ULL << tk->shift;
 	tk->ntp_error += remainder << tk->ntp_error_shift;
 
 	/*
