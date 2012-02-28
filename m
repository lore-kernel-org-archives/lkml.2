Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771Ab2B1Aaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:30:52 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53340 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2B1A3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:29:49 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 5/7] time: Shadow cycle_last in timekeeper structure
Date: Mon, 27 Feb 2012 16:29:32 -0800
Message-Id: <1330388974-27793-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022800-3352-0000-0000-000002F03F30
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

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6c36d19..ebfb037 100644
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
@@ -138,7 +139,8 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 	u64 tmp, ntpinterval;
 
 	timekeeper.clock = clock;
-	clock->cycle_last = clock->read(clock);
+	timekeeper.cycle_last = clock->read(clock);
+	clock->cycle_last = timekeeper.cycle_last;
 
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
@@ -184,7 +186,7 @@ static inline s64 timekeeping_get_ns(void)
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
 
 	nsec = cycle_delta * timekeeper.mult + timekeeper.xtime_nsec;
 	return nsec >> timekeeper.shift;
@@ -200,7 +202,7 @@ static inline s64 timekeeping_get_ns_raw(void)
 	cycle_now = clock->read(clock);
 
 	/* calculate the delta since the last update_wall_time: */
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
+	cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
 
 	/* return delta convert to nanoseconds. */
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
@@ -248,8 +250,9 @@ static void timekeeping_forward_now(void)
 
 	clock = timekeeper.clock;
 	cycle_now = clock->read(clock);
-	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
-	clock->cycle_last = cycle_now;
+	cycle_delta = (cycle_now - timekeeper.cycle_last) & clock->mask;
+	timekeeper.cycle_last = cycle_now;
+	timekeeper.clock->cycle_last = cycle_now;
 
 	timekeeper.xtime_nsec += cycle_delta * timekeeper.mult;
 
@@ -749,7 +752,8 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(&ts);
 	}
 	/* re-base the last cycle value */
-	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
+	timekeeper.cycle_last = timekeeper.clock->read(timekeeper.clock);
+	timekeeper.clock->cycle_last = timekeeper.cycle_last;
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
 
@@ -1016,7 +1020,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 
 	/* Accumulate one shifted interval */
 	offset -= tk->cycle_interval << shift;
-	tk->clock->cycle_last += tk->cycle_interval << shift;
+	tk->cycle_last += tk->cycle_interval << shift;
 
 	tk->xtime_nsec += tk->xtime_interval << shift;
 	while (tk->xtime_nsec >= nsecps) {
@@ -1070,7 +1074,7 @@ static void update_wall_time(void)
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = tk.cycle_interval;
 #else
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
+	offset = (clock->read(clock) - tk.cycle_last) & clock->mask;
 #endif
 
 	/*
@@ -1143,6 +1147,7 @@ static void update_wall_time(void)
 
 
 	timekeeper = tk;
+	timekeeper.clock->cycle_last = timekeeper.cycle_last;
 	timekeeping_update(&timekeeper, false);
 
 out:
-- 
1.7.3.2.146.gca209

