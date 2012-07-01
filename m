Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2GAJiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:38:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34078 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2GAJiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:38:21 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] [RFC] Potential fix for leapsecond caused futex related load spikes
Date: Sun,  1 Jul 2012 05:36:11 -0400
Message-Id: <1341135371-45034-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
x-cbid: 12070109-7606-0000-0000-000001A24767
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As widely reported on the internet today, some Linux systems after
the leapsecond was inserted are experiencing futex related load
spikes (usually connected to MySQL, Firefox, Thunderbird, Java, etc).

An apparent for this issue workaround is running:
$ date -s "`date`"

Credit: http://www.sheeri.com/content/mysql-and-leap-second-high-cpu-and-fix

I believe this issue is due to the leapsecond being added without
calling clock_was_set() to notify the hrtimer subsystem of the
change. (Although I've not yet chased all the way down to the
hrtimer code to validate exactly what's going on there).

The workaround functions as it forces a clock_was_set()
call from settimeofday().

This fix adds some extra logic to track when a leapsecond
is added from update_wall_time() and calls clock_was_set()
once the timekeeper.lock is released.

I've been able to reproduce the load spike using Thunderbird
when triggering a leap second and with this patch the issue
did not crop up.

NOTE: Some reports have been of a hard hang right at or before
the leapsecond. I've not been able to reproduce or diagnose
this, so this fix does not likely address the reported hard
hangs (unless they end up being connected to the futex/hrtimer
issue).

It had been a long day before I heard about this issue, so
my brain is a little mushy right now. Reviews and extra
testing would be greatly appreciated.

CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6f46a00..e5da44f 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -942,7 +942,7 @@ static void timekeeping_adjust(s64 offset)
  *
  * Returns the unconsumed cycles.
  */
-static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
+static cycle_t logarithmic_accumulation(cycle_t offset, int shift, int* clockset)
 {
 	u64 nsecps = (u64)NSEC_PER_SEC << timekeeper.shift;
 	u64 raw_nsecs;
@@ -963,6 +963,8 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			*clockset = 1;
 	}
 
 	/* Accumulate raw time */
@@ -994,6 +996,7 @@ static void update_wall_time(void)
 	struct clocksource *clock;
 	cycle_t offset;
 	int shift = 0, maxshift;
+	int clockset = 0;
 	unsigned long flags;
 
 	write_seqlock_irqsave(&timekeeper.lock, flags);
@@ -1026,7 +1029,7 @@ static void update_wall_time(void)
 	maxshift = (64 - (ilog2(ntp_tick_length())+1)) - 1;
 	shift = min(shift, maxshift);
 	while (offset >= timekeeper.cycle_interval) {
-		offset = logarithmic_accumulation(offset, shift);
+		offset = logarithmic_accumulation(offset, shift, &clockset);
 		if(offset < timekeeper.cycle_interval<<shift)
 			shift--;
 	}
@@ -1079,6 +1082,8 @@ static void update_wall_time(void)
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
 		timekeeper.wall_to_monotonic.tv_sec -= leap;
+		if (leap)
+			clockset = 1;
 	}
 
 	timekeeping_update(false);
@@ -1086,6 +1091,8 @@ static void update_wall_time(void)
 out:
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
+	if (clockset)
+		clock_was_set();
 }
 
 /**
-- 
1.7.9.5

