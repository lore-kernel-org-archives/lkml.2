Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033Ab2CBHNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:13:11 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:41567 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903Ab2CBHNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:13:04 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 4/9] time: Update timekeeper structure using a local shadow
Date: Thu,  1 Mar 2012 23:12:43 -0800
Message-Id: <1330672368-32290-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
References: <1330672368-32290-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030207-7408-0000-0000-00000324BA85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses a local shadow structure to update the timekeeper. This
will allow for reduced timekeeper.rlock hold time.

CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   43 +++++++++++++++++++++++--------------------
 1 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f9ee96c..09460c1 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -74,6 +74,7 @@ struct timekeeper {
 };
 
 static struct timekeeper timekeeper;
+static struct timekeeper shadow_tk;
 
 /* Locks for timekeeper variable: */
 /* This seqcount serializes readers from updates */
@@ -1072,10 +1073,11 @@ static void update_wall_time(void)
 	if (unlikely(timekeeping_suspended))
 		goto out;
 
-	clock = timekeeper.clock;
+	shadow_tk = timekeeper;
+	clock = shadow_tk.clock;
 
 #ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
-	offset = timekeeper.cycle_interval;
+	offset = shadow_tk.cycle_interval;
 #else
 	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
@@ -1088,19 +1090,19 @@ static void update_wall_time(void)
 	 * chunk in one go, and then try to consume the next smaller
 	 * doubled multiple.
 	 */
-	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
+	shift = ilog2(offset) - ilog2(shadow_tk.cycle_interval);
 	shift = max(0, shift);
 	/* Bound shift to one less then what overflows tick_length */
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
-	while (offset >= timekeeper.cycle_interval) {
-		offset = logarithmic_accumulation(&timekeeper, offset, shift);
-		if(offset < timekeeper.cycle_interval<<shift)
+	while (offset >= shadow_tk.cycle_interval) {
+		offset = logarithmic_accumulation(&shadow_tk, offset, shift);
+		if (offset < shadow_tk.cycle_interval<<shift)
 			shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
-	timekeeping_adjust(&timekeeper, offset);
+	timekeeping_adjust(&shadow_tk, offset);
 
 	/*
 	 * Since in the loop above, we accumulate any amount of time
@@ -1118,10 +1120,10 @@ static void update_wall_time(void)
 	 * We'll correct this error next time through this function, when
 	 * xtime_nsec is not as small.
 	 */
-	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
-		s64 neg = -(s64)timekeeper.xtime_nsec;
-		timekeeper.xtime_nsec = 0;
-		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
+	if (unlikely((s64)shadow_tk.xtime_nsec < 0)) {
+		s64 neg = -(s64)shadow_tk.xtime_nsec;
+		shadow_tk.xtime_nsec = 0;
+		shadow_tk.ntp_error += neg << shadow_tk.ntp_error_shift;
 	}
 
 	/*
@@ -1133,23 +1135,24 @@ static void update_wall_time(void)
 	* the vsyscall implementations are converted to use xtime_nsec
 	* (shifted nanoseconds), this can be killed.
 	*/
-	remainder = timekeeper.xtime_nsec & ((1<<timekeeper.shift)-1);
-	timekeeper.xtime_nsec -= remainder;
-	timekeeper.xtime_nsec += 1<<timekeeper.shift;
-	timekeeper.ntp_error += remainder <<
-					timekeeper.ntp_error_shift;
+	remainder = shadow_tk.xtime_nsec & ((1<<shadow_tk.shift)-1);
+	shadow_tk.xtime_nsec -= remainder;
+	shadow_tk.xtime_nsec += 1<<shadow_tk.shift;
+	shadow_tk.ntp_error += remainder << shadow_tk.ntp_error_shift;
 
 	/*
 	 * Finally, make sure that after the rounding
 	 * xtime.tv_nsec isn't larger then NSEC_PER_SEC
 	 */
-	if (unlikely(timekeeper.xtime_nsec >=
-			((u64)NSEC_PER_SEC << timekeeper.shift))) {
-		timekeeper.xtime_nsec -= (u64)NSEC_PER_SEC << timekeeper.shift;
-		timekeeper.xtime_sec++;
+	if (unlikely(shadow_tk.xtime_nsec >=
+				((u64)NSEC_PER_SEC << shadow_tk.shift))) {
+		shadow_tk.xtime_nsec -= (u64)NSEC_PER_SEC << shadow_tk.shift;
+		shadow_tk.xtime_sec++;
 		second_overflow();
 	}
 
+
+	timekeeper = shadow_tk;
 	timekeeping_update(&timekeeper, false);
 
 out:
-- 
1.7.3.2.146.gca209

