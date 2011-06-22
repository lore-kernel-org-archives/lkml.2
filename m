Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1FVTua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:50:30 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:49445 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758594Ab1FVTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:50:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADFFAk5tgwPS/2dsb2JhbACdIHilLw2FVgQ
Date: Wed, 22 Jun 2011 21:50:24 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110622195024.GA26745@infomag.iguana.be>
References: <20110618171946.GB3441@infomag.iguana.be> <201106182058.14702.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106182058.14702.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> Great to see the series posted again, I'm looking forward to seeing
> this included in 3.1.

That's the goal :-).

> > +/*
> > + * This is an example driver where the hardware does not support
> > + * stopping the watchdog timer.
> > + */
> 
> Since this is an example driver, I'll try to be extra pedantic to make\
> sure it's as good as possible ;-)

Hmm, this is _NOT_ an example of the most common watchdog driver.
It's a common exception for devices that can't be stopped once started.
Perhaps it's better that this example is not part of the framework, but a seperate patch.

> > +#define DRV_NAME KBUILD_MODNAME
> > +#define pr_fmt(fmt) DRV_NAME ": " fmt
> > +
> > +#include <linux/init.h>
> > +#include <linux/errno.h>
> > +#include <linux/err.h>
> > +#include <linux/module.h>
> > +#include <linux/moduleparam.h>
> > +#include <linux/types.h>
> > +#include <linux/kernel.h>
> > +#include <linux/watchdog.h>
> > +#include <linux/jiffies.h>
> > +#include <linux/timer.h>
> > +#include <linux/bitops.h>
> > +#include <linux/uaccess.h>
> 
> I'm pretty sure you don't need bitops.h or uaccess.h here, because all the
> code using those has moved into the core.

bitops will be used later on, but this can indeed be cleaned up.

> > +#include <linux/io.h>
> 
> This is also not needed here, although it will probably be needed in most
> real drivers.

Same.

> > +#include <linux/platform_device.h>
> > +
> > +/* Hardware heartbeat in seconds */
> > +#define WDT_HW_HEARTBEAT 2
> > +
> > +/* Timer heartbeat (500ms) */
> > +#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
> > +
> > +/* User land timeout */
> > +#define WDT_TIMEOUT 15
> > +static int timeout = WDT_TIMEOUT;
> > +module_param(timeout, int, 0);
> > +MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
> > +	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
> 
> Should the module parameter really be part of each individual driver?
> It would be nice if that can be moved into the core as well.

Yes, the module parameter is needed for each individual driver.
If we go for supporting multiple watchdog devices, then we will have to support
different timeout values. The timeout ranges also differ for different devices.

> > +static void wdt_timer_tick(unsigned long data);
> 
> I usually recommend reordering all functions so that you don't need any forward
> declarations, that makes the driver easier to read IMHO.
> 
> > +static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> > +					/* The timer that pings the watchdog */

Yes, I also tend to do that but it's used in the DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
just under it. No clean way to do that better imho...

> > +static unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
> > +static unsigned long running;		/* is watchdog running for userspace? */
> 
> How about moving these into a structure that hangs off watchdog_device->priv?
> It would be nice if a driver could live without global variables, especially
> if you want to eventually support multiple concurrent watchdog instances.

Correct.

> > +static struct platform_device *wdt_platform_device;
> > +
> > +/*
> > + * Reset the watchdog timer.  (ie, pat the watchdog)
> > + */
> > +static inline void wdt_reset(void)
> > +{
> > +	/* Reset the watchdog timer hardware here */
> > +}
> > +
> > +/*
> > + * Timer tick: the timer will make sure that the watchdog timer hardware
> > + * is being reset in time. The conditions to do this are:
> > + *  1) the watchog timer has been started and /dev/watchdog is open
> > + *     and there is still time left before userspace should send the
> > + *     next heartbeat/ping. (note: the internal heartbeat is much smaller
> > + *     then the external/userspace heartbeat).
> > + *  2) the watchdog timer has been stopped by userspace.
> > + */
> > +static void wdt_timer_tick(unsigned long data)
> > +{
> > +	if (time_before(jiffies, next_heartbeat) ||
> > +			(!running)) {
> > +		wdt_reset();
> > +		mod_timer(&timer, jiffies + WDT_HEARTBEAT);
> > +	} else
> > +		pr_crit("I will reboot your machine !\n");
> > +}
> 
> Is it common for watchdog these days to have both a kernel timer and
> a user space timer?

No, it is only common for watchdog devices that
1) don't stop once started
2) device that have very small (mostly < 1second) heartbeat values.
All other watchdog device timers don't need and use the kernel timer.

> If yes, that might be good to support in the core as well, instead of
> having to implement it in each driver.
> 
> If no, it might not be ideal to have in an example driver.

As said, it's an example for a common exception. You should not look at this
as a common example driver. I added it, because it's a common exception that
people understand less.

> > +static struct watchdog_device wdt_dev = {
> > +	.name =		DRV_NAME,
> > +	.ops =		&wdt_ops,
> > +};
> > +
> > +/*
> > + * The watchdog timer drivers init and exit routines
> > + */
> > +static int __devinit wdt_probe(struct platform_device *pdev)
> > +{
> > +	int res;
> > +
> > +	/* Register other stuff */
> > +
> > +	/* Register the watchdog timer device */
> > +	res = watchdog_register_device(&wdt_dev);
> > +	if (res) {
> > +		pr_err("watchdog_register_device returned %d\n", res);
> > +		return res;
> > +	}
> 
> Not sure if statically allocating the device is ideal. Why not make
> watchdog_register_device allocate a struct watchdog_device? I would
> change the prototype to
> 
> 	struct watchdog_device *watchdog_device_register(const char *name,
> 		const struct watchdog_device_ops *ops, struct device *parent);

Some watchdog's are only available on one platform, these drivers can perfectly
work with a fixed structure instead of allocating one. Drivers that support multiple
devices will allocate the struct thenmselves.
We return the error or succes codes now, that's something we want to keep. So
that's the second reason why we didn't go for the device allocating prototype.

> > +static int __init wdt_init(void)
> > +{
> > +	int err;
> > +
> > +	pr_info("WDT driver initialising.\n");
> > +
> > +	err = platform_driver_register(&wdt_driver);
> > +	if (err)
> > +		return err;
> > +
> > +	wdt_platform_device = platform_device_register_simple(DRV_NAME,
> > +								-1, NULL, 0);
> > +	if (IS_ERR(wdt_platform_device)) {
> > +		err = PTR_ERR(wdt_platform_device);
> > +		goto unreg_platform_driver;
> > +	}
> > +
> > +	return 0;
> > +
> > +unreg_platform_driver:
> > +	platform_driver_unregister(&wdt_driver);
> > +	return err;
> > +}
> 
> Normally, we don't want platform device to be registered by the device driver,
> but rather by the platform code. I think it would be better for the example
> driver to only call platform_driver_register, but not platform_device_register.

Hmm; that's a point.

> > +struct watchdog_device {
> > +	char *name;
> > +	const struct watchdog_ops *ops;
> > +	long status;
> > +};
> > +
> > +It contains following fields:
> > +* name: a pointer to the (preferably unique) name of the watchdog timer device.
> > +* ops: a pointer to the list of watchdog operations that the watchdog supports.
> > +* status: this field contains a number of status bits that give extra
> > +  information about the status of the device (Like: is the device opened via
> > +  the /dev/watchdog interface or not, ...)
> 
> I think this should really have a pointer to the struct device implementing the
> watchdog, so that a driver that gets called with a struct watchdog_device can
> find its own state from there. Alternatively, you could have struct device
> embedded in struct watchdog_device and register it as a child of the hardware
> device.

Would go for a pointer to private data then.

> > +int watchdog_register_device(struct watchdog_device *wdd)
> > +{
> > +	int ret;
> > +
> > +	/* Make sure we have a valid watchdog_device structure */
> > +	if (wdd == NULL || wdd->ops == NULL)
> > +		return -ENODATA;
> > +
> > +	/* Make sure that the mandatory operations are supported */
> > +	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
> > +		return -ENODATA;
> > +
> > +	/* Note: now that all watchdog_device data has been verified, we
> > +	 * will not check this anymore in other functions. If data get's
> > +	 * corrupted in a later stage then we expect a kernel panic! */
> > +
> > +	/* The future version will have to manage a list of all
> > +	 * registered watchdog devices. To start we will only
> > +	 * support 1 watchdog device via the /dev/watchdog interface */
> > +
> > +	/* create the /dev/watchdog interface */
> > +	ret = watchdog_dev_register(wdd);
> > +	if (ret) {
> > +		pr_err("error registering /dev/watchdog (err=%d)", ret);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(watchdog_register_device);
> 
> How about making this EXPORT_SYMBOL_GPL?
> 
> > +static const struct file_operations watchdog_fops = {
> > +	.owner		= THIS_MODULE,
> > +	.llseek		= no_llseek,
> > +	.write		= watchdog_write,
> > +	.open		= watchdog_open,
> > +	.release	= watchdog_release,
> > +};
> 
> No need to set no_llseek any more. It's the default now.

OK. Will change this.

Kind regards,
Wim.

