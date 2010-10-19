Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab0JSJnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:43:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:12171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933461Ab0JSJng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:43:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,349,1283756400"; 
   d="scan'208";a="565345873"
Date: Tue, 19 Oct 2010 11:43:19 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Factor out WM831x I2C I/O from the core driver
Message-ID: <20101019094317.GF2736@sortiz-mobl>
References: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 02:23:22PM -0700, Mark Brown wrote:
> In preparation for the addition of SPI support for the WM831x move the I2C
> specific code into a separate file with a separate Kconfig option so the
> I2C support can be excluded from the build.
> 
> Also update the 1133-EV1 PMIC module support for SMDK6410 to use the new
> symbol.
Sorry, that's the one I applied.

Cheers,
Samuel.

 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Resending as my finger macro sent these to the ALSA list.
> 
>  arch/arm/mach-s3c64xx/Kconfig   |    1 +
>  drivers/mfd/Kconfig             |   14 +++--
>  drivers/mfd/Makefile            |    1 +
>  drivers/mfd/wm831x-core.c       |  138 +------------------------------------
>  drivers/mfd/wm831x-i2c.c        |  143 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/wm831x/core.h |   12 +++
>  6 files changed, 170 insertions(+), 139 deletions(-)
>  create mode 100644 drivers/mfd/wm831x-i2c.c
> 
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index 1e4d78a..546db5c 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -185,6 +185,7 @@ config SMDK6410_WM1192_EV1
>  	select REGULATOR_WM831X
>  	select S3C24XX_GPIO_EXTRA64
>  	select MFD_WM831X
> +	select MFD_WM831X_I2C
>  	help
>  	  The Wolfson Microelectronics 1192-EV1 is a WM831x based PMIC
>  	  daughtercard for the Samsung SMDK6410 reference platform.
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 6c6b9f0..608a277 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -315,14 +315,18 @@ config MFD_WM8400
>  	  the functionality of the device.
>  
>  config MFD_WM831X
> -	bool "Support Wolfson Microelectronics WM831x/2x PMICs"
> +	bool
> +	depends on GENERIC_HARDIRQS
> +
> +config MFD_WM831X_I2C
> +	bool "Support Wolfson Microelectronics WM831x/2x PMICs with I2C"
>  	select MFD_CORE
>  	depends on I2C=y && GENERIC_HARDIRQS
>  	help
> -	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs.
> -	  This driver provides common support for accessing the device,
> -	  additional drivers must be enabled in order to use the
> -	  functionality of the device.
> +	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs
> +	  when controlled using I2C.  This driver provides common support
> +	  for accessing the device, additional drivers must be enabled in
> +	  order to use the functionality of the device.
>  
>  config MFD_WM8350
>  	bool
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 70b2699..c9ef41b 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -24,6 +24,7 @@ obj-$(CONFIG_MFD_TC6393XB)	+= tc6393xb.o tmio_core.o
>  obj-$(CONFIG_MFD_WM8400)	+= wm8400-core.o
>  wm831x-objs			:= wm831x-core.o wm831x-irq.o wm831x-otp.o
>  obj-$(CONFIG_MFD_WM831X)	+= wm831x.o
> +obj-$(CONFIG_MFD_WM831X_I2C)	+= wm831x-i2c.o
>  wm8350-objs			:= wm8350-core.o wm8350-regmap.o wm8350-gpio.o
>  wm8350-objs			+= wm8350-irq.o
>  obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
> diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
> index ad36579..7d2563f 100644
> --- a/drivers/mfd/wm831x-core.c
> +++ b/drivers/mfd/wm831x-core.c
> @@ -14,7 +14,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/i2c.h>
>  #include <linux/bcd.h>
>  #include <linux/delay.h>
>  #include <linux/mfd/core.h>
> @@ -90,15 +89,6 @@ int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL + 1] = {
>  };
>  EXPORT_SYMBOL_GPL(wm831x_isinkv_values);
>  
> -enum wm831x_parent {
> -	WM8310 = 0x8310,
> -	WM8311 = 0x8311,
> -	WM8312 = 0x8312,
> -	WM8320 = 0x8320,
> -	WM8321 = 0x8321,
> -	WM8325 = 0x8325,
> -};
> -
>  static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
>  {
>  	if (!wm831x->locked)
> @@ -1447,7 +1437,7 @@ static struct mfd_cell backlight_devs[] = {
>  /*
>   * Instantiate the generic non-control parts of the device.
>   */
> -static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
> +int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
>  {
>  	struct wm831x_pdata *pdata = wm831x->dev->platform_data;
>  	int rev;
> @@ -1673,7 +1663,7 @@ err:
>  	return ret;
>  }
>  
> -static void wm831x_device_exit(struct wm831x *wm831x)
> +void wm831x_device_exit(struct wm831x *wm831x)
>  {
>  	wm831x_otp_exit(wm831x);
>  	mfd_remove_devices(wm831x->dev);
> @@ -1683,7 +1673,7 @@ static void wm831x_device_exit(struct wm831x *wm831x)
>  	kfree(wm831x);
>  }
>  
> -static int wm831x_device_suspend(struct wm831x *wm831x)
> +int wm831x_device_suspend(struct wm831x *wm831x)
>  {
>  	int reg, mask;
>  
> @@ -1719,126 +1709,6 @@ static int wm831x_device_suspend(struct wm831x *wm831x)
>  	return 0;
>  }
>  
> -static int wm831x_i2c_read_device(struct wm831x *wm831x, unsigned short reg,
> -				  int bytes, void *dest)
> -{
> -	struct i2c_client *i2c = wm831x->control_data;
> -	int ret;
> -	u16 r = cpu_to_be16(reg);
> -
> -	ret = i2c_master_send(i2c, (unsigned char *)&r, 2);
> -	if (ret < 0)
> -		return ret;
> -	if (ret != 2)
> -		return -EIO;
> -
> -	ret = i2c_master_recv(i2c, dest, bytes);
> -	if (ret < 0)
> -		return ret;
> -	if (ret != bytes)
> -		return -EIO;
> -	return 0;
> -}
> -
> -/* Currently we allocate the write buffer on the stack; this is OK for
> - * small writes - if we need to do large writes this will need to be
> - * revised.
> - */
> -static int wm831x_i2c_write_device(struct wm831x *wm831x, unsigned short reg,
> -				   int bytes, void *src)
> -{
> -	struct i2c_client *i2c = wm831x->control_data;
> -	unsigned char msg[bytes + 2];
> -	int ret;
> -
> -	reg = cpu_to_be16(reg);
> -	memcpy(&msg[0], &reg, 2);
> -	memcpy(&msg[2], src, bytes);
> -
> -	ret = i2c_master_send(i2c, msg, bytes + 2);
> -	if (ret < 0)
> -		return ret;
> -	if (ret < bytes + 2)
> -		return -EIO;
> -
> -	return 0;
> -}
> -
> -static int wm831x_i2c_probe(struct i2c_client *i2c,
> -			    const struct i2c_device_id *id)
> -{
> -	struct wm831x *wm831x;
> -
> -	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
> -	if (wm831x == NULL)
> -		return -ENOMEM;
> -
> -	i2c_set_clientdata(i2c, wm831x);
> -	wm831x->dev = &i2c->dev;
> -	wm831x->control_data = i2c;
> -	wm831x->read_dev = wm831x_i2c_read_device;
> -	wm831x->write_dev = wm831x_i2c_write_device;
> -
> -	return wm831x_device_init(wm831x, id->driver_data, i2c->irq);
> -}
> -
> -static int wm831x_i2c_remove(struct i2c_client *i2c)
> -{
> -	struct wm831x *wm831x = i2c_get_clientdata(i2c);
> -
> -	wm831x_device_exit(wm831x);
> -
> -	return 0;
> -}
> -
> -static int wm831x_i2c_suspend(struct i2c_client *i2c, pm_message_t mesg)
> -{
> -	struct wm831x *wm831x = i2c_get_clientdata(i2c);
> -
> -	return wm831x_device_suspend(wm831x);
> -}
> -
> -static const struct i2c_device_id wm831x_i2c_id[] = {
> -	{ "wm8310", WM8310 },
> -	{ "wm8311", WM8311 },
> -	{ "wm8312", WM8312 },
> -	{ "wm8320", WM8320 },
> -	{ "wm8321", WM8321 },
> -	{ "wm8325", WM8325 },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
> -
> -
> -static struct i2c_driver wm831x_i2c_driver = {
> -	.driver = {
> -		   .name = "wm831x",
> -		   .owner = THIS_MODULE,
> -	},
> -	.probe = wm831x_i2c_probe,
> -	.remove = wm831x_i2c_remove,
> -	.suspend = wm831x_i2c_suspend,
> -	.id_table = wm831x_i2c_id,
> -};
> -
> -static int __init wm831x_i2c_init(void)
> -{
> -	int ret;
> -
> -	ret = i2c_add_driver(&wm831x_i2c_driver);
> -	if (ret != 0)
> -		pr_err("Failed to register wm831x I2C driver: %d\n", ret);
> -
> -	return ret;
> -}
> -subsys_initcall(wm831x_i2c_init);
> -
> -static void __exit wm831x_i2c_exit(void)
> -{
> -	i2c_del_driver(&wm831x_i2c_driver);
> -}
> -module_exit(wm831x_i2c_exit);
> -
> -MODULE_DESCRIPTION("I2C support for the WM831X AudioPlus PMIC");
> +MODULE_DESCRIPTION("Core support for the WM831X AudioPlus PMIC");
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Mark Brown");
> diff --git a/drivers/mfd/wm831x-i2c.c b/drivers/mfd/wm831x-i2c.c
> new file mode 100644
> index 0000000..156b198
> --- /dev/null
> +++ b/drivers/mfd/wm831x-i2c.c
> @@ -0,0 +1,143 @@
> +/*
> + * wm831x-i2c.c  --  I2C access for Wolfson WM831x PMICs
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
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/core.h>
> +#include <linux/slab.h>
> +
> +#include <linux/mfd/wm831x/core.h>
> +#include <linux/mfd/wm831x/pdata.h>
> +
> +static int wm831x_i2c_read_device(struct wm831x *wm831x, unsigned short reg,
> +				  int bytes, void *dest)
> +{
> +	struct i2c_client *i2c = wm831x->control_data;
> +	int ret;
> +	u16 r = cpu_to_be16(reg);
> +
> +	ret = i2c_master_send(i2c, (unsigned char *)&r, 2);
> +	if (ret < 0)
> +		return ret;
> +	if (ret != 2)
> +		return -EIO;
> +
> +	ret = i2c_master_recv(i2c, dest, bytes);
> +	if (ret < 0)
> +		return ret;
> +	if (ret != bytes)
> +		return -EIO;
> +	return 0;
> +}
> +
> +/* Currently we allocate the write buffer on the stack; this is OK for
> + * small writes - if we need to do large writes this will need to be
> + * revised.
> + */
> +static int wm831x_i2c_write_device(struct wm831x *wm831x, unsigned short reg,
> +				   int bytes, void *src)
> +{
> +	struct i2c_client *i2c = wm831x->control_data;
> +	unsigned char msg[bytes + 2];
> +	int ret;
> +
> +	reg = cpu_to_be16(reg);
> +	memcpy(&msg[0], &reg, 2);
> +	memcpy(&msg[2], src, bytes);
> +
> +	ret = i2c_master_send(i2c, msg, bytes + 2);
> +	if (ret < 0)
> +		return ret;
> +	if (ret < bytes + 2)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int wm831x_i2c_probe(struct i2c_client *i2c,
> +			    const struct i2c_device_id *id)
> +{
> +	struct wm831x *wm831x;
> +
> +	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
> +	if (wm831x == NULL)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, wm831x);
> +	wm831x->dev = &i2c->dev;
> +	wm831x->control_data = i2c;
> +	wm831x->read_dev = wm831x_i2c_read_device;
> +	wm831x->write_dev = wm831x_i2c_write_device;
> +
> +	return wm831x_device_init(wm831x, id->driver_data, i2c->irq);
> +}
> +
> +static int wm831x_i2c_remove(struct i2c_client *i2c)
> +{
> +	struct wm831x *wm831x = i2c_get_clientdata(i2c);
> +
> +	wm831x_device_exit(wm831x);
> +
> +	return 0;
> +}
> +
> +static int wm831x_i2c_suspend(struct i2c_client *i2c, pm_message_t mesg)
> +{
> +	struct wm831x *wm831x = i2c_get_clientdata(i2c);
> +
> +	return wm831x_device_suspend(wm831x);
> +}
> +
> +static const struct i2c_device_id wm831x_i2c_id[] = {
> +	{ "wm8310", WM8310 },
> +	{ "wm8311", WM8311 },
> +	{ "wm8312", WM8312 },
> +	{ "wm8320", WM8320 },
> +	{ "wm8321", WM8321 },
> +	{ "wm8325", WM8325 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
> +
> +
> +static struct i2c_driver wm831x_i2c_driver = {
> +	.driver = {
> +		   .name = "wm831x",
> +		   .owner = THIS_MODULE,
> +	},
> +	.probe = wm831x_i2c_probe,
> +	.remove = wm831x_i2c_remove,
> +	.suspend = wm831x_i2c_suspend,
> +	.id_table = wm831x_i2c_id,
> +};
> +
> +static int __init wm831x_i2c_init(void)
> +{
> +	int ret;
> +
> +	ret = i2c_add_driver(&wm831x_i2c_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register wm831x I2C driver: %d\n", ret);
> +
> +	return ret;
> +}
> +subsys_initcall(wm831x_i2c_init);
> +
> +static void __exit wm831x_i2c_exit(void)
> +{
> +	i2c_del_driver(&wm831x_i2c_driver);
> +}
> +module_exit(wm831x_i2c_exit);
> diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
> index eb5bd4e..a1239c4 100644
> --- a/include/linux/mfd/wm831x/core.h
> +++ b/include/linux/mfd/wm831x/core.h
> @@ -238,6 +238,15 @@ struct regulator_dev;
>  
>  #define WM831X_NUM_IRQ_REGS 5
>  
> +enum wm831x_parent {
> +	WM8310 = 0x8310,
> +	WM8311 = 0x8311,
> +	WM8312 = 0x8312,
> +	WM8320 = 0x8320,
> +	WM8321 = 0x8321,
> +	WM8325 = 0x8325,
> +};
> +
>  struct wm831x {
>  	struct mutex io_lock;
>  
> @@ -285,6 +294,9 @@ int wm831x_set_bits(struct wm831x *wm831x, unsigned short reg,
>  int wm831x_bulk_read(struct wm831x *wm831x, unsigned short reg,
>  		     int count, u16 *buf);
>  
> +int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq);
> +void wm831x_device_exit(struct wm831x *wm831x);
> +int wm831x_device_suspend(struct wm831x *wm831x);
>  int wm831x_irq_init(struct wm831x *wm831x, int irq);
>  void wm831x_irq_exit(struct wm831x *wm831x);
>  
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
