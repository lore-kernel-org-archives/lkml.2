Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1IPIIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:08:47 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52693 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab1IPIIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:08:44 -0400
Date: Fri, 16 Sep 2011 10:08:37 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers/block/xen-blkback/blkback.c: take size  of
 pointed value, not pointer
In-Reply-To: <4E7319010200007800056727@nat28.tlf.novell.com>
Message-ID: <Pine.LNX.4.64.1109161008210.8543@pc-004.diku.dk>
References: <1316156255-19509-1-git-send-email-julia@diku.dk>
 <4E7319010200007800056727@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think a better fix for this is to use kzalloc() properly here:

Indeed, it seems like a much better idea :)

julia

> Subject: xen-blkback: use kzalloc() in favor of kmalloc()+memset()
> 
> This fixes the problem of three of those four memset()-s having
> improper size arguments passed: Sizeof a pointer-typed expression
> returns the size of the pointer, not that of the pointed to data.
> 
> It also reverts using kmalloc() instead of kzalloc() for the allocation
> of the pending grant handles array, as that array gets fully
> initialized in a subsequent loop.
> 
> Reported-by: Julia Lawall <julia@diku.dk>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  drivers/block/xen-blkback/blkback.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> --- 3.1-rc6/drivers/block/xen-blkback/blkback.c
> +++ 3.1-rc6-xen-blkback-kzalloc/drivers/block/xen-blkback/blkback.c
> @@ -765,9 +765,9 @@ static int __init xen_blkif_init(void)
>  
>  	mmap_pages = xen_blkif_reqs * BLKIF_MAX_SEGMENTS_PER_REQUEST;
>  
> -	blkbk->pending_reqs          = kmalloc(sizeof(blkbk->pending_reqs[0]) *
> +	blkbk->pending_reqs          = kzalloc(sizeof(blkbk->pending_reqs[0]) *
>  					xen_blkif_reqs, GFP_KERNEL);
> -	blkbk->pending_grant_handles = kzalloc(sizeof(blkbk->pending_grant_handles[0]) *
> +	blkbk->pending_grant_handles = kmalloc(sizeof(blkbk->pending_grant_handles[0]) *
>  					mmap_pages, GFP_KERNEL);
>  	blkbk->pending_pages         = kzalloc(sizeof(blkbk->pending_pages[0]) *
>  					mmap_pages, GFP_KERNEL);
> @@ -790,8 +790,6 @@ static int __init xen_blkif_init(void)
>  	if (rc)
>  		goto failed_init;
>  
> -	memset(blkbk->pending_reqs, 0, sizeof(blkbk->pending_reqs));
> -
>  	INIT_LIST_HEAD(&blkbk->pending_free);
>  	spin_lock_init(&blkbk->pending_free_lock);
>  	init_waitqueue_head(&blkbk->pending_free_wq);
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
