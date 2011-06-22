Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab1FVAGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:06:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47931 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342Ab1FVAGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:06:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [Update][PATCH 4/8] PM / Domains: Support for generic I/O PM domains (v6)
Date: Wed, 22 Jun 2011 02:07:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <201106112223.04972.rjw@sisk.pl> <201106200002.19377.rjw@sisk.pl> <874o3jt72c.fsf@ti.com>
In-Reply-To: <874o3jt72c.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106220207.01434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 21, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Introduce common headers, helper functions and callbacks allowing
> > platforms to use simple generic power domains for runtime power
> > management.
> >
> > Introduce struct generic_pm_domain to be used for representing
> > power domains that each contain a number of devices and may be
> > parent domains or subdomains with respect to other power domains.
> > Among other things, this structure includes callbacks to be
> > provided by platforms for performing specific tasks related to
> > power management (i.e. ->stop_device() may disable a device's
> > clocks, while ->start_device() may enable them, ->power_off() is
> > supposed to remove power from the entire power domain
> > and ->power_on() is supposed to restore it).
> >
> > Introduce functions that can be used as power domain runtime PM
> > callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> > as well as helper functions for the initialization of a power
> > domain represented by a struct generic_power_domain object,
> > adding a device to or removing a device from it and adding or
> > removing subdomains.
> >
> > Introduce configuration option CONFIG_PM_GENERIC_DOMAINS to be
> > selected by the platforms that want to use the new code.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >
> > Hi,
> >
> > I this version of the patch I made the following modifications:
> >
> > * Removed the change adding platform_data to struct dev_pm_domain,
> >   because that field is not going to be necessary in the near future.
> >
> > * Moved the code calling drv->pm->runtime_suspend(dev) to a separate
> >   function that returns immediately if dle->need_restore is set for the
> >   given device (meaning that drv->pm->runtime_suspend(dev) has already
> >   been called for it and the corresponding ->runtime_resume() hasn't).
> >   This fixes a bug where drv->pm->runtime_suspend() could be called for
> >   a device whose state hasn't been restored after power cycling its
> >   PM domain.
> >
> > * Made pm_genpd_add_device() return error code on an attempt to add a device
> >   do a PM domain whose power_is_off is set (that complemets the previous
> >   modification).
> >
> > * Makde the .power_on() and .power_off() generic PM domain callbacks take
> >   (struct generic_pm_domain *) arguments instead of (struct dev_pm_domain *).
> >
> > Thanks,
> > Rafael
> 
> There's a guiding assumption in this generic PM domain layer that the
> runtime PM callbacks need only be called if power to the underlying PM
> domain is actually being cut.  As a result, devices no longer have a
> callback called for other low-power states where the power may not
> actually be cut (a.k.a low-power with memory & logic retention.)
> 
> However, there are devices (at least on OMAP, but I presume on all SoCs)
> where the driver will need to do other "stuff" for *all* low-power
> transitions, not just the power-off ones (e.g. device specific idle mode
> registers, clearing device-specific events/state that prevent low power
> transitions, etc.)
> 
> Because of this, I don't currently see how to use these generic PM
> domains on devices with multiple power states since the runtime PM
> callbacks are only called for a subset of the power states.
> 
> I haven't given this too much thought yet (especially the system PM
> aspects), but in order for generic PM domains to be more broadly useful
> for runtime PM, I'm starting to think that this series should add
> another set of callbacks: .power_off, .power_on or something similar.
> The .runtime_suspend/.runtime_resume callbacks would then be used for
> all power states and the .power_off/.power_on callbacks used only when
> power is actually cut.

Well, I _really_ would like to avoid adding more callbacks to struct
dev_pm_ops, if that's what you mean, because we already seem to have
problems with managing the existing ones.

Also, IMO, you can always map every system with more power states to the
model where there are only "device active" (runtime PM RPM_ACTIVE) "device
stopped" (runtime PM RPM_SUSPENDED, need not save state) and "device
power off" (runtime PM RPM_SUSPENDED, must save state) "software" states
represented here.

If anything more fine grained is necessary or useful, I'd say you need a
more complicated model, but I'd prefer to avoid further complications in this
patchset.

> [...]
> 
> > Index: linux-2.6/drivers/base/power/domain.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/drivers/base/power/domain.c
> > @@ -0,0 +1,490 @@
> > +/*
> > + * drivers/base/power/domain.c - Common code related to device power domains.
> > + *
> > + * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
> > + *
> > + * This file is released under the GPLv2.
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/io.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/pm_domain.h>
> > +#include <linux/slab.h>
> > +#include <linux/err.h>
> > +
> > +#ifdef CONFIG_PM_RUNTIME
> > +
> > +static void genpd_sd_counter_dec(struct generic_pm_domain *genpd)
> > +{
> > +	if (!WARN_ON(genpd->sd_count == 0))
> > +			genpd->sd_count--;
> > +}
> > +
> > +/**
> > + * __pm_genpd_save_device - Save the pre-suspend state of a device.
> > + * @dle: Device list entry of the device to save the state of.
> > + * @genpd: PM domain the device belongs to.
> > + */
> > +static int __pm_genpd_save_device(struct dev_list_entry *dle,
> > +				  struct generic_pm_domain *genpd)
> > +{
> > +	struct device *dev = dle->dev;
> > +	struct device_driver *drv = dev->driver;
> > +	int ret = 0;
> > +
> > +	if (dle->need_restore)
> > +		return 0;
> > +
> > +	if (genpd->start_device)
> > +		genpd->start_device(dev);
> > +
> > +	if (drv && drv->pm && drv->pm->runtime_suspend)
> 
> The start/stop device calls should probably be included inside this 'if'
> since there's no reason to restart and re-stop the device if there is no
> callback to be run.

That's a good point, I'll do that.

> Some drivers have alterntive ways of saving context (shadow registers,
> manual save/restore per-xfer, etc.) and thus have no callbacks for
> context save/restore.
> 
> > +		ret = drv->pm->runtime_suspend(dev);
> > +
> > +	if (genpd->stop_device)
> > +		genpd->stop_device(dev);
> > +
> > +	if (!ret)
> > +		dle->need_restore = true;
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * __pm_genpd_restore_device - Restore the pre-suspend state of a device.
> > + * @dle: Device list entry of the device to restore the state of.
> > + * @genpd: PM domain the device belongs to.
> > + */
> > +static void __pm_genpd_restore_device(struct dev_list_entry *dle,
> > +				      struct generic_pm_domain *genpd)
> > +{
> > +	struct device *dev = dle->dev;
> > +	struct device_driver *drv = dev->driver;
> > +
> > +	if (!dle->need_restore)
> > +		return;
> > +
> > +	if (genpd->start_device)
> > +		genpd->start_device(dev);
> > +
> > +	if (drv && drv->pm && drv->pm->runtime_resume)
> 
> Similar to the 'save' case, the start/stop device calls should also be
> included inside this 'if'.

Agreed.

> > +		drv->pm->runtime_resume(dev);
> > +
> > +	if (genpd->stop_device)
> > +		genpd->stop_device(dev);
> > +
> > +	dle->need_restore = false;
> > +}

Thanks for the comments, I'm going to implement your suggestions.

Take care,
Rafael
