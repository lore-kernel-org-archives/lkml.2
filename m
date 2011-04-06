Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1DFHYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:24:10 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:8275 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1DFHYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:24:09 -0400
Date: Wed, 6 Apr 2011 09:23:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: <achew@nvidia.com>
Cc: <guenter.roeck@ericsson.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <w30289@motorola.com>,
        <toddpoynor@google.com>, <wni@nvidia.com>, <olofj@chromium.org>
Subject: Re: [PATCH 1/1] [hwmon] nct1008: Initial NCT1008 driver
Message-ID: <20110406092358.07e8ca78@endymion.delvare>
In-Reply-To: <1302059183-29631-1-git-send-email-achew@nvidia.com>
References: <1302059183-29631-1-git-send-email-achew@nvidia.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, 5 Apr 2011 20:06:23 -0700, achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> This is a digital temperature sensor I2C peripheral from ON Semiconductor.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/hwmon/Kconfig   |   11 ++
>  drivers/hwmon/Makefile  |    1 +
>  drivers/hwmon/nct1008.c |  423 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 435 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/nct1008.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 060ef63..daa6159 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -738,6 +738,17 @@ config SENSORS_MAX6650
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called max6650.
>  
> +config SENSORS_NCT1008
> +	tristate "ON Semiconductor Temperature Sensor"
> +	default n

Default n is the default, so there's no point mentioning it.

> +	depends on I2C
> +	help
> +	  Say yes here if you wish to include the ON Semiconductor
> +	  NCT1008 Temperature sensor.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called nct1008.
> +
>  config SENSORS_PC87360
>  	tristate "National Semiconductor PC87360 family"
>  	select HWMON_VID
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 967d0ea..803893c 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -87,6 +87,7 @@ obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
>  obj-$(CONFIG_SENSORS_MAX6639)	+= max6639.o
>  obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
>  obj-$(CONFIG_SENSORS_MC13783_ADC)+= mc13783-adc.o
> +obj-$(CONFIG_SENSORS_NCT1008)	+= nct1008.o
>  obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
>  obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
>  obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
> diff --git a/drivers/hwmon/nct1008.c b/drivers/hwmon/nct1008.c
> new file mode 100644
> index 0000000..ebae3b6
> --- /dev/null
> +++ b/drivers/hwmon/nct1008.c
> @@ -0,0 +1,423 @@
> +/*
> + * Driver for NCT1008, temperature monitoring device from ON Semiconductors
> + *
> + * Copyright (c) 2010, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +
> +#include <linux/interrupt.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/gpio.h>
> +
> +#include <linux/nct1008.h>
> +#include <linux/hwmon.h>
> +
> +#define DRIVER_NAME "nct1008"
> +
> +/* Register Addresses */
> +#define LOCAL_TEMP_RD			0x00
> +#define EXT_HI_TEMP_RD			0x01
> +#define EXT_LO_TEMP_RD			0x10
> +#define STATUS_RD			0x02
> +#define CONFIG_RD			0x03
> +
> +#define CONFIG_WR			0x09
> +#define CONV_RATE_WR			0x0A
> +#define LOCAL_TEMP_HI_LIMIT_WR		0x0B
> +#define EXT_TEMP_HI_LIMIT_HI_BYTE	0x0D
> +#define OFFSET_WR			0x11
> +#define EXT_THERM_LIMIT_WR		0x19
> +#define LOCAL_THERM_LIMIT_WR		0x20
> +#define THERM_HYSTERESIS_WR		0x21

These register definitions look very familiar to me. Have you looked at
the lm90 driver to check has difficult it would be to add support for
the NCT1008? I bet it will only take a few lines of code.

-- 
Jean Delvare
