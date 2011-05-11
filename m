Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1EKUhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:37:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43554 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab1EKUh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:37:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [Update][RFC][PATCH 1/2] PM / Runtime: Support for generic I/O power domains (v2)
Date: Wed, 11 May 2011 22:37:50 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <201104290154.12966.rjw@sisk.pl> <201104300254.46973.rjw@sisk.pl> <1305098801.4642.6.camel@vence>
In-Reply-To: <1305098801.4642.6.camel@vence>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105112237.50625.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 11, 2011, Kevin Hilman wrote:
> Hi Rafael,

Hi Kevin,

> On Sat, 2011-04-30 at 02:54 +0200, Rafael J. Wysocki wrote: 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introcude common headers, helper functions and callbacks allowing
> > platforms to use simple generic power domains for runtime power
> > management.
> > 
> > Introduce struct generic_power_domain to be used for representing
> > power domains that each contain a number of devices and may be
> > master domains or subdomains with respect to other power domains.
> > Among other things, this structure includes callbacks to be
> > provided by platforms for performing specific tasks related to
> > power management (i.e. ->stop_device() may disable a device's
> > clocks, while ->start_device() may enable them, ->power_on() is
> > supposed to remove power from the entire power domain
> > and ->power_off() is supposed to restore it).
> >
> > Introduce functions that can be used as power domain runtime PM
> > callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> > as well as helper functions for the initialization of a power
> > domain represented by a struct generic_power_domain object,
> > adding a device to or removing a device from it and adding or
> > removing subdomains.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Thanks for proposing this.  It looks like a good starting point.

That's exactly the purpose of it.

> I haven't had the time to experiment with it on OMAP yet due to
> travel/conferences, but here's at least a few comments and questions
> after a brief review.
> 
> This looks like a good start for an abstraction, but I'm not sure if can
> be broadly useful without some further complications.

I wouldn't expect it to match every possible use case, of course, but it's
simple enough as an initial step and something we may build upon in the
future.

> On many SoCs, a HW power domain has more than 2 states.  On OMAP for
> example, a power domain can be on, inactive, retention or off.
> Therefore, the 2-state approach in this patch doesn't really map well to
> hardware power domains (and I'm pretty sure OMAP is not unique here.)

Right, so we'd need to extend the approach for OMAP somehow.

> It also means that the binary decision of the proposed governor doesn't
> necessarily map well either (e.g., based on wake-up latency constraints,
> or HW bugs, you might allow an idle device might be able to go to
> retention, but not to off.)
> 
> I suppose one option would be to use "off" as defined here to handle all
> the !on states, and let the platform-specific code handle the details.
> However, that doesn't sound all that "generic" for a generic solution.
> 
> Another possibility would be to allow a generic power domain to have
> multiple states (or levels), with a governor hook for each state.  

That's possible.  It all depends on how the various domain states affect
devices.  For example, if device registers survive the inactive and retention
domain states, they may be regarded as substates of a more general "on" state.

Generally, my idea was to use a relatively simple hardware model, like the
shmobile one, and develop some general code that works with it and may be
extended in various ways, pretty much as we did with runtime PM.  I think the
code in this patchset is suitable for that (even on shmobile there are
more complicated power domains that will require some additional handling).

In my opinion, if wanted to start with merging something that would match
every possible hardware configuration out there, we'd end up with a 100 patches
and 10000 lines of code, or something like this.  That wouldn't be easily
mergeable, as experience shows all too well. :-)

...
> > +#ifdef CONFIG_PM_RUNTIME
> > +
> > +/**
> > + * __pm_genpd_restore_device - Restore a pre-suspend state of a device.
> > + * @dev: Device to restore the state of.
> > + * @genpd: Power domain the device belongs to.
> > + */
> > +static void __pm_genpd_restore_device(struct device *dev,
> > +				      struct generic_power_domain *genpd)
> > +{
> > +	struct device_driver *drv = dev->driver;
> > +
> > +	if (genpd->start_device)
> > +		genpd->start_device(dev);
> > +
> > +	if (drv && drv->pm && drv->pm->runtime_resume)
> > +		drv->pm->runtime_resume(dev);
> > +
> > +	if (genpd->stop_device)
> > +		genpd->stop_device(dev);
> 
> Why the ->stop_device() here?
> 
> Based on the changelog, I'm imagining an implementation of
> ->start_device() to be based on clock enable and a ->stop_device to be
> based on clock disable.  Assuming that, after this runtime resume path,
> the driver's device will still have its clocks cut.  Am I missing
> something here?

Please note that this code is executed in a loop for every device in
the power domain by __pm_genpd_poweron() (including the device whose
resume triggered powering up the domain).  At this point all the
devices remain in the "suspended" state from the runtime PM viewpoint.

> Maybe I don't understand what you mean by "pre-suspend" state.  In my
> mind, the pre-suspend state of a device would be clocks enabled.
> 
> Similar question below...
> 
> > +}
> > +
> > +/**
> > + * __pm_genpd_poweroff - Remove power from a given power domain.
> > + * @genpd: Power domain to power down.
> > + *
> > + * If all of the @genpd's devices have been suspended and all of its subdomains
> > + * have been powered down, run the runtime suspend callbacks provided by all of
> > + * the @genpd's devices' drivers and remove power from @genpd.
> > + */
> > +static int __pm_genpd_poweroff(struct generic_power_domain *genpd)
> > +{
> > +	struct generic_power_domain *subdomain;
> > +	struct dev_list_entry *dle;
> > +	unsigned int not_suspended;
> > +	int ret;
> > +
> > +	if (genpd->power_is_off)
> > +		return 0;
> > +
> > +	not_suspended = 0;
> > +	list_for_each_entry(dle, &genpd->device_list, node)
> > +		if (!pm_runtime_suspended(dle->dev))
> > +			not_suspended++;
> > +
> > +	if (not_suspended > genpd->in_progress)
> > +		return -EBUSY;
> > +
> > +	list_for_each_entry_reverse(subdomain, &genpd->subdomain_list, node) {
> > +		mutex_lock(&subdomain->lock);
> > +		ret = __pm_genpd_poweroff(subdomain);
> > +		mutex_unlock(&subdomain->lock);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	if (genpd->gov && genpd->gov->power_down_ok) {
> > +		if (!genpd->gov->power_down_ok(&genpd->domain))
> > +			return -EAGAIN;
> > +	}
> > +
> > +	list_for_each_entry_reverse(dle, &genpd->device_list, node) {
> > +		struct device *dev = dle->dev;
> > +		struct device_driver *drv = dev->driver;
> > +
> > +		if (genpd->start_device)
> > +			genpd->start_device(dev);
> 
> ... is the ->start_device() needed here?
> 
> Before the driver's ->runtime_suspend() method is called, I doubt it
> expects its clocks to be cut.

In fact, it does, because all of the devices must have been put into the
runtime PM's "suspended" state before that code is executed.

> Of course, having the (what seem to be) extra stop/start calls here
> doesn't harm anything.  But if the ->[start|stop]_device() calls are
> expensive for a given platform, the extra overhead might be significant
> for frequent runtime PM transitions.

If the entire domain is frequently powered up and down, then I agree it will
be expensive.  However, that's kind of to be expected, isn't it? ;-)

The code could be optimized to avoid starting and stopping the device that
triggers the domain poweroff, but that would make it more complicated, which
I intentionally wanted to avoid at this stage.

Again, this code is meant as a starting point for more complicated things.
How complicated they will turn out to be in the end, I can't tell right now. :-)

Thanks,
Rafael
