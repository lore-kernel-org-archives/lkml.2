Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2GaQLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:11:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2GaQLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:11:07 -0400
Date: Tue, 31 Jul 2012 13:11:01 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Liam Girdwood <lrg@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [ 35/73] ASoC: dapm: Fix locking during codec shutdown
Message-ID: <20120731161100.GB3111@herton-Z68MA-D2H-B3>
References: <20120731044310.013763753@decadent.org.uk>
 <20120731044316.865191013@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731044316.865191013@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 05:43:45AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
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
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  sound/soc/soc-dapm.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> index 5be4f9a..114f2af 100644
> --- a/sound/soc/soc-dapm.c
> +++ b/sound/soc/soc-dapm.c
> @@ -3537,10 +3537,13 @@ EXPORT_SYMBOL_GPL(snd_soc_dapm_free);
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

Hi, this doesn't build on 3.2:

linux-stable/sound/soc/soc-dapm.c: In function 'soc_dapm_shutdown_codec':
linux-stable/sound/soc/soc-dapm.c:2982:18: error: 'struct snd_soc_card' has no member named 'dapm_mutex'
linux-stable/sound/soc/soc-dapm.c:3007:20: error: 'struct snd_soc_card' has no member named 'dapm_mutex'

Looking at it, I'm not sure the fix is needed on 3.2, and introducing
dapm_mutex would be several changes.

>  	list_for_each_entry(w, &dapm->card->widgets, list) {
>  		if (w->dapm != dapm)
>  			continue;
> @@ -3563,6 +3566,8 @@ static void soc_dapm_shutdown_codec(struct snd_soc_dapm_context *dapm)
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
