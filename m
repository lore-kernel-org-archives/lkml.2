Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0LAR0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:26:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0LAR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:26:07 -0500
Date: Wed, 1 Dec 2010 18:26:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2] soc_camera: Add the ability to bind regulators to
 soc_camedra devices
In-Reply-To: <1291137176.6537.20.camel@realization>
Message-ID: <Pine.LNX.4.64.1012011803140.28110@axis700.grange>
References: <1291137176.6537.20.camel@realization>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:i/fM0S4CG+vVWoJ0FPCbmQI9vx5VuIHPDUQb5rE4X9c
 zTdLAdReSW3HMhUqH7RUzKCjKTC5jGy15ZkqT5Y1dhtvgmrMTh
 qetIt8AI469ksIcXmoZyWtM1YEEnTklHFKNQQ6mqypp4xyFAl8
 0oWD1g2s/0nOzNcAzIlqkpMTDI8NrjGVIl5NhNlrXTd5z6oT2N
 dLzRj6S66tXNbX7PNlDVUXglyX+kw+w3x12NFgt8/w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Alberto Panizzo wrote:

> In certain machines, camera devices are supplied directly
> by a number of regulators. This patch add the ability to drive
> these regulators directly by the soc_camera driver.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
> 
> v2 changes:
> It is used the more standard regulator_bulk API, thanks to
> Mark Brown for pointing this.
> 
>  drivers/media/video/soc_camera.c |   73 +++++++++++++++++++++++++++-----------
>  include/media/soc_camera.h       |    5 +++
>  2 files changed, 57 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 43848a7..f1c2094 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c

Have to

#include <linux/regulator/consumer.h>

here

> @@ -43,6 +43,41 @@ static LIST_HEAD(hosts);
>  static LIST_HEAD(devices);
>  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
>  
> +static int soc_camera_power_set(struct soc_camera_device *icd,
> +				struct soc_camera_link *icl,
> +				int power_on)
> +{
> +	int ret = 0;

"= 0" unneeded.

> +
> +	if (power_on) {
> +		ret = regulator_bulk_enable(icl->num_regulators,
> +					    icl->regulators);
> +	} else {
> +		ret = regulator_bulk_disable(icl->num_regulators,
> +					     icl->regulators);
> +	}

superfluous braces

> +	if (ret < 0) {
> +		dev_err(icd->pdev, "Cannot %s regulators",
> +			power_on ? "ENABLE" : "DISABLE");

why capitals?

> +		goto err;

just return ret

> +	}
> +
> +	if (icl->power) {
> +		ret = icl->power(icd->pdev, power_on);
> +		if (ret < 0) {
> +			dev_err(icd->pdev,
> +				"Platform failed to power %s the camera.\n",
> +				power_on ? "ON" : "OFF");

why capitals?

> +			goto err;

just return ret, although, if switching on failed, and the platform us 
also using regulators, don't you want to turn them off? Still I would do 
this here inline without a goto, but that's already a matter of taste, so, 
if you prefer, in this case a goto would be justified.

> +		}
> +	}
> +
> +	return 0;
> +
> +err:
> +	return ret;

with the above, this might go.

> +}
> +
>  const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
>  	struct soc_camera_device *icd, unsigned int fourcc)
>  {
> @@ -375,11 +410,9 @@ static int soc_camera_open(struct file *file)
>  			},
>  		};
>  
> -		if (icl->power) {
> -			ret = icl->power(icd->pdev, 1);
> -			if (ret < 0)
> -				goto epower;
> -		}
> +		ret = soc_camera_power_set(icd, icl, 1);
> +		if (ret < 0)
> +			goto epower;
>  
>  		/* The camera could have been already on, try to reset */
>  		if (icl->reset)
> @@ -425,8 +458,7 @@ esfmt:
>  eresume:
>  	ici->ops->remove(icd);
>  eiciadd:
> -	if (icl->power)
> -		icl->power(icd->pdev, 0);
> +	soc_camera_power_set(icd, icl, 0);
>  epower:
>  	icd->use_count--;
>  	mutex_unlock(&icd->video_lock);
> @@ -450,8 +482,7 @@ static int soc_camera_close(struct file *file)
>  
>  		ici->ops->remove(icd);
>  
> -		if (icl->power)
> -			icl->power(icd->pdev, 0);
> +		soc_camera_power_set(icd, icl, 0);
>  	}
>  
>  	if (icd->streamer == file)
> @@ -941,14 +972,14 @@ static int soc_camera_probe(struct device *dev)
>  
>  	dev_info(dev, "Probing %s\n", dev_name(dev));
>  
> -	if (icl->power) {
> -		ret = icl->power(icd->pdev, 1);
> -		if (ret < 0) {
> -			dev_err(dev,
> -				"Platform failed to power-on the camera.\n");
> -			goto epower;
> -		}
> -	}
> +	ret = regulator_bulk_get(icd->pdev, icl->num_regulators,
> +				 icl->regulators);
> +	if (ret)

"if (ret < 0)" for consistency, please

> +		goto epower;
> +
> +	ret = soc_camera_power_set(icd, icl, 1);
> +	if (ret < 0)
> +		goto epower;

You need a new label for this error - you also have to free regulators, if 
this fails.

>  
>  	/* The camera could have been already on, try to reset */
>  	if (icl->reset)
> @@ -1021,8 +1052,7 @@ static int soc_camera_probe(struct device *dev)
>  
>  	ici->ops->remove(icd);
>  
> -	if (icl->power)
> -		icl->power(icd->pdev, 0);
> +	soc_camera_power_set(icd, icl, 0);
>  
>  	mutex_unlock(&icd->video_lock);
>  
> @@ -1044,8 +1074,7 @@ eadddev:
>  evdc:
>  	ici->ops->remove(icd);
>  eadd:
> -	if (icl->power)
> -		icl->power(icd->pdev, 0);
> +	soc_camera_power_set(icd, icl, 0);
>  epower:
>  	return ret;
>  }
> @@ -1081,6 +1110,8 @@ static int soc_camera_remove(struct device *dev)
>  	}
>  	soc_camera_free_user_formats(icd);
>  
> +	regulator_bulk_free(icl->num_regulators, icl->regulators);
> +
>  	return 0;
>  }
>  
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 86e3631..3e6b903 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -15,6 +15,7 @@
>  #include <linux/device.h>
>  #include <linux/mutex.h>
>  #include <linux/pm.h>
> +#include <linux/regulator/consumer.h>

No need to include the header here, just declare

struct regulator_bulk_data;

>  #include <linux/videodev2.h>
>  #include <media/videobuf-core.h>
>  #include <media/v4l2-device.h>
> @@ -108,6 +109,10 @@ struct soc_camera_link {
>  	const char *module_name;
>  	void *priv;
>  
> +	/* Optional regulators that have to be managed on power on/off events */
> +	struct regulator_bulk_data *regulators;
> +	int num_regulators;
> +
>  	/*
>  	 * For non-I2C devices platform platform has to provide methods to
>  	 * add a device to the system and to remove
> -- 
> 1.6.3.3

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
