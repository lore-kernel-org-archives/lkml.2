Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab2AKIgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:36:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52364 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2AKIgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:36:37 -0500
Date: Wed, 11 Jan 2012 09:36:34 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michael Thalmeier <michael.thalmeier@hale.at>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, michael@thalmeier.at
Subject: Re: [PATCH] input/mc13783-ts: add pdata to set conversion delay
Message-ID: <20120111083634.GL14252@pengutronix.de>
References: <1326269903-22180-1-git-send-email-michael.thalmeier@hale.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326269903-22180-1-git-send-email-michael.thalmeier@hale.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Wed, Jan 11, 2012 at 09:18:23AM +0100, Michael Thalmeier wrote:
> MC13783 can be programmed to wait some clock cycles between the touch screen
> polarization and the resistance conversion. This is needed to adjust for
> touchscreens with high capacitance between plates.
> 
> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
> ---
>  drivers/hwmon/mc13783-adc.c            |    2 +-
>  drivers/input/touchscreen/mc13783_ts.c |    6 +++++-
>  drivers/mfd/mc13xxx-core.c             |   11 +++++++++--
>  include/linux/mfd/mc13xxx.h            |   16 +++++++++++++++-
>  4 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
> index ef65ab5..6acd044 100644
> --- a/drivers/hwmon/mc13783-adc.c
> +++ b/drivers/hwmon/mc13783-adc.c
> @@ -53,7 +53,7 @@ static int mc13783_adc_read(struct device *dev,
>  
>  	ret = mc13xxx_adc_do_conversion(priv->mc13xxx,
>  			MC13XXX_ADC_MODE_MULT_CHAN,
> -			channel, sample);
> +			channel, 0, 0, sample);
>  	if (ret)
>  		return ret;
>  
> diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
> index 68f86f7..d71f45a 100644
> --- a/drivers/input/touchscreen/mc13783_ts.c
> +++ b/drivers/input/touchscreen/mc13783_ts.c
> @@ -39,6 +39,7 @@ struct mc13783_ts_priv {
>  	struct delayed_work work;
>  	struct workqueue_struct *workq;
>  	unsigned int sample[4];
> +	struct mc13xxx_ts_platform_data *touch;
>  };
>  
>  static irqreturn_t mc13783_ts_handler(int irq, void *data)
> @@ -125,7 +126,9 @@ static void mc13783_ts_work(struct work_struct *work)
>  	unsigned int channel = 12;
>  
>  	if (mc13xxx_adc_do_conversion(priv->mc13xxx,
> -				mode, channel, priv->sample) == 0)
> +				mode, channel,
> +				priv->touch->ato, priv->touch->atox,
> +				priv->sample) == 0)
>  		mc13783_ts_report_sample(priv);
>  }
>  
> @@ -179,6 +182,7 @@ static int __init mc13783_ts_probe(struct platform_device *pdev)
>  	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
>  	priv->mc13xxx = dev_get_drvdata(pdev->dev.parent);
>  	priv->idev = idev;
> +	priv->touch = dev_get_platdata(&pdev->dev);
This cannot fail in practice unless the device isn't created via
mc13xxx_probe. Still it would feel a tad better to have error detection
here or at least a comment saying why it doesn't fail.

Other than that:
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
