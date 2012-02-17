Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2BQV6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab2BQV6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:58:23 -0500
Date: Fri, 17 Feb 2012 16:58:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] block: make blk-throttle preserve the issuing task
 on delayed bios
Message-ID: <20120217215814.GH26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329431878-28300-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:37:58PM -0800, Tejun Heo wrote:
> Make blk-throttle call bio_associate_current() on bios being delayed
> such that they get issued to block layer with the original io_context.
> This allows stacking blk-throttle and cfq-iosched propio policies.
> bios will always be issued with the correct ioc and blkcg whether it
> gets delayed by blk-throttle or not.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/blk-throttle.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index a7c8e0b..ad8e16b 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -894,6 +894,9 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
>  		goto out;
>  	}
>  
> +	/* bio_associate_current() needs ioc, try creating */
> +	create_io_context(GFP_ATOMIC, q->node);
> +
>  	/*
>  	 * A throtl_grp pointer retrieved under rcu can be used to access
>  	 * basic fields like stats and io rates. If a group has no rules,
> @@ -958,6 +961,7 @@ queue_bio:
>  			tg->io_disp[rw], tg->iops[rw],
>  			tg->nr_queued[READ], tg->nr_queued[WRITE]);
>  
> +	bio_associate_current(bio);

blk-throttle is just one of places where we lose submitter's context info.
There are others too.

As Kent said, doing this at more generic level will probably make sense.
I think dm layer also might benefit from it. We had issues with losing
this process context info while bio is being submitted with a helper thread.

https://lkml.org/lkml/2010/10/24/59

But I guess this will require some changes at dm layer too so that it
takes extra bio->ioc and bio->blkcg references at cloning time.

Thanks
Vivek
