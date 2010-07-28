Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0G1CGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 22:06:48 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58218 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab0G1CGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 22:06:44 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>
Subject: [RFC][PATCH 1/2] Remove stop_machine from change_clocksource
Date: Tue, 27 Jul 2010 19:06:41 -0700
Message-Id: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To me, there isn't a clear reason why we're using stop_machine
when changing clocksources instead of just taking the xtime_lock.

Additionally, using stop_machine limits us from being able to
register clocksources from timers (as needed for a following
patch).

This patch simply removes the stop_machine usage and instead
directly calls change_clocksource, which now takes the xtime_lock.

I could be totally missing something here that necessitates
stop_machine, but in my testing it seems to function fine.

Any clarifications or corrections would be appreciated!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Clark Williams <williams@redhat.com>
---
 kernel/time/timekeeping.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e14c839..fa2cc41 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -19,7 +19,6 @@
 #include <linux/jiffies.h>
 #include <linux/time.h>
 #include <linux/tick.h>
-#include <linux/stop_machine.h>
 
 /* Structure holding internal timekeeping values. */
 struct timekeeper {
@@ -345,12 +344,12 @@ EXPORT_SYMBOL(do_settimeofday);
  *
  * Accumulates current time interval and initializes new clocksource
  */
-static int change_clocksource(void *data)
+static int change_clocksource(struct clocksource *new)
 {
-	struct clocksource *new, *old;
-
-	new = (struct clocksource *) data;
+	struct clocksource *old;
+	unsigned long flags;
 
+	write_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_forward_now();
 	if (!new->enable || new->enable(new) == 0) {
 		old = timekeeper.clock;
@@ -358,6 +357,7 @@ static int change_clocksource(void *data)
 		if (old->disable)
 			old->disable(old);
 	}
+	write_sequnlock_irqrestore(&xtime_lock, flags);
 	return 0;
 }
 
@@ -372,7 +372,7 @@ void timekeeping_notify(struct clocksource *clock)
 {
 	if (timekeeper.clock == clock)
 		return;
-	stop_machine(change_clocksource, clock, NULL);
+	change_clocksource(clock);
 	tick_clock_notify();
 }
 
-- 
1.6.0.4

