Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab2FTNwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:52:21 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39591
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103Ab2FTNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:52:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 20 Jun 2012 21:48:01 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>, <alsa-devel@alsa-project.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        <linux-kernel@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [alsa-devel] [PATCH v2 3/3] ASoC: dmaengine-pcm: Add support
 for querying stream position from DMA driver
Message-ID: <20120620134800.GL10387@shlinux2.ap.freescale.net>
References: <1339438302-12417-1-git-send-email-lars@metafoo.de>
 <1339438302-12417-3-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1339438302-12417-3-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 08:11:42PM +0200, Lars-Peter Clausen wrote:
> Currently the sound dmaengine pcm helper functions implement the pcm_pointer
> callback by trying to count the number of elapsed periods. This is done by
> advancing the stream position in the dmaengine callback by one period.
> Unfortunately there is no guarantee that the callback will be called for each
> elapsed period. It may be possible that under high system load it is only called
> once for multiple elapsed periods. This patch addresses the issue by
> implementing support for querying the current stream position directly from the
> dmaengine driver. Since not all dmaengine drivers support reporting the stream
> position yet the old period counting implementation is kept for now.
> 
> Furthermore the new mechanism allows to report the stream position with a
> sub-period granularity, given that the dmaengine driver supports this.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> Changes since v1:
> 	* Don't implement fallback support in snd_dmaengine_pcm_pointer, instead it
> 	  is now moved to its own function. This was done to make it more explicit
> 	  that implementing residue reporting for cyclic is required and that this
> 	  won't be optional for new drivers.
> ---
>  include/sound/dmaengine_pcm.h |    1 +
>  sound/soc/soc-dmaengine-pcm.c |   29 ++++++++++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/include/sound/dmaengine_pcm.h b/include/sound/dmaengine_pcm.h
> index ea57915..b877334 100644
> --- a/include/sound/dmaengine_pcm.h
> +++ b/include/sound/dmaengine_pcm.h
> @@ -38,6 +38,7 @@ void *snd_dmaengine_pcm_get_data(struct snd_pcm_substream *substream);
>  int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
>  	const struct snd_pcm_hw_params *params, struct dma_slave_config *slave_config);
>  int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd);
> +snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream);
>  snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream *substream);
>  
>  int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
> diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
> index 7c0877e..2995334 100644
> --- a/sound/soc/soc-dmaengine-pcm.c
> +++ b/sound/soc/soc-dmaengine-pcm.c
> @@ -30,6 +30,7 @@
>  
>  struct dmaengine_pcm_runtime_data {
>  	struct dma_chan *dma_chan;
> +	dma_cookie_t cookie;
>  
>  	unsigned int pos;
>  
> @@ -153,7 +154,7 @@ static int dmaengine_pcm_prepare_and_submit(struct snd_pcm_substream *substream)
>  
>  	desc->callback = dmaengine_pcm_dma_complete;
>  	desc->callback_param = substream;
> -	dmaengine_submit(desc);
> +	prtd->cookie = dmaengine_submit(desc);
>  
>  	return 0;
>  }
> @@ -213,6 +214,32 @@ snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream
>  }
>  EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_pointer_no_residue);
>  
> +/**
> + * snd_dmaengine_pcm_pointer - dmaengine based PCM pointer implementation
> + * @substream: PCM substream
> + *
> + * This function can be used as the PCM pointer callback for dmaengine based PCM
> + * driver implementations.
> + */
> +snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream)
> +{
> +	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
> +	struct dma_tx_state state;
> +	enum dma_status status;
> +	unsigned int buf_size;
> +	unsigned int pos = 0;
> +
> +	status = dmaengine_tx_status(prtd->dma_chan, prtd->cookie, &state);
> +	if (status == DMA_IN_PROGRESS || status == DMA_PAUSED) {
> +		buf_size = snd_pcm_lib_buffer_bytes(substream);
> +		if (state.residue > 0 && state.residue <= buf_size)
> +			pos = buf_size - state.residue;
One question i still not very clear, for the case when one buffer size of cyclic dma
transfer completes, the dma residue may be buf_size( or 0 as Russell said), then
pos here is 0. So is it correct that call bytes_to_frames(substream->runtime, 0)
for this case?

Regards
Dong Aisheng

