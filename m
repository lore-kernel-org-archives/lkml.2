Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0CYU6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:58:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:60991 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752874Ab0CYU6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:58:10 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/r54B0v5HrF3UH/bzvMELke5BRF4qM+KiboMywSB
	3KdMkH6YK3flUE
Date: Thu, 25 Mar 2010 21:58:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linus Walleij <linus.walleij@stericsson.com>
cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status
In-Reply-To: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
Message-ID: <Pine.LNX.4.64.1003252146070.4413@axis700.grange>
References: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Linus Walleij wrote:

> Convert the device_is_tx_complete() operation on the
> DMA engine to a generic device_tx_status()operation which
> can return three states, DMA_TX_RUNNING, DMA_TX_COMPLETE,
> DMA_TX_PAUSED.
> 
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Cc: Magnus Damm <damm@opensource.se>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Roland Dreier <rdreier@cisco.com>
> ---

[snip]

General: you converted all drivers to the new .device_tx_status() API, but 
since they don't implement "residue," you left it uninitialised 
everywhere. Wouldn't it be better to set it to 0 or total length, 
depending on the complete / not complete status?

> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 0731802..c9f2c67 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -40,11 +40,13 @@ typedef s32 dma_cookie_t;
>   * enum dma_status - DMA transaction status
>   * @DMA_SUCCESS: transaction completed successfully
>   * @DMA_IN_PROGRESS: transaction not yet processed
> + * @DMA_PAUSED: transaction is paused
>   * @DMA_ERROR: transaction failed
>   */
>  enum dma_status {
>  	DMA_SUCCESS,
>  	DMA_IN_PROGRESS,
> +	DMA_PAUSED,
>  	DMA_ERROR,
>  };
>  
> @@ -249,6 +251,21 @@ struct dma_async_tx_descriptor {
>  };
>  
>  /**
> + * struct dma_tx_state - filled in to report the status of
> + * a transfer.
> + * @last: last completed DMA cookie
> + * @used: last issued DMA cookie (i.e. the one in progress)
> + * @residue: the remaining number of bytes left to transmit
> + *	on the selected transfer for states DMA_IN_PROGRESS and
> + *	DMA_PAUSED if this is implemented in the driver, else 0
> + */
> +struct dma_tx_state {
> +	dma_cookie_t last;
> +	dma_cookie_t used;
> +	u32 residue;

In the original proposal by Dan Williams the last member was "unsigned 
long pos." I don't think, even on 64-bit systems anyone would kick off a > 
4GB transfer, but who knows... And - I don't particularly like the name 
"pos," but I do like the idea of returning bytes transfered better, than 
bytes left. Can we change this?

> +};
> +
> +/**
>   * struct dma_device - info on the entity supplying DMA services
>   * @chancnt: how many DMA channels are supported
>   * @privatecnt: how many DMA channels are requested by dma_request_channel
> @@ -276,7 +293,10 @@ struct dma_async_tx_descriptor {
>   * @device_prep_slave_sg: prepares a slave dma operation
>   * @device_control: manipulate all pending operations on a channel, returns
>   *	zero or error code
> - * @device_is_tx_complete: poll for transaction completion
> + * @device_tx_status: poll for transaction completion, the optional
> + *	txstate parameter can be supplied with a pointer to get a
> + *	struct with some transfer information, else the call will just

Maybe "with auxiliary transfer status information, otherwise..."

> + *	return a simple status code
>   * @device_issue_pending: push pending transactions to hardware
>   */
>  struct dma_device {
> @@ -329,9 +349,9 @@ struct dma_device {
>  		unsigned long flags);
>  	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd);
>  
> -	enum dma_status (*device_is_tx_complete)(struct dma_chan *chan,
> -			dma_cookie_t cookie, dma_cookie_t *last,
> -			dma_cookie_t *used);
> +	enum dma_status (*device_tx_status)(struct dma_chan *chan,
> +					    dma_cookie_t cookie,
> +					    struct dma_tx_state *txstate);
>  	void (*device_issue_pending)(struct dma_chan *chan);
>  };
>  
> @@ -572,7 +592,13 @@ static inline void dma_async_issue_pending(struct dma_chan *chan)
>  static inline enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
>  	dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
>  {
> -	return chan->device->device_is_tx_complete(chan, cookie, last, used);
> +	struct dma_tx_state state;
> +	enum dma_status status;
> +
> +	status = chan->device->device_tx_status(chan, cookie, &state);
> +	*last = state.last;
> +	*used = state.used;

Both last and used can be NULL.

> +	return status;
>  }
>  
>  #define dma_async_memcpy_complete(chan, cookie, last, used)\
> -- 
> 1.6.3.3

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
