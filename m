Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0FZRO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 13:14:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54667 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753228Ab0FZROz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 13:14:55 -0400
Date: Sat, 26 Jun 2010 13:14:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mark gross <640e9920@gmail.com>, Florian Mickler <florian@mickler.org>,
       Neil Brown <neilb@suse.de>, <linux-pci@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       <Arve@smtp1.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] PM: Make it possible to avoid wakeup events
 from being lost
In-Reply-To: <18366.69939.qm@web180315.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1006261258140.22018-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010, David Brownell wrote:

> This is a repeat of an issue I posted before, but
> which for some reason I never saw email back ...

I replied to one of your emails on this topic.  Maybe you didn't see 
the reply.

> basically, I think the notion of counting wakeup
> events seems dubious on common hardware, so the
> focus might perhaps better be placed on ensuring
> userspace just receives events rather than
> trying to track events which in one context ended
> up being wakeup events.  (That's simpler, and the
> system is by definition awake if it can handle any
> events at all.)

I disagree.  There's no question that userspace will eventually receive 
these events.  The question is whether they will be received in a 
timely manner.

The "counting" isn't meant as a way of keeping track of the absolute
number of these events.  It's more like a technique for seeing how many
remain outstanding at any time.

> Thing is, "wakeup" is, for e.g. most ARMs, just a hardware attribute of what's otherwise a routine
> event, which happens in other contexts and needs
> to be handled consistently .... nothing special
> about having woken the system too, the result ought to
> be the same regardless (from the user P.O.V.) ...  (Common Examples include SoC peripheral IRQs that can wake the system (including GPIO and other types
> of external IRQ signal.)

There's nothing wrong with that.  All these routine events may qualify
as "wakeup" events.  The real deciding factor is whether the event
should cause tasks to be unfrozen (if they have already been frozen by
the PM core).  If yes then it is a "wakeup" event; otherwise it isn't.

> BRIEFLY:  if that event doesn't arrive reliably,
> it's an issue regardless of wakeup:  either TX from
> kernel, or RX in userspace. Such bugs would need to
> be fixed.  Having them fixed will help the wakeup scenarios too of course.

That is irrelevant to the topic at hand.  We know that these events 
arrive; what we don't know is that they will properly block tasks 
from being frozen (or will unfreeze them if they are already frozen).

> (The raciness issues might boil down to something as simple as not letting userspace know about transition events to/from suspend states, but that issue
> ought to be cleanly separable; ISTR other messages on the suspend blocker threads have shown how to work with such clean factoring.)
> 
> 
> 
> So trying to track whether a given event is what
> woke the system will often be implausible, since
> several such events might each have fired (one
> or more concurrent wakeup sources, even ... it
> could be indeterminate which one[s] happened.)
> And the event could fire without being a wakeup.

It doesn't matter which event(s) woke the system, and Rafael's patch 
doesn't try to track this.

> Yes, there are a few cases (like USB remote wakeup
> signaling and some PCI mechanisms, plus a few BIOS
> assisted situations) where certain events may be
> identifiable as wakeup sources, perhaps runtime not
> system-wide).  But the common case just includes
> an event, not the ability to know that event had
> the "woke whole system from low power state"
> side effect too.

> > +        The
> > /sys/power/wakeup_count file allows user space to avoid
> > +        losing wakeup events
> > when transitioning the system into a sleep
> > +        state.  Reading

This could have been phrased better:  The /sys/power/wakeup_count file
allows user space to put the system into a sleep state conditionally
subject to the arrival of concurrent wakeup events, which will either
block the sleep transition or cause it to fail.

Alan Stern

