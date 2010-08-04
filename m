Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0HDTq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:46:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:37979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab0HDTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:46:25 -0400
Date: Wed, 4 Aug 2010 12:43:19 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] RFC: AMBA bus discardable probe() function
Message-ID: <20100804194319.GA30722@suse.de>
References: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 02:39:03PM +0200, Linus Walleij wrote:
> Fighting a compilation warning when using __init on probe():s in
> the AMBA (PrimeCell) bus abstraction, the intended effect of
> discarding AMBA probe():s is not achieveable without first adding
> the amba_driver_probe() function akin to platform_driver_probe().
> 
> The latter does some extensive checks which I believe are
> necessary to replicate, and leads to this nasty hack,
> dereferencing structs from base/base.h like the platform bus does.

Ick, no, don't do that :(

> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index d31590e..2a4c88f 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -18,6 +18,9 @@
>  #include <asm/irq.h>
>  #include <asm/sizes.h>
>  
> +/* Cross referencing the private driver core like the platform bus does */
> +#include "../base/base.h"

Nope, sorry, not allowed.  This should be your first flag that something
is wrong here.

The platform bus does this because it is part of the driver core, and it
does other fun things.  This should never be needed for any other bus.
Note how no other bus needs to do this, so that should be a hint that
it's wrong.

> +static int amba_driver_probe_fail(struct device *_dev)
> +{
> +	return -ENXIO;
> +}
> +
> +
> +/**
> + * amba_driver_probe - register AMBA driver for non-hotpluggable device
> + * @drv: platform driver structure
> + * @probe: the driver probe routine, probably from an __init section
> + *
> + * Use this instead of amba_driver_register() when you know the device
> + * is not hotpluggable and has already been registered, and you want to
> + * remove its run-once probe() infrastructure from memory after the driver
> + * has bound to the device.

Is that _really_ worth it?  Come on, how much memory are you saving
here?

> + * One typical use for this would be with drivers for controllers integrated
> + * into system-on-chip processors, where the controller devices have been
> + * configured as part of board setup.
> + *
> + * Returns zero if the driver registered and bound to a device, else returns
> + * a negative error code and with the driver not registered.
> + */
> +int __init_or_module amba_driver_probe(struct amba_driver *drv,
> +		int (*probe)(struct amba_device *,
> +		struct amba_id *))
> +{
> +	int retval, code;
> +
> +	/* make sure driver won't have bind/unbind attributes */
> +	drv->drv.suppress_bind_attrs = true;
> +
> +	/* temporary section violation during probe() */
> +	drv->probe = probe;
> +	retval = code = amba_driver_register(drv);
> +
> +	/*
> +	 * Fixup that section violation, being paranoid about code scanning
> +	 * the list of drivers in order to probe new devices.  Check to see
> +	 * if the probe was successful, and make sure any forced probes of
> +	 * new devices fail.
> +	 */
> +	spin_lock(&amba_bustype.p->klist_drivers.k_lock);

Ick, nope, you can't do this, sorry.  That's a "private" structure for a
reason.

So what's the real driving force here, just saving a few hundred bytes
after booting?  Or something else?

thanks,

greg k-h
