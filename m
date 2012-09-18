Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab2IRBjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:39:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40938 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab2IRBi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:38:57 -0400
From: John Stultz <john.stultz@linaro.org>
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, Zhouping Liu <zliu@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] 2.6.34.y: time: Improve sanity checking of timekeeping inputs
Date: Mon, 17 Sep 2012 21:38:45 -0400
Message-Id: <1347932327-33192-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347932327-33192-1-git-send-email-john.stultz@linaro.org>
References: <1347932327-33192-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091801-9360-0000-0000-00000AC2EC68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a -stable backport of 4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b

Unexpected behavior could occur if the time is set to a value large
enough to overflow a 64bit ktime_t (which is something larger then the
year 2262).

Also unexpected behavior could occur if large negative offsets are
injected via adjtimex.

So this patch improves the sanity check timekeeping inputs by
improving the timespec_valid() check, and then makes better use of
timespec_valid() to make sure we don't set the time to an invalid
negative value or one that overflows ktime_t.

Note: This does not protect from setting the time close to overflowing
ktime_t and then letting natural accumulation cause the overflow.

Reported-by: CAI Qian <caiqian@redhat.com>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1344454580-17031-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/ktime.h     |    7 -------
 include/linux/time.h      |   22 ++++++++++++++++++++--
 kernel/time/timekeeping.c |   15 ++++++++++++++-
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index ce59832..ecdf64e 100644
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
index 6e026e4..146b6f3 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -91,11 +91,29 @@ static inline struct timespec timespec_sub(struct timespec lhs,
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
 
 extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 156fd67..0d59077 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -343,7 +343,7 @@ int do_settimeofday(struct timespec *tv)
 	struct timespec ts_delta;
 	unsigned long flags;
 
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
+	if (!timespec_valid(tv))
 		return -EINVAL;
 
 	write_seqlock_irqsave(&xtime_lock, flags);
@@ -559,7 +559,20 @@ void __init timekeeping_init(void)
 	struct timespec now, boot;
 
 	read_persistent_clock(&now);
+	if (!timespec_valid(&now)) {
+		printk("WARNING: Persistent clock returned invalid value!\n"
+			"         Check your CMOS/BIOS settings.\n");
+		now.tv_sec = 0;
+		now.tv_nsec = 0;
+	}
+
 	read_boot_clock(&boot);
+	if (!timespec_valid(&boot)) {
+		printk("WARNING: Boot clock returned invalid value!\n"
+			"         Check your CMOS/BIOS settings.\n");
+		boot.tv_sec = 0;
+		boot.tv_nsec = 0;
+	}
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
-- 
1.7.9.5

