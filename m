Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423988Ab2LFPt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:49:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16229 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965230Ab2LFPt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:49:57 -0500
X-AuditID: cbfee61b-b7f616d00000319b-1d-50c0bea402bb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 05/12] async_memset: convert to dmaengine_unmap_data
Date: Thu, 06 Dec 2012 16:48:00 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, vinod.koul@intel.com,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
 <20121206092536.17085.7308.stgit@dev279.prn1.facebook.com>
In-reply-to: <20121206092536.17085.7308.stgit@dev279.prn1.facebook.com>
MIME-version: 1.0
Message-id: <201212061648.00277.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAd0l+w4EGDw/rmtxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgypn/nLOgQrui7/ZqxgXESfxcjJ4eEgInEtHMr2CFsMYkL99az
	dTFycQgJLGKUuDaxmxHCWcokcejTd2aQKjYBK4mJ7asYQWwRATmJ1bengMWFBTwkzp9vYAKx
	WQRUJa78vMgCYosKOEh0Tp0ANpVZYCujxPcnO1lBEkICLYwSHZ9NQGxOAXeJnl9PwM7gFRCU
	+DH5HguEbSnx6fVXNhCbWUBLovnNJkYIW15i85q3zBMYBWYhaZmFpGwWkrIFjMyrGEVTC5IL
	ipPSc430ihNzi0vz0vWS83M3MYJD8Jn0DsZVDRaHGAU4GJV4eC2q9wcIsSaWFVfmHmKU4GBW
	EuGN6TgQIMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMlQEggPbEkNTs1tSC1CCbLxMEp1cBo
	zcajf9QlaIFRwtPTlh4bf+x4/87rTs8azk8TfHxvtx9Q/KjFsf/i+w2tAc47Kkxay0RzvU8e
	nVSu8E69z+WE+nXdCd17rP8bNQUrTXlzoEho6SzFDevm3//N73f+09Fzy3bMrXMXUwnfI9Le
	eN+mwstm92ULB424VUZ8rRM3S/xdEnBitUOOEktxRqKhFnNRcSIAvYdtpz0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 06 December 2012 10:25:37 Dan Williams wrote:
> Use the generic unmap object to unmap dma buffers.
> 
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Dan Williams <djbw@fb.com>
> ---
>  crypto/async_tx/async_memset.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
> index 05a4d1e..ffca53b 100644
> --- a/crypto/async_tx/async_memset.c
> +++ b/crypto/async_tx/async_memset.c
> @@ -47,17 +47,22 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
>  						      &dest, 1, NULL, 0, len);
>  	struct dma_device *device = chan ? chan->device : NULL;
>  	struct dma_async_tx_descriptor *tx = NULL;
> +	struct dmaengine_unmap_data *unmap = NULL;
>  
> -	if (device && is_dma_fill_aligned(device, offset, 0, len)) {
> -		dma_addr_t dma_dest;
> -		unsigned long dma_prep_flags = 0;
> +	if (device)
> +		unmap = dmaengine_get_unmap_data(device->dev, 1, GFP_NOIO);
> +
> +	if (unmap && is_dma_fill_aligned(device, offset, 0, len)) {
> +		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
> +					       DMA_COMPL_SKIP_DEST_UNMAP;
>  
>  		if (submit->cb_fn)
>  			dma_prep_flags |= DMA_PREP_INTERRUPT;
>  		if (submit->flags & ASYNC_TX_FENCE)
>  			dma_prep_flags |= DMA_PREP_FENCE;
> -		dma_dest = dma_map_page(device->dev, dest, offset, len,
> -					DMA_FROM_DEVICE);
> +		unmap->from_cnt = 1;
> +		unmap->addr[0] = dma_map_page(device->dev, dest, offset, len,
> +					      DMA_FROM_DEVICE);

unmap->len is not set anywhere

>  		tx = device->device_prep_dma_memset(chan, dma_dest, val, len,
>  						    dma_prep_flags);
> @@ -65,6 +70,8 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
>  
>  	if (tx) {
>  		pr_debug("%s: (async) len: %zu\n", __func__, len);
> +
> +		dma_set_unmap(tx, unmap);
>  		async_tx_submit(chan, tx, submit);
>  	} else { /* run the memset synchronously */
>  		void *dest_buf;
> @@ -79,6 +86,7 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
>  
>  		async_tx_sync_epilog(submit);
>  	}
> +	dmaengine_unmap_put(unmap);
>  
>  	return tx;
>  }

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
