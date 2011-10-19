Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab1JSNob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 09:44:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab1JSNoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 09:44:30 -0400
Date: Wed, 19 Oct 2011 09:44:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        ni@google.com
Subject: Re: [PATCH 04/10] block: pass around REQ_* flags instead of broken
 down booleans during request alloc/free
Message-ID: <20111019134424.GC1140@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318998384-22525-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 09:26:18PM -0700, Tejun Heo wrote:
> blk_alloc_request() and freed_request() take different combinations of
> REQ_* @flags, @priv and @is_sync when @flags is superset of the latter
> two.  Make them take @flags only.  This cleans up the code a bit and
> will ease updating allocation related REQ_* flags.
> 
> This patch doesn't introduce any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-core.c |   36 +++++++++++++++++-------------------
>  1 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a995141..fafa669 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -575,7 +575,7 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
>  }
>  
>  static struct request *
> -blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
> +blk_alloc_request(struct request_queue *q, unsigned int flags, gfp_t gfp_mask)
>  {
>  	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
>  
> @@ -586,12 +586,10 @@ blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
>  
>  	rq->cmd_flags = flags | REQ_ALLOCED;
>  
> -	if (priv) {
> -		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
> -			mempool_free(rq, q->rq.rq_pool);
> -			return NULL;
> -		}
> -		rq->cmd_flags |= REQ_ELVPRIV;

Don't we need to set REQ_ELVPRIV in rq->cmd_flags in this new code?

> +	if ((flags & REQ_ELVPRIV) &&
> +	    unlikely(elv_set_request(q, rq, gfp_mask))) {
> +		mempool_free(rq, q->rq.rq_pool);
> +		return NULL;
>  	}

Thanks
Vivek
