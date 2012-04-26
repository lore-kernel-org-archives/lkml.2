Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2DZJXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:23:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:43969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab2DZJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:23:08 -0400
Date: Thu, 26 Apr 2012 11:23:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 3.4
Message-ID: <alpine.LFD.2.02.1204261121560.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Thanks,

	tglx

------------------>
Suresh Siddha (1):
      tick: Fix the spurious broadcast timer ticks after resume

Thomas Gleixner (2):
      tick: Fix oneshot broadcast setup really
      tick: Ensure that the broadcast device is initialized


 kernel/time/tick-broadcast.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bf57abd..f113755 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -346,7 +346,8 @@ int tick_resume_broadcast(void)
 						     tick_get_broadcast_mask());
 			break;
 		case TICKDEV_MODE_ONESHOT:
-			broadcast = tick_resume_broadcast_oneshot(bc);
+			if (!cpumask_empty(tick_get_broadcast_mask()))
+				broadcast = tick_resume_broadcast_oneshot(bc);
 			break;
 		}
 	}
@@ -373,6 +374,9 @@ static int tick_broadcast_set_event(ktime_t expires, int force)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 
+	if (bc->mode != CLOCK_EVT_MODE_ONESHOT)
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
+
 	return clockevents_program_event(bc, expires, force);
 }
 
@@ -531,7 +535,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
 		/* Take the do_timer update */
 		tick_do_timer_cpu = cpu;
@@ -549,6 +552,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			   to_cpumask(tmpmask));
 
 		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(to_cpumask(tmpmask),
 						       tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
@@ -577,15 +581,10 @@ void tick_broadcast_switch_to_oneshot(void)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
-
-	if (cpumask_empty(tick_get_broadcast_mask()))
-		goto end;
-
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
 
-end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
