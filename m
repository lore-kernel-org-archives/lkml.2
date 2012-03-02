Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2CBNVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:21:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2CBNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:21:52 -0500
Date: Fri, 2 Mar 2012 14:21:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH/RFC] dmaengine: add a slave parameter to __dma_request_channel()
In-Reply-To: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
Message-ID: <Pine.LNX.4.64.1203021341590.913@axis700.grange>
References: <Pine.LNX.4.64.1202011610050.26261@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:lh2sOpk9QEwkqhR8OpGI5reFVrnI5few58+27lviCq2
 Hl3XZrhJzlJM5N5d5BzPMVEIGagzlF7QjDavHdE7yIJOjgS7a8
 ZDVz8HtrOGPuHiAvrVHnxiQl4D6xMfaUJ5IN2Y5rc8DXSoQGZN
 bNYlH63/8QQ9e5TJhYkPq3Jz7IZay7qRsSN1t/zjIz+yjCu0WV
 p624xOtmA4tnp1ibSgiykOIG4H1tguXwKF0X70392xkw2Dg5uN
 PNhp1zK9hBDxOVyMYiCfU41S6KkO58KrL85AgvGaNcNLHKSo25
 G7pHC0E8CbA/ku+JqEpm4WlOePp5RgxCj+d6aOw1XjWOpu8qXO
 7yRo/tUnnEMGKC3k6gB591rLXJ1syxN82L5GTDQgH7/3/SVewV
 3eYLBvFEp9WQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Wed, 1 Feb 2012, Guennadi Liakhovetski wrote:

> When performing slame DMA some dmaengine drivers need additional data from
> client drivers to find out, whether they can support that specific client
> and to configure the DMA channel for it. This additional data has to be
> supplied by client drivers during channel allocation, i.e., with the
> __dma_request_channel() function. This patch adds a new
> struct dma_slave_desc with some basic data in it, further this struct can
> be embedded in hardware-specific types to supply any auxiliary
> configuration.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

What do you think about this patch? It would be important for me to know 
your opinion, resp., to get it approved by you, then I could base my other 
shdma / "simple" dma work on top of it. It would also give me a "natural" 
way to eliminate the use of the .priv pointer in shdma.

Thanks
Guennadi

> ---
> 
> Vinod, this is the patch I told you about. It also requires changing all 
> dmaengine drivers by adding one parameter to their 
> .device_alloc_chan_resources() methods, which they would simply continue 
> to ignore. Since this patch doesn't include that modification, it is 
> marked as an RFC.
> 
>  drivers/dma/dmaengine.c   |   14 ++++++++------
>  include/linux/dmaengine.h |   16 ++++++++++++----
>  2 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 139d418..0eb03b8 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -204,10 +204,11 @@ static void balance_ref_count(struct dma_chan *chan)
>  /**
>   * dma_chan_get - try to grab a dma channel's parent driver module
>   * @chan - channel to grab
> + * @slave - optional DMA slave specification
>   *
>   * Must be called under dma_list_mutex
>   */
> -static int dma_chan_get(struct dma_chan *chan)
> +static int dma_chan_get(struct dma_chan *chan, struct dma_slave_desc *slave)
>  {
>  	struct module *owner = dma_chan_to_owner(chan);
>  
> @@ -220,7 +221,7 @@ static int dma_chan_get(struct dma_chan *chan)
>  
>  	/* allocate upon first client reference */
>  	if (chan->client_count == 1) {
> -		int desc_cnt = chan->device->device_alloc_chan_resources(chan);
> +		int desc_cnt = chan->device->device_alloc_chan_resources(chan, slave);
>  
>  		if (desc_cnt < 0) {
>  			chan->client_count = 0;
> @@ -482,7 +483,8 @@ static struct dma_chan *private_candidate(dma_cap_mask_t *mask, struct dma_devic
>   * @fn: optional callback to disposition available channels
>   * @fn_param: opaque parameter to pass to dma_filter_fn
>   */
> -struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param)
> +struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param,
> +				       struct dma_slave_desc *slave)
>  {
>  	struct dma_device *device, *_d;
>  	struct dma_chan *chan = NULL;
> @@ -500,7 +502,7 @@ struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, v
>  			 */
>  			dma_cap_set(DMA_PRIVATE, device->cap_mask);
>  			device->privatecnt++;
> -			err = dma_chan_get(chan);
> +			err = dma_chan_get(chan, slave);
>  
>  			if (err == -ENODEV) {
>  				pr_debug("%s: %s module removed\n", __func__,
> @@ -555,7 +557,7 @@ void dmaengine_get(void)
>  		if (dma_has_cap(DMA_PRIVATE, device->cap_mask))
>  			continue;
>  		list_for_each_entry(chan, &device->channels, device_node) {
> -			err = dma_chan_get(chan);
> +			err = dma_chan_get(chan, NULL);
>  			if (err == -ENODEV) {
>  				/* module removed before we could use it */
>  				list_del_rcu(&device->global_node);
> @@ -762,7 +764,7 @@ int dma_async_device_register(struct dma_device *device)
>  			/* if clients are already waiting for channels we need
>  			 * to take references on their behalf
>  			 */
> -			if (dma_chan_get(chan) == -ENODEV) {
> +			if (dma_chan_get(chan, NULL) == -ENODEV) {
>  				/* note we can only get here for the first
>  				 * channel as the remaining channels are
>  				 * guaranteed to get a reference
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index 679b349..8164007 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -412,6 +412,10 @@ struct dma_async_tx_descriptor {
>  #endif
>  };
>  
> +struct dma_slave_desc {
> +	unsigned int id;
> +};
> +
>  #ifndef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
>  static inline void txd_lock(struct dma_async_tx_descriptor *txd)
>  {
> @@ -541,7 +545,8 @@ struct dma_device {
>  	int dev_id;
>  	struct device *dev;
>  
> -	int (*device_alloc_chan_resources)(struct dma_chan *chan);
> +	int (*device_alloc_chan_resources)(struct dma_chan *chan,
> +					   struct dma_slave_desc *slave);
>  	void (*device_free_chan_resources)(struct dma_chan *chan);
>  
>  	struct dma_async_tx_descriptor *(*device_prep_dma_memcpy)(
> @@ -922,7 +927,8 @@ enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie);
>  #ifdef CONFIG_DMA_ENGINE
>  enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx);
>  void dma_issue_pending_all(void);
> -struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
> +struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param,
> +				       struct dma_slave_desc *slave);
>  void dma_release_channel(struct dma_chan *chan);
>  #else
>  static inline enum dma_status dma_wait_for_async_tx(struct dma_async_tx_descriptor *tx)
> @@ -933,7 +939,7 @@ static inline void dma_issue_pending_all(void)
>  {
>  }
>  static inline struct dma_chan *__dma_request_channel(dma_cap_mask_t *mask,
> -					      dma_filter_fn fn, void *fn_param)
> +		dma_filter_fn fn, void *fn_param, struct dma_slave_desc *slave)
>  {
>  	return NULL;
>  }
> @@ -948,7 +954,9 @@ int dma_async_device_register(struct dma_device *device);
>  void dma_async_device_unregister(struct dma_device *device);
>  void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
>  struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
> -#define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
> +#define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y, NULL)
> +#define dma_request_slave_channel(mask, x, y, id) __dma_request_channel(&(mask), \
> +									x, y, id)
>  
>  /* --- Helper iov-locking functions --- */
>  
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
