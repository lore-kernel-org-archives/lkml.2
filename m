Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934740Ab0HDUTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:19:45 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:46790 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab0HDUTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:19:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C59CBA9.1030808@jic23.retrosnub.co.uk>
Date: Wed, 04 Aug 2010 21:20:57 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100802 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/iio: call mutex_unlock in error handling
 code
References: <Pine.LNX.4.64.1008042153460.30592@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008042153460.30592@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/10 20:54, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
Youch bad reviewing on my part.

Had a quick look and I think you caught all instances of this...

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Adjust the error handling code so that it benefits from the call to
> mutex_unlock at the end of the function.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @rcu exists@
> position p1;
> expression E;
> @@
> 
> mutex_lock@p1(E);
> ...
> mutex_unlock(E);
> 
> @exists@
> position rcu.p1;
> expression E;
> @@
> 
> *mutex_lock@p1(E);
> ... when != mutex_unlock(E);
> ?*return ...;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/staging/iio/magnetometer/hmc5843.c     |   25 +++++++++++++------
>  1 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
> index 92f6c6f..ea5f749 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843.c
> @@ -220,11 +220,15 @@ static ssize_t hmc5843_set_operating_mode(struct device *dev,
>  	int error;
>  	mutex_lock(&data->lock);
>  	error = strict_strtoul(buf, 10, &operating_mode);
> -	if (error)
> -		return error;
> +	if (error) {
> +		count = error;
> +		goto exit;
> +	}
>  	dev_dbg(dev, "set Conversion mode to %lu\n", operating_mode);
> -	if (operating_mode > MODE_SLEEP)
> -			return -EINVAL;
> +	if (operating_mode > MODE_SLEEP) {
> +		count = -EINVAL;
> +		goto exit;
> +	}
>  
>  	status = i2c_smbus_write_byte_data(client, this_attr->address,
>  					operating_mode);
> @@ -437,18 +441,23 @@ static ssize_t set_range(struct device *dev,
>  	int error;
>  	mutex_lock(&data->lock);
>  	error = strict_strtoul(buf, 10, &range);
> -	if (error)
> -		return error;
> +	if (error) {
> +		count = error;
> +		goto exit;
> +	}
>  	dev_dbg(dev, "set range to %lu\n", range);
>  
> -	if (range > RANGE_6_5)
> -		return -EINVAL;
> +	if (range > RANGE_6_5) {
> +		count = -EINVAL;
> +		goto exit;
> +	}
>  
>  	data->range = range;
>  	range = range << RANGE_GAIN_OFFSET;
>  	if (i2c_smbus_write_byte_data(client, this_attr->address, range))
>  		count = -EINVAL;
>  
> +exit:
>  	mutex_unlock(&data->lock);
>  	return count;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

