Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2F1LFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:05:52 -0400
Received: from smtp-out-130.synserver.de ([212.40.185.130]:1242 "EHLO
	smtp-out-120.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753967Ab2F1LFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:05:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20266
Message-ID: <4FEC3B70.5030902@metafoo.de>
Date: Thu, 28 Jun 2012 13:09:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: perex@perex.cz, broonie@opensource.wolfsonmicro.com, tiwai@suse.de,
        lrg@ti.com, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH] ASoC: snd_dmaengine: add common api for pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:01 AM, Laxman Dewangan wrote:
> The pcm mmap for the substream dma buffer is done using the
> dma_mmap_writecombine().
> Some of the chip sound driver like Spear, Tegra, Davinci,
> ep93xx,snd_imx, snd_mxs, NUC900, OMAP, Samsung are doing this
> mapping locally.
> Add api in the snd dmaengine driver so that different client of
> snd dmaengine can use this rather than implementing locally.
> 

This is not really related to the dmaengine pcm driver. It's more of a
coincidence that all upstream drivers which use the dmaengine pcm driver
also use write-combined memory. In my opinion it would be better to add this
to the ALSA core. Now that there is a generic dma_mmap_writecombine it may
make sense to integrate this with snd_pcm_lib_default_mmap.

- Lars

> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  include/sound/dmaengine_pcm.h |    2 ++
>  sound/soc/soc-dmaengine-pcm.c |   17 +++++++++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/include/sound/dmaengine_pcm.h b/include/sound/dmaengine_pcm.h
> index b877334..15c0d3c 100644
> --- a/include/sound/dmaengine_pcm.h
> +++ b/include/sound/dmaengine_pcm.h
> @@ -47,4 +47,6 @@ int snd_dmaengine_pcm_close(struct snd_pcm_substream *substream);
>  
>  struct dma_chan *snd_dmaengine_pcm_get_chan(struct snd_pcm_substream *substream);
>  
> +int snd_dmaengine_pcm_mmap_writecombine(struct snd_pcm_substream *substream,
> +		struct vm_area_struct *vma);
>  #endif
> diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
> index 5df529e..6535eb3 100644
> --- a/sound/soc/soc-dmaengine-pcm.c
> +++ b/sound/soc/soc-dmaengine-pcm.c
> @@ -21,6 +21,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/slab.h>
>  #include <sound/pcm.h>
>  #include <sound/pcm_params.h>
> @@ -313,3 +314,19 @@ int snd_dmaengine_pcm_close(struct snd_pcm_substream *substream)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_close);
> +
> +/**
> + * snd_dmaengine_pcm_mmap_writecombine - mmap stream dma buffer using
> + * dma_mmap_writecombine().
> + * @substream: PCM substream
> + * @vma: VM area.
> + */
> +int snd_dmaengine_pcm_mmap_writecombine(struct snd_pcm_substream *substream,
> +			struct vm_area_struct *vma)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +
> +	return dma_mmap_writecombine(substream->pcm->card->dev, vma,
> +		runtime->dma_area, runtime->dma_addr, runtime->dma_bytes);
> +}
> +EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_mmap_writecombine);

