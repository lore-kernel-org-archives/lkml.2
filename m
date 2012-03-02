Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292Ab2CBHOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:14:42 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57156 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070Ab2CBHNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:13 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 5/9] time: Shadow cycle_last in timekeeper structure
Date: Thu,  1 Mar 2012 23:12:44 -0800
Message-Id: <1330672368-32290-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-7182-0000-0000-000000F25FFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocksource cycle_last value is problematic for working on
shadow copies of the timekeeper, because the clocksource is global.

Since its mostly used only for timekeeping, move cycle_last into
the timekeeper. Unfortunately there are some uses for cycle_last
outside of timekeeping (such as tsc_read, which makes sure we haven't
skipped to a core that the TSC is behind the last read), so we
keep the clocksource cycle_last updated as well.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 09460c1..ed8cb51 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -29,7 +29,8 @@ struct timekeeper {
 	u32	mult;
 	/* The shift value of the current clocksource. */
 	int	shift;
-
+	/* cycle value at last accumulation point */
+	cycle_t cycle_last;
 	/* Number of clock cycles in one NTP interval. */
 	cycle_t cycle_interval;
 	/* Number of clock shifted nano seconds in one NTP interval. */
@@ -142,7 +143,8 @@ static void tk_setup_internals(struct timekeeper *tk, struct clocksource *clock)
 
 	old_clock = tk->clock;
 	tk->clock = clock;
-	clock->cycle_last = clock->read(clock);
+	tk->cycle_last = clock->read(clock);
+	clock->cycle_last = tk->cycle_last;
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -195,7 +197,7 @@ static inline s64 timekeeping_get_ns(struct timekeeper *tk)
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	cycle_delta = (cycle_now - tk->cycle_last) & clock->mask;
 
 	nsec = cycle_delta * tk->mult + tk->xtime_nsec;
 	return nsec >> tk->shift;
@@ -211,7 +213,7 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	cycle_delta = (cycle_now - tk->cycle_last) & clock->mask;
 
 	/* return delta convert to nanoseconds. */
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
@@ -259,8 +261,9 @@ static void timekeeping_forward_now(struct timekeeper *tk)
 
 	clock = tk->clock;
 	cycle_now = clock->read(clock);
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	clock->cycle_last = cycle_now;
+	cycle_delta = (cycle_now - tk->cycle_last) & clock->mask;
+	tk->cycle_last = cycle_now;
+	tk->clock->cycle_last = cycle_now;
 
 	tk->xtime_nsec += cycle_delta * tk->mult;
 
@@ -760,7 +763,8 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(&ts);
 	}
 	/* re-base the last cycle value */
-	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
+	timekeeper.cycle_last = timekeeper.clock->read(timekeeper.clock);
+	timekeeper.clock->cycle_last = timekeeper.cycle_last;
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
 
@@ -1026,7 +1030,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 
 	/* Accumulate one shifted interval */
 	offset -= tk->cycle_interval << shift;
-	tk->clock->cycle_last += tk->cycle_interval << shift;
+	tk->cycle_last += tk->cycle_interval << shift;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
 	while (tk->xtime_nsec >= nsecps) {
@@ -1079,7 +1083,7 @@ static void update_wall_time(void)
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = shadow_tk.cycle_interval;
 #else
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - shadow_tk.cycle_last) & clock->mask;
 #endif
 
 	/*
@@ -1153,6 +1157,7 @@ static void update_wall_time(void)
 
 
 	timekeeper = shadow_tk;
+	timekeeper.clock->cycle_last = timekeeper.cycle_last;
 	timekeeping_update(&timekeeper, false);
 
 out:
-- 
1.7.3.2.146.gca209

