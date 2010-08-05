Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab0HEPgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:36:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594Ab0HEPfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:35:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Thu, 5 Aug 2010 17:34:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
References: <20100801054816.GI2470@linux.vnet.ibm.com> <201008050220.51805.rjw@sisk.pl> <AANLkTikK+OCrg8Jx5SpTbg6iFDX12MKZrTsdOr4mRJN0@mail.gmail.com>
In-Reply-To: <AANLkTikK+OCrg8Jx5SpTbg6iFDX12MKZrTsdOr4mRJN0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008051734.06736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 05, 2010, Arve Hjønnevåg wrote:
> 2010/8/4 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, August 05, 2010, Arve Hjønnevåg wrote:
> >> On Wed, Aug 4, 2010 at 1:56 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >> > On Wed, Aug 04, 2010 at 10:51:07PM +0200, Rafael J. Wysocki wrote:
> >> >> On Wednesday, August 04, 2010, Matthew Garrett wrote:
> >> >> > No! And that's precisely the issue. Android's existing behaviour could
> >> >> > be entirely implemented in the form of binary that manually triggers
> >> >> > suspend when (a) the screen is off and (b) no userspace applications
> >> >> > have indicated that the system shouldn't sleep, except for the wakeup
> >> >> > event race. Imagine the following:
> >> >> >
> >> >> > 1) The policy timeout is about to expire. No applications are holding
> >> >> > wakelocks. The system will suspend providing nothing takes a wakelock.
> >> >> > 2) A network packet arrives indicating an incoming SIP call
> >> >> > 3) The VOIP application takes a wakelock and prevents the phone from
> >> >> > suspending while the call is in progress
> >> >> >
> >> >> > What stops the system going to sleep between (2) and (3)? cgroups don't,
> >> >> > because the voip app is an otherwise untrusted application that you've
> >> >> > just told the scheduler to ignore.
> >> >>
> >> >> I _think_ you can use the just-merged /sys/power/wakeup_count mechanism to
> >> >> avoid the race (if pm_wakeup_event() is called at 2)).
> >> >
> >> > Yes, I think that solves the problem. The only question then is whether
> >>
> >> How? By passing a timeout to pm_wakeup_event when the network driver
> >> gets the packet or by passing 0. If you pass a timeout it is the same
> >> as using a wakelock with a timeout and should work (assuming the
> >> timeout you picked is long enough). If you don't pass a timeout it
> >> does not work, since the packet may not be visible to user-space yet.
> >
> > Alternatively, pm_stay_awake() / pm_relax() can be used.
> >
> 
> Which makes the driver and/or network stack changes identical to using
> wakelocks, right?

Please refer to the Matthew's response.

> >> > it's preferable to use cgroups or suspend fully, which is pretty much up
> >> > to the implementation. In other words, is there a reason we're still
> >>
> >> I have seen no proposed way to use cgroups that will work. If you
> >> leave some processes running while other processes are frozen you run
> >> into problems when a frozen process holds a resource that a running
> >> process needs.
> >>
> >>
> >> > having this conversation? :) It'd be good to have some feedback from
> >> > Google as to whether this satisfies their functional requirements.
> >> >
> >>
> >> That is "this"? The merged code? If so, no it does not satisfy our
> >> requirements. The in kernel api, while offering similar functionality
> >> to the wakelock interface, does not use any handles which makes it
> >> impossible to get reasonable stats (You don't know which pm_stay_awake
> >> request pm_relax is reverting).
> >
> > Why is that a problem (out of curiosity)?
> >
> 
> Not having stats or not knowing what pm_relax is undoing? We need
> stats to be able to debug the system.

You have the stats in struct device and they are available via sysfs.
I suppose they are insufficient, but I'd like to know why exactly.

> If the system does not suspend
> at all or is awake for too long, the wakelock stats tells us which
> component is at fault. Since pm_stay_awake and pm_relax does not
> operate on a handle, you cannot determine how long it prevented
> suspend for.

Well, if you need that, you can add a counter of "completed events" into
struct dev_pm_info and a function similar to pm_relax() that
will update that counter.  I don't think anyone will object to that change.

> >> The proposed in user-space interface
> >> of calling into every process that receives wakeup events before every
> >> suspend call
> >
> > Well,  you don't really need to do that.
> >
> 
> Only if the driver blocks suspend until user-space has read the event.
> This means that for android to work we need to block suspend when
> input events are not processed, but a system using your scheme needs a
> pm_wakeup_event call when the input event is queued. How to you switch
> between them? Do we add separate ioctls in the input device to enable
> each scheme? If someone has a single threaded user space power manager
> that also reads input event it will deadlock if you block suspend
> until it reads the input events since you block when reading the wake
> count.

Well, until someone actually tries to implement a power manager in user space
it's a bit vague.

Thanks,
Rafael
