Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1GHSF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 14:05:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1GHSF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 14:05:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [Update][PATCH 6/10] PM / Domains: System-wide transitions support for generic domains (v5)
Date: Fri, 8 Jul 2011 20:06:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <Pine.LNX.4.44L0.1107081033000.2208-100000@iolanthe.rowland.org> <87y6088z9n.fsf@ti.com>
In-Reply-To: <87y6088z9n.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107082006.49660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 08, 2011, Kevin Hilman wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Fri, 8 Jul 2011, Rafael J. Wysocki wrote:
> >
> >> On Friday, July 08, 2011, Kevin Hilman wrote:
> >> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> > 
> >> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> >> > >
> >> > > Make generic PM domains support system-wide power transitions
> >> > > (system suspend and hibernation).  Add suspend, resume, freeze, thaw,
> >> > > poweroff and restore callbacks to be associated with struct
> >> > > generic_pm_domain objects and make pm_genpd_init() use them as
> >> > > appropriate.
> >> > >
> >> > > The new callbacks do nothing for devices belonging to power domains
> >> > > that were powered down at run time (before the transition).  
> >> > 
> >> > Thinking about this some more, how is a driver supposed to reconfigure
> >> > wakeups during suspend if it has already been runtime suspended?
> >> 
> >> If the device belongs to a PM domain that has been powered off, it
> >> won't be notified.
> >> 
> >> > For example, assume a device where device_may_wakeup() == false.  This
> >> > means wakeups during *suspend* are disabled, but wakeups wakeups are
> >> > assumed to enabled when it is runtime suspended.
> >> > 
> >> > So now, assume this device is RPM_SUSPENDED, it has wakeups *enabled*,
> >> > and then system suspend comes along.  
> >> > 
> >> > With this current patch, the driver will never receive any callbacks, so
> >> > it can never disable its wakeups.  
> >> >
> >> > Am I missing something?
> >> 
> >> As I said above, this only happens with devices that belog to PM domains
> >> that were powered off before system suspend has started, so the problem
> >> is limited to devices that wakeup is signaled on behalf of even when they
> >> have no power.
> 
> Which on OMAP, is *all* devices, so that's a pretty major limitation.  :)

So we'll need to avoid it _for_ _OMAP_.  Any of the platforms that will use
this code in near future doesn't have this limitation, AFAICS, so I don't
really see a point coding for it right now.

Your point seems to be that the whole thing has to be ready for OMAP
in advance and my point is that we can make it ready for OMAP later.
Which I believe is more pragmatic, because if every platform had adopted
the other viewpoint, we wouldn't have made any progress at all.

> >> So this is a limitation, but not affecting all platforms.
> >> 
> >> There are a few ways to avoid this limitation I can think of:
> >> (1) Add a "make me operational during system suspend" flag to struct dev_pm_info
> >>     and run pm_runtime_resume() on such devices from the core (either dpm_prepare()
> >>     core, or pm_genpd_prepare()).
> >
> > What's to prevent the device from being runtime-suspended again before 
> > the wakeup setting can be changed?
> >
> >> (2) Add a "my .prepare() is safe to run if device is not accessible" flag to
> >>     struct dev_pm_info and make pm_genpd_prepare() execute .prepare() for such
> >>     devices regardless of whether or not their PM domains are off.
> >> (3) Call .prepare() from all drivers unconditionally during system suspend
> >>     (and probably .complete() too) in the hope they won't access inaccessible
> >>     devices.
> 
> Like Alan's comment above for (1), I think the same applies for (3)
> since runtime PM transitions can still happen between .prepare() and
> .suspend()

Not with the current PM domains code (and please see my reply to Alan).

Thanks,
Rafael
