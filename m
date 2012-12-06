Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424103Ab2LFPwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:52:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16229 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965222Ab2LFPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:49:56 -0500
X-AuditID: cbfee61b-b7f616d00000319b-18-50c0bea3ca74
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 04/12] async_memcpy: convert to dmaengine_unmap_data
Date: Thu, 06 Dec 2012 16:47:58 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, vinod.koul@intel.com,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
 <20121206092531.17085.71257.stgit@dev279.prn1.facebook.com>
In-reply-to: <20121206092531.17085.71257.stgit@dev279.prn1.facebook.com>
MIME-version: 1.0
Message-id: <201212061647.58297.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAd0l+w4EGNxaxmpxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgynt/ZwFiwSqLi0fOH7A2MH4W6GDk5JARMJDb/f8gEYYtJXLi3
	nq2LkYtDSGARo8S7WdOhnKVMEp09C1hBqtgErCQmtq9iBLFFBOQkVt+ewgxiCwt4SHy/uo0F
	xGYRUJVY2NgKNlVUwEGic+oEsEHMAlsZJb4/2ckKMbWVUeLYsWNgVZxA3Q92TQKzeQUEJX5M
	vscCYVtKLD7QCGYzC2hJNL/ZxAhhy0tsXvOWeQKjwCwkLbOQlM1CUraAkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnAYPpPewbiqweIQowAHoxIPr0X1/gAh1sSy4srcQ4wSHMxKIrwx
	HQcChHhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmkJ5akZqemFqQWwWSZODilGhj7Leb/
	M3T7WGO8NqX4y+qQKx/LQhSULpxJmqspcSbkuV39g4agfpmazhDZRpab356uv11/hOnHXtPC
	4939QQvEeB5d1Ai9sLZ4U03Rvs7LTdo7dXbu1kxOn8Lcxuunb25TqZ3XX9UWKHrq8qxtNj1f
	7gg1OomtWSaw/ZxVv+iZHWz9J9WbbZRYijMSDbWYi4oTAVvsgXM/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 06 December 2012 10:25:31 Dan Williams wrote:
> Use the generic unmap object to unmap dma buffers.
> 
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Dan Williams <djbw@fb.com>
> ---
>  crypto/async_tx/async_memcpy.c |   39 ++++++++++++++++++++++-----------------
>  drivers/dma/dmaengine.c        |    3 ++-
>  include/linux/dmaengine.h      |    2 ++
>  3 files changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
> index 9e62fef..ca95c4c 100644
> --- a/crypto/async_tx/async_memcpy.c
> +++ b/crypto/async_tx/async_memcpy.c
> @@ -50,33 +50,36 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
>  						      &dest, 1, &src, 1, len);
>  	struct dma_device *device = chan ? chan->device : NULL;
>  	struct dma_async_tx_descriptor *tx = NULL;
> +	struct dmaengine_unmap_data *unmap = NULL;
>  
> -	if (device && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
> -		dma_addr_t dma_dest, dma_src;
> -		unsigned long dma_prep_flags = 0;
> +	if (device)
> +		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
> +
> +	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
> +		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
> +					       DMA_COMPL_SKIP_DEST_UNMAP;
>  
>  		if (submit->cb_fn)
>  			dma_prep_flags |= DMA_PREP_INTERRUPT;
>  		if (submit->flags & ASYNC_TX_FENCE)
>  			dma_prep_flags |= DMA_PREP_FENCE;
> -		dma_dest = dma_map_page(device->dev, dest, dest_offset, len,
> -					DMA_FROM_DEVICE);
> -
> -		dma_src = dma_map_page(device->dev, src, src_offset, len,
> -				       DMA_TO_DEVICE);
> -
> -		tx = device->device_prep_dma_memcpy(chan, dma_dest, dma_src,
> -						    len, dma_prep_flags);
> -		if (!tx) {
> -			dma_unmap_page(device->dev, dma_dest, len,
> -				       DMA_FROM_DEVICE);
> -			dma_unmap_page(device->dev, dma_src, len,
> -				       DMA_TO_DEVICE);
> -		}
> +
> +		unmap->to_cnt = 1;
> +		unmap->addr[0] = dma_map_page(device->dev, src, src_offset, len,
> +		                              DMA_TO_DEVICE);
> +		unmap->from_cnt = 1;
> +		unmap->addr[1] = dma_map_page(device->dev, dest, dest_offset, len,
> +					      DMA_FROM_DEVICE);

unmap->len is not set anywhere

> +
> +		tx = device->device_prep_dma_memcpy(chan, unmap->addr[1],
> +						    unmap->addr[0], len,
> +						    dma_prep_flags);
>  	}
>  
>  	if (tx) {
>  		pr_debug("%s: (async) len: %zu\n", __func__, len);
> +
> +		dma_set_unmap(tx, unmap);
>  		async_tx_submit(chan, tx, submit);
>  	} else {
>  		void *dest_buf, *src_buf;
> @@ -96,6 +99,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
>  		async_tx_sync_epilog(submit);
>  	}
>  
> +	dmaengine_unmap_put(unmap);
> +
>  	return tx;
>  }
>  EXPORT_SYMBOL_GPL(async_memcpy);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
