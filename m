Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1BIH4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 02:56:51 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56328 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1BIH4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:56:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nrQdQWAJ9NxwRjDsvAdyN5vOU+5l92MYF9zHz+iqjMOGtdPFpr4s8yPPEomoHXQesA
         /GkqLmsBoqyjXKuIyLWoDxlmf1LEPlR2x6E/hjcdmRVfpSUjheY1XBlzPAtMxKrfY0az
         cemH7krFl9iuEyVCrrHOAobS7AlxAYryyKLVk=
MIME-Version: 1.0
In-Reply-To: <1297235952-20435-1-git-send-email-tklauser@distanz.ch>
References: <1297171322-32401-1-git-send-email-tklauser@distanz.ch>
	<1297235952-20435-1-git-send-email-tklauser@distanz.ch>
Date: Wed, 9 Feb 2011 08:56:48 +0100
Message-ID: <AANLkTi=QiCgoswixhUEseK9+-=S0R_sZLA-AefmcC9=T@mail.gmail.com>
Subject: Re: [PATCH v3] watchdog: Add driver for Altera Watchdog Timer
From: Belisko Marek <marek.belisko@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Walter Goossens <waltergoossens@home.nl>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 8:19 AM, Tobias Klauser <tklauser@distanz.ch> wrote:
> This driver adds support for the Altera Timer in the Watchdog Timer
> configuration. This component is usually found on SOPC (System on
> Programmable Chip) for Altera FPGAs.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> Reviewed-by: Jamie Iles <jamie@jamieiles.com>
> ---
> Thanks a lot to Jamie Iles and Walter Goossens for their feedback on v2.
>
> changes for v3:
>  - Make altera_wdt_setup static void (as suggested by Jamie)
>  - Use const __be32 * for devicetree properties (as suggested by Walter)
> changes for v2:
>  - Get driver properties from devicetree (and document them), thus the
>   driver depends on OF
>  - Do not select WATCHDOG_NOWAYOUT, but instead implement a software
>   timer resetting the watchdog timer when the device is not open
>  - Only support a single instance of the watchdog, so the private data
>   can be kept in static data
>  - Use devm_* functions in altera_wdt_probe to simplify cleanup and
>   error handling
>  - Remove empty altera_wdt_shutdown function
>  - Add MODULE_LICENSE (GPL)
>
>
>  .../devicetree/bindings/watchdog/altera_wdt.txt    |    7 +
>  drivers/watchdog/Kconfig                           |    8 +
>  drivers/watchdog/Makefile                          |    1 +
>  drivers/watchdog/altera_wdt.c                      |  309 ++++++++++++++++++++
>  4 files changed, 325 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/altera_wdt.txt
>  create mode 100644 drivers/watchdog/altera_wdt.c
>
> diff --git a/Documentation/devicetree/bindings/watchdog/altera_wdt.txt b/Documentation/devicetree/bindings/watchdog/altera_wdt.txt
> new file mode 100644
> index 0000000..16ac949
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/altera_wdt.txt
> @@ -0,0 +1,7 @@
> +Altera Watchdog Timer
> +
> +Required properties:
> +- compatible : should be "ALTR,wdt-1.0"
> +- clock-frequency : frequency of the clock input
> +- timeout : load value of the timer (number of clock ticks until watchdog
> +            resets)
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index bd6a33d..ebcafb0 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -69,6 +69,14 @@ config WM8350_WATCHDOG
>          Support for the watchdog in the WM8350 AudioPlus PMIC.  When
>          the watchdog triggers the system will be reset.
>
> +config ALTERA_WDT
> +       tristate "Altera Watchdog Timer"
> +       depends on OF
> +       help
> +         Support for the Altera Timer in the Watchdog Timer configuration. This
> +         component is found on SOPC (System on Programmable Chip) for Altera
> +         FPGAs.
> +
>  # ALPHA Architecture
>
>  # ARM Architecture
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index fd9c8c0..48a2167 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -153,4 +153,5 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)               += cpwd.o
>  obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
>  obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
>  obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
> +obj-$(CONFIG_ALTERA_WDT) += altera_wdt.o
>  obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
> diff --git a/drivers/watchdog/altera_wdt.c b/drivers/watchdog/altera_wdt.c
> new file mode 100644
> index 0000000..2a7f14a
> --- /dev/null
> +++ b/drivers/watchdog/altera_wdt.c
> @@ -0,0 +1,309 @@
> +/*
> + * Driver for the Altera Watchdog Timer
> + *
> + * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
> + * Copyright (C) 2005 Walter Goossens
> + *
> + * Originally based on wdt.c which is
> + *
> + * Copyright (C) 1995-1997 Alan Cox <alan@lxorguk.ukuu.org.uk>
> + *
> + * Software timeout heartbeat code based on pika_wdt.c which is
> + *
> + * Copyright (c) 2008 PIKA Technologies
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
> +#include <linux/jiffies.h>
> +#include <linux/timer.h>
> +#include <linux/io.h>
> +#include <linux/uaccess.h>
> +#include <linux/of_platform.h>
> +
> +#define WATCHDOG_NAME  "altera_wdt"
> +
> +/* Register offsets */
> +#define ALTERA_WDT_STATUS      0x00
> +#define ALTERA_WDT_CONTROL     0x04
> +#define ALTERA_WDT_PERIODL     0x08
> +#define ALTERA_WDT_PERIODH     0x0C
> +
> +#define ALTERA_WDT_RUN_BIT     0x04
> +
> +/* User land timeout */
> +#define WDT_HEARTBEAT 15
> +static int heartbeat = WDT_HEARTBEAT;
> +module_param(heartbeat, int, 0);
> +MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
> +       "(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
> +
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
> +       "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +static struct {
> +       void __iomem *base;
> +       unsigned long wdt_timeout;      /* timeout of the hardware timer */
> +
> +       unsigned long next_heartbeat;   /* the next_heartbeat for the timer */
> +       unsigned long is_open;
> +       char expect_close;
> +       struct timer_list timer;        /* software timer that pings the watchdog */
> +} altera_wdt_priv;
> +
> +/*
> + * Start the watchdog. Once it has been started, it cannot be stopped anymore.
> + */
> +static void altera_wdt_setup(void)
> +{
> +       u32 control = readl(altera_wdt_priv.base + ALTERA_WDT_CONTROL);
> +
> +       writel(control | ALTERA_WDT_RUN_BIT, altera_wdt_priv.base + ALTERA_WDT_CONTROL);
> +}
> +
> +/*
> + * Tickle the watchdog (reset the watchdog timer)
> + */
> +static void altera_wdt_reset(void)
> +{
> +       /* It doesn't matter what value we write */
> +       writel(1, altera_wdt_priv.base + ALTERA_WDT_PERIODL);
> +}
> +
> +/*
> + * Software timer tick
> + */
> +static void altera_wdt_ping(unsigned long data)
> +{
> +       if (time_before(jiffies, altera_wdt_priv.next_heartbeat) ||
> +                       (!nowayout && !altera_wdt_priv.is_open)) {
> +               altera_wdt_reset();
> +               mod_timer(&altera_wdt_priv.timer, jiffies + altera_wdt_priv.wdt_timeout);
> +       } else
> +               pr_crit(WATCHDOG_NAME ": I will reset your machine!\n");
> +}
> +
> +static void altera_wdt_keepalive(void)
> +{
> +       altera_wdt_priv.next_heartbeat = jiffies + heartbeat * HZ;
> +}
> +
> +static void altera_wdt_start(void)
> +{
> +       altera_wdt_keepalive();
> +       mod_timer(&altera_wdt_priv.timer, jiffies + altera_wdt_priv.wdt_timeout);
> +}
> +
> +static int altera_wdt_open(struct inode *inode, struct file *file)
> +{
> +       /* /dev/watchdog can only be opened once */
> +       if (test_and_set_bit(0, &altera_wdt_priv.is_open))
> +               return -EBUSY;
> +
> +       altera_wdt_start();
> +
> +       return nonseekable_open(inode, file);
> +}
> +
> +static int altera_wdt_release(struct inode *inode, struct file *file)
> +{
> +       /* stop internal ping */
> +       if (!altera_wdt_priv.expect_close)
> +               del_timer(&altera_wdt_priv.timer);
> +
> +       clear_bit(0, &altera_wdt_priv.is_open);
> +       altera_wdt_priv.expect_close = 0;
> +
> +       return 0;
> +}
> +
> +static ssize_t altera_wdt_write(struct file *file, const char __user *data,
> +               size_t len, loff_t *ppos)
> +{
> +       if (!len)
> +               return 0;
> +
> +       /* Scan for magic character */
> +       if (!nowayout) {
> +               size_t i;
> +
> +               altera_wdt_priv.expect_close = 0;
> +
> +               for (i = 0; i < len; i++) {
> +                       char c;
> +                       if (get_user(c, data + i))
> +                               return -EFAULT;
> +                       if (c == 'V') {
> +                               altera_wdt_priv.expect_close = 42;
For what this value is used? Why 42? It's never checked in code to such a value.
> +                               break;
> +                       }
> +               }
> +       }
> +
> +       altera_wdt_keepalive();
> +
> +       return len;
> +}
> +
> +static const struct watchdog_info altera_wdt_info = {
> +       .identity               = "Altera Watchdog",
> +       .options                = WDIOF_SETTIMEOUT |
> +                                 WDIOF_KEEPALIVEPING |
> +                                 WDIOF_MAGICCLOSE,
> +       .firmware_version       = 1,
> +};
> +
> +static long altera_wdt_ioctl(struct file *file, unsigned int cmd,
> +               unsigned long arg)
> +{
> +       void __user *argp = (void __user *) arg;
> +       int __user *p = argp;
> +       int new_value;
> +
> +       switch (cmd) {
> +       case WDIOC_GETSUPPORT:
> +               return copy_to_user(argp, &altera_wdt_info, sizeof(altera_wdt_info));
> +
> +       case WDIOC_GETSTATUS:
> +       case WDIOC_GETBOOTSTATUS:
> +               return put_user(0, p);
> +
> +       case WDIOC_KEEPALIVE:
> +               altera_wdt_keepalive();
> +               return 0;
> +
> +       case WDIOC_SETTIMEOUT:
> +               if (get_user(new_value, p))
> +                       return -EFAULT;
> +
> +               heartbeat = new_value;
> +               altera_wdt_keepalive();
> +
> +               return put_user(new_value, p);  /* return current value */
> +
> +       case WDIOC_GETTIMEOUT:
> +               return put_user(heartbeat, p);
> +
> +       default:
> +               return -ENOTTY;
> +       }
> +}
> +
> +static const struct file_operations altera_wdt_fops = {
> +       .owner          = THIS_MODULE,
> +       .llseek         = no_llseek,
> +       .open           = altera_wdt_open,
> +       .release        = altera_wdt_release,
> +       .write          = altera_wdt_write,
> +       .unlocked_ioctl = altera_wdt_ioctl,
> +};
> +
> +static struct miscdevice altera_wdt_miscdev = {
> +       .minor  = WATCHDOG_MINOR,
> +       .name   = "watchdog",
> +       .fops   = &altera_wdt_fops,
> +};
> +
> +static int __devinit altera_wdt_probe(struct platform_device *pdev)
> +{
> +       struct resource *res, *mem;
> +       const __be32 *freq_prop, *timeout_prop;
> +       unsigned long timeout;
> +       int ret;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res)
> +               return -ENOENT;
> +
> +       mem = devm_request_mem_region(&pdev->dev, res->start,
> +                                     resource_size(res), pdev->name);
> +       if (!mem)
> +               return -EBUSY;
> +
> +       altera_wdt_priv.base = devm_ioremap_nocache(&pdev->dev, mem->start,
> +                                                   resource_size(mem));
> +       if (!altera_wdt_priv.base)
> +               return -ENOMEM;
> +
> +       freq_prop = of_get_property(pdev->dev.of_node, "clock-frequency", NULL);
> +       if (!freq_prop)
> +               return -ENODEV;
> +
> +       timeout_prop = of_get_property(pdev->dev.of_node, "timeout", NULL);
> +       if (!timeout_prop)
> +               return -ENODEV;
> +
> +       /* Add 1 as the timeout property actually holds the load value */
> +       timeout = be32_to_cpup(timeout_prop) + 1;
> +       /* Convert timeout to msecs */
> +       timeout = timeout / (be32_to_cpup(freq_prop) / MSEC_PER_SEC);
> +       /* Tickle the watchdog twice per timeout period */
> +       altera_wdt_priv.wdt_timeout = msecs_to_jiffies(timeout / 2);
> +
> +       ret = misc_register(&altera_wdt_miscdev);
> +       if (ret)
> +               return ret;
> +
> +       altera_wdt_setup();
> +       altera_wdt_priv.next_heartbeat = jiffies + heartbeat * HZ;
> +       setup_timer(&altera_wdt_priv.timer, altera_wdt_ping, 0);
> +       mod_timer(&altera_wdt_priv.timer, jiffies + altera_wdt_priv.wdt_timeout);
> +
> +       pr_info(WATCHDOG_NAME " enabled (heartbeat=%d sec, nowayout=%d)\n",
> +               heartbeat, nowayout);
> +
> +       return 0;
> +}
> +
> +static int __devexit altera_wdt_remove(struct platform_device *pdev)
> +{
> +       misc_deregister(&altera_wdt_miscdev);
> +       return 0;
> +}
> +
> +static struct of_device_id altera_wdt_match[] = {
> +       { .compatible = "altr,wdt-1.0", },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, altera_wdt_match);
> +
> +static struct platform_driver altera_wdt_driver = {
> +       .probe          = altera_wdt_probe,
> +       .remove         = __devexit_p(altera_wdt_remove),
> +       .driver         = {
> +               .owner          = THIS_MODULE,
> +               .name           = WATCHDOG_NAME,
> +               .of_match_table = altera_wdt_match,
> +       },
> +};
> +
> +static int __init altera_wdt_init(void)
> +{
> +       return platform_driver_register(&altera_wdt_driver);
> +}
> +
> +static void __exit altera_wdt_exit(void)
> +{
> +       platform_driver_unregister(&altera_wdt_driver);
> +}
> +
> +module_init(altera_wdt_init);
> +module_exit(altera_wdt_exit);
> +
> +MODULE_AUTHOR("Walter Goossens, Tobias Klauser <tklauser@distanz.ch>");
> +MODULE_DESCRIPTION("Driver for Altera Watchdog Timer");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> +MODULE_ALIAS("platform:" WATCHDOG_NAME);
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
