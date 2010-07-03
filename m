Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0GCWSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:18:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49075 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0GCWSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:18:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Do not use dynamically allocated objects in pm_wakeup_event()
Date: Sun, 4 Jul 2010 00:16:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007040016.32605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Originally, pm_wakeup_event() uses struct delayed_work objects,
allocated with GFP_ATOMIC, to schedule the execution of pm_relax()
in future.  However, as noted by Alan Stern, it is not necessary to
do that, because all pm_wakeup_event() calls can use one static timer
that will always be set to expire at the latest time passed to
pm_wakeup_event().

The modifications are based on the example code posted by Alan.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
This is a resend of a previously posted patch with a couple of minor changes.
If there are no objections, I'll put it into suspend-2.6/linux-next shortly.

Rafael
---
 drivers/base/power/wakeup.c |   56 +++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -28,6 +28,11 @@ static unsigned long events_in_progress;
 
 static DEFINE_SPINLOCK(events_lock);
 
+static void pm_wakeup_timer_fn(unsigned long data);
+
+static DEFINE_TIMER(events_timer, pm_wakeup_timer_fn, 0, 0);
+static unsigned long events_timer_expires;
+
 /*
  * The functions below use the observation that each wakeup event starts a
  * period in which the system should not be suspended.  The moment this period
@@ -103,17 +108,22 @@ void pm_relax(void)
 }
 
 /**
- * pm_wakeup_work_fn - Deferred closing of a wakeup event.
+ * pm_wakeup_timer_fn - Delayed finalization of a wakeup event.
  *
- * Execute pm_relax() for a wakeup event detected in the past and free the
- * work item object used for queuing up the work.
+ * Decrease the counter of wakeup events being processed after it was increased
+ * by pm_wakeup_event().
  */
-static void pm_wakeup_work_fn(struct work_struct *work)
+static void pm_wakeup_timer_fn(unsigned long data)
 {
-	struct delayed_work *dwork = to_delayed_work(work);
+	unsigned long flags;
 
-	pm_relax();
-	kfree(dwork);
+	spin_lock_irqsave(&events_lock, flags);
+	if (events_timer_expires
+	    && time_before_eq(events_timer_expires, jiffies)) {
+		events_in_progress--;
+		events_timer_expires = 0;
+	}
+	spin_unlock_irqrestore(&events_lock, flags);
 }
 
 /**
@@ -123,30 +133,38 @@ static void pm_wakeup_work_fn(struct wor
  *
  * Notify the PM core of a wakeup event (signaled by @dev) that will take
  * approximately @msec milliseconds to be processed by the kernel.  Increment
- * the counter of wakeup events being processed and queue up a work item
- * that will execute pm_relax() for the event after @msec milliseconds.  If @dev
- * is not NULL, the counter of wakeup events related to @dev is incremented too.
+ * the counter of registered wakeup events and (if @msec is nonzero) set up
+ * the wakeup events timer to execute pm_wakeup_timer_fn() in future (if the
+ * timer has not been set up already, increment the counter of wakeup events
+ * being processed).  If @dev is not NULL, the counter of wakeup events related
+ * to @dev is incremented too.
  *
  * It is safe to call this function from interrupt context.
  */
 void pm_wakeup_event(struct device *dev, unsigned int msec)
 {
 	unsigned long flags;
-	struct delayed_work *dwork;
-
-	dwork = msec ? kzalloc(sizeof(*dwork), GFP_ATOMIC) : NULL;
 
 	spin_lock_irqsave(&events_lock, flags);
+	event_count++;
 	if (dev)
 		dev->power.wakeup_count++;
 
-	if (dwork) {
-		INIT_DELAYED_WORK(dwork, pm_wakeup_work_fn);
-		schedule_delayed_work(dwork, msecs_to_jiffies(msec));
+	if (msec) {
+		unsigned long expires;
 
-		events_in_progress++;
-	} else {
-		event_count++;
+		expires = jiffies + msecs_to_jiffies(msec);
+		if (!expires)
+			expires = 1;
+
+		if (!events_timer_expires
+		    || time_after(expires, events_timer_expires)) {
+			if (!events_timer_expires)
+				events_in_progress++;
+
+			mod_timer(&events_timer, expires);
+			events_timer_expires = expires;
+		}
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
 }
