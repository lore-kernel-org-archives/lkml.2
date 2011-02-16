Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab1BPEUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:20:32 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33464 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab1BPEUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:20:15 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=C3=83=C2=B8nnev=C3=83=C2=A5g?= 
	<arve@android.com>
Subject: [PATCH 2/5] time: Introduce get_monotonic_boottime and ktime_get_boottime
Date: Tue, 15 Feb 2011 20:20:04 -0800
Message-Id: <1297830007-426-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
References: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds new functions that return the monotonic time since boot
(in other words, CLOCK_MONOTONIC + suspend time).

CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve HjÃ¸nnevÃ¥g <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/hrtimer.h   |    1 +
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 20b8e66..7a9e7ee 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -312,6 +312,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
+extern ktime_t ktime_get_boottime(void);
 
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
diff --git a/include/linux/time.h b/include/linux/time.h
index 379b903..fa39150 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -161,6 +161,7 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
 		struct timespec *ts_real);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
+extern void get_monotonic_boottime(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6262c1d..5fbd9aa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -907,7 +907,7 @@ static void update_wall_time(void)
  * getboottime - Return the real time of system boot.
  * @ts:		pointer to the timespec to be set
  *
- * Returns the time of day in a timespec.
+ * Returns the wall-time of boot in a timespec.
  *
  * This is based on the wall_to_monotonic offset and the total suspend
  * time. Calls to settimeofday will affect the value returned (which
@@ -925,6 +925,55 @@ void getboottime(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(getboottime);
 
+
+/**
+ * get_monotonic_boottime - Returns monotonic time since boot
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the monotonic time since boot in a timespec.
+ *
+ * This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
+ * includes the time spent in suspend.
+ */
+void get_monotonic_boottime(struct timespec *ts)
+{
+	struct timespec tomono, sleep;
+	unsigned int seq;
+	s64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		*ts = xtime;
+		tomono = wall_to_monotonic;
+		sleep = total_sleep_time;
+		nsecs = timekeeping_get_ns();
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
+			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec + nsecs);
+}
+EXPORT_SYMBOL_GPL(get_monotonic_boottime);
+
+/**
+ * ktime_get_boottime - Returns monotonic time since boot in a ktime
+ *
+ * Returns the monotonic time since boot in a ktime
+ *
+ * This is similar to CLOCK_MONTONIC/ktime_get, but also
+ * includes the time spent in suspend.
+ */
+ktime_t ktime_get_boottime(void)
+{
+	struct timespec ts;
+
+	get_monotonic_boottime(&ts);
+	return timespec_to_ktime(ts);
+}
+EXPORT_SYMBOL_GPL(ktime_get_boottime);
+
 /**
  * monotonic_to_bootbased - Convert the monotonic time to boot based.
  * @ts:		pointer to the timespec to be converted
-- 
1.7.3.2.146.gca209

