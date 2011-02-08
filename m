Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1BHROB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:14:01 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34919 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1BHROA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:14:00 -0500
Date: Tue, 8 Feb 2011 17:13:46 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw
Subject: Re: [PATCH v2] watchdog: Add driver for Altera Watchdog Timer
Message-ID: <20110208171346.GD8679@pulham.picochip.com>
References: <1294829027-15029-1-git-send-email-tklauser@distanz.ch>
 <1297171322-32401-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297171322-32401-1-git-send-email-tklauser@distanz.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

One very pedantic comment, otherwise looks great!

On Tue, Feb 08, 2011 at 02:22:02PM +0100, Tobias Klauser wrote:
> This driver adds support for the Altera Timer in the Watchdog Timer
> configuration. This component is usually found on SOPC (System on
> Programmable Chip) for Altera FPGAs.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Reviewed-by: Jamie Iles <jamie@jamieiles.com>.

> ---
> 
> Thanks a lot to Jamie Iles for reviewing the first submitted version of this
> driver.
> 
> changes for v2:
>  - Get driver properties from devicetree (and document them), thus the
>    driver depends on OF
>  - Do not select WATCHDOG_NOWAYOUT, but instead implement a software
>    timer resetting the watchdog timer when the device is not open
>  - Only support a single instance of the watchdog, so the private data
>    can be kept in static data
>  - Use devm_* functions in altera_wdt_probe to simplify cleanup and
>    error handling
>  - Remove empty altera_wdt_shutdown function
>  - Add MODULE_LICENSE (GPL)
> 
>  .../devicetree/bindings/watchdog/altera_wdt.txt    |    7 +
>  drivers/watchdog/Kconfig                           |    8 +
>  drivers/watchdog/Makefile                          |    1 +
>  drivers/watchdog/altera_wdt.c                      |  310 ++++++++++++++++++++
>  4 files changed, 326 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/altera_wdt.txt
>  create mode 100644 drivers/watchdog/altera_wdt.c
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
> +            resets)
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index bd6a33d..ebcafb0 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -69,6 +69,14 @@ config WM8350_WATCHDOG
>  	  Support for the watchdog in the WM8350 AudioPlus PMIC.  When
>  	  the watchdog triggers the system will be reset.
>  
> +config ALTERA_WDT
> +	tristate "Altera Watchdog Timer"
> +	depends on OF
> +	help
> +	  Support for the Altera Timer in the Watchdog Timer configuration. This
> +	  component is found on SOPC (System on Programmable Chip) for Altera
> +	  FPGAs.
> +
>  # ALPHA Architecture
>  
>  # ARM Architecture
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index fd9c8c0..48a2167 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -153,4 +153,5 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
>  obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
>  obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
>  obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
> +obj-$(CONFIG_ALTERA_WDT) += altera_wdt.o
>  obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
> diff --git a/drivers/watchdog/altera_wdt.c b/drivers/watchdog/altera_wdt.c
> new file mode 100644
> index 0000000..dbced1e
> --- /dev/null
> +++ b/drivers/watchdog/altera_wdt.c
> @@ -0,0 +1,310 @@
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
> +#define WATCHDOG_NAME	"altera_wdt"
> +
> +/* Register offsets */
> +#define ALTERA_WDT_STATUS	0x00
> +#define ALTERA_WDT_CONTROL	0x04
> +#define ALTERA_WDT_PERIODL	0x08
> +#define ALTERA_WDT_PERIODH	0x0C
> +
> +#define ALTERA_WDT_RUN_BIT	0x04
> +
> +/* User land timeout */
> +#define WDT_HEARTBEAT 15
> +static int heartbeat = WDT_HEARTBEAT;
> +module_param(heartbeat, int, 0);
> +MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
> +	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
> +
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
> +	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +static struct {
> +	void __iomem *base;
> +	unsigned long wdt_timeout;	/* timeout of the hardware timer */
> +
> +	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
> +	unsigned long is_open;
> +	char expect_close;
> +	struct timer_list timer;	/* software timer that pings the watchdog */
> +} altera_wdt_priv;
> +
> +/*
> + * Start the watchdog. Once it has been started, it cannot be stopped anymore.
> + */
> +static int altera_wdt_setup(void)
> +{
> +	u32 control = readl(altera_wdt_priv.base + ALTERA_WDT_CONTROL);
> +
> +	writel(control | ALTERA_WDT_RUN_BIT, altera_wdt_priv.base + ALTERA_WDT_CONTROL);
> +	return 0;
> +}

Looks like this could be made static void.

Jamie
