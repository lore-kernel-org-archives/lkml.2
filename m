Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2GOJBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:01:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2GOJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:00:58 -0400
Date: Sun, 15 Jul 2012 02:00:40 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-2a8c0883c3cfffcc148ea606e2a4e7453cd75e73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: john.stultz@linaro.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com, tglx@linutronix.de,
        prarit@redhat.com
In-Reply-To: <1342156917-25092-8-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-8-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time:
  Move xtime_nsec adjustment underflow handling timekeeping_adjust
Git-Commit-ID: 2a8c0883c3cfffcc148ea606e2a4e7453cd75e73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Jul 2012 02:00:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a8c0883c3cfffcc148ea606e2a4e7453cd75e73
Gitweb:     http://git.kernel.org/tip/2a8c0883c3cfffcc148ea606e2a4e7453cd75e73
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 13 Jul 2012 01:21:56 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 15 Jul 2012 10:39:07 +0200

time: Move xtime_nsec adjustment underflow handling timekeeping_adjust

When we make adjustments speeding up the clock, its possible
for xtime_nsec to underflow. We already handle this properly,
but we do so from update_wall_time() instead of the more logical
timekeeping_adjust(), where the possible underflow actually
occurs.

Thus, move the correction logic to the timekeeping_adjust, which
is the function that causes the issue. Making update_wall_time()
more readable.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1342156917-25092-8-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e43289d..aeeaab8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -980,6 +980,27 @@ static void timekeeping_adjust(s64 offset)
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
 
 
@@ -1105,27 +1126,6 @@ static void update_wall_time(void)
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
