Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab2DZUgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:36:17 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759222Ab2DZUgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:36:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 5/8] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
Date: Thu, 26 Apr 2012 22:40:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201204222322.44278.rjw@sisk.pl> <20120426140324.0357b1a3@notabene.brown>
In-Reply-To: <20120426140324.0357b1a3@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204262240.54135.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 26, 2012, NeilBrown wrote:
> On Sun, 22 Apr 2012 23:22:43 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Arve Hjønnevåg <arve@android.com>
> > 
> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> > wakeup_source will be active to prevent suspend. This can be used to
> > handle wakeup events from a driver that support poll, e.g. input, if
> > that driver wakes up the waitqueue passed to epoll before allowing
> > suspend.
> > 
> > The current implementation uses an extra wakeup_source when
> > ep_scan_ready_list runs. This can cause problems if a single thread
> > is polling on wakeup events and frequent non-wakeup events (events
> > usually arrive during thread freezing) using the same epoll file.
> 
> This is quite neat.
> 
> If I understand it correctly, you register file descriptors with epoll_ctl()
> on an fd created with epoll_create(), and set the new EPOLLWAKEUP flag.
> Then when a regular 'poll' or 'select' on the epoll fd reports that it is
> readable you:
>   - get a wakelock
>   - use epoll_wait to collect the events
>   - process the events
>   - release your wakelock
>   - go back to poll() or select() on the epoll fd.
> Correct?  As long as there are ready events with EPOLLWAKEUP set a
> wakeup_source is held active and the system won't go to sleep.
> 
> My concern with this is about permissions.  It appears that any process could
> wait of some fd (maybe a pipe they created themselves) with EPOLLWAKEUP, and
> then simply never epoll_wait() for the event.  Then they would be keeping
> the system awake.  I don't think that is acceptable.

I wonder what Arve has to say to that, but let me say that on systems without
autosleep every process can go into an infinite busy loop which is going to
drain battery relatively quickly just as well and I don't see why that's so
much different.

> So there needs to be some way to limit who can effectively block suspend by
> using EPOLLWAKEUP.
> (This is one of the reasons I like an all-user-space solution.  Policy issues
> like this can easily be decided in user-space but are clumsy to put into the
> kernel).
> 
> Also, I'm having trouble understanding the ep->ws wakeup_source.
> The epi->ws makes lots of sense and I think I understand it all.
> However I don't see why you need a wakeup_source for the 'struct eventpoll'.
> 
> Every time that 'poll' decides to call the ->poll fop for the eventpoll, this
> wakeup_source will be activated and deactivated which will abort any current
> suspend cycle even if there are no events to report.
> 
> I suspect it can just go away.

I'll leave this one entirely to Arve, if you don't mind. :-)

> One last item that doesn't really belong here - but it is in context.
> 
> This mechanism is elegant because it provides a single implementation that
> provides wakeup_source for almost any sort of device.  I would like to do the
> same thing for interrupts.
> Most (maybe all) of the wakeup device on my phone have an interrupt where the
> body is run in a thread.  When the thread has done it's work the event is
> visible to userspace so the EPOLLWAKEUP mechanism is all that is needed to
> complete the path to user-space (or for my user-space solution, nothing else
> is needed once it is visible to user-space).
> So we just need to ensure a clear path from the "top half" interrupt handler
> to the threaded handler.
> So I imagine attaching a wakeup source to every interrupt for which 'wakeup'
> is enabled, activating it when the top-half starts and relaxing it when the
> bottom-half completes.  With this in place, almost all drivers would get
> wakeup_source handling for free.
> Does this seem reasonable to you.

Yes, it does.

Wakeup devices have their own wakeup source objects anyway, so perhaps they may
be used for this purpose somehow (just wondering).

> I'm afraid I don't have code yet, but hope to find time in a few weeks.
> 
> One difficulty with that is that I have noticed a number of drivers that
> potentially enable_irq_wake just before suspend and disable_irq_wake
> immediately after (e.g. gpio_keys.c).  Allocating a wakeup_source on each
> enable_irq_wake would be an unfortunate overhead.  Maybe we just allocate it
> the first time enable_irq_wake is called ....

I guess we can do something in analogy with device_wakeup_enable()?

Rafael
