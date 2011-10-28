Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab1J1BMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 21:12:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57542 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab1J1BMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 21:12:51 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Chen Jie <chenj@lemote.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] time: Improve documentation of timekeeeping_adjust()
Date: Thu, 27 Oct 2011 18:12:42 -0700
Message-Id: <1319764362-32367-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11102801-5806-0000-0000-000000665D7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After getting a number of questions in private emails about the
math around admittedly very complex timekeeping_adjust() and
timekeeping_big_adjust(), I  figure the code needs some better
comments.

Hopefully the explanations are clear enough and don't muddy the water
any worse.

Still needs documentation for ntp_error, but I couldn't recall
exactly the full explanation behind the code that's there (although
I do recall once working it out when Roman first proposed it).
Given a bit more time I can probably work it out, but I don't want to
hold back this documentation until then.

CC: Chen Jie <chenj@lemote.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   81 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a5846a8..de8737e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -802,14 +802,44 @@ static void timekeeping_adjust(s64 offset)
 	s64 error, interval = timekeeper.cycle_interval;
 	int adj;
 
+	/*
+	 * The point of this is to check if the error is greater then half
+	 * an interval.
+	 *
+	 * First we shift it down from NTP_SHIFT to clocksource->shifted nsecs.
+	 *
+	 * Note we subtract one in the shift, so that error is really error*2.
+	 * This "saves" dividing(shifting) intererval twice, but keeps the
+	 * (error > interval) comparision as still measuring if error is
+	 * larger then half an interval.
+	 *
+	 * Note: It does not "save" on aggrivation when reading the code.
+	 */
 	error = timekeeper.ntp_error >> (timekeeper.ntp_error_shift - 1);
 	if (error > interval) {
+		/*
+		 * We now divide error by 4(via shift), which checks if
+		 * the error is greater then twice the interval.
+		 * If it is greater, we need a bigadjust, if its smaller,
+		 * we can adjust by 1.
+		 */
 		error >>= 2;
+		/*
+		 * XXX - In update_wall_time, we round up to the next
+		 * nanosecond, and store the amount rounded up into
+		 * the error. This causes the likely below to be unlikely.
+		 *
+		 * The properfix is to avoid rounding up by using
+		 * the high precision timekeeper.xtime_nsec instead of
+		 * xtime.tv_nsec everywhere. Fixing this will take some
+		 * time.
+		 */
 		if (likely(error <= interval))
 			adj = 1;
 		else
 			adj = timekeeping_bigadjust(error, &interval, &offset);
 	} else if (error < -interval) {
+		/* See comment above, this is just switched for the negative */
 		error >>= 2;
 		if (likely(error >= -interval)) {
 			adj = -1;
@@ -817,9 +847,58 @@ static void timekeeping_adjust(s64 offset)
 			offset = -offset;
 		} else
 			adj = timekeeping_bigadjust(error, &interval, &offset);
-	} else
+	} else /* No adjustment needed */
 		return;
 
+	/*
+	 * So the following can be confusing.
+	 *
+	 * To keep things simple, lets assume adj == 1 for now.
+	 *
+	 * When adj != 1, remember that the interval and offset values
+	 * have been appropriately scaled so the math is the same.
+	 *
+	 * The basic idea here is that we're increasing the multiplier
+	 * by one, this causes the xtime_interval to be incremented by
+	 * one cycle_interval. This is because:
+	 *	xtime_interval = cycle_interval * mult
+	 * So if mult is being incremented by one:
+	 *	xtime_interval = cycle_interval * (mult + 1)
+	 * Its the same as:
+	 *	xtime_interval = (cycle_interval * mult) + cycle_interval
+	 * Which can be shortened to:
+	 *	xtime_interval += cycle_interval
+	 *
+	 * So offset stores the non-accumulated cycles. Thus the current
+	 * time (in shifted nanoseconds) is:
+	 *	now = (offset * adj) + xtime_nsec
+	 * Now, even though we're adjusting the clock frequency, we have
+	 * to keep time consistent. In other words, we can't jump back
+	 * in time, and we also want to avoid jumping forward in time.
+	 *
+	 * So given the same offset value, we need the time to be the same
+	 * both before and after the freq adjustment.
+	 *	now = (offset * adj_1) + xtime_nsec_1
+	 *	now = (offset * adj_2) + xtime_nsec_2
+	 * So:
+	 *	(offset * adj_1) + xtime_nsec_1 =
+	 *		(offset * adj_2) + xtime_nsec_2
+	 * And we know:
+	 *	adj_2 = adj_1 + 1
+	 * So:
+	 *	(offset * adj_1) + xtime_nsec_1 =
+	 *		(offset * (adj_1+1)) + xtime_nsec_2
+	 *	(offset * adj_1) + xtime_nsec_1 =
+	 *		(offset * adj_1) + offset + xtime_nsec_2
+	 * Canceling the sides:
+	 *	xtime_nsec_1 = offset + xtime_nsec_2
+	 * Which gives us:
+	 *	xtime_nsec_2 = xtime_nsec_1 - offset
+	 * Which simplfies to:
+	 *	xtime_nsec -= offset
+	 *
+	 * XXX - TODO: Doc ntp_error calculation.
+	 */
 	timekeeper.mult += adj;
 	timekeeper.xtime_interval += interval;
 	timekeeper.xtime_nsec -= offset;
-- 
1.7.3.2.146.gca209

