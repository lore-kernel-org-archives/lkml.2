Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1GHOhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:37:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47863 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752038Ab1GHOhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:37:32 -0400
Date: Fri, 8 Jul 2011 10:37:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kevin Hilman <khilman@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [Update][PATCH 6/10] PM / Domains: System-wide transitions
 support for generic domains (v5)
In-Reply-To: <201107081124.17463.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1107081033000.2208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jul 2011, Rafael J. Wysocki wrote:

> On Friday, July 08, 2011, Kevin Hilman wrote:
> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >
> > > Make generic PM domains support system-wide power transitions
> > > (system suspend and hibernation).  Add suspend, resume, freeze, thaw,
> > > poweroff and restore callbacks to be associated with struct
> > > generic_pm_domain objects and make pm_genpd_init() use them as
> > > appropriate.
> > >
> > > The new callbacks do nothing for devices belonging to power domains
> > > that were powered down at run time (before the transition).  
> > 
> > Thinking about this some more, how is a driver supposed to reconfigure
> > wakeups during suspend if it has already been runtime suspended?
> 
> If the device belongs to a PM domain that has been powered off, it
> won't be notified.
> 
> > For example, assume a device where device_may_wakeup() == false.  This
> > means wakeups during *suspend* are disabled, but wakeups wakeups are
> > assumed to enabled when it is runtime suspended.
> > 
> > So now, assume this device is RPM_SUSPENDED, it has wakeups *enabled*,
> > and then system suspend comes along.  
> > 
> > With this current patch, the driver will never receive any callbacks, so
> > it can never disable its wakeups.  
> >
> > Am I missing something?
> 
> As I said above, this only happens with devices that belog to PM domains
> that were powered off before system suspend has started, so the problem
> is limited to devices that wakeup is signaled on behalf of even when they
> have no power.
> 
> So this is a limitation, but not affecting all platforms.
> 
> There are a few ways to avoid this limitation I can think of:
> (1) Add a "make me operational during system suspend" flag to struct dev_pm_info
>     and run pm_runtime_resume() on such devices from the core (either dpm_prepare()
>     core, or pm_genpd_prepare()).

What's to prevent the device from being runtime-suspended again before 
the wakeup setting can be changed?

> (2) Add a "my .prepare() is safe to run if device is not accessible" flag to
>     struct dev_pm_info and make pm_genpd_prepare() execute .prepare() for such
>     devices regardless of whether or not their PM domains are off.
> (3) Call .prepare() from all drivers unconditionally during system suspend
>     (and probably .complete() too) in the hope they won't access inaccessible
>     devices.
> Probably, there's more.

In the PM domain's suspend code, do a runtime resume if the wakeup
setting needs to be changed, rather than simply skipping over the
device.

> In any case I think it's material for future work.

Alan Stern

