Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0H3N27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:28:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab0H3N26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:28:58 -0400
Date: Mon, 30 Aug 2010 09:28:36 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Message-ID: <20100830132836.GB5283@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283162296-13650-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30 2010 at  5:58am -0400,
Tejun Heo <tj@kernel.org> wrote:

> This patch converts request-based dm to support the new REQ_FLUSH/FUA.
...
> This patch rips out special flush code path and deals handles
> REQ_FLUSH/FUA requests the same way as other requests.  The only
> special treatment is that REQ_FLUSH requests use the block address 0
> when finding target, which is enough for now.

Looks very comparable to the patch I prepared but I have 2 observations
below (based on my findings from testing my patch).

> @@ -1562,22 +1483,15 @@ static int setup_clone(struct request *clone, struct request *rq,
>  {
>  	int r;
>  
> -	if (dm_rq_is_flush_request(rq)) {
> -		blk_rq_init(NULL, clone);
> -		clone->cmd_type = REQ_TYPE_FS;
> -		clone->cmd_flags |= (REQ_HARDBARRIER | WRITE);
> -	} else {
> -		r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
> -				      dm_rq_bio_constructor, tio);
> -		if (r)
> -			return r;
> -
> -		clone->cmd = rq->cmd;
> -		clone->cmd_len = rq->cmd_len;
> -		clone->sense = rq->sense;
> -		clone->buffer = rq->buffer;
> -	}
> +	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
> +			      dm_rq_bio_constructor, tio);
> +	if (r)
> +		return r;
>  
> +	clone->cmd = rq->cmd;
> +	clone->cmd_len = rq->cmd_len;
> +	clone->sense = rq->sense;
> +	clone->buffer = rq->buffer;
>  	clone->end_io = end_clone_request;
>  	clone->end_io_data = tio;

blk_rq_prep_clone() of a REQ_FLUSH request will result in a
rq_data_dir(clone) of read.

I still had the following:

        if (rq->cmd_flags & REQ_FLUSH) {
                blk_rq_init(NULL, clone);
                clone->cmd_type = REQ_TYPE_FS;
                /* without this the clone has a rq_data_dir of 0 */
                clone->cmd_flags |= WRITE_FLUSH;
        } else {
                r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
                                      dm_rq_bio_constructor, tio);
                ...

Request-based DM's REQ_FLUSH still works without this special casing but
I figured I'd raise this to ask: what is the proper rq_data_dir() is for
a REQ_FLUSH?

> @@ -1709,15 +1621,12 @@ static void dm_request_fn(struct request_queue *q)
>  		if (!rq)
>  			goto plug_and_out;
>  
> -		if (unlikely(dm_rq_is_flush_request(rq))) {
> -			BUG_ON(md->flush_request);
> -			md->flush_request = rq;
> -			blk_start_request(rq);
> -			queue_work(md->wq, &md->barrier_work);
> -			goto out;
> -		}
> +		/* always use block 0 to find the target for flushes for now */
> +		pos = 0;
> +		if (!(rq->cmd_flags & REQ_FLUSH))
> +			pos = blk_rq_pos(rq);
>  
> -		ti = dm_table_find_target(map, blk_rq_pos(rq));
> +		ti = dm_table_find_target(map, pos);

I added the following here: BUG_ON(!dm_target_is_valid(ti));

>  		if (ti->type->busy && ti->type->busy(ti))
>  			goto plug_and_out;

I also needed to avoid the ->busy call for REQ_FLUSH:

                if (!(rq->cmd_flags & REQ_FLUSH)) {
                        ti = dm_table_find_target(map, blk_rq_pos(rq));
                        BUG_ON(!dm_target_is_valid(ti));
                        if (ti->type->busy && ti->type->busy(ti))
                                goto plug_and_out;
                } else {
                        /* rq-based only ever has one target! leverage this for FLUSH */
                        ti = dm_table_get_target(map, 0);
                }

If I allowed ->busy to be called for REQ_FLUSH it would result in a
deadlock.  I haven't identified where/why yet.

Other than these remaining issues this patch looks good.

Thanks,
Mike
