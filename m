Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab1CIObM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:31:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab1CIObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:31:10 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] blktrace: Use rq->cmd_flags directly in blk_add_trace_rq.
References: <1299219358-17507-1-git-send-email-tm@tao.ma>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 09 Mar 2011 09:31:05 -0500
In-Reply-To: <1299219358-17507-1-git-send-email-tm@tao.ma> (Tao Ma's message
	of "Fri, 4 Mar 2011 14:15:58 +0800")
Message-ID: <x49k4g8nz6e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tm@tao.ma> writes:

> From: Tao Ma <boyu.mt@taobao.com>
>
> In blk_add_trace_rq, we only chose the minor 2 bits from
> request's cmd_flags and did some check for discard.
> so most of other flags(e.g, REQ_SYNC) are missing.
>
> For example, with a sync write after blkparse we get:
>   8,16   1        1     0.001776503  7509  A  WS 1349632 + 1024 <- (8,17) 1347584
>   8,16   1        2     0.001776813  7509  Q  WS 1349632 + 1024 [dd]
>   8,16   1        3     0.001780395  7509  G  WS 1349632 + 1024 [dd]
>   8,16   1        5     0.001783186  7509  I   W 1349632 + 1024 [dd]
>   8,16   1       11     0.001816987  7509  D   W 1349632 + 1024 [dd]
>   8,16   0        2     0.006218192     0  C   W 1349632 + 1024 [0]
>
> Since now we have integrated the flags of both bio and request,
> it is safe to pass rq->cmd_flags directly to __blk_add_trace.
>
> With this patch, after a sync write we get:
>   8,16   1        1     0.001776900  5425  A  WS 1189888 + 1024 <- (8,17) 1187840
>   8,16   1        2     0.001777179  5425  Q  WS 1189888 + 1024 [dd]
>   8,16   1        3     0.001780797  5425  G  WS 1189888 + 1024 [dd]
>   8,16   1        5     0.001783402  5425  I  WS 1189888 + 1024 [dd]
>   8,16   1       11     0.001817468  5425  D  WS 1189888 + 1024 [dd]
>   8,16   0        2     0.005640709     0  C  WS 1189888 + 1024 [0]
>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  kernel/trace/blktrace.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index cbafed7..7aa40f8 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -703,28 +703,21 @@ void blk_trace_shutdown(struct request_queue *q)
>   *
>   **/
>  static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
> -				    u32 what)
> +			     u32 what)
>  {
>  	struct blk_trace *bt = q->blk_trace;
> -	int rw = rq->cmd_flags & 0x03;
>  
>  	if (likely(!bt))
>  		return;
>  
> -	if (rq->cmd_flags & REQ_DISCARD)
> -		rw |= REQ_DISCARD;
> -
> -	if (rq->cmd_flags & REQ_SECURE)
> -		rw |= REQ_SECURE;
> -
>  	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
>  		what |= BLK_TC_ACT(BLK_TC_PC);
> -		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rw,
> +		__blk_add_trace(bt, 0, blk_rq_bytes(rq), rq->cmd_flags,
>  				what, rq->errors, rq->cmd_len, rq->cmd);
>  	} else  {
>  		what |= BLK_TC_ACT(BLK_TC_FS);
> -		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq), rw,
> -				what, rq->errors, 0, NULL);
> +		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
> +				rq->cmd_flags, what, rq->errors, 0, NULL);
>  	}
>  }

Looks like a fine cleanup to me.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
