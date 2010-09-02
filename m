Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0IBRpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:45:14 -0400
Received: from n1.taur.dk ([217.198.219.102]:33875 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0IBRpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:45:12 -0400
X-Greylist: delayed 3051 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 13:45:10 EDT
Message-ID: <4C7FD6B8.7080401@kasperkp.dk>
Date: Thu, 02 Sep 2010 18:54:16 +0200
From: Kasper Pedersen <kkp2010@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] time: compensate for rounding on odd-frequency clocksources
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the clocksource is not a multiple of HZ, the clock will be off. 
For acpi_pm, HZ=1000 the error is 127.111 ppm:

The rounding of cycle_interval ends up generating a false error term 
in ntp_error accumulation since xtime_interval is not exactly 1/HZ. 
So, we subtract out the error caused by the rounding.

This has been visible since 2.6.32-rc2
	commit a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601
	time: Implement logarithmic time accumulation
That commit raised NTP_INTERVAL_FREQ and exposed the rounding error.

testing tool: http://n1.taur.dk/permanent/testpmt.c
Also tested with ntpd and a frequency counter.

patch against 2.6.36-rc3-next. 


Signed-off-by: Kasper Pedersen <kkp2010@kasperkp.dk>
---
 kernel/time/timekeeping.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 77e930d..5ee5dea 100644
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
 
@@ -746,7 +750,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-	timekeeper.ntp_error -= timekeeper.xtime_interval <<
+	timekeeper.ntp_error -=
+	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
 
 	return offset;

