Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab1AYARO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:17:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35821 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1AYARM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:17:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/3] PM / Wakeup: Add missing memory barriers
Date: Tue, 25 Jan 2011 01:14:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201101250112.40350.rjw@sisk.pl>
In-Reply-To: <201101250112.40350.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101250114.17758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The memory barrier in wakeup_source_deactivate() is supposed to
prevent the callers of pm_wakeup_pending() and pm_get_wakeup_count()
from seeing the new value of events_in_progress (0, in particular)
and the old value of event_count at the same time.  However, if
wakeup_source_deactivate() is executed by CPU0 and, for instance,
pm_wakeup_pending() is executed by CPU1, where both processors can
reorder operations, the memory barrier in wakeup_source_deactivate()
doesn't affect CPU1 which can reorder reads.  In that case CPU1 may
very well decide to fetch event_count before it's modified and
events_in_progress after it's been updated, so pm_wakeup_pending()
may fail to detect a wakeup event.  This issue can be addressed by
adding a read memory barrier in pm_wakeup_pending() that will enforce
events_in_progress to be read before event_count.

For similar reason, a read memory barrier should be added to
pm_get_wakeup_count().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -568,12 +568,30 @@ static void pm_wakeup_update_hit_counts(
 }
 
 /**
+ * __pm_wakeup_pending - Check if there are any new wakeup events.
+ * @count: Expected number of wakeup events registered so far.
+ *
+ * Compare the current number of registered wakeup events with @count and return
+ * true if they are different.  Also return true if the current number of wakeup
+ * events being processed is different from zero.
+ */
+static bool __pm_wakeup_pending(unsigned int count)
+{
+	bool in_progress;
+
+	in_progress = !!atomic_read(&events_in_progress);
+	smp_rmb();
+	return in_progress || (unsigned int)atomic_read(&event_count) != count;
+}
+
+/**
  * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
- * Compare the current number of registered wakeup events with its preserved
- * value from the past and return true if new wakeup events have been registered
- * since the old value was stored.  Also return true if the current number of
- * wakeup events being processed is different from zero.
+ * If wakeup events detection is enabled, call __pm_wakeup_pending() for
+ * saved_count (preserved number of registered wakeup events from the past) and
+ * return its result.  If it is 'true' (i.e. new wakeup events have been
+ * registered since the last modification of saved_count), disable wakeup events
+ * detection and update the statistics of all wakeup sources.
  */
 bool pm_wakeup_pending(void)
 {
@@ -582,8 +600,7 @@ bool pm_wakeup_pending(void)
 
 	spin_lock_irqsave(&events_lock, flags);
 	if (events_check_enabled) {
-		ret = ((unsigned int)atomic_read(&event_count) != saved_count)
-			|| atomic_read(&events_in_progress);
+		ret = __pm_wakeup_pending(saved_count);
 		events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
@@ -616,6 +633,7 @@ bool pm_get_wakeup_count(unsigned int *c
 	}
 
 	ret = !atomic_read(&events_in_progress);
+	smp_rmb();
 	*count = atomic_read(&event_count);
 	return ret;
 }
@@ -634,8 +652,7 @@ bool pm_save_wakeup_count(unsigned int c
 	bool ret = false;
 
 	spin_lock_irq(&events_lock);
-	if (count == (unsigned int)atomic_read(&event_count)
-	    && !atomic_read(&events_in_progress)) {
+	if (!__pm_wakeup_pending(count)) {
 		saved_count = count;
 		events_check_enabled = true;
 		ret = true;

