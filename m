Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790Ab2HHTgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:36:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51933 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030750Ab2HHTgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:36:44 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] time: Improve sanity checking of timekeeping inputs
Date: Wed,  8 Aug 2012 15:36:20 -0400
Message-Id: <1344454580-17031-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080819-1976-0000-0000-00000FFD1300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, Ingo,
	Here's a fix against tip/timers/urgent that addresses
timekeeping edge cases detected by both a bad BIOS and system
fuzzing w/ trinity. Thanks to Sasha Levin and CAI Qian for
finding and reporting these!

Let me know if you have any tweaks you want to see.

thanks
-john

Unexpected behavior could occur if the time is set to
a value large enough to overflow a 64bit ktime_t
(which is something larger then the year 2262).

Also unexpected behavior could occur if large negative
offsets are injected via adjtimex.

So this patch improves the sanity check timekeeping inputs
by improving the timespec_valid() check, and then makes better
use of timespec_valid() to make sure we don't set the time to
an invalid negative value or one that overflows ktime_t.

Note: This does not protect from setting the time close to
overflowing ktime_t and then letting natural accumulation
cause the overflow.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: stable@vger.kernel.org
Reported-by: CAI Qian <caiqian@redhat.com>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/ktime.h     |    7 -------
 include/linux/time.h      |   22 ++++++++++++++++++++--
 kernel/time/timekeeping.c |   26 ++++++++++++++++++++++++--
 3 files changed, 44 insertions(+), 11 deletions(-)

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
index e16af19..898bef0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -427,7 +427,7 @@ int do_settimeofday(const struct timespec *tv)
 	struct timespec ts_delta, xt;
 	unsigned long flags;
 
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
+	if (!timespec_valid(tv))
 		return -EINVAL;
 
 	write_seqlock_irqsave(&tk->lock, flags);
@@ -463,6 +463,8 @@ int timekeeping_inject_offset(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
+	struct timespec tmp;
+	int ret = 0;
 
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
@@ -471,10 +473,17 @@ int timekeeping_inject_offset(struct timespec *ts)
 
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
@@ -482,7 +491,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	/* signal hrtimers about time change */
 	clock_was_set();
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(timekeeping_inject_offset);
 
@@ -649,7 +658,20 @@ void __init timekeeping_init(void)
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
 
-- 
1.7.9.5

