Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab1F2U5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:57:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56737 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753126Ab1F2U5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:57:41 -0400
Date: Wed, 29 Jun 2011 10:59:09 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: alsa-devel@alsa-project.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 4/5] ASoC: atmel_ssc_dai/atmel-pcm: adapt to dmaengine
 usage
Message-ID: <20110629175905.GC13051@opensource.wolfsonmicro.com>
References: <7fd26c605d5cfa422d0fc37a7b790fb9a837d7e3.1309368631.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fd26c605d5cfa422d0fc37a7b790fb9a837d7e3.1309368631.git.nicolas.ferre@atmel.com>
X-Cookie: Chicken Little was right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 08:00:18PM +0200, Nicolas Ferre wrote:

> +static const struct snd_pcm_hardware atmel_pcm_dma_hardware = {
> +	.info			= SNDRV_PCM_INFO_MMAP |
> +				  SNDRV_PCM_INFO_MMAP_VALID |

The naming here looks a bit undescriptive but I'm not sure what a better
name would be - obviously both DMA controllers are DMA controllers.  It
feels like it would be more sensible to just write a separate DMA driver
as I'm not sure how much code actually ends up being shared here but it
looks pretty small from the diff...

> +static bool filter(struct dma_chan *chan, void *slave)
> +{
> +	struct	at_dma_slave		*sl = slave;
> +

Odd whitespace here.

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

Why wouldn't we have a device, and why is there a separate copy of the
device?

> +	if (!prtd->dma_chan) {
> +		pr_err("atmel-pcm: "
> +			"DMA channel not available, unable to use SSC-audio\n");
> +		return -EBUSY;

dev_err() and don't split strings over lines.

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

It strikes me that this mapping of bytes to DMA_SLAVE_ is likely to be
quite common and might be nice as a helper in dmaengine.

I'd also expect to see something complain (even if just with BUG()) if we
hit the default case.
