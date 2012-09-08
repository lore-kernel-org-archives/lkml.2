Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2IHJ3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 05:29:50 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:46957 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2IHJ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 05:29:05 -0400
Message-ID: <504B0FDF.70004@kernel.org>
Date: Sat, 08 Sep 2012 10:29:03 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        grundler@chromium.org, ldewangan@nvidia.com, lars@metafoo.de,
        gregkh@linuxfoundation.org, jic23@cam.ac.uk
Subject: Re: [PATCH] iio: isl29018: Support fractional ALS scaling.
References: <1346874953-22353-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1346874953-22353-1-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 08:55 PM, Bryan Freed wrote:
> The Industrial IO framework supports scaling ADC values by fractions,
> but most drivers default to using whole numbers.
> This change turns on fractional scaling in the isl29018 driver.
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>

add to togreg branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks

Technically doing integer + micro values is actually pretty common
but having calibration scale is less so. Doesn't seem any harm in doing
it here, though as calibscale is of an arbitary scaling itself, if it
wasn't an abi change (which this is not) then I'd suggest just doing it
as a 1000 * the original value.

Still this does the job nicely so thanks!

Jonathan
> ---
>  drivers/staging/iio/light/isl29018.c |   17 +++++++++++++++--
>  1 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
> index 31d22f5..6ee5567 100644
> --- a/drivers/staging/iio/light/isl29018.c
> +++ b/drivers/staging/iio/light/isl29018.c
> @@ -63,6 +63,7 @@ struct isl29018_chip {
>  	struct regmap		*regmap;
>  	struct mutex		lock;
>  	unsigned int		lux_scale;
> +	unsigned int		lux_uscale;
>  	unsigned int		range;
>  	unsigned int		adc_bit;
>  	int			prox_scheme;
> @@ -145,13 +146,22 @@ static int isl29018_read_sensor_input(struct isl29018_chip *chip, int mode)
>  static int isl29018_read_lux(struct isl29018_chip *chip, int *lux)
>  {
>  	int lux_data;
> +	unsigned int data_x_range, lux_unshifted;
>  
>  	lux_data = isl29018_read_sensor_input(chip, COMMMAND1_OPMODE_ALS_ONCE);
>  
>  	if (lux_data < 0)
>  		return lux_data;
>  
> -	*lux = (lux_data * chip->range * chip->lux_scale) >> chip->adc_bit;
> +	/* To support fractional scaling, separate the unshifted lux
> +	 * into two calculations: int scaling and micro-scaling.
> +	 * lux_uscale ranges from 0-999999, so about 20 bits.  Split
> +	 * the /1,000,000 in two to reduce the risk of over/underflow.
> +	 */
> +	data_x_range = lux_data * chip->range;
> +	lux_unshifted = data_x_range * chip->lux_scale;
> +	lux_unshifted += data_x_range / 1000 * chip->lux_uscale / 1000;
> +	*lux = lux_unshifted >> chip->adc_bit;
>  
>  	return 0;
>  }
> @@ -339,6 +349,8 @@ static int isl29018_write_raw(struct iio_dev *indio_dev,
>  	mutex_lock(&chip->lock);
>  	if (mask == IIO_CHAN_INFO_CALIBSCALE && chan->type == IIO_LIGHT) {
>  		chip->lux_scale = val;
> +		/* With no write_raw_get_fmt(), val2 is a MICRO fraction. */
> +		chip->lux_uscale = val2;
>  		ret = 0;
>  	}
>  	mutex_unlock(&chip->lock);
> @@ -379,7 +391,8 @@ static int isl29018_read_raw(struct iio_dev *indio_dev,
>  	case IIO_CHAN_INFO_CALIBSCALE:
>  		if (chan->type == IIO_LIGHT) {
>  			*val = chip->lux_scale;
> -			ret = IIO_VAL_INT;
> +			*val2 = chip->lux_uscale;
> +			ret = IIO_VAL_INT_PLUS_MICRO;
>  		}
>  		break;
>  	default:
> 
