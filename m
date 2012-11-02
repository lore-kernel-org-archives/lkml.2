Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555Ab2KBJxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:53:05 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45230 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2KBJxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:53:02 -0400
Message-ID: <509397FD.6070400@kernel.org>
Date: Fri, 02 Nov 2012 09:53:01 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@cam.ac.uk,
        gregkh@linuxfoundation.org, lars@metafoo.de
Subject: Re: [PATCH] iio: isl29018: Support suspend and resume.
References: <1351121955-25788-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1351121955-25788-1-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 12:39 AM, Bryan Freed wrote:
> The driver leaves the device in power-down state anyway,
> so there is nothing to do on suspend.
> On resume, we just have to make sure the range and ADC
> values are updated in the device since it may have been
> powered down in suspend.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
Added to togreg branch of iio.git
though the various uses of power down in the description had
me scratching my head for a second.

I'm guessing auto power-down means the chip is locally disabled
but in suspend it's possible the power supply will be cut
to the chip rather than it simply powering down internally...
> ---
>  drivers/staging/iio/light/isl29018.c |   45 ++++++++++++++++++++++++++++++++++
>  1 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index 6ee5567..3b03f6f 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -67,6 +67,7 @@ struct isl29018_chip {
>  	unsigned int		range;
>  	unsigned int		adc_bit;
>  	int			prox_scheme;
> +	bool			suspended;
>  };
>  
>  static int isl29018_set_range(struct isl29018_chip *chip, unsigned long range,
> @@ -368,6 +369,10 @@ static int isl29018_read_raw(struct iio_dev *indio_dev,
>  	struct isl29018_chip *chip = iio_priv(indio_dev);
>  
>  	mutex_lock(&chip->lock);
> +	if (chip->suspended) {
> +		mutex_unlock(&chip->lock);
> +		return -EBUSY;
> +	}
>  	switch (mask) {
>  	case IIO_CHAN_INFO_RAW:
>  	case IIO_CHAN_INFO_PROCESSED:
> @@ -561,6 +566,7 @@ static int __devinit isl29018_probe(struct i2c_client *client,
>  	chip->lux_scale = 1;
>  	chip->range = 1000;
>  	chip->adc_bit = 16;
> +	chip->suspended = false;
>  
>  	chip->regmap = devm_regmap_init_i2c(client, &isl29018_regmap_config);
>  	if (IS_ERR(chip->regmap)) {
> @@ -603,6 +609,44 @@ static int __devexit isl29018_remove(struct i2c_client *client)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int isl29018_suspend(struct device *dev)
> +{
> +	struct isl29018_chip *chip = iio_priv(dev_get_drvdata(dev));
> +
> +	mutex_lock(&chip->lock);
> +
> +	/* Since this driver uses only polling commands, we are by default in
> +	 * auto shutdown (ie, power-down) mode.
> +	 * So we do not have much to do here.
> +	 */
> +	chip->suspended = true;
> +
> +	mutex_unlock(&chip->lock);
> +	return 0;
> +}
> +
> +static int isl29018_resume(struct device *dev)
> +{
> +	struct isl29018_chip *chip = iio_priv(dev_get_drvdata(dev));
> +	int err;
> +
> +	mutex_lock(&chip->lock);
> +
> +	err = isl29018_chip_init(chip);
> +	if (!err)
> +		chip->suspended = false;
> +
> +	mutex_unlock(&chip->lock);
> +	return err;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(isl29018_pm_ops, isl29018_suspend, isl29018_resume);
> +#define ISL29018_PM_OPS (&isl29018_pm_ops)
> +#else
> +#define ISL29018_PM_OPS NULL
> +#endif
> +
>  static const struct i2c_device_id isl29018_id[] = {
>  	{"isl29018", 0},
>  	{}
> @@ -620,6 +664,7 @@ static struct i2c_driver isl29018_driver = {
>  	.class	= I2C_CLASS_HWMON,
>  	.driver	 = {
>  			.name = "isl29018",
> +			.pm = ISL29018_PM_OPS,
>  			.owner = THIS_MODULE,
>  			.of_match_table = isl29018_of_match,
>  		    },
> 
