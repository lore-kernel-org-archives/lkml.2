Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2I2Jso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 05:48:44 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38515 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2I2Jsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 05:48:42 -0400
Message-ID: <5066C3F9.3000303@kernel.org>
Date: Sat, 29 Sep 2012 10:48:41 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Patil, Rachna" <rachna@ti.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v4 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
References: <1348636814-14129-1-git-send-email-rachna@ti.com> <1348636814-14129-5-git-send-email-rachna@ti.com>
In-Reply-To: <1348636814-14129-5-git-send-email-rachna@ti.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 06:20 AM, Patil, Rachna wrote:
> This patch adds support for TI's ADC driver.
> This is a multifunctional device.
> Analog input lines are provided on which
> voltage measurements can be carried out.
> You can have upto 8 input lines.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>

Note I cannot build test and it won't apply to staging-next
without some merge fixes.
I wonder if this driver is a case for a small tree that gets pulled
into input/iio/mfd in the next cycle. It's a fiddly merge at
best right now as there have been changes that effect it
in all 3 subsystems earlier in this cycle (iio ones may just be
fuzz, I haven't gotten to a state to check it hasn't hit anything
else!)
> ---
> Changes in v2:
> 	Addressed review comments from Matthias Kaehlcke
> 
> Changes in v3:
> 	Addressed review comments from Jonathan Cameron.
> 	Added comments, new line appropriately.
> 
> Changes in v4:
> 	Removed extra comments and variables.
> 	rename idev to indio_dev throughout the driver.
> 	Renamed structs for better readability.
> 
>  drivers/iio/adc/Kconfig                     |    7 +
>  drivers/iio/adc/Makefile                    |    1 +
>  drivers/iio/adc/ti_am335x_adc.c             |  216 +++++++++++++++++++++++++++
>  drivers/mfd/ti_am335x_tscadc.c              |   18 ++-
>  include/linux/mfd/ti_am335x_tscadc.h        |    9 +-
>  include/linux/platform_data/ti_am335x_adc.h |   14 ++
>  6 files changed, 263 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iio/adc/ti_am335x_adc.c
>  create mode 100644 include/linux/platform_data/ti_am335x_adc.h
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 8a78b4f..59db45f 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -22,4 +22,11 @@ config AT91_ADC
>  	help
>  	  Say yes here to build support for Atmel AT91 ADC.
>  
> +config TI_AM335X_ADC
> +	tristate "TI's ADC driver"
> +	depends on ARCH_OMAP2PLUS
> +	help
> +	  Say yes here to build support for Texas Instruments ADC
> +	  driver which is also a MFD client.
> +
>  endmenu
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index 52eec25..e716588 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -4,3 +4,4 @@
>  
>  obj-$(CONFIG_AD7266) += ad7266.o
>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
> +obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> new file mode 100644
> index 0000000..9e1b3ac
> --- /dev/null
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -0,0 +1,216 @@
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
> +#include <linux/mfd/ti_am335x_tscadc.h>
> +#include <linux/platform_data/ti_am335x_adc.h>
> +
> +struct tiadc_device {
> +	struct ti_tscadc_dev *mfd_tscadc;
> +	int channels;
> +};
> +
> +static unsigned int adc_readl(struct tiadc_device *adc, unsigned int reg)
> +{
> +	return readl(adc->mfd_tscadc->tscadc_base + reg);
> +}
> +
> +static void adc_writel(struct tiadc_device *adc, unsigned int reg,
> +					unsigned int val)
> +{
> +	writel(val, adc->mfd_tscadc->tscadc_base + reg);
> +}
> +
> +static void adc_step_config(struct tiadc_device *adc_dev)
> +{
> +	unsigned int stepconfig;
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
> +static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
> +{
> +	struct iio_chan_spec *chan_array;
> +	int i;
> +
> +	indio_dev->num_channels = channels;
> +	chan_array = kcalloc(indio_dev->num_channels,
> +			sizeof(struct iio_chan_spec), GFP_KERNEL);
> +
> +	if (chan_array == NULL)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < (indio_dev->num_channels); i++) {
> +		struct iio_chan_spec *chan = chan_array + i;
> +		chan->type = IIO_VOLTAGE;
> +		chan->indexed = 1;
> +		chan->channel = i;
> +		chan->info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT;
> +	}
> +
> +	indio_dev->channels = chan_array;
> +
> +	return indio_dev->num_channels;
> +}
> +
> +static void tiadc_channels_remove(struct iio_dev *indio_dev)
> +{
> +	kfree(indio_dev->channels);
> +}
> +
> +static int tiadc_read_raw(struct iio_dev *indio_dev,
> +		struct iio_chan_spec const *chan,
> +		int *val, int *val2, long mask)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
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
> +	struct iio_dev		*indio_dev;
> +	struct tiadc_device	*adc_dev;
> +	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
> +	struct mfd_tscadc_board	*pdata;
> +	int			err;
> +
> +	pdata = tscadc_dev->dev->platform_data;
> +	if (!pdata || !pdata->adc_init) {
> +		dev_err(&pdev->dev, "Could not find platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	indio_dev = iio_device_alloc(sizeof(struct tiadc_device));
> +	if (indio_dev == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate iio device\n");
> +		err = -ENOMEM;
> +		goto err_ret;
> +	}
> +	adc_dev = iio_priv(indio_dev);
> +
> +	adc_dev->mfd_tscadc = tscadc_dev;
> +	adc_dev->channels = pdata->adc_init->adc_channels;
> +
> +	indio_dev->dev.parent = &pdev->dev;
> +	indio_dev->name = dev_name(&pdev->dev);
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->info = &tiadc_info;
> +
> +	adc_step_config(adc_dev);
> +
> +	err = tiadc_channel_init(indio_dev, adc_dev->channels);
> +	if (err < 0)
> +		goto err_free_device;
> +
> +	err = iio_device_register(indio_dev);
> +	if (err)
> +		goto err_free_channels;
> +
> +	platform_set_drvdata(pdev, indio_dev);
> +
> +	return 0;
> +
> +err_free_channels:
> +	tiadc_channels_remove(indio_dev);
> +err_free_device:
> +	iio_device_free(indio_dev);
> +err_ret:
> +	return err;
> +}
> +
> +static int __devexit tiadc_remove(struct platform_device *pdev)
> +{
> +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> +
> +	iio_device_unregister(indio_dev);
> +	tiadc_channels_remove(indio_dev);
> +
> +	iio_device_free(indio_dev);
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
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index 168313e..45d66e5 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -23,6 +23,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/mfd/ti_am335x_tscadc.h>
>  #include <linux/input/ti_am335x_tsc.h>
> +#include <linux/platform_data/ti_am335x_adc.h>
>  
>  static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
>  {
> @@ -55,14 +56,23 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
>  	int			irq;
>  	int			err, ctrl;
>  	int			clk_value, clock_rate;
> -	int			tsc_wires;
> +	int			tsc_wires, adc_channels = 0, total_channels;
>  
>  	if (!pdata) {
>  		dev_err(&pdev->dev, "Could not find platform data\n");
>  		return -EINVAL;
>  	}
>  
> +	if (pdata->adc_init)
> +		adc_channels = pdata->adc_init->adc_channels;
> +
>  	tsc_wires = pdata->tsc_init->wires;
> +	total_channels = tsc_wires + adc_channels;
> +
> +	if (total_channels > 8) {
> +		dev_err(&pdev->dev, "Number of i/p channels more than 8\n");
> +		return -EINVAL;
> +	}
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res) {
> @@ -149,6 +159,12 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
>  	cell->platform_data = tscadc;
>  	cell->pdata_size = sizeof(*tscadc);
>  
> +	/* ADC Cell */
> +	cell = &tscadc->cells[ADC_CELL];
> +	cell->name = "tiadc";
> +	cell->platform_data = tscadc;
> +	cell->pdata_size = sizeof(*tscadc);
> +
>  	err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
>  			TSCADC_CELLS, NULL, 0, NULL);
>  	if (err < 0)
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index 458accd..bd9fe1d 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -117,15 +117,19 @@
>  
>  #define ADC_CLK			3000000
>  #define	MAX_CLK_DIV		7
> +#define TOTAL_STEPS		16
> +#define TOTAL_CHANNELS		8
>  
> -#define TSCADC_CELLS		1
> +#define TSCADC_CELLS		2
>  
>  enum tscadc_cells {
>  	TSC_CELL,
> +	ADC_CELL,
>  };
>  
>  struct mfd_tscadc_board {
>  	struct tsc_data *tsc_init;
> +	struct adc_data *adc_init;
>  };
>  
>  struct ti_tscadc_dev {
> @@ -136,6 +140,9 @@ struct ti_tscadc_dev {
>  
>  	/* tsc device */
>  	struct tscadc *tsc;
> +
> +	/* adc device */
> +	struct adc_device *adc;
>  };
>  
>  #endif
> diff --git a/include/linux/platform_data/ti_am335x_adc.h b/include/linux/platform_data/ti_am335x_adc.h
> new file mode 100644
> index 0000000..e41d583
> --- /dev/null
> +++ b/include/linux/platform_data/ti_am335x_adc.h
> @@ -0,0 +1,14 @@
> +#ifndef __LINUX_TI_AM335X_ADC_H
> +#define __LINUX_TI_AM335X_ADC_H
> +
> +/**
> + * struct adc_data	ADC Input information
> + * @adc_channels:	Number of analog inputs
> + *			available for ADC.
> + */
> +
> +struct adc_data {
> +	unsigned int adc_channels;
> +};
> +
> +#endif
> 
