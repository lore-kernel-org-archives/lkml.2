Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1BXMNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:13:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1BXMN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:13:27 -0500
Date: Thu, 24 Feb 2011 09:36:24 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 1/10] Generic Watchdog Timer Driver
Message-ID: <20110224093624.GA15118@pulham.picochip.com>
References: <20110223204206.GA7138@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223204206.GA7138@infomag.iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Looks like a nice series, a couple of nitpicks inline but otherwise 
great!  Thanks for doing this, it looks like it'll make a big 
improvement to the watchdog system!

Jamie

On Wed, Feb 23, 2011 at 09:42:06PM +0100, Wim Van Sebroeck wrote:
> commit 608917b2dba29a26d352124d1371aafcd81cfb8c
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Fri Jun 18 08:40:15 2010 +0000
> 
>     watchdog: WatchDog Timer Driver Core - Part 1
>     
>     The WatchDog Timer Driver Core is a framework
>     that contains the common code for all watchdog-driver's.
>     It also introduces a watchdog device structure and the
>     operations that go with it.
>     
>     This is the introduction of this framework. This part
>     supports the minimal watchdog userspace API (or with
>     other words: the functionality to use /dev/watchdog's
>     open, release and write functionality as defined in
>     the simplest watchdog API). Extra functionality will
>     follow in the next set of patches.
>     
>     Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
> new file mode 100644
> index 0000000..d0b6056
> --- /dev/null
> +++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
> @@ -0,0 +1,210 @@
> +/*
> + * Watchdog timer driver example with timer.
> + *
> + * Copyright (C) 2009-2010 Wim Van Sebroeck <wim@iguana.be>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +/*
> + * This is an example driver where the hardware does not support
> + * stopping the watchdog timer.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/watchdog.h>
> +#include <linux/jiffies.h>
> +#include <linux/timer.h>
> +#include <linux/bitops.h>
> +#include <linux/uaccess.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +
> +#define DRV_NAME "wdt"
> +#define PFX DRV_NAME ": "

Is it worth using pr_fmt() and friends rather than printk() with 
explicit levels and prefixes throughout the code?

> +
> +/* Hardware heartbeat in seconds */
> +#define WDT_HW_HEARTBEAT 2
> +
> +/* Timer heartbeat (500ms) */
> +#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
> +
> +/* User land timeout */
> +#define WDT_TIMEOUT 15
> +static int timeout = WDT_TIMEOUT;
> +module_param(timeout, int, 0);
> +MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
> +	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
> +
> +static void wdt_timer_tick(unsigned long data);
> +static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> +					/* The timer that pings the watchdog */
> +static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
> +static unsigned long running;		/* is watchdog running for userspace? */
> +
> +static struct platform_device *wdt_platform_device;
> +
> +/*
> + * Reset the watchdog timer.  (ie, pat the watchdog)
> + */
> +static inline void wdt_reset(void)
> +{
> +	/* Reset the watchdog timer hardware here */
> +}
> +
> +/*
> + * Timer tick: the timer will make sure that the watchdog timer hardware
> + * is being reset in time. The conditions to do this are:
> + *  1) the watchog timer has been started and /dev/watchdog is open
> + *     and there is still time left before userspace should send the
> + *     next heartbeat/ping. (note: the internal heartbeat is much smaller
> + *     then the external/userspace heartbeat).
> + *  2) the watchdog timer has been stopped by userspace.
> + */
> +static void wdt_timer_tick(unsigned long data)
> +{
> +	if (time_before(jiffies, next_heartbeat) ||
> +			(!running)) {
> +		wdt_reset();
> +		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
> +	} else
> +		printk(KERN_CRIT PFX "I will reboot your machine !\n");
> +}
> +
> +/*
> + * The watchdog operations
> + */
> +static int wdt_ping(struct watchdog_device *wdd)
> +{
> +	/* calculate when the next userspace timeout will be */
> +	next_heartbeat = jiffies + timeout * HZ;
> +	return 0;
> +}
> +
> +static int wdt_start(struct watchdog_device *wdd)
> +{
> +	/* calculate the next userspace timeout and modify the timer */
> +	wdt_ping(wdd);
> +	mod_timer(&timer, jiffies + WDT_HEARTBEAT);
> +
> +	/* Start the watchdog timer hardware here */
> +	printk(KERN_INFO PFX "wdt_start\n");
> +
> +	running = 1;
> +	return 0;
> +}
> +
> +static int wdt_stop(struct watchdog_device *wdd)
> +{
> +	/* The watchdog timer hardware can not be stopped... */
> +	printk(KERN_INFO PFX "wdt_stop\n");
> +
> +	running = 0;
> +	return 0;
> +}
> +
> +/*
> + * The watchdog kernel structures
> + */
> +static const struct watchdog_ops wdt_ops = {
> +	.start =	wdt_start,
> +	.stop =		wdt_stop,
> +	.ping =		wdt_ping,
> +};
> +
> +static struct watchdog_device wdt_dev = {
> +	.name =		DRV_NAME,
> +	.ops =		&wdt_ops,
> +};
> +
> +/*
> + * The watchdog timer drivers init and exit routines
> + */
> +static int __devinit wdt_probe(struct platform_device *pdev)
> +{
> +	int res;
> +
> +	/* Register other stuff */
> +
> +	/* Register the watchdog timer device */
> +	res = register_watchdogdevice(&wdt_dev);
> +	if (res) {
> +		printk(KERN_ERR PFX
> +				"register_watchdogdevice returned %d\n", res);
> +		return res;
> +	}
> +
> +	printk(KERN_INFO PFX "enabled (timeout=%d sec)\n", timeout);
> +
> +	return 0;
> +}
> +
> +static int __devexit wdt_remove(struct platform_device *pdev)
> +{
> +	/* Unregister the watchdog timer device */
> +	unregister_watchdogdevice(&wdt_dev);
> +
> +	/* stop and delete the timer */
> +	printk(KERN_WARNING PFX "I quit now, hardware will probably reboot!\n");
> +	del_timer(&timer);
> +
> +	/* Unregister other stuff */
> +	return 0;
> +}
> +
> +static struct platform_driver wdt_driver = {
> +	.probe		= wdt_probe,
> +	.remove		= __devexit_p(wdt_remove),
> +	.driver		= {
> +		.name	= DRV_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init wdt_init(void)
> +{
> +	int err;
> +
> +	printk(KERN_INFO "WDT driver initialising.\n");
> +
> +	err = platform_driver_register(&wdt_driver);
> +	if (err)
> +		return err;
> +
> +	wdt_platform_device = platform_device_register_simple(DRV_NAME,
> +								-1, NULL, 0);
> +	if (IS_ERR(wdt_platform_device)) {
> +		err = PTR_ERR(wdt_platform_device);
> +		goto unreg_platform_driver;
> +	}
> +
> +	return 0;
> +
> +unreg_platform_driver:
> +	platform_driver_unregister(&wdt_driver);
> +	return err;
> +}
> +
> +static void __exit wdt_exit(void)
> +{
> +	platform_device_unregister(wdt_platform_device);
> +	platform_driver_unregister(&wdt_driver);
> +	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
> +}
> +
> +module_init(wdt_init);
> +module_exit(wdt_exit);
> +
> +MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
> +MODULE_DESCRIPTION("WatchDog Timer Driver example with timer");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:" DRV_NAME);
> diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
> new file mode 100644
> index 0000000..e69d1cc
> --- /dev/null
> +++ b/Documentation/watchdog/watchdog-kernel-api.txt
> @@ -0,0 +1,97 @@
> +The Linux WatchDog Timer Driver Core kernel API.
> +===============================================
> +Last reviewed: 09-Jun-2010
> +
> +Wim Van Sebroeck <wim@iguana.be>
> +
> +Introduction
> +------------
> +This document does not describe what a WatchDog Timer (WDT) Driver or Device is.
> +It also does not describe the API which can be used by user space to communicate
> +with a WatchDog Timer. If you want to know this then please read the following
> +file: Documentation/watchdog/watchdog-api.txt .
> +
> +So what does this document describe? It describes the API that can be used by
> +WatchDog Timer Drivers that want to use the WatchDog Timer Driver Core
> +Framework. This framework provides all interfacing towards user space so that
> +the same code does not have to be reproduced each time. This also means that
> +a watchdog timer driver then only needs to provide the different routines
> +(operations) that control the watchdog timer (WDT).
> +
> +The API
> +-------
> +Each watchdog timer driver that wants to use the WatchDog Timer Driver Core
> +must #include <linux/watchdog.h> (you would have to do this anyway when
> +writing a watchdog device driver). This include file contains following
> +register/unregister routines:
> +
> +extern int register_watchdogdevice(struct watchdog_device *);
> +extern void unregister_watchdogdevice(struct watchdog_device *);
> +
> +The register_watchdogdevice routine registers a watchdog timer device.
> +The parameter of this routine is a pointer to a watchdog_device structure.
> +This routine returns zero on success and a negative errno code for failure.
> +
> +The unregister_watchdogdevice routine deregisters a registered watchdog timer
> +device. The parameter of this routine is the pointer to the registered
> +watchdog_device structure.
> +
> +The watchdog device structure looks like this:
> +
> +struct watchdog_device {
> +	char *name;
> +	const struct watchdog_ops *ops;
> +	long status;
> +};
> +
> +It contains following fields:
> +* name: a pointer to the (preferably unique) name of the watchdog timer device.
> +* ops: a pointer to the list of watchdog operations that the watchdog supports.
> +* status: this field contains a number of status bits that give extra
> +  information about the status of the device (Like: is the device opened via
> +  the /dev/watchdog interface or not, ...)
> +
> +The list of watchdog operations is defined as:
> +
> +struct watchdog_ops {
> +	/* mandatory operations */
> +	int (*start)(struct watchdog_device *);
> +	int (*stop)(struct watchdog_device *);
> +	/* optional operations */
> +	int (*ping)(struct watchdog_device *);
> +};
> +
> +Some operations are mandatory and some are optional. The mandatory operations
> +are:
> +* start: this is a pointer to the routine that starts the watchdog timer
> +  device.
> +  The routine needs a pointer to the watchdog timer device structure as a
> +  parameter. It returns zero on success or a negative errno code for failure.
> +* stop: with this routine the watchdog timer device is being stopped.
> +  The routine needs a pointer to the watchdog timer device structure as a
> +  parameter. It returns zero on success or a negative errno code for failure.
> +  Some watchdog timer hardware can only be started and not be stopped. The
> +  driver supporting this hardware needs to make sure that a start and stop
> +  routine is being provided. This can be done by using a timer in the driver
> +  that regularly sends a keepalive ping to the watchdog timer hardware.
> +  (See Documentation/watchdog/src/watchdog-with-timer-example.c for an
> +  example).
> +
> +Not all watchdog timer hardware supports the same functionality. That's why
> +all other routines/operations are optional. They only need to be provided if
> +they are supported. These optional routines/operations are:
> +* ping: this is the routine that sends a keepalive ping to the watchdog timer
> +  hardware.
> +  The routine needs a pointer to the watchdog timer device structure as a
> +  parameter. It returns zero on success or a negative errno code for failure.
> +  Most hardware that does not support this as a separate function uses the
> +  start function to restart the watchdog timer hardware. And that's also what
> +  the watchdog timer driver core does: to send a keepalive ping to the watchdog
> +  timer hardware it will either use the ping operation (when available) or the
> +  start operation (when the ping operation is not available).
> +
> +The status bits should (preferably) be set with the set_bit and clear_bit alike
> +bit-operations. The status bit's that are defined are:
> +* WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
> +  was opened via /dev/watchdog.
> +  (This bit should only be used by the WatchDog Timer Driver Core).
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 6c216f9..15bc0de 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -37,6 +37,8 @@ config WATCHDOG_NOWAYOUT
>  	  get killed. If you say Y here, the watchdog cannot be stopped once
>  	  it has been started.
>  
> +source "drivers/watchdog/core/Kconfig"
> +
>  #
>  # General Watchdog drivers
>  #
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index d520bf9..ffdacc3 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -2,6 +2,8 @@
>  # Makefile for the WatchDog device drivers.
>  #
>  
> +obj-$(CONFIG_WATCHDOG)  += core/
> +
>  # Only one watchdog can succeed. We probe the ISA/PCI/USB based
>  # watchdog-cards first, then the architecture specific watchdog
>  # drivers and then the architecture independant "softdog" driver.
> diff --git a/drivers/watchdog/core/Kconfig b/drivers/watchdog/core/Kconfig
> new file mode 100644
> index 0000000..9a64ae2
> --- /dev/null
> +++ b/drivers/watchdog/core/Kconfig
> @@ -0,0 +1,30 @@
> +#
> +# Watchdog timer driver core
> +#
> +
> +if WATCHDOG
> +
> +config WATCHDOG_CORE
> +	tristate "WatchDog Timer Driver Core"
> +	depends on EXPERIMENTAL
> +	default m
> +	---help---
> +	  Say Y here if you want to use the new watchdog timer driver core.
> +	  This driver provides a framework for all watchdog timer drivers
> +	  and gives them the /dev/watchdog interface (and later also the
> +	  sysfs interface).
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called watchdog.
> +
> +config WATCHDOG_DEBUG_CORE
> +	bool "WatchDog Timer Driver Core debugging output"
> +	depends on WATCHDOG_CORE
> +	default n
> +	---help---
> +	  Say Y here if you want the Watchdog Timer Driver Core to
> +	  produce debugging information. Select this if you are having a
> +	  problem with the watchdog timer driver core and want to see
> +	  more of what is really happening.
> +
> +endif # WATCHDOG
> diff --git a/drivers/watchdog/core/Makefile b/drivers/watchdog/core/Makefile
> new file mode 100644
> index 0000000..30d8159
> --- /dev/null
> +++ b/drivers/watchdog/core/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for the WatchDog Timer Driver Core.
> +#
> +
> +watchdog-objs	+= watchdog_core.o watchdog_dev.o
> +obj-$(CONFIG_WATCHDOG_CORE)	+= watchdog.o
> diff --git a/drivers/watchdog/core/watchdog_core.c b/drivers/watchdog/core/watchdog_core.c
> new file mode 100644
> index 0000000..d37006c
> --- /dev/null
> +++ b/drivers/watchdog/core/watchdog_core.c
> @@ -0,0 +1,133 @@
> +/*
> + *	watchdog_core.c
> + *
> + *	(c) Copyright 2008-2010 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> + *						All Rights Reserved.
> + *
> + *	(c) Copyright 2008-2010 Wim Van Sebroeck <wim@iguana.be>.
> + *
> + *	This source code is part of the generic code that can be used
> + *	by all the watchdog timer drivers.
> + *
> + *	Based on source code of the following authors:
> + *	  Matt Domsch <Matt_Domsch@dell.com>,
> + *	  Rob Radez <rob@osinvestor.com>,
> + *	  Rusty Lynch <rusty@linux.co.intel.com>
> + *	  Satyam Sharma <satyam@infradead.org>
> + *	  Randy Dunlap <randy.dunlap@oracle.com>
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version
> + *	2 of the License, or (at your option) any later version.
> + *
> + *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
> + *	admit liability nor provide warranty for any of this software.
> + *	This material is provided "AS-IS" and at no charge.
> + */
> +
> +#include <linux/module.h>	/* For EXPORT_SYMBOL//module stuff/... */
> +#include <linux/types.h>	/* For standard types */
> +#include <linux/errno.h>	/* For the -ENODEV/... values */
> +#include <linux/kernel.h>	/* For printk/panic/... */
> +#include <linux/watchdog.h>	/* For watchdog specific items */
> +#include <linux/init.h>		/* For __init/__exit/... */
> +
> +#include "watchdog_core.h"	/* For watchdog_dev_register/... */
> +
> +/*
> + *	Version information
> + */
> +#define DRV_VERSION	"0.01"
> +#define DRV_NAME	"watchdog_core"
> +#define PFX DRV_NAME	": "
> +
> +/**
> + *	register_watchdogdevice	-	register a watchdog device
> + *	@wdd: watchdog device
> + *
> + *	Register a watchdog device with the kernel so that the
> + *	watchdog timer can be accessed from userspace.
> + *
> + *	A zero is returned on success and a negative errno code for
> + *	failure.
> + */
> +int register_watchdogdevice(struct watchdog_device *wdd)
> +{
> +	int ret;
> +
> +	/* Make sure we have a valid watchdog_device structure */
> +	if (wdd == NULL || wdd->ops == NULL)
> +		return -ENODATA;
> +
> +	/* Make sure that the mandatory operations are supported */
> +	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
> +		return -ENODATA;
> +
> +	/* Note: now that all watchdog_device data has been verified, we
> +	 * will not check this anymore in other functions. If data get's
> +	 * corrupted in a later stage then we expect a kernel panic! */
> +
> +	/* The future version will have to manage a list of all
> +	 * registered watchdog devices. To start we will only
> +	 * support 1 watchdog device via the /dev/watchdog interface */
> +
> +	/* create the /dev/watchdog interface */
> +	ret = watchdog_dev_register(wdd);
> +	if (ret) {
> +		printk(KERN_ERR PFX "error registering /dev/watchdog (err=%d)",
> +			ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}

Should this function also take a reference on the module implementing 
the driver?  Perhaps add a 'struct module *owner' to the 'struct 
watchdog_ops' and do a try_module_get() here?  We'd also need the 
corresponding module_put() in unregister_watchdogdevice().

> +EXPORT_SYMBOL(register_watchdogdevice);
> +
> +/**
> + *	unregister_watchdogdevice	-	unregister a watchdog device
> + *	@wdd: watchdog device to unregister
> + *
> + *	Unregister a watchdog device that was previously successfully
> + *	registered with register_watchdogdevice().
> + */
> +void unregister_watchdogdevice(struct watchdog_device *wdd)
> +{
> +	int ret;
> +
> +	/* Make sure we have a valid watchdog_device structure */
> +	if (wdd == NULL)
> +		return;
> +
> +	/* The future version will check if this watchdog can be found
> +	 * in the list of registered watchdog devices */
> +
> +	/* remove the /dev/watchdog interface */
> +	ret = watchdog_dev_unregister(wdd);
> +	if (ret)
> +		printk(KERN_ERR PFX
> +			"error unregistering /dev/watchdog (err=%d)", ret);
> +}
> +EXPORT_SYMBOL(unregister_watchdogdevice);
> +
> +static int __init watchdog_init(void)
> +{
> +	printk(KERN_INFO "Watchdog timer driver core v%s loaded\n",
> +		DRV_VERSION);
> +	return 0;
> +}
> +
> +static void __exit watchdog_exit(void)
> +{
> +	printk(KERN_INFO "Watchdog timer driver core unloaded\n");
> +}
> +
> +module_init(watchdog_init);
> +module_exit(watchdog_exit);
> +
> +MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>, "
> +		"Wim Van Sebroeck <wim@iguana.be>");
> +MODULE_DESCRIPTION("WatchDog Timer Driver Core");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("watchdog");
> diff --git a/drivers/watchdog/core/watchdog_core.h b/drivers/watchdog/core/watchdog_core.h
> new file mode 100644
> index 0000000..bc11d3c
> --- /dev/null
> +++ b/drivers/watchdog/core/watchdog_core.h
> @@ -0,0 +1,33 @@
> +/*
> + *	watchdog_core.h
> + *
> + *	(c) Copyright 2008-2010 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> + *						All Rights Reserved.
> + *
> + *	(c) Copyright 2008-2010 Wim Van Sebroeck <wim@iguana.be>.
> + *
> + *	This source code is part of the generic code that can be used
> + *	by all the watchdog timer drivers.
> + *
> + *	Based on source code of the following authors:
> + *	  Matt Domsch <Matt_Domsch@dell.com>,
> + *	  Rob Radez <rob@osinvestor.com>,
> + *	  Rusty Lynch <rusty@linux.co.intel.com>
> + *	  Satyam Sharma <satyam@infradead.org>
> + *	  Randy Dunlap <randy.dunlap@oracle.com>
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version
> + *	2 of the License, or (at your option) any later version.
> + *
> + *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
> + *	admit liability nor provide warranty for any of this software.
> + *	This material is provided "AS-IS" and at no charge.
> + */
> +
> +/*
> + *	External functions/procedures
> + */
> +extern int watchdog_dev_register(struct watchdog_device *);
> +extern int watchdog_dev_unregister(struct watchdog_device *);
> diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
> new file mode 100644
> index 0000000..881ca42
> --- /dev/null
> +++ b/drivers/watchdog/core/watchdog_dev.c
> @@ -0,0 +1,281 @@
> +/*
> + *	watchdog_dev.c
> + *
> + *	(c) Copyright 2008-2010 Alan Cox <alan@lxorguk.ukuu.org.uk>,
> + *						All Rights Reserved.
> + *
> + *	(c) Copyright 2008-2010 Wim Van Sebroeck <wim@iguana.be>.
> + *
> + *
> + *	This source code is part of the generic code that can be used
> + *	by all the watchdog timer drivers.
> + *
> + *	This part of the generic code takes care of the following
> + *	misc device: /dev/watchdog.
> + *
> + *	Based on source code of the following authors:
> + *	  Matt Domsch <Matt_Domsch@dell.com>,
> + *	  Rob Radez <rob@osinvestor.com>,
> + *	  Rusty Lynch <rusty@linux.co.intel.com>
> + *	  Satyam Sharma <satyam@infradead.org>
> + *	  Randy Dunlap <randy.dunlap@oracle.com>
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version
> + *	2 of the License, or (at your option) any later version.
> + *
> + *	Neither Alan Cox, CymruNet Ltd., Wim Van Sebroeck nor Iguana vzw.
> + *	admit liability nor provide warranty for any of this software.
> + *	This material is provided "AS-IS" and at no charge.
> + */
> +
> +#include <linux/module.h>	/* For EXPORT_SYMBOL/module stuff/... */
> +#include <linux/types.h>	/* For standard types (like size_t) */
> +#include <linux/errno.h>	/* For the -ENODEV/... values */
> +#include <linux/kernel.h>	/* For printk/panic/... */
> +#include <linux/fs.h>		/* For file operations */
> +#include <linux/watchdog.h>	/* For watchdog specific items */
> +#include <linux/miscdevice.h>	/* For handling misc devices */
> +#include <linux/init.h>		/* For __init/__exit/... */
> +#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
> +
> +/*
> + *	Version information
> + */
> +#define DRV_VERSION	"0.01"
> +#define DRV_NAME	"watchdog_dev"
> +#define PFX DRV_NAME	": "
> +
> +/*
> + *	Debugging Macros
> + */
> +#ifdef CONFIG_WATCHDOG_DEBUG_CORE
> +#define trace(format, args...) \
> +	printk(KERN_INFO PFX "%s(" format ")\n", __func__ , ## args)
> +#define dbg(format, args...) \
> +	printk(KERN_DEBUG PFX "%s: " format "\n", __func__, ## args)
> +#else
> +#define trace(format, args...) do { } while (0)
> +#define dbg(format, args...) do { } while (0)
> +#endif
> +
> +/*
> + *	Locally used variables
> + */
> +
> +/* make sure we only register one /dev/watchdog device */
> +static unsigned long register_busy;

I first read this to mean that a registration was in progress not that a 
watchdog is registered.  Rename to watchdog_is_registered or similar?

> +/* the watchdog device behind /dev/watchdog */
> +static struct watchdog_device *wdd;
> +
> +/*
> + *	/dev/watchdog operations
> + */
> +
> +/*
> + *	watchdog_ping: ping the watchdog.
> + *	@wddev: the watchdog device to ping
> + *
> + *	If the watchdog has no own ping operation then it needs to be
> + *	restarted via the start operation. This wrapper function does
> + *	exactly that.
> + */
> +
> +static int watchdog_ping(struct watchdog_device *wddev)
> +{
> +	if (wddev->ops->ping)
> +		return wddev->ops->ping(wddev);  /* ping the watchdog */
> +	else
> +		return wddev->ops->start(wddev); /* restart the watchdog */
> +}
> +
> +/*
> + *	watchdog_write: writes to the watchdog.
> + *	@file: file from VFS
> + *	@data: user address of data
> + *	@len: length of data
> + *	@ppos: pointer to the file offset
> + *
> + *	A write to a watchdog device is defined as a keepalive ping.
> + */
> +
> +static ssize_t watchdog_write(struct file *file, const char __user *data,
> +						size_t len, loff_t *ppos)
> +{
> +	size_t i;
> +	char c;
> +
> +	trace("%p, %p, %zu, %p", file, data, len, ppos);
> +
> +	if (len == 0)	/* Can we see this even ? */
> +		return 0;
> +
> +	for (i = 0; i != len; i++) {
> +		if (get_user(c, data + i))
> +			return -EFAULT;
> +	}

Shouldn't this loop be added in the patch where you add the magic close 
support?

> +
> +	/* someone wrote to us, so we sent the watchdog a keepalive ping */
> +	watchdog_ping(wdd);
> +
> +	return len;
> +}
> +
> +/*
> + *	watchdog_open: open the /dev/watchdog device.
> + *	@inode: inode of device
> + *	@file: file handle to device
> + *
> + *	When the /dev/watchdog device get's opened, we start the watchdog.
> + *	Watch out: the /dev/watchdog device is single open, so we make sure
> + *	it can only be opened once.
> + */
> +
> +static int watchdog_open(struct inode *inode, struct file *file)
> +{
> +	int err;
> +
> +	trace("%p, %p", inode, file);
> +
> +	/* the watchdog is single open! */
> +	if (test_and_set_bit(WDOG_DEV_OPEN, &wdd->status))
> +		return -EBUSY;
> +
> +	/* start the watchdog */
> +	err = wdd->ops->start(wdd);
> +	if (err < 0)
> +		goto out;
> +
> +	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
> +	return nonseekable_open(inode, file);
> +
> +out:
> +	clear_bit(WDOG_DEV_OPEN, &wdd->status);
> +	return err;
> +}
> +
> +/*
> + *      watchdog_release: release the /dev/watchdog device.
> + *      @inode: inode of device
> + *      @file: file handle to device
> + *
> + *	This is the code for when /dev/watchdog get's closed.
> + */
> +
> +static int watchdog_release(struct inode *inode, struct file *file)
> +{
> +	int err = -1;
> +
> +	trace("%p, %p", inode, file);
> +
> +	/* stop the watchdog */
> +	err = wdd->ops->stop(wdd);
> +	if (err != 0) {
> +		printk(KERN_CRIT "%s: not stopping watchdog!\n", wdd->name);
> +		watchdog_ping(wdd);
> +	}
> +
> +	/* make sure that /dev/watchdog can be re-opened */
> +	clear_bit(WDOG_DEV_OPEN, &wdd->status);
> +
> +	return 0;
> +}
> +
> +/*
> + *	/dev/watchdog kernel interfaces
> + */
> +
> +static const struct file_operations watchdog_fops = {
> +	.owner		= THIS_MODULE,
> +	.llseek		= no_llseek,
> +	.write		= watchdog_write,
> +	.open		= watchdog_open,
> +	.release	= watchdog_release,
> +};
> +
> +static struct miscdevice watchdog_miscdev = {
> +	.minor		= WATCHDOG_MINOR,
> +	.name		= "watchdog",
> +	.fops		= &watchdog_fops,
> +};
> +
> +/*
> + *	/dev/watchdog register and unregister functions
> + */
> +
> +/*
> + *	watchdog_dev_register:
> + *	@watchdog: watchdog device
> + *
> + *	Register a watchdog device as /dev/watchdog. /dev/watchdog
> + *	is actually a miscdevice and thus we set it up like that.
> + */
> +
> +int watchdog_dev_register(struct watchdog_device *watchdog)
> +{
> +	int err;
> +
> +	trace("%p", watchdog);
> +
> +	/* Only one device can register for /dev/watchdog */
> +	if (test_and_set_bit(0, &register_busy)) {
> +		printk(KERN_ERR PFX
> +			"only one watchdog can use /dev/watchdog.\n");
> +		return -EBUSY;
> +	}
> +
> +	wdd = watchdog;
> +
> +	/* Register the miscdevice */
> +	dbg("Register a new /dev/watchdog device");
> +	err = misc_register(&watchdog_miscdev);
> +	if (err != 0) {
> +		printk(KERN_ERR
> +			"%s: cannot register miscdev on minor=%d (err=%d).\n",
> +			watchdog->name, WATCHDOG_MINOR, err);
> +		goto out;
> +	}
> +
> +	return 0;
> +
> +out:
> +	wdd = NULL;
> +	clear_bit(0, &register_busy);
> +	return err;
> +}
> +EXPORT_SYMBOL(watchdog_dev_register);
> +
> +/*
> + *	watchdog_dev_unregister:
> + *	@watchdog: watchdog device
> + *
> + *	Deregister the /dev/watchdog device.
> + */
> +
> +int watchdog_dev_unregister(struct watchdog_device *watchdog)
> +{
> +	trace("%p", watchdog);
> +
> +	/* Check that a watchdog device was registered in the past */
> +	if (!test_bit(0, &register_busy) || !wdd)
> +		return -ENODEV;
> +
> +	/* We can only unregister the watchdog device that was registered */
> +	if (watchdog != wdd) {
> +		printk(KERN_ERR PFX
> +			"%s: watchdog was not registered as /dev/watchdog.\n",
> +			watchdog->name);
> +		return -ENODEV;
> +	}
> +
> +	/* Unregister the miscdevice */
> +	dbg("Unregister /dev/watchdog device");
> +	misc_deregister(&watchdog_miscdev);
> +	wdd = NULL;
> +	clear_bit(0, &register_busy);
> +	return 0;
> +}
> +EXPORT_SYMBOL(watchdog_dev_unregister);
> +
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index 011bcfe..4d00bf8 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -59,6 +59,31 @@ struct watchdog_info {
>  #define WATCHDOG_NOWAYOUT	0
>  #endif
>  
> +struct watchdog_ops;
> +struct watchdog_device;
> +
> +/* The watchdog-devices operations */
> +struct watchdog_ops {
> +	/* mandatory operations */
> +	int (*start)(struct watchdog_device *);
> +	int (*stop)(struct watchdog_device *);
> +	/* optional operations */
> +	int (*ping)(struct watchdog_device *);
> +};
> +
> +/* The structure that defines a watchdog device */
> +struct watchdog_device {
> +	char *name;
> +	const struct watchdog_ops *ops;
> +	long status;
> +#define WDOG_DEV_OPEN		1	/* is the watchdog opened via
> +					 * /dev/watchdog */
> +};
> +
> +/* drivers/watchdog/core/watchdog_core.c */
> +extern int register_watchdogdevice(struct watchdog_device *);
> +extern void unregister_watchdogdevice(struct watchdog_device *);
> +
>  #endif	/* __KERNEL__ */
>  
>  #endif  /* ifndef _LINUX_WATCHDOG_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
