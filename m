Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424087Ab2LFPwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:52:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:12741 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965224Ab2LFPt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:49:57 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ce-50c0bea3c7cd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 03/12] dmaengine: reference counted unmap data
Date: Thu, 06 Dec 2012 16:47:55 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
 <20121206092525.17085.63225.stgit@dev279.prn1.facebook.com>
In-reply-to: <20121206092525.17085.63225.stgit@dev279.prn1.facebook.com>
MIME-version: 1.0
Message-id: <201212061647.55796.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jAd3F+w4EGDyaJW1xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyVh8/wlzQZlhxd/0N9gbGv2pdjJwcEgImEh0bTjFC2GISF+6t
	Z+ti5OIQEljEKNHw7ywThLOUSaKzZwErSBWbgJXExPZVYB0iAnISq29PYe5i5OAQFnCSODaZ
	EyTMIqAq8fD1HmYQW1TAQaJz6gSwocwChxglDh77zAwxtJVRovXYTrChnAIeEk+/n2MHsXkF
	BCV+TL7HAmFbSsw+vQ6shllAS6L5zSZGCFteYvOat8wTGAVmIWmZhaRsFpKyBYzMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCg/CZ1A7GlQ0WhxgFOBiVeHgtq/cHCLEmlhVX5gKdzMGs
	JMIb03EgQIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvs0dKgJBAemJJanZqakFqEUyWiYNTqoFx
	xcsHX/XkBKru/LpiMau+NU1mzcPMd6fDtwdWqEsGq/2Ls19vmWLJ4vBkt/WnD/P+x53k9T9a
	UG3cLde0dduZiVfe/fGc/8/n2PmLHIorTXs7mDVeXI3o2xteE6TRtTVyYcqLYy+djFZeivQJ
	776T85Fj9rLjGk+OKpY5tJRa3fws6H+aY8J3JZbijERDLeai4kQAv9KZ1z4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 06 December 2012 10:25:26 Dan Williams wrote:
> hang a common 'unmap' object off of dma descriptors for the purpose of
> providing a unified unmapping interface.  The lifetime of a mapping may
> span multiple descriptors, so these unmap objects are reference counted
> by related descriptor.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Dan Williams <djbw@fb.com>
> ---
>  drivers/dma/dmaengine.c   |  157 ++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/dmaengine.h |    3 +
>  2 files changed, 151 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index f3cadc6..00f0baf 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -62,6 +62,7 @@
>  #include <linux/rculist.h>
>  #include <linux/idr.h>
>  #include <linux/slab.h>
> +#include <linux/mempool.h>
>  
>  static DEFINE_MUTEX(dma_list_mutex);
>  static DEFINE_IDR(dma_idr);
> @@ -856,6 +857,131 @@ void dma_async_device_unregister(struct dma_device *device)
>  }
>  EXPORT_SYMBOL(dma_async_device_unregister);
>  
> +struct dmaengine_unmap_pool {
> +	struct kmem_cache *cache;
> +	const char *name;
> +	mempool_t *pool;
> +	size_t size;
> +};
> +
> +#define __UNMAP_POOL(x) { .size = x, .name = "dmaengine-unmap-" __stringify(x) }
> +static struct dmaengine_unmap_pool unmap_pool[] = {
> +	__UNMAP_POOL(2),
> +	#if IS_ENABLED(ASYNC_TX_DMA)
> +	__UNMAP_POOL(16),
> +	__UNMAP_POOL(128),
> +	__UNMAP_POOL(256),
> +	#endif
> +};
> +
> +static struct dmaengine_unmap_pool *__get_unmap_pool(int nr)
> +{
> +	int order = get_count_order(nr);
> +
> +	switch (order) {
> +	case 0 ... 1:
> +		return &unmap_pool[0];
> +	case 2 ... 4:
> +		return &unmap_pool[1];
> +	case 5 ... 7:
> +		return &unmap_pool[2];
> +	case 8:
> +		return &unmap_pool[3];
> +	default:
> +		BUG();
> +		return NULL;
> +	}
> +
> +}
> +
> +static void dmaengine_unmap(struct kref *kref)
> +{
> +	struct dmaengine_unmap_data *unmap = container_of(kref, typeof(*unmap), kref);
> +	struct device *dev = unmap->dev;
> +	int cnt, i;
> +
> +	cnt = unmap->to_cnt;
> +	for (i = 0; i < cnt; i++)
> +		dma_unmap_page(dev, unmap->addr[i], unmap->len,
> +			       DMA_TO_DEVICE);
> +	cnt += unmap->from_cnt;
> +	for (; i < cnt; i++)
> +		dma_unmap_page(dev, unmap->addr[i], unmap->len,
> +			       DMA_FROM_DEVICE);
> +	cnt += unmap->bidi_cnt;
> +	for (; i < cnt; i++)
> +		dma_unmap_page(dev, unmap->addr[i], unmap->len,
> +			       DMA_BIDIRECTIONAL);
> +	kmem_cache_free(__get_unmap_pool(cnt)->cache, unmap);

Shouldn't it call mempool_free() instead?

> +}
> +
> +void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap)
> +{
> +	if (unmap)
> +		kref_put(&unmap->kref, dmaengine_unmap);
> +}
> +EXPORT_SYMBOL_GPL(dmaengine_unmap_put);
> +
> +static void dmaengine_destroy_unmap_pool(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(unmap_pool); i++) {
> +		struct dmaengine_unmap_pool *p = &unmap_pool[i];
> +
> +		if (p->cache)
> +			kmem_cache_destroy(p->cache);
> +		p->cache = NULL;
> +		if (p->pool)
> +			mempool_destroy(p->pool);
> +		p->pool = NULL;
> +	}
> +}
> +
> +static int dmaengine_init_unmap_pool(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(unmap_pool); i++) {
> +		struct dmaengine_unmap_pool *p = &unmap_pool[i];
> +		size_t size;
> +
> +		size = sizeof(struct dmaengine_unmap_data) +
> +		       sizeof(dma_addr_t) * p->size;
> +
> +		p->cache = kmem_cache_create(p->name, size, 0,
> +					     SLAB_HWCACHE_ALIGN, NULL);
> +		if (!p->cache)
> +			break;
> +		p->pool = mempool_create_slab_pool(1, p->cache);
> +		if (!p->pool)
> +			break;
> +	}
> +
> +	if (i > ARRAY_SIZE(unmap_pool))
> +		return 0;
> +
> +	dmaengine_destroy_unmap_pool();
> +	return -ENOMEM;
> +}
> +
> +static struct dmaengine_unmap_data *
> +dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
> +{
> +	struct dmaengine_unmap_data *unmap;
> +
> +	unmap = mempool_alloc(__get_unmap_pool(nr)->pool, flags);
> +	if (!unmap)
> +		return NULL;
> +	unmap->to_cnt = 0;
> +	unmap->from_cnt = 0;
> +	unmap->bidi_cnt = 0;

unmap->len is not initialized

> +	kref_init(&unmap->kref);
> +	unmap->dev = dev;
> +
> +	return unmap;
> +}
> +
>  /**
>   * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
>   * @chan: DMA channel to offload copy to
> @@ -877,24 +1003,33 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
>  {
>  	struct dma_device *dev = chan->device;
>  	struct dma_async_tx_descriptor *tx;
> -	dma_addr_t dma_dest, dma_src;
> +	struct dmaengine_unmap_data *unmap;
>  	dma_cookie_t cookie;
>  	unsigned long flags;
>  
> -	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
> -	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
> -				DMA_FROM_DEVICE);
> -	flags = DMA_CTRL_ACK;
> -	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
> +	unmap = dmaengine_get_unmap_data(dev->dev, 2, GFP_NOIO);
> +	if (!unmap)
> +		return -ENOMEM;
> +
> +	unmap->to_cnt = 1;
> +	unmap->from_cnt = 1;
> +	unmap->addr[0] = dma_map_page(dev->dev, src_pg, src_off, len,
> +				      DMA_TO_DEVICE);
> +	unmap->addr[1] = dma_map_page(dev->dev, dest_pg, dest_off, len,
> +				      DMA_FROM_DEVICE);

unmap->len is not set anywhere

> +	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
> +		DMA_COMPL_SKIP_DEST_UNMAP;
> +	tx = dev->device_prep_dma_memcpy(chan, unmap->addr[1], unmap->addr[0],
> +					 len, flags);
>  
>  	if (!tx) {
> -		dma_unmap_page(dev->dev, dma_src, len, DMA_TO_DEVICE);
> -		dma_unmap_page(dev->dev, dma_dest, len, DMA_FROM_DEVICE);
> +		dmaengine_unmap_put(unmap);
>  		return -ENOMEM;
>  	}
>  
> -	tx->callback = NULL;
> +	dma_set_unmap(tx, unmap);
>  	cookie = tx->tx_submit(tx);
> +	dmaengine_unmap_put(unmap);
>  
>  	preempt_disable();
>  	__this_cpu_add(chan->local->bytes_transferred, len);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
