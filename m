Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2BPWQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:16:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56628 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab2BPWQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:16:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 3/3] PM / Sleep: Make __pm_stay_awake() delete wakeup source timers
Date: Thu, 16 Feb 2012 23:20:44 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201202152318.04206.rjw@sisk.pl> <201202152324.08073.rjw@sisk.pl> <CAMP5Xgctu7ra6XbgNuTo5uP77otboXmSxAaLHj1uJwiH1+ce9g@mail.gmail.com>
In-Reply-To: <CAMP5Xgctu7ra6XbgNuTo5uP77otboXmSxAaLHj1uJwiH1+ce9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202162320.44863.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 16, 2012, Arve Hjønnevåg wrote:
> 2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> ...
> > --- linux.orig/drivers/base/power/wakeup.c
> > +++ linux/drivers/base/power/wakeup.c
> > @@ -365,9 +365,15 @@ void __pm_stay_awake(struct wakeup_sourc
> >                return;
> >
> >        spin_lock_irqsave(&ws->lock, flags);
> > +
> > +       del_timer(&ws->timer);
> > +       ws->timer_expires = 0;
> 
> timer_expires gets overwritten in wakeup_source_activate,

I actually don't remember why it does that and with the $subject changes
it's just pointless.

> so __pm_relax followed by __pm_stay_awake is still not safe.

Yes, I overlooked that timer_expires modification.  Updated patch follows.

> ...
> > @@ -529,8 +535,12 @@ void __pm_wakeup_event(struct wakeup_sou
> >        spin_lock_irqsave(&ws->lock, flags);
> >
> >        ws->event_count++;
> > -       if (!ws->active)
> > +       if (ws->active) {
> > +               if (!ws->timer_expires)
> > +                       goto unlock;
> > +       } else {
> >                wakeup_source_activate(ws);
> > +       }
> >
> >        if (!msec) {
> >                wakeup_source_deactivate(ws);
> >
> 
> I suggest dropping this and adding:

Well, what exactly would you like to drop?  The above proposed changes I guess?

> -       if (time_after(expires, ws->timer_expires)) {
> +       if (!ws->timer_expires || time_after(expires, ws->timer_expires)) {

I've tried to follow your suggestion, so that __pm_wakeup_event() always
sets the timer, if msec is positive, or deactivates the wakeup source, if
msec is 0.  Please let me know if that's what you wanted. :-)

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Sleep: Make __pm_stay_awake() delete wakeup source timers

If __pm_stay_awake() is called after __pm_wakeup_event() for the same
wakep source object before its timer expires, it won't cancel the
timer, so the wakeup source will be deactivated from the timer
function as scheduled by __pm_wakeup_event().  In that case
__pm_stay_awake() doesn't have any effect beyond incrementing
the wakeup source's event_count field, although it should cancel
the timer and make the wakeup source stay active until __pm_relax()
is called for it.

To fix this problem make __pm_stay_awake() delete the wakeup source's
timer and ensure that it won't be deactivated from the timer funtion
afterwards by clearing its timer_expires field.

Reported-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -344,7 +344,6 @@ static void wakeup_source_activate(struc
 {
 	ws->active = true;
 	ws->active_count++;
-	ws->timer_expires = jiffies;
 	ws->last_time = ktime_get();
 
 	/* Increment the counter of events in progress. */
@@ -365,9 +364,14 @@ void __pm_stay_awake(struct wakeup_sourc
 		return;
 
 	spin_lock_irqsave(&ws->lock, flags);
+
 	ws->event_count++;
 	if (!ws->active)
 		wakeup_source_activate(ws);
+
+	del_timer(&ws->timer);
+	ws->timer_expires = 0;
+
 	spin_unlock_irqrestore(&ws->lock, flags);
 }
 EXPORT_SYMBOL_GPL(__pm_stay_awake);
@@ -541,7 +545,7 @@ void __pm_wakeup_event(struct wakeup_sou
 	if (!expires)
 		expires = 1;
 
-	if (time_after(expires, ws->timer_expires)) {
+	if (!ws->timer_expires || time_after(expires, ws->timer_expires)) {
 		mod_timer(&ws->timer, expires);
 		ws->timer_expires = expires;
 	}
