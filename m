Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab2H3UKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 16:10:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53185 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2H3UKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 16:10:11 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 Aug 2012 13:10:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: add Maxim MAX197 support
Message-ID: <20120830201019.GA3875@roeck-us.net>
References: <1346351995-9038-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346351995-9038-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:39:55PM -0400, Vivien Didelot wrote:
> The MAX197 is an A/D converter, made by Maxim. This driver currently
> supports the MAX197, and MAX199. They are both 8-Channel, Multi-Range,
> 5V, 12-Bit DAS with 8+4 Bus Interface and Fault Protection.
> 
> The available ranges for the MAX197 are {0,-5V} to 5V, and {0,-10V} to
> 10V, while they are {0,-2V} to 2V, and {0,-4V} to 4V on the MAX199.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Hi Vivien,

[ ... ]

>  
> +config SENSORS_MAX197
> +	tristate "Maxim MAX197 and compatibles"
> +	help
> +	  Support for the Maxim MAX197 A/D converter.
> +	  Support will include, but not be limited to, MAX197, and MAX199.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called max197.
> +

Please move this a bit further down to retain alphabetical order.

>  config SENSORS_MAX1111
>  	tristate "Maxim MAX1111 Multichannel, Serial 8-bit ADC chip"
>  	depends on SPI_MASTER
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 7aa9811..b9e202a 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -90,6 +90,7 @@ obj-$(CONFIG_SENSORS_LTC4151)	+= ltc4151.o
>  obj-$(CONFIG_SENSORS_LTC4215)	+= ltc4215.o
>  obj-$(CONFIG_SENSORS_LTC4245)	+= ltc4245.o
>  obj-$(CONFIG_SENSORS_LTC4261)	+= ltc4261.o
> +obj-$(CONFIG_SENSORS_MAX197)	+= max197.o

Same here.

>  obj-$(CONFIG_SENSORS_MAX1111)	+= max1111.o
>  obj-$(CONFIG_SENSORS_MAX16065)	+= max16065.o
>  obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
> diff --git a/drivers/hwmon/max197.c b/drivers/hwmon/max197.c
> new file mode 100644
> index 0000000..6cc045a
> --- /dev/null
> +++ b/drivers/hwmon/max197.c
> @@ -0,0 +1,378 @@
> +/*
> + * Maxim MAX197 A/D Converter driver
> + *
> + * Copyright (c) 2012 Savoir-faire Linux Inc.
> + *          Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * For further information, see the Documentation/hwmon/max197 file.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/device.h>
> +#include <linux/sysfs.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_data/max197.h>
> +
> +#define MAX199_LIMIT	4000	/* 4V */
> +#define MAX197_LIMIT	10000	/* 10V */
> +
> +#define MAX197_NUM_CH	8	/* 8 Analog Input Channels */
> +
> +/* Control byte format */
> +#define MAX197_A0	0x01	/* Channel bit 0 */
> +#define MAX197_A1	0x02	/* Channel bit 1 */
> +#define MAX197_A2	0x04	/* Channel bit 2 */
> +#define MAX197_BIP	0x08	/* Bipolarity */
> +#define MAX197_RNG	0x10	/* Full range */
> +#define MAX197_ACQMOD	0x20	/* Internal/External controlled acquisition */
> +#define MAX197_PD0	0x40	/* Clock/Power-Down modes bit 1 */
> +#define MAX197_PD1	0x80	/* Clock/Power-Down modes bit 2 */
> +

Most of the above defines are not used. Please remove the unused ones.
For the ones you do use, please use (1 << x) to show that it is a bit.

[ ... ]
> +
> +static int __devinit max197_probe(struct platform_device *pdev)
> +{
> +	struct max197_chip *chip;
> +	struct max197_platform_data *pdata;
> +	int ch, ret;
> +
> +	if (pdev->dev.platform_data == NULL) {
> +		dev_err(&pdev->dev, "no platform data supplied\n");
> +		return -EINVAL;
> +	}
> +	pdata = pdev->dev.platform_data;
> +
> +	if (pdata->convert == NULL) {
> +		dev_err(&pdev->dev, "no convert function supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	chip = devm_kzalloc(&pdev->dev, sizeof(struct max197_chip), GFP_KERNEL);
> +	if (!chip) {
> +		dev_err(&pdev->dev, "devm_kzalloc failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	chip->pdata = pdata;
> +	mutex_init(&chip->lock);
> +
> +	if (strcmp("max197", pdev->name) == 0) {
> +		chip->limit = MAX197_LIMIT;
> +		chip->scale = true;
> +	} else {
> +		chip->limit = MAX199_LIMIT;
> +		chip->scale = false;
> +	}
> +
> +	for (ch = 0; ch < MAX197_NUM_CH; ch++)
> +		chip->ctrl_bytes[ch] = (u8) ch;
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &max197_sysfs_group);
> +	if (ret) {
> +		dev_err(&pdev->dev, "sysfs create group failed\n");
> +		return ret;
> +	}
> +
> +	chip->hwmon_dev = hwmon_device_register(&pdev->dev);
> +	if (IS_ERR(chip->hwmon_dev)) {
> +		ret = PTR_ERR(chip->hwmon_dev);
> +		dev_err(&pdev->dev, "hwmon device register failed\n");
> +		sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
> +		return ret;

Please follow CodingStyle, chapter 7. Specifically, create a single error exit
point and use goto to jump to it.

		goto error;

error:
	sysfs_remove_group(...);
	return ret;
}

> +	}
> +
> +	platform_set_drvdata(pdev, chip);
> +
This causes a race condition; the access functions reference it, and can be
called after the sysfs files are created. You'll have to move it further up,
before the call to sysfs_create_group().

> +	return 0;
> +}
> +
> +static int __devexit max197_remove(struct platform_device *pdev)
> +{
> +	struct max197_chip *chip = platform_get_drvdata(pdev);
> +
> +	hwmon_device_unregister(chip->hwmon_dev);
> +	sysfs_remove_group(&pdev->dev.kobj, &max197_sysfs_group);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver __refdata maxim_drivers[] = {
> +	{
> +		.driver = {
> +			.name = "max197",
> +			.owner = THIS_MODULE,
> +		},
> +		.probe = max197_probe,
> +		.remove = __devexit_p(max197_remove),
> +	}, {
> +		.driver = {
> +			.name = "max199",
> +			.owner = THIS_MODULE,
> +		},
> +		.probe = max197_probe,
> +		.remove = __devexit_p(max197_remove),
> +	}
> +};
> +
> +static int __init max197_init(void)
> +{
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(maxim_drivers); i++) {
> +		ret = platform_driver_register(&maxim_drivers[i]);
> +		if (ret)
> +			goto error_unregister;
> +	}

I keep thinking about this; there must be a better way where we only need one
platform driver instance. After all, there is just one driver, only there can
be multiple devices. No idea how to do that right now, though. If I find out,
I'll let you know.

Anyway, you'll need to add:

MODULE_ALIAS("platform:max197");
MODULE_ALIAS("platform:max199");

Guenter
