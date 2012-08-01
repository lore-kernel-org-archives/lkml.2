Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab2HAQkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:40:42 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35785 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2HAQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:40:41 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2012 12:40:41 EDT
Date: Wed, 1 Aug 2012 09:31:25 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: qiang.liu@freescale.com
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, dan.j.williams@gmail.com,
        Vinod Koul <vinod.koul@intel.com>, herbert@gondor.hengli.com.au,
        Dan Williams <dan.j.williams@intel.com>, davem@davemloft.net
Subject: Re: [PATCH v5 4/6] fsl-dma: move the function ahead of its invoke
 function
Message-ID: <20120801163125.GB11359@ovro.caltech.edu>
References: <1343810983-25412-1-git-send-email-qiang.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343810983-25412-1-git-send-email-qiang.liu@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (ovro.ovro.caltech.edu); Wed, 01 Aug 2012 09:31:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 04:49:43PM +0800, qiang.liu@freescale.com wrote:
> From: Qiang Liu <qiang.liu@freescale.com>
> 
> Move the function fsldma_cleanup_descriptor() and fsl_chan_xfer_ld_queue()
> ahead of its invoke function for avoiding redundant definition.
> 
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---
>  drivers/dma/fsldma.c |  252 +++++++++++++++++++++++++-------------------------
>  1 files changed, 124 insertions(+), 128 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 87f52c0..bb883c0 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -400,9 +400,6 @@ out_splice:
>  	list_splice_tail_init(&desc->tx_list, &chan->ld_pending);
>  }
> 
> -static void fsldma_cleanup_descriptor(struct fsldma_chan *chan);
> -static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan);
> -

Please swap the order of this patch (patch 4/6) and the previous patch
(patch 3/6).

You added these lines in the patch 3/6 and deleted them here. If you
reverse the order of the patches, this doesn't happen.

Adding lines only to delete them in the next patch should be avoided.

>  /**
>   * fsldma_clean_completed_descriptor - free all descriptors which
>   * has been completed and acked
> @@ -519,6 +516,130 @@ fsldma_clean_running_descriptor(struct fsldma_chan *chan,
>  	return 0;
>  }
> 
> +/**
> + * fsl_chan_xfer_ld_queue - transfer any pending transactions
> + * @chan : Freescale DMA channel
> + *
> + * HARDWARE STATE: idle
> + * LOCKING: must hold chan->desc_lock
> + */
> +static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
> +{
> +	struct fsl_desc_sw *desc;
> +
> +	/*
> +	 * If the list of pending descriptors is empty, then we
> +	 * don't need to do any work at all
> +	 */
> +	if (list_empty(&chan->ld_pending)) {
> +		chan_dbg(chan, "no pending LDs\n");
> +		return;
> +	}
> +
> +	/*
> +	 * The DMA controller is not idle, which means that the interrupt
> +	 * handler will start any queued transactions when it runs after
> +	 * this transaction finishes
> +	 */
> +	if (!chan->idle) {
> +		chan_dbg(chan, "DMA controller still busy\n");
> +		return;
> +	}
> +
> +	/*
> +	 * If there are some link descriptors which have not been
> +	 * transferred, we need to start the controller
> +	 */
> +
> +	/*
> +	 * Move all elements from the queue of pending transactions
> +	 * onto the list of running transactions
> +	 */
> +	chan_dbg(chan, "idle, starting controller\n");
> +	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
> +	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
> +
> +	/*
> +	 * The 85xx DMA controller doesn't clear the channel start bit
> +	 * automatically at the end of a transfer. Therefore we must clear
> +	 * it in software before starting the transfer.
> +	 */
> +	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
> +		u32 mode;
> +
> +		mode = DMA_IN(chan, &chan->regs->mr, 32);
> +		mode &= ~FSL_DMA_MR_CS;
> +		DMA_OUT(chan, &chan->regs->mr, mode, 32);
> +	}
> +
> +	/*
> +	 * Program the descriptor's address into the DMA controller,
> +	 * then start the DMA transaction
> +	 */
> +	set_cdar(chan, desc->async_tx.phys);
> +	get_cdar(chan);
> +
> +	dma_start(chan);
> +	chan->idle = false;
> +}
> +
> +/**
> + * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
> + * @chan: Freescale DMA channel
> + * @desc: descriptor to cleanup and free
> + *
> + * This function is used on a descriptor which has been executed by the DMA
> + * controller. It will run any callbacks, submit any dependencies, and then
> + * free the descriptor.
> + */
> +static void fsldma_cleanup_descriptor(struct fsldma_chan *chan)
> +{
> +	struct fsl_desc_sw *desc, *_desc;
> +	dma_cookie_t cookie = 0;
> +	dma_addr_t curr_phys = get_cdar(chan);
> +	int idle = dma_is_idle(chan);
> +	int seen_current = 0;
> +
> +	fsldma_clean_completed_descriptor(chan);
> +
> +	/* Run the callback for each descriptor, in order */
> +	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
> +		/*
> +		 * do not advance past the current descriptor loaded into the
> +		 * hardware channel, subsequent descriptors are either in
> +		 * process or have not been submitted
> +		 */
> +		if (seen_current)
> +			break;
> +
> +		/*
> +		 * stop the search if we reach the current descriptor and the
> +		 * channel is busy
> +		 */
> +		if (desc->async_tx.phys == curr_phys) {
> +			seen_current = 1;
> +			if (!idle)
> +				break;
> +		}
> +
> +		cookie = fsldma_run_tx_complete_actions(desc, chan, cookie);
> +
> +		if (fsldma_clean_running_descriptor(chan, desc))
> +			break;
> +	}
> +
> +	/*
> +	 * Start any pending transactions automatically
> +	 *
> +	 * In the ideal case, we keep the DMA controller busy while we go
> +	 * ahead and free the descriptors below.
> +	 */
> +	fsl_chan_xfer_ld_queue(chan);
> +
> +	if (cookie > 0)
> +		chan->common.completed_cookie = cookie;
> +}
> +
>  static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>  {
>  	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
> @@ -932,131 +1053,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>  }
> 
>  /**
> - * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
> - * @chan: Freescale DMA channel
> - * @desc: descriptor to cleanup and free
> - *
> - * This function is used on a descriptor which has been executed by the DMA
> - * controller. It will run any callbacks, submit any dependencies, and then
> - * free the descriptor.
> - */
> -static void fsldma_cleanup_descriptor(struct fsldma_chan *chan)
> -{
> -	struct fsl_desc_sw *desc, *_desc;
> -	dma_cookie_t cookie = 0;
> -	dma_addr_t curr_phys = get_cdar(chan);
> -	int idle = dma_is_idle(chan);
> -	int seen_current = 0;
> -
> -	fsldma_clean_completed_descriptor(chan);
> -
> -	/* Run the callback for each descriptor, in order */
> -	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
> -		/*
> -		 * do not advance past the current descriptor loaded into the
> -		 * hardware channel, subsequent descriptors are either in
> -		 * process or have not been submitted
> -		 */
> -		if (seen_current)
> -			break;
> -
> -		/*
> -		 * stop the search if we reach the current descriptor and the
> -		 * channel is busy
> -		 */
> -		if (desc->async_tx.phys == curr_phys) {
> -			seen_current = 1;
> -			if (!idle)
> -				break;
> -		}
> -
> -		cookie = fsldma_run_tx_complete_actions(desc, chan, cookie);
> -
> -		if (fsldma_clean_running_descriptor(chan, desc))
> -			break;
> -
> -	}
> -
> -	/*
> -	 * Start any pending transactions automatically
> -	 *
> -	 * In the ideal case, we keep the DMA controller busy while we go
> -	 * ahead and free the descriptors below.
> -	 */
> -	fsl_chan_xfer_ld_queue(chan);
> -
> -	if (cookie > 0)
> -		chan->common.completed_cookie = cookie;
> -}
> -
> -/**
> - * fsl_chan_xfer_ld_queue - transfer any pending transactions
> - * @chan : Freescale DMA channel
> - *
> - * HARDWARE STATE: idle
> - * LOCKING: must hold chan->desc_lock
> - */
> -static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
> -{
> -	struct fsl_desc_sw *desc;
> -
> -	/*
> -	 * If the list of pending descriptors is empty, then we
> -	 * don't need to do any work at all
> -	 */
> -	if (list_empty(&chan->ld_pending)) {
> -		chan_dbg(chan, "no pending LDs\n");
> -		return;
> -	}
> -
> -	/*
> -	 * The DMA controller is not idle, which means that the interrupt
> -	 * handler will start any queued transactions when it runs after
> -	 * this transaction finishes
> -	 */
> -	if (!chan->idle) {
> -		chan_dbg(chan, "DMA controller still busy\n");
> -		return;
> -	}
> -
> -	/*
> -	 * If there are some link descriptors which have not been
> -	 * transferred, we need to start the controller
> -	 */
> -
> -	/*
> -	 * Move all elements from the queue of pending transactions
> -	 * onto the list of running transactions
> -	 */
> -	chan_dbg(chan, "idle, starting controller\n");
> -	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
> -	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
> -
> -	/*
> -	 * The 85xx DMA controller doesn't clear the channel start bit
> -	 * automatically at the end of a transfer. Therefore we must clear
> -	 * it in software before starting the transfer.
> -	 */
> -	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
> -		u32 mode;
> -
> -		mode = DMA_IN(chan, &chan->regs->mr, 32);
> -		mode &= ~FSL_DMA_MR_CS;
> -		DMA_OUT(chan, &chan->regs->mr, mode, 32);
> -	}
> -
> -	/*
> -	 * Program the descriptor's address into the DMA controller,
> -	 * then start the DMA transaction
> -	 */
> -	set_cdar(chan, desc->async_tx.phys);
> -	get_cdar(chan);
> -
> -	dma_start(chan);
> -	chan->idle = false;
> -}
> -
> -/**
>   * fsl_dma_memcpy_issue_pending - Issue the DMA start command
>   * @chan : Freescale DMA channel
>   */
> --
> 1.7.5.1
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
