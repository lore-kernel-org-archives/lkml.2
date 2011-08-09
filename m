Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1HIPic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:38:32 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57122 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab1HIPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:38:31 -0400
Date: Tue, 9 Aug 2011 17:38:26 +0200
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <msnitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch] block: properly handle flush/fua requests in
 blk_insert_cloned_request
Message-ID: <20110809153826.GB23842@htj.dyndns.org>
References: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y5z2eibl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 09, 2011 at 11:05:34AM -0400, Jeff Moyer wrote:
> @@ -1708,6 +1710,21 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
>  	    should_fail_request(&rq->rq_disk->part0, blk_rq_bytes(rq)))
>  		return -EIO;
>  
> +	/*
> +	 * Check the cmd_flags against the flush flags of the underlying
> +	 * request_queue and resolve any differences.
> +	 */
> +	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) {
> +		if (!(q->flush_flags & REQ_FLUSH))
> +			rq->cmd_flags &= ~REQ_FLUSH;
> +		if (!(q->flush_flags & REQ_FUA))
> +			rq->cmd_flags &= ~REQ_FUA;
> +		if (!(rq->cmd_flags & REQ_FLUSH) && !blk_rq_sectors(rq)) {
> +			blk_end_bidi_request(rq, 0, 0, 0);
> +			return 0;
> +		}
> +	}
> +

I'm a bit confused.  We still need ELEVATOR_INSERT_FLUSH fix for
insertion paths, right?  Or is blk_insert_cloned_request() supposed to
used only by request based dm which lives under the elevator?  If so,
it would be great to make that explicit in the comment.  Maybe just
renaming it to blk_insert_dm_cloned_request() would be better as it
wouldn't be safe for other cases anyway.

> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 6395692..4fe753f 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -168,7 +168,7 @@ enum rq_flag_bits {
>  #define REQ_COMMON_MASK \
>  	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_DISCARD | \
>  	 REQ_NOIDLE | REQ_FLUSH | REQ_FUA | REQ_SECURE)
> -#define REQ_CLONE_MASK		REQ_COMMON_MASK
> +#define REQ_CLONE_MASK		(REQ_COMMON_MASK | REQ_FLUSH_SEQ)

Given the weirdness, I think it deserves fat comment on why
REQ_FLUSH_SEQ is necessary.

Thanks.

-- 
tejun
