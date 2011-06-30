Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1F3BdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:33:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:34667 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1F3BdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:33:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,446,1304319600"; 
   d="scan'208";a="22133259"
Subject: Re: [PATCH 4/5] ASoC: atmel_ssc_dai/atmel-pcm: adapt to dmaengine
 usage
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <7fd26c605d5cfa422d0fc37a7b790fb9a837d7e3.1309368631.git.nicolas.ferre@atmel.com>
References: <1309370419-22810-1-git-send-email-nicolas.ferre@atmel.com>
	 <7fd26c605d5cfa422d0fc37a7b790fb9a837d7e3.1309368631.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 06:24:53 +0530
Message-ID: <1309395294.1536.18.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 20:00 +0200, Nicolas Ferre wrote:
> Change xfer_size name to apply to PDC and DMA aswell.
> Specify overrun bit in interrupt mask.
> Add dmaengine specific routines and replace PDC ones in
> pcm_ops if appropriate.
> Uses cyclic DMA API for queuing samples.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  sound/soc/atmel/atmel-pcm.c     |  382 +++++++++++++++++++++++++++++++++++---
>  sound/soc/atmel/atmel-pcm.h     |    4 +-
>  sound/soc/atmel/atmel_ssc_dai.c |   33 ++--
>  3 files changed, 373 insertions(+), 46 deletions(-)
> 
> diff --git a/sound/soc/atmel/atmel-pcm.c b/sound/soc/atmel/atmel-pcm.c
> index 51dde4e..fee6696 100644
> --- a/sound/soc/atmel/atmel-pcm.c
> +++ b/sound/soc/atmel/atmel-pcm.c
> @@ -37,6 +37,7 @@
>  #include <linux/slab.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/atmel_pdc.h>
> +#include <linux/dmaengine.h>
>  #include <linux/atmel-ssc.h>
>  
>  #include <sound/core.h>
> @@ -44,6 +45,8 @@
>  #include <sound/pcm_params.h>
>  #include <sound/soc.h>
>  
> +#include <mach/at_hdmac.h>
> +
>  #include "atmel-pcm.h"
>  
> 
> @@ -53,7 +56,7 @@
>  /* TODO: These values were taken from the AT91 platform driver, check
>   *	 them against real values for AT32
>   */
> -static const struct snd_pcm_hardware atmel_pcm_hardware = {
> +static const struct snd_pcm_hardware atmel_pcm_pdc_hardware = {
>  	.info			= SNDRV_PCM_INFO_MMAP |
>  				  SNDRV_PCM_INFO_MMAP_VALID |
>  				  SNDRV_PCM_INFO_INTERLEAVED |
> @@ -66,6 +69,22 @@ static const struct snd_pcm_hardware atmel_pcm_hardware = {
>  	.buffer_bytes_max	= 32 * 1024,
>  };
>  
> +static const struct snd_pcm_hardware atmel_pcm_dma_hardware = {
> +	.info			= SNDRV_PCM_INFO_MMAP |
> +				  SNDRV_PCM_INFO_MMAP_VALID |
> +				  SNDRV_PCM_INFO_INTERLEAVED |
> +				  SNDRV_PCM_INFO_RESUME |
> +				  SNDRV_PCM_INFO_PAUSE,
> +	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
> +	.period_bytes_min	= 256,		/* not too low to absorb DMA programming overhead */
> +	.period_bytes_max	= 2 * 0xffff,	/* if 2 bytes format */
> +	.periods_min		= 8,
> +	.periods_max		= 1024,		/* no limit */
> +	.buffer_bytes_max	= 64 * 1024,	/* 64KiB */
> +};
> +
> +static const struct snd_pcm_hardware *atmel_pcm_hardware;
> +
>  
>  /*--------------------------------------------------------------------------*\
>   * Data types
> @@ -77,12 +96,19 @@ struct atmel_runtime_data {
>  	size_t period_size;
>  
>  	dma_addr_t period_ptr;		/* physical address of next period */
> +	int periods;			/* period index of period_ptr */
>  
>  	/* PDC register save */
>  	u32 pdc_xpr_save;
>  	u32 pdc_xcr_save;
>  	u32 pdc_xnpr_save;
>  	u32 pdc_xncr_save;
> +
> +	/* dmaengine data */
> +	struct at_dma_slave atslave;
> +	struct dma_async_tx_descriptor *desc;
> +	dma_cookie_t cookie;
> +	struct dma_chan *dma_chan;
>  };
>  
> 
> @@ -94,7 +120,7 @@ static int atmel_pcm_preallocate_dma_buffer(struct snd_pcm *pcm,
>  {
>  	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
>  	struct snd_dma_buffer *buf = &substream->dma_buffer;
> -	size_t size = atmel_pcm_hardware.buffer_bytes_max;
> +	size_t size = atmel_pcm_hardware->buffer_bytes_max;
>  
>  	buf->dev.type = SNDRV_DMA_TYPE_DEV;
>  	buf->dev.dev = pcm->card->dev;
> @@ -116,7 +142,7 @@ static int atmel_pcm_preallocate_dma_buffer(struct snd_pcm *pcm,
>  /*--------------------------------------------------------------------------*\
>   * ISR
>  \*--------------------------------------------------------------------------*/
> -static void atmel_pcm_dma_irq(u32 ssc_sr,
> +static void atmel_pcm_pdc_irq(u32 ssc_sr,
>  	struct snd_pcm_substream *substream)
>  {
>  	struct atmel_runtime_data *prtd = substream->runtime->private_data;
> @@ -142,7 +168,7 @@ static void atmel_pcm_dma_irq(u32 ssc_sr,
>  		ssc_writex(params->ssc->regs, params->pdc->xpr,
>  			   prtd->period_ptr);
>  		ssc_writex(params->ssc->regs, params->pdc->xcr,
> -			   prtd->period_size / params->pdc_xfer_size);
> +			   prtd->period_size / params->data_xfer_size);
>  		ssc_writex(params->ssc->regs, ATMEL_PDC_PTCR,
>  			   params->mask->pdc_enable);
>  	}
> @@ -156,12 +182,163 @@ static void atmel_pcm_dma_irq(u32 ssc_sr,
>  		ssc_writex(params->ssc->regs, params->pdc->xnpr,
>  			   prtd->period_ptr);
>  		ssc_writex(params->ssc->regs, params->pdc->xncr,
> -			   prtd->period_size / params->pdc_xfer_size);
> +			   prtd->period_size / params->data_xfer_size);
>  	}
>  
>  	snd_pcm_period_elapsed(substream);
>  }
>  
> +/**
> + * atmel_pcm_dma_irq: SSC interrupt handler for DMAENGINE enabled SSC
> + *
> + * We use DMAENGINE to send/receive data to/from SSC so this ISR is only to
> + * check if any overrun occured.
> + */
> +static void atmel_pcm_dma_irq(u32 ssc_sr,
> +	struct snd_pcm_substream *substream)
> +{
> +	struct atmel_runtime_data *prtd = substream->runtime->private_data;
> +	struct atmel_pcm_dma_params *params = prtd->params;
> +
> +	if (ssc_sr & params->mask->ssc_error) {
> +		if (snd_pcm_running(substream))
> +			pr_warning("atmel-pcm: buffer %s on %s"
> +					" (SSC_SR=%#x)\n",
> +					substream->stream == SNDRV_PCM_STREAM_PLAYBACK
> +					? "underrun" : "overrun",
> +					params->name, ssc_sr);
> +
> +		/* stop RX and capture stream: will be enabled again at restart */
> +		ssc_writex(params->ssc->regs, SSC_CR, params->mask->ssc_disable);
> +		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
> +
> +		/* now drain RHR and read status to remove xrun condition */
> +		ssc_readx(params->ssc->regs, SSC_RHR);
> +		ssc_readx(params->ssc->regs, SSC_SR);
> +	}
> +}
> +
> +/*--------------------------------------------------------------------------*\
> + * DMAENGINE operations
> +\*--------------------------------------------------------------------------*/
> +static bool filter(struct dma_chan *chan, void *slave)
> +{
> +	struct	at_dma_slave		*sl = slave;
> +
> +	if (sl->dma_dev == chan->device->dev) {
> +		chan->private = sl;
Nope you dont want to do that, pls use dmaengine_slave_config() API for
setting this
> +		return true;
> +	} else {
> +		return false;
> +	}
> +}
> +
> +static int atmel_pcm_dma_alloc(struct snd_pcm_substream *substream,
> +	struct snd_pcm_hw_params *params)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct atmel_runtime_data *prtd = runtime->private_data;
> +	struct ssc_device *ssc = prtd->params->ssc;
> +	struct at_dma_slave *sdata = NULL;
> +
> +	if (ssc->pdev)
> +		sdata = ssc->pdev->dev.platform_data;
> +
> +	if (sdata && sdata->dma_dev) {
> +		dma_cap_mask_t mask;
> +
> +		/* setup DMA addresses */
> +		sdata->rx_reg = (dma_addr_t)ssc->phybase + SSC_RHR;
> +		sdata->tx_reg = (dma_addr_t)ssc->phybase + SSC_THR;
> +
> +		/* Try to grab a DMA channel */
> +		dma_cap_zero(mask);
> +		dma_cap_set(DMA_CYCLIC, mask);
> +		prtd->dma_chan = dma_request_channel(mask, filter, sdata);
> +	}
> +	if (!prtd->dma_chan) {
> +		pr_err("atmel-pcm: "
> +			"DMA channel not available, unable to use SSC-audio\n");
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +static void audio_dma_irq(void *data)
> +{
> +	struct snd_pcm_substream *substream = (struct snd_pcm_substream *)data;
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct atmel_runtime_data *prtd = runtime->private_data;
> +
> +	prtd->period_ptr += prtd->period_size;
> +	if (prtd->period_ptr >= prtd->dma_buffer_end)
> +		prtd->period_ptr = prtd->dma_buffer;
> +
> +	snd_pcm_period_elapsed(substream);
> +}
> +
> +static void atmel_pcm_dma_slave_config(struct snd_pcm_substream *substream)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct atmel_runtime_data *prtd = runtime->private_data;
> +	struct dma_chan *chan = prtd->dma_chan;
> +	struct dma_slave_config slave_config;
> +	enum dma_slave_buswidth buswidth;
> +
> +	switch (prtd->params->data_xfer_size) {
> +	case 1:
> +		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
> +		break;
> +	case 2:
> +		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
> +		break;
> +	case 4:
> +		buswidth = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
> +		slave_config.direction = DMA_TO_DEVICE;
> +		slave_config.dst_addr_width = buswidth;
> +	} else {
> +		slave_config.direction = DMA_FROM_DEVICE;
> +		slave_config.src_addr_width = buswidth;
> +	}
> +
> +	dmaengine_slave_config(chan, &slave_config);
okay, you seem to be doing right thing, then why are you setting the
chan->slave pointer??

> +}
> +
> +static int atmel_pcm_dma_prep(struct snd_pcm_substream *substream)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct atmel_runtime_data *prtd = runtime->private_data;
> +	struct dma_chan *chan = prtd->dma_chan;
> +
> +	if (prtd->desc)
> +		/* already been there: redo the prep job */
> +		dmaengine_terminate_all(chan);
> +
> +	/* setup dma configuration */
> +	atmel_pcm_dma_slave_config(substream);
Nope, this is channel config. As long as you retain the channel you
shouldn't be required to set this again.
> +
> +	prtd->desc = chan->device->device_prep_dma_cyclic(chan, prtd->dma_buffer,
> +			prtd->period_size * prtd->periods,
> +			prtd->period_size,
> +			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
> +			DMA_TO_DEVICE : DMA_FROM_DEVICE);
> +	if (!prtd->desc) {
> +		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
> +		return -EINVAL;
> +	}
> +
> +	prtd->desc->callback = audio_dma_irq;
> +	prtd->desc->callback_param = substream;
> +
> +	return 0;
> +}
>  
>  /*--------------------------------------------------------------------------*\
>   * PCM operations
> @@ -172,6 +349,7 @@ static int atmel_pcm_hw_params(struct snd_pcm_substream *substream,
>  	struct snd_pcm_runtime *runtime = substream->runtime;
>  	struct atmel_runtime_data *prtd = runtime->private_data;
>  	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	int ret;
>  
>  	/* this may get called several times by oss emulation
>  	 * with different params */
> @@ -180,15 +358,35 @@ static int atmel_pcm_hw_params(struct snd_pcm_substream *substream,
>  	runtime->dma_bytes = params_buffer_bytes(params);
>  
>  	prtd->params = snd_soc_dai_get_dma_data(rtd->cpu_dai, substream);
> -	prtd->params->dma_intr_handler = atmel_pcm_dma_irq;
>  
>  	prtd->dma_buffer = runtime->dma_addr;
>  	prtd->dma_buffer_end = runtime->dma_addr + runtime->dma_bytes;
>  	prtd->period_size = params_period_bytes(params);
> +	prtd->periods = params_periods(params);
> +
> +	if (ssc_use_dmaengine()) {
> +		if (prtd->dma_chan == NULL) {
> +			ret = atmel_pcm_dma_alloc(substream, params);
> +			if (ret)
> +				return ret;
> +		}
> +		ret = atmel_pcm_dma_prep(substream);
> +		if (ret) {
> +			dma_release_channel(prtd->dma_chan);
> +			prtd->dma_chan = NULL;
> +			return ret;
> +		}
> +
> +		prtd->params->dma_intr_handler = atmel_pcm_dma_irq;
> +	} else {
> +		prtd->params->dma_intr_handler = atmel_pcm_pdc_irq;
> +	}
>  
>  	pr_debug("atmel-pcm: "
> -		"hw_params: DMA for %s initialized "
> +		"hw_params: %s%s for %s initialized "
>  		"(dma_bytes=%u, period_size=%u)\n",
> +		prtd->dma_chan ? "DMA " : "PDC",
> +		prtd->dma_chan ? dma_chan_name(prtd->dma_chan): "",
>  		prtd->params->name,
>  		runtime->dma_bytes,
>  		prtd->period_size);
> @@ -201,15 +399,30 @@ static int atmel_pcm_hw_free(struct snd_pcm_substream *substream)
>  	struct atmel_pcm_dma_params *params = prtd->params;
>  
>  	if (params != NULL) {
> -		ssc_writex(params->ssc->regs, SSC_PDC_PTCR,
> -			   params->mask->pdc_disable);
> +		if (ssc_use_dmaengine()) {
> +			struct dma_chan *chan = prtd->dma_chan;
> +
> +			if (chan) {
> +				dmaengine_terminate_all(chan);
> +				prtd->cookie = 0;
> +				prtd->desc = NULL;
> +				dma_release_channel(chan);
> +				prtd->dma_chan = NULL;
> +			}
> +		} else {
> +			ssc_writex(params->ssc->regs, SSC_PDC_PTCR,
> +				   params->mask->pdc_disable);
> +		}
>  		prtd->params->dma_intr_handler = NULL;
>  	}
>  
>  	return 0;
>  }
>  
> -static int atmel_pcm_prepare(struct snd_pcm_substream *substream)
> +/*--------------------------------------------------------------------------*\
> + * PCM callbacks using PDC
> +\*--------------------------------------------------------------------------*/
> +static int atmel_pcm_pdc_prepare(struct snd_pcm_substream *substream)
>  {
>  	struct atmel_runtime_data *prtd = substream->runtime->private_data;
>  	struct atmel_pcm_dma_params *params = prtd->params;
> @@ -221,7 +434,7 @@ static int atmel_pcm_prepare(struct snd_pcm_substream *substream)
>  	return 0;
>  }
>  
> -static int atmel_pcm_trigger(struct snd_pcm_substream *substream,
> +static int atmel_pcm_pdc_trigger(struct snd_pcm_substream *substream,
>  	int cmd)
>  {
>  	struct snd_pcm_runtime *rtd = substream->runtime;
> @@ -240,13 +453,13 @@ static int atmel_pcm_trigger(struct snd_pcm_substream *substream,
>  		ssc_writex(params->ssc->regs, params->pdc->xpr,
>  			   prtd->period_ptr);
>  		ssc_writex(params->ssc->regs, params->pdc->xcr,
> -			   prtd->period_size / params->pdc_xfer_size);
> +			   prtd->period_size / params->data_xfer_size);
>  
>  		prtd->period_ptr += prtd->period_size;
>  		ssc_writex(params->ssc->regs, params->pdc->xnpr,
>  			   prtd->period_ptr);
>  		ssc_writex(params->ssc->regs, params->pdc->xncr,
> -			   prtd->period_size / params->pdc_xfer_size);
> +			   prtd->period_size / params->data_xfer_size);
>  
>  		pr_debug("atmel-pcm: trigger: "
>  			"period_ptr=%lx, xpr=%u, "
> @@ -264,7 +477,7 @@ static int atmel_pcm_trigger(struct snd_pcm_substream *substream,
>  
>  		pr_debug("sr=%u imr=%u\n",
>  			ssc_readx(params->ssc->regs, SSC_SR),
> -			ssc_readx(params->ssc->regs, SSC_IER));
> +			ssc_readx(params->ssc->regs, SSC_IMR));
>  		break;		/* SNDRV_PCM_TRIGGER_START */
>  
>  	case SNDRV_PCM_TRIGGER_STOP:
> @@ -287,7 +500,7 @@ static int atmel_pcm_trigger(struct snd_pcm_substream *substream,
>  	return ret;
>  }
>  
> -static snd_pcm_uframes_t atmel_pcm_pointer(
> +static snd_pcm_uframes_t atmel_pcm_pdc_pointer(
>  	struct snd_pcm_substream *substream)
>  {
>  	struct snd_pcm_runtime *runtime = substream->runtime;
> @@ -305,13 +518,107 @@ static snd_pcm_uframes_t atmel_pcm_pointer(
>  	return x;
>  }
>  
> +/*--------------------------------------------------------------------------*\
> + * PCM callbacks using DMAENGINE
> +\*--------------------------------------------------------------------------*/
> +static int atmel_pcm_dma_prepare(struct snd_pcm_substream *substream)
> +{
> +	struct atmel_runtime_data *prtd = substream->runtime->private_data;
> +	struct atmel_pcm_dma_params *params = prtd->params;
> +
> +	ssc_writex(params->ssc->regs, SSC_IDR, params->mask->ssc_error);
> +	return 0;
> +}
> +
> +static int atmel_pcm_dma_trigger(struct snd_pcm_substream *substream,
> +	int cmd)
> +{
> +	struct snd_pcm_runtime *rtd = substream->runtime;
> +	struct atmel_runtime_data *prtd = rtd->private_data;
> +	struct atmel_pcm_dma_params *params = prtd->params;
> +	dma_cookie_t cookie;
> +	int ret = 0;
> +
> +	pr_debug("atmel-pcm: trigger %d: buffer_size = %ld,"
> +		" dma_area = %p, dma_bytes = %u\n",
> +		cmd, rtd->buffer_size, rtd->dma_area, rtd->dma_bytes);
> +
> +	switch (cmd) {
> +	case SNDRV_PCM_TRIGGER_START:
> +
> +		if (prtd->cookie < DMA_MIN_COOKIE) {
> +			cookie = dmaengine_submit(prtd->desc);
submit and issue_pending as well...
> +			if (dma_submit_error(cookie)) {
> +				ret = -EINVAL;
> +				break;
> +			}
> +			prtd->cookie = cookie;
> +			prtd->period_ptr = prtd->dma_buffer;
> +		}
> +
> +
> +		pr_debug("atmel-pcm: trigger: start sr=0x%08x imr=0x%08u\n",
> +			ssc_readx(params->ssc->regs, SSC_SR),
> +			ssc_readx(params->ssc->regs, SSC_IMR));
> +
> +		/* fallback */
> +	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> +	case SNDRV_PCM_TRIGGER_RESUME:
> +		dmaengine_resume(prtd->dma_chan);
> +
> +		/* It not already done or comming from xrun state */
> +		ssc_readx(params->ssc->regs, SSC_SR);
> +		ssc_writex(params->ssc->regs, SSC_IER, params->mask->ssc_error);
> +		ssc_writex(params->ssc->regs, SSC_CR, params->mask->ssc_enable);
> +
> +		break;
> +	case SNDRV_PCM_TRIGGER_STOP:
> +		pr_debug("atmel-pcm: trigger: stop cmd = %d\n", cmd);
> +
> +		ssc_writex(params->ssc->regs, SSC_IDR, params->mask->ssc_error);
> +
> +		/* fallback */
> +	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> +	case SNDRV_PCM_TRIGGER_SUSPEND:
> +		dmaengine_pause(prtd->dma_chan);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static snd_pcm_uframes_t atmel_pcm_dma_pointer(
> +	struct snd_pcm_substream *substream)
> +{
> +	struct snd_pcm_runtime *runtime = substream->runtime;
> +	struct atmel_runtime_data *prtd = runtime->private_data;
> +	snd_pcm_uframes_t x;
> +
> +	dev_vdbg(substream->pcm->card->dev, "%s: 0x%08x %ld\n",
> +		__func__, prtd->period_ptr,
> +		bytes_to_frames(runtime, prtd->period_ptr - prtd->dma_buffer));
> +
> +	x = bytes_to_frames(runtime, prtd->period_ptr - prtd->dma_buffer);
> +
> +	if (x >= runtime->buffer_size)
> +		x = 0;
> +
> +	return x;
> +}
> +
> +
> +/*--------------------------------------------------------------------------*\
> + * PCM open/close/mmap
> +\*--------------------------------------------------------------------------*/
>  static int atmel_pcm_open(struct snd_pcm_substream *substream)
>  {
>  	struct snd_pcm_runtime *runtime = substream->runtime;
>  	struct atmel_runtime_data *prtd;
>  	int ret = 0;
>  
> -	snd_soc_set_runtime_hwparams(substream, &atmel_pcm_hardware);
> +	snd_soc_set_runtime_hwparams(substream, atmel_pcm_hardware);
>  
>  	/* ensure that buffer size is a multiple of period size */
>  	ret = snd_pcm_hw_constraint_integer(runtime,
> @@ -352,9 +659,9 @@ static struct snd_pcm_ops atmel_pcm_ops = {
>  	.ioctl		= snd_pcm_lib_ioctl,
>  	.hw_params	= atmel_pcm_hw_params,
>  	.hw_free	= atmel_pcm_hw_free,
> -	.prepare	= atmel_pcm_prepare,
> -	.trigger	= atmel_pcm_trigger,
> -	.pointer	= atmel_pcm_pointer,
> +	.prepare	= atmel_pcm_pdc_prepare,
> +	.trigger	= atmel_pcm_pdc_trigger,
> +	.pointer	= atmel_pcm_pdc_pointer,
>  	.mmap		= atmel_pcm_mmap,
>  };
>  
> @@ -426,14 +733,16 @@ static int atmel_pcm_suspend(struct snd_soc_dai *dai)
>  	prtd = runtime->private_data;
>  	params = prtd->params;
>  
> -	/* disable the PDC and save the PDC registers */
> +	if (!ssc_use_dmaengine()) {
> +		/* disable the PDC and save the PDC registers */
>  
> -	ssc_writel(params->ssc->regs, PDC_PTCR, params->mask->pdc_disable);
> +		ssc_writel(params->ssc->regs, PDC_PTCR, params->mask->pdc_disable);
>  
> -	prtd->pdc_xpr_save = ssc_readx(params->ssc->regs, params->pdc->xpr);
> -	prtd->pdc_xcr_save = ssc_readx(params->ssc->regs, params->pdc->xcr);
> -	prtd->pdc_xnpr_save = ssc_readx(params->ssc->regs, params->pdc->xnpr);
> -	prtd->pdc_xncr_save = ssc_readx(params->ssc->regs, params->pdc->xncr);
> +		prtd->pdc_xpr_save = ssc_readx(params->ssc->regs, params->pdc->xpr);
> +		prtd->pdc_xcr_save = ssc_readx(params->ssc->regs, params->pdc->xcr);
> +		prtd->pdc_xnpr_save = ssc_readx(params->ssc->regs, params->pdc->xnpr);
> +		prtd->pdc_xncr_save = ssc_readx(params->ssc->regs, params->pdc->xncr);
> +	}
>  
>  	return 0;
>  }
> @@ -450,13 +759,15 @@ static int atmel_pcm_resume(struct snd_soc_dai *dai)
>  	prtd = runtime->private_data;
>  	params = prtd->params;
>  
> -	/* restore the PDC registers and enable the PDC */
> -	ssc_writex(params->ssc->regs, params->pdc->xpr, prtd->pdc_xpr_save);
> -	ssc_writex(params->ssc->regs, params->pdc->xcr, prtd->pdc_xcr_save);
> -	ssc_writex(params->ssc->regs, params->pdc->xnpr, prtd->pdc_xnpr_save);
> -	ssc_writex(params->ssc->regs, params->pdc->xncr, prtd->pdc_xncr_save);
> +	if (!ssc_use_dmaengine()) {
> +		/* restore the PDC registers and enable the PDC */
> +		ssc_writex(params->ssc->regs, params->pdc->xpr, prtd->pdc_xpr_save);
> +		ssc_writex(params->ssc->regs, params->pdc->xcr, prtd->pdc_xcr_save);
> +		ssc_writex(params->ssc->regs, params->pdc->xnpr, prtd->pdc_xnpr_save);
> +		ssc_writex(params->ssc->regs, params->pdc->xncr, prtd->pdc_xncr_save);
>  
> -	ssc_writel(params->ssc->regs, PDC_PTCR, params->mask->pdc_enable);
> +		ssc_writel(params->ssc->regs, PDC_PTCR, params->mask->pdc_enable);
> +	}
>  	return 0;
>  }
>  #else
> @@ -495,6 +806,15 @@ static struct platform_driver atmel_pcm_driver = {
>  
>  static int __init snd_atmel_pcm_init(void)
>  {
> +	if (ssc_use_dmaengine()) {
> +		atmel_pcm_ops.prepare = atmel_pcm_dma_prepare;
> +		atmel_pcm_ops.trigger = atmel_pcm_dma_trigger;
> +		atmel_pcm_ops.pointer = atmel_pcm_dma_pointer;
> +
> +		atmel_pcm_hardware = &atmel_pcm_dma_hardware;
> +	} else {
> +		atmel_pcm_hardware = &atmel_pcm_pdc_hardware;
> +	}
>  	return platform_driver_register(&atmel_pcm_driver);
>  }
>  module_init(snd_atmel_pcm_init);
> diff --git a/sound/soc/atmel/atmel-pcm.h b/sound/soc/atmel/atmel-pcm.h
> index 5e0a95e..b007376 100644
> --- a/sound/soc/atmel/atmel-pcm.h
> +++ b/sound/soc/atmel/atmel-pcm.h
> @@ -50,6 +50,7 @@ struct atmel_pdc_regs {
>  struct atmel_ssc_mask {
>  	u32	ssc_enable;		/* SSC recv/trans enable */
>  	u32	ssc_disable;		/* SSC recv/trans disable */
> +	u32	ssc_error;		/* SSC error conditions */
>  	u32	ssc_endx;		/* SSC ENDTX or ENDRX */
>  	u32	ssc_endbuf;		/* SSC TXBUFE or RXBUFF */
>  	u32	pdc_enable;		/* PDC recv/trans enable */
> @@ -66,7 +67,8 @@ struct atmel_ssc_mask {
>   */
>  struct atmel_pcm_dma_params {
>  	char *name;			/* stream identifier */
> -	int pdc_xfer_size;		/* PDC counter increment in bytes */
> +	int data_xfer_size;		/* PDC counter increment in bytes,
> +					   DMA data transfer size in bytes */
>  	struct ssc_device *ssc;		/* SSC device for stream */
>  	struct atmel_pdc_regs *pdc;	/* PDC receive or transmit registers */
>  	struct atmel_ssc_mask *mask;	/* SSC & PDC status bits */
> diff --git a/sound/soc/atmel/atmel_ssc_dai.c b/sound/soc/atmel/atmel_ssc_dai.c
> index a7a7bbc..9412fc3 100644
> --- a/sound/soc/atmel/atmel_ssc_dai.c
> +++ b/sound/soc/atmel/atmel_ssc_dai.c
> @@ -48,7 +48,8 @@
>  #include "atmel_ssc_dai.h"
>  
> 
> -#if defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9G20)
> +#if defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9G20) \
> +	|| defined(CONFIG_ARCH_AT91SAM9X5)
>  #define NUM_SSC_DEVICES		1
>  #else
>  #define NUM_SSC_DEVICES		3
> @@ -86,6 +87,7 @@ static struct atmel_ssc_mask ssc_tx_mask = {
>  static struct atmel_ssc_mask ssc_rx_mask = {
>  	.ssc_enable	= SSC_BIT(CR_RXEN),
>  	.ssc_disable	= SSC_BIT(CR_RXDIS),
> +	.ssc_error	= SSC_BIT(SR_OVRUN),
>  	.ssc_endx	= SSC_BIT(SR_ENDRX),
>  	.ssc_endbuf	= SSC_BIT(SR_RXBUFF),
>  	.pdc_enable	= ATMEL_PDC_RXTEN,
> @@ -183,7 +185,8 @@ static irqreturn_t atmel_ssc_interrupt(int irq, void *dev_id)
>  		if ((dma_params != NULL) &&
>  			(dma_params->dma_intr_handler != NULL)) {
>  			ssc_substream_mask = (dma_params->mask->ssc_endx |
> -					dma_params->mask->ssc_endbuf);
> +					dma_params->mask->ssc_endbuf |
> +					dma_params->mask->ssc_error);
>  			if (ssc_sr & ssc_substream_mask) {
>  				dma_params->dma_intr_handler(ssc_sr,
>  						dma_params->
> @@ -376,19 +379,19 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
>  	switch (params_format(params)) {
>  	case SNDRV_PCM_FORMAT_S8:
>  		bits = 8;
> -		dma_params->pdc_xfer_size = 1;
> +		dma_params->data_xfer_size = 1;
>  		break;
>  	case SNDRV_PCM_FORMAT_S16_LE:
>  		bits = 16;
> -		dma_params->pdc_xfer_size = 2;
> +		dma_params->data_xfer_size = 2;
>  		break;
>  	case SNDRV_PCM_FORMAT_S24_LE:
>  		bits = 24;
> -		dma_params->pdc_xfer_size = 4;
> +		dma_params->data_xfer_size = 4;
>  		break;
>  	case SNDRV_PCM_FORMAT_S32_LE:
>  		bits = 32;
> -		dma_params->pdc_xfer_size = 4;
> +		dma_params->data_xfer_size = 4;
>  		break;
>  	default:
>  		printk(KERN_WARNING "atmel_ssc_dai: unsupported PCM format");
> @@ -561,15 +564,17 @@ static int atmel_ssc_hw_params(struct snd_pcm_substream *substream,
>  		/* Reset the SSC and its PDC registers */
>  		ssc_writel(ssc_p->ssc->regs, CR, SSC_BIT(CR_SWRST));
>  
> -		ssc_writel(ssc_p->ssc->regs, PDC_RPR, 0);
> -		ssc_writel(ssc_p->ssc->regs, PDC_RCR, 0);
> -		ssc_writel(ssc_p->ssc->regs, PDC_RNPR, 0);
> -		ssc_writel(ssc_p->ssc->regs, PDC_RNCR, 0);
> +		if (!ssc_use_dmaengine()) {
> +			ssc_writel(ssc_p->ssc->regs, PDC_RPR, 0);
> +			ssc_writel(ssc_p->ssc->regs, PDC_RCR, 0);
> +			ssc_writel(ssc_p->ssc->regs, PDC_RNPR, 0);
> +			ssc_writel(ssc_p->ssc->regs, PDC_RNCR, 0);
>  
> -		ssc_writel(ssc_p->ssc->regs, PDC_TPR, 0);
> -		ssc_writel(ssc_p->ssc->regs, PDC_TCR, 0);
> -		ssc_writel(ssc_p->ssc->regs, PDC_TNPR, 0);
> -		ssc_writel(ssc_p->ssc->regs, PDC_TNCR, 0);
> +			ssc_writel(ssc_p->ssc->regs, PDC_TPR, 0);
> +			ssc_writel(ssc_p->ssc->regs, PDC_TCR, 0);
> +			ssc_writel(ssc_p->ssc->regs, PDC_TNPR, 0);
> +			ssc_writel(ssc_p->ssc->regs, PDC_TNCR, 0);
> +		}
>  
>  		ret = request_irq(ssc_p->ssc->irq, atmel_ssc_interrupt, 0,
>  				ssc_p->name, ssc_p);


-- 
~Vinod

