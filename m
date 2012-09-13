Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab2IMP0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:26:38 -0400
Received: from smtp-out-028.synserver.de ([212.40.185.28]:1189 "EHLO
	smtp-out-028.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab2IMP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:26:33 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28363
Message-ID: <5051FB4D.3000009@metafoo.de>
Date: Thu, 13 Sep 2012 17:27:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: Re: [PATCH v2 03/15] dmaengine: Add no_wakeup parameter to dmaengine_prep_dma_cyclic()
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com> <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1347543485-339-4-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 03:37 PM, Peter Ujfalusi wrote:
> The dmaengine_prep_dma_cyclic() function primarily used by audio for cyclic
> transfer required by ALSA.
> With this new parameter it is going to be possible to enable the
> SNDRV_PCM_INFO_NO_PERIOD_WAKEUP mode on platforms where it is possible.
> This patch only changes the public API first. Followup patch will change
> the device_prep_dma_cyclic() callback parameters to pass this information
> towards the dma drivers.
> 

Hi,

Hm... Do you think it would work as well if we implement this by setting the
callback for the descriptor to NULL? If the callback is NULL there is
nothing to at the end of a transfer/period and the dma engine driver may
choose to disable interrupts. This would also benefit non cyclic transfers
where the callback is NULL and we do not need add the new parameter to
dmaengine_prep_dma_cyclic.

- Lars

> ---
>  include/linux/dmaengine.h     | 3 ++-
>  sound/soc/soc-dmaengine-pcm.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 9c02a45..990444b 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -653,7 +653,8 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_rio_sg(
>  
>  static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
>  		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
> -		size_t period_len, enum dma_transfer_direction dir)
> +		size_t period_len, enum dma_transfer_direction dir,
> +		bool no_wakeup)
>  {
>  	return chan->device->device_prep_dma_cyclic(chan, buf_addr, buf_len,
>  						period_len, dir, NULL);
> diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
> index 5df529e..6b70adb 100644
> --- a/sound/soc/soc-dmaengine-pcm.c
> +++ b/sound/soc/soc-dmaengine-pcm.c
> @@ -147,7 +147,8 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
>  	desc = dmaengine_prep_dma_cyclic(chan,
>  		substream->runtime->dma_addr,
>  		snd_pcm_lib_buffer_bytes(substream),
> -		snd_pcm_lib_period_bytes(substream), direction);
> +		snd_pcm_lib_period_bytes(substream), direction,
> +		substream->runtime->no_period_wakeup);
>  
>  	if (!desc)
>  		return -ENOMEM;

