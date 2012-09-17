Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2IQSVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:21:47 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57484 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2IQSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:21:46 -0400
Message-ID: <50576A36.3050202@kernel.org>
Date: Mon, 17 Sep 2012 19:21:42 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iio: inkern: add error case in iio_channel_get()
References: <A874F61F95741C4A9BA573A70FE3998F41EF509D@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF509D@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 09:44 AM, Kim, Milo wrote:
>  The datasheet name is defined in the IIO driver.
>  On the other hand, the adc_channel_label is configured in
>  the platform side.
>  If the datasheet name is not matched with any adc_channel_label,
>  the iio_channel_get() should be returned as error for preventing
>  invalid channel data access.
> 
>  This can be handled either way.
>  (a) checking null data when using it : in the xxx_read_raw()
>  or
>  (b) error returns when the channel is requested : this patch
> 
>  The IIO consumer can't use the channel with invalid channel spec.
>  Therefore case (b) is more reasonable.
> 
Nicely patch, thanks.

Merged to togreg branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git


> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/iio/inkern.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index 1faa240..13748c0 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -136,12 +136,21 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>  
>  	channel->indio_dev = c->indio_dev;
>  
> -	if (c->map->adc_channel_label)
> +	if (c->map->adc_channel_label) {
>  		channel->channel =
>  			iio_chan_spec_from_name(channel->indio_dev,
>  						c->map->adc_channel_label);
>  
> +		if (channel->channel == NULL)
> +			goto error_no_chan;
> +	}
> +
>  	return channel;
> +
> +error_no_chan:
> +	iio_device_put(c->indio_dev);
> +	kfree(channel);
> +	return ERR_PTR(-EINVAL);
>  }
>  EXPORT_SYMBOL_GPL(iio_channel_get);
>  
> 
