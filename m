Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1E2K6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:58:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1E2K6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:58:32 -0400
Date: Sun, 29 May 2011 12:58:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Chew <achew@nvidia.com>
cc: mchehab@redhat.com, olof@lixom.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5 v2] [media] ov9740: Add suspend/resume
In-Reply-To: <1306368272-28279-5-git-send-email-achew@nvidia.com>
Message-ID: <Pine.LNX.4.64.1105291249220.18788@axis700.grange>
References: <1306368272-28279-1-git-send-email-achew@nvidia.com>
 <1306368272-28279-5-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:i4e3y3C7Bex9tl9P0K7CjZ7RPwwhIgj26t+oB9XqgX6
 DZUrY6cyTg14OwzDetSQQzpjY8058jSVDqiKEcWazs7p6uKnAQ
 U7UEOFpbqMdMmSjic7h0WArJiyMLlWoXTqDqbXYV9099J4WoEF
 wWvjqh86jYNU5FNhjzeOpZgoTpKooIWkHVU4rT2On9wP1ME05t
 Ayc1LqzEKQVHGY4W3ULO+W4SqMGw3tfM2arlSq1lvE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, achew@nvidia.com wrote:

> From: Andrew Chew <achew@nvidia.com>
> 
> On suspend, remember whether we are streaming or not, and at what frame format,
> so that on resume, we can start streaming again.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/media/video/ov9740.c |   39 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
> index 6c28ae8..4abe943 100644
> --- a/drivers/media/video/ov9740.c
> +++ b/drivers/media/video/ov9740.c
> @@ -201,6 +201,10 @@ struct ov9740_priv {
>  
>  	bool				flag_vflip;
>  	bool				flag_hflip;
> +
> +	/* For suspend/resume. */
> +	struct v4l2_mbus_framefmt	current_mf;
> +	int				current_enable;

bool?

>  };
>  
>  static const struct ov9740_reg ov9740_defaults[] = {
> @@ -551,6 +555,8 @@ static int ov9740_s_stream(struct v4l2_subdev *sd, int enable)
>  					       0x00);
>  	}
>  
> +	priv->current_enable = enable;
> +
>  	return ret;
>  }
>  
> @@ -786,6 +792,7 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>  			struct v4l2_mbus_framefmt *mf)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov9740_priv *priv = to_ov9740(sd);
>  	enum v4l2_colorspace cspace;
>  	enum v4l2_mbus_pixelcode code = mf->code;
>  	int ret;
> @@ -812,6 +819,8 @@ static int ov9740_s_fmt(struct v4l2_subdev *sd,
>  	mf->code	= code;
>  	mf->colorspace	= cspace;
>  
> +	memcpy(&priv->current_mf, mf, sizeof(struct v4l2_mbus_framefmt));
> +
>  	return ret;
>  }
>  
> @@ -922,7 +931,37 @@ err:
>  	return ret;
>  }
>  
> +static int ov9740_suspend(struct soc_camera_device *icd, pm_message_t state)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct ov9740_priv *priv = to_ov9740(sd);
> +
> +	if (priv->current_enable) {
> +		int current_enable = priv->current_enable;
> +
> +		ov9740_s_stream(sd, 0);
> +		priv->current_enable = current_enable;

You don't need the local variable, just set

	priv->current_enable = true;

> +	}
> +
> +	return 0;
> +}
> +
> +static int ov9740_resume(struct soc_camera_device *icd)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct ov9740_priv *priv = to_ov9740(sd);
> +
> +	if (priv->current_enable) {
> +		ov9740_s_fmt(sd, &priv->current_mf);
> +		ov9740_s_stream(sd, priv->current_enable);
> +	}
> +
> +	return 0;
> +}
> +
>  static struct soc_camera_ops ov9740_ops = {
> +	.suspend		= ov9740_suspend,
> +	.resume			= ov9740_resume,

No, we don't want to use these, whey should disappear some time... Please, 
use .s_power() from struct v4l2_subdev_core_ops, you can check 
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/33105 
for an example. If your host is not using these ops, it has to be fixed. 
So far in the mainline only one soc-camera host driver is using these 
callbacks: pxa_camera.c, which, looking at your email address, I doubt is 
the driver, that you're using;)

>  	.set_bus_param		= ov9740_set_bus_param,
>  	.query_bus_param	= ov9740_query_bus_param,
>  	.controls		= ov9740_controls,
> -- 
> 1.7.5.2
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
