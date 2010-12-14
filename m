Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728Ab0LNT65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 14:58:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab0LNT64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 14:58:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC][PATCH 2/4] PM: Remove redundant checks from core device resume routines
Date: Tue, 14 Dec 2010 20:58:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012130128.31243.rjw@sisk.pl> <AANLkTi=UVOQb15EdpfSeD+Qh8x779pJpsSCTyGvf-gxG@mail.gmail.com> <AANLkTim+UoR+GeEK8T1_jgie3gwq6Pdt_=sRiSf8qx6K@mail.gmail.com>
In-Reply-To: <AANLkTim+UoR+GeEK8T1_jgie3gwq6Pdt_=sRiSf8qx6K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012142058.04469.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 14, 2010, Ming Lei wrote:
> 2010/12/13 Linus Torvalds <torvalds@linux-foundation.org>:
> > So I really like this series not only because it implements what I
> > suggested, but also because each patch seems to remove more lines than
> > it adds. That's always nice, and much too unusual.
> >
> > But in this one, I really think you should simplify/clarify things further:
> >
> > On Sun, Dec 12, 2010 at 4:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >> +++ linux-2.6/drivers/base/power/main.c
> >> @@ -485,20 +485,17 @@ void dpm_resume_noirq(pm_message_t state
> >>        transition_started = false;
> >>        while (!list_empty(&dpm_noirq_list)) {
> >>                struct device *dev = to_device(dpm_noirq_list.next);
> >> +               int error;
> >>
> >>                get_device(dev);
> >> -               if (dev->power.status > DPM_OFF) {
> >> -                       int error;
> >> -
> >> -                       dev->power.status = DPM_OFF;
> >> -                       mutex_unlock(&dpm_list_mtx);
> >> +               dev->power.status = DPM_OFF;
> >> +               mutex_unlock(&dpm_list_mtx);
> >
> > I think you should move the device to the dpm_suspended list _here_,
> > before dropping the mutex. That way the power.status thing matches the
> > list.
> >
> > So then you'd just remove the crazy conditional "if it's still on a
> > list, move it to the right list" thing, and these two lines:
> >
> >>                if (!list_empty(&dev->power.entry))
> >>                        list_move_tail(&dev->power.entry, &dpm_suspended_list);
> >
> > Would just be that plain
> >
> >        list_move_tail(&dev->power.entry, &dpm_suspended_list);
> >
> > before you even drop the lock. That look much simpler, and the list
> > movement seems a lot more obvious, no?
> >
> > If an unregister event (or whatever) happens while you had the mutex
> > unlocked, it will just remove it from the new list (the one that
> > matches the power state). So no need for that whole complexity with
> > "what happens with the list if somebody removed the device while we
> > were busy suspending/resuming it".
> >
> > Or am I missing something?
> >
> > (And same comment for that other identical case in dpm_complete())
> 
> Seems it may apply in other cases(dpm_prepare/dpm_suspend
> /dpm_suspend_noirq) too?

I thought about that, but in these cases the status is changed after the
callback has returned and only if it's succeeded.  Moreover, if the callback
hasn't been successful, the device is not moved to the new list, so I think
it's better to leave that as is.

Thanks,
Rafael
