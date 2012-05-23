Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab2EWTEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:04:13 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:54211 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933877Ab2EWTEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:04:11 -0400
Date: Wed, 23 May 2012 21:04:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>, sameo@linux.intel.com
Subject: Re: [PATCH] Watchdog: DA9052/53 PMIC watchdog support v3
Message-ID: <20120523190410.GO3074@spo001.leaseweb.com>
References: <1334753066.8143.44.camel@dhruva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334753066.8143.44.camel@dhruva>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

> This driver adds support for the watchdog functionality provided by the Dialog
> Semiconductor DA9052 PMIC chip.
> 
> Signed-off-by: Anthony Olech <Anthony.Olech@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
> Changes since V3:
> - Add new watchdog framework
> Changes since V2:
> - Code restructured for simplicty.
> - Add watchdog documentation.
> - Remove Auto strobing feature.
> - Remove strobe filtering flag.
> ---
>  Documentation/watchdog/watchdog-parameters.txt |    3 +
>  drivers/watchdog/Kconfig                       |    7 +
>  drivers/watchdog/Makefile                      |    1 +
>  drivers/watchdog/da9052_wdt.c                  |  223 ++++++++++++++++++++++++
>  4 files changed, 234 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/watchdog/watchdog-parameters.txt b/Documentation/watchdog/watchdog-parameters.txt
> index 17ddd82..b1a65eb 100644
> --- a/Documentation/watchdog/watchdog-parameters.txt
> +++ b/Documentation/watchdog/watchdog-parameters.txt
> @@ -78,6 +78,9 @@ wd0_timeout: Default watchdog0 timeout in 1/10secs
>  wd1_timeout: Default watchdog1 timeout in 1/10secs
>  wd2_timeout: Default watchdog2 timeout in 1/10secs
>  -------------------------------------------------
> +da9052_wdt:
> +timeout: Watchdog timeout in seconds. 2<= timeout <=131, default=4.096s
> +-------------------------------------------------
>  davinci_wdt:
>  heartbeat: Watchdog heartbeat period in seconds from 1 to 600, default 60
>  -------------------------------------------------
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index eeea76f..ece08cf 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -64,6 +64,13 @@ config SOFT_WATCHDOG
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called softdog.
>  
> +config DA9052_WATCHDOG
> +	tristate "Dialog DA9052 Watchdog"
> +	depends on PMIC_DA9052
> +	select WATCHDOG_CORE
> +	help
> +	  Support for the watchdog in the DA9052 PMIC.
> +
>  config WM831X_WATCHDOG
>  	tristate "WM831x watchdog"
>  	depends on MFD_WM831X
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index e8f479a..b3032e9 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -167,3 +167,4 @@ obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
>  obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
>  obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
>  obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
> +obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
> diff --git a/drivers/watchdog/da9052_wdt.c b/drivers/watchdog/da9052_wdt.c
> new file mode 100644
> index 0000000..ca7f907
> --- /dev/null
> +++ b/drivers/watchdog/da9052_wdt.c
> @@ -0,0 +1,223 @@
> +/*
> + * System monitoring driver for DA9052 PMICs.
> + *
> + * Copyright(c) 2012 Dialog Semiconductor Ltd.
> + *
> + * Author: Dajun Chen <dchen@diasemi.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/uaccess.h>
> +#include <linux/platform_device.h>
> +#include <linux/time.h>
> +#include <linux/watchdog.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +
> +#include <linux/mfd/da9052/reg.h>
> +#include <linux/mfd/da9052/da9052.h>
> +
> +#define DA9052_DEF_TIMEOUT	4
> +
> +struct da9052_wdt_drvdata {
> +	struct watchdog_device wdt;
> +	struct da9052 *da9052;
> +	struct mutex lock;
> +};
> +
> +static const struct {
> +	u8 reg_val;
> +	int time;  /* Seconds */

shouldn't this be unsigned int time?

> +} da9052_wdt_maps[] = {
> +	{ 1, 2 },
> +	{ 2, 4 },
> +	{ 3, 8 },
> +	{ 4, 16 },
> +	{ 5, 32 },
> +	{ 5, 33 },  /* Actual time  32.768s so included both 32s and 33s */
> +	{ 6, 65 },
> +	{ 6, 66 },  /* Actual time 65.536s so include both, 65s and 66s */
> +	{ 7, 131 },
> +};
> +
> +static int da9052_wdt_set_timeout(struct watchdog_device *wdt_dev,
> +				  unsigned int timeout)
> +{
> +	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
> +	struct da9052 *da9052 = driver_data->da9052;
> +	int ret, i;
> +
> +	/* Disable the Watchdog timer before setting
> +	 * new time out.
> +	 */

Minor remark: comment should be according to codingstyle.

> +	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
> +				DA9052_CONTROLD_TWDSCALE, 0);
> +	if (ret < 0) {
> +		dev_err(da9052->dev, "Failed to disable watchdog bit, %d\n",
> +			ret);
> +		return ret;
> +	}
> +	if (timeout) {
> +		/* To change the timeout, da9052 needs to
> +		 * be disabled for at least 150 us.
> +		 */
> +		udelay(150);
> +
> +		/* Set the desired timeout */
> +		for (i = 0; i < ARRAY_SIZE(da9052_wdt_maps); i++)
> +			if (da9052_wdt_maps[i].time == timeout)
> +				break;
> +
> +		if (i == ARRAY_SIZE(da9052_wdt_maps))
> +			ret = -EINVAL;
> +		else
> +			ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
> +						DA9052_CONTROLD_TWDSCALE,
> +						da9052_wdt_maps[i].reg_val);
> +		if (ret < 0) {
> +			dev_err(da9052->dev,
> +				"Failed to update timescale bit, %d\n", ret);
> +			return ret;
> +		}

Here the mdelay should be added... (Don't know the exact value for TWDMIN is).

> +	}

You should set the watchdog timeout here... So something like:
	wdt_dev->timeout = timeout;

> +
> +	return 0;
> +}
> +
> +static int da9052_wdt_start(struct watchdog_device *wdt_dev)
> +{
> +	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
> +	int ret = 0;

can be "int ret;" since the value will always be filled by the return of da9052_wdt_set_timeout.

> +
> +	mutex_lock(&driver_data->lock);

Mutex lock is not needed anymore.
We have a patch from Hans de Goede now that does this in the core.

> +	ret = da9052_wdt_set_timeout(wdt_dev, DA9052_DEF_TIMEOUT);

Hmm, if you do a start, set_timeout, stop and then a new start then you want to have the changed timeout and not the default timeout. So it's better to do da9052_wdt_set_timeout(wdt_dev, wdt_dev->timeout);

> +	mutex_unlock(&driver_data->lock);
> +
> +	return ret;
> +}

Since the mutex is not needed anymore, you can even forget about the int ret (and even the driver_data) and just do:
	return da9052_wdt_set_timeout(wdt_dev, wdt_dev->timeout);

> +
> +static int da9052_wdt_stop(struct watchdog_device *wdt_dev)
> +{
> +	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
> +	struct da9052 *da9052 = driver_data->da9052;
> +	int ret = 0;
> +
> +	mutex_lock(&driver_data->lock);
> +	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
> +				DA9052_CONTROLD_TWDSCALE, 0);
> +	mutex_unlock(&driver_data->lock);
> +
> +	return ret;
> +}

And this can be: return da9052_wdt_set_timeout(wdt_dev, 0);

> +
> +static int da9052_wdt_ping(struct watchdog_device *wdt_dev)
> +{
> +	struct da9052_wdt_drvdata *driver_data = watchdog_get_drvdata(wdt_dev);
> +	struct da9052 *da9052 = driver_data->da9052;
> +	int ret;
> +
> +	mutex_lock(&driver_data->lock);
> +	/* Reset the watchdog timer */
> +	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
> +				DA9052_CONTROLD_WATCHDOG, 1 << 7);
> +	if (ret < 0)
> +		goto err_strobe;
> +
> +	/* FIXME: Reset the watchdog core, in general PMIC
> +	 * is supposed to do this
> +	 */
> +	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
> +				DA9052_CONTROLD_WATCHDOG, 0 << 7);
> +err_strobe:
> +	mutex_unlock(&driver_data->lock);
> +	return ret;
> +}
> +
> +static struct watchdog_info da9052_wdt_info = {
> +	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
> +	.identity	= "DA9052 Watchdog",
> +};
> +
> +static const struct watchdog_ops da9052_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = da9052_wdt_start,
> +	.stop = da9052_wdt_stop,
> +	.ping = da9052_wdt_ping,
> +	.set_timeout = da9052_wdt_set_timeout,
> +};
> +
> +
> +static int __devinit da9052_wdt_probe(struct platform_device *pdev)
> +{
> +	struct da9052 *da9052 = dev_get_drvdata(pdev->dev.parent);
> +	struct da9052_wdt_drvdata *driver_data;
> +	struct watchdog_device *da9052_wdt;
> +	int ret;
> +
> +	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
> +				   GFP_KERNEL);

Since the watchdog_device struct (part of driver_data) is dynamically allocated,
we will need to add ref and unref functions here. See code of Hans de Goede.

> +	if (!driver_data) {
> +		dev_err(da9052->dev, "Unable to alloacate watchdog device\n");

Typo: alloacate should be allocate.

> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	mutex_init(&driver_data->lock);

Also not needed anymore (just as all mutex_lock and mutex_unlocks).

> +	driver_data->da9052 = da9052;
> +
> +	da9052_wdt = &driver_data->wdt;
> +
> +	da9052_wdt->info = &da9052_wdt_info;
> +	da9052_wdt->ops = &da9052_wdt_ops;

You should set da9052->timeout here so that the WDIOC_GET_TIMEOUT call will give you a correct result.
min_timeout and max_timeout are also possible.

> +	watchdog_set_drvdata(da9052_wdt, driver_data);
> +
> +	ret = da9052_reg_update(da9052, DA9052_CONTROL_D_REG,
> +				DA9052_CONTROLD_TWDSCALE, 0);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to disable watchdog bits, %d\n",
> +			ret);
> +		goto err;
> +	}
> +
> +	ret = watchdog_register_device(&driver_data->wdt);
> +	if (ret != 0) {
> +		dev_err(da9052->dev, "watchdog_register_device() failed: %d\n",
> +			ret);
> +		goto err;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, driver_data);
> +err:
> +	return ret;
> +}
> +
> +static int __devexit da9052_wdt_remove(struct platform_device *pdev)
> +{
> +	struct da9052_wdt_drvdata *driver_data = dev_get_drvdata(&pdev->dev);
> +
> +	watchdog_unregister_device(&driver_data->wdt);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_wdt_driver = {
> +	.probe = da9052_wdt_probe,
> +	.remove = __devexit_p(da9052_wdt_remove),
> +	.driver = {
> +		.name	= "da9052-watchdog",
> +	},
> +};
> +
> +module_platform_driver(da9052_wdt_driver);
> +
> +MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
> +MODULE_DESCRIPTION("DA9052 SM Device Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:da9052-wdt");

Shouldn't this be:
MODULE_ALIAS("platform:da9052-watchdog"); ?

Kind regards,
Wim.

