Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab0HJR24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 13:28:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265Ab0HJR2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 13:28:52 -0400
Date: Tue, 10 Aug 2010 10:08:33 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        Wang Qi <qi.wang@intel.com>, Andrew <andrew.chih.howe.khor@intel.com>,
        arjan@linux.intel.com, Wang Yong Y <yong.y.wang@intel.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Message-ID: <20100810170833.GC21220@suse.de>
References: <4C613101.20502@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C613101.20502@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 07:59:13PM +0900, Masayuki Ohtak wrote:
> GPIO driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. 
> Topcliff PCH has GPIO I/F. Using this I/F, it is able to access system
> devices connected to GPIO.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---
>  drivers/gpio/Kconfig    |    8 +
>  drivers/gpio/Makefile   |    1 +
>  drivers/gpio/pch_gpio.c |  901 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/gpio/pch_gpio.h |  245 +++++++++++++
>  4 files changed, 1155 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/pch_gpio.c
>  create mode 100644 drivers/gpio/pch_gpio.h
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 7face91..76701f6 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -113,6 +113,14 @@ config GPIO_SCH
>  
>  comment "I2C GPIO expanders:"
>  
> +config PCH_GPIO
> +	tristate "PCH GPIO"
> +	depends on PCI
> +	help
> +	  This driver is for PCH GPIO of Topcliff which is an IOH for x86
> +	  embedded processor.
> +	  This driver can access PCH GPIO device.
> +
>  config GPIO_MAX7300
>  	tristate "Maxim MAX7300 GPIO expander"
>  	depends on I2C
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index e53dcff..eda01b6 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -35,3 +35,4 @@ obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
>  obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
>  obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
>  obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
> +obj-$(CONFIG_PCH_GPIO)	+= pch_gpio.o
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> new file mode 100644
> index 0000000..4cf8fc0
> --- /dev/null
> +++ b/drivers/gpio/pch_gpio.c
> @@ -0,0 +1,901 @@
> +/*
> + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
> + */
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +#include <linux/fs.h>
> +#include <linux/cdev.h>
> +#include <linux/interrupt.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/sched.h>
> +#include <linux/io.h>
> +#include "pch_gpio.h"
> +
> +static void (*pch_gpio_cbr) (u32, struct pch_gpio_chip *);
> +static DEFINE_MUTEX(pch_gpio_mutex);
> +static s32 pch_gpio_major_no;

A whole major number for a single driver and a single minor?

Please no, just dynamically allocate it if you really need it.

And with the char node, you are creating new ioctls that duplicate the
gpio layer in the kernel, please don't do that.  Just hook into the
proper gpio subsystem and you will not need any character device at all.

thanks,

greg k-h
