Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1FRS6f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:58:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64268 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1FRS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:58:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Date: Sat, 18 Jun 2011 20:58:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618171946.GB3441@infomag.iguana.be>
In-Reply-To: <20110618171946.GB3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182058.14702.arnd@arndb.de>
X-Provags-ID: V02:K0:jousO5Y2hoaTcgRzDOEDdOZXZcOisWwBbIyladZ7k9V
 YiPoWCEDAhXnm29LPwAX1iT5sPoz/bVg/CSiDn8ksSM+wd6cuJ
 mCuzesuRPmKC6BZ5JsZf10VDnjEYoD2aCxmlz0DyYuIPd8GyRI
 2OOExFGpft7JkTt/JOuoyo5eSN7sHrIYyHurWE1IgIwKIM8Nt7
 QWlsrPqUM77+isCbiVE4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 19:19:46 Wim Van Sebroeck wrote:
> watchdog: WatchDog Timer Driver Core - Part 1
> 
> The WatchDog Timer Driver Core is a framework
> that contains the common code for all watchdog-driver's.
> It also introduces a watchdog device structure and the
> operations that go with it.
> 
> This is the introduction of this framework. This part
> supports the minimal watchdog userspace API (or with
> other words: the functionality to use /dev/watchdog's
> open, release and write functionality as defined in
> the simplest watchdog API). Extra functionality will
> follow in the next set of patches.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Hi Wim,

Great to see the series posted again, I'm looking forward to seeing
this included in 3.1.

I've got a few comments for stuff that can still be improved.

I noticed that your email subject lines are all the same, you should
probably see if you mail setup can be fixed to take the one-line
comment in each patch as the subject, and also to make all mails
replies to the [PATCH 0/10] email.

> diff -urN linux-2.6.38-orig/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part1/Documentation/watchdog/src/watchdog-with-timer-example.c
> --- linux-2.6.38-orig/Documentation/watchdog/src/watchdog-with-timer-example.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.38-generic-part1/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:07:33.939170516 +0200
> @@ -0,0 +1,210 @@
> +/*
> + * Watchdog timer driver example with timer.
> + *
> + * Copyright (C) 2009-2011 Wim Van Sebroeck <wim@iguana.be>
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

Since this is an example driver, I'll try to be extra pedantic to make\
sure it's as good as possible ;-)

> +#define DRV_NAME KBUILD_MODNAME
> +#define pr_fmt(fmt) DRV_NAME ": " fmt
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

I'm pretty sure you don't need bitops.h or uaccess.h here, because all the
code using those has moved into the core.

> +#include <linux/io.h>

This is also not needed here, although it will probably be needed in most
real drivers.

> +#include <linux/platform_device.h>
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

Should the module parameter really be part of each individual driver?
It would be nice if that can be moved into the core as well.

> +static void wdt_timer_tick(unsigned long data);

I usually recommend reordering all functions so that you don't need any forward
declarations, that makes the driver easier to read IMHO.

> +static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> +					/* The timer that pings the watchdog */
> +static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
> +static unsigned long running;		/* is watchdog running for userspace? */

How about moving these into a structure that hangs off watchdog_device->priv?
It would be nice if a driver could live without global variables, especially
if you want to eventually support multiple concurrent watchdog instances.

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
> +		pr_crit("I will reboot your machine !\n");
> +}

Is it common for watchdog these days to have both a kernel timer and
a user space timer?

If yes, that might be good to support in the core as well, instead of
having to implement it in each driver.

If no, it might not be ideal to have in an example driver.


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
> +	res = watchdog_register_device(&wdt_dev);
> +	if (res) {
> +		pr_err("watchdog_register_device returned %d\n", res);
> +		return res;
> +	}

Not sure if statically allocating the device is ideal. Why not make
watchdog_register_device allocate a struct watchdog_device? I would
change the prototype to

	struct watchdog_device *watchdog_device_register(const char *name,
		const struct watchdog_device_ops *ops, struct device *parent);


> +static int __init wdt_init(void)
> +{
> +	int err;
> +
> +	pr_info("WDT driver initialising.\n");
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

Normally, we don't want platform device to be registered by the device driver,
but rather by the platform code. I think it would be better for the example
driver to only call platform_driver_register, but not platform_device_register.

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

I think this should really have a pointer to the struct device implementing the
watchdog, so that a driver that gets called with a struct watchdog_device can
find its own state from there. Alternatively, you could have struct device
embedded in struct watchdog_device and register it as a child of the hardware
device.

> +int watchdog_register_device(struct watchdog_device *wdd)
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
> +		pr_err("error registering /dev/watchdog (err=%d)", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(watchdog_register_device);

How about making this EXPORT_SYMBOL_GPL?

> +static const struct file_operations watchdog_fops = {
> +	.owner		= THIS_MODULE,
> +	.llseek		= no_llseek,
> +	.write		= watchdog_write,
> +	.open		= watchdog_open,
> +	.release	= watchdog_release,
> +};

No need to set no_llseek any more. It's the default now.

	Arnd
