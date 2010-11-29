Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0K2CoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:44:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:49844 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0K2CoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:44:19 -0500
Subject: Re: [PATCH 3/5] fpga: add basic CARMA board support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1283964082-30133-4-git-send-email-iws@ovro.caltech.edu>
References: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
	 <1283964082-30133-4-git-send-email-iws@ovro.caltech.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 11:36:18 +1100
Message-ID: <1290990978.32570.211.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 09:41 -0700, Ira W. Snyder wrote:
> This adds basic support for the system controller FPGA on the OVRO CARMA
> board. This patch only adds infrastructure that will be used by later
> drivers.

One comment I have is do you really need to create a class ? Do you
provide a specific API/interface that would make it useful ?

Cheers,
Ben.

> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> ---
>  drivers/Kconfig             |    2 +
>  drivers/Makefile            |    1 +
>  drivers/fpga/Kconfig        |    1 +
>  drivers/fpga/Makefile       |    1 +
>  drivers/fpga/carma/Kconfig  |   21 ++++++++++++
>  drivers/fpga/carma/Makefile |    1 +
>  drivers/fpga/carma/carma.c  |   73 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/fpga/carma/carma.h  |   22 +++++++++++++
>  8 files changed, 122 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/fpga/Kconfig
>  create mode 100644 drivers/fpga/Makefile
>  create mode 100644 drivers/fpga/carma/Kconfig
>  create mode 100644 drivers/fpga/carma/Makefile
>  create mode 100644 drivers/fpga/carma/carma.c
>  create mode 100644 drivers/fpga/carma/carma.h
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index a2b902f..8945ae6 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -111,4 +111,6 @@ source "drivers/xen/Kconfig"
>  source "drivers/staging/Kconfig"
>  
>  source "drivers/platform/Kconfig"
> +
> +source "drivers/fpga/Kconfig"
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index ae47344..c0b05de 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -115,3 +115,4 @@ obj-$(CONFIG_VLYNQ)		+= vlynq/
>  obj-$(CONFIG_STAGING)		+= staging/
>  obj-y				+= platform/
>  obj-y				+= ieee802154/
> +obj-$(CONFIG_FPGA_DRIVERS)	+= fpga/
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> new file mode 100644
> index 0000000..c85c2cc
> --- /dev/null
> +++ b/drivers/fpga/Kconfig
> @@ -0,0 +1 @@
> +source "drivers/fpga/carma/Kconfig"
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> new file mode 100644
> index 0000000..409a5f9
> --- /dev/null
> +++ b/drivers/fpga/Makefile
> @@ -0,0 +1 @@
> +obj-y		+= carma/
> diff --git a/drivers/fpga/carma/Kconfig b/drivers/fpga/carma/Kconfig
> new file mode 100644
> index 0000000..448885e
> --- /dev/null
> +++ b/drivers/fpga/carma/Kconfig
> @@ -0,0 +1,21 @@
> +
> +menuconfig FPGA_DRIVERS
> +	bool "FPGA Drivers"
> +	default n
> +	help
> +	  Say Y here to see options for devices used with custom FPGAs.
> +	  This option alone does not add any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.
> +
> +if FPGA_DRIVERS
> +
> +config CARMA
> +	tristate "CARMA System Controller FPGA support"
> +	depends on FSL_SOC && PPC_83xx
> +	default n
> +	help
> +	  Say Y here to include basic support for the CARMA System Controller
> +	  FPGA. This option allows the other more advanced drivers to be built.
> +
> +endif # FPGA_DRIVERS
> diff --git a/drivers/fpga/carma/Makefile b/drivers/fpga/carma/Makefile
> new file mode 100644
> index 0000000..90d0594
> --- /dev/null
> +++ b/drivers/fpga/carma/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_CARMA)			+= carma.o
> diff --git a/drivers/fpga/carma/carma.c b/drivers/fpga/carma/carma.c
> new file mode 100644
> index 0000000..97549d2
> --- /dev/null
> +++ b/drivers/fpga/carma/carma.c
> @@ -0,0 +1,73 @@
> +/*
> + * CARMA Board Utility Driver
> + *
> + * Copyright (c) 2009-2010 Ira W. Snyder <iws@ovro.caltech.edu>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +
> +#include "carma.h"
> +
> +static struct class *carma_class;
> +static const char drv_name[] = "carma";
> +
> +/*
> + * CARMA Device Class Functions
> + */
> +
> +struct device *carma_device_create(struct device *parent, dev_t devno,
> +				   const char *fmt, ...)
> +{
> +	struct device *dev;
> +	va_list vargs;
> +
> +	va_start(vargs, fmt);
> +	dev = device_create_vargs(carma_class, parent, devno, NULL, fmt, vargs);
> +	va_end(vargs);
> +
> +	return dev;
> +}
> +EXPORT_SYMBOL_GPL(carma_device_create);
> +
> +void carma_device_destroy(dev_t devno)
> +{
> +	device_destroy(carma_class, devno);
> +}
> +EXPORT_SYMBOL_GPL(carma_device_destroy);
> +
> +/*
> + * Module Init / Exit
> + */
> +
> +static int __init carma_init(void)
> +{
> +	/* Register the CARMA device class */
> +	carma_class = class_create(THIS_MODULE, "carma");
> +	if (IS_ERR(carma_class)) {
> +		pr_err("%s: unable to create CARMA class\n", drv_name);
> +		return PTR_ERR(carma_class);
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit carma_exit(void)
> +{
> +	class_destroy(carma_class);
> +}
> +
> +MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
> +MODULE_DESCRIPTION("CARMA Device Class Driver");
> +MODULE_LICENSE("GPL");
> +
> +module_init(carma_init);
> +module_exit(carma_exit);
> diff --git a/drivers/fpga/carma/carma.h b/drivers/fpga/carma/carma.h
> new file mode 100644
> index 0000000..f556dc8
> --- /dev/null
> +++ b/drivers/fpga/carma/carma.h
> @@ -0,0 +1,22 @@
> +/*
> + * CARMA Board Utilities
> + *
> + * Copyright (c) 2009-2010 Ira W. Snyder <iws@ovro.caltech.edu>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2 of the License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef CARMA_DEVICE_H
> +#define CARMA_DEVICE_H
> +
> +#include <linux/device.h>
> +
> +struct device *carma_device_create(struct device *parent, dev_t devno,
> +				   const char *fmt, ...)
> +				   __attribute__((format(printf, 3, 4)));
> +void carma_device_destroy(dev_t devno);
> +
> +#endif /* CARMA_DEVICE_H */


