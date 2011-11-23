Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1KWVq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:46:56 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:48825 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab1KWVqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:46:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAI1nzU5tg6zW/2dsb2JhbAA7CagCgnCBBoFyAQEEAScTHCMQCANGFCUDIRMbh2oCtFQShx2DMwSUR5IM
Date: Wed, 23 Nov 2011 22:43:38 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123214338.GP23376@infomag.iguana.be>
References: <20111122112212.GD2734@pengutronix.de> <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com> <20111122173227.GK6624@sirena.org.uk> <20111122184051.GA30941@pengutronix.de> <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com> <20111123104926.GB4063@pengutronix.de> <20111123121329.GM23376@infomag.iguana.be> <20111123122018.GA12227@opensource.wolfsonmicro.com> <20111123124037.GN23376@infomag.iguana.be> <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> > Coming back to now: if the driver incorporates the timer (like all other
> > devices that can be started but not stopped once started do), then the start
> > and stop functions are not empty.
> > The timer (with the example that I prepared as part of the generic code) is
> > not so difficult and will be a good solution for the time being. (Unless
> > Dmitry Artamonow's comment about the fact that the watchdog could perhaps
> > be started and stopped is correct... This should be investigated first imho).
> >
> The watchdog can not be started and stopped from the driver. This is
> what I investigated first and found impossible (and explains why this
> driver is still missing).
> 
> I do not fully understand yet what has to be done with the timer.

Below the example driver that should get included in the Documentation.

Kind regards,
Wim.
--------------------------------------------------------------------------------
/*
 * Watchdog timer driver example with timer.
 *
 * Copyright (C) 2009-2011 Wim Van Sebroeck <wim@iguana.be>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version
 * 2 of the License, or (at your option) any later version.
 */

/*
 * Some watchdog device can't stop once started. To support
 * the magic_close feature we therefor need to use an internal
 * timer to keep the watchdog being pinged when /dev/watchdog has
 * been closed correctly.
 *
 * This is an example driver for these kind of watchdog devices. 
 */

#define DRV_NAME KBUILD_MODNAME
#define pr_fmt(fmt) DRV_NAME ": " fmt

#include <linux/init.h>
#include <linux/errno.h>
#include <linux/err.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/watchdog.h>
#include <linux/jiffies.h>
#include <linux/timer.h>
#include <linux/platform_device.h>

/* Hardware heartbeat in seconds */
#define WDT_HW_HEARTBEAT 2

/* Timer heartbeat (500ms) */
#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */

/* User land timeout */
#define WDT_TIMEOUT 15
static int timeout = WDT_TIMEOUT;
module_param(timeout, int, 0);
MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");

static int nowayout = WATCHDOG_NOWAYOUT;
module_param(nowayout, int, 0);
MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started. "
	"(default = " __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");

static struct watchdog_device wdt_dev;
static void wdt_timer_tick(unsigned long data);
static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
					/* The timer that pings the watchdog */
static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
static unsigned long running;		/* is watchdog running for userspace? */

static struct platform_device *wdt_platform_device;

/*
 * Reset the watchdog timer.  (ie, pat the watchdog)
 */
static inline void wdt_reset(void)
{
	/* Reset the watchdog timer hardware here */
}

/*
 * Timer tick: the timer will make sure that the watchdog timer hardware
 * is being reset in time. The conditions to do this are:
 *  1) the watchog timer has been started and /dev/watchdog is open
 *     and there is still time left before userspace should send the
 *     next heartbeat/ping. (note: the internal heartbeat is much smaller
 *     then the external/userspace heartbeat).
 *  2) the watchdog timer has been stopped by userspace.
 */
static void wdt_timer_tick(unsigned long data)
{
	if (time_before(jiffies, next_heartbeat) ||
	   (!test_bit(WDOG_ACTIVE, &wdt_dev.status))) {
		wdt_reset();
		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
	} else
		pr_crit("I will reboot your machine !\n");
}

/*
 * The watchdog operations
 */
static int wdt_ping(struct watchdog_device *wdd)
{
	/* calculate when the next userspace timeout will be */
	next_heartbeat = jiffies + timeout * HZ;
	return 0;
}

static int wdt_start(struct watchdog_device *wdd)
{
	/* calculate the next userspace timeout and modify the timer */
	wdt_ping(wdd);
	mod_timer(&timer, jiffies + WDT_HEARTBEAT);

	/* Start the watchdog timer hardware here */
	pr_info("wdt_start\n");

	running = 1;
	return 0;
}

static int wdt_stop(struct watchdog_device *wdd)
{
	/* The watchdog timer hardware can not be stopped... */
	pr_info("wdt_stop\n");

	running = 0;
	return 0;
}

static unsigned int wdt_status(struct watchdog_device *wdd)
{
	return WDIOF_FANFAULT;
}

static int wdt_set_timeout(struct watchdog_device *wdd, unsigned int new_timeout)
{
	if (new_timeout < 1)
		return -EINVAL;
	return 0;
}

/*
 * The watchdog kernel structures
 */
static const struct watchdog_info wdt_info = {
	.identity =	DRV_NAME,
	.options =	WDIOF_SETTIMEOUT |
			WDIOF_MAGICCLOSE |
			WDIOF_KEEPALIVEPING,
};

static const struct watchdog_ops wdt_ops = {
	.owner =	THIS_MODULE,
	.start =	wdt_start,
	.stop =		wdt_stop,
	.ping =		wdt_ping,
	.status =	wdt_status,
	.set_timeout =	wdt_set_timeout,
};

static struct watchdog_device wdt_dev = {
	.info =		&wdt_info,
	.ops =		&wdt_ops,
};

/*
 * The watchdog timer drivers init and exit routines
 */
static int __devinit wdt_probe(struct platform_device *pdev)
{
	int res;

	/* Register other stuff */

	/* Set watchdog_device parameters */
	wdt_dev.timeout = timeout;
/*	wdt_dev.dev.parent = &pdev->dev;*/
	if (nowayout)
		set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);

	/* Register the watchdog timer device */
	res = watchdog_register_device(&wdt_dev);
	if (res) {
		pr_err("watchdog_register_device returned %d\n", res);
		return res;
	}

	pr_info("enabled (timeout=%d sec)\n", timeout);

	return 0;
}

static int __devexit wdt_remove(struct platform_device *pdev)
{
	/* Unregister the watchdog timer device */
	watchdog_unregister_device(&wdt_dev);

	/* stop and delete the timer */
	pr_warn("I quit now, hardware will probably reboot!\n");
	del_timer(&timer);

	/* Unregister other stuff */
	return 0;
}

static struct platform_driver wdt_driver = {
	.probe		= wdt_probe,
	.remove		= __devexit_p(wdt_remove),
	.driver		= {
		.name	= DRV_NAME,
		.owner	= THIS_MODULE,
	},
};

static int __init wdt_init(void)
{
	int err;

	pr_info("WDT driver initialising.\n");

	err = platform_driver_register(&wdt_driver);
	if (err)
		return err;

	wdt_platform_device = platform_device_register_simple(DRV_NAME,
								-1, NULL, 0);
	if (IS_ERR(wdt_platform_device)) {
		err = PTR_ERR(wdt_platform_device);
		goto unreg_platform_driver;
	}

	return 0;

unreg_platform_driver:
	platform_driver_unregister(&wdt_driver);
	return err;
}

static void __exit wdt_exit(void)
{
	platform_device_unregister(wdt_platform_device);
	platform_driver_unregister(&wdt_driver);
	pr_info("Watchdog Module Unloaded.\n");
}

module_init(wdt_init);
module_exit(wdt_exit);

MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
MODULE_DESCRIPTION("WatchDog Timer Driver example with timer");
MODULE_LICENSE("GPL");
MODULE_ALIAS("platform:" DRV_NAME);
