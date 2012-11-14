Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161252Ab2KNQmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:42:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35784 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161099Ab2KNQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:42:34 -0500
Date: Wed, 14 Nov 2012 11:42:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Huang Ying <ying.huang@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and forbidden
In-Reply-To: <1456950.61QZjXbNpt@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1211141127440.1620-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Rafael J. Wysocki wrote:

> On Thursday, November 08, 2012 12:07:54 PM Alan Stern wrote:
> > On Thu, 8 Nov 2012, Rafael J. Wysocki wrote:
> 
> [...]
> 
> I'd like to revisit this for a while if you don't mind.

Not at all.

> > Your revised patch does do the job, except for a few problems.  
> > Namely, while local_pci_probe() and pci_device_remove() are running,
> > the device _does_ have a driver.
> 
> Right.
> 
> > This means that local_pci_probe() should not call pm_runtime_get_sync(),
> > for example.  Doing so would invoke the driver's runtime_resume routine
> > before calling the driver's probe routine!
> > 
> > The USB subsystem solves this problem by carefully keeping track of the 
> > state of the device-driver binding:
> > 
> > 	Originally the device is UNBOUND.
> > 
> > 	At the start of the subsystem's probe routine, the state
> > 	changes to BINDING.
> > 
> > 	If the probe succeeds then it changes to BOUND; otherwise
> > 	it goes back to UNBOUND.
> > 
> > 	At the start of the subsystem's remove routine, the state
> > 	changes to UNBINDING.  At the end it goes to UNBOUND.
> > 
> > When the state is anything other than BOUND, the subsystem's runtime PM 
> > routines act as though there is no driver.
> 
> Well, that wouldn't help PCI, because some drivers want to use the
> pm_runtime_* stuff in their .probe() routines and actually expect it to
> work. :-)

PCI could do something like this:

	local_pci_probe() calls pm_runtime_get_sync() twice before
	it changes the binding state to BINDING.  It then calls 
	pm_runtime_put_sync() after the state is BOUND.

	pci_device_remove() calls pm_runtime_get_sync() before it
	changes the binding state to UNBINDING.  It then calls
	pm_runtime_put_sync() twice after the state is UNBOUND.

(Obviously some of those calls could be _get_noresume() or
_put_noidle().)

This has the side effect that when a driver unbinds, it can't leave the 
device in a special low-power state.  The device will always end up in 
the generic low-power state supported by the PCI core.

> Perhaps we can introduce something like
> 
> pm_runtime_get[_put]_skip_callbacks()
> 
> that would treat the device as though it had the power.no_callbacks flag
> set and use that around the driver's .probe() in the PCI core?

That would prevent the PM core from invoking the PCI subsystem's own 
callback, not just the driver's callback.  So I don't think that's what 
you want.

Alan Stern

