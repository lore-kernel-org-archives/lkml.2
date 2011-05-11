Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab1EKQPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:15:31 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:43201 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176Ab1EKQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:15:28 -0400
Subject: Re: [Update][RFC][PATCH 1/2] PM / Runtime: Support for generic I/O
 power domains (v2)
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
In-Reply-To: <201104300254.46973.rjw@sisk.pl>
References: <201104290154.12966.rjw@sisk.pl>
	 <201104290154.56145.rjw@sisk.pl>  <201104300254.46973.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments, Inc.
Date: Wed, 11 May 2011 09:26:41 +0200
Message-ID: <1305098801.4642.6.camel@vence>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sat, 2011-04-30 at 02:54 +0200, Rafael J. Wysocki wrote: 
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introcude common headers, helper functions and callbacks allowing
> platforms to use simple generic power domains for runtime power
> management.
> 
> Introduce struct generic_power_domain to be used for representing
> power domains that each contain a number of devices and may be
> master domains or subdomains with respect to other power domains.
> Among other things, this structure includes callbacks to be
> provided by platforms for performing specific tasks related to
> power management (i.e. ->stop_device() may disable a device's
> clocks, while ->start_device() may enable them, ->power_on() is
> supposed to remove power from the entire power domain
> and ->power_off() is supposed to restore it).
>
> Introduce functions that can be used as power domain runtime PM
> callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> as well as helper functions for the initialization of a power
> domain represented by a struct generic_power_domain object,
> adding a device to or removing a device from it and adding or
> removing subdomains.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks for proposing this.  It looks like a good starting point.  I
haven't had the time to experiment with it on OMAP yet due to
travel/conferences, but here's at least a few comments and questions
after a brief review.

This looks like a good start for an abstraction, but I'm not sure if can
be broadly useful without some further complications.

On many SoCs, a HW power domain has more than 2 states.  On OMAP for
example, a power domain can be on, inactive, retention or off.
Therefore, the 2-state approach in this patch doesn't really map well to
hardware power domains (and I'm pretty sure OMAP is not unique here.)
It also means that the binary decision of the proposed governor doesn't
necessarily map well either (e.g., based on wake-up latency constraints,
or HW bugs, you might allow an idle device might be able to go to
retention, but not to off.)

I suppose one option would be to use "off" as defined here to handle all
the !on states, and let the platform-specific code handle the details.
However, that doesn't sound all that "generic" for a generic solution.

Another possibility would be to allow a generic power domain to have
multiple states (or levels), with a governor hook for each state.  

> ---
> 
> Hi,
> 
> This version of the patch fixes a bug that caused pm_runtime_suspend()
> (and equivalent) to return -EBUSY erroneously when suspending the last
> active device in a power domain.  It has been tested on an ARM shmobile
> system.
> 
> Greg, I hope your ACK is still valid. :-)
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/base/power/Makefile |    2 
>  drivers/base/power/domain.c |  439 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pm.h          |    3 
>  include/linux/pm_domain.h   |   83 ++++++++
>  4 files changed, 525 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/include/linux/pm_domain.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/pm_domain.h
> @@ -0,0 +1,83 @@
> +/*
> + * pm_domain.h - Definitions and headers related to device power domains.
> + *
> + * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
> + *
> + * This file is released under the GPLv2.
> + */
> +
> +#ifndef _LINUX_PM_DOMAIN_H
> +#define _LINUX_PM_DOMAIN_H
> +
> +#include <linux/device.h>
> +
> +struct dev_power_governor {
> +	bool (*power_down_ok)(struct dev_power_domain *domain);
> +};
> +
> +struct generic_power_domain {
> +	struct dev_power_domain domain;
> +	struct list_head node;
> +	struct generic_power_domain *master;
> +	struct list_head subdomain_list;
> +	struct list_head device_list;
> +	struct mutex lock;
> +	struct dev_power_governor *gov;
> +	unsigned int in_progress;
> +	bool power_is_off;
> +	int (*power_off)(struct dev_power_domain *domain);
> +	int (*power_on)(struct dev_power_domain *domain);
> +	int (*start_device)(struct device *dev);
> +	int (*stop_device)(struct device *dev);
> +};
> +
> +struct dev_list_entry {
> +	struct list_head node;
> +	struct device *dev;
> +};
> +
> +#ifdef CONFIG_PM_RUNTIME
> +extern int pm_genpd_runtime_suspend(struct device *dev);
> +extern int pm_genpd_runtime_resume(struct device *dev);
> +#else
> +#define pm_genpd_runtime_suspend	NULL;
> +#define pm_genpd_runtime_resume	NULL;
> +#endif
> +
> +#ifdef CONFIG_PM
> +extern int pm_genpd_add_device(struct generic_power_domain *genpd,
> +			       struct device *dev);
> +extern int pm_genpd_remove_device(struct generic_power_domain *genpd,
> +				  struct device *dev);
> +extern int pm_genpd_add_subdomain(struct generic_power_domain *genpd,
> +				  struct generic_power_domain *new_subdomain);
> +extern int pm_genpd_remove_subdomain(struct generic_power_domain *genpd,
> +				     struct generic_power_domain *target);
> +extern void pm_genpd_init(struct generic_power_domain *genpd,
> +			  struct dev_power_governor *gov, bool is_off);
> +#else
> +static inline int pm_genpd_add_device(struct generic_power_domain *genpd,
> +				      struct device *dev)
> +{
> +	return -ENOSYS;
> +}
> +static inline int pm_genpd_remove_device(struct generic_power_domain *genpd,
> +					 struct device *dev)
> +{
> +	return -ENOSYS;
> +}
> +static inline int pm_genpd_add_subdomain(struct generic_power_domain *genpd,
> +					 struct generic_power_domain *new_sd)
> +{
> +	return -ENOSYS;
> +}
> +static inline int pm_genpd_remove_subdomain(struct generic_power_domain *genpd,
> +					    struct generic_power_domain *target)
> +{
> +	return -ENOSYS;
> +}
> +static inline void pm_genpd_init(struct generic_power_domain *genpd,
> +				 struct dev_power_governor *gov, bool is_off) {}
> +#endif
> +
> +#endif /* _LINUX_PM_DOMAIN_H */
> Index: linux-2.6/include/linux/pm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pm.h
> +++ linux-2.6/include/linux/pm.h
> @@ -472,7 +472,8 @@ extern void update_pm_runtime_accounting
>   * subsystem-level and driver-level callbacks.
>   */
>  struct dev_power_domain {
> -	struct dev_pm_ops	ops;
> +	struct dev_pm_ops ops;
> +	void *platform_data;
>  };
>  
>  /*
> Index: linux-2.6/drivers/base/power/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/Makefile
> +++ linux-2.6/drivers/base/power/Makefile
> @@ -1,4 +1,4 @@
> -obj-$(CONFIG_PM)	+= sysfs.o generic_ops.o
> +obj-$(CONFIG_PM)	+= sysfs.o generic_ops.o domain.o
>  obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
>  obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
>  obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
> Index: linux-2.6/drivers/base/power/domain.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/base/power/domain.c
> @@ -0,0 +1,439 @@
> +/*
> + * drivers/base/power/domain.c - Common code related to device power domains.
> + *
> + * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
> + *
> + * This file is released under the GPLv2.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/pm_domain.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +
> +#ifdef CONFIG_PM_RUNTIME
> +
> +/**
> + * __pm_genpd_restore_device - Restore a pre-suspend state of a device.
> + * @dev: Device to restore the state of.
> + * @genpd: Power domain the device belongs to.
> + */
> +static void __pm_genpd_restore_device(struct device *dev,
> +				      struct generic_power_domain *genpd)
> +{
> +	struct device_driver *drv = dev->driver;
> +
> +	if (genpd->start_device)
> +		genpd->start_device(dev);
> +
> +	if (drv && drv->pm && drv->pm->runtime_resume)
> +		drv->pm->runtime_resume(dev);
> +
> +	if (genpd->stop_device)
> +		genpd->stop_device(dev);

Why the ->stop_device() here?

Based on the changelog, I'm imagining an implementation of
->start_device() to be based on clock enable and a ->stop_device to be
based on clock disable.  Assuming that, after this runtime resume path,
the driver's device will still have its clocks cut.  Am I missing
something here?

Maybe I don't understand what you mean by "pre-suspend" state.  In my
mind, the pre-suspend state of a device would be clocks enabled.

Similar question below...

> +}
> +
> +/**
> + * __pm_genpd_poweroff - Remove power from a given power domain.
> + * @genpd: Power domain to power down.
> + *
> + * If all of the @genpd's devices have been suspended and all of its subdomains
> + * have been powered down, run the runtime suspend callbacks provided by all of
> + * the @genpd's devices' drivers and remove power from @genpd.
> + */
> +static int __pm_genpd_poweroff(struct generic_power_domain *genpd)
> +{
> +	struct generic_power_domain *subdomain;
> +	struct dev_list_entry *dle;
> +	unsigned int not_suspended;
> +	int ret;
> +
> +	if (genpd->power_is_off)
> +		return 0;
> +
> +	not_suspended = 0;
> +	list_for_each_entry(dle, &genpd->device_list, node)
> +		if (!pm_runtime_suspended(dle->dev))
> +			not_suspended++;
> +
> +	if (not_suspended > genpd->in_progress)
> +		return -EBUSY;
> +
> +	list_for_each_entry_reverse(subdomain, &genpd->subdomain_list, node) {
> +		mutex_lock(&subdomain->lock);
> +		ret = __pm_genpd_poweroff(subdomain);
> +		mutex_unlock(&subdomain->lock);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (genpd->gov && genpd->gov->power_down_ok) {
> +		if (!genpd->gov->power_down_ok(&genpd->domain))
> +			return -EAGAIN;
> +	}
> +
> +	list_for_each_entry_reverse(dle, &genpd->device_list, node) {
> +		struct device *dev = dle->dev;
> +		struct device_driver *drv = dev->driver;
> +
> +		if (genpd->start_device)
> +			genpd->start_device(dev);

... is the ->start_device() needed here?

Before the driver's ->runtime_suspend() method is called, I doubt it
expects its clocks to be cut.

Of course, having the (what seem to be) extra stop/start calls here
doesn't harm anything.  But if the ->[start|stop]_device() calls are
expensive for a given platform, the extra overhead might be significant
for frequent runtime PM transitions.

Kevin


