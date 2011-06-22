Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1FVI71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:59:27 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:49997 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1FVI70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:59:26 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E01B0CE.4050400@cam.ac.uk>
Date: Wed, 22 Jun 2011 10:07:26 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, jbrenner@taosinc.com, gregkh@suse.de,
        arnd@arndb.de, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 2/3] light sensor: Fix a panic in the tsl2563 driver.
References: <1308696897-25161-1-git-send-email-bfreed@chromium.org> <1308696897-25161-2-git-send-email-bfreed@chromium.org>
In-Reply-To: <1308696897-25161-2-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Add a wrapper for this driver around the IIO_CHAN() wrapper to make channel
> parameters more readable.  This fixes a panic caused by the info_masks being
> accidentally passed in as channel2 parameters which easily surpass the size
> of the iio_modifier_names_light array.
Good change (particularly as it's my bug in the first place - oops!).

Thanks,
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

> ---
>  drivers/staging/iio/light/tsl2563.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
> index 04aa155..d9be19c 100644
> --- a/drivers/staging/iio/light/tsl2563.c
> +++ b/drivers/staging/iio/light/tsl2563.c
> @@ -570,15 +570,16 @@ error_ret:
>  	return ret;
>  }
>  
> +#define INFO_MASK (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE)
> +#define EVENT_MASK (IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) | \
> +		    IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING))
> +#define IIO_CHAN_2563(type, mod, proc, chan, imask, emask) \
> +	IIO_CHAN(type, mod, 1, proc, NULL, chan, 0, imask, 0, 0, {}, emask)
> +
>  static const struct iio_chan_spec tsl2563_channels[] = {
> -	IIO_CHAN(IIO_LIGHT, 0, 1, 1, NULL, 0, 0, 0, 0, 0, {}, 0),
> -	IIO_CHAN(IIO_INTENSITY, 1, 1, 0, "both", 0,
> -		 (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE), 0, 0, 0, {},
> -		 IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) |
> -		 IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)),
> -	IIO_CHAN(IIO_INTENSITY, 1, 1, 0, "ir", 1,
> -		 (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE), 0, 0, 0, {},
> -		 0)
> +	IIO_CHAN_2563(IIO_LIGHT,     0, 1, 0, 0, 0),
> +	IIO_CHAN_2563(IIO_INTENSITY, 1, 0, 0, INFO_MASK, EVENT_MASK),
> +	IIO_CHAN_2563(IIO_INTENSITY, 1, 0, 1, INFO_MASK, 0),
>  };
>  
>  static int tsl2563_read_thresh(struct iio_dev *indio_dev,

