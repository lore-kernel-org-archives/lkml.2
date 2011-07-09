Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1GILCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 07:02:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41211
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab1GILCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 07:02:42 -0400
Date: Sat, 9 Jul 2011 07:02:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin TerAvest <teravest@google.com>
Cc: vgoyal@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH v2] cfq: Remove special treatment for metadata rqs.
Message-ID: <20110709110238.GA29082@infradead.org>
References: <1308603796-11074-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308603796-11074-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, any plans to pick this up?  Beeing able to just tag requests
as metadata without side effects would really help us fs developers
to be able to make more sense of blktrace output.

On Mon, Jun 20, 2011 at 02:03:16PM -0700, Justin TerAvest wrote:
> There is no consistency among filesystems from what bios (or requests)
> are marked as being metadata. It's interesting to expose this in traces,
> but we shouldn't schedule the requests differently based on whether or
> not they're marked as being metadata.
> 
> Signed-off-by: Justin TerAvest <teravest@google.com>
> ---
>  block/cfq-iosched.c |   18 ------------------
>  1 files changed, 0 insertions(+), 18 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 3d403a1..aecfdd0 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -129,8 +129,6 @@ struct cfq_queue {
>  	unsigned long slice_end;
>  	long slice_resid;
>  
> -	/* pending metadata requests */
> -	int meta_pending;
>  	/* number of requests that are on the dispatch list or inside driver */
>  	int dispatched;
>  
> @@ -670,9 +668,6 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
>  	if (rq_is_sync(rq1) != rq_is_sync(rq2))
>  		return rq_is_sync(rq1) ? rq1 : rq2;
>  
> -	if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_META)
> -		return rq1->cmd_flags & REQ_META ? rq1 : rq2;
> -
>  	s1 = blk_rq_pos(rq1);
>  	s2 = blk_rq_pos(rq2);
>  
> @@ -1593,10 +1588,6 @@ static void cfq_remove_request(struct request *rq)
>  	cfqq->cfqd->rq_queued--;
>  	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
>  					rq_data_dir(rq), rq_is_sync(rq));
> -	if (rq->cmd_flags & REQ_META) {
> -		WARN_ON(!cfqq->meta_pending);
> -		cfqq->meta_pending--;
> -	}
>  }
>  
>  static int cfq_merge(struct request_queue *q, struct request **req,
> @@ -3331,13 +3322,6 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  		return true;
>  
>  	/*
> -	 * So both queues are sync. Let the new request get disk time if
> -	 * it's a metadata request and the current queue is doing regular IO.
> -	 */
> -	if ((rq->cmd_flags & REQ_META) && !cfqq->meta_pending)
> -		return true;
> -
> -	/*
>  	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
>  	 */
>  	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> @@ -3401,8 +3385,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	struct cfq_io_context *cic = RQ_CIC(rq);
>  
>  	cfqd->rq_queued++;
> -	if (rq->cmd_flags & REQ_META)
> -		cfqq->meta_pending++;
>  
>  	cfq_update_io_thinktime(cfqd, cic);
>  	cfq_update_io_seektime(cfqd, cfqq, rq);
> -- 
> 1.7.3.1
> 
---end quoted text---
