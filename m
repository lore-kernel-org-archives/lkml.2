Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab2A3Jy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:54:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:1786 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2A3Jy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:54:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="101806847"
Subject: Re: [PATCH] dmaengine: care sd_dma_address/len in
 dmaengine_prep_slave_single()
From: Vinod Koul <vinod.koul@intel.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <8739axwnh9.wl%kuninori.morimoto.gx@renesas.com>
References: <8739axwnh9.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 15:26:06 +0530
Message-ID: <1327917366.1527.42.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 01:25 -0800, Kuninori Morimoto wrote:
> dmaengine_prep_slave_single() is helper macro of dmaengine.
> But it doesn't have sg_dma_address/len() settings which are required.
> And it used void *buf in parameter, but it should be dma_addr_t.
> This patch fixes up it.
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
>  include/linux/dmaengine.h |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 75f53f8..f47c578 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -521,11 +521,16 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>  }
>  
>  static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
> -	struct dma_chan *chan, void *buf, size_t len,
> +	struct dma_chan *chan, dma_addr_t buf, size_t len,
>  	enum dma_data_direction dir, unsigned long flags)
dma_transfer_direction... this is not based on 3.3-rc1 or
slave-dma/next?

>  {
>  	struct scatterlist sg;
> -	sg_init_one(&sg, buf, len);
> +
> +	sg_init_table(&sg, 1);
> +	sg_set_page(&sg, pfn_to_page(PFN_DOWN(buf)),
> +		    len, offset_in_page(buf));
> +	sg_dma_address(&sg) = buf;
> +	sg_dma_len(&sg) = len;
>  
>  	return chan->device->device_prep_slave_sg(chan, &sg, 1, dir, flags);
>  }


-- 
~Vinod

