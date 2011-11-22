Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1KVTaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:30:05 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:47515 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab1KVTaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:30:03 -0500
X-Greylist: delayed 1836 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Nov 2011 14:30:03 EST
Date: Tue, 22 Nov 2011 10:59:25 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: b29237@freescale.com
Cc: dan.j.williams@intel.com, leoli@freescale.com, zw@zh-kernel.org,
        vinod.koul@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] fsldma: fix performance degradation by optimizing
 spinlock use.
Message-ID: <20111122185924.GA23323@ovro.caltech.edu>
References: <1321937705-19587-1-git-send-email-b29237@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321937705-19587-1-git-send-email-b29237@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Tue, 22 Nov 2011 10:59:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:55:05PM +0800, b29237@freescale.com wrote:
> From: Forrest Shi <b29237@freescale.com>
> 
>     dma status check function fsl_tx_status is heavily called in
>     a tight loop and the desc lock in fsl_tx_status contended by
>     the dma status update function. this caused the dma performance
>     degrades much.
> 
>     this patch releases the lock in the fsl_tx_status function.
>     I believe it has no neglect impact on the following call of
>     dma_async_is_complete(...).
> 
>     we can see below three conditions will be identified as success
>     a)  x < complete < use
>     b)  x < complete+N < use+N
>     c)  x < complete < use+N
>     here complete is the completed_cookie, use is the last_used
>     cookie, x is the querying cookie, N is MAX cookie
> 
>     when chan->completed_cookie is being read, the last_used may
>     be incresed. Anyway it has no neglect impact on the dma status
>     decision.
> 
>     Signed-off-by: Forrest Shi <xuelin.shi@freescale.com>
> ---
>  drivers/dma/fsldma.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index 8a78154..1dca56f 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -986,15 +986,10 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
>  	struct fsldma_chan *chan = to_fsl_chan(dchan);
>  	dma_cookie_t last_complete;
>  	dma_cookie_t last_used;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&chan->desc_lock, flags);
>  

This will cause a bug. See below for a detailed explanation. You need
this instead:

	/*
	 * On an SMP system, we must ensure that this CPU has seen the
	 * memory accesses performed by another CPU under the
	 * chan->desc_lock spinlock.
	 */
	smp_mb();
>  	last_complete = chan->completed_cookie;
>  	last_used = dchan->cookie;
>  
> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> -
>  	dma_set_tx_state(txstate, last_complete, last_used, 0);
>  	return dma_async_is_complete(cookie, last_complete, last_used);
>  }

Facts:
- dchan->cookie is the same member as chan->common.cookie (same memory location)
- chan->common.cookie is the "last allocated cookie for a pending transaction"
- chan->completed_cookie is the "last completed transaction"

I have replaced "dchan->cookie" with "chan->common.cookie" in the below
explanation, to keep everything referenced from the same structure.

Variable usage before your change. Everything is used locked.
- RW chan->common.cookie		(fsl_dma_tx_submit)
- R  chan->common.cookie		(fsl_tx_status)
- R  chan->completed_cookie		(fsl_tx_status)
- W  chan->completed_cookie		(dma_do_tasklet)

Variable usage after your change:
- RW chan->common.cookie		LOCKED
- R  chan->common.cookie		NO LOCK
- R  chan->completed_cookie		NO LOCK
- W  chan->completed_cookie             LOCKED

What if we assume that you have a 2 CPU system (such as a P2020). After
your changes, one possible sequence is:

=== CPU1 - allocate + submit descriptor: fsl_dma_tx_submit() ===
spin_lock_irqsave
descriptor->cookie = 20		(x in your example)
chan->common.cookie = 20	(used in your example)
spin_unlock_irqrestore

=== CPU2 - immediately calls fsl_tx_status() ===
chan->common.cookie == 19
chan->completed_cookie == 19
descriptor->cookie == 20

Since we don't have locks anymore, CPU2 may not have seen the write to
chan->common.cookie yet.

Also assume that the DMA hardware has not started processing the
transaction yet. Therefore dma_do_tasklet() has not been called, and
chan->completed_cookie has not been updated.

In this case, dma_async_is_complete() (on CPU2) returns DMA_SUCCESS,
even though the DMA operation has not succeeded. The DMA operation has
not even started yet!

The smp_mb() fixes this, since it forces CPU2 to have seen all memory
operations that happened before CPU1 released the spinlock. Spinlocks
are implicit SMP memory barriers.

Therefore, the above example becomes:
smp_mb();
chan->common.cookie == 20
chan->completed_cookie == 19
descriptor->cookie == 20

Then dma_async_is_complete() returns DMA_IN_PROGRESS, which is correct.

Thanks,
Ira
