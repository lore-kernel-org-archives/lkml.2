Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2L0LOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 06:14:49 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39510 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2L0LOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 06:14:46 -0500
Message-ID: <50DC2D9E.3030006@kernel.org>
Date: Thu, 27 Dec 2012 11:14:38 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: (max1363) Fix probe error path
References: <1356330298-11443-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1356330298-11443-1-git-send-email-linux@roeck-us.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2012 06:24 AM, Guenter Roeck wrote:
> Instantiating the driver with no available regulator results in:
> 
> [39711.686393] i2c i2c-7: new_device: Instantiated device max1139 at 0x35
> [39711.688687] BUG: unable to handle kernel paging request at fffffffffffffe13
> [39711.688734] IP: [<ffffffff813e835b>] regulator_disable+0x1b/0x80
> [39711.688788] PGD 1c0e067 PUD 1c0f067 PMD 0
> [39711.688835] Oops: 0000 [#1] SMP
> 
> Caused by bad probe error path. Fix it.
Oops.
> 
> Driver should also not attempt to free the interrupt in its error path if
> none was allocated. Fix that problem as well.
> 
> Finally, testing if the regulator was allocated is not necessary in the
> remove function, since the probe function bails out if this is the case.
> Remove that check.
> 
Thanks Guenter. Added to the fixes-togreg branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Might be the new year before I send Greg the pull request.

Jonathan

> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/iio/adc/max1363.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iio/adc/max1363.c b/drivers/iio/adc/max1363.c
> index 1e84b5b..31f3485 100644
> --- a/drivers/iio/adc/max1363.c
> +++ b/drivers/iio/adc/max1363.c
> @@ -1605,19 +1605,20 @@ static int __devinit max1363_probe(struct i2c_client *client,
>  
>  	return 0;
>  error_free_irq:
> -	free_irq(st->client->irq, indio_dev);
> +	if (client->irq)
> +		free_irq(st->client->irq, indio_dev);
>  error_uninit_buffer:
>  	iio_buffer_unregister(indio_dev);
>  error_cleanup_buffer:
>  	max1363_buffer_cleanup(indio_dev);
>  error_free_available_scan_masks:
>  	kfree(indio_dev->available_scan_masks);
> -error_unregister_map:
> -	iio_map_array_unregister(indio_dev, client->dev.platform_data);
>  error_disable_reg:
>  	regulator_disable(st->reg);
>  error_put_reg:
>  	regulator_put(st->reg);
> +error_unregister_map:
> +	iio_map_array_unregister(indio_dev, client->dev.platform_data);
>  error_free_device:
>  	iio_device_free(indio_dev);
>  error_out:
> @@ -1635,10 +1636,8 @@ static int __devexit max1363_remove(struct i2c_client *client)
>  	iio_buffer_unregister(indio_dev);
>  	max1363_buffer_cleanup(indio_dev);
>  	kfree(indio_dev->available_scan_masks);
> -	if (!IS_ERR(st->reg)) {
> -		regulator_disable(st->reg);
> -		regulator_put(st->reg);
> -	}
> +	regulator_disable(st->reg);
> +	regulator_put(st->reg);
>  	iio_map_array_unregister(indio_dev, client->dev.platform_data);
>  	iio_device_free(indio_dev);
>  
> 
