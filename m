Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab2AKQpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:45:05 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:34637 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab2AKQpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:45:03 -0500
X-Greylist: delayed 1874 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jan 2012 11:45:03 EST
Date: Wed, 11 Jan 2012 08:13:47 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Shi Xuelin-B29237 <B29237@freescale.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]     fsldma: fix performance degradation by optimizing
 spinlock use.
Message-ID: <20120111161347.GA1430@ovro.caltech.edu>
References: <1324879263-11845-1-git-send-email-b29237@freescale.com>
 <DBB740589CE8814680DECFE34BE197AB1665A3@039-SN1MPN1-006.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBB740589CE8814680DECFE34BE197AB1665A3@039-SN1MPN1-006.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 11 Jan 2012 08:13:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 07:54:55AM +0000, Shi Xuelin-B29237 wrote:
> Hello Iris,
> 
> As we discussed in the previous patch, I add one smp_mb() in fsl_tx_status.
> In my testing with iozone, this smp_mb() could cause 1%~2% performance degradation.
> Anyway it is acceptable for me. Do you have any other comments?
> 

This patch looks fine to me.

Ira

> -----Original Message-----
> From: Shi Xuelin-B29237 
> Sent: 2011年12月26日 14:01
> To: iws@ovro.caltech.edu; vinod.koul@intel.com; dan.j.williams@intel.com; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Cc: Shi Xuelin-B29237
> Subject: [PATCH] fsldma: fix performance degradation by optimizing spinlock use.
> 
> From: Forrest shi <b29237@freescale.com>
> 
>     dma status check function fsl_tx_status is heavily called in
>     a tight loop and the desc lock in fsl_tx_status contended by
>     the dma status update function. this caused the dma performance
>     degrades much.
> 
>     this patch releases the lock in the fsl_tx_status function, and
>     introduce the smp_mb() to avoid possible memory inconsistency.
> 
>     Signed-off-by: Forrest Shi <xuelin.shi@freescale.com>
> ---
>  drivers/dma/fsldma.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index 8a78154..008fb5e 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -986,15 +986,11 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
>  	struct fsldma_chan *chan = to_fsl_chan(dchan);
>  	dma_cookie_t last_complete;
>  	dma_cookie_t last_used;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&chan->desc_lock, flags);
>  
> 	last_complete = chan->completed_cookie;
> +	smp_mb();
> 	last_used = dchan->cookie;
>  
> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
> -
>  	dma_set_tx_state(txstate, last_complete, last_used, 0);
>  	return dma_async_is_complete(cookie, last_complete, last_used); }
> --
> 1.7.0.4
> 
> 
