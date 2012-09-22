Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2IVJOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:14:34 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52753 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2IVJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:14:30 -0400
Message-ID: <505D8177.6050101@kernel.org>
Date: Sat, 22 Sep 2012 10:14:31 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: inkern: clean up error return code
References: <A874F61F95741C4A9BA573A70FE3998F41EF539F@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF539F@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 05:56 AM, Kim, Milo wrote:
>  When the IIO consumer tries to get specific IIO channel,
>  few error cases can be happened.
>  (a) Memory allocation failure
>  (b) No matched ADC channel error
>  (c) Invalid input arguments
>  This patch enables cleaning up error handling in case of (a) and (b).
> 
>  In error handling code,
>  (a): the reference count of the IIO device should be decreased.
>  (b): the allocated memory should be freed with restoring the reference count.
>  Therefore iio_deivce_put() is called in both cases.
>  This can be handled in the last error statement.
> 
>  Additionally, integer variable is used for stating each error case explicitly.
>  Then, the error returns as ERR_PTR() with this value.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Thanks,
added to togreg branch of iio.git
> ---
>  drivers/iio/inkern.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index aff034b..656d4d4 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -111,6 +111,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>  {
>  	struct iio_map_internal *c_i = NULL, *c = NULL;
>  	struct iio_channel *channel;
> +	int err;
>  
>  	if (name == NULL && channel_name == NULL)
>  		return ERR_PTR(-ENODEV);
> @@ -131,8 +132,10 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>  		return ERR_PTR(-ENODEV);
>  
>  	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
> -	if (channel == NULL)
> +	if (channel == NULL) {
> +		err = -ENOMEM;
>  		goto error_no_mem;
> +	}
>  
>  	channel->indio_dev = c->indio_dev;
>  
> @@ -141,19 +144,19 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>  			iio_chan_spec_from_name(channel->indio_dev,
>  						c->map->adc_channel_label);
>  
> -		if (channel->channel == NULL)
> +		if (channel->channel == NULL) {
> +			err = -EINVAL;
>  			goto error_no_chan;
> +		}
>  	}
>  
>  	return channel;
>  
>  error_no_chan:
> -	iio_device_put(c->indio_dev);
>  	kfree(channel);
> -	return ERR_PTR(-EINVAL);
>  error_no_mem:
>  	iio_device_put(c->indio_dev);
> -	return ERR_PTR(-ENOMEM);
> +	return ERR_PTR(err);
>  }
>  EXPORT_SYMBOL_GPL(iio_channel_get);
>  
> 
