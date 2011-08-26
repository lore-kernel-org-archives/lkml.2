Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1HZWc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:32:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:58342 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab1HZWcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,286,1312182000"; 
   d="scan'208";a="42896289"
From: Andi Kleen <andi@firstfloor.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] clockevents: Use an atomic RCU notifier for clockevents
Date: Fri, 26 Aug 2011 15:32:02 -0700
Message-Id: <1314397924-10236-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use an atomic_notifier instead of a raw_notifier for the clockevents
notification.

This avoids a global lock in the idle path, is a scalability
problem. With this patch we don't have a global lock anymore
at least on systems with an always running timer.

Only broadcast_enter/exit actually do use RCU for now.

I kept all the other events under the lock because they are not
on fast paths and it was not fully clear if they are all RCU
safe or not.

Actually an alternative would be to just get rid of the notifier.
As far as I can see it only has a single client anyways. But
right now I kept it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/time/clockevents.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index e4c699d..2ee6bcb 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -25,12 +25,12 @@
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
 
-/* Notification for clock events */
-static RAW_NOTIFIER_HEAD(clockevents_chain);
-
 /* Protection for the above */
 static DEFINE_RAW_SPINLOCK(clockevents_lock);
 
+/* Notification for clock events */
+static ATOMIC_NOTIFIER_HEAD(clockevents_chain);
+
 /**
  * clockevents_delta2ns - Convert a latch value (device ticks) to nanoseconds
  * @latch:	value to convert
@@ -137,23 +137,12 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
  */
 int clockevents_register_notifier(struct notifier_block *nb)
 {
-	unsigned long flags;
-	int ret;
-
-	raw_spin_lock_irqsave(&clockevents_lock, flags);
-	ret = raw_notifier_chain_register(&clockevents_chain, nb);
-	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
-
-	return ret;
+	return atomic_notifier_chain_register(&clockevents_chain, nb);
 }
 
-/*
- * Notify about a clock event change. Called with clockevents_lock
- * held.
- */
 static void clockevents_do_notify(unsigned long reason, void *dev)
 {
-	raw_notifier_call_chain(&clockevents_chain, reason, dev);
+	atomic_notifier_call_chain(&clockevents_chain, reason, dev);
 }
 
 /*
@@ -308,6 +297,14 @@ void clockevents_notify(unsigned long reason, void *arg)
 	unsigned long flags;
 	int cpu;
 
+	/* For idle path events don't take a lock */
+
+	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER ||
+	    reason == CLOCK_EVT_NOTIFY_BROADCAST_EXIT) {
+		clockevents_do_notify(reason, arg);
+		return;
+	}
+
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 	clockevents_do_notify(reason, arg);
 
-- 
1.7.4.4

