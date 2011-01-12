Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1ALLsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:48:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38763 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1ALLsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:48:06 -0500
Date: Wed, 12 Jan 2011 11:48:00 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: [PATCH] watchdog: Add driver for Altera Watchdog Timer
Message-ID: <20110112114800.GB2658@pulham.picochip.com>
References: <1294829027-15029-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294829027-15029-1-git-send-email-tklauser@distanz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

On Wed, Jan 12, 2011 at 11:43:47AM +0100, Tobias Klauser wrote:
> This driver adds support for the Altera Timer in the Watchdog Timer
> configuration. This component is usually found on SOPC (System on
> Programmable Chip) for Altera FPGAs containing a Nios2 softcore
> processor.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/watchdog/Kconfig      |   11 ++
>  drivers/watchdog/Makefile     |    3 +
>  drivers/watchdog/altera_wdt.c |  229 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 243 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/watchdog/altera_wdt.c
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 62e743d..be4cb39 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -972,6 +972,17 @@ config BCM63XX_WDT
>  	  To compile this driver as a loadable module, choose M here.
>  	  The module will be called bcm63xx_wdt.
>  
> +# NIOS2 Architecture
> +
> +config ALTERA_WDT
> +	tristate "Altera Watchdog Timer"
> +	select WATCHDOG_NOWAYOUT
> +	help
> +	  Watchdog driver for the Altera Watchdog Timer found on Altera
> +	  Nios2 SOPC systems.
> +
> +	  Once the watchdog timer is started it cannot be stopped anymore.
> +
>  # PARISC Architecture

I've been writing a driver for a watchdog that also cannot be stopped 
and Wim pointed out that selecting WATCHDOG_NOWAYOUT is the wrong way to 
do this as it will select this for the system and not the single driver.  
The correct approach is to have a software timer to implement a 
heartbeat to kick the watchdog when it is not open.  There are examples 
in at91sam9_wdt.c and pika_wdt.c

> diff --git a/drivers/watchdog/altera_wdt.c 
> b/drivers/watchdog/altera_wdt.c
> new file mode 100644
> index 0000000..a7bf7ce
> --- /dev/null
> +++ b/drivers/watchdog/altera_wdt.c
> @@ -0,0 +1,229 @@
> +/*
> + * Driver for the Altera Watchdog Timer
> + *
> + * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
> + * Copyright (C) 2005 Walter Goossens
> + * Copyright (C) 1996 Alan Cox <alan@redhat.com>
> + *
> + * Originally based on wdt.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/miscdevice.h>
> +#include <linux/watchdog.h>
> +#include <linux/platform_device.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +
> +#define WATCHDOG_NAME	"altera_wdt"
> +
> +/* Register offsets */
> +#define ALTERA_WDT_SIZE		0x18
> +#define ALTERA_WDT_STATUS	0x00
> +#define ALTERA_WDT_CONTROL	0x01
> +#define ALTERA_WDT_PERIODL	0x02
> +#define ALTERA_WDT_PERIODH	0x03
> +
> +#define ALTERA_WDT_RUN_BIT	0x04
> +
> +static struct platform_device *altera_wdt_pdev;
> +
> +struct altera_wdt_dev {
> +	void __iomem *base;
> +	unsigned long wdt_users;
> +};

As you support a single watchdog, do you need the altera_wdt_pdev 
pointer?  This requires you to set the drvdata then keep retrieving it, 
but you could just have a static instance of altera_wdt_dev.

> +
> +static int altera_wdt_start(struct altera_wdt_dev *wdev)
> +{
> +	u32 control = readl(wdev->base + ALTERA_WDT_CONTROL);
> +
> +	pr_debug("%s: Starting watchdog timer\n", WATCHDOG_NAME);
> +	writel(control | ALTERA_WDT_RUN_BIT, wdev->base + ALTERA_WDT_CONTROL);
> +	return 0;
> +}
> +
> +static void altera_wdt_ping(struct altera_wdt_dev *wdev)
> +{
> +	/* It doesn't matter what value we write */
> +	writel(1, wdev->base + ALTERA_WDT_PERIODL);
> +}
> +
> +static ssize_t altera_wdt_write(struct file *file, const char __user *buf,
> +		size_t len, loff_t *ppos)
> +{
> +	struct altera_wdt_dev *wdev = file->private_data;
> +
> +	if (len)
> +		altera_wdt_ping(wdev);
> +	return len;
> +}
> +
> +static const struct watchdog_info altera_wdt_info = {
> +	.identity		= "Altera Watchdog",
> +	.options		= WDIOF_KEEPALIVEPING,
> +	.firmware_version	= 1,
> +};
> +
> +static long altera_wdt_ioctl(struct file *file, unsigned int cmd,
> +		unsigned long arg)
> +{
> +	struct altera_wdt_dev *wdev = file->private_data;
> +	void __user *argp = (void __user *) arg;
> +
> +	switch (cmd) {
> +	case WDIOC_GETSUPPORT:
> +		return copy_to_user(argp, &altera_wdt_info, sizeof(altera_wdt_info));
> +	case WDIOC_KEEPALIVE:
> +		altera_wdt_ping(wdev);
> +		return 0;
> +	default:
> +		return -ENOTTY;
> +	}
> +}

Can you set/get the timeout period on this watchdog?  Even if you can't 
set it then it would be good to allow the user to read the constant 
timeout that the watchdog uses so it knows how often to kick it.  If you 
use the software timeout heartbeat then in the future you could emulate 
longer timeouts.

Can you set/get the timeout period on this watchdog?  Even if you can't 
set it then it would be good to allow the user to read the constant 
timeout that the watchdog uses so it knows how often to kick it.  If you 
use the software timeout heartbeat then in the future you could emulate 
longer timeouts.

> +static int altera_wdt_open(struct inode *inode, struct file *file)
> +{
> +	struct altera_wdt_dev *wdev = platform_get_drvdata(altera_wdt_pdev);
> +
> +	if (test_and_set_bit(1, &wdev->wdt_users))
> +		return -EBUSY;
> +
> +	file->private_data = wdev;
> +
> +	altera_wdt_start(wdev);
> +	altera_wdt_ping(wdev);
> +
> +	return nonseekable_open(inode, file);
> +}
> +
> +static int altera_wdt_release(struct inode *inode, struct file *file)
> +{
> +	struct altera_wdt_dev *wdev = file->private_data;
> +
> +	/* It is not possible to stop the watchdog timer, once started */
> +	pr_crit("%s: Unexpected close, not stopping!\n", WATCHDOG_NAME);
> +	wdev->wdt_users = 0;
> +
> +	return 0;
> +}
> +
> +static const struct file_operations altera_wdt_fops = {
> +	.owner		= THIS_MODULE,
> +	.llseek		= no_llseek,
> +	.write		= altera_wdt_write,
> +	.unlocked_ioctl	= altera_wdt_ioctl,
> +	.open		= altera_wdt_open,
> +	.release	= altera_wdt_release,
> +};
> +
> +static struct miscdevice altera_wdt_miscdev = {
> +	.minor	= WATCHDOG_MINOR,
> +	.name	= "watchdog",
> +	.fops	= &altera_wdt_fops,
> +};
> +
> +static int __devinit altera_wdt_probe(struct platform_device *pdev)
> +{
> +	struct altera_wdt_dev *wdev;
> +	struct resource *res, *mem;
> +	int ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
> +
> +	if (altera_wdt_pdev)
> +		return -EBUSY;
> +
> +	mem = request_mem_region(res->start, resource_size(res), pdev->name);
> +	if (!mem)
> +		return -EBUSY;
> +
> +	wdev = kzalloc(sizeof(struct altera_wdt_dev), GFP_KERNEL);
> +	if (!wdev) {
> +		ret = -ENOMEM;
> +		goto err_kzalloc;
> +	}
> +
> +	wdev->base = ioremap(mem->start, resource_size(mem));
> +	if (!wdev->base) {
> +		ret = -ENOMEM;
> +		goto err_ioremap;
> +	}

You can use devm_request_mem_region(), devm_kzalloc() and devm_ioremap() 
here to make the cleanup and error handling a bit simpler 
(Documentation/driver-model/devres.txt)

> +
> +	platform_set_drvdata(pdev, wdev);
> +
> +	ret = misc_register(&altera_wdt_miscdev);
> +	if (ret)
> +		goto err_misc;
> +
> +	altera_wdt_pdev = pdev;
> +
> +	return 0;
> +
> +err_misc:
> +	iounmap(wdev->base);
> +err_ioremap:
> +	kfree(wdev);
> +err_kzalloc:
> +	release_mem_region(res->start, resource_size(res));
> +
> +	return ret;
> +}
> +
> +static int __devexit altera_wdt_remove(struct platform_device *pdev)
> +{
> +	struct altera_wdt_dev *wdev = platform_get_drvdata(pdev);
> +	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	misc_deregister(&altera_wdt_miscdev);
> +	platform_set_drvdata(pdev, NULL);
> +	iounmap(wdev->base);
> +	release_mem_region(res->start, resource_size(res));
> +	kfree(wdev);
> +	altera_wdt_pdev = NULL;
> +
> +	return 0;
> +}
> +
> +static void altera_wdt_shutdown(struct platform_device *pdev)
> +{
> +	/* Do nothing. It is not possible to stop the watchdog timer, once
> +	 * started */
> +}

Can you just remove this function and not define it in alter_wdt_driver?

> +
> +static struct platform_driver altera_wdt_driver = {
> +	.probe		= altera_wdt_probe,
> +	.remove		= __devexit_p(altera_wdt_remove),
> +	.shutdown	= altera_wdt_shutdown,
> +	.driver		= {
> +		.owner	= THIS_MODULE,
> +		.name	= WATCHDOG_NAME,
> +	},
> +};
> +
> +static int __init altera_wdt_init(void)
> +{
> +	return platform_driver_register(&altera_wdt_driver);
> +}
> +
> +static void __exit altera_wdt_exit(void)
> +{
> +	platform_driver_unregister(&altera_wdt_driver);
> +}
> +
> +module_init(altera_wdt_init);
> +module_exit(altera_wdt_exit);
> +
> +MODULE_AUTHOR("Walter Goossens, Tobias Klauser <tklauser@distanz.ch>");
> +MODULE_DESCRIPTION("Driver for Altera Watchdog Timer");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);

Jamie
