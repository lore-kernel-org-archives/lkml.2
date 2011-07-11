Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab1GKTi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:38:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46625 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964832Ab1GKTi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:38:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [Update][PATCH 6/10] PM / Domains: System-wide transitions support for generic domains (v5)
Date: Mon, 11 Jul 2011 21:39:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <Pine.LNX.4.44L0.1107081033000.2208-100000@iolanthe.rowland.org> <201107091615.38915.rjw@sisk.pl> <87oc10zv4g.fsf@ti.com>
In-Reply-To: <87oc10zv4g.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107112139.50503.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 11, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> [...]
> 
> >
> > There's one more case to consider, namely devices that are runtime
> > suspended, set up to wake up the system from sleep states
> > (ie. device_may_wakeup(dev) returns "true") and such that
> > genpd->active_wakeup(dev) returns "true" for them, because they need
> > to be resumed at this point too (arguably, it makes a little sense to
> > runtime suspend such devices, but that's possible in principle).
> >
> > So, IMO, the patch should look like this:
> >
> > ---
> >  drivers/base/power/domain.c |   19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> >> Index: linux-2.6/drivers/base/power/domain.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/domain.c
> > +++ linux-2.6/drivers/base/power/domain.c
> > @@ -486,6 +486,22 @@ static void pm_genpd_sync_poweroff(struc
> >  }
> >  
> >  /**
> > + * resume_needed - Check whether to resume a device before system suspend.
> > + * @dev: Device to handle.
> > + * @genpd: PM domain the device belongs to.
> > + */
> > +static bool resume_needed(struct device *dev, struct generic_pm_domain *genpd)
> > +{
> > +	bool active_wakeup;
> > +
> > +	if (!device_can_wakeup(dev))
> > +		return false;
> > +
> > +	active_wakeup = genpd->active_wakeup && genpd->active_wakeup(dev);
> > +	return device_may_wakeup(dev) ? active_wakeup : !active_wakeup;
> 
> This also returns true and causes a resume if active_wakeup = false and
> device_may_wakeup() = false.  That doesn't seem right.

This is on purpose. :-)  If active_wakeup is false, the device may signal
remote wakeup while suspended.  So, if active_wakeup is false and the device
is suspended, we have to assume that the device has been set up to signal
remote wakeup for runtime PM (if it is not suspended, attempting to resume it
will not have any effect).  Now, if device_may_wakeup() returns false in
addition to that, we may need to change the device's wakeup settings, so the
driver's callbacks should be invoked during suspend, so we're resuming the
device (we can't just leave it suspended and then invoke the driver's callbacks
in the hope they'll do the right thing).

I don't really think we can do anything else without using new device flags.

> > +}
> > +
> > +/**
> >   * pm_genpd_prepare - Start power transition of a device in a PM domain.
> >   * @dev: Device to start the transition of.
> >   *
> > @@ -519,6 +535,9 @@ static int pm_genpd_prepare(struct devic
> >  		return -EBUSY;
> >  	}
> >  
> > +	if (resume_needed(dev, genpd))
> > +		pm_runtime_resume(dev);
> > +
> >  	genpd_acquire_lock(genpd);
> >  
> >  	if (genpd->prepared_count++ == 0)
> 
> IIUC, if a device is runtime suspended when a system suspend happens,
> the device will be runtime resumed, but never re-suspended.

It will be resuspended by the pm_runtime_idle() in pm_genpd_complete()
(added by one of the new patches I've been posting for the last few days).

> Should resumes by the PM core be done with a get (and a corresponding
> put in .complete())?

Not necessarily. :-)

Thanks,
Rafael
