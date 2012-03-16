Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161915Ab2CPA7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:59:55 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46489 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032512Ab2CPA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:59:52 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] [RFC] ntp: Fix leap-second hrtimer livelock
Date: Thu, 15 Mar 2012 17:59:45 -0700
Message-Id: <1331859585-27765-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031600-3270-0000-0000-000004D3E95C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7dffa3c673fbcf835cd7be80bb4aec8ad3f51168 the ntp
subsystem has used an hrtimer for triggering the leapsecond
adjustment. However, this can cause a potential livelock.

Thomas diagnosed this as the following pattern:
CPU 0                                                    CPU 1
do_adjtimex()
  spin_lock_irq(&ntp_lock);
    process_adjtimex_modes();				 timer_interrupt()
      process_adj_status();                                do_timer()
        ntp_start_leap_timer();                             write_lock(&xtime_lock);
          hrtimer_start();                                  update_wall_time();
             hrtimer_reprogram();                            ntp_tick_length()
               tick_program_event()                            spin_lock(&ntp_lock);
                 clockevents_program_event()
		   ktime_get()
                     seq = req_seqbegin(xtime_lock);

This patch tries to avoid the problem by reverting back to not using
an hrtimer to inject leapseconds, and instead we handle the leapsecond
processing in the second_overflow() function.

The downside to this change is that on systems that support highres
timers, the leap second processing will occur on a HZ tick boundary,
(ie: ~1-10ms, depending on HZ)  after the leap second instead of
possibly sooner (~34us in my tests w/ x86_64 lapic).

This patch applies on top of tip/timers/core.

CC: Sasha Levin <levinsasha928@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Diagnoised-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timex.h     |    2 +-
 kernel/time/ntp.c         |  128 ++++++++++++++------------------------------
 kernel/time/timekeeping.c |   20 ++-----
 3 files changed, 48 insertions(+), 102 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index b75e186..99bc88b 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -252,7 +252,7 @@ extern void ntp_clear(void);
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
 extern u64 ntp_tick_length(void);
 
-extern void second_overflow(void);
+extern int second_overflow(unsigned long secs);
 extern int do_adjtimex(struct timex *);
 extern void hardpps(const struct timespec *, const struct timespec *);
 
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 17fb1b9..a9331cf 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -34,8 +34,6 @@ unsigned long			tick_nsec;
 static u64			tick_length;
 static u64			tick_length_base;
 
-static struct hrtimer		leap_timer;
-
 #define MAX_TICKADJ		500LL		/* usecs */
 #define MAX_TICKADJ_SCALED \
 	(((MAX_TICKADJ * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
@@ -381,70 +379,63 @@ u64 ntp_tick_length(void)
 
 
 /*
- * Leap second processing. If in leap-insert state at the end of the
- * day, the system clock is set back one second; if in leap-delete
- * state, the system clock is set ahead one second.
+ * this routine handles the overflow of the microsecond field
+ *
+ * The tricky bits of code to handle the accurate clock support
+ * were provided by Dave Mills (Mills@UDEL.EDU) of NTP fame.
+ * They were originally developed for SUN and DEC kernels.
+ * All the kudos should go to Dave for this stuff.
+ *
+ * Also handles leap second processing, and returns leap offset
  */
-static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
+int second_overflow(unsigned long secs)
 {
-	enum hrtimer_restart res = HRTIMER_NORESTART;
-	unsigned long flags;
+	s64 delta;
 	int leap = 0;
+	unsigned long flags;
 
 	spin_lock_irqsave(&ntp_lock, flags);
+
+	/*
+	 * Leap second processing. If in leap-insert state at the end of the
+	 * day, the system clock is set back one second; if in leap-delete
+	 * state, the system clock is set ahead one second.
+	 */
 	switch (time_state) {
 	case TIME_OK:
+		if (time_status & STA_INS)
+			time_state = TIME_INS;
+		else if (time_status & STA_DEL)
+			time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		leap = -1;
-		time_state = TIME_OOP;
-		printk(KERN_NOTICE
-			"Clock: inserting leap second 23:59:60 UTC\n");
-		hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
-		res = HRTIMER_RESTART;
+		if (secs % 86400 == 0) {
+			leap = -1;
+			time_state = TIME_OOP;
+			printk(KERN_NOTICE
+				"Clock: inserting leap second 23:59:60 UTC\n");
+		}
 		break;
 	case TIME_DEL:
-		leap = 1;
-		time_tai--;
-		time_state = TIME_WAIT;
-		printk(KERN_NOTICE
-			"Clock: deleting leap second 23:59:59 UTC\n");
+		if ((secs + 1) % 86400 == 0) {
+			leap = 1;
+			time_tai--;
+			time_state = TIME_WAIT;
+			printk(KERN_NOTICE
+				"Clock: deleting leap second 23:59:59 UTC\n");
+		}
 		break;
 	case TIME_OOP:
 		time_tai++;
 		time_state = TIME_WAIT;
-		/* fall through */
+		break;
+
 	case TIME_WAIT:
 		if (!(time_status & (STA_INS | STA_DEL)))
 			time_state = TIME_OK;
 		break;
 	}
-	spin_unlock_irqrestore(&ntp_lock, flags);
-
-	/*
-	 * We have to call this outside of the ntp_lock to keep
-	 * the proper locking hierarchy
-	 */
-	if (leap)
-		timekeeping_leap_insert(leap);
-
-	return res;
-}
-
-/*
- * this routine handles the overflow of the microsecond field
- *
- * The tricky bits of code to handle the accurate clock support
- * were provided by Dave Mills (Mills@UDEL.EDU) of NTP fame.
- * They were originally developed for SUN and DEC kernels.
- * All the kudos should go to Dave for this stuff.
- */
-void second_overflow(void)
-{
-	s64 delta;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ntp_lock, flags);
 
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
@@ -481,8 +472,13 @@ void second_overflow(void)
 	tick_length += (s64)(time_adjust * NSEC_PER_USEC / NTP_INTERVAL_FREQ)
 							 << NTP_SCALE_SHIFT;
 	time_adjust = 0;
+
+
+
 out:
 	spin_unlock_irqrestore(&ntp_lock, flags);
+
+	return leap;
 }
 
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
@@ -544,27 +540,6 @@ static void notify_cmos_timer(void)
 static inline void notify_cmos_timer(void) { }
 #endif
 
-/*
- * Start the leap seconds timer:
- */
-static inline void ntp_start_leap_timer(struct timespec *ts)
-{
-	long now = ts->tv_sec;
-
-	if (time_status & STA_INS) {
-		time_state = TIME_INS;
-		now += 86400 - now % 86400;
-		hrtimer_start(&leap_timer, ktime_set(now, 0), HRTIMER_MODE_ABS);
-
-		return;
-	}
-
-	if (time_status & STA_DEL) {
-		time_state = TIME_DEL;
-		now += 86400 - (now + 1) % 86400;
-		hrtimer_start(&leap_timer, ktime_set(now, 0), HRTIMER_MODE_ABS);
-	}
-}
 
 /*
  * Propagate a new txc->status value into the NTP state:
@@ -589,22 +564,6 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	time_status &= STA_RONLY;
 	time_status |= txc->status & ~STA_RONLY;
 
-	switch (time_state) {
-	case TIME_OK:
-		ntp_start_leap_timer(ts);
-		break;
-	case TIME_INS:
-	case TIME_DEL:
-		time_state = TIME_OK;
-		ntp_start_leap_timer(ts);
-	case TIME_WAIT:
-		if (!(time_status & (STA_INS | STA_DEL)))
-			time_state = TIME_OK;
-		break;
-	case TIME_OOP:
-		hrtimer_restart(&leap_timer);
-		break;
-	}
 }
 /*
  * Called with the xtime lock held, so we can access and modify
@@ -686,9 +645,6 @@ int do_adjtimex(struct timex *txc)
 		    (txc->tick <  900000/USER_HZ ||
 		     txc->tick > 1100000/USER_HZ))
 			return -EINVAL;
-
-		if (txc->modes & ADJ_STATUS && time_state != TIME_OK)
-			hrtimer_cancel(&leap_timer);
 	}
 
 	if (txc->modes & ADJ_SETOFFSET) {
@@ -1010,6 +966,4 @@ __setup("ntp_tick_adj=", ntp_tick_adj_setup);
 void __init ntp_init(void)
 {
 	ntp_clear();
-	hrtimer_init(&leap_timer, CLOCK_REALTIME, HRTIMER_MODE_ABS);
-	leap_timer.function = ntp_leap_second;
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 403c2a0..dad9b95 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -184,18 +184,6 @@ static void timekeeping_update(bool clearntp)
 }
 
 
-void timekeeping_leap_insert(int leapsecond)
-{
-	unsigned long flags;
-
-	write_seqlock_irqsave(&timekeeper.lock, flags);
-	timekeeper.xtime.tv_sec += leapsecond;
-	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
-	timekeeping_update(false);
-	write_sequnlock_irqrestore(&timekeeper.lock, flags);
-
-}
-
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -962,9 +950,11 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	timekeeper.xtime_nsec += timekeeper.xtime_interval << shift;
 	while (timekeeper.xtime_nsec >= nsecps) {
+		int leap;
 		timekeeper.xtime_nsec -= nsecps;
 		timekeeper.xtime.tv_sec++;
-		second_overflow();
+		leap = second_overflow(timekeeper.xtime.tv_sec);
+		timekeeper.xtime.tv_sec += leap;
 	}
 
 	/* Accumulate raw time */
@@ -1075,9 +1065,11 @@ static void update_wall_time(void)
 	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
 	 */
 	if (unlikely(timekeeper.xtime.tv_nsec >= NSEC_PER_SEC)) {
+		int leap;
 		timekeeper.xtime.tv_nsec -= NSEC_PER_SEC;
 		timekeeper.xtime.tv_sec++;
-		second_overflow();
+		leap = second_overflow(timekeeper.xtime.tv_sec);
+		timekeeper.xtime.tv_sec += leap;
 	}
 
 	timekeeping_update(false);
-- 
1.7.3.2.146.gca209

