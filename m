Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1BAJVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:21:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52406 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1BAJVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=RugQRNDiclCNZZTXonYnVFo7T/n01jW123DBA2u8lTyMMyqNvenjQW4HRZlvxz19sq
         JID8tXOol8SSZUtTM4C7gMmX8fFCbtLkKGaPbaRq710/EE//Q1CYmrfYG69d/8DHOtmW
         0ChWdNbHntYp/nFlpMWebYCs4Kp+j+uSXCUpk=
Date: Tue, 1 Feb 2011 01:21:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Duncan Laurie <dlaurie@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: serio - clear serio event queue after sysfs
 driver rebind
Message-ID: <20110201092126.GC17706@core.coreip.homeip.net>
References: <1290467390-25302-1-git-send-email-dlaurie@chromium.org>
 <20101127084153.GC28745@core.coreip.homeip.net>
 <AANLkTik1TE9zgKaiLQZ=1uFgMyZt43xp8VJBWfxdVyMY@mail.gmail.com>
 <20101208051211.GB4140@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101208051211.GB4140@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 09:12:11PM -0800, Dmitry Torokhov wrote:
> On Mon, Nov 29, 2010 at 01:37:35PM -0800, Duncan Laurie wrote:
> > On Sat, Nov 27, 2010 at 12:41 AM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > > Hi Duncan,
> > >
> > > On Mon, Nov 22, 2010 at 03:09:50PM -0800, Duncan Laurie wrote:
> > >> When rebinding a serio driver via sysfs drvctl interface it is possible for
> > >> an interrupt to trigger after the disconnect of the existing driver and
> > >> before the binding of the new driver.  This will cause the serio interrupt
> > >> handler to queue a rescan event which will disconnect the new driver
> > >> immediately after it is attached.
> > >>
> > >> This change clears the serio event queue after processing the drvctl
> > >> request but before releasing the serio mutex, which will clear any queued
> > >> rescans before they can get processed.
> > >>
> > >> Reproduction involves issuing a rebind of device port from psmouse driver
> > >> to serio_raw driver while generating input to trigger interrupts.  Then
> > >> checking to see if the corresponding i8042/serio4/driver is correctly
> > >> attached to the serio_raw driver instead of psmouse.
> > >>
> > >> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> > >> ---
> > >>  drivers/input/serio/serio.c |    1 +
> > >>  1 files changed, 1 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
> > >> index 405bf21..a66307e 100644
> > >> --- a/drivers/input/serio/serio.c
> > >> +++ b/drivers/input/serio/serio.c
> > >> @@ -454,6 +454,7 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
> > >>               serio_disconnect_port(serio);
> > >>               error = serio_bind_driver(serio, to_serio_driver(drv));
> > >>               put_driver(drv);
> > >> +             serio_remove_pending_events(serio);
> > >
> > > Hmm, makes sense, although should we limit events being removed to
> > > rescan events only?
> > >
> > 
> > 
> > That seems reasonable.  It would mean adding a new function or a
> > parameter to the existing serio_remove_pending_events function, do you
> > have a preference?
> > 
> 
> I wonder if a boolean parameter (rescan_only) would not be the best
> option.
> 

Hi Duncan,

I eneded up with the following patch, could you please try and see if
it still works for you? 

Thanks.

-- 
Dmitry

Input: serio - clear pending rescans after sysfs driver rebind

From: Duncan Laurie <dlaurie@chromium.org>

When rebinding a serio driver via sysfs drvctl interface it is
possible for an interrupt to trigger after the disconnect of the
existing driver and before the binding of the new driver.  This will
cause the serio interrupt handler to queue a rescan event which will
disconnect the new driver immediately after it is attached.

This change removes pending rescans from the serio event queue after
processing the drvctl request but before releasing the serio mutex.

Reproduction involves issuing a rebind of device port from psmouse
driver to serio_raw driver while generating input to trigger
interrupts.  Then checking to see if the corresponding
i8042/serio4/driver is correctly attached to the serio_raw driver
instead of psmouse.

Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/serio.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index db5b0bc..7c38d1f 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -188,7 +188,8 @@ static void serio_free_event(struct serio_event *event)
 	kfree(event);
 }
 
-static void serio_remove_duplicate_events(struct serio_event *event)
+static void serio_remove_duplicate_events(void *object,
+					  enum serio_event_type type)
 {
 	struct serio_event *e, *next;
 	unsigned long flags;
@@ -196,13 +197,13 @@ static void serio_remove_duplicate_events(struct serio_event *event)
 	spin_lock_irqsave(&serio_event_lock, flags);
 
 	list_for_each_entry_safe(e, next, &serio_event_list, node) {
-		if (event->object == e->object) {
+		if (object == e->object) {
 			/*
 			 * If this event is of different type we should not
 			 * look further - we only suppress duplicate events
 			 * that were sent back-to-back.
 			 */
-			if (event->type != e->type)
+			if (type != e->type)
 				break;
 
 			list_del_init(&e->node);
@@ -245,7 +246,7 @@ static void serio_handle_event(struct work_struct *work)
 			break;
 		}
 
-		serio_remove_duplicate_events(event);
+		serio_remove_duplicate_events(event->object, event->type);
 		serio_free_event(event);
 	}
 
@@ -436,10 +437,12 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
 	} else if (!strncmp(buf, "rescan", count)) {
 		serio_disconnect_port(serio);
 		serio_find_driver(serio);
+		serio_remove_duplicate_events(serio, SERIO_RESCAN_PORT);
 	} else if ((drv = driver_find(buf, &serio_bus)) != NULL) {
 		serio_disconnect_port(serio);
 		error = serio_bind_driver(serio, to_serio_driver(drv));
 		put_driver(drv);
+		serio_remove_duplicate_events(serio, SERIO_RESCAN_PORT);
 	} else {
 		error = -EINVAL;
 	}
