Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874Ab2IMMNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:13:35 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:35181 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab2IMMNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:13:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <5051CDEA.5080200@kernel.org>
Date: Thu, 13 Sep 2012 13:13:30 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Patil, Rachna" <rachna@ti.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v3 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
References: <1347532819-505-1-git-send-email-rachna@ti.com> <1347532819-505-5-git-send-email-rachna@ti.com>
In-Reply-To: <1347532819-505-5-git-send-email-rachna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/12 11:40, Patil, Rachna wrote:
> This patch adds support for TI's ADC driver.
> This is a multifunctional device.
> Analog input lines are provided on which
> voltage measurements can be carried out.
> You can have upto 8 input lines.
>
> Signed-off-by: Patil, Rachna <rachna@ti.com>

There's a little fuzz in applying this due to other drivers that have
gone in recently.

Actually this is going to be 'interesting' to merge. Dmitry, Samuel 
thoughts on who takes this one and how?  Maybe this is a case for a
'special' branch pulled into more than one tree?


One minor thing inline.  I have an aversion to dynamic allocation of
things that are then constant.

Also the module name is simply ti_adc. Does seem a little 'vague'
given the range of ADC's TI makes :)  Perhaps keep the reference
to the tsc in there?  Personally I'd have preferred the whole thing
being named after a particular part number (any one it support would
do) to avoid a clash in future with a new touch screen adc from TI.
Bit late for that though I guess ;)

Jonathan
> ---
> Changes in v2:
> 	Addressed review comments from Matthias Kaehlcke
>
> Changes in v3:
> 	Addressed review comments from Jonathan Cameron.
> 	Added comments, new line appropriately.
>
>   drivers/iio/adc/Kconfig              |    7 +
>   drivers/iio/adc/Makefile             |    1 +
>   drivers/iio/adc/ti_adc.c             |  223 ++++++++++++++++++++++++++++++++++
>   drivers/mfd/ti_tscadc.c              |   18 +++-
>   include/linux/mfd/ti_tscadc.h        |    9 ++-
>   include/linux/platform_data/ti_adc.h |   14 ++
>   6 files changed, 270 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/iio/adc/ti_adc.c
>   create mode 100644 include/linux/platform_data/ti_adc.h
>
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 8a78b4f..ad32df8 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -22,4 +22,11 @@ config AT91_ADC
>   	help
>   	  Say yes here to build support for Atmel AT91 ADC.
>
> +config TI_ADC
> +	tristate "TI's ADC driver"
> +	depends on ARCH_OMAP2PLUS
> +	help
> +	  Say yes here to build support for Texas Instruments ADC
> +	  driver which is also a MFD client.
> +
>   endmenu
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index 52eec25..a930cee 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -4,3 +4,4 @@
>
>   obj-$(CONFIG_AD7266) += ad7266.o
>   obj-$(CONFIG_AT91_ADC) += at91_adc.o
> +obj-$(CONFIG_TI_ADC) += ti_adc.o
> diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c
> new file mode 100644
> index 0000000..56f8af2
> --- /dev/null
> +++ b/drivers/iio/adc/ti_adc.c
> @@ -0,0 +1,223 @@
> +/*
> + * TI ADC MFD driver
> + *
> + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/iio/iio.h>
> +
> +#include <linux/mfd/ti_tscadc.h>
> +#include <linux/platform_data/ti_adc.h>
> +
> +struct adc_device {
> +	struct ti_tscadc_dev *mfd_tscadc;
> +	struct iio_dev *idev;
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
> +static int tiadc_channel_init(struct iio_dev *idev, int channels)
> +{
> +	struct iio_chan_spec *chan_array;
> +	int i;
> +
> +	idev->num_channels = channels;
> +	chan_array = kcalloc(idev->num_channels, sizeof(struct iio_chan_spec),
> +					GFP_KERNEL);
> +
> +	if (chan_array == NULL)
> +		return -ENOMEM;
> +
Minor point, but I'd be tempted to do this as a static const array and 
then just set num_channels appropriately.  Still it's such a simple 
driver that I'm not that fussed.
> +	for (i = 0; i < (idev->num_channels); i++) {
> +		struct iio_chan_spec *chan = chan_array + i;
> +		chan->type = IIO_VOLTAGE;
> +		chan->indexed = 1;
> +		chan->channel = i;
> +		chan->info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT;
> +	}
> +
> +	idev->channels = chan_array;
> +
> +	return idev->num_channels;
> +}
> +
> +static void tiadc_channels_remove(struct iio_dev *idev)
> +{
> +	kfree(idev->channels);
> +}
> +
> +static int tiadc_read_raw(struct iio_dev *idev,
> +		struct iio_chan_spec const *chan,
> +		int *val, int *val2, long mask)
> +{
> +	struct adc_device *adc_dev = iio_priv(idev);
> +	int i;
> +	unsigned int fifo1count, readx1;
> +
> +	/*
> +	 * When the sub-system is first enabled,
> +	 * the sequencer will always start with the
> +	 * lowest step (1) and continue until step (16).
> +	 * For ex: If we have enabled 4 ADC channels and
> +	 * currently use only 1 out of them, the
> +	 * sequencer still configures all the 4 steps,
> +	 * leading to 3 unwanted data.
> +	 * Hence we need to flush out this data.
> +	 */
> +
> +	fifo1count = adc_readl(adc_dev, REG_FIFO1CNT);
> +	for (i = 0; i < fifo1count; i++) {
> +		readx1 = adc_readl(adc_dev, REG_FIFO1);
> +		if (i == chan->channel)
> +			*val = readx1 & 0xfff;
> +	}
> +	adc_writel(adc_dev, REG_SE, STPENB_STEPENB);
> +
> +	return IIO_VAL_INT;
> +}
> +
> +static const struct iio_info tiadc_info = {
> +	.read_raw = &tiadc_read_raw,
> +};
> +
> +static int __devinit tiadc_probe(struct platform_device *pdev)
> +{
> +	struct iio_dev		*idev;
> +	int			err;
> +	struct adc_device	*adc_dev;
> +	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
> +	struct mfd_tscadc_board	*pdata;
> +
> +	pdata = (struct mfd_tscadc_board *)tscadc_dev->dev->platform_data;
> +	if (!pdata || !pdata->adc_init) {
> +		dev_err(tscadc_dev->dev, "Could not find platform data\n");
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
> +static int __devexit tiadc_remove(struct platform_device *pdev)
> +{
> +	struct ti_tscadc_dev   *tscadc_dev = pdev->dev.platform_data;
> +	struct adc_device	*adc_dev = tscadc_dev->adc;
> +	struct iio_dev		*idev = adc_dev->idev;
> +
> +	iio_device_unregister(idev);
> +	tiadc_channels_remove(idev);
> +
> +	tscadc_dev->adc = NULL;
> +	iio_device_free(idev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver tiadc_driver = {
> +	.driver = {
> +		.name   = "tiadc",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe	= tiadc_probe,
> +	.remove	= __devexit_p(tiadc_remove),
> +};
> +
> +module_platform_driver(tiadc_driver);
> +
> +MODULE_DESCRIPTION("TI ADC controller driver");
> +MODULE_AUTHOR("Rachna Patil <rachna@ti.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/mfd/ti_tscadc.c b/drivers/mfd/ti_tscadc.c
> index f26e53b..9dbd6d0 100644
> --- a/drivers/mfd/ti_tscadc.c
> +++ b/drivers/mfd/ti_tscadc.c
> @@ -23,6 +23,7 @@
>   #include <linux/pm_runtime.h>
>   #include <linux/mfd/ti_tscadc.h>
>   #include <linux/input/ti_tsc.h>
> +#include <linux/platform_data/ti_adc.h>
>
>   static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
>   {
> @@ -55,14 +56,23 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
>   	int			irq;
>   	int			err, ctrl;
>   	int			clk_value, clock_rate;
> -	int			tsc_wires;
> +	int			tsc_wires, adc_channels = 0, total_channels;
>
>   	if (!pdata) {
>   		dev_err(&pdev->dev, "Could not find platform data\n");
>   		return -EINVAL;
>   	}
>
> +	if (pdata->adc_init)
> +		adc_channels = pdata->adc_init->adc_channels;
> +
>   	tsc_wires = pdata->tsc_init->wires;
> +	total_channels = tsc_wires + adc_channels;
> +
> +	if (total_channels > 8) {
> +		dev_err(&pdev->dev, "Number of i/p channels more than 8\n");
> +		return -EINVAL;
> +	}
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	if (!res) {
> @@ -149,6 +159,12 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
>   	cell->platform_data = tscadc;
>   	cell->pdata_size = sizeof(*tscadc);
>
> +	/* ADC Cell */
> +	cell = &tscadc->cells[ADC_CELL];
> +	cell->name = "tiadc";
> +	cell->platform_data = tscadc;
> +	cell->pdata_size = sizeof(*tscadc);
> +
>   	err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
>   			TSCADC_CELLS, NULL, 0);
>   	if (err < 0)
> diff --git a/include/linux/mfd/ti_tscadc.h b/include/linux/mfd/ti_tscadc.h
> index d28a35c..67b7d5e 100644
> --- a/include/linux/mfd/ti_tscadc.h
> +++ b/include/linux/mfd/ti_tscadc.h
> @@ -117,15 +117,19 @@
>
>   #define ADC_CLK			3000000
>   #define	MAX_CLK_DIV		7
> +#define TOTAL_STEPS		16
> +#define TOTAL_CHANNELS		8
>
> -#define TSCADC_CELLS		1
> +#define TSCADC_CELLS		2
>
>   enum tscadc_cells {
>   	TSC_CELL,
> +	ADC_CELL,
>   };
>
>   struct mfd_tscadc_board {
>   	struct tsc_data *tsc_init;
> +	struct adc_data *adc_init;
>   };
>
>   struct ti_tscadc_dev {
> @@ -136,6 +140,9 @@ struct ti_tscadc_dev {
>
>   	/* tsc device */
>   	struct tscadc *tsc;
> +
> +	/* adc device */
> +	struct adc_device *adc;
>   };
>
>   #endif
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
> +	int adc_channels;
> +};
> +
> +#endif
>

