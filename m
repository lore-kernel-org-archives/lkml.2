Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab1FBPIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 11:08:01 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:57106 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1FBPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 11:08:00 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DE7A92F.7090702@cam.ac.uk>
Date: Thu, 02 Jun 2011 16:15:59 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Andre Bartke <andre.bartke@googlemail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: Re: [PATCH] staging/iio: error case memory leak fix
References: <1306966905-13799-1-git-send-email-andre.bartke@gmail.com>
In-Reply-To: <1306966905-13799-1-git-send-email-andre.bartke@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/11 23:21, Andre Bartke wrote:
> The data pointer should be freed in the error
> cases of adis16400_trigger_handler().
Thanks.  
> 
> Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/imu/adis16400_ring.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/iio/imu/adis16400_ring.c b/drivers/staging/iio/imu/adis16400_ring.c
> index 2589a7e..3612373 100644
> --- a/drivers/staging/iio/imu/adis16400_ring.c
> +++ b/drivers/staging/iio/imu/adis16400_ring.c
> @@ -137,13 +137,13 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
>  		if (st->variant->flags & ADIS16400_NO_BURST) {
>  			ret = adis16350_spi_read_all(&indio_dev->dev, st->rx);
>  			if (ret < 0)
> -				return ret;
> +				goto err;
>  			for (; i < ring->scan_count; i++)
>  				data[i]	= *(s16 *)(st->rx + i*2);
>  		} else {
>  			ret = adis16400_spi_read_burst(&indio_dev->dev, st->rx);
>  			if (ret < 0)
> -				return ret;
> +				goto err;
>  			for (; i < indio_dev->ring->scan_count; i++) {
>  				j = __ffs(mask);
>  				mask &= ~(1 << j);
> @@ -158,9 +158,13 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
>  	ring->access->store_to(indio_dev->ring, (u8 *) data, pf->timestamp);
>  
>  	iio_trigger_notify_done(indio_dev->trig);
> -	kfree(data);
>  
> +	kfree(data);
>  	return IRQ_HANDLED;
> +
> +err:
> +	kfree(data);
> +	return ret;
>  }
>  
>  void adis16400_unconfigure_ring(struct iio_dev *indio_dev)

