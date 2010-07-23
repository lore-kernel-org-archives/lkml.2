Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0GWDNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:13:16 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42611 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0GWDNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:13:15 -0400
Subject: [RFC][PATCH -rt] Handling delayed clocksource watchdog timer
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Darren Hart <dvhltc@us.ibm.com>,
        Paul Clarke <pacman@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 20:13:09 -0700
Message-ID: <1279854789.2442.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	I just wanted to run this by you to see if you maybe had a thought on
how to better handle a situation we came across.

Now, first of all, with the rt throttling enabled, this is less likely
to bite folks, but its possible that folks disabling the throttling
could run into trouble.

We ran into a case where an very heavy -rt test load, which was normally
run on a multi-processor system was moved over to a single core system.
The box basically locks up for awhile while the test load churns away
(lots of SCHED_FIFO tasks, basically hogging the cpu).

After some hours, when the test completes, we noticed that even on
systems with stable TSCs, we were seeing the: "Clocksource tsc unstable
(delta = XYZ ns)" messages, and the system had fallen back to a slower
clocksource.

Digging into the clocksource watchdog code, I realized that the watchdog
timer was being drastically delayed. So long in fact, that the
clocksource watchdog hardware would wrap (while the TSC would not). This
then caused a great disparity between the clocksource interval and the
watchdog interval, and thus the TSC was being marked unstable.

The solution is a little more difficult to figure out. Because with the
delay we run into the problem that the watchdog hardware is not
reliable. So it makes it difficult distinguish between cases where the
clocksource is actually bad, and the cases where the timer was delayed.

The following patch tries to ignore cases where the timer was delayed by
more then 4x the watchdog interval. However, its not really perfect,
since jiffies may be driven by the clocksource, so if the clocksource
running really really fast, its possible that jiffies would increment
quickly enough that we'd think we just were delayed a long time.

I also considered skipping cases where the wd_nsec value was too large
or too small, but again, as the timer is driven by the possibly bad
clocksource, it seemed we could give false negatives and miss the bad
hardware.

Any better ideas?

thanks
-john

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 0e98497..a91e7ba 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -280,7 +280,8 @@ static void clocksource_watchdog(unsigned long data)
 		cs_nsec = clocksource_cyc2ns((csnow - cs->wd_last) &
 					     cs->mask, cs->mult, cs->shift);
 		cs->wd_last = csnow;
-		if (abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
+		if (jiffies - watchdog_timer.expires > 4*WATCHDOG_INTERVAL) &&
+				(abs(cs_nsec - wd_nsec) > WATCHDOG_THRESHOLD) {
 			clocksource_unstable(cs, cs_nsec - wd_nsec);
 			continue;
 		}


