Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab2A3J3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:29:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:10453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab2A3J3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:29:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="117958817"
Subject: Re: [RFC] dmaengine/dma_slave: add context parameter to
 prep_slave_sg callback
From: Vinod Koul <vinod.koul@intel.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, dan.j.williams@intel.com,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <1327612946-29397-1-git-send-email-alexandre.bounine@idt.com>
References: <1327612946-29397-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 15:00:49 +0530
Message-ID: <1327915849.1527.17.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 16:22 -0500, Alexandre Bounine wrote:
> As we agreed during our discussion about adding DMA Engine support for RapidIO
> subsystem, RapidIO and similar clients may benefit from adding an extra context
> parameter to device_prep_slave_sg() callback.
> See https://lkml.org/lkml/2011/10/24/275 for more details.
> 
> Adding the context parameter will allow to pass client/target specific
> information associated with an individual data transfer request.
> 
> In the case of RapidIO support this additional information consists of target
> destination ID and its buffer address (which is not mapped into the local CPU
> memory space). Because a single RapidIO-capable DMA channel may queue data
> transfer requests to different target devices, the per-request configuration
> is required.
> 
> The proposed change eliminates need for new subsystem-specific API.
> Existing DMA_SLAVE clients will ignore the new parameter.
> 
> This RFC only demonstrates the API change and does not include corresponding
> changes to existing DMA_SLAVE clients. Complete set of patches will be provided
> after (if) this API change is accepted.
This looks good to me. But was thinking if we need to add this new
parameter for other slave calls (circular, interleaved, memcpy...)

> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Russell King <rmk@arm.linux.org.uk> 
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Li Yang <leoli@freescale.com>
> ---
>  include/linux/dmaengine.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 679b349..79d71bb 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -575,7 +575,7 @@ struct dma_device {
>  	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
>  		struct dma_chan *chan, struct scatterlist *sgl,
>  		unsigned int sg_len, enum dma_transfer_direction direction,
> -		unsigned long flags);
> +		unsigned long flags, void *context);
>  	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
>  		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>  		size_t period_len, enum dma_transfer_direction direction);
> @@ -607,12 +607,13 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>  
>  static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
>  	struct dma_chan *chan, void *buf, size_t len,
> -	enum dma_transfer_direction dir, unsigned long flags)
> +	enum dma_transfer_direction dir, unsigned long flags, void *context)
>  {
>  	struct scatterlist sg;
>  	sg_init_one(&sg, buf, len);
>  
> -	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
> +	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags,
> +						  context);
>  }
>  
>  static inline int dmaengine_terminate_all(struct dma_chan *chan)


-- 
~Vinod

