Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab2EYWJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:09:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:40154 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114Ab2EYWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:09:00 -0400
Message-Id: <20120525214819.317535385@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 25 May 2012 22:08:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [patch 4/4] timers: Improve get_next_timer_interrupt()
References: <20120525214617.051888729@linutronix.de>
Content-Disposition: inline; filename=timers-fix-get-next-interrupt.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gilad reported at

 http://lkml.kernel.org/r/1336056962-10465-2-git-send-email-gilad@benyossef.com

"Current timer code fails to correctly return a value meaning that
 there is no future timer event, with the result that the timer keeps
 getting re-armed in HZ one shot mode even when we could turn it off,
 generating unneeded interrupts.

 What is happening is that when __next_timer_interrupt() wishes
 to return a value that signifies "there is no future timer
 event", it returns (base->timer_jiffies + NEXT_TIMER_MAX_DELTA).

 However, the code in tick_nohz_stop_sched_tick(), which called
 __next_timer_interrupt() via get_next_timer_interrupt(),
 compares the return value to (last_jiffies + NEXT_TIMER_MAX_DELTA)
 to see if the timer needs to be re-armed.

 base->timer_jiffies != last_jiffies and so tick_nohz_stop_sched_tick()
 interperts the return value as indication that there is a distant
 future event 12 days from now and programs the timer to fire next
 after KTIME_MAX nsecs instead of avoiding to arm it. This ends up
 causing a needless interrupt once every KTIME_MAX nsecs."

Fix this by using the new active timer accounting. This avoids scans
when no active timer is enqueued completely, so we don't have to rely
on base->timer_next and base->timer_jiffies anymore.

Reported-by: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: tip/kernel/timer.c
===================================================================
--- tip.orig/kernel/timer.c
+++ tip/kernel/timer.c
@@ -1326,18 +1326,21 @@ static unsigned long cmp_next_hrtimer_ev
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
 	struct tvec_base *base = __this_cpu_read(tvec_bases);
-	unsigned long expires;
+	unsigned long expires = now + NEXT_TIMER_MAX_DELTA;
 
 	/*
 	 * Pretend that there is no timer pending if the cpu is offline.
 	 * Possible pending timers will be migrated later to an active cpu.
 	 */
 	if (cpu_is_offline(smp_processor_id()))
-		return now + NEXT_TIMER_MAX_DELTA;
+		return expires;
+
 	spin_lock(&base->lock);
-	if (time_before_eq(base->next_timer, base->timer_jiffies))
-		base->next_timer = __next_timer_interrupt(base);
-	expires = base->next_timer;
+	if (base->active_timers) {
+		if (time_before_eq(base->next_timer, base->timer_jiffies))
+			base->next_timer = __next_timer_interrupt(base);
+		expires = base->next_timer;
+	}
 	spin_unlock(&base->lock);
 
 	if (time_before_eq(expires, now))


