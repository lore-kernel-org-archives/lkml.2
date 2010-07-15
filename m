Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab0GOIxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 04:53:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:50864 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932652Ab0GOIxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 04:53:10 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18zDghs4+UzggTvmjfUjd2gg1+xWP4MmDinj94Qpg
	nXHXF/1yxwSGeO
Date: Thu, 15 Jul 2010 10:53:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Axel Lin <axel.lin@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 11/12] wm8978: fix a memory leak if another WM8978 is
 registered
In-Reply-To: <1279183026.10733.2.camel@mola>
Message-ID: <Pine.LNX.4.64.1007151052120.5310@axis700.grange>
References: <1279162147.29294.2.camel@mola> <1279163338.29294.30.camel@mola>
 <1279183026.10733.2.camel@mola>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Axel Lin wrote:

> >>From e53ff15ee6843d6591509f9aeeb2fa1a0c1eccee Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Thu, 15 Jul 2010 16:33:20 +0800
> Subject: [PATCH] wm8978: fix a memory leak if a wm8978_register fail
> 
> There is a memory leak found if wm8978_register() fail.
> This patch moves the buffer allocate and release
> at the same level to prevent the memory leak.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks for the patch, Axel! Only compile-tested, so, here's 

Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Guennadi

> ---
>  sound/soc/codecs/wm8978.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
> index 51d5f43..8a1ad77 100644
> --- a/sound/soc/codecs/wm8978.c
> +++ b/sound/soc/codecs/wm8978.c
> @@ -1076,7 +1076,6 @@ static __devinit int wm8978_register(struct wm8978_priv *wm8978)
>  err_codec:
>  	snd_soc_unregister_codec(codec);
>  err:
> -	kfree(wm8978);
>  	return ret;
>  }
>  
> @@ -1085,13 +1084,13 @@ static __devexit void wm8978_unregister(struct wm8978_priv *wm8978)
>  	wm8978_set_bias_level(&wm8978->codec, SND_SOC_BIAS_OFF);
>  	snd_soc_unregister_dai(&wm8978_dai);
>  	snd_soc_unregister_codec(&wm8978->codec);
> -	kfree(wm8978);
>  	wm8978_codec = NULL;
>  }
>  
>  static __devinit int wm8978_i2c_probe(struct i2c_client *i2c,
>  				      const struct i2c_device_id *id)
>  {
> +	int ret;
>  	struct wm8978_priv *wm8978;
>  	struct snd_soc_codec *codec;
>  
> @@ -1107,13 +1106,18 @@ static __devinit int wm8978_i2c_probe(struct i2c_client *i2c,
>  
>  	codec->dev = &i2c->dev;
>  
> -	return wm8978_register(wm8978);
> +	ret = wm8978_register(wm8978);
> +	if (ret < 0)
> +		kfree(wm8978);
> +
> +	return ret;
>  }
>  
>  static __devexit int wm8978_i2c_remove(struct i2c_client *client)
>  {
>  	struct wm8978_priv *wm8978 = i2c_get_clientdata(client);
>  	wm8978_unregister(wm8978);
> +	kfree(wm8978);
>  	return 0;
>  }
>  
> -- 
> 1.5.4.3
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
