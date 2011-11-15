Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1KOEFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:05:01 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35064 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab1KOEEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:54 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 15/16] time: Update tiemkeeper structure using a local shadow
Date: Mon, 14 Nov 2011 20:04:05 -0800
Message-Id: <1321329846-14755-16-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-3534-0000-0000-000001E29A24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses a local shadow structure to update the timekeeper. This
reduces the timekeeper.lock hold time.

WARNING: This introduces a race, but the window might be provably
so small as to not be observable. This patch needs lots more math
and comments to validate that assumption.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7870a0e..ba595a3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -940,6 +940,7 @@ static cycle_t logarithmic_accumulation(struct timekeeper *tk, cycle_t offset,
 static void update_wall_time(void)
 {
 	struct clocksource *clock;
+	struct timekeeper tk;
 	cycle_t offset;
 	int shift = 0, maxshift;
 	unsigned long flags;
@@ -951,10 +952,13 @@ static void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = timekeeper.clock;
+	tk = timekeeper;
+	write_sequnlock_irqrestore(&timekeeper.lock, flags);
+
+	clock = tk.clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = timekeeper.cycle_interval;
+	offset = tk.cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
@@ -967,19 +971,19 @@ static void update_wall_time(void)
 	 * chunk in one go, and then try to consume the next smaller
 	 * doubled multiple.
 	 */
-	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
+	shift = ilog2(offset) - ilog2(tk.cycle_interval);
 	shift = max(0, shift);
 	/* Bound shift to one less then what overflows tick_length */
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
-	while (offset >= timekeeper.cycle_interval) {
-		offset = logarithmic_accumulation(&timekeeper, offset, shift);
-		if(offset < timekeeper.cycle_interval<<shift)
+	while (offset >= tk.cycle_interval) {
+		offset = logarithmic_accumulation(&tk, offset, shift);
+		if(offset < tk.cycle_interval<<shift)
 			shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
-	timekeeping_adjust(&timekeeper, offset);
+	timekeeping_adjust(&tk, offset);
 
 	/*
 	 * Since in the loop above, we accumulate any amount of time
@@ -997,10 +1001,10 @@ static void update_wall_time(void)
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
-		s64 neg = -(s64)timekeeper.xtime_nsec;
-		timekeeper.xtime_nsec = 0;
-		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
+	if (unlikely((s64)tk.xtime_nsec < 0)) {
+		s64 neg = -(s64)tk.xtime_nsec;
+		tk.xtime_nsec = 0;
+		tk.ntp_error += neg << tk.ntp_error_shift;
 	}
 
 	/*
@@ -1012,23 +1016,24 @@ static void update_wall_time(void)
 	* the vsyscall implementations are converted to use xtime_nsec
 	* (shifted nanoseconds), this can be killed.
 	*/
-	remainder = timekeeper.xtime_nsec & ((1<<timekeeper.shift)-1);
-	timekeeper.xtime_nsec -= remainder;
-	timekeeper.xtime_nsec += 1<<timekeeper.shift;
-	timekeeper.ntp_error += remainder <<
-					timekeeper.ntp_error_shift;
+	remainder = tk.xtime_nsec & ((1<<tk.shift)-1);
+	tk.xtime_nsec -= remainder;
+	tk.xtime_nsec += 1<<tk.shift;
+	tk.ntp_error += remainder << tk.ntp_error_shift;
 
 	/*
 	 * Finally, make sure that after the rounding
 	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
 	 */
-	if (unlikely(timekeeper.xtime_nsec >=
-			(NSEC_PER_SEC << timekeeper.shift))) {
-		timekeeper.xtime_nsec -= NSEC_PER_SEC << timekeeper.shift;
-		timekeeper.xtime_sec++;
+	if (unlikely(tk.xtime_nsec >= (NSEC_PER_SEC << tk.shift))) {
+		tk.xtime_nsec -= NSEC_PER_SEC << tk.shift;
+		tk.xtime_sec++;
 		second_overflow();
 	}
 
+	write_seqlock_irqsave(&timekeeper.lock, flags);
+
+	timekeeper = tk;
 	timekeeping_update(&timekeeper, false);
 
 out:
-- 
1.7.3.2.146.gca209

