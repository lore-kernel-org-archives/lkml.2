Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1IAI55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:57:57 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:52638 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab1IAI5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:57:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E5F4AFE.5020800@cam.ac.uk>
Date: Thu, 01 Sep 2011 10:06:06 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Russell King <linux@arm.linux.org.uk>,
        Andrew Chew <achew@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/3] staging:iio:magnetometer:ak8975: Don't assume 0 is
 an invalid GPIO
References: <1314819657-828-1-git-send-email-swarren@nvidia.com> <1314819657-828-2-git-send-email-swarren@nvidia.com>
In-Reply-To: <1314819657-828-2-git-send-email-swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/11 20:40, Stephen Warren wrote:
> gpio_is_valid() is the defined mechanism to determine whether a GPIO is
> valid. Use this instead of assuming that 0 is an invalid GPIO.
> 
Greg, depending on merge order you will get some fuzz between this and something
in my tree.

> Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/magnetometer/ak8975.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
> index bd40e32..79ed183 100644
> --- a/drivers/staging/iio/magnetometer/ak8975.c
> +++ b/drivers/staging/iio/magnetometer/ak8975.c
> @@ -373,7 +373,7 @@ static int ak8975_read_axis(struct iio_dev *indio_dev, int index, int *val)
>  	}
>  
>  	/* Wait for the conversion to complete. */
> -	if (data->eoc_gpio)
> +	if (gpio_is_valid(data->eoc_gpio))
>  		ret = wait_conversion_complete_gpio(data);
>  	else
>  		ret = wait_conversion_complete_polled(data);
> @@ -481,7 +481,7 @@ static int ak8975_probe(struct i2c_client *client,
>  
>  	/* We may not have a GPIO based IRQ to scan, that is fine, we will
>  	   poll if so */
> -	if (eoc_gpio > 0) {
> +	if (gpio_is_valid(eoc_gpio)) {
>  		err = gpio_request(eoc_gpio, "ak_8975");
>  		if (err < 0) {
>  			dev_err(&client->dev,
> @@ -497,8 +497,7 @@ static int ak8975_probe(struct i2c_client *client,
>  						eoc_gpio, err);
>  			goto exit_gpio;
>  		}
> -	} else
> -		eoc_gpio = 0;	/* No GPIO available */
> +	}
>  
>  	/* Register with IIO */
>  	indio_dev = iio_allocate_device(sizeof(*data));
> @@ -534,7 +533,7 @@ static int ak8975_probe(struct i2c_client *client,
>  exit_free_iio:
>  	iio_free_device(indio_dev);
>  exit_gpio:
> -	if (eoc_gpio)
> +	if (gpio_is_valid(eoc_gpio))
>  		gpio_free(eoc_gpio);
>  exit:
>  	return err;
> @@ -549,7 +548,7 @@ static int ak8975_remove(struct i2c_client *client)
>  	iio_device_unregister(indio_dev);
>  	iio_free_device(indio_dev);
>  
> -	if (eoc_gpio)
> +	if (gpio_is_valid(eoc_gpio))
>  		gpio_free(eoc_gpio);
>  
>  	return 0;

