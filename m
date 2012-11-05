Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2KEUwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:52:44 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59176 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab2KEUwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:52:42 -0500
Message-ID: <50982716.6010805@kernel.org>
Date: Mon, 05 Nov 2012 20:52:38 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
CC: linus.walleij@linaro.org, poeschel@lemonage.de, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH v3 5/5] iio: adc: add viperboard adc driver
References: <1352126906-4560-1-git-send-email-larsi@wh2.tu-dresden.de> <1352126906-4560-5-git-send-email-larsi@wh2.tu-dresden.de>
In-Reply-To: <1352126906-4560-5-git-send-email-larsi@wh2.tu-dresden.de>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 02:48 PM, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This adds the mfd cell to use the adc part of the Nano River Technologies
> viperboard.
> 
One utter nitpick inline (nice to clean up but totally trivial)

> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>

As there is a clear dependence on the mfd elements here this should
probably go though Samuel's tree once people are happy with the other elements.
> ---
>  drivers/iio/adc/Kconfig          |    7 ++
>  drivers/iio/adc/Makefile         |    1 +
>  drivers/iio/adc/viperboard_adc.c |  181 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/viperboard.c         |    3 +
>  include/linux/mfd/viperboard.h   |    1 +
>  5 files changed, 193 insertions(+)
>  create mode 100644 drivers/iio/adc/viperboard_adc.c
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 4927581..35ad77d 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -60,4 +60,11 @@ config LP8788_ADC
>  	help
>  	  Say yes here to build support for TI LP8788 ADC.
>  
> +config VIPERBOARD_ADC
> +	tristate "Viperboard ADC support"
> +	depends on MFD_VIPERBOARD && USB
> +	help
> +	  Say yes here to access the ADC part of the Nano River
> +	  Technologies Viperboard.
> +
>  endmenu
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index 900995d..4852c2e 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_AD7476) += ad7476.o
>  obj-$(CONFIG_AD7791) += ad7791.o
>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
> +obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
> diff --git a/drivers/iio/adc/viperboard_adc.c b/drivers/iio/adc/viperboard_adc.c
> new file mode 100644
> index 0000000..58345c7
> --- /dev/null
> +++ b/drivers/iio/adc/viperboard_adc.c
> @@ -0,0 +1,181 @@
> +/*
> + *  Nano River Technologies viperboard iio ADC driver
IIO (told you it was a nitpick).
> + *
> + *  (C) 2012 by Lemonage GmbH
> + *  Author: Lars Poeschel <poeschel@lemonage.de>
> + *  All rights reserved.
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the	License, or (at your
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
> +#include <linux/platform_device.h>
> +
> +#include <linux/usb.h>
> +#include <linux/iio/iio.h>
> +
> +#include <linux/mfd/viperboard.h>
> +
> +#define VPRBRD_ADC_CMD_GET		0x00
> +
> +struct vprbrd_adc_msg {
> +	u8 cmd;
> +	u8 chan;
> +	u8 val;
> +} __packed;
> +
> +struct vprbrd_adc {
> +	struct vprbrd *vb;
> +};
> +
> +#define VPRBRD_ADC_CHANNEL(_index) {			\
> +	.type = IIO_VOLTAGE,				\
> +	.indexed = 1,					\
> +	.channel = _index,				\
> +	.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
> +	.scan_index = _index,				\
> +	.scan_type = {					\
> +		.sign = 'u',				\
> +		.realbits = 8,				\
> +		.storagebits = 8,			\
> +	},						\
> +}
> +
> +static struct iio_chan_spec const vprbrd_adc_iio_channels[] = {
> +	VPRBRD_ADC_CHANNEL(0),
> +	VPRBRD_ADC_CHANNEL(1),
> +	VPRBRD_ADC_CHANNEL(2),
> +	VPRBRD_ADC_CHANNEL(3),
> +};
> +
> +static int vprbrd_iio_read_raw(struct iio_dev *iio_dev,
> +				struct iio_chan_spec const *chan,
> +				int *val,
> +				int *val2,
> +				long info)
> +{
> +	int ret, error = 0;
> +	struct vprbrd_adc *adc = iio_priv(iio_dev);
> +	struct vprbrd *vb = adc->vb;
> +	struct vprbrd_adc_msg *admsg = (struct vprbrd_adc_msg *)vb->buf;
> +
> +	switch (info) {
> +	case IIO_CHAN_INFO_RAW:
> +		mutex_lock(&vb->lock);
> +
> +		admsg->cmd = VPRBRD_ADC_CMD_GET;
> +		admsg->chan = chan->scan_index;
> +		admsg->val = 0x00;
> +
> +		ret = usb_control_msg(vb->usb_dev,
> +			usb_sndctrlpipe(vb->usb_dev, 0), VPRBRD_USB_REQUEST_ADC,
> +			VPRBRD_USB_TYPE_OUT, 0x0000, 0x0000, admsg,
> +			sizeof(struct vprbrd_adc_msg), VPRBRD_USB_TIMEOUT_MS);
> +		if (ret != sizeof(struct vprbrd_adc_msg)) {
> +			dev_err(&iio_dev->dev, "usb send error on adc read\n");
> +			error = -EREMOTEIO;
> +		}
> +
> +		ret = usb_control_msg(vb->usb_dev,
> +			usb_rcvctrlpipe(vb->usb_dev, 0), VPRBRD_USB_REQUEST_ADC,
> +			VPRBRD_USB_TYPE_IN, 0x0000, 0x0000, admsg,
> +			sizeof(struct vprbrd_adc_msg), VPRBRD_USB_TIMEOUT_MS);
> +
> +		*val = admsg->val;
> +
> +		mutex_unlock(&vb->lock);
> +
> +		if (ret != sizeof(struct vprbrd_adc_msg)) {
> +			dev_err(&iio_dev->dev, "usb recv error on adc read\n");
> +			error = -EREMOTEIO;
> +		}
> +
> +		if (error)
> +			goto error;
> +
> +		return IIO_VAL_INT;
> +	default:
> +		error = -EINVAL;
> +		break;
> +	}
> +error:
> +	return error;
> +}
> +
> +static const struct iio_info vprbrd_adc_iio_info = {
> +	.read_raw = &vprbrd_iio_read_raw,
> +	.driver_module = THIS_MODULE,
> +};
> +
> +static int __devinit vprbrd_adc_probe(struct platform_device *pdev)
> +{
> +	struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
> +	struct vprbrd_adc *adc;
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	/* registering iio */
> +	indio_dev = iio_device_alloc(sizeof(struct vprbrd_adc));
> +	if (!indio_dev) {
> +		dev_err(&pdev->dev, "failed allocating iio device\n");
> +		return -ENOMEM;
> +	}
> +
> +	adc = iio_priv(indio_dev);
> +	adc->vb = vb;
> +	indio_dev->name = "viperboard adc";
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->info = &vprbrd_adc_iio_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = vprbrd_adc_iio_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(vprbrd_adc_iio_channels);
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "could not register iio (adc)");
> +		goto error;
> +	}
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +
> +	return 0;
> +
> +error:
> +	iio_device_free(indio_dev);
> +	return ret;
> +}
> +
> +static int __devexit vprbrd_adc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	iio_device_unregister(indio_dev);
> +	iio_device_free(indio_dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver vprbrd_adc_driver = {
> +	.driver = {
> +		.name	= "viperboard-adc",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= vprbrd_adc_probe,
> +	.remove		= __devexit_p(vprbrd_adc_remove),
> +};
> +
> +module_platform_driver(vprbrd_adc_driver);
> +
> +MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
> +MODULE_DESCRIPTION("IIO ADC driver for Nano River Techs Viperboard");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:viperboard-adc");
> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> index a7b5b34..dacb3b7 100644
> --- a/drivers/mfd/viperboard.c
> +++ b/drivers/mfd/viperboard.c
> @@ -44,6 +44,9 @@ static struct mfd_cell vprbrd_devs[] = {
>  	{
>  		.name = "viperboard-i2c",
>  	},
> +	{
> +		.name = "viperboard-adc",
> +	},
>  };
>  
>  static int vprbrd_probe(struct usb_interface *interface,
> diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
> index ef78514..1934528 100644
> --- a/include/linux/mfd/viperboard.h
> +++ b/include/linux/mfd/viperboard.h
> @@ -46,6 +46,7 @@
>  #define VPRBRD_USB_REQUEST_I2C      0xe9
>  #define VPRBRD_USB_REQUEST_MAJOR    0xea
>  #define VPRBRD_USB_REQUEST_MINOR    0xeb
> +#define VPRBRD_USB_REQUEST_ADC      0xec
>  #define VPRBRD_USB_REQUEST_GPIOA    0xed
>  #define VPRBRD_USB_REQUEST_GPIOB    0xdd
>  
> 
