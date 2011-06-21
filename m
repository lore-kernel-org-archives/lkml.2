Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1FURm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:42:27 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:37871 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082Ab1FURmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:42:24 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [Update][PATCH 4/8] PM / Domains: Support for generic I/O PM domains (v6)
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201106112231.11269.rjw@sisk.pl>
	<201106200002.19377.rjw@sisk.pl>
Date: Tue, 21 Jun 2011 10:42:19 -0700
In-Reply-To: <201106200002.19377.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 20 Jun 2011 00:02:19 +0200")
Message-ID: <874o3jt72c.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Introduce common headers, helper functions and callbacks allowing
> platforms to use simple generic power domains for runtime power
> management.
>
> Introduce struct generic_pm_domain to be used for representing
> power domains that each contain a number of devices and may be
> parent domains or subdomains with respect to other power domains.
> Among other things, this structure includes callbacks to be
> provided by platforms for performing specific tasks related to
> power management (i.e. ->stop_device() may disable a device's
> clocks, while ->start_device() may enable them, ->power_off() is
> supposed to remove power from the entire power domain
> and ->power_on() is supposed to restore it).
>
> Introduce functions that can be used as power domain runtime PM
> callbacks, pm_genpd_runtime_suspend() and pm_genpd_runtime_resume(),
> as well as helper functions for the initialization of a power
> domain represented by a struct generic_power_domain object,
> adding a device to or removing a device from it and adding or
> removing subdomains.
>
> Introduce configuration option CONFIG_PM_GENERIC_DOMAINS to be
> selected by the platforms that want to use the new code.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>
> Hi,
>
> I this version of the patch I made the following modifications:
>
> * Removed the change adding platform_data to struct dev_pm_domain,
>   because that field is not going to be necessary in the near future.
>
> * Moved the code calling drv->pm->runtime_suspend(dev) to a separate
>   function that returns immediately if dle->need_restore is set for the
>   given device (meaning that drv->pm->runtime_suspend(dev) has already
>   been called for it and the corresponding ->runtime_resume() hasn't).
>   This fixes a bug where drv->pm->runtime_suspend() could be called for
>   a device whose state hasn't been restored after power cycling its
>   PM domain.
>
> * Made pm_genpd_add_device() return error code on an attempt to add a device
>   do a PM domain whose power_is_off is set (that complemets the previous
>   modification).
>
> * Makde the .power_on() and .power_off() generic PM domain callbacks take
>   (struct generic_pm_domain *) arguments instead of (struct dev_pm_domain *).
>
> Thanks,
> Rafael

There's a guiding assumption in this generic PM domain layer that the
runtime PM callbacks need only be called if power to the underlying PM
domain is actually being cut.  As a result, devices no longer have a
callback called for other low-power states where the power may not
actually be cut (a.k.a low-power with memory & logic retention.)

However, there are devices (at least on OMAP, but I presume on all SoCs)
where the driver will need to do other "stuff" for *all* low-power
transitions, not just the power-off ones (e.g. device specific idle mode
registers, clearing device-specific events/state that prevent low power
transitions, etc.)

Because of this, I don't currently see how to use these generic PM
domains on devices with multiple power states since the runtime PM
callbacks are only called for a subset of the power states.

I haven't given this too much thought yet (especially the system PM
aspects), but in order for generic PM domains to be more broadly useful
for runtime PM, I'm starting to think that this series should add
another set of callbacks: .power_off, .power_on or something similar.
The .runtime_suspend/.runtime_resume callbacks would then be used for
all power states and the .power_off/.power_on callbacks used only when
power is actually cut.

[...]

> Index: linux-2.6/drivers/base/power/domain.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/base/power/domain.c
> @@ -0,0 +1,490 @@
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
> +static void genpd_sd_counter_dec(struct generic_pm_domain *genpd)
> +{
> +	if (!WARN_ON(genpd->sd_count == 0))
> +			genpd->sd_count--;
> +}
> +
> +/**
> + * __pm_genpd_save_device - Save the pre-suspend state of a device.
> + * @dle: Device list entry of the device to save the state of.
> + * @genpd: PM domain the device belongs to.
> + */
> +static int __pm_genpd_save_device(struct dev_list_entry *dle,
> +				  struct generic_pm_domain *genpd)
> +{
> +	struct device *dev = dle->dev;
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (dle->need_restore)
> +		return 0;
> +
> +	if (genpd->start_device)
> +		genpd->start_device(dev);
> +
> +	if (drv && drv->pm && drv->pm->runtime_suspend)

The start/stop device calls should probably be included inside this 'if'
since there's no reason to restart and re-stop the device if there is no
callback to be run.

Some drivers have alterntive ways of saving context (shadow registers,
manual save/restore per-xfer, etc.) and thus have no callbacks for
context save/restore.

> +		ret = drv->pm->runtime_suspend(dev);
> +
> +	if (genpd->stop_device)
> +		genpd->stop_device(dev);
> +
> +	if (!ret)
> +		dle->need_restore = true;
> +
> +	return ret;
> +}
> +
> +/**
> + * __pm_genpd_restore_device - Restore the pre-suspend state of a device.
> + * @dle: Device list entry of the device to restore the state of.
> + * @genpd: PM domain the device belongs to.
> + */
> +static void __pm_genpd_restore_device(struct dev_list_entry *dle,
> +				      struct generic_pm_domain *genpd)
> +{
> +	struct device *dev = dle->dev;
> +	struct device_driver *drv = dev->driver;
> +
> +	if (!dle->need_restore)
> +		return;
> +
> +	if (genpd->start_device)
> +		genpd->start_device(dev);
> +
> +	if (drv && drv->pm && drv->pm->runtime_resume)

Similar to the 'save' case, the start/stop device calls should also be
included inside this 'if'.

> +		drv->pm->runtime_resume(dev);
> +
> +	if (genpd->stop_device)
> +		genpd->stop_device(dev);
> +
> +	dle->need_restore = false;
> +}

Kevin
