Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2JPHL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:11:57 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:38614 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab2JPHLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:11:55 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.73
From: Lars Poeschel <poeschel@lemonage.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH v2 4/4] iio: adc: add viperboard adc driver
Date: Tue, 16 Oct 2012 09:11:43 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        linus.walleij@linaro.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
References: <20120925085559.GL28670@sortiz-mobl> <1350052469-27802-4-git-send-email-larsi@wh2.tu-dresden.de> <507C1D1C.2030607@metafoo.de>
In-Reply-To: <507C1D1C.2030607@metafoo.de>
MIME-Version: 1.0
Message-Id: <201210160911.44070.poeschel@lemonage.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012 at 16:26:36, Lars-Peter Clausen wrote:
> Added linux-iio@vger.kernel.org to Cc.
> 
> On 10/12/2012 04:34 PM, Lars Poeschel wrote:
> > From: Lars Poeschel <poeschel@lemonage.de>
> > 
> > This adds the mfd cell to use the adc part of the Nano River Technologies
> > viperboard.
> > 
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> 
> Looks good in general, just some minor code style issues.
> 
> > ---
> > 
> >  drivers/iio/adc/Kconfig          |    7 ++
> >  drivers/iio/adc/Makefile         |    1 +
> >  drivers/iio/adc/viperboard_adc.c |  185
> >  ++++++++++++++++++++++++++++++++++++++ drivers/mfd/viperboard.c        
> >  |    3 +
> >  4 files changed, 196 insertions(+)
> >  create mode 100644 drivers/iio/adc/viperboard_adc.c
> 
> [...]
> 
> > diff --git a/drivers/iio/adc/viperboard_adc.c
> > b/drivers/iio/adc/viperboard_adc.c new file mode 100644
> > index 0000000..8ae6634
> > --- /dev/null
> > +++ b/drivers/iio/adc/viperboard_adc.c
> > @@ -0,0 +1,185 @@
> > +/*
> > + *  Nano River Technologies viperboard iio ADC driver
> > + *
> > + *  (C) 2012 by Lemonage GmbH
> > + *  Author: Lars Poeschel <poeschel@lemonage.de>
> > + *  All rights reserved.
> > + *
> > + *  This program is free software; you can redistribute  it and/or
> > modify it + *  under  the terms of  the GNU General  Public License as
> > published by the + *  Free Software Foundation;  either version 2 of
> > the	License, or (at your + *  option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/mutex.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <linux/usb.h>
> > +#include <linux/iio/iio.h>
> > +
> > +#include <linux/mfd/viperboard.h>
> > +
> > +#define VPRBRD_ADC_CMD_GET		0x00
> > +
> > +struct __packed vprbrd_adc_msg {
> > +	u8 cmd;
> > +	u8 chan;
> > +	u8 val;
> > +};
> 
> put the __packed between } and ;

GCC allows both alternatives, but you are right: Most kernel code is doing it 
between } and ; so I will change this.

> > +
> > +struct vprbrd_adc {
> > +	struct vprbrd *vb;
> > +};
> > +
> > +#define VPRBRD_ADC_CHANNEL(_index) {			\
> > +	.type = IIO_VOLTAGE,				\
> > +	.indexed = 1,					\
> > +	.channel = _index,				\
> > +	.info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT,	\
> 
> It would be good if you could also report the channel scale.

I saw that there is the possibility to supply a channel scale, which is way 
cool. :-) The doc of the viperboard says nothing about the scale of the ADC. 
At the moment I do not have the right measuring equipment here to measure a 
scale myself. I would do another tiny patch if I have the oppotunity to 
measure somewhere.

> > +	.scan_index = _index,				\
> > +	.scan_type.sign = 'u',				\
> > +	.scan_type.realbits = 8,			\
> > +	.scan_type.storagebits = 8,			\
> 
> Usually this is written as
> 	.scan_type = {
> 		.sign = 'u',
> 		....
> 	},
> 
> > +}
> > +
> > +static struct iio_chan_spec vprbrd_adc_iio_channels[] = {
> 
> const
> 
> > +	VPRBRD_ADC_CHANNEL(0),
> > +	VPRBRD_ADC_CHANNEL(1),
> > +	VPRBRD_ADC_CHANNEL(2),
> > +	VPRBRD_ADC_CHANNEL(3),
> > +};
> > +
> > +static int vprbrd_iio_read_raw(struct iio_dev *iio_dev,
> > +				struct iio_chan_spec const *chan,
> > +				int *val,
> > +				int *val2,
> > +				long mask)
> 
> 'mask' used to be a mask and that's why it is still called 'mask' in older
> drivers. For new drivers we should use 'info'.
> 
> > +{
> > +	int ret, error = 0;
> > +	struct vprbrd_adc *adc = iio_priv(iio_dev);
> > +	struct vprbrd *vb = adc->vb;
> > +	struct vprbrd_adc_msg *admsg = (struct vprbrd_adc_msg *)vb->buf;
> > +
> > +	if (mask == IIO_CHAN_INFO_RAW) {
> > +
> 
> Use switch instead of if. Otherwise you'd end up with if(mask == ...) else
> if(mask == ...) else if (mask == ...) if you add support for more channel
> attributes.
> 
> > +		mutex_lock(&vb->lock);
> > +
> > +		admsg->cmd = VPRBRD_ADC_CMD_GET;
> > +		admsg->chan = chan->scan_index;
> > +		admsg->val = 0x00;
> > +
> > +		ret = usb_control_msg(vb->usb_dev,
> > +			usb_sndctrlpipe(vb->usb_dev, 0), 0xec, 0x40,
> > +			0x0000, 0x0000, admsg,
> > +			sizeof(struct vprbrd_adc_msg), 100);
> > +		if (ret != sizeof(struct vprbrd_adc_msg)) {
> > +			dev_err(&iio_dev->dev, "usb send error on adc read\n");
> > +			error = -EREMOTEIO;
> > +		}
> 
> Does it make sense to send out the second msg if the first one failed?

This is a good question. I can not fully answer it, because I did not build 
the hardware. I thought it is better to try send the second message, because 
there is some chance it reaches the device. I would opt for trying it.

> > +
> > +		ret = usb_control_msg(vb->usb_dev,
> > +			usb_rcvctrlpipe(vb->usb_dev, 0), 0xec, 0xc0,
> > +			0x0000, 0x0000, admsg,
> > +			sizeof(struct vprbrd_adc_msg), 100);
> > +
> 
> It would be good to have some defines for the magic constants used for
> request and request_type.
> 
> > +		*val = admsg->val;
> > +
> > +		mutex_unlock(&vb->lock);
> > +
> > +		if (ret != sizeof(struct vprbrd_adc_msg)) {
> > +			dev_err(&iio_dev->dev, "usb recv error on adc read\n");
> > +			error = -EREMOTEIO;
> > +		}
> > +
> > +		if (error)
> > +			goto error;
> > +
> > +		return IIO_VAL_INT;
> > +	}
> > +	error =  -EINVAL;
> > +error:
> > +	return error;
> > +}
> > +
> > +static const struct iio_info vprbrd_adc_iio_info = {
> > +	.read_raw = &vprbrd_iio_read_raw,
> > +	.driver_module = THIS_MODULE,
> > +};
> > +
> > +static int __devinit vprbrd_adc_probe(struct platform_device *pdev)
> > +{
> > +	struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
> > +	struct vprbrd_adc *adc;
> > +	struct iio_dev *iodev;
> 
> Usually this is called indio_dev, would be good for consistency if you'd do
> this as well.
> 
> > +	int ret;
> > +
> > +	/* registering iio */
> > +	iodev = iio_device_alloc(sizeof(struct vprbrd_adc));
> > +	if (!iodev) {
> > +		dev_err(&pdev->dev, "failed allocating iio device\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	adc = iio_priv(iodev);
> > +	adc->vb = vb;
> > +	iodev->name = "viperboard adc";
> > +	iodev->dev.parent = &pdev->dev;
> > +	iodev->info = &vprbrd_adc_iio_info;
> > +	iodev->modes = INDIO_DIRECT_MODE;
> > +	iodev->channels = vprbrd_adc_iio_channels;
> > +	iodev->num_channels = ARRAY_SIZE(vprbrd_adc_iio_channels);
> > +
> > +	ret = iio_device_register(iodev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "could not register iio (adc)");
> > +		goto error;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, iodev);
> > +
> > +	return 0;
> > +
> > +error:
> > +	iio_device_free(iodev);
> > +	return ret;
> > +}
> > +
> > +static int __devexit vprbrd_adc_remove(struct platform_device *pdev)
> > +{
> > +	struct iio_dev *iodev = platform_get_drvdata(pdev);
> > +
> > +	iio_device_unregister(iodev);
> > +	iio_device_free(iodev);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver vprbrd_adc_driver = {
> > +	.driver.name	= "viperboard-adc",
> > +	.driver.owner	= THIS_MODULE,
> 
> Same as with scan_type, usually this is written as
> 
> .driver = {
> 	.name = ...
> 	....
> },
> 
> > +	.probe		= vprbrd_adc_probe,
> > +	.remove		= __devexit_p(vprbrd_adc_remove),
> > +};
> > +
> > +static int __init vprbrd_adc_init(void)
> > +{
> > +	return platform_driver_register(&vprbrd_adc_driver);
> > +}
> > +subsys_initcall(vprbrd_adc_init);
> > +
> > +static void __exit vprbrd_adc_exit(void)
> > +{
> > +	platform_driver_unregister(&vprbrd_adc_driver);
> > +}
> > +module_exit(vprbrd_adc_exit);
> 
> module_platform_driver(vprbrd_adc_driver);
> 
> > +
> > +MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
> > +MODULE_DESCRIPTION("IIO ADC driver for Nano River Techs Viperboard");
> > +MODULE_LICENSE("GPL");
> > +MODULE_ALIAS("platform:viperboard-adc");
> > diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> > index a25e07e..eb1cf89 100644
> > --- a/drivers/mfd/viperboard.c
> > +++ b/drivers/mfd/viperboard.c
> > @@ -55,6 +55,9 @@ static struct mfd_cell vprbrd_devs[] = {
> > 
> >  	{
> >  	
> >  		.name = "viperboard-i2c",
> >  	
> >  	},
> > 
> > +	{
> > +		.name = "viperboard-adc",
> > +	},
> > 
> >  };
> >  
> >  static int vprbrd_probe(struct usb_interface *interface,

Thank you for your review. The other things you mention are clear. I will 
change them. I will wait some time for some feedback from the other 
maintainers and then do a version 3 of the whole patchset.

Regards,
Lars

