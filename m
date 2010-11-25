Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0KYIGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:06:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0KYIGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dr+vEaroDsWmw3PuoVktTZVKu7pnwkyQAMFt5mKVidG+XzwRfM1so4U4m0ieX1tPL8
         RShN3D7743EgvFtcrDQvq6yxC8hfC4XFTo4o98SSwVi1kbypnlT1nKu/gDoi5Tm3Lwqb
         Vvdxj0wVJTXHifqYIGz7piH2WgHnVk4igoIZw=
Date: Thu, 25 Nov 2010 10:06:04 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 6/8] ASoC: simone: fix resource leak in simone_init
	error path
Message-ID: <20101125080604.GL14080@gw.healthdatacare.com>
References: <1290668785.30158.7.camel@mola> <1290669150.30158.18.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290669150.30158.18.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:12:30PM +0800, Axel Lin wrote:
> Fix the error path to properly free allocated resources.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mika Westerberg <mika.westerberg@iki.fi>

Thanks for catching this.

> ---
>  sound/soc/ep93xx/simone.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/sound/soc/ep93xx/simone.c b/sound/soc/ep93xx/simone.c
> index 4b0d199..2868179 100644
> --- a/sound/soc/ep93xx/simone.c
> +++ b/sound/soc/ep93xx/simone.c
> @@ -54,24 +54,26 @@ static int __init simone_init(void)
>  
>  	ret = platform_device_add(simone_snd_ac97_device);
>  	if (ret)
> -		goto fail;
> +		goto fail1;
>  
>  	simone_snd_device = platform_device_alloc("soc-audio", -1);
>  	if (!simone_snd_device) {
>  		ret = -ENOMEM;
> -		goto fail;
> +		goto fail2;
>  	}
>  
>  	platform_set_drvdata(simone_snd_device, &snd_soc_simone);
>  	ret = platform_device_add(simone_snd_device);
> -	if (ret) {
> -		platform_device_put(simone_snd_device);
> -		goto fail;
> -	}
> +	if (ret)
> +		goto fail3;
>  
> -	return ret;
> +	return 0;
>  
> -fail:
> +fail3:
> +	platform_device_put(simone_snd_device);
> +fail2:
> +	platform_device_del(simone_snd_ac97_device);
> +fail1:
>  	platform_device_put(simone_snd_ac97_device);
>  	return ret;
>  }
> -- 
> 1.7.2
> 
> 
