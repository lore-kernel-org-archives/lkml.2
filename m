Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2JORJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:09:57 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:51165 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab2JORJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:09:56 -0400
Date: Mon, 15 Oct 2012 19:09:53 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
cc: linux-kernel@vger.kernel.org, Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH v2 1/4] mfd: add viperboard driver
In-Reply-To: <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
Message-ID: <alpine.DEB.2.01.1210151900530.27712@pmeerw.net>
References: <20120925085559.GL28670@sortiz-mobl> <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


minor nitpicking below

> From: Lars Poeschel <poeschel@lemonage.de>
> 
> Add mfd driver for Nano River Technologies viperboard.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  drivers/mfd/Kconfig            |   14 ++++
>  drivers/mfd/Makefile           |    1 +
>  drivers/mfd/viperboard.c       |  149 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/viperboard.h |   99 ++++++++++++++++++++++++++
>  4 files changed, 263 insertions(+)
>  create mode 100644 drivers/mfd/viperboard.c
>  create mode 100644 include/linux/mfd/viperboard.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b1a1462..98d9fa3 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1003,6 +1003,20 @@ config MFD_PALMAS
>  	  If you say yes here you get support for the Palmas
>  	  series of PMIC chips from Texas Instruments.
>  
> +config MFD_VIPERBOARD
> +        tristate "Support for Nano River Technologies Viperboard"

probably wrong indentation (space vs. tab)?

> +	select MFD_CORE
> +	depends on USB && IIO
> +        default n
> +        help
> +          Say yes here if you want support for Nano River Technologies
> +          Viperboard.
> +          There are mfd cell drivers available for i2c master, adc and
> +          both gpios found on the board. The spi part does not yet
> +          have a driver.
> +          You need to select the mfd cell drivers seperatly.

separately

> +          The drivers do not support all features the board exposes.
> +
>  endmenu
>  endif
>  
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 79dd22d..6ab6b64 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -128,6 +128,7 @@ obj-$(CONFIG_MFD_TPS65090)	+= tps65090.o
>  obj-$(CONFIG_MFD_AAT2870_CORE)	+= aat2870-core.o
>  obj-$(CONFIG_MFD_INTEL_MSIC)	+= intel_msic.o
>  obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
> +obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
>  obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
>  obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
>  obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> new file mode 100644
> index 0000000..8095ea2
> --- /dev/null
> +++ b/drivers/mfd/viperboard.c
> @@ -0,0 +1,149 @@
> +/*
> + *  Nano River Technologies viperboard driver
> + *
> + *  This is the core driver for the viperboard. There are cell drivers
> + *  available for I2C, ADC and both GPIOs. SPI is not yet supported

full stop (.) missing

> + *  The drivers do not support all features the board exposes. See user
> + *  manual of the viperboard.
> + *
> + *  (C) 2012 by Lemonage GmbH
> + *  Author: Lars Poeschel <poeschel@lemonage.de>
> + *  All rights reserved.
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/viperboard.h>
> +
> +#include <linux/usb.h>
> +
> +
> +static const struct usb_device_id vprbrd_table[] = {
> +	{ USB_DEVICE(0x2058, 0x1005) },   /* Nano River Technologies */
> +	{ }                               /* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, vprbrd_table);
> +
> +static void vprbrd_dev_release(struct device *dev)
> +{
> +	return;

return not needed

> +}
> +
> +static void vprbrd_free(struct vprbrd *dev)
> +{
> +	usb_put_dev(dev->usb_dev);
> +	kfree(dev);
> +}


-- 

Peter Meerwald
+43-664-2444418 (mobile)
