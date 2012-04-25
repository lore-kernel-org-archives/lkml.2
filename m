Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2DYJlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:41:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:25630 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab2DYJlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:41:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145693804"
Subject: Re: [PATCH v2] dma: pl330: fix a couple of compilation warnings
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boojin Kim <boojin.kim@samsung.com>
In-Reply-To: <1333927579-16999-1-git-send-email-olof@lixom.net>
References: <1333919920-25481-1-git-send-email-olof@lixom.net>
	 <1333927579-16999-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 15:07:03 +0530
Message-ID: <1335346623.31825.120.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 16:26 -0700, Olof Johansson wrote:
> Move a couple of tests and do a minor refactor to avoid:
> 
> drivers/dma/pl330.c: In function 'pl330_probe':
> drivers/dma/pl330.c:2929:215: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> drivers/dma/pl330.c: In function 'pl330_tasklet':
> drivers/dma/pl330.c:2250:8: warning: 'pch' may be used uninitialized in this function [-Wuninitialized]
> drivers/dma/pl330.c:2228:25: note: 'pch' was declared here
> drivers/dma/pl330.c:2277:130: warning: 'pch' may be used uninitialized in this function [-Wuninitialized]
> drivers/dma/pl330.c:2260:25: note: 'pch' was declared here
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
Applied thanks

> ---
>  drivers/dma/pl330.c |   25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 282caf11..2ee6e23 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2225,12 +2225,9 @@ static inline void free_desc_list(struct list_head *list)
>  {
>  	struct dma_pl330_dmac *pdmac;
>  	struct dma_pl330_desc *desc;
> -	struct dma_pl330_chan *pch;
> +	struct dma_pl330_chan *pch = NULL;
>  	unsigned long flags;
>  
> -	if (list_empty(list))
> -		return;
> -
>  	/* Finish off the work list */
>  	list_for_each_entry(desc, list, node) {
>  		dma_async_tx_callback callback;
> @@ -2247,6 +2244,10 @@ static inline void free_desc_list(struct list_head *list)
>  		desc->pchan = NULL;
>  	}
>  
> +	/* pch will be unset if list was empty */
> +	if (!pch)
> +		return;
> +
>  	pdmac = pch->dmac;
>  
>  	spin_lock_irqsave(&pdmac->pool_lock, flags);
> @@ -2257,12 +2258,9 @@ static inline void free_desc_list(struct list_head *list)
>  static inline void handle_cyclic_desc_list(struct list_head *list)
>  {
>  	struct dma_pl330_desc *desc;
> -	struct dma_pl330_chan *pch;
> +	struct dma_pl330_chan *pch = NULL;
>  	unsigned long flags;
>  
> -	if (list_empty(list))
> -		return;
> -
>  	list_for_each_entry(desc, list, node) {
>  		dma_async_tx_callback callback;
>  
> @@ -2274,6 +2272,10 @@ static inline void handle_cyclic_desc_list(struct list_head *list)
>  			callback(desc->txd.callback_param);
>  	}
>  
> +	/* pch will be unset if list was empty */
> +	if (!pch)
> +		return;
> +
>  	spin_lock_irqsave(&pch->lock, flags);
>  	list_splice_tail_init(list, &pch->work_list);
>  	spin_unlock_irqrestore(&pch->lock, flags);
> @@ -2926,8 +2928,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	INIT_LIST_HEAD(&pd->channels);
>  
>  	/* Initialize channel parameters */
> -	num_chan = max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
> -			(u8)pi->pcfg.num_chan);
> +	if (pdat)
> +		num_chan = max_t(int, pdat->nr_valid_peri, pi->pcfg.num_chan);
> +	else
> +		num_chan = max_t(int, pi->pcfg.num_peri, pi->pcfg.num_chan);
> +
>  	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
>  
>  	for (i = 0; i < num_chan; i++) {


-- 
~Vinod

