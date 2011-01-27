Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1A0VT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:19:56 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:50595 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752626Ab1A0VTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:19:55 -0500
From: "Rafael J. Wysocki" <rjw@novell.com>
Organization: Novell Inc.
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] PM / Wakeup: Add missing memory barriers
Date: Thu, 27 Jan 2011 22:19:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1101271335480.2090-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101271335480.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101272219.54303.rjw@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 27, 2011, Alan Stern wrote:
> On Wed, 26 Jan 2011, Rafael J. Wysocki wrote:
> 
> > > Ideally you could do away with the need for synchronization entirely.  
> > > For example, events_in_progress and event_count could be stored as two 
> > > 16-bit values stuffed into a single atomic variable.  Then they could 
> > > both be read or updated simultaneously.
> > 
> > OK, the patch below appears to work for me.  Can you have a look at it, please?
> > 
> > Rafael
> > 
> > 
> > ---
> >  drivers/base/power/wakeup.c |   82 +++++++++++++++++++++++++++++++-------------
> >  1 file changed, 58 insertions(+), 24 deletions(-)
> > 
> > Index: linux-2.6/drivers/base/power/wakeup.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/wakeup.c
> > +++ linux-2.6/drivers/base/power/wakeup.c
> > @@ -24,12 +24,48 @@
> >   */
> >  bool events_check_enabled;
> >  
> > -/* The counter of registered wakeup events. */
> > -static atomic_t event_count = ATOMIC_INIT(0);
> > -/* A preserved old value of event_count. */
> > +#define EVENT_COUNT_BITS	(sizeof(atomic_t) * 4)
> 
> This should be sizeof(int), since atomic_t variables store int values.  
> In principle, the atomic_t might include other things along with the 
> stored value (it used to, on some architectures).

OK

> > +#define MAX_EVENT_COUNT		((1 << EVENT_COUNT_BITS) - 1)
> > +
> > +/* Combined counters of registered wakeup events and events in progress. */
> > +static atomic_t combined_event_count = ATOMIC_INIT(0);
> > +
> 
> Comment here, explaining that this is needed so that the in_progress 
> and count parts can be operated on simultaneously.

OK

> > +static unsigned int split_counters(unsigned int *inpr, unsigned int *cnt)
> > +{
> > +	unsigned int comb = atomic_read(&combined_event_count);
> > +
> > +	*inpr = (comb >> EVENT_COUNT_BITS);
> > +	*cnt = comb & MAX_EVENT_COUNT;
> 
> The inpr part is bounded, whereas the cnt part increments without 
> limit.  Therefore inpr should occupy the lower bits and cnt should 
> occupy the upper bits, where overflow isn't an issue.

Well, it wouldn't matter if merge_counters() weren't buggy (cnt should have
been masked before applying the | in there).  Plus the simplifications below
require inpr to be the lower bits, right?

> > +	return comb;
> > +}
> > +
> > +static unsigned int merge_counters(unsigned int inpr, unsigned int cnt)
> > +{
> > +	return (inpr << EVENT_COUNT_BITS) | cnt;
> > +}
> > +
> > +static void update_events_in_progress(void)
> > +{
> > +	unsigned int cnt, inpr, old, new;
> > +
> > +	do {
> > +		old = split_counters(&inpr, &cnt);
> > +		new = merge_counters(inpr + 1, cnt);
> > +	} while (atomic_cmpxchg(&combined_event_count, old, new) != old);
> > +}
> 
> Just atomic_inc(&combined_event_count) -- after inpr has been moved to 
> the lower bits.

OK

> > +
> > +static void update_counters(void)
> > +{
> > +	unsigned int cnt, inpr, old, new;
> > +
> > +	do {
> > +		old = split_counters(&inpr, &cnt);
> > +		new = merge_counters(inpr - 1, cnt + 1);
> > +	} while (atomic_cmpxchg(&combined_event_count, old, new) != old);
> > +}
> 
> Just atomic_add(MAX_EVENT_COUNT, &combined_event_count).

Right.

> The rest looks fine.

OK

Updated patch is appended.

Thanks,
Rafael

---
 drivers/base/power/wakeup.c |   61 ++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -24,12 +24,26 @@
  */
 bool events_check_enabled;
 
-/* The counter of registered wakeup events. */
-static atomic_t event_count = ATOMIC_INIT(0);
-/* A preserved old value of event_count. */
+/*
+ * Combined counters of registered wakeup events and wakeup events in progress.
+ * They need to be modified together atomically, so it's better to use one
+ * atomic variable to hold them both.
+ */
+static atomic_t combined_event_count = ATOMIC_INIT(0);
+
+#define IN_PROGRESS_BITS	(sizeof(int) * 4)
+#define MAX_IN_PROGRESS		((1 << IN_PROGRESS_BITS) - 1)
+
+static void split_counters(unsigned int *cnt, unsigned int *inpr)
+{
+	unsigned int comb = atomic_read(&combined_event_count);
+
+	*cnt = (comb >> IN_PROGRESS_BITS);
+	*inpr = comb & MAX_IN_PROGRESS;
+}
+
+/* A preserved old value of the events counter. */
 static unsigned int saved_count;
-/* The counter of wakeup events being processed. */
-static atomic_t events_in_progress = ATOMIC_INIT(0);
 
 static DEFINE_SPINLOCK(events_lock);
 
@@ -333,7 +347,8 @@ static void wakeup_source_activate(struc
 	ws->timer_expires = jiffies;
 	ws->last_time = ktime_get();
 
-	atomic_inc(&events_in_progress);
+	/* Increment the counter of events in progress. */
+	atomic_inc(&combined_event_count);
 }
 
 /**
@@ -420,14 +435,10 @@ static void wakeup_source_deactivate(str
 	del_timer(&ws->timer);
 
 	/*
-	 * event_count has to be incremented before events_in_progress is
-	 * modified, so that the callers of pm_check_wakeup_events() and
-	 * pm_save_wakeup_count() don't see the old value of event_count and
-	 * events_in_progress equal to zero at the same time.
+	 * Increment the counter of registered wakeup events and decrement the
+	 * couter of wakeup events in progress simultaneously.
 	 */
-	atomic_inc(&event_count);
-	smp_mb__before_atomic_dec();
-	atomic_dec(&events_in_progress);
+	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
 }
 
 /**
@@ -582,8 +593,10 @@ bool pm_wakeup_pending(void)
 
 	spin_lock_irqsave(&events_lock, flags);
 	if (events_check_enabled) {
-		ret = ((unsigned int)atomic_read(&event_count) != saved_count)
-			|| atomic_read(&events_in_progress);
+		unsigned int cnt, inpr;
+
+		split_counters(&cnt, &inpr);
+		ret = (cnt != saved_count || inpr > 0);
 		events_check_enabled = !ret;
 	}
 	spin_unlock_irqrestore(&events_lock, flags);
@@ -605,19 +618,22 @@ bool pm_wakeup_pending(void)
  */
 bool pm_get_wakeup_count(unsigned int *count)
 {
-	bool ret;
+	unsigned int cnt, inpr;
 
 	if (capable(CAP_SYS_ADMIN))
 		events_check_enabled = false;
 
-	while (atomic_read(&events_in_progress) && !signal_pending(current)) {
+	for (;;) {
+		split_counters(&cnt, &inpr);
+		if (inpr == 0 || signal_pending(current))
+			break;
 		pm_wakeup_update_hit_counts();
 		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
 	}
 
-	ret = !atomic_read(&events_in_progress);
-	*count = atomic_read(&event_count);
-	return ret;
+	split_counters(&cnt, &inpr);
+	*count = cnt;
+	return !inpr;
 }
 
 /**
@@ -631,11 +647,12 @@ bool pm_get_wakeup_count(unsigned int *c
  */
 bool pm_save_wakeup_count(unsigned int count)
 {
+	unsigned int cnt, inpr;
 	bool ret = false;
 
 	spin_lock_irq(&events_lock);
-	if (count == (unsigned int)atomic_read(&event_count)
-	    && !atomic_read(&events_in_progress)) {
+	split_counters(&cnt, &inpr);
+	if (cnt == count && inpr == 0) {
 		saved_count = count;
 		events_check_enabled = true;
 		ret = true;
