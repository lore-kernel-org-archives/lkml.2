Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2FNDS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:18:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:51332 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab2FNDS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:18:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="152917163"
Subject: Re: [PATCH] DMA: PL330: Fix racy mutex unlock
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        Jassi Brar <jaswinder.singh@linaro.org>
In-Reply-To: <1339596420-18127-1-git-send-email-javi.merino@arm.com>
References: <1339596420-18127-1-git-send-email-javi.merino@arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jun 2012 08:41:06 +0530
Message-ID: <1339643466.1927.1638.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 15:07 +0100, Javi Merino wrote:
> pl330_update() stores a pointer to the thrd->req that finished, which
> contains a pointer to the corresponding pl330_req.  This is done with
> the pl330_lock held.  Then, it iterates through the req_done list,
> calling the callback for each of the requests that are done.  The
> problem is that the driver releases the lock before calling the
> callback for each of the callbacks.  pl330_submit_req() running in
> another processor can then acquire the lock and insert another request
> in one of the thrd->req that hasn't been processed yet, replacing the
> pointer to pl330_req there.  When the callback returns in
> pl330_update() and the next rqdone is popped from the list, it
> dereferences the pl330_req pointer to the just scheduled pl330_req,
> instead of the one that has finished, calling pl330 with the wrong r.
> 
> This patch fixes this by storing the pointer to pl330_req directly in
> the list.
> 
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
Applied, thanks

> ---
>  drivers/dma/pl330.c |   26 ++++++++++----------------
>  1 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index cbcc28e..b1d93b0 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -392,6 +392,8 @@ struct pl330_req {
>  	struct pl330_reqcfg *cfg;
>  	/* Pointer to first xfer in the request. */
>  	struct pl330_xfer *x;
> +	/* Hook to attach to DMAC's list of reqs with due callback */
> +	struct list_head rqd;
>  };
>  
>  /*
> @@ -461,8 +463,6 @@ struct _pl330_req {
>  	/* Number of bytes taken to setup MC for the req */
>  	u32 mc_len;
>  	struct pl330_req *r;
> -	/* Hook to attach to DMAC's list of reqs with due callback */
> -	struct list_head rqd;
>  };
>  
>  /* ToBeDone for tasklet */
> @@ -1683,7 +1683,7 @@ static void pl330_dotask(unsigned long data)
>  /* Returns 1 if state was updated, 0 otherwise */
>  static int pl330_update(const struct pl330_info *pi)
>  {
> -	struct _pl330_req *rqdone;
> +	struct pl330_req *rqdone, *tmp;
>  	struct pl330_dmac *pl330;
>  	unsigned long flags;
>  	void __iomem *regs;
> @@ -1750,7 +1750,10 @@ static int pl330_update(const struct pl330_info *pi)
>  			if (active == -1) /* Aborted */
>  				continue;
>  
> -			rqdone = &thrd->req[active];
> +			/* Detach the req */
> +			rqdone = thrd->req[active].r;
> +			thrd->req[active].r = NULL;
> +
>  			mark_free(thrd, active);
>  
>  			/* Get going again ASAP */
> @@ -1762,20 +1765,11 @@ static int pl330_update(const struct pl330_info *pi)
>  	}
>  
>  	/* Now that we are in no hurry, do the callbacks */
> -	while (!list_empty(&pl330->req_done)) {
> -		struct pl330_req *r;
> -
> -		rqdone = container_of(pl330->req_done.next,
> -					struct _pl330_req, rqd);
> -
> -		list_del_init(&rqdone->rqd);
> -
> -		/* Detach the req */
> -		r = rqdone->r;
> -		rqdone->r = NULL;
> +	list_for_each_entry_safe(rqdone, tmp, &pl330->req_done, rqd) {
> +		list_del(&rqdone->rqd);
>  
>  		spin_unlock_irqrestore(&pl330->lock, flags);
> -		_callback(r, PL330_ERR_NONE);
> +		_callback(rqdone, PL330_ERR_NONE);
>  		spin_lock_irqsave(&pl330->lock, flags);
>  	}
>  


-- 
~Vinod

