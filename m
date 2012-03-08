Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2CHJqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:46:32 -0500
Received: from smtp-out-087.synserver.de ([212.40.185.87]:1053 "EHLO
	smtp-out-087.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2CHJqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:46:30 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26040
Message-ID: <4F58806E.9090500@metafoo.de>
Date: Thu, 08 Mar 2012 10:48:30 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: care sd_dma_address/len in dmaengine_prep_slave_single()
References: <8739axwnh9.wl%kuninori.morimoto.gx@renesas.com>	<1327917366.1527.42.camel@vkoul-udesk3> <87pqe04qtk.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87pqe04qtk.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 02:13 AM, Kuninori Morimoto wrote:
> dmaengine_prep_slave_single() is helper macro of dmaengine.
> But it doesn't have sg_dma_address/len() settings which are required.
> And it used void *buf in parameter, but it should be dma_addr_t.
> This patch fixes up it.
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Hi,

Any news regarding this patch? The dmaengine_prep_slave_single in upstream
is not really usable as it is right now.

Thanks,
- Lars

> ---
> V1 -> v2
> 
> - based on latest linus/master branch
> 
>  include/linux/dmaengine.h |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 679b349..97eaf57 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -606,11 +606,16 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
>  }
>  
>  static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
> -	struct dma_chan *chan, void *buf, size_t len,
> +	struct dma_chan *chan, dma_addr_t buf, size_t len,
>  	enum dma_transfer_direction dir, unsigned long flags)
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

