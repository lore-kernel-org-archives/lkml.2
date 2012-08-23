Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab2HWSNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:13:24 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63396 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2HWSNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:13:21 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 23 Aug 2012 11:13:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon/lm70: adding support for NS LM74 chip
Message-ID: <20120823181317.GA5623@roeck-us.net>
References: <201208231532.q7NFWCQZ023407@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208231532.q7NFWCQZ023407@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 05:32:12PM +0200, Christophe Leroy wrote:
> Hello,
> 
Hi Christophe,

Just a nitpick, but as written the Hello is added to the commit log.

> This Patch adds support for the LM74 chip from National Semiconductor (NS) 
> in the lm70 driver
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> diff -u linux-3.5-vanilla/drivers/hwmon/Kconfig linux-3.5/drivers/hwmon/Kconfig
> --- linux-3.5-vanilla/drivers/hwmon/Kconfig	2012-07-21 22:58:29.000000000 +0200
> +++ linux-3.5/drivers/hwmon/Kconfig	2012-08-21 13:46:47.000000000 +0200
> @@ -530,11 +530,11 @@
>  	  will be called lm63.
>  
>  config SENSORS_LM70
> -	tristate "National Semiconductor LM70 / Texas Instruments TMP121"
> +	tristate "National Semiconductor LM70&LM74 / Texas Instruments TMP121"

Make it "LM70 and compatibles". There are other chips which should work as well,
such as LM71 and TMP122/TMP124.

>  	depends on SPI_MASTER
>  	help
>  	  If you say yes here you get support for the National Semiconductor
> -	  LM70 and Texas Instruments TMP121/TMP123 digital temperature
> +	  LM70 and LM74 and Texas Instruments TMP121/TMP123 digital temperature
>  	  sensor chips.
>  
>  	  This driver can also be built as a module.  If so, the module
> diff -u linux-3.5-vanilla/drivers/hwmon/lm70.c linux-3.5/drivers/hwmon/lm70.c
> --- linux-3.5-vanilla/drivers/hwmon/lm70.c	2012-07-21 22:58:29.000000000 +0200
> +++ linux-3.5/drivers/hwmon/lm70.c	2012-08-21 13:46:31.000000000 +0200
> @@ -3,11 +3,12 @@
>   *
>   * The LM70 is a temperature sensor chip from National Semiconductor (NS).
>   * Copyright (C) 2006 Kaiwan N Billimoria <kaiwan@designergraphix.com>
> + * Copyright (C) 2012 Christophe Leroy <christophe.leroy@c-s.fr>

Not for a couple of lines of code.

>   *
>   * The LM70 communicates with a host processor via an SPI/Microwire Bus
>   * interface. The complete datasheet is available at National's website
>   * here:
> - * http://www.national.com/pf/LM/LM70.html
> + * http://www.ti.com/product/LM70

Updating the data sheet link for LM70 would be a second patch. Only one change
per patch, please (even more so since the old link still works).

>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -43,6 +44,7 @@
>  
>  #define LM70_CHIP_LM70		0	/* original NS LM70 */
>  #define LM70_CHIP_TMP121	1	/* TI TMP121/TMP123 */
> +#define LM70_CHIP_LM74		2	/* original NS LM74 */
>  
Drop the "original" here. All chips are "original". The "original LM70"
statement above probably refers to the first chip supported by this driver.

>  struct lm70 {
>  	struct device *hwmon_dev;
> @@ -98,6 +100,7 @@
>  		break;
>  
>  	case LM70_CHIP_TMP121:
> +	case LM70_CHIP_LM74:
>  		val = ((int)raw / 8) * 625 / 10;
>  		break;
>  	}
> @@ -123,6 +126,9 @@
>  	case LM70_CHIP_TMP121:
>  		ret = sprintf(buf, "tmp121\n");
>  		break;
> +	case LM70_CHIP_LM74:
> +		ret = sprintf(buf, "lm74\n");
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> @@ -139,12 +145,13 @@
>  	struct lm70 *p_lm70;
>  	int status;
>  
> -	/* signaling is SPI_MODE_0 for both LM70 and TMP121 */
> +	/* signaling is SPI_MODE_0 for LM70, LM74 and TMP121 */
>  	if (spi->mode & (SPI_CPOL | SPI_CPHA))
>  		return -EINVAL;
>  
> -	/* 3-wire link (shared SI/SO) for LM70 */
> -	if (chip == LM70_CHIP_LM70 && !(spi->mode & SPI_3WIRE))
> +	/* 3-wire link (shared SI/SO) for LM70 and LM74 */
> +	if ((chip == LM70_CHIP_LM70 || chip == LM70_CHIP_LM74)
> +			&& !(spi->mode & SPI_3WIRE))

Ok for now, but I'll have to check this. The driver does not really write
anything to the chip, so it should be irrelevant which mode the SPI master
controller supports (MOSI does not have to be connected). Besides, from the
chip specification it looks like it is possible to connect the chip to a
standard SPI interface by adding a 10k resistor between MOSI and MISO.

>  		return -EINVAL;
>  
>  	/* NOTE:  we assume 8-bit words, and convert to 16 bits manually */
> @@ -202,6 +209,7 @@
>  static const struct spi_device_id lm70_ids[] = {
>  	{ "lm70",   LM70_CHIP_LM70 },
>  	{ "tmp121", LM70_CHIP_TMP121 },
> +	{ "lm74",   LM70_CHIP_LM74 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(spi, lm70_ids);
> @@ -219,5 +227,5 @@
>  module_spi_driver(lm70_driver);
>  
>  MODULE_AUTHOR("Kaiwan N Billimoria");
> -MODULE_DESCRIPTION("NS LM70 / TI TMP121/TMP123 Linux driver");
> +MODULE_DESCRIPTION("NS LM70 & LM74 / TI TMP121/TMP123 Linux driver");
>  MODULE_LICENSE("GPL");
> diff -u linux-3.5-vanilla/Documentation/hwmon/lm70 linux-3.5/Documentation/hwmon/lm70
> --- linux-3.5-vanilla/Documentation/hwmon/lm70	2012-07-21 22:58:29.000000000 +0200
> +++ linux-3.5/Documentation/hwmon/lm70	2012-08-21 13:38:24.000000000 +0200
> @@ -3,7 +3,9 @@
>  
>  Supported chips:
>    * National Semiconductor LM70
> -    Datasheet: http://www.national.com/pf/LM/LM70.html
> +    Datasheet: http://www.ti.com/product/LM70

Again, separate patch

> +  * National Semiconductor LM74
> +    Datasheet: http://www.ti.com/product/LM74
>    * Texas Instruments TMP121/TMP123
>      Information: http://focus.ti.com/docs/prod/folders/print/tmp121.html
>  
> @@ -31,9 +33,11 @@
>  with a "SPI master controller driver", see drivers/spi/spi_lm70llp.c
>  and its associated documentation.
>  
> -The TMP121/TMP123 are very similar; main differences are 4 wire SPI inter-
> -face (read only) and 13-bit temperature data (0.0625 degrees celsius reso-
> -lution).
> +The LM74 is very similar; main differences is 13-bit temperature data 

ERROR: trailing whitespace
#131: FILE: Documentation/hwmon/lm70:36:
+The LM74 is very similar; main differences is 13-bit temperature data $

> +(0.0625 degrees celsius resolution).
> +
> +The TMP121/TMP123 are very similar to the LM74; main difference is 4 wire
> +SPI interface (read only).
>  
>  Thanks to
>  ---------
> 
