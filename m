Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946112Ab2EROK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:10:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54267 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946073Ab2EROKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:22 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V2 6/6] time: Add CLOCK_TAI clockid
Date: Fri, 18 May 2012 16:09:58 +0200
Message-Id: <d4ecc549b8a60253528b7b831ac7463b1d2b5d3d.1337348892.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
In-Reply-To: <cover.1337348892.git.richardcochran@gmail.com>
References: <cover.1337348892.git.richardcochran@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

This adds a CLOCK_TAI clockid and the needed accessors.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/time.h      |    7 +++----
 kernel/posix-timers.c     |   10 ++++++++++
 kernel/time/timekeeping.c |   31 +++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index b6034b0..9be8205 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -169,6 +169,7 @@ extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
 extern int timekeeping_inject_offset(struct timespec *ts);
 extern void timekeeping_set_tai_offset(time_t tai_offset);
+extern void timekeeping_clocktai(struct timespec *ts);
 
 struct tms;
 extern void do_sys_times(struct tms *);
@@ -297,11 +298,9 @@ struct itimerval {
 #define CLOCK_BOOTTIME			7
 #define CLOCK_REALTIME_ALARM		8
 #define CLOCK_BOOTTIME_ALARM		9
+#define CLOCK_SGI_CYCLE			10	/* Hardware specific */
+#define CLOCK_TAI			11
 
-/*
- * The IDs of various hardware clocks:
- */
-#define CLOCK_SGI_CYCLE			10
 #define MAX_CLOCKS			16
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
 #define CLOCKS_MONO			CLOCK_MONOTONIC
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..d6d146c 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -221,6 +221,11 @@ static int posix_get_boottime(const clockid_t which_clock, struct timespec *tp)
 	return 0;
 }
 
+static int posix_get_tai(clockid_t which_clock, struct timespec *tp)
+{
+	timekeeping_clocktai(tp);
+	return 0;
+}
 
 /*
  * Initialize everything, well, just everything in Posix clocks/timers ;)
@@ -261,6 +266,10 @@ static __init int init_posix_timers(void)
 		.clock_getres	= posix_get_coarse_res,
 		.clock_get	= posix_get_monotonic_coarse,
 	};
+	struct k_clock clock_tai = {
+		.clock_getres	= hrtimer_get_res,
+		.clock_get	= posix_get_tai,
+	};
 	struct k_clock clock_boottime = {
 		.clock_getres	= hrtimer_get_res,
 		.clock_get	= posix_get_boottime,
@@ -278,6 +287,7 @@ static __init int init_posix_timers(void)
 	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
 	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
 	posix_timers_register_clock(CLOCK_BOOTTIME, &clock_boottime);
+	posix_timers_register_clock(CLOCK_TAI, &clock_tai);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fdd1a48..6696f60 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -315,6 +315,37 @@ void ktime_get_ts(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
+
+/**
+ * timekeeping_clocktai - Returns the TAI time of day in a timespec
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the time of day in a timespec.
+ */
+void timekeeping_clocktai(struct timespec *ts)
+{
+	unsigned long seq;
+	s64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+
+		*ts = timekeeper.xtime;
+		nsecs = timekeeping_get_ns();
+
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
+		ts->tv_sec += timekeeper.tai_offset;
+
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+	timespec_add_ns(ts, nsecs);
+}
+EXPORT_SYMBOL(timekeeping_clocktai);
+
+
 #ifdef CONFIG_NTP_PPS
 
 /**
-- 
1.7.2.5

