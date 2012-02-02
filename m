Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2BBMQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:16:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51387 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2BBMQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:16:16 -0500
Date: Thu, 2 Feb 2012 12:15:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, linus.walleij@linaro.org, mirko.gardi@st.com,
        perex@perex.cz, vipin.kumar@st.com, vipulkumar.samar@st.com,
        egtvedt@samfundet.no, pratyush.anand@st.com, deepak.sikri@st.com,
        cjb@laptop.org, hskinnemoen@gmail.com, bhavna.yadav@st.com,
        armando.visconti@st.com, shiraz.hashim@st.com, amit.virdi@st.com,
        vincenzo.frascino@st.com, ulf.hansson@stericsson.com,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.linux@gmail.com,
        kernel@pengutronix.de
Subject: Re: [PATCH V3 08/12] dmaengine/dw_dmac: Unmap all memory buffers
	after completion of non-slave transfers
Message-ID: <20120202121523.GG889@n2100.arm.linux.org.uk>
References: <cover.1328091915.git.viresh.kumar@st.com> <c098ca5959c947b3634555bc7bf4a8b3af82a2ae.1328091915.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c098ca5959c947b3634555bc7bf4a8b3af82a2ae.1328091915.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:12:24PM +0530, Viresh Kumar wrote:
> Currently, after completion of transfer, source address or destination address
> of only the first LLI descriptor is unmapped. And length passed for unmap is
> total length of all descriptors in the list. Which means unmapping code assumed
> that the memory buffers pointed to by the descriptors will be physically
> contiguous, which might not be the case.
> 
> This patch intends to fix this wrong expectation of dw_dmac. Now, first desc
> will not contain total length of transfer. But individual descriptors will
> contain their individual lengths. Finally, we will call unmap for all
> descriptors.

I'm still unconvinced that this is anywhere close to correct.

Look.  DMA engines only automatically unmap when they're being used by the
async_tx stuff for memcpy's, and RAID computation offload, and the like.
These work with individual single buffers, not scatterlists.  These will
not be fragmented.

If the caller mapped it with a single or page mapping, then the DMA engine
ABSOLUTELY MUST unmap it with the equivalent unmapping function _with the
same arguments_ which were used to map it - and certainly not doing it
piece meal on multiple small bits of the buffer.  The whole buffer entirely
in one go.  Even if the DMA engine driver decides internally to split the
buffer into smaller chunks.

The DMA API demands that the following will always be satisfied:

	dma = dma_map_single(dev, addr, len, dir);

	dma_unmap_single(dev, dma, len, dir);

where those arguments passed into dma_unmap_single() are those which were
passed into/outof dma_map_single() _totally_ _unmodified_.

The same is true for dma_map_page()..dma_unmap_page().

> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c |   49 +++++++++++++++++++++++++++++++------------------
>  1 files changed, 31 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 5d7b199..49d477c 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -231,6 +231,14 @@ static void dwc_dostart(struct dw_dma_chan *dwc, struct dw_desc *first)
>  
>  /*----------------------------------------------------------------------*/
>  
> +#define dw_dmac_unmap(utype, _desc, _child, _buf, _dir)			\
> +do {									\
> +	list_for_each_entry(_child, &_desc->tx_list, desc_node)		\
> +		dma_unmap_##utype(parent, _child->lli._buf,		\
> +				_child->len, _dir);			\
> +	dma_unmap_##utype(parent, _desc->lli._buf, _desc->len, _dir);	\
> +} while (0)
> +
>  static void
>  dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
>  		bool callback_required)
> @@ -264,19 +272,19 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
>  		struct device *parent = chan2parent(&dwc->chan);
>  		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
>  			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> -				dma_unmap_single(parent, desc->lli.dar,
> -						desc->len, DMA_FROM_DEVICE);
> +				dw_dmac_unmap(single, desc, child, dar,
> +						DMA_FROM_DEVICE);
>  			else
> -				dma_unmap_page(parent, desc->lli.dar,
> -						desc->len, DMA_FROM_DEVICE);
> +				dw_dmac_unmap(page, desc, child, dar,
> +						DMA_FROM_DEVICE);
>  		}
>  		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
>  			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> -				dma_unmap_single(parent, desc->lli.sar,
> -						desc->len, DMA_TO_DEVICE);
> +				dw_dmac_unmap(single, desc, child, sar,
> +						DMA_TO_DEVICE);
>  			else
> -				dma_unmap_page(parent, desc->lli.sar,
> -						desc->len, DMA_TO_DEVICE);
> +				dw_dmac_unmap(page, desc, child, sar,
> +						DMA_TO_DEVICE);
>  		}
>  	}
>  
> @@ -676,6 +684,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>  		desc->lli.dar = dest + offset;
>  		desc->lli.ctllo = ctllo;
>  		desc->lli.ctlhi = xfer_count;
> +		desc->len = xfer_count << src_width;
>  
>  		if (!first) {
>  			first = desc;
> @@ -701,7 +710,6 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
>  			DMA_TO_DEVICE);
>  
>  	first->txd.flags = flags;
> -	first->len = len;
>  
>  	return &first->txd;
>  
> @@ -725,7 +733,6 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  	unsigned int		mem_width;
>  	unsigned int		i;
>  	struct scatterlist	*sg;
> -	size_t			total_len = 0;
>  
>  	dev_vdbg(chan2dev(chan), "prep_dma_slave\n");
>  
> @@ -774,6 +781,7 @@ slave_sg_todev_fill_desc:
>  			}
>  
>  			desc->lli.ctlhi = dlen >> mem_width;
> +			desc->len = dlen;
>  
>  			if (!first) {
>  				first = desc;
> @@ -787,7 +795,6 @@ slave_sg_todev_fill_desc:
>  						&first->tx_list);
>  			}
>  			prev = desc;
> -			total_len += dlen;
>  
>  			if (len)
>  				goto slave_sg_todev_fill_desc;
> @@ -831,6 +838,7 @@ slave_sg_fromdev_fill_desc:
>  				len = 0;
>  			}
>  			desc->lli.ctlhi = dlen >> reg_width;
> +			desc->len = dlen;
>  
>  			if (!first) {
>  				first = desc;
> @@ -844,7 +852,6 @@ slave_sg_fromdev_fill_desc:
>  						&first->tx_list);
>  			}
>  			prev = desc;
> -			total_len += dlen;
>  
>  			if (len)
>  				goto slave_sg_fromdev_fill_desc;
> @@ -863,8 +870,6 @@ slave_sg_fromdev_fill_desc:
>  			prev->txd.phys, sizeof(prev->lli),
>  			DMA_TO_DEVICE);
>  
> -	first->len = total_len;
> -
>  	return &first->txd;
>  
>  err_desc_get:
> @@ -950,11 +955,19 @@ dwc_tx_status(struct dma_chan *chan,
>  		ret = dma_async_is_complete(cookie, last_complete, last_used);
>  	}
>  
> -	if (ret != DMA_SUCCESS)
> -		dma_set_tx_state(txstate, last_complete, last_used,
> -				dwc_first_active(dwc)->len);
> -	else
> +	if (ret != DMA_SUCCESS) {
> +		struct dw_desc *desc, *child;
> +		unsigned int len;
> +
> +		desc = dwc_first_active(dwc);
> +		len = desc->len;
> +		list_for_each_entry(child, &desc->tx_list, desc_node)
> +			len += child->len;
> +
> +		dma_set_tx_state(txstate, last_complete, last_used, len);
> +	} else {
>  		dma_set_tx_state(txstate, last_complete, last_used, 0);
> +	}
>  
>  	if (dwc->paused)
>  		return DMA_PAUSED;
> -- 
> 1.7.8.110.g4cb5d
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
