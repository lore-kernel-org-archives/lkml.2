Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424048Ab2LFPu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:50:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16241 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423990Ab2LFPuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:50:01 -0500
X-AuditID: cbfee61b-b7f616d00000319b-2d-50c0bea828c3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 09/12] async_pq: convert to dmaengine_unmap_data
Date: Thu, 06 Dec 2012 16:48:08 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, vinod.koul@intel.com,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
 <20121206092559.17085.82548.stgit@dev279.prn1.facebook.com>
In-reply-to: <20121206092559.17085.82548.stgit@dev279.prn1.facebook.com>
MIME-version: 1.0
Message-id: <201212061648.08856.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAd0V+w4EGKx+wGNxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyXkz/yFYw2bHi3acexgbGqUZdjJwcEgImEkt+PWGFsMUkLtxb
	z9bFyMUhJLCIUWJ913cmCGcpk8SxZZ+ZQKrYBKwkJravYgSxRQTkJFbfnsIMYgsLuEhsXv2f
	DcRmEVCVaDzzHMwWFXCQ6Jw6AWwqs8BWRonvT3ayQkxtZZS4vLELrJtTwENi2cm1YFN5BQQl
	fky+xwJhW0q8PXQdbDOzgJZE85tNjBC2vMTmNW+ZJzAKzELSMgtJ2SwkZQsYmVcxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBIfhM+kdjKsaLA4xCnAwKvHwWlTvDxBiTSwrrsw9xCjBwawk
	whvTcSBAiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6YklqdmpqQWoRTJaJg1OqgZH9
	1q/Qw7crQzODop4mtK951G5lXbTJ4GmG5qbD73vmN53nu7o32OVAQ2OvtY3c1KiTx7xe9lff
	Ypr53HZGe8Df09LGj8U3rRS/1ffsDqdDMlNI8fLK3qKLGXULndv3J3+sY3H49Wvh9u0C2d+u
	XTKMe3N6nevlFdplhSzz8p801X0I5Oo58FyJpTgj0VCLuag4EQATSagbPwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2012 10:25:59 Dan Williams wrote:
> Use the generic unmap object to unmap dma buffers.
> 
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Dan Williams <djbw@fb.com>
> ---
>  crypto/async_tx/async_pq.c |  117 ++++++++++++++++++++++++--------------------
>  drivers/dma/dmaengine.c    |    5 ++
>  2 files changed, 68 insertions(+), 54 deletions(-)
> 
> diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
> index 91d5d38..1d78984 100644
> --- a/crypto/async_tx/async_pq.c
> +++ b/crypto/async_tx/async_pq.c
> @@ -46,49 +46,25 @@ static struct page *pq_scribble_page;
>   * do_async_gen_syndrome - asynchronously calculate P and/or Q
>   */
>  static __async_inline struct dma_async_tx_descriptor *
> -do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
> -		      const unsigned char *scfs, unsigned int offset, int disks,
> -		      size_t len, dma_addr_t *dma_src,
> +do_async_gen_syndrome(struct dma_chan *chan,
> +		      const unsigned char *scfs, int disks,
> +		      struct dmaengine_unmap_data *unmap,
> +		      enum dma_ctrl_flags dma_flags,
>  		      struct async_submit_ctl *submit)
>  {
> +	dma_addr_t *dma_dest = &unmap->addr[disks - 2];

This seem to have the same issue with dma_dest[0] being potentially
overwritten as patch #8 so temporary array is really necessary.

>  	struct dma_async_tx_descriptor *tx = NULL;
>  	struct dma_device *dma = chan->device;
> -	enum dma_ctrl_flags dma_flags = 0;
>  	enum async_tx_flags flags_orig = submit->flags;
>  	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
>  	dma_async_tx_callback cb_param_orig = submit->cb_param;
>  	int src_cnt = disks - 2;
> -	unsigned char coefs[src_cnt];
>  	unsigned short pq_src_cnt;
> -	dma_addr_t dma_dest[2];
>  	int src_off = 0;
> -	int idx;
> -	int i;
>  
> -	/* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
> -	if (P(blocks, disks))
> -		dma_dest[0] = dma_map_page(dma->dev, P(blocks, disks), offset,
> -					   len, DMA_BIDIRECTIONAL);
> -	else
> -		dma_flags |= DMA_PREP_PQ_DISABLE_P;
> -	if (Q(blocks, disks))
> -		dma_dest[1] = dma_map_page(dma->dev, Q(blocks, disks), offset,
> -					   len, DMA_BIDIRECTIONAL);
> -	else
> -		dma_flags |= DMA_PREP_PQ_DISABLE_Q;
> -
> -	/* convert source addresses being careful to collapse 'empty'
> -	 * sources and update the coefficients accordingly
> -	 */
> -	for (i = 0, idx = 0; i < src_cnt; i++) {
> -		if (blocks[i] == NULL)
> -			continue;
> -		dma_src[idx] = dma_map_page(dma->dev, blocks[i], offset, len,
> -					    DMA_TO_DEVICE);
> -		coefs[idx] = scfs[i];
> -		idx++;
> -	}
> -	src_cnt = idx;
> +	dma_flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
> +	if (submit->flags & ASYNC_TX_FENCE)
> +		dma_flags |= DMA_PREP_FENCE;
>  
>  	while (src_cnt > 0) {
>  		submit->flags = flags_orig;
> @@ -100,28 +76,23 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
>  		if (src_cnt > pq_src_cnt) {
>  			submit->flags &= ~ASYNC_TX_ACK;
>  			submit->flags |= ASYNC_TX_FENCE;
> -			dma_flags |= DMA_COMPL_SKIP_DEST_UNMAP;
>  			submit->cb_fn = NULL;
>  			submit->cb_param = NULL;
>  		} else {
> -			dma_flags &= ~DMA_COMPL_SKIP_DEST_UNMAP;
>  			submit->cb_fn = cb_fn_orig;
>  			submit->cb_param = cb_param_orig;
>  			if (cb_fn_orig)
>  				dma_flags |= DMA_PREP_INTERRUPT;
>  		}
> -		if (submit->flags & ASYNC_TX_FENCE)
> -			dma_flags |= DMA_PREP_FENCE;
>  
> -		/* Since we have clobbered the src_list we are committed
> -		 * to doing this asynchronously.  Drivers force forward
> -		 * progress in case they can not provide a descriptor
> +		/* Drivers force forward progress in case they can not provide
> +		 * a descriptor
>  		 */
>  		for (;;) {
>  			tx = dma->device_prep_dma_pq(chan, dma_dest,
> -						     &dma_src[src_off],
> +						     &unmap->addr[src_off],
>  						     pq_src_cnt,
> -						     &coefs[src_off], len,
> +						     &scfs[src_off], unmap->len,
>  						     dma_flags);
>  			if (likely(tx))
>  				break;
> @@ -129,6 +100,7 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
>  			dma_async_issue_pending(chan);
>  		}
>  
> +		dma_set_unmap(tx, unmap);
>  		async_tx_submit(chan, tx, submit);
>  		submit->depend_tx = tx;
>  
> @@ -188,10 +160,6 @@ do_sync_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
>   * set to NULL those buffers will be replaced with the raid6_zero_page
>   * in the synchronous path and omitted in the hardware-asynchronous
>   * path.
> - *
> - * 'blocks' note: if submit->scribble is NULL then the contents of
> - * 'blocks' may be overwritten to perform address conversions
> - * (dma_map_page() or page_address()).
>   */
>  struct dma_async_tx_descriptor *
>  async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
> @@ -202,26 +170,69 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
>  						      &P(blocks, disks), 2,
>  						      blocks, src_cnt, len);
>  	struct dma_device *device = chan ? chan->device : NULL;
> -	dma_addr_t *dma_src = NULL;
> +	struct dmaengine_unmap_data *unmap = NULL;
>  
>  	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
>  
> -	if (submit->scribble)
> -		dma_src = submit->scribble;
> -	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
> -		dma_src = (dma_addr_t *) blocks;
> +	if (device)
> +		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
>  
> -	if (dma_src && device &&
> +	if (unmap &&
>  	    (src_cnt <= dma_maxpq(device, 0) ||
>  	     dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
>  	    is_dma_pq_aligned(device, offset, 0, len)) {
> +		struct dma_async_tx_descriptor *tx;
> +		enum dma_ctrl_flags dma_flags = 0;
> +		unsigned char coefs[src_cnt];
> +		int i, j;
> +
>  		/* run the p+q asynchronously */
>  		pr_debug("%s: (async) disks: %d len: %zu\n",
>  			 __func__, disks, len);
> -		return do_async_gen_syndrome(chan, blocks, raid6_gfexp, offset,
> -					     disks, len, dma_src, submit);
> +
> +		/* convert source addresses being careful to collapse 'empty'
> +		 * sources and update the coefficients accordingly
> +		 */
> +		unmap->len = len;
> +		for (i = 0, j = 0; i < src_cnt; i++) {
> +			if (blocks[i] == NULL)
> +				continue;
> +			unmap->addr[j] = dma_map_page(device->dev, blocks[i], offset,
> +						      len, DMA_TO_DEVICE);
> +			coefs[j] = raid6_gfexp[i];
> +			unmap->to_cnt++;
> +			j++;
> +		}
> +
> +		/*
> +		 * DMAs use destinations as sources,
> +		 * so use BIDIRECTIONAL mapping
> +		 */
> +		unmap->bidi_cnt++;
> +		if (P(blocks, disks))
> +			unmap->addr[j++] = dma_map_page(device->dev, P(blocks, disks),
> +							offset, len, DMA_BIDIRECTIONAL);
> +		else {
> +			unmap->addr[j++] = 0;
> +			dma_flags |= DMA_PREP_PQ_DISABLE_P;
> +		}
> +
> +		unmap->bidi_cnt++;
> +		if (Q(blocks, disks))
> +			unmap->addr[j++] = dma_map_page(device->dev, Q(blocks, disks),
> +						       offset, len, DMA_BIDIRECTIONAL);
> +		else {
> +			unmap->addr[j++] = 0;
> +			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
> +		}
> +
> +		tx = do_async_gen_syndrome(chan, coefs, j, unmap, dma_flags, submit);
> +		dmaengine_unmap_put(unmap);
> +		return tx;
>  	}
>  
> +	dmaengine_unmap_put(unmap);
> +
>  	/* run the pq synchronously */
>  	pr_debug("%s: (sync) disks: %d len: %zu\n", __func__, disks, len);
>  
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 1b76227..5a3c7c0 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -909,9 +909,12 @@ static void dmaengine_unmap(struct kref *kref)
>  		dma_unmap_page(dev, unmap->addr[i], unmap->len,
>  			       DMA_FROM_DEVICE);
>  	cnt += unmap->bidi_cnt;
> -	for (; i < cnt; i++)
> +	for (; i < cnt; i++) {
> +		if (unmap->addr[i] == 0)
> +			continue;
>  		dma_unmap_page(dev, unmap->addr[i], unmap->len,
>  			       DMA_BIDIRECTIONAL);
> +	}
>  	kmem_cache_free(__get_unmap_pool(cnt)->cache, unmap);
>  }

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
