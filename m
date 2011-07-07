Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1GGCkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 22:40:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35238 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1GGCkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 22:40:49 -0400
Subject: Re: [PATCH] dmaengine/coh901318: fix slave submission semantics
From: Vinod Koul <vkoul@infradead.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1309531648-16163-1-git-send-email-linus.walleij@stericsson.com>
References: <1309531648-16163-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Thu, 07 Jul 2011 07:39:46 +0530
Message-ID: <1310004586.20150.17.camel@psiaudioba-mobl1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 16:47 +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> While testing Per Forlins MMC speed improvements I noticed a
> semantic bug in the COH901318 driver: it will write to channel
> registers in the prep_slave_sg() function, instead of deferring
> it to later, breaking the assumption from the drivers to be able
> to queue up new jobs while another job is running. Fix this by
> storing up the initial register writes in the job descriptors
> and write them to hardware when we process the descriptor
> instead. Now the stress tests work.
> 
> Acked-by: Per Forlin <per.forlin@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
Looks good, it is in my queue...

>  drivers/dma/coh901318.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> index af8c0b5..a7fca16 100644
> --- a/drivers/dma/coh901318.c
> +++ b/drivers/dma/coh901318.c
> @@ -40,6 +40,8 @@ struct coh901318_desc {
>  	struct coh901318_lli *lli;
>  	enum dma_data_direction dir;
>  	unsigned long flags;
> +	u32 head_config;
> +	u32 head_ctrl;
>  };
>  
>  struct coh901318_base {
> @@ -660,6 +662,9 @@ static struct coh901318_desc *coh901318_queue_start(struct coh901318_chan *cohc)
>  
>  		coh901318_desc_submit(cohc, cohd);
>  
> +		/* Program the transaction head */
> +		coh901318_set_conf(cohc, cohd->head_config);
> +		coh901318_set_ctrl(cohc, cohd->head_ctrl);
>  		coh901318_prep_linked_list(cohc, cohd->lli);
>  
>  		/* start dma job on this channel */
> @@ -1090,8 +1095,6 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  	} else
>  		goto err_direction;
>  
> -	coh901318_set_conf(cohc, config);
> -
>  	/* The dma only supports transmitting packages up to
>  	 * MAX_DMA_PACKET_SIZE. Calculate to total number of
>  	 * dma elemts required to send the entire sg list
> @@ -1128,16 +1131,18 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
>  	if (ret)
>  		goto err_lli_fill;
>  
> -	/*
> -	 * Set the default ctrl for the channel to the one from the lli,
> -	 * things may have changed due to odd buffer alignment etc.
> -	 */
> -	coh901318_set_ctrl(cohc, lli->control);
>  
>  	COH_DBG(coh901318_list_print(cohc, lli));
>  
>  	/* Pick a descriptor to handle this transfer */
>  	cohd = coh901318_desc_get(cohc);
> +	cohd->head_config = config;
> +	/*
> +	 * Set the default head ctrl for the channel to the one from the
> +	 * lli, things may have changed due to odd buffer alignment
> +	 * etc.
> +	 */
> +	cohd->head_ctrl = lli->control;
>  	cohd->dir = direction;
>  	cohd->flags = flags;
>  	cohd->desc.tx_submit = coh901318_tx_submit;

-- 
~Vinod Koul
Intel Corp.

