Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab2EOC6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:58:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:49518 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab2EOCRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 075/179] time: Compensate for rounding on odd-frequency clocksources
Date: Mon, 14 May 2012 22:12:51 -0400
Message-ID: <1337048075-6132-76-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kasper Pedersen <kkp2010@kasperkp.dk>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a386b5af8edda1c742ce9f77891e112eefffc005 upstream.

When the clocksource is not a multiple of HZ, the clock will be off.  For
acpi_pm, HZ=1000 the error is 127.111 ppm:

The rounding of cycle_interval ends up generating a false error term in
ntp_error accumulation since xtime_interval is not exactly 1/HZ.  So, we
subtract out the error caused by the rounding.

This has been visible since 2.6.32-rc2
	commit a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601
	time: Implement logarithmic time accumulation
That commit raised NTP_INTERVAL_FREQ and exposed the rounding error.

testing tool: http://n1.taur.dk/permanent/testpmt.c
Also tested with ntpd and a frequency counter.

Signed-off-by: Kasper Pedersen <kkp2010@kasperkp.dk>
Acked-by: john stultz <johnstul@us.ibm.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/timekeeping.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 39f6177..268020d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -32,6 +32,8 @@ struct timekeeper {
 	cycle_t cycle_interval;
 	/* Number of clock shifted nano seconds in one NTP interval. */
 	u64	xtime_interval;
+	/* shifted nano seconds left over when rounding cycle_interval */
+	s64	xtime_remainder;
 	/* Raw nano seconds accumulated per NTP interval. */
 	u32	raw_interval;
 
@@ -62,7 +64,7 @@ struct timekeeper timekeeper;
 static void timekeeper_setup_internals(struct clocksource *clock)
 {
 	cycle_t interval;
-	u64 tmp;
+	u64 tmp, ntpinterval;
 
 	timekeeper.clock = clock;
 	clock->cycle_last = clock->read(clock);
@@ -70,6 +72,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
 	tmp <<= clock->shift;
+	ntpinterval = tmp;
 	tmp += clock->mult/2;
 	do_div(tmp, clock->mult);
 	if (tmp == 0)
@@ -80,6 +83,7 @@ static void timekeeper_setup_internals(struct clocksource *clock)
 
 	/* Go back from cycles -> shifted ns */
 	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.xtime_remainder = ntpinterval - timekeeper.xtime_interval;
 	timekeeper.raw_interval =
 		((u64) interval * clock->mult) >> clock->shift;
 
@@ -772,7 +776,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-	timekeeper.ntp_error -= timekeeper.xtime_interval <<
+	timekeeper.ntp_error -=
+	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
 
 	return offset;
-- 
1.7.9.6

