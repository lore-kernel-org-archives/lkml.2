Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab1FFTKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:10:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:37470 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab1FFTKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:10:19 -0400
Date: Mon, 6 Jun 2011 21:10:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer fixes
Message-ID: <alpine.LFD.2.02.1106062109360.13964@ionos>
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

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Sebastian Andrzej Siewior (1):
      timers: Consider slack value in mod_timer()

Thomas Gleixner (1):
      clockevents: Handle empty cpumask gracefully


 kernel/time/clockevents.c |    5 ++++-
 kernel/timer.c            |   15 +++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index c027d4f..e4c699d 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -182,7 +182,10 @@ void clockevents_register_device(struct clock_event_device *dev)
 	unsigned long flags;
 
 	BUG_ON(dev->mode != CLOCK_EVT_MODE_UNUSED);
-	BUG_ON(!dev->cpumask);
+	if (!dev->cpumask) {
+		WARN_ON(num_possible_cpus() > 1);
+		dev->cpumask = cpumask_of(smp_processor_id());
+	}
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index fd61986..8cff361 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -749,16 +749,15 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
 	unsigned long expires_limit, mask;
 	int bit;
 
-	expires_limit = expires;
-
 	if (timer->slack >= 0) {
 		expires_limit = expires + timer->slack;
 	} else {
-		unsigned long now = jiffies;
+		long delta = expires - jiffies;
+
+		if (delta < 256)
+			return expires;
 
-		/* No slack, if already expired else auto slack 0.4% */
-		if (time_after(expires, now))
-			expires_limit = expires + (expires - now)/256;
+		expires_limit = expires + delta / 256;
 	}
 	mask = expires ^ expires_limit;
 	if (mask == 0)
@@ -795,6 +794,8 @@ unsigned long apply_slack(struct timer_list *timer, unsigned long expires)
  */
 int mod_timer(struct timer_list *timer, unsigned long expires)
 {
+	expires = apply_slack(timer, expires);
+
 	/*
 	 * This is a common optimization triggered by the
 	 * networking code - if the timer is re-modified
@@ -803,8 +804,6 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
 	if (timer_pending(timer) && timer->expires == expires)
 		return 1;
 
-	expires = apply_slack(timer, expires);
-
 	return __mod_timer(timer, expires, false, TIMER_NOT_PINNED);
 }
 EXPORT_SYMBOL(mod_timer);
