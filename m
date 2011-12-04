Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1LDRXN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 12:23:13 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:50544 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1LDRXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 12:23:12 -0500
Message-ID: <4EDBAC7F.50001@kernel.org>
Date: Sun, 04 Dec 2011 17:23:11 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: jbrenner@taosinc.com, linux-iio@vger.kernel.org, jic23@cam.ac.uk,
        gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: light sensor: Improve granularity of tsl2583
 lux values.
References: <1322864370-15126-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1322864370-15126-1-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 10:19 PM, Bryan Freed wrote:
> When illuminance0_calibbias gets 4000 (for a 4x multiplier), we see lux
> granularity of 4.  Reversing the order of the right shift and multiplication
> retains the precision of the unadjusted lux value.
Looks sensible to me, but having said that, Greg, please leave a little
while for Jon Brenner to get to it as he clearly knows this driver
a lot better than me!
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/staging/iio/light/tsl2583.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
> index 80f77cf..25f4c1d 100644
> --- a/drivers/staging/iio/light/tsl2583.c
> +++ b/drivers/staging/iio/light/tsl2583.c
> @@ -194,6 +194,7 @@ static int taos_get_lux(struct iio_dev *indio_dev)
>  {
>  	u16 ch0, ch1; /* separated ch0/ch1 data from device */
>  	u32 lux; /* raw lux calculated from device data */
> +	u64 lux64;
>  	u32 ratio;
>  	u8 buf[5];
>  	struct taos_lux *p;
> @@ -297,9 +298,19 @@ static int taos_get_lux(struct iio_dev *indio_dev)
>  		lux = (lux + (chip->als_time_scale >> 1)) /
>  			chip->als_time_scale;
>  
> -	/* adjust for active gain scale */
> -	lux >>= 13; /* tables have factor of 8192 builtin for accuracy */
> -	lux = (lux * chip->taos_settings.als_gain_trim + 500) / 1000;
> +	/* Adjust for active gain scale.
> +	 * The taos_device_lux tables above have a factor of 8192 built in,
> +	 * so we need to shift right.
> +	 * User-specified gain provides a multiplier.
> +	 * Apply user-specified gain before shifting right to retain precision.
> +	 * Use 64 bits to avoid overflow on multiplication.
> +	 * Then go back to 32 bits before division to avoid using div_u64().
> +	 */
> +	lux64 = lux;
> +	lux64 = lux64 * chip->taos_settings.als_gain_trim;
> +	lux64 >>= 13;
> +	lux = lux64;
> +	lux = (lux + 500) / 1000;
>  	if (lux > TSL258X_LUX_CALC_OVER_FLOW) { /* check for overflow */
>  return_max:
>  		lux = TSL258X_LUX_CALC_OVER_FLOW;

