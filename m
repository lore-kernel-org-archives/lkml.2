Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0JSJog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:44:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:59155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab0JSJof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:44:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="618132233"
Date: Tue, 19 Oct 2010 11:44:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: Add WM831x SPI support
Message-ID: <20101019094422.GG2736@sortiz-mobl>
References: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1286573003-13889-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286573003-13889-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Oct 08, 2010 at 02:23:23PM -0700, Mark Brown wrote:
> Implement support for controlling WM831x and WM832x devices using SPI.
Patch applied, many thanks.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Resending as my finger macro sent these to the ALSA list.
> 
>  drivers/mfd/Kconfig      |   10 ++
>  drivers/mfd/Makefile     |    1 +
>  drivers/mfd/wm831x-spi.c |  232 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 243 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/wm831x-spi.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 608a277..40aa2e8 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -328,6 +328,16 @@ config MFD_WM831X_I2C
>  	  for accessing the device, additional drivers must be enabled in
>  	  order to use the functionality of the device.
>  
> +config MFD_WM831X_SPI
> +	bool "Support Wolfson Microelectronics WM831x/2x PMICs with SPI"
> +	select MFD_CORE
> +	depends on SPI_MASTER && GENERIC_HARDIRQS
> +	help
> +	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
> +	  when controlled using SPI.  This driver provides common support
> +	  for accessing the device, additional drivers must be enabled in
> +	  order to use the functionality of the device.
> +
>  config MFD_WM8350
>  	bool
>  	depends on GENERIC_HARDIRQS
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index c9ef41b..f54b365 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -25,6 +25,7 @@ obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
>  wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
>  obj-$(CONFIG_MFD_WM831X)	+= wm831x.o
>  obj-$(CONFIG_MFD_WM831X_I2C)	+= wm831x-i2c.o
> +obj-$(CONFIG_MFD_WM831X_SPI)	+= wm831x-spi.o
>  wm8350-objs			:= wm8350-core.o wm8350-regmap.o wm8350-gpio.o
>  wm8350-objs			+= wm8350-irq.o
>  obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
> diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
> new file mode 100644
> index 0000000..073d4c6
> --- /dev/null
> +++ b/drivers/mfd/wm831x-spi.c
> @@ -0,0 +1,232 @@
> +/*
> + * wm831x-spi.c  --  SPI access for Wolfson WM831x PMICs
> + *
> + * Copyright 2009,2010 Wolfson Microelectronics PLC.
> + *
> + * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spi/spi.h>
> +
> +#include <linux/mfd/wm831x/core.h>
> +
> +static int wm831x_spi_read_device(struct wm831x *wm831x, unsigned short reg,
> +				  int bytes, void *dest)
> +{
> +	u16 tx_val;
> +	u16 *d = dest;
> +	int r, ret;
> +
> +	/* Go register at a time */
> +	for (r = reg; r < reg + (bytes / 2); r++) {
> +		tx_val = r | 0x8000;
> +
> +		ret = spi_write_then_read(wm831x->control_data,
> +					  (u8 *)&tx_val, 2, (u8 *)d, 2);
> +		if (ret != 0)
> +			return ret;
> +
> +		*d = be16_to_cpu(*d);
> +
> +		d++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int wm831x_spi_write_device(struct wm831x *wm831x, unsigned short reg,
> +				   int bytes, void *src)
> +{
> +	struct spi_device *spi = wm831x->control_data;
> +	u16 *s = src;
> +	u16 data[2];
> +	int ret;
> +
> +	/* Go register at a time */
> +	for (r = reg; r < reg + (bytes / 2); r++) {
> +		data[0] = r;
> +		data[1] = *s++;
> +
> +		ret = spi_write(spi, (char *)&data, sizeof(data));
> +		if (ret != 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devinit wm831x_spi_probe(struct spi_device *spi)
> +{
> +	struct wm831x *wm831x;
> +	enum wm831x_parent type;
> +
> +	/* Currently SPI support for ID tables is unmerged, we're faking it */
> +	if (strcmp(spi->modalias, "wm8310") == 0)
> +		type = WM8310;
> +	else if (strcmp(spi->modalias, "wm8311") == 0)
> +		type = WM8311;
> +	else if (strcmp(spi->modalias, "wm8312") == 0)
> +		type = WM8312;
> +	else if (strcmp(spi->modalias, "wm8320") == 0)
> +		type = WM8320;
> +	else if (strcmp(spi->modalias, "wm8321") == 0)
> +		type = WM8321;
> +	else if (strcmp(spi->modalias, "wm8325") == 0)
> +		type = WM8325;
> +	else {
> +		dev_err(&spi->dev, "Unknown device type\n");
> +		return -EINVAL;
> +	}
> +
> +	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
> +	if (wm831x == NULL)
> +		return -ENOMEM;
> +
> +	spi->bits_per_word = 16;
> +	spi->mode = SPI_MODE_0;
> +
> +	dev_set_drvdata(&spi->dev, wm831x);
> +	wm831x->dev = &spi->dev;
> +	wm831x->control_data = spi;
> +	wm831x->read_dev = wm831x_spi_read_device;
> +	wm831x->write_dev = wm831x_spi_write_device;
> +
> +	return wm831x_device_init(wm831x, type, spi->irq);
> +}
> +
> +static int __devexit wm831x_spi_remove(struct spi_device *spi)
> +{
> +	struct wm831x *wm831x = dev_get_drvdata(&spi->dev);
> +
> +	wm831x_device_exit(wm831x);
> +
> +	return 0;
> +}
> +
> +static int wm831x_spi_suspend(struct spi_device *spi, pm_message_t m)
> +{
> +	struct wm831x *wm831x = dev_get_drvdata(&spi->dev);
> +
> +	return wm831x_device_suspend(wm831x);
> +}
> +
> +static struct spi_driver wm8310_spi_driver = {
> +	.driver = {
> +		.name	= "wm8310",
> +		.bus	= &spi_bus_type,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= wm831x_spi_probe,
> +	.remove		= __devexit_p(wm831x_spi_remove),
> +	.suspend	= wm831x_spi_suspend,
> +};
> +
> +static struct spi_driver wm8311_spi_driver = {
> +	.driver = {
> +		.name	= "wm8311",
> +		.bus	= &spi_bus_type,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= wm831x_spi_probe,
> +	.remove		= __devexit_p(wm831x_spi_remove),
> +	.suspend	= wm831x_spi_suspend,
> +};
> +
> +static struct spi_driver wm8312_spi_driver = {
> +	.driver = {
> +		.name	= "wm8312",
> +		.bus	= &spi_bus_type,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= wm831x_spi_probe,
> +	.remove		= __devexit_p(wm831x_spi_remove),
> +	.suspend	= wm831x_spi_suspend,
> +};
> +
> +static struct spi_driver wm8320_spi_driver = {
> +	.driver = {
> +		.name	= "wm8320",
> +		.bus	= &spi_bus_type,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= wm831x_spi_probe,
> +	.remove		= __devexit_p(wm831x_spi_remove),
> +	.suspend	= wm831x_spi_suspend,
> +};
> +
> +static struct spi_driver wm8321_spi_driver = {
> +	.driver = {
> +		.name	= "wm8321",
> +		.bus	= &spi_bus_type,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= wm831x_spi_probe,
> +	.remove		= __devexit_p(wm831x_spi_remove),
> +	.suspend	= wm831x_spi_suspend,
> +};
> +
> +static struct spi_driver wm8325_spi_driver = {
> +	.driver = {
> +		.name	= "wm8325",
> +		.bus	= &spi_bus_type,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= wm831x_spi_probe,
> +	.remove		= __devexit_p(wm831x_spi_remove),
> +	.suspend	= wm831x_spi_suspend,
> +};
> +
> +static int __init wm831x_spi_init(void)
> +{
> +	int ret;
> +
> +	ret = spi_register_driver(&wm8310_spi_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register WM8310 SPI driver: %d\n", ret);
> +
> +	ret = spi_register_driver(&wm8311_spi_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register WM8311 SPI driver: %d\n", ret);
> +
> +	ret = spi_register_driver(&wm8312_spi_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register WM8312 SPI driver: %d\n", ret);
> +
> +	ret = spi_register_driver(&wm8320_spi_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register WM8320 SPI driver: %d\n", ret);
> +
> +	ret = spi_register_driver(&wm8321_spi_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register WM8321 SPI driver: %d\n", ret);
> +
> +	ret = spi_register_driver(&wm8325_spi_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register WM8325 SPI driver: %d\n", ret);
> +
> +	return 0;
> +}
> +subsys_initcall(wm831x_spi_init);
> +
> +static void __exit wm831x_spi_exit(void)
> +{
> +	spi_unregister_driver(&wm8325_spi_driver);
> +	spi_unregister_driver(&wm8321_spi_driver);
> +	spi_unregister_driver(&wm8320_spi_driver);
> +	spi_unregister_driver(&wm8312_spi_driver);
> +	spi_unregister_driver(&wm8311_spi_driver);
> +	spi_unregister_driver(&wm8310_spi_driver);
> +}
> +module_exit(wm831x_spi_exit);
> +
> +MODULE_DESCRIPTION("SPI support for WM831x/2x AudioPlus PMICs");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mark Brown");
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
