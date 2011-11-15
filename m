Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1KOEG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:06:29 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52445 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab1KOEEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:24 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 12/16] time: Move common updates to a function
Date: Mon, 14 Nov 2011 20:04:02 -0800
Message-Id: <1321329846-14755-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-5518-0000-0000-00000068B871
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   39 +++++++++++++++++----------------------
 1 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b632678..9416be0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -172,17 +172,26 @@ static inline s64 timekeeping_get_ns_raw(void)
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
+/* must hold write on timekeeper.lock */
+static void timekeeping_update(bool clearntp)
+{
+	if (clearntp) {
+		timekeeper.ntp_error = 0;
+		ntp_clear();
+	}
+	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
+			 timekeeper.clock, timekeeper.mult);
+}
+
+
 void timekeeping_leap_insert(int leapsecond)
 {
 	unsigned long flags;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
-
 	timekeeper.xtime.tv_sec += leapsecond;
 	timekeeper.wall_to_monotonic.tv_sec -= leapsecond;
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
-			 timekeeper.clock, timekeeper.mult);
-
+	timekeeping_update(false);
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 }
@@ -382,12 +391,7 @@ int do_settimeofday(const struct timespec *tv)
 			timespec_sub(timekeeper.wall_to_monotonic, ts_delta);
 
 	timekeeper.xtime = *tv;
-
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
-			timekeeper.clock, timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -421,11 +425,7 @@ int timekeeping_inject_offset(struct timespec *ts)
 	timekeeper.wall_to_monotonic =
 				timespec_sub(timekeeper.wall_to_monotonic, *ts);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
-			timekeeper.clock, timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -664,10 +664,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 
 	__timekeeping_inject_sleeptime(delta);
 
-	timekeeper.ntp_error = 0;
-	ntp_clear();
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
-			timekeeper.clock, timekeeper.mult);
+	timekeeping_update(true);
 
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
@@ -993,9 +990,7 @@ static void update_wall_time(void)
 		second_overflow();
 	}
 
-	/* check to see if there is a new clocksource to use */
-	update_vsyscall(&timekeeper.xtime, &timekeeper.wall_to_monotonic,
-			timekeeper.clock, timekeeper.mult);
+	timekeeping_update(false);
 
 out:
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
-- 
1.7.3.2.146.gca209

