Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0LHSa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 13:30:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57699 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0LHSa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 13:30:58 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Bph6ssctQ44A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=tBb2bbeoAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=R5z1oqr90NEaCzVe3EAA:9 a=eHgT1TnorDCjTaAbLnwA:7 a=_vYWKDqEWA0obBHMBdUnuomFF18A:4 a=PUjeQqilurYA:10 a=YuKU6ANggZ8A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFC][PATCH] timekeeping: Keep xtime_nsec remainder separate from
 ntp_error
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 08 Dec 2010 13:30:54 -0500
Message-ID: <1291833054.5015.1133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing my end of year unlikely() cleanup, running the annotate
branch profiler, I came across this:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
  122588 65653641  99 timekeeping_adjust             timekeeping.c        664
  167493 14584927  98 timekeeping_adjust             timekeeping.c        658

This shows that the following likely()'s are wrong most of the time:

	if (error > interval) {
		error >>= 2;
		if (likely(error <= interval))
			adj = 1;
		else
			adj = timekeeping_bigadjust(error, &interval, &offset);
	} else if (error < -interval) {
		error >>= 2;
		if (likely(error >= -interval)) {

Talking about this with John Stultz, we both agreed that the annotations
should be correct and is not the issue, but something else is going
wrong.

Adding in trace_printks(), I saw that the adj values that were added to
the "mult" multiplier were sometimes quite large. The time intervals
never got down into a small error, but instead was making large
oscillations, both positive and negative to where it should be.

John noticed that if he removed the commit:

commit 5cd1c9c5cf30d4b33df3d3f74d8142f278d536b7
timekeeping: fix rounding problem during clock update

that the problem would go away and we would get back into a tight
oscillation that would stay within the fast path (and the likely()'s
were again likely).

What the above commit did was to fix a bug that caused time to go
backward a nanosec due to the truncating of the xtime_nsec shifted into
the xtime.tv_nsec.  The fix for that bug (and what that commit did) was
to always round up one. It added +1 to the xtime.tv_nsec after it did
the conversion, and then took the difference between this shifted and
the xtime_nsec and stored that into the ntp_error.

The ntp_error is used to control the frequency, and this constant adding
of the shift remainder would cause the large oscillation.

This patch instead adds another field to the timekeeping structure that
stores the remainder separately. On re-entry into update_wall_time(),
the remainder is added back onto the xtime_nsec after it is set to the
xtime.tv_nsec and restoring its original value.

This handles the rounding problem that the original commit addressed but
does not cause the large oscillation that it caused.

The new results of the branch annotation profiler is now:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
  736971      129   0 timekeeping_adjust             timekeeping.c        685
  736943      115   0 timekeeping_adjust             timekeeping.c        676


Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-compile.git/kernel/time/timekeeping.c
===================================================================
--- linux-compile.git.orig/kernel/time/timekeeping.c
+++ linux-compile.git/kernel/time/timekeeping.c
@@ -37,6 +37,10 @@ struct timekeeper {
 
 	/* Clock shifted nano seconds remainder not stored in xtime.tv_nsec. */
 	u64	xtime_nsec;
+
+	/* remainder in xtime subtraction */
+	u64	xtime_nsec_rem;
+
 	/* Difference between accumulated time and NTP time in ntp
 	 * shifted nano seconds. */
 	s64	ntp_error;
@@ -84,6 +88,7 @@ static void timekeeper_setup_internals(s
 		((u64) interval * clock->mult) >> clock->shift;
 
 	timekeeper.xtime_nsec = 0;
+	timekeeper.xtime_nsec_rem = 0;
 	timekeeper.shift = clock->shift;
 
 	timekeeper.ntp_error = 0;
@@ -751,6 +756,12 @@ void update_wall_time(void)
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
 	/*
+	 * Add back the remainder that was left over when adding +1 to
+	 * xtime.tv_nsec;
+	 */
+	timekeeper.xtime_nsec += timekeeper.xtime_nsec_rem;
+
+	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
 	 * we calculate the largest doubling multiple of cycle_intervals
@@ -797,12 +808,11 @@ void update_wall_time(void)
 
 	/*
 	 * Store full nanoseconds into xtime after rounding it up and
-	 * add the remainder to the error difference.
+	 * store the remainder to update xtime_nsec on the next iteration.
 	 */
 	xtime.tv_nsec =	((s64) timekeeper.xtime_nsec >> timekeeper.shift) + 1;
 	timekeeper.xtime_nsec -= (s64) xtime.tv_nsec << timekeeper.shift;
-	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
-				timekeeper.ntp_error_shift;
+	timekeeper.xtime_nsec_rem = timekeeper.xtime_nsec;
 
 	/*
 	 * Finally, make sure that after the rounding


