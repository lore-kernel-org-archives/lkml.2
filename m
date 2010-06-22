Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0FVVAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:00:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39039 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab0FVVAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:00:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Tue, 22 Jun 2010 22:58:53 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <Pine.LNX.4.44L0.1006221508390.1322-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1006221508390.1322-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006222258.54164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010, Alan Stern wrote:
> On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
> 
> > On Tuesday, June 22, 2010, Alan Stern wrote:
> > > On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
> > > 
> > > > Having reconsidered that I think there's more to it.
> > > > 
> > > > Take the PCI subsystem as an example, specifically pcie_pme_handle_request().
> > > > This is the place where wakeup events are started, but it has no idea about
> > > > how they are going to be handled.  Thus in the suspend blocker scheme it would
> > > > need to activate a blocker, but it wouldn't be able to release it.  So, it
> > > > seems, we would need to associate a suspend blocker with each PCIe device
> > > > that can generate wakeup events and require all drivers of such devices to
> > > > deal with a blocker activated by someone else (PCIe PME driver in this
> > > > particular case).  That sounds cumbersome to say the least.
> > > 
> > > Maybe this means pcie_pme_handle_request() isn't a good place to note
> > > the arrival of a wakeup event.  Doing it in the individual driver might
> > > work out better.
> > 
> > But it this case there will be an open window in which suspend may be started
> > after the wakeup event is signaled, but before the PM core is told about it.
> 
> That's true but it doesn't matter, assuming the suspend can't progress 
> during this window.
> 
> > > The problem in your example is that pcie_pme_handle_request() has no 
> > > idea about the nature or extent of the critical section to follow.
> > 
> > Exactly.
> >  
> > > Therefore it's not in a good position to mark the beginning of the 
> > > critical section, even though it is in an excellent position to mark 
> > > the receipt of a wakeup event.
> > 
> > I think we have no choice but to regard the detection of a wakeup event as the
> > beginning of a "suspend critical section".
> 
> Receipt of a wakeup event triggers a whole series of function calls,
> including calls to the resume methods of every driver.  The system
> should be designed so that the next suspend can't begin until those
> function calls complete.  For example, the next suspend certainly can't
> begin before the resume methods all complete.  Given that premise, any
> one of those functions could serve as the start of a suspend critical
> section.

Well, consider pcie_pme_handle_request() again.  It certainly can be called
during suspend (until the PME interrupt is disabled), but the PM workqueue
is frozen at this point, so the device driver's resume routine won't be called.
However, the wakeup signal from the device should be regarded as a wakeup
event in that case IMO.

[We have a check for that in dpm_prepare(), but I think it should be replaced
by the "proper" handling of wakeup events, once we have one.]

... 
> > > > So, even if we can say when the kernel has finished processing the event
> > > > (although that would be complicated in the PCIe case above), I don't think
> > > > it's generally possible to ensure that the entire processing of a wakeup event
> > > > has been completed.  This leads to the question whether or not it is worth
> > > > trying to detect the ending of the processing of a wakeup event.
> > > 
> > > As Arve pointed out, in some cases it definitely is worthwhile (the
> > > gpio keypad matrix example).  In other cases there may be no reasonable
> > > way to tell.  That doesn't mean we have to give up entirely.
> > 
> > Well, I'm not sure, because that really depends on the hardware and bus in
> > question.  The necessary condition seems to be that the event be detected
> > and handled entirely by the same functional unit (eg. a device driver) within
> > the kernel and such that it is able to detect whether or not user space has
> > acquired the event information.  That doesn't seem to be a common case to me.
> 
> It's hard to say how common this is without having a list of possible
> wakeup sources.  And of course, that list will differ from one platform
> to another.

Agreed.

... 
> > I think there are a few different issues that the suspend blockers (or
> > wakelocks) framework attempts to address in one bit hammer.  To me, they are
> > at least (1) deciding when to suspend, (2) detecting events that should make
> > us avoid suspending (or abort suspend if already started), (3) preventing
> > "untrusted" processes from making the system use too much energy.
> > 
> > IMO it's better to treat them as different issues and try to address them
> > separately.
> 
> Certainly (3) needs to be addressed separately.  It should be handled 
> completely within userspace, if at all possible.
> 
> (1) and (2) are closely related.  In fact, a reasonable criterion for 
> (1) might be: Suspend whenever it is allowed.  Then (2) becomes: What 
> sorts of things should disallow suspend, and for how long?

The events I mean by (2) are the minimal subset of conditions used in (1),
because the user may add more restrictions that should be checked by user space.

For example, the user may request to suspend whenever there are no open SSH
connections to the machine (why not?), but even if that criterion is satisfied,
wake-on-LAN events should prevent suspend from happening.

> Evidently part of the problem here is that for a very long time
> (predating the existence of Linux), people have been using a bad
> abstraction.  We talk about "wakeup events", but an event occupies only
> a single moment in time.  If the computer happens to be asleep at that
> moment then it wakes up, fine.  But if it was already awake, then once
> the moment is passed there's no reason not to suspend -- even if only
> 1 microsecond has elapsed.  Likewise, if an event causes the computer
> to wake up, then once the computer is awake the moment is over and
> there's nothing to prevent the computer from immediately going back to
> sleep.
> 
> Instead of talking about events, we should be talking about procedures
> or sections: something that happens over a non-zero period of time.

Agreed.
 
> But people have never thought in terms of wakeup procedures or suspend
> critical sections, and so the kernel isn't designed to accomodate them.  
> We may know when they begin, but we often have only a cloudy idea of
> when they end.

Yeah.

> Historically, people have mostly had in mind that the answer to (1)
> would be: Suspend whenever the user tells the computer to suspend.  In
> that kind of setting, (2) doesn't matter: When the user tells the
> machine to suspend, it should obey.

Well, not necessarily, because the user can change his mind while the machine
is suspending and try to generate a wakeup event to abort the suspend.

> But when we start to consider energy conservation and autonomous (or
> opportunistic) suspend, things become more complex.  This is why, for
> example, the USB subsystem has a user-selectable autosuspend delay.  
> It's not an ideal solution, but it does prevent us from thrashing
> between suspending and resuming a device over and over if it gets used
> repeatedly during a short period of time.
> 
> We can design mechanisms until we are blue in the face (some of us may
> be blue already!), but until we remedy this weakness in our thinking we
> won't know how to apply them.  Which means people won't be able to
> agree on a single correct approach.

I agree 100%.

Rafael
