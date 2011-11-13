Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1KMXTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 18:19:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:45137 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1KMXTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 18:19:49 -0500
Message-Id: <20111113231341.602682242@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 13 Nov 2011 23:19:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [patch 3/7] timekeeping: Make seqcount sections smaller
References: <20111113230921.728083714@linutronix.de>
Content-Disposition: inline; filename=xtime-timekeeping-seqcount-sections.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the seqcount bump inside of do_timer() and remove it from
sections which only need the xtime_lock serialization.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-common.c |    2 --
 kernel/time/tick-sched.c  |    4 ----
 kernel/time/timekeeping.c |    4 ++--
 3 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/time/tick-common.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-common.c
+++ linux-2.6/kernel/time/tick-common.c
@@ -64,13 +64,11 @@ static void tick_periodic(int cpu)
 {
 	if (tick_do_timer_cpu == cpu) {
 		raw_spin_lock(&xtime_lock);
-		write_seqcount_begin(&xtime_seq);
 
 		/* Keep track of the next tick event */
 		tick_next_period = ktime_add(tick_next_period, tick_period);
 
 		do_timer(1);
-		write_seqcount_end(&xtime_seq);
 		raw_spin_unlock(&xtime_lock);
 	}
 
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -57,7 +57,6 @@ static void tick_do_update_jiffies64(kti
 
 	/* Reevalute with xtime_lock held */
 	raw_spin_lock(&xtime_lock);
-	write_seqcount_begin(&xtime_seq);
 
 	delta = ktime_sub(now, last_jiffies_update);
 	if (delta.tv64 >= tick_period.tv64) {
@@ -80,7 +79,6 @@ static void tick_do_update_jiffies64(kti
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
-	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock(&xtime_lock);
 }
 
@@ -92,12 +90,10 @@ static ktime_t tick_init_jiffy_update(vo
 	ktime_t period;
 
 	raw_spin_lock(&xtime_lock);
-	write_seqcount_begin(&xtime_seq);
 	/* Did we start the jiffies update yet ? */
 	if (last_jiffies_update.tv64 == 0)
 		last_jiffies_update = tick_next_period;
 	period = last_jiffies_update;
-	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock(&xtime_lock);
 	return period;
 }
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -1116,8 +1116,10 @@ struct timespec get_monotonic_coarse(voi
  */
 void do_timer(unsigned long ticks)
 {
+	write_seqcount_begin(&xtime_seq);
 	jiffies_64 += ticks;
 	update_wall_time();
+	write_seqcount_end(&xtime_seq);
 	calc_global_load(ticks);
 }
 
@@ -1165,8 +1167,6 @@ ktime_t ktime_get_monotonic_offset(void)
 void xtime_update(unsigned long ticks)
 {
 	raw_spin_lock(&xtime_lock);
-	write_seqcount_begin(&xtime_seq);
 	do_timer(ticks);
-	write_seqcount_end(&xtime_seq);
 	raw_spin_unlock(&xtime_lock);
 }


