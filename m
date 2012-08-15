Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2HOOE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:04:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2HOOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:04:25 -0400
Date: Wed, 15 Aug 2012 07:04:02 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, caiqian@redhat.com, john.stultz@linaro.org,
        levinsasha928@gmail.com, zliu@redhat.com, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, caiqian@redhat.com, john.stultz@linaro.org,
        levinsasha928@gmail.com, zliu@redhat.com, tglx@linutronix.de,
        prarit@redhat.com
In-Reply-To: <1344454580-17031-1-git-send-email-john.stultz@linaro.org>
References: <1344454580-17031-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Improve sanity checking of timekeeping inputs
Git-Commit-ID: 4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 15 Aug 2012 07:04:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b
Gitweb:     http://git.kernel.org/tip/4e8b14526ca7fb046a81c94002c1c43b6fdf0e9b
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Wed, 8 Aug 2012 15:36:20 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 15 Aug 2012 15:54:01 +0200

time: Improve sanity checking of timekeeping inputs

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
 
