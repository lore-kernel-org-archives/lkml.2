Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2BQUnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 15:43:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab2BQUnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 15:43:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 3/3] PM / Sleep: Make __pm_stay_awake() delete wakeup source timers
Date: Fri, 17 Feb 2012 21:46:59 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201202152318.04206.rjw@sisk.pl> <201202162320.44863.rjw@sisk.pl> <CAMP5Xgc5JtqH-PqS9+z1swg9CR5w6Az+_HNyuO9uG9WyGONRaw@mail.gmail.com>
In-Reply-To: <CAMP5Xgc5JtqH-PqS9+z1swg9CR5w6Az+_HNyuO9uG9WyGONRaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202172146.59236.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 17, 2012, Arve Hjønnevåg wrote:
> 2012/2/16 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, February 16, 2012, Arve Hjønnevåg wrote:
> >> 2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> >> ...
> >> > --- linux.orig/drivers/base/power/wakeup.c
> >> > +++ linux/drivers/base/power/wakeup.c
> >> > @@ -365,9 +365,15 @@ void __pm_stay_awake(struct wakeup_sourc
> >> >                return;
> >> >
> >> >        spin_lock_irqsave(&ws->lock, flags);
> >> > +
> >> > +       del_timer(&ws->timer);
> >> > +       ws->timer_expires = 0;
> >>
> >> timer_expires gets overwritten in wakeup_source_activate,
> >
> > I actually don't remember why it does that and with the $subject changes
> > it's just pointless.
> >
> >> so __pm_relax followed by __pm_stay_awake is still not safe.
> >
> > Yes, I overlooked that timer_expires modification.  Updated patch follows.
> >
> >> ...
> >> > @@ -529,8 +535,12 @@ void __pm_wakeup_event(struct wakeup_sou
> >> >        spin_lock_irqsave(&ws->lock, flags);
> >> >
> >> >        ws->event_count++;
> >> > -       if (!ws->active)
> >> > +       if (ws->active) {
> >> > +               if (!ws->timer_expires)
> >> > +                       goto unlock;
> >> > +       } else {
> >> >                wakeup_source_activate(ws);
> >> > +       }
> >> >
> >> >        if (!msec) {
> >> >                wakeup_source_deactivate(ws);
> >> >
> >>
> >> I suggest dropping this and adding:
> >
> > Well, what exactly would you like to drop?  The above proposed changes I guess?
> 
> Yes.
> 
> >
> >> -       if (time_after(expires, ws->timer_expires)) {
> >> +       if (!ws->timer_expires || time_after(expires, ws->timer_expires)) {
> >
> > I've tried to follow your suggestion, so that __pm_wakeup_event() always
> > sets the timer, if msec is positive, or deactivates the wakeup source, if
> > msec is 0.  Please let me know if that's what you wanted. :-)
> >
> 
> Yes. I should be able to replace a wake_lock with a single wakeup_source now.

Good, thanks for the confirmation!

Rafael
