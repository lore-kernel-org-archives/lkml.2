Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1KOEGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:06:32 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51553 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab1KOEEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 08/16] ntp: Access tick_length variable via ntp_tick_length()
Date: Mon, 14 Nov 2011 20:03:58 -0800
Message-Id: <1321329846-14755-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
References: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
x-cbid: 11111504-6148-0000-0000-000001338180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the NTP managed tick_length value is accessed globally,
in preparations for locking cleanups, make sure it is accessed via
a function and mark it as static.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/timex.h     |    2 +-
 kernel/time/ntp.c         |    9 ++++++++-
 kernel/time/timekeeping.c |    6 +++---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 92e01fc..b75e186 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -250,7 +250,7 @@ extern void ntp_clear(void);
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
-extern u64 tick_length;
+extern u64 ntp_tick_length(void);
 
 extern void second_overflow(void);
 extern int do_adjtimex(struct timex *);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index ae7e136..f131ba6 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -28,7 +28,7 @@ unsigned long			tick_usec = TICK_USEC;
 /* ACTHZ period (nsecs): */
 unsigned long			tick_nsec;
 
-u64				tick_length;
+static u64			tick_length;
 static u64			tick_length_base;
 
 static struct hrtimer		leap_timer;
@@ -360,6 +360,13 @@ void ntp_clear(void)
 	pps_clear();
 }
 
+
+u64 ntp_tick_length(void)
+{
+	return tick_length;
+}
+
+
 /*
  * Leap second processing. If in leap-insert state at the end of the
  * day, the system clock is set back one second; if in leap-delete
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8f54200..f92e636 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -807,7 +807,7 @@ static __always_inline int timekeeping_bigadjust(s64 error, s64 *interval,
 	 * Now calculate the error in (1 << look_ahead) ticks, but first
 	 * remove the single look ahead already included in the error.
 	 */
-	tick_error = tick_length >> (timekeeper.ntp_error_shift + 1);
+	tick_error = ntp_tick_length() >> (timekeeper.ntp_error_shift + 1);
 	tick_error -= timekeeper.xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -904,7 +904,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	timekeeper.raw_time.tv_nsec = raw_nsecs;
 
 	/* Accumulate error between NTP and clock interval */
-	timekeeper.ntp_error += tick_length << shift;
+	timekeeper.ntp_error += ntp_tick_length() << shift;
 	timekeeper.ntp_error -=
 	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
@@ -952,7 +952,7 @@ static void update_wall_time(void)
 	shift = ilog2(offset) - ilog2(timekeeper.cycle_interval);
 	shift = max(0, shift);
 	/* Bound shift to one less then what overflows tick_length */
-	maxshift = (8*sizeof(tick_length) - (ilog2(tick_length)+1)) - 1;
+	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
 		offset = logarithmic_accumulation(offset, shift);
-- 
1.7.3.2.146.gca209

