Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0HROzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:55:05 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:22149 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab0HROy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:54:59 -0400
Message-ID: <4C6BF460.9090105@nokia.com>
Date: Wed, 18 Aug 2010 17:55:28 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        "Palande Ameya (Nokia-MS/Helsinki)" <ameya.palande@nokia.com>,
        "Lehtonen Markus (Nokia-MS/Helsinki)" <markus.lehtonen@nokia.com>
Subject: Re: [PATCH] power_supply: add isp1704 charger detection driver
References: <1282136465-1748-1-git-send-email-ext-heikki.krogerus@nokia.com>
In-Reply-To: <1282136465-1748-1-git-send-email-ext-heikki.krogerus@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/18/2010 04:01 PM, Krogerus Heikki (EXT-Teleca/Helsinki) wrote:
> From: Heikki Krogerus<ext-heikki.krogerus@nokia.com>
>
> NXP ISP1704 is Battery Charging Specification 1.0 compliant USB
> transceiver. This adds a power supply driver for ISP1704 and
> ISP1707 USB transceivers.
>
> Signed-off-by: Heikki Krogerus<ext-heikki.krogerus@nokia.com>
> ---
>   drivers/power/Kconfig           |    7 +
>   drivers/power/Makefile          |    1 +
>   drivers/power/isp1704_charger.c |  371 +++++++++++++++++++++++++++++++++++++++
>   3 files changed, 379 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/power/isp1704_charger.c
>
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 0734356..d55fc29 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -166,4 +166,11 @@ config BATTERY_INTEL_MID
>   	  Say Y here to enable the battery driver on Intel MID
>   	  platforms.
>
> +config CHARGER_ISP1704
> +	tristate "ISP1704 USB Charger Detection"
> +	select NOP_USB_XCEIV if ! MACH_NOKIA_RX51

As Anton mentioned, this is wrong.

It is possible for platforms other than RX51 to use ISP1704 and this driver 
should be usable on them without modifications to kconfig or driver code.

> +	help
> +	  Say Y to enable support for USB Charger Detection with
> +	  ISP1707/ISP1704 USB transceivers.
> +


>   endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 10143aa..c73d381 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -37,3 +37,4 @@ obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
>   obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
>   obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
>   obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
> +obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
> diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
> new file mode 100644
> index 0000000..821ad29
> --- /dev/null
> +++ b/drivers/power/isp1704_charger.c
> @@ -0,0 +1,371 @@
> +/*
> + * isp1704_charger.c - ISP1704 USB Charger Detection driver
> + *
> + * Copyright (C) 2010 Nokia Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +

<snip>


> +
> +static inline int isp1704_test_ulpi(struct isp1704_charger *isp)
> +{
> +	int			vendor, product, i;
> +	int			ret = -ENODEV;
> +
> +	/* Test ULPI interface */
> +	ret = otg_io_write(isp->otg, ULPI_SCRATCH, 0xaa);
> +	if (ret<  0)
> +		return ret;
> +	ret = otg_io_read(isp->otg, ULPI_SCRATCH);
> +	if (ret<  0)
> +		return ret;
> +	if (ret != 0xaa)
> +		return -ENODEV;
> +	/* Verify the product and vendor id matches */
> +	vendor = otg_io_read(isp->otg, ULPI_VENDOR_ID_LOW);
> +	vendor |= otg_io_read(isp->otg, ULPI_VENDOR_ID_HIGH)<<  8;
> +	if (vendor != NXP_VENDOR_ID)
> +		return -ENODEV;
> +	for (i = 0; i<  ARRAY_SIZE(isp170x_id); i++) {
> +		product = otg_io_read(isp->otg, ULPI_PRODUCT_ID_LOW);
> +		product |= otg_io_read(isp->otg, ULPI_PRODUCT_ID_HIGH)<<  8;

product id should be read outside the for loop. This way you will save 
unnecessary otg_io_reads. product id won't change anyways.

> +		if (product == isp170x_id[i]) {
> +			sprintf(isp->model, "isp%x", product);
> +			return product;
> +		}
> +	}
> +
> +	dev_err(isp->dev, "product id %x not matching known ids", product);
> +
> +	return -ENODEV;
> +}

<snip>

> +static struct platform_driver isp1704_charger_driver = {
> +	.driver = {
> +		.name = "isp1704_charger",
> +	},
> +	.probe = isp1704_charger_probe,
> +	.remove = __devexit_p(isp1704_charger_remove),
> +};
> +
> +static struct platform_device *isp1704_device;
> +
> +static int __init isp1704_charger_init(void)
> +{
> +	int ret = 0;
> +
> +	ret = platform_driver_register(&isp1704_charger_driver);
> +	if (ret)
> +		return ret;
> +
> +	isp1704_device = platform_device_register_simple("isp1704_charger",
> +							0, NULL, 0);

This platform_device_register should be done in the rx51 board file. i.e. 
board-rx51-peripherals.c

> +	if (IS_ERR(isp1704_device)) {
> +		platform_driver_unregister(&isp1704_charger_driver);
> +		ret = PTR_ERR(isp1704_device);
> +	}
> +
> +	return ret;
> +}
> +module_init(isp1704_charger_init);
> +
> +static void __exit isp1704_charger_exit(void)
> +{
> +	platform_device_unregister(isp1704_device);
don't do platform_device_unregister here.

> +	platform_driver_unregister(&isp1704_charger_driver);
> +}
> +module_exit(isp1704_charger_exit);
> +
> +MODULE_ALIAS("platform:isp1704-charger");
> +MODULE_AUTHOR("Nokia Corporation");
> +MODULE_DESCRIPTION("ISP170x USB Charger driver");
> +MODULE_LICENSE("GPL");


-- 
regards,
-roger
