Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab1LUVTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:19:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab1LUVSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:18:21 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        avi@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/5] time: Minimize number of touch_softlockup_watchdog
Date: Wed, 21 Dec 2011 16:17:42 -0500
Message-Id: <1324502265-24521-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
References: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another patch where I was worried about overhead on a change
in the softlockup code.  Currently on my x86 box it seems the
tick code was touch the softlockup every millisecond.

To minimize, I moved the touch_softlockup_watchdog to a
common function, tick_do_update_jiffies64.  Then the code
only ever touches the softlockup when there was a greater
than 1 second jump in the tick.

Considering the softlockup fires ever 20 seconds or so, this
should be safe for now.

This saves about a 1 thousand calls/per second.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/time/tick-sched.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 31cc061..00578c0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -73,6 +73,8 @@ static void tick_do_update_jiffies64(ktime_t now)
 
 			last_jiffies_update = ktime_add_ns(last_jiffies_update,
 							   incr * ticks);
+			if (incr > NSEC_PER_SEC)
+				touch_softlockup_watchdog();
 		}
 		do_timer(++ticks);
 
@@ -144,8 +146,6 @@ static void tick_nohz_update_jiffies(ktime_t now)
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
-
-	touch_softlockup_watchdog();
 }
 
 /*
@@ -572,7 +572,6 @@ void tick_nohz_restart_sched_tick(void)
 		account_idle_ticks(ticks);
 #endif
 
-	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
 	 */
@@ -625,7 +624,6 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	 * do when we go busy again does not account too much ticks.
 	 */
 	if (ts->tick_stopped) {
-		touch_softlockup_watchdog();
 		ts->idle_jiffies++;
 	}
 
@@ -783,7 +781,6 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		 * when we go busy again does not account too much ticks.
 		 */
 		if (ts->tick_stopped) {
-			touch_softlockup_watchdog();
 			ts->idle_jiffies++;
 		}
 		update_process_times(user_mode(regs));
-- 
1.7.7.4

