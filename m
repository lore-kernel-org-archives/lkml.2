Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab0DAQaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:30:18 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:28895 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab0DAQaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:30:14 -0400
Date: Thu, 1 Apr 2010 11:33:56 -0500
From: scameron@beardog.cce.hp.com
To: Dan Carpenter <error27@gmail.com>, Mike Miller <mike.miller@hp.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] cciss: unlock on error path
Message-ID: <20100401163356.GQ12755@beardog.cce.hp.com>
References: <20100401155404.GD5265@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401155404.GD5265@bicker>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 06:54:04PM +0300, Dan Carpenter wrote:
> We take the spin_lock again in fail_all_cmds() so we need to unlock
> here.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> This was found by a static checker and I don't have the hardware myself.
> Please review carefully.
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 9e3af30..eb5ff05 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3341,6 +3341,7 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
>  					printk(KERN_WARNING
>  					       "cciss: controller cciss%d failed, stopping.\n",
>  					       h->ctlr);
> +					spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
>  					fail_all_cmds(h->ctlr);
>  					return IRQ_HANDLED;
>  				}

Looks ok to me.  (Seems like I've seen this patch before).
It's pretty much a paranoid "never happen" case anyway.
To hit this, the hardware would have to return a tag that was marked as 
containing an index, and then the index would have to be out of bounds,
so either, it would have to be broken driver, broken firmware or
broken hardware.

Really, one of these days, the interrupt handler should probably be
cleaned up to be more like what's in the hpsa driver.

-- steve

