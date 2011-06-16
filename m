Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab1FPHVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:21:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59706 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756628Ab1FPHKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:32 -0400
X-Sasl-enc: 1fcXzP0kJ/JUSArVRYnkiDbGH6PObM0QnZwISO7wI/BG 1308208231
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:06 2011
Message-Id: <20110616002905.962278622@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kasper Pedersen <kkp2010@kasperkp.dk>,
        john stultz <johnstul@us.ibm.com>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [22/85] time: Compensate for rounding on odd-frequency clocksources
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kasper Pedersen <kkp2010@kasperkp.dk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/timekeeping.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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
@@ -70,6 +72,7 @@ static void timekeeper_setup_internals(s
 	/* Do the ns -> cycle conversion first, using original mult */
 	tmp = NTP_INTERVAL_LENGTH;
 	tmp <<= clock->shift;
+	ntpinterval = tmp;
 	tmp += clock->mult/2;
 	do_div(tmp, clock->mult);
 	if (tmp == 0)
@@ -80,6 +83,7 @@ static void timekeeper_setup_internals(s
 
 	/* Go back from cycles -> shifted ns */
 	timekeeper.xtime_interval = (u64) interval * clock->mult;
+	timekeeper.xtime_remainder = ntpinterval - timekeeper.xtime_interval;
 	timekeeper.raw_interval =
 		((u64) interval * clock->mult) >> clock->shift;
 
@@ -771,7 +775,8 @@ static cycle_t logarithmic_accumulation(
 
 	/* Accumulate error between NTP and clock interval */
 	timekeeper.ntp_error += tick_length << shift;
-	timekeeper.ntp_error -= timekeeper.xtime_interval <<
+	timekeeper.ntp_error -=
+	    (timekeeper.xtime_interval + timekeeper.xtime_remainder) <<
 				(timekeeper.ntp_error_shift + shift);
 
 	return offset;


