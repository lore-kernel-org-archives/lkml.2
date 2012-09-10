Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2IJJXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:23:37 -0400
Received: from smtp-out-022.synserver.de ([212.40.185.22]:1163 "EHLO
	smtp-out-022.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2IJJXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:23:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27644
Message-ID: <504DB1B8.4020608@metafoo.de>
Date: Mon, 10 Sep 2012 11:24:08 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: inkern: add error case in iio_channel_get()
References: <A874F61F95741C4A9BA573A70FE3998F41EF45EB@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF45EB@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 10:02 AM, Kim, Milo wrote:
>  The datasheet name is defined in the IIO driver.
>  On the other hand, the adc_channel_label is configured in
>  the platform machine side.
>  If the datasheet name is not matched with any adc_channel_label,
>  the iio_channel_get() should be returned as error for preventing
>  using invalid IIO channel data.
> 
>  Moreover, this patch detects NULL pointer dereference problem at early time.
>  In general, the IIO driver just accesses to any member of the iio_chan_spec
>  in own xxx_read_raw() function.
>  If the iio_chan_spec is invalid pointer, NULL dereference problem may occur
>  such like 'iio_chan_spec->channel' or 'iio_chan_spec->type'.
>  If the iio_channel_get() gets failed in the IIO consumer,
>  then no read_raw() operation proceeds.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/iio/inkern.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index 1faa240..a5caf6b 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -136,11 +136,15 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
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
> +			return ERR_PTR(-ENODEV);

This introduces a memory leak. You need to free channel before returning.

> +	}
> +
>  	return channel;
>  }
>  EXPORT_SYMBOL_GPL(iio_channel_get);

