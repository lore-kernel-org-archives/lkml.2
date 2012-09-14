Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2INGMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:12:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56186 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab2INGMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:12:12 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: RE: [PATCH v3 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
Thread-Topic: [PATCH v3 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
Thread-Index: AQHNkZ7gO7g99euPFUGlO1rlKzOd1peH3X+AgAFor4A=
Date: Fri, 14 Sep 2012 06:11:50 +0000
Message-ID: <4CE347531D4CA947960AF71FF095B9323E953D41@DBDE01.ent.ti.com>
References: <1347532819-505-1-git-send-email-rachna@ti.com>
 <1347532819-505-5-git-send-email-rachna@ti.com> <5051D6C7.2010700@metafoo.de>
In-Reply-To: <5051D6C7.2010700@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 18:21:19, Lars-Peter Clausen wrote:
> On 09/13/2012 12:40 PM, Patil, Rachna wrote:
> > This patch adds support for TI's ADC driver.
> > This is a multifunctional device.
> > Analog input lines are provided on which voltage measurements can be 
> > carried out.
> > You can have upto 8 input lines.
> > 
> 
> Hi,
> 
> couple of minor issues inline.

Hi,

Please find my comments inline.

> 
> > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > ---
> > Changes in v2:
> > 	Addressed review comments from Matthias Kaehlcke
> > 
> > Changes in v3:
> > 	Addressed review comments from Jonathan Cameron.
> > 	Added comments, new line appropriately.
> > 
> >  drivers/iio/adc/Kconfig              |    7 +
> >  drivers/iio/adc/Makefile             |    1 +
> >  drivers/iio/adc/ti_adc.c             |  223 ++++++++++++++++++++++++++++++++++
> >  drivers/mfd/ti_tscadc.c              |   18 +++-
> >  include/linux/mfd/ti_tscadc.h        |    9 ++-
> >  include/linux/platform_data/ti_adc.h |   14 ++
> >  6 files changed, 270 insertions(+), 2 deletions(-)  create mode 
> > 100644 drivers/iio/adc/ti_adc.c  create mode 100644 
> > include/linux/platform_data/ti_adc.h
> > 
> [...]
> > +
> > +struct adc_device {
> 
> Not really an issue, but I'd use a consistent function/struct prefix.
> Currently you use both "adc" and "tiadc"

Ok. I will update this.

> 
> > +	struct ti_tscadc_dev *mfd_tscadc;
> > +	struct iio_dev *idev;
> 
> idev is used only once in the remove callback. But you can get a pointer to it easily using platform_get_drvdata. So I'd remove it from the adc_device struct.

Ok. I will remove this.

> 
> > +	int channels;
> > +};
> > +
> > +static unsigned int adc_readl(struct adc_device *adc, unsigned int 
> > +reg) {
> > +	return readl(adc->mfd_tscadc->tscadc_base + reg); }
> > +
> > +static void adc_writel(struct adc_device *adc, unsigned int reg,
> > +					unsigned int val)
> > +{
> > +	writel(val, adc->mfd_tscadc->tscadc_base + reg); }
> > +
> > +static void adc_step_config(struct adc_device *adc_dev) {
> > +	unsigned int    stepconfig;
> 
> extra whitespace

Ok. I will remove this.

> 
> > +	int i, channels = 0, steps;
> > +
> > +	/*
> > +	 * There are 16 configurable steps and 8 analog input
> > +	 * lines available which are shared between Touchscreen and ADC.
> > +	 *
> > +	 * Steps backwards i.e. from 16 towards 0 are used by ADC
> > +	 * depending on number of input lines needed.
> > +	 * Channel would represent which analog input
> > +	 * needs to be given to ADC to digitalize data.
> > +	 */
> > +
> > +	steps = TOTAL_STEPS - adc_dev->channels;
> > +	channels = TOTAL_CHANNELS - adc_dev->channels;
> > +
> > +	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
> > +
> > +	for (i = (steps + 1); i <= TOTAL_STEPS; i++) {
> > +		adc_writel(adc_dev, REG_STEPCONFIG(i),
> > +				stepconfig | STEPCONFIG_INP(channels));
> > +		adc_writel(adc_dev, REG_STEPDELAY(i),
> > +				STEPCONFIG_OPENDLY);
> > +		channels++;
> > +	}
> > +	adc_writel(adc_dev, REG_SE, STPENB_STEPENB); }
> > +
> > [...]
> > +
> > +static const struct iio_info tiadc_info = {
> > +	.read_raw = &tiadc_read_raw,
> 
>     .driver_module = THIS_MODULE,
> 
> > +};
> > +
> > +static int __devinit tiadc_probe(struct platform_device *pdev) {
> > +	struct iio_dev		*idev;
> 
> For consistency with other drivers please rename idev to indio_dev throughout the driver.

Ok. I will rename this.

> 
> > +	int			err;
> > +	struct adc_device	*adc_dev;
> > +	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
> > +	struct mfd_tscadc_board	*pdata;
> > +
> > +	pdata = (struct mfd_tscadc_board *)tscadc_dev->dev->platform_data;
> 
> The cast should not be necessary.

True,
I will correct this.

> 
> > +	if (!pdata || !pdata->adc_init) {
> > +		dev_err(tscadc_dev->dev, "Could not find platform data\n");
> 
> I'd still use pdev->dev for the device parameter here. Seeing a message printed by this driver for another device might be confusing.

Yes, I will correct this.

> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	idev = iio_device_alloc(sizeof(struct adc_device));
> > +	if (idev == NULL) {
> > +		dev_err(&pdev->dev, "failed to allocate iio device.\n");
> > +		err = -ENOMEM;
> > +		goto err_ret;
> > +	}
> > +	adc_dev = iio_priv(idev);
> > +
> > +	tscadc_dev->adc = adc_dev;
> 
> This there any reason why you need to store a pointer to the adc struct in the mfd struct? Is it going to be used outside of the adc driver? Currently it is, as far as I can see, only used in the remove callback and suspend/resume handlers. But there you can use iio_priv just as easily to get the pointer to the adc device struct and it certainly will be also be cleaner to do it that way.

Yes, currently it is used only in suspend/resume.
I will drop this line.

> 
> > +	adc_dev->mfd_tscadc = tscadc_dev;
> > +	adc_dev->idev = idev;
> > +	adc_dev->channels = pdata->adc_init->adc_channels;
> > +
> > +	idev->dev.parent = &pdev->dev;
> > +	idev->name = dev_name(&pdev->dev);
> > +	idev->modes = INDIO_DIRECT_MODE;
> > +	idev->info = &tiadc_info;
> > +
> > +	adc_step_config(adc_dev);
> > +
> > +	err = tiadc_channel_init(idev, adc_dev->channels);
> > +	if (err < 0)
> > +		goto err_free_device;
> > +
> > +	err = iio_device_register(idev);
> > +	if (err)
> > +		goto err_free_channels;
> > +
> > +	dev_info(&pdev->dev, "attached adc driver\n");
> 
> I'd remove that line, it's just noise.

Ok. I will drop this.

> 
> > +	platform_set_drvdata(pdev, idev);
> > +
> > +	return 0;
> > +
> > +err_free_channels:
> > +	tiadc_channels_remove(idev);
> > +err_free_device:
> > +	iio_device_free(idev);
> > +err_ret:
> > +	return err;
> > +}
> > +
> 
> [...]
> > diff --git a/include/linux/platform_data/ti_adc.h 
> > b/include/linux/platform_data/ti_adc.h
> > new file mode 100644
> > index 0000000..5a89f1d
> > --- /dev/null
> > +++ b/include/linux/platform_data/ti_adc.h
> > @@ -0,0 +1,14 @@
> > +#ifndef __LINUX_TI_ADC_H
> > +#define __LINUX_TI_ADC_H
> > +
> > +/**
> > + * struct adc_data	ADC Input information
> > + * @adc_channels:	Number of analog inputs
> > + *			available for ADC.
> > + */
> > +
> > +struct adc_data {
> 
> The struct name might be a bit to generic.
> 
> > +	int adc_channels;
> 
> It does not really matter, but considering that there hardly ever going to be a negative number of channels I'd make this unsigned.

Ok. I will update this.

Regards,
Rachna

