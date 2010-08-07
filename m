Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082Ab0HGIvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:51:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0HGIvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:51:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Sat, 7 Aug 2010 10:49:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <Pine.LNX.4.44L0.1008061505070.9303-100000@netrider.rowland.org> <201008070004.43923.rjw@sisk.pl>
In-Reply-To: <201008070004.43923.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008071049.38237.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 07, 2010, Rafael J. Wysocki wrote:
> On Friday, August 06, 2010, Alan Stern wrote:
> > On Thu, 5 Aug 2010, Arve Hjønnevåg wrote:
> ...
> > But what sorts of things qualify as wakeup events?  Right now, the code
> > handles only events coming by way of the PME# signal (or its platform
> > equivalent).  But that signal usually gets activated only when a PCI
> > device is in a low-power mode; if the device is at full power then it
> > simply generates an IRQ.  It's the same event, but reported to the
> > kernel in a different way.  So consider...
> > 
> > Case 1: The system is suspending and the PCI device has already been
> > 	placed in D3hot when an event occurs.  PME# is activated,
> > 	the wakeup event is reported, the suspend is aborted, and the 
> > 	system won't try to suspend again for at least 100 ms.  Good.
> > 
> > Case 2: The system is running normally and the PCI device is at full
> > 	power when an event occurs.  PME# isn't activated and 
> > 	pm_wakeup_event doesn't get called.  Then when the system
> > 	tries to suspend 25 ms later, there's nothing to prevent it
> > 	even though the event is still being processed.  Bad.
> > 
> > In case 2 the race has not been resolved.  It seems to me that the 
> > only proper solution is to call pm_wakeup_event for _every_ PCI 
> > interrupt.  This may be too much to add to a hot path, but what's the 
> > alternative?
> 
> Arguably not every PCI interrupt should be regarded as a wakeup event, so
> I think we can simply say in the cases when that's necessary the driver should
> be responsible for using pm_wakeup_event() or pm_stay_awake() / pm_relax() as
> appropriate.
> 
> My patch only added it to the bus-level code which covered the PME-based
> wakeup events that _cannot_ be handled by device drivers.

Also please note that it depends a good deal on the definition of a "wakeup
event".  Under the definition used when my patch was being developed, ie. that
wakeup events are the events that would wake up the system from a sleep state,
PCI interrupts cannot be wakeup events, unless the given device remains in the
full power state although the system has been suspended (standard PCI devices
are not allowed to generate signals except for PME from low-power states).

Thanks,
Rafael
