Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab1BADoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:44:11 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51814 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab1BADoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:44:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/2] hrtimers: Add CLOCK_BOOTTIME clockid, hrtimerbase and posix interface
Date: Mon, 31 Jan 2011 19:43:56 -0800
Message-Id: <1296531837-12879-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1296531837-12879-1-git-send-email-john.stultz@linaro.org>
References: <1296531837-12879-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLOCK_MONOTONIC stops while the system is in suspend. This is because
to applications system suspend is invisible. However, there is a
growing set of applications that are wanting to be suspend-aware,
but do not want to deal with the complicatoins of CLOCK_REALTIME
(which might jump around if settimeofday is called).

For these applications, I propose a new clockid: CLOCK_BOOTTIME.
CLOCK_BOOTTIME is idential to CLOCK_MONOTONIC, except it also
includes any time spent in suspend.

This patch adds the new CLOCK_BOOTTIME clockid, as well as the
infrastructure needed to support hrtimers against it, and the
wiring to expose it out via the posix interface.

CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/hrtimer.h   |    2 +
 include/linux/time.h      |    4 ++
 kernel/hrtimer.c          |   16 ++++++++-
 kernel/posix-timers.c     |   16 ++++++++-
 kernel/time/timekeeping.c |   79 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 113 insertions(+), 4 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 20b8e66..6bc1804 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -151,6 +151,7 @@ struct hrtimer_clock_base {
 enum  hrtimer_base_type {
 	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_MONOTONIC,
+	HRTIMER_BASE_BOOTTIME,
 	HRTIMER_MAX_CLOCK_BASES,
 };
 
@@ -312,6 +313,7 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
+extern ktime_t ktime_get_boottime(void);
 
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
diff --git a/include/linux/time.h b/include/linux/time.h
index 1e6d3b5..9c520f4 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -126,6 +126,8 @@ unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec __get_wall_to_monotonic(void); /* does not take xtime_lock */
+extern struct timespec __get_sleep_time(void); /* does not take xtime_lock */
+
 struct timespec get_monotonic_coarse(void);
 
 #define CURRENT_TIME		(current_kernel_time())
@@ -162,6 +164,7 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
 		struct timespec *ts_real);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
+extern void get_monotonic_boottime(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
@@ -292,6 +295,7 @@ struct itimerval {
 #define CLOCK_MONOTONIC_RAW		4
 #define CLOCK_REALTIME_COARSE		5
 #define CLOCK_MONOTONIC_COARSE		6
+#define CLOCK_BOOTTIME			7
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ce6dd95..628c734 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -73,6 +73,11 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 			.get_time = &ktime_get,
 			.resolution = KTIME_LOW_RES,
 		},
+		{
+			.index = CLOCK_BOOTTIME,
+			.get_time = &ktime_get_boottime,
+			.resolution = KTIME_LOW_RES,
+		},
 	}
 };
 
@@ -100,21 +105,26 @@ static inline int hrtimer_clockid_to_base(clockid_t clock_id)
  */
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
-	ktime_t xtim, tomono;
-	struct timespec xts, tom;
+	ktime_t xtim, tomono, sleep;
+	struct timespec xts, tom, slp;
 	unsigned long seq;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
 		xts = __current_kernel_time();
 		tom = __get_wall_to_monotonic();
+		slp = __get_sleep_time();
 	} while (read_seqretry(&xtime_lock, seq));
 
 	xtim = timespec_to_ktime(xts);
 	tomono = timespec_to_ktime(tom);
+	sleep = timespec_to_ktime(slp);
 	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
 	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time =
 		ktime_add(xtim, tomono);
+	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time =
+		ktime_add(base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time,
+				sleep);
 }
 
 /*
@@ -745,6 +755,7 @@ static int hrtimer_switch_to_hres(void)
 	base->hres_active = 1;
 	base->clock_base[HRTIMER_BASE_REALTIME].resolution = KTIME_HIGH_RES;
 	base->clock_base[HRTIMER_BASE_MONOTONIC].resolution = KTIME_HIGH_RES;
+	base->clock_base[HRTIMER_BASE_BOOTTIME].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
 
@@ -1742,6 +1753,7 @@ void __init hrtimers_init(void)
 		hrtimer_clock_to_base_table[i] = -1;
 	hrtimer_clock_to_base_table[CLOCK_REALTIME] = HRTIMER_BASE_REALTIME;
 	hrtimer_clock_to_base_table[CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC;
+	hrtimer_clock_to_base_table[CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME;
 
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 93bd2eb..389d5d5 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -240,7 +240,7 @@ static int posix_ktime_get_ts(clockid_t which_clock, struct timespec *tp)
 }
 
 /*
- * Get monotonic time for posix timers
+ * Get monotonic-raw time for posix timers
  */
 static int posix_get_monotonic_raw(clockid_t which_clock, struct timespec *tp)
 {
@@ -267,6 +267,14 @@ static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
 }
+
+static int posix_get_boottime(const clockid_t which_clock, struct timespec *tp)
+{
+	get_monotonic_boottime(tp);
+	return 0;
+}
+
+
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
  */
@@ -301,12 +309,18 @@ static __init int init_posix_timers(void)
 		.timer_create = no_timer_create,
 		.nsleep = no_nsleep,
 	};
+	struct k_clock clock_boottime = {
+		.clock_getres = hrtimer_get_res,
+		.clock_get = posix_get_boottime,
+		.clock_set = do_posix_clock_nosettime,
+	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
 	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
 	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
 	register_posix_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
 	register_posix_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	register_posix_clock(CLOCK_BOOTTIME, &clock_boottime);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d27c756..d063aed 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -871,7 +871,7 @@ void update_wall_time(void)
  * getboottime - Return the real time of system boot.
  * @ts:		pointer to the timespec to be set
  *
- * Returns the time of day in a timespec.
+ * Returns the wall-time of boot in a timespec.
  *
  * This is based on the wall_to_monotonic offset and the total suspend
  * time. Calls to settimeofday will affect the value returned (which
@@ -889,6 +889,83 @@ void getboottime(struct timespec *ts)
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
+	unsigned int seq;
+	s64 secs, nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		secs = xtime.tv_sec;
+		secs += wall_to_monotonic.tv_sec;
+		secs += total_sleep_time.tv_sec;
+		nsecs = xtime.tv_nsec;
+		nsecs += wall_to_monotonic.tv_nsec;
+		nsecs += total_sleep_time.tv_nsec;
+		nsecs += timekeeping_get_ns();
+
+	} while (read_seqretry(&xtime_lock, seq));
+	/*
+	 * Use ktime_set/ktime_add_ns to create a proper ktime on
+	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
+	 */
+	return ktime_add_ns(ktime_set(secs, 0), nsecs);
+}
+EXPORT_SYMBOL_GPL(ktime_get_boottime);
+
+/**
+ * __get_sleep_time - returns total_sleep_time
+ *
+ * Returns total time spent in suspend.
+ * Requires the xtime lock be held
+ */
+struct timespec __get_sleep_time(void)
+{
+	return total_sleep_time;
+}
+
 /**
  * monotonic_to_bootbased - Convert the monotonic time to boot based.
  * @ts:		pointer to the timespec to be converted
-- 
1.7.3.2.146.gca209

