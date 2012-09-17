Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2IQJdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:33:33 -0400
Received: from smtp-out-029.synserver.de ([212.40.185.29]:1100 "EHLO
	smtp-out-029.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2IQJdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:33:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 17742
Message-ID: <5056EE95.6050101@metafoo.de>
Date: Mon, 17 Sep 2012 11:34:13 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iio: inkern: put the IIO device when mem alloc gets
 failed
References: <A874F61F95741C4A9BA573A70FE3998F41EF50A5@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF50A5@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 10:44 AM, Kim, Milo wrote:
>  The reference count of the IIO device is increased if the IIO map has
>  matched consumer name.
>  After then, it tries to allocate the iio_channel which is used by the consumer.
>  If memory allocation gets failed, the reference count should be decreased.
> 
>  This patch enables restoring the reference count of the IIO device.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/iio/inkern.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index 13748c0..aff034b 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -132,7 +132,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>  
>  	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
>  	if (channel == NULL)
> -		return ERR_PTR(-ENOMEM);
> +		goto error_no_mem;
>  
>  	channel->indio_dev = c->indio_dev;
>  
> @@ -151,6 +151,9 @@ error_no_chan:
>  	iio_device_put(c->indio_dev);
>  	kfree(channel);
>  	return ERR_PTR(-EINVAL);
> +error_no_mem:
> +	iio_device_put(c->indio_dev);
> +	return ERR_PTR(-ENOMEM);
>  }
>  EXPORT_SYMBOL_GPL(iio_channel_get);
>  

If you do it that way, you don't really need the goto, something like

error_no_chan:
  	kfree(channel);
error_no_mem:
	iio_device_put(c->indio_dev);
	return ret

would be better in my opinion. With ret being initialized in the if branch
before the goto.

- Lars
