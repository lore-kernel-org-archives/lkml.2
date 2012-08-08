Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030946Ab2HHVNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:13:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030867Ab2HHVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:13:19 -0400
Date: Wed, 8 Aug 2012 18:13:12 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Misael Lopez Cruz <misael.lopez@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [ 017/109] ASoC: dapm: Fix locking during codec shutdown
Message-ID: <20120808211311.GA5654@herton-Z68MA-D2H-B3>
References: <20120807222043.089735600@linuxfoundation.org>
 <20120807222044.607925717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807222044.607925717@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 03:34:36PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Liam Girdwood <lrg@ti.com>
> 
> commit 01005a729a17ab419f61a366e22f3419e7a2c3fe upstream.
> 
> Codec shutdown performs a DAPM power sequence that might cause conflicts
> and/or race conditions if another stream power event is running simultaneously.
> Use card's dapm mutex to protect any potential race condition between them.
> 
> Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
> Signed-off-by: Liam Girdwood <lrg@ti.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  sound/soc/soc-dapm.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -3210,10 +3210,13 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_free);
>  
>  static void soc_dapm_shutdown_codec(struct snd_soc_dapm_context *dapm)
>  {
> +	struct snd_soc_card *card = dapm->card;
>  	struct snd_soc_dapm_widget *w;
>  	LIST_HEAD(down_list);
>  	int powerdown = 0;
>  
> +	mutex_lock(&card->dapm_mutex);
> +

Doesn't build on 3.4:

linux-stable/sound/soc/soc-dapm.c: In function 'soc_dapm_shutdown_codec':
linux-stable/sound/soc/soc-dapm.c:3226:18: error: 'struct snd_soc_card' has no member named 'dapm_mutex'
linux-stable/sound/soc/soc-dapm.c:3251:20: error: 'struct snd_soc_card' has no member named 'dapm_mutex'

It seems this patch should be dropped as when it was applied to 3.2, is
that correct?

>  	list_for_each_entry(w, &dapm->card->widgets, list) {
>  		if (w->dapm != dapm)
>  			continue;
> @@ -3236,6 +3239,8 @@ static void soc_dapm_shutdown_codec(stru
>  			snd_soc_dapm_set_bias_level(dapm,
>  						    SND_SOC_BIAS_STANDBY);
>  	}
> +
> +	mutex_unlock(&card->dapm_mutex);
>  }
>  
>  /*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
