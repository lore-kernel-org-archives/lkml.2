Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2AQNw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:52:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:41044 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab2AQNw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:52:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96725259"
Subject: Re: [PATCH v2 1/2] dmaengine: Add support for per xfer specific
 privatedata & box dma
From: Vinod Koul <vinod.koul@intel.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: dan.j.williams@intel.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, tsoni@qualcomm.com, johlstei@qualcomm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1325854052-21402-2-git-send-email-kumarrav@codeaurora.org>
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
	 <1325854052-21402-2-git-send-email-kumarrav@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 19:23:08 +0530
Message-ID: <1326808388.1540.123.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 18:17 +0530, Ravi Kumar V wrote:
> Qualcomm MSM have a feature to pass command configuration and
> control data along with source,destination and length of transfer
> for every transaction, as of now struct scatterlist has no support
> to send private data related to each transaction we added private_data
> variable for supporting this type of archictures.
this looks quite similar to what RIO [1] folks were asking, ie ability
to pass specific parameters for each transaction which are device
specific.
> 
> Qualcomm MSM also supports BOX mode of dma, currently as there is no
> API in dmaengine to support this type of dma we added new API.
> 
> Change-Id: Ia9ee19f2c253e68b8e5ff254a57478dcc51014ca
> Signed-off-by: Ravi Kumar V <kumarrav@codeaurora.org>
> ---
>  include/asm-generic/scatterlist.h |    1 +
>  include/linux/dmaengine.h         |   17 ++++++++++++++++-
>  2 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
> index 5de0735..e66dfcb 100644
> --- a/include/asm-generic/scatterlist.h
> +++ b/include/asm-generic/scatterlist.h
> @@ -14,6 +14,7 @@ struct scatterlist {
>  #ifdef CONFIG_NEED_SG_DMA_LENGTH
>  	unsigned int	dma_length;
>  #endif
> +	unsigned long	private_data;
what do you plan to pass here. Please keep in mind this is a generic
scatterlist structure, and modifying it for your purposes doesn't seem
to be a great one!
Also why can't you pass this as addition argument in your new "BOX API"?

>  };
>  
>  /*
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 75f53f8..ea29e73 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -72,10 +72,11 @@ enum dma_transaction_type {
>  	DMA_ASYNC_TX,
>  	DMA_SLAVE,
>  	DMA_CYCLIC,
> +	DMA_BOX,
>  };
>  
>  /* last transaction type for creation of the capabilities mask */
> -#define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
> +#define DMA_TX_TYPE_END (DMA_BOX + 1)
>  
> 
>  /**
> @@ -404,6 +405,15 @@ struct dma_tx_state {
>  	u32 residue;
>  };
>  
> +
> +struct dma_box_list {
> +	dma_addr_t dma_row_address;
> +	unsigned int dma_row_len;
> +	unsigned int dma_row_num;
> +	unsigned int dma_row_offset;
> +	unsigned long private_data;
> +};
again a private data here?
is this some kind of interleaved pattern?
> +
>  /**
>   * struct dma_device - info on the entity supplying DMA services
>   * @chancnt: how many DMA channels are supported
> @@ -497,6 +507,11 @@ struct dma_device {
>  	struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
>  		struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>  		size_t period_len, enum dma_data_direction direction);
> +	struct dma_async_tx_descriptor *(*device_prep_dma_box)(
> +		struct dma_chan *chan, struct dma_box_list *dst_box,
> +		struct dma_box_list *src_box, unsigned int num_list,
> +		unsigned long flags);
still not clean what kind of transfer do you want to do here
> +
>  	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>  		unsigned long arg);
>  


-- 
~Vinod

