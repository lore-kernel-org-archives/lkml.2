Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2GMFX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:23:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51494 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab2GMFW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:22:29 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 6/8] time: Move arch_gettimeoffset() usage into timekeeping_get_ns()
Date: Fri, 13 Jul 2012 01:21:55 -0400
Message-Id: <1342156917-25092-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071305-7282-0000-0000-00000AE1D577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we call arch_gettimeoffset() in all the accessor
functions, move arch_gettimeoffset() calls into
timekeeping_get_ns() and timekeeping_get_ns_raw() to simplify
the code.

This also makes the code easier to maintain as we don't have to
worry about forgetting the arch_gettimeoffset() as has happened
in the past.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5ffb2b6..dd119355 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -195,13 +195,18 @@ static inline s64 timekeeping_get_ns(void)
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 	nsec = cycle_delta * timekeeper.mult + timekeeper.xtime_nsec;
-	return nsec >> timekeeper.shift;
+	nsec >>= timekeeper.shift;
+
+	/* If arch requires, add in gettimeoffset() */
+	nsec += arch_gettimeoffset();
+	return nsec;
 }
 
 static inline s64 timekeeping_get_ns_raw(void)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
+	s64 nsec;
 
 	/* read clocksource: */
 	clock = timekeeper.clock;
@@ -210,8 +215,13 @@ static inline s64 timekeeping_get_ns_raw(void)
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	/* return delta convert to nanoseconds. */
-	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+	/* convert delta to nanoseconds. */
+	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+
+	/* If arch requires, add in gettimeoffset() */
+	nsec += arch_gettimeoffset();
+	return nsec;
+
 }
 
 static void update_rt_offset(void)
@@ -286,9 +296,6 @@ void getnstimeofday(struct timespec *ts)
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns();
 
-		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
-
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts, nsecs);
@@ -308,8 +315,6 @@ ktime_t ktime_get(void)
 				timekeeper.wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns() +
 				timekeeper.wall_to_monotonic.tv_nsec;
-		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&timekeeper.lock, seq));
 	/*
@@ -340,8 +345,6 @@ void ktime_get_ts(struct timespec *ts)
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns();
 		tomono = timekeeper.wall_to_monotonic;
-		/* If arch requires, add in gettimeoffset() */
-		ts->tv_nsec += arch_gettimeoffset();
 
 	} while (read_seqretry(&timekeeper.lock, seq));
 
@@ -369,8 +372,6 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		u32 arch_offset;
-
 		seq = read_seqbegin(&timekeeper.lock);
 
 		*ts_raw = timekeeper.raw_time;
@@ -380,11 +381,6 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw = timekeeping_get_ns_raw();
 		nsecs_real = timekeeping_get_ns();
 
-		/* If arch requires, add in gettimeoffset() */
-		arch_offset = arch_gettimeoffset();
-		nsecs_raw += arch_offset;
-		nsecs_real += arch_offset;
-
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
@@ -1342,8 +1338,6 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
 
 		secs = timekeeper.xtime_sec;
 		nsecs = timekeeping_get_ns();
-		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
 
 		*offs_real = timekeeper.offs_real;
 		*offs_boot = timekeeper.offs_boot;
-- 
1.7.9.5

