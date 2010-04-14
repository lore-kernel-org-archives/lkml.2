Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0DNNft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:35:49 -0400
Received: from bamako.nerim.net ([62.4.17.28]:50862 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0DNNfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:35:46 -0400
Date: Wed, 14 Apr 2010 15:35:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re:
Message-ID: <20100414153543.4d0291a2@hyperion.delvare>
In-Reply-To: <20100414125234.23507.42816.stgit@localhost.localdomain>
References: <20100414125234.23507.42816.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 13:54:02 +0100, Alan Cox wrote:
> Subject: [FOR COMMENT] cy8ctmg110 for review
> 
> From: Samuli Konttila <samuli.konttila@aavamobile.com>
> 
> Add support for the cy8ctmg110 capacitive touchscreen used on some embedded
> devices.
> 
> (Some clean up by Alan Cox)
> 
> (No signed off, not yet ready to go in)
> ---
> 
>  drivers/input/touchscreen/Kconfig         |   12 +
>  drivers/input/touchscreen/Makefile        |    3 
>  drivers/input/touchscreen/cy8ctmg110_ts.c |  521 +++++++++++++++++++++++++++++
>  3 files changed, 535 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/input/touchscreen/cy8ctmg110_ts.c
> 
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index b3ba374..89a3eb1 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -591,4 +591,16 @@ config TOUCHSCREEN_TPS6507X
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tps6507x_ts.
>  
> +config TOUCHSCREEN_CY8CTMG110
> +	tristate "cy8ctmg110 touchscreen"
> +	depends on I2C
> +	help
> +	  Say Y here if you have a cy8ctmg110 touchscreen capacitive
> +	  touchscreen
> +
> +	  If unsure, say N.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called cy8ctmg110_ts.
> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index dfb7239..c7acb65 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -1,5 +1,5 @@
>  #
> -# Makefile for the touchscreen drivers.
> +# Makefile for the touchscreen drivers.mororor

I confirm, not yet ready to go in ;)

>  #
>  
>  # Each configuration option enables a list of files.
> @@ -12,6 +12,7 @@ obj-$(CONFIG_TOUCHSCREEN_AD7879)	+= ad7879.o
>  obj-$(CONFIG_TOUCHSCREEN_ADS7846)	+= ads7846.o
>  obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+= atmel_tsadcc.o
>  obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
> +obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)    += cy8ctmg110_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
>  obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
>  obj-$(CONFIG_TOUCHSCREEN_EETI)		+= eeti_ts.o
> diff --git a/drivers/input/touchscreen/cy8ctmg110_ts.c b/drivers/input/touchscreen/cy8ctmg110_ts.c
> new file mode 100644
> index 0000000..4adbe87
> --- /dev/null
> +++ b/drivers/input/touchscreen/cy8ctmg110_ts.c
> @@ -0,0 +1,521 @@
> +/*
> + * cy8ctmg110_ts.c Driver for cypress touch screen controller
> + * Copyright (c) 2009 Aava Mobile
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <asm/io.h>
> +#include <linux/i2c.h>
> +#include <linux/timer.h>
> +#include <linux/gpio.h>
> +#include <linux/hrtimer.h>
> +
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <asm/ioctl.h>
> +#include <asm/uaccess.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <asm/ioctl.h>
> +#include <linux/fs.h>
> +#include <linux/init.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>

What a mess. Countless duplicates includes... Seriously, I'm not even
reviewing further.

-- 
Jean Delvare
