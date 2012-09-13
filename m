Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab2IMMuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:50:51 -0400
Received: from smtp-out-026.synserver.de ([212.40.185.26]:1045 "EHLO
	smtp-out-026.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab2IMMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:50:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10134
Message-ID: <5051D6C7.2010700@metafoo.de>
Date: Thu, 13 Sep 2012 14:51:19 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Patil, Rachna" <rachna@ti.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v3 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
References: <1347532819-505-1-git-send-email-rachna@ti.com> <1347532819-505-5-git-send-email-rachna@ti.com>
In-Reply-To: <1347532819-505-5-git-send-email-rachna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 12:40 PM, Patil, Rachna wrote:
> This patch adds support for TI's ADC driver.
> This is a multifunctional device.
> Analog input lines are provided on which
> voltage measurements can be carried out.
> You can have upto 8 input lines.
> 

Hi,

couple of minor issues inline.

> Signed-off-by: Patil, Rachna <rachna@ti.com>
> ---
> Changes in v2:
> 	Addressed review comments from Matthias Kaehlcke
> 
> Changes in v3:
> 	Addressed review comments from Jonathan Cameron.
> 	Added comments, new line appropriately.
> 
>  drivers/iio/adc/Kconfig              |    7 +
>  drivers/iio/adc/Makefile             |    1 +
>  drivers/iio/adc/ti_adc.c             |  223 ++++++++++++++++++++++++++++++++++
>  drivers/mfd/ti_tscadc.c              |   18 +++-
>  include/linux/mfd/ti_tscadc.h        |    9 ++-
>  include/linux/platform_data/ti_adc.h |   14 ++
>  6 files changed, 270 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iio/adc/ti_adc.c
>  create mode 100644 include/linux/platform_data/ti_adc.h
> 
[...]
> +
> +struct adc_device {

Not really an issue, but I'd use a consistent function/struct prefix.
Currently you use both "adc" and "tiadc"

> +	struct ti_tscadc_dev *mfd_tscadc;
> +	struct iio_dev *idev;

idev is used only once in the remove callback. But you can get a pointer to
it easily using platform_get_drvdata. So I'd remove it from the adc_device
struct.

> +	int channels;
> +};
> +
> +static unsigned int adc_readl(struct adc_device *adc, unsigned int reg)
> +{
> +	return readl(adc->mfd_tscadc->tscadc_base + reg);
> +}
> +
> +static void adc_writel(struct adc_device *adc, unsigned int reg,
> +					unsigned int val)
> +{
> +	writel(val, adc->mfd_tscadc->tscadc_base + reg);
> +}
> +
> +static void adc_step_config(struct adc_device *adc_dev)
> +{
> +	unsigned int    stepconfig;

extra whitespace

> +	int i, channels = 0, steps;
> +
> +	/*
> +	 * There are 16 configurable steps and 8 analog input
> +	 * lines available which are shared between Touchscreen and ADC.
> +	 *
> +	 * Steps backwards i.e. from 16 towards 0 are used by ADC
> +	 * depending on number of input lines needed.
> +	 * Channel would represent which analog input
> +	 * needs to be given to ADC to digitalize data.
> +	 */
> +
> +	steps = TOTAL_STEPS - adc_dev->channels;
> +	channels = TOTAL_CHANNELS - adc_dev->channels;
> +
> +	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
> +
> +	for (i = (steps + 1); i <= TOTAL_STEPS; i++) {
> +		adc_writel(adc_dev, REG_STEPCONFIG(i),
> +				stepconfig | STEPCONFIG_INP(channels));
> +		adc_writel(adc_dev, REG_STEPDELAY(i),
> +				STEPCONFIG_OPENDLY);
> +		channels++;
> +	}
> +	adc_writel(adc_dev, REG_SE, STPENB_STEPENB);
> +}
> +
> [...]
> +
> +static const struct iio_info tiadc_info = {
> +	.read_raw = &tiadc_read_raw,

    .driver_module = THIS_MODULE,

> +};
> +
> +static int __devinit tiadc_probe(struct platform_device *pdev)
> +{
> +	struct iio_dev		*idev;

For consistency with other drivers please rename idev to indio_dev
throughout the driver.

> +	int			err;
> +	struct adc_device	*adc_dev;
> +	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
> +	struct mfd_tscadc_board	*pdata;
> +
> +	pdata = (struct mfd_tscadc_board *)tscadc_dev->dev->platform_data;

The cast should not be necessary.

> +	if (!pdata || !pdata->adc_init) {
> +		dev_err(tscadc_dev->dev, "Could not find platform data\n");

I'd still use pdev->dev for the device parameter here. Seeing a message
printed by this driver for another device might be confusing.

> +		return -EINVAL;
> +	}
> +
> +	idev = iio_device_alloc(sizeof(struct adc_device));
> +	if (idev == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate iio device.\n");
> +		err = -ENOMEM;
> +		goto err_ret;
> +	}
> +	adc_dev = iio_priv(idev);
> +
> +	tscadc_dev->adc = adc_dev;

This there any reason why you need to store a pointer to the adc struct in
the mfd struct? Is it going to be used outside of the adc driver? Currently
it is, as far as I can see, only used in the remove callback and
suspend/resume handlers. But there you can use iio_priv just as easily to
get the pointer to the adc device struct and it certainly will be also be
cleaner to do it that way.

> +	adc_dev->mfd_tscadc = tscadc_dev;
> +	adc_dev->idev = idev;
> +	adc_dev->channels = pdata->adc_init->adc_channels;
> +
> +	idev->dev.parent = &pdev->dev;
> +	idev->name = dev_name(&pdev->dev);
> +	idev->modes = INDIO_DIRECT_MODE;
> +	idev->info = &tiadc_info;
> +
> +	adc_step_config(adc_dev);
> +
> +	err = tiadc_channel_init(idev, adc_dev->channels);
> +	if (err < 0)
> +		goto err_free_device;
> +
> +	err = iio_device_register(idev);
> +	if (err)
> +		goto err_free_channels;
> +
> +	dev_info(&pdev->dev, "attached adc driver\n");

I'd remove that line, it's just noise.

> +	platform_set_drvdata(pdev, idev);
> +
> +	return 0;
> +
> +err_free_channels:
> +	tiadc_channels_remove(idev);
> +err_free_device:
> +	iio_device_free(idev);
> +err_ret:
> +	return err;
> +}
> +

[...]
> diff --git a/include/linux/platform_data/ti_adc.h b/include/linux/platform_data/ti_adc.h
> new file mode 100644
> index 0000000..5a89f1d
> --- /dev/null
> +++ b/include/linux/platform_data/ti_adc.h
> @@ -0,0 +1,14 @@
> +#ifndef __LINUX_TI_ADC_H
> +#define __LINUX_TI_ADC_H
> +
> +/**
> + * struct adc_data	ADC Input information
> + * @adc_channels:	Number of analog inputs
> + *			available for ADC.
> + */
> +
> +struct adc_data {

The struct name might be a bit to generic.

> +	int adc_channels;

It does not really matter, but considering that there hardly ever going to
be a negative number of channels I'd make this unsigned.

> +};
> +
> +#endif

