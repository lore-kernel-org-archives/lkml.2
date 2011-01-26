Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1AZXNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:13:32 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:52937 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753608Ab1AZXNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:13:23 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2011 18:13:23 EST
From: "Rafael J. Wysocki" <rjw@novell.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] PM / Wakeup: Add missing memory barriers
Date: Wed, 26 Jan 2011 23:53:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1101261514280.1879-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101261514280.1879-100000@iolanthe.rowland.org>
Organization: Novell Inc.
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101262353.21043.rjw@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 26, 2011, Alan Stern wrote:
> On Tue, 25 Jan 2011, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The memory barrier in wakeup_source_deactivate() is supposed to
> > prevent the callers of pm_wakeup_pending() and pm_get_wakeup_count()
> > from seeing the new value of events_in_progress (0, in particular)
> > and the old value of event_count at the same time.  However, if
> > wakeup_source_deactivate() is executed by CPU0 and, for instance,
> > pm_wakeup_pending() is executed by CPU1, where both processors can
> > reorder operations, the memory barrier in wakeup_source_deactivate()
> > doesn't affect CPU1 which can reorder reads.  In that case CPU1 may
> > very well decide to fetch event_count before it's modified and
> > events_in_progress after it's been updated, so pm_wakeup_pending()
> > may fail to detect a wakeup event.  This issue can be addressed by
> > adding a read memory barrier in pm_wakeup_pending() that will enforce
> > events_in_progress to be read before event_count.
> > 
> > For similar reason, a read memory barrier should be added to
> > pm_get_wakeup_count().
> 
> How come this is implemented using memory barriers rather than a lock?  
> Is it because this is potentially a fairly hot path?
> 
> New memory barriers are supposed to have comments present in the code, 
> explaining why they are needed.
> 
> Ideally you could do away with the need for synchronization entirely.  
> For example, events_in_progress and event_count could be stored as two 
> 16-bit values stuffed into a single atomic variable.  Then they could 
> both be read or updated simultaneously.

OK, the patch below appears to work for me.  Can you have a look at it, please?

Rafael


---
 drivers/base/power/wakeup.c |   82 +++++++++++++++++++++++++++++++-------------
 1 file changed, 58 insertions(+), 24 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -24,12 +24,48 @@
  */
 bool events_check_enabled;
 
-/* The counter of registered wakeup events. */
-static atomic_t event_count = ATOMIC_INIT(0);
-/* A preserved old value of event_count. */
+#define EVENT_COUNT_BITS	(sizeof(atomic_t) * 4)
+#define MAX_EVENT_COUNT		((1 << EVENT_COUNT_BITS) - 1)
+
+/* Combined counters of registered wakeup events and events in progress. */
+static atomic_t combined_event_count = ATOMIC_INIT(0);
+
+static unsigned int split_counters(unsigned int *inpr, unsigned int *cnt)
+{
+	unsigned int comb = atomic_read(&combined_event_count);
+
+	*inpr = (comb >> EVENT_COUNT_BITS);
+	*cnt = comb & MAX_EVENT_COUNT;
+	return comb;
+}
+
+static unsigned int merge_counters(unsigned int inpr, unsigned int cnt)
+{
+	return (inpr << EVENT_COUNT_BITS) | cnt;
+}
+
+static void update_events_in_progress(void)
+{
+	unsigned int cnt, inpr, old, new;
+
+	do {
+		old = split_counters(&inpr, &cnt);
+		new = merge_counters(inpr + 1, cnt);
+	} while (atomic_cmpxchg(&combined_event_count, old, new) != old);
+}
+
+static void update_counters(void)
+{
+	unsigned int cnt, inpr, old, new;
+
+	do {
+		old = split_counters(&inpr, &cnt);
+		new = merge_counters(inpr - 1, cnt + 1);
+	} while (atomic_cmpxchg(&combined_event_count, old, new) != old);
+}
+
+/* A preserved old value of event counter. */
 static unsigned int saved_count;
-/* The counter of wakeup events being processed. */
-static atomic_t events_in_progress = ATOMIC_INIT(0);
 
 static DEFINE_SPINLOCK(events_lock);
 
@@ -333,7 +369,7 @@ static void wakeup_source_activate(struc
 	ws->timer_expires = jiffies;
 	ws->last_time = ktime_get();
 
-	atomic_inc(&events_in_progress);
+	update_events_in_progress();
 }
 
 /**
@@ -419,15 +455,7 @@ static void wakeup_source_deactivate(str
 
 	del_timer(&ws->timer);
 
-	/*
-	 * event_count has to be incremented before events_in_progress is
-	 * modified, so that the callers of pm_check_wakeup_events() and
-	 * pm_save_wakeup_count() don't see the old value of event_count and
-	 * events_in_progress equal to zero at the same time.
-	 */
-	atomic_inc(&event_count);
-	smp_mb__before_atomic_dec();
-	atomic_dec(&events_in_progress);
+	update_counters();
 }
 
 /**
@@ -582,8 +610,10 @@ bool pm_wakeup_pending(void)
 
 	spin_lock_irqsave(&events_lock, flags);
 	if (events_check_enabled) {
-		ret = ((unsigned int)atomic_read(&event_count) != saved_count)
-			|| atomic_read(&events_in_progress);
+		unsigned int inpr, cnt;
+
+		split_counters(&inpr, &cnt);
+		ret = (cnt != saved_count || inpr > 0);
 		events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
@@ -605,19 +635,22 @@ bool pm_wakeup_pending(void)
  */
 bool pm_get_wakeup_count(unsigned int *count)
 {
-	bool ret;
+	unsigned int inpr, cnt;
 
 	if (capable(CAP_SYS_ADMIN))
 		events_check_enabled = false;
 
-	while (atomic_read(&events_in_progress) && !signal_pending(current)) {
+	for (;;) {
+		split_counters(&inpr, &cnt);
+		if (inpr == 0 || signal_pending(current))
+			break;
 		pm_wakeup_update_hit_counts();
 		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
 	}
 
-	ret = !atomic_read(&events_in_progress);
-	*count = atomic_read(&event_count);
-	return ret;
+	split_counters(&inpr, &cnt);
+	*count = cnt;
+	return !inpr;
 }
 
 /**
@@ -631,11 +664,12 @@ bool pm_get_wakeup_count(unsigned int *c
  */
 bool pm_save_wakeup_count(unsigned int count)
 {
+	unsigned int inpr, cnt;
 	bool ret = false;
 
 	spin_lock_irq(&events_lock);
-	if (count == (unsigned int)atomic_read(&event_count)
-	    && !atomic_read(&events_in_progress)) {
+	split_counters(&inpr, &cnt);
+	if (cnt == count && inpr == 0) {
 		saved_count = count;
 		events_check_enabled = true;
 		ret = true;
