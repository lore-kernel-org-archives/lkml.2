Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2HHLFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:05:40 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:37249 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab2HHLFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:05:39 -0400
Date: Wed, 8 Aug 2012 13:05:37 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2] iio/adjd_s311: Fix potential memory leak in
 adjd_s311_update_scan_mode()
In-Reply-To: <1344419935-20885-1-git-send-email-khoroshilov@ispras.ru>
Message-ID: <alpine.DEB.2.01.1208081305030.15745@pmeerw.net>
References: <1344419935-20885-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do not leak memory by updating pointer with potentially NULL realloc return value.
> There is no need to preserve data in the buffer,
> so replace krealloc() by kfree()-kmalloc() pair.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Peter Meerwald <pmeerw@pmeerw.net>

> ---
>  drivers/iio/light/adjd_s311.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iio/light/adjd_s311.c b/drivers/iio/light/adjd_s311.c
> index 1cbb449..9a99f43 100644
> --- a/drivers/iio/light/adjd_s311.c
> +++ b/drivers/iio/light/adjd_s311.c
> @@ -271,9 +271,10 @@ static int adjd_s311_update_scan_mode(struct iio_dev *indio_dev,
>  	const unsigned long *scan_mask)
>  {
>  	struct adjd_s311_data *data = iio_priv(indio_dev);
> -	data->buffer = krealloc(data->buffer, indio_dev->scan_bytes,
> -				GFP_KERNEL);
> -	if (!data->buffer)
> +
> +	kfree(data->buffer);
> +	data->buffer = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
> +	if (data->buffer == NULL)
>  		return -ENOMEM;
>  
>  	return 0;
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
