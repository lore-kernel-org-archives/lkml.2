Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2GMFYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:24:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58123 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab2GMFYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:24:04 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 7/8] time: Move xtime_nsec adjustment underflow handling timekeeping_adjust
Date: Fri, 13 Jul 2012 01:21:56 -0400
Message-Id: <1342156917-25092-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071305-6148-0000-0000-0000079F0AB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we make adjustments speeding up the clock, its possible
for xtime_nsec to underflow. We already handle this properly,
but we do so from update_wall_time() instead of the more logical
timekeeping_adjust(), where the possible underflow actually
occurs.

Thus, move the correction logic to the timekeeping_adjust, which
is the function that causes the issue. Making update_wall_time()
more readable.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dd119355..4b76432 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -987,6 +987,27 @@ static void timekeeping_adjust(s64 offset)
 	timekeeper.xtime_nsec -= offset;
 	timekeeper.ntp_error -= (interval - offset) <<
 				timekeeper.ntp_error_shift;
+
+	/*
+	 * It may be possible that when we entered this function, xtime_nsec
+	 * was very small.  Further, if we're slightly speeding the clocksource
+	 * in the code above, its possible the required corrective factor to
+	 * xtime_nsec could cause it to underflow.
+	 *
+	 * Now, since we already accumulated the second, cannot simply roll
+	 * the accumulated second back, since the NTP subsystem has been
+	 * notified via second_overflow. So instead we push xtime_nsec forward
+	 * by the amount we underflowed, and add that amount into the error.
+	 *
+	 * We'll correct this error next time through this function, when
+	 * xtime_nsec is not as small.
+	 */
+	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
+		s64 neg = -(s64)timekeeper.xtime_nsec;
+		timekeeper.xtime_nsec = 0;
+		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
+	}
+
 }
 
 
@@ -1112,27 +1133,6 @@ static void update_wall_time(void)
 	/* correct the clock when NTP error is too big */
 	timekeeping_adjust(offset);
 
-	/*
-	 * Since in the loop above, we accumulate any amount of time
-	 * in xtime_nsec over a second into xtime.tv_sec, its possible for
-	 * xtime_nsec to be fairly small after the loop. Further, if we're
-	 * slightly speeding the clocksource up in timekeeping_adjust(),
-	 * its possible the required corrective factor to xtime_nsec could
-	 * cause it to underflow.
-	 *
-	 * Now, we cannot simply roll the accumulated second back, since
-	 * the NTP subsystem has been notified via second_overflow. So
-	 * instead we push xtime_nsec forward by the amount we underflowed,
-	 * and add that amount into the error.
-	 *
-	 * We'll correct this error next time through this function, when
-	 * xtime_nsec is not as small.
-	 */
-	if (unlikely((s64)timekeeper.xtime_nsec < 0)) {
-		s64 neg = -(s64)timekeeper.xtime_nsec;
-		timekeeper.xtime_nsec = 0;
-		timekeeper.ntp_error += neg << timekeeper.ntp_error_shift;
-	}
 
 	/*
 	* Store only full nanoseconds into xtime_nsec after rounding
-- 
1.7.9.5

