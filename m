Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768Ab0HDUdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:33:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38372 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934605Ab0HDUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:33:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Wed, 4 Aug 2010 22:31:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
References: <20100801210548.23f77ff6@infradead.org> <201008041347.25595.rjw@sisk.pl> <alpine.DEB.2.00.1008041130550.6545@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.1008041130550.6545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042231.51901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 04, 2010, david@lang.hm wrote:
> On Wed, 4 Aug 2010, Rafael J. Wysocki wrote:
> 
> > On Wednesday, August 04, 2010, david@lang.hm wrote:
> >> On Wed, 4 Aug 2010, Arve Hj?nnev?g wrote:
> >>
> >>> 2010/8/3  <david@lang.hm>:
> >>>> On Tue, 3 Aug 2010, Arve Hj?nnev?g wrote:
> >>>>
> >>>>> 2010/8/3  <david@lang.hm>:
> >>>>>>
> >>>>>> On Tue, 3 Aug 2010, Arve Hj?nnev?g wrote:
> > ...
> >>>>>>> The hardware specific idle hook can (and does) decide to go into any
> >>>>>>> power state from idle that does not disrupt any active devices.
> >>>>>>
> >>>>>> This I know is an Andoid specific thing. On other platforms power states
> >>>>>> very definantly can make user visible changes.
> >
> > It would be much better if you gave specific examples.  Because, for instance,
> > I'm not sure what platforms you have in mind.
> 
> I gave examples in other messages that included dimming/turning off the 
> screen and  spinning down the disk among others.
> 
> the definition of 'transparently' was then clarified to not mean 
> transparent to the user, but transparent (except for possibly delays) to 
> the applications (they may have to wait for the disk to spin up for 
> example)
> 
> >>>>> How is this Android specific?
> >>>>
> >>>> you are stating that this must be suspend because low-power idle must be
> >>>> transparent to the user.
> >>>
> >>> It must be transparent to the rest of the system.
> >>>
> >>>>
> >>>> I am saying that on Linux, low-power idle commonly is not transparent to the
> >>>> user, so the requirement for it to be transparent (therefor putting the
> >>>> suspend into a different category) is an Android only requirement.
> >>>>
> >>>
> >>> I'm am not talking about minor latencies. If you have a platform that
> >>> for instance turns off you screen dma when entering idle, it is broken
> >>> whether is running Android or not. If it does the same in suspend it
> >>> is not a problem.
> >>
> >> This isn't sounding quite right to me. I've seen too many discussions
> >> about things like idle and USB devices/hubs/drives/etc getting powered
> >> down for power savings modes to make me readily accept that everything
> >> must be as transparent as you imply. Just the case of drive spin-down
> >> shows that it's possible to do things that would be considered
> >> destructive, but you have to have a flag and wake-up path to recover
> >> within a 'reasonable' amount of time (I guess that this could be
> >> 'transparent' if that only implies that things must work eventually, which
> >> isn't what I read into the statement)
> >
> > Well, consider a single character device and suppose there is an application
> > talking to the driver using read(), write(), ioctl(), whatever.  Now suppose
> > you want to put the device into a low-power state such that the device can't
> > do the I/O in that state.  You need to ensure that the app won't be able to
> > reach the device while in that state and you can (1) arrange things so that
> > the device is put into the full-power state whenever the app tries to access
> > it and (2) "freeze" the app so that it won't try to access the device being in
> > the low-power state.
> >
> > Generally speaking (1) is what idle (and any other form of runtime PM) does and
> > (2) is what suspend does with respect to the whole system.
> 
> makes sense
> 
> > In the suspend case, when you have frozen all applications, you can
> > sequentially disable all interrupts except for a few selected ("wakeup") ones
> > in a safe way.   By disabling them, you ensure that the CPU will only be
> > "revived" by a limited set of events and that allows the system to stay
> > low-power for extended time intervals.
> 
> the benifit of this will depend on what wakeups you are able to avoid by 
> putting the hardware to sleep. Depending on the hardware, this may be not 
> matter that much.

That's correct, but evidently it does make a difference with the hardware
Android commonly runs on.

> In addition, there are input devices like a touchscreen that could be 
> disabled even short of a full suspend, as long as there is some way to get 
> them reactivated.

That's correct again, but it doesn't matter too much as far as the difference
between "deep idle" and suspend is concerned.  These devices are generally not
the interrupt sources that are difficult to shut down safely in the "idle" case.

> > To achieve the same result in the "idle" case, you'll need to have a mechanism
> > to disable interrupts (except for the "wakeup" ones) avoiding synchronization
> > problems (eg. situations in which task A, blocked on a "suspended" device
> > access, holds a mutex waited for by task B that needs to run so that we can
> > "suspend" another device).  That, however, is a difficult problem.
> 
> I would say that the difficulty of the problem depends on the hardware and 
> how much userspace interaction is needed. If the kernel can disable the 
> hardware in the driver (so that it can wake it up again when accessed by 
> an application) it would seem that this isn't a problem.

Well, I guess it's useful to consider the sequence of events in the "idle"
case.

We first detect that a CPU is idle, so it can be put into a C-state (or
equivalent).  It's easy to put that CPU into such a state, but suppose we
want to do more and put all devices into low-power states at that point.
We have to ensure that there are no devices in the middle of DMA and that
the other CPUs are idle (that's kind of easy, but still).  Next, we have to
figure out the right ordering in which to put devices into low-power states
(that is not trivial, because the tasks that use those devices may depend on
each other in various ways).  If we decide to shut down clock source
interrupts, we must ensure that the timekeeping will be correct after that and
so on.  Moreover, things get ugly if there are shared interrupts.

Suspend kind of works around these difficulties by taking the entire user
space out of the picture with one big sledgehammer called the freezer,
but these problems would have to be actually _solved_ in the "idle" case.

Thanks,
Rafael
