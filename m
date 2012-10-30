Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965368Ab2J3S2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:28:45 -0400
Received: from smtp-out-181.synserver.de ([212.40.185.181]:1197 "EHLO
	smtp-out-181.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760078Ab2J3S2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:28:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22198
Message-ID: <50901C5A.8080502@metafoo.de>
Date: Tue, 30 Oct 2012 19:28:42 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.9) Gecko/20121014 Icedove/10.0.9
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] ti_tscadc: Update with IIO map interface & deal with
 partial activation
References: <1351698938-3839-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351698938-3839-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 04:55 PM, Pantelis Antoniou wrote:
> Add an IIO map interface that consumers can use.
> Also make sure the mfd device doesn't activate a driver which
> the configuration doesn't require.

Same here, two completely different changes in the same patch.

> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/iio/adc/ti_am335x_adc.c      | 53 ++++++++++++++++++++++++++++++------
>  drivers/mfd/ti_am335x_tscadc.c       | 30 ++++++++++++++------
>  include/linux/mfd/ti_am335x_tscadc.h |  8 ++----
>  3 files changed, 68 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 02a43c8..d48fd79 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -20,8 +20,9 @@
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
> -#include <linux/io.h>
>  #include <linux/iio/iio.h>
> +#include <linux/iio/machine.h>
> +#include <linux/iio/driver.h>
>  
>  #include <linux/mfd/ti_am335x_tscadc.h>
>  #include <linux/platform_data/ti_am335x_adc.h>
> @@ -29,6 +30,8 @@
>  struct tiadc_device {
>  	struct ti_tscadc_dev *mfd_tscadc;
>  	int channels;
> +	char *buf;

As far as I can see 'buf' is not used otherwise in this patch.

> +	struct iio_map *map;
>  };
>  
>  static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
> @@ -75,25 +78,57 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>  static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
>  {
>  	struct iio_chan_spec *chan_array;
> -	int i;
> -
> -	indio_dev->num_channels = channels;
> -	chan_array = kcalloc(indio_dev->num_channels,
> -			sizeof(struct iio_chan_spec), GFP_KERNEL);
> +	struct iio_chan_spec *chan;
> +	char *s;
> +	int i, len, size, ret;
>  
> +	size = indio_dev->num_channels * (sizeof(struct iio_chan_spec) + 6);
> +	chan_array = kzalloc(size, GFP_KERNEL);
>  	if (chan_array == NULL)
>  		return -ENOMEM;
>  
> -	for (i = 0; i < (indio_dev->num_channels); i++) {
> -		struct iio_chan_spec *chan = chan_array + i;
> +	/* buffer space is after the array */
> +	s = (char *)(chan_array + indio_dev->num_channels);
> +	chan = chan_array;
> +	for (i = 0; i < indio_dev->num_channels; i++, chan++, s += len + 1) {
> +
> +		len = sprintf(s, "AIN%d", i);
> +
>  		chan->type = IIO_VOLTAGE;
>  		chan->indexed = 1;
>  		chan->channel = i;
> -		chan->info_mask = IIO_CHAN_INFO_RAW_SEPARATE_BIT;
> +		chan->datasheet_name = s;

> +		chan->scan_type.sign = 'u';
> +		chan->scan_type.realbits = 12;
> +		chan->scan_type.storagebits = 32;
> +		chan->scan_type.shift = 0;

This part is another separate thing done by this patch and is not even in
the patch description.

>  	}
>  
>  	indio_dev->channels = chan_array;
>  
> +	size = (indio_dev->num_channels + 1) * sizeof(struct iio_map);
> +	adc_dev->map = kzalloc(size, GFP_KERNEL);
> +	if (adc_dev->map == NULL) {
> +		kfree(chan_array);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < indio_dev->num_channels; i++) {
> +		adc_dev->map[i].adc_channel_label = chan_array[i].datasheet_name;
> +		adc_dev->map[i].consumer_dev_name = "any";
> +		adc_dev->map[i].consumer_channel = chan_array[i].datasheet_name;
> +	}
> +	adc_dev->map[i].adc_channel_label = NULL;
> +	adc_dev->map[i].consumer_dev_name = NULL;
> +	adc_dev->map[i].consumer_channel = NULL;
> +
> +	ret = iio_map_array_register(indio_dev, adc_dev->map);
> +	if (ret != 0) {
> +		kfree(adc_dev->map);
> +		kfree(chan_array);
> +		return -ENOMEM;
> +	}

The consumer data is supposed to be passed in by platform data, as it will
depend on the actual consumer. E.g. the consumer_dev_name has to match the
name of device which requests the channel. Same goes for the consumer
channel attribute, this is consumer specific as well.

> +
>  	return indio_dev->num_channels;
>  }
>  
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index e947dd8..cbb8b70c 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -176,26 +176,38 @@ static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
>  	ctrl |= CNTRLREG_TSCSSENB;
>  	tscadc_writel(tscadc, REG_CTRL, ctrl);
>  
> +	tscadc->used_cells = 0;
> +	tscadc->tsc_cell = -1;
> +	tscadc->adc_cell = -1;
> +
>  	/* TSC Cell */
> -	cell = &tscadc->cells[TSC_CELL];
> -	cell->name = "tsc";
> -	cell->platform_data = tscadc;
> -	cell->pdata_size = sizeof(*tscadc);
> +	if (tsc_wires > 0) {
> +		tscadc->tsc_cell = tscadc->used_cells;
> +		cell = &tscadc->cells[tscadc->used_cells++];
> +		cell->name = "tsc";
> +		cell->platform_data = tscadc;
> +		cell->pdata_size = sizeof(*tscadc);
> +	}
>  
>  	/* ADC Cell */
> -	cell = &tscadc->cells[ADC_CELL];
> -	cell->name = "tiadc";
> -	cell->platform_data = tscadc;
> -	cell->pdata_size = sizeof(*tscadc);
> +	if (adc_channels > 0) {
> +		tscadc->adc_cell = tscadc->used_cells;
> +		cell = &tscadc->cells[tscadc->used_cells++];
> +		cell->name = "tiadc";
> +		cell->platform_data = tscadc;
> +		cell->pdata_size = sizeof(*tscadc);
> +	}
>  
>  	err = mfd_add_devices(&pdev->dev, pdev->id, tscadc->cells,
> -			TSCADC_CELLS, NULL, 0, NULL);
> +			tscadc->used_cells, NULL, 0, NULL);
>  	if (err < 0)
>  		goto err_disable_clk;
>  
>  	device_init_wakeup(&pdev->dev, true);
>  	platform_set_drvdata(pdev, tscadc);
>  
> +	dev_info(&pdev->dev, "Initialized OK.\n");
> +
>  	return 0;
>  
>  err_disable_clk:
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index 9624fea..50a245f 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -128,11 +128,6 @@
>  
>  #define TSCADC_CELLS		2
>  
> -enum tscadc_cells {
> -	TSC_CELL,
> -	ADC_CELL,
> -};
> -
>  struct mfd_tscadc_board {
>  	struct tsc_data *tsc_init;
>  	struct adc_data *adc_init;
> @@ -143,6 +138,9 @@ struct ti_tscadc_dev {
>  	struct regmap *regmap_tscadc;
>  	void __iomem *tscadc_base;
>  	int irq;
> +	int used_cells;	/* 0-2 */
> +	int tsc_cell;	/* -1 if not used */
> +	int adc_cell;	/* -1 if not used */
>  	struct mfd_cell cells[TSCADC_CELLS];
>  
>  	/* tsc device */

