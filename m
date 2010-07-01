Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0GAUKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:10:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0GAUJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:09:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update] Re: [PATCH] PM: Make it possible to avoid wakeup events from being lost
Date: Thu, 1 Jul 2010 22:08:11 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <Pine.LNX.4.44L0.1007010953060.1596-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1007010953060.1596-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007012208.11464.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 01, 2010, Alan Stern wrote:
> On Thu, 1 Jul 2010, Rafael J. Wysocki wrote:
> 
> > I invented a slightly different version in the meantime, which is appended
> > as a patch on top of the original one (I don't want to modify the original
> > patch, since it's been reviewed already by several people and went to my
> > linux-next branch).
> 
> >  /**
> > - * pm_wakeup_work_fn - Deferred closing of a wakeup event.
> > + * pm_wakeup_timer_fn - Deferred closing of a wakeup event.
> >   *
> >   * Execute pm_relax() for a wakeup event detected in the past and free the
> >   * work item object used for queuing up the work.
> >   */
> > -static void pm_wakeup_work_fn(struct work_struct *work)
> > +static void pm_wakeup_timer_fn(unsigned long data)
> >  {
> > -	struct delayed_work *dwork = to_delayed_work(work);
> > +	unsigned long flags;
> >  
> > -	pm_relax();
> > -	kfree(dwork);
> > +	spin_lock_irqsave(&events_lock, flags);
> > +	if (events_timer_expires && time_after(jiffies, events_timer_expires)) {
> 
> Should be time_after_eq.

Yes, it should.

> > +		events_in_progress -= delayed_count;
> > +		event_count += delayed_count;
> > +		delayed_count = 0;
> > +		events_timer_expires = 0;
> > +	}
> > +	spin_unlock_irqrestore(&events_lock, flags);
> >  }
> >  
> >  /**
> > @@ -132,19 +145,31 @@ static void pm_wakeup_work_fn(struct wor
> >  void pm_wakeup_event(struct device *dev, unsigned int msec)
> >  {
> >  	unsigned long flags;
> > -	struct delayed_work *dwork;
> > -
> > -	dwork = msec ? kzalloc(sizeof(*dwork), GFP_ATOMIC) : NULL;
> >  
> >  	spin_lock_irqsave(&events_lock, flags);
> >  	if (dev)
> >  		dev->power.wakeup_count++;
> >  
> > -	if (dwork) {
> > -		INIT_DELAYED_WORK(dwork, pm_wakeup_work_fn);
> > -		schedule_delayed_work(dwork, msecs_to_jiffies(msec));
> > +	if (msec) {
> > +		ktime_t kt;
> > +		struct timespec ts;
> > +		unsigned long expires;
> > +
> > +		kt = ktime_get();
> > +		kt = ktime_add_ns(kt, msec * NSEC_PER_MSEC);
> > +		ts = ktime_to_timespec(kt);
> > +		expires = timespec_to_jiffies(&ts);
> 
> Is this somehow better than jiffies + msecs_to_jiffies(msec)?

I'm not sure about overflows.  That said, the "+" version is used in many
places, so there's no problem I think.

> > +		if (!expires)
> > +			expires = 1;
> > +
> > +		if (!events_timer_expires
> > +		    || time_after(expires, events_timer_expires)) {
> > +			mod_timer(&events_timer, expires);
> > +			events_timer_expires = expires;
> > +		}
> >  
> >  		events_in_progress++;
> > +		delayed_count++;
> >  	} else {
> >  		event_count++;
> >  	}

I think your version is better for a few reasons, so I created the appended
patch.

Rafael

---
Subject: PM: Do not use dynamically allocated objects in pm_wakeup_event()

Originally, pm_wakeup_event() uses struct delayed_work objects,
allocated with GFP_ATOMIC, to schedule the execution of pm_relax()
in future.  However, as noted by Alan Stern, it is not necessary to
do that, because all pm_wakeup_event() calls can use one static timer
that will always be set to expire at the latest time passed to
pm_wakeup_event().

The modifications are based on the example code posted by Alan.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   57 +++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/ktime.h>
 #include <linux/capability.h>
 #include <linux/suspend.h>
 #include <linux/pm.h>
@@ -28,6 +29,11 @@ static unsigned long events_in_progress;
 
 static DEFINE_SPINLOCK(events_lock);
 
+static void pm_wakeup_timer_fn(unsigned long data);
+
+static DEFINE_TIMER(events_timer, pm_wakeup_timer_fn, 0, 0);
+static unsigned long events_timer_expires;
+
 /*
  * The functions below use the observation that each wakeup event starts a
  * period in which the system should not be suspended.  The moment this period
@@ -103,17 +109,22 @@ void pm_relax(void)
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
@@ -123,30 +134,38 @@ static void pm_wakeup_work_fn(struct wor
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
