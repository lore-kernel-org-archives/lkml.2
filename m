Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423233Ab2JaRwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:52:43 -0400
Received: from smtp-out-183.synserver.de ([212.40.185.183]:1226 "EHLO
	smtp-out-183.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423085Ab2JaRwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:52:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23326
Message-ID: <50916563.8080704@metafoo.de>
Date: Wed, 31 Oct 2012 18:52:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.9) Gecko/20121014 Icedove/10.0.9
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/3] ti_adc: Update with IIO map interface
References: <1351783496-11557-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351783496-11557-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 04:24 PM, Pantelis Antoniou wrote:
> Add an IIO map interface that consumers can use.

Hi,

Looks like you overlooked the review comments I had inline last time. I've
put them in again, see below.

> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/iio/adc/ti_am335x_adc.c | 60 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 49 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 02a43c8..8595a90 100644
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

buf doesn't seem to be used anywhere

> +	struct iio_map *map;
>  };
>  
>  static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
> @@ -72,27 +75,62 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>  	tiadc_writel(adc_dev, REG_SE, STPENB_STEPENB);
>  }
>  
> -static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
> +static int tiadc_channel_init(struct iio_dev *indio_dev,
> +		struct tiadc_device *adc_dev)
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
> +	int channels = adc_dev->channels;
>  
> +	size = channels * (sizeof(struct iio_chan_spec) + 6);
> +	chan_array = kzalloc(size, GFP_KERNEL);
>  	if (chan_array == NULL)
>  		return -ENOMEM;
>  
> -	for (i = 0; i < (indio_dev->num_channels); i++) {
> -		struct iio_chan_spec *chan = chan_array + i;
> +	/* buffer space is after the array */
> +	s = (char *)(chan_array + channels);
> +	chan = chan_array;
> +	for (i = 0; i < channels; i++, chan++, s += len + 1) {
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

The scan type assignment should go in a separate patch if possible.

>  	}
>  
>  	indio_dev->channels = chan_array;
> +	indio_dev->num_channels = channels;
> +
> +	size = (channels + 1) * sizeof(struct iio_map);
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

The map should be passed in via platform data or similar. All the fields of
the map depend on the specific user, so you can't use a generic map. In fact
if we were able to use a generic map, we wouldn't need a map at all.

> +
> +	ret = iio_map_array_register(indio_dev, adc_dev->map);
> +	if (ret != 0) {
> +		kfree(adc_dev->map);
> +		kfree(chan_array);
> +		return -ENOMEM;
> +	}
>  
>  	return indio_dev->num_channels;
>  }
> @@ -168,7 +206,7 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
>  
>  	tiadc_step_config(adc_dev);
>  
> -	err = tiadc_channel_init(indio_dev, adc_dev->channels);
> +	err = tiadc_channel_init(indio_dev, adc_dev);
>  	if (err < 0)
>  		goto err_free_device;
>  

