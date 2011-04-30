Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab1D3Oie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 10:38:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62790 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab1D3OiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 10:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v8KkOuxLPZmkH/+FbRzXSi0xML+DLeYYLj/0YKp1HgyZIgvr7EZGQw9n2BsVbnRmiZ
         cCl0ln6g7lFZ4opCjF4Z6ouaNFV50K3m8OusGcas22oAnrnNfErTem7Pr+mxlEtGKkNZ
         V8ka9krge4c8qANgw6FbobSSnagiRBAIwDAlk=
Date: Sat, 30 Apr 2011 16:37:58 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
Message-ID: <20110430143758.GK29280@htj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
 <20110422233204.GB1576@mtj.dyndns.org>
 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
 <20110425085827.GB17734@mtj.dyndns.org>
 <20110425091311.GC17734@mtj.dyndns.org>
 <1303778790.3981.283.camel@sli10-conroe>
 <20110426104843.GB878@htj.dyndns.org>
 <1303977055.3981.587.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303977055.3981.587.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Thu, Apr 28, 2011 at 03:50:55PM +0800, Shaohua Li wrote:
> Index: linux/block/blk-flush.c
> ===================================================================
> --- linux.orig/block/blk-flush.c	2011-04-28 10:23:12.000000000 +0800
> +++ linux/block/blk-flush.c	2011-04-28 14:12:50.000000000 +0800
> @@ -158,6 +158,17 @@ static bool blk_flush_complete_seq(struc
>  	switch (seq) {
>  	case REQ_FSEQ_PREFLUSH:
>  	case REQ_FSEQ_POSTFLUSH:
> +		/*
> +		 * If queue doesn't support queueable flush request, we just
> +		 * merge the flush with running flush. For such queue, there
> +		 * are no normal requests running when flush request is
> +		 * running, so this still guarantees the correctness.
> +		 */
> +		if (!blk_queue_flush_queueable(q)) {
> +			list_move_tail(&rq->flush.list,
> +				&q->flush_queue[q->flush_running_idx]);
> +			break;
> +		}

As I've said several times already, I really don't like this magic
being done in the completion path.  Can't you detect the condition on
issue of the second/following flush and append it to the running list?
If you already have tried that but this way still seems better, can
you please explain why?

Also, this is a separate logic.  Please put it in a separate patch.
The first patch should implement queue holding while flushing, which
should remove the regression, right?

The second patch can optimize back-to-back execution, which might or
might not buy us tangible performance gain, so it would be nice to
have some measurement for this change.  Also, this logic isn't
necessarily related with queueability of flushes, right?  As such, I
think it would be better for it to be implemented separately from the
queueability thing, unless doing such increases complexity too much.

> Index: linux/include/linux/blkdev.h
> ===================================================================
> --- linux.orig/include/linux/blkdev.h	2011-04-28 10:23:12.000000000 +0800
> +++ linux/include/linux/blkdev.h	2011-04-28 10:32:54.000000000 +0800
> @@ -364,6 +364,13 @@ struct request_queue
>  	 * for flush operations
>  	 */
>  	unsigned int		flush_flags;
> +	unsigned int		flush_not_queueable:1;
> +	/*
> +	 * flush_exclusive_running and flush_queue_delayed are only meaningful
> +	 * when flush request isn't queueable
> +	 */
> +	unsigned int		flush_exclusive_running:1;
> +	unsigned int		flush_queue_delayed:1;

Hmmm... why do you need separate ->flush_exclusive_running?  Doesn't
pending_idx != running_idx already have the same information?

> Index: linux/block/blk-core.c
> ===================================================================
> --- linux.orig/block/blk-core.c	2011-04-28 10:23:12.000000000 +0800
> +++ linux/block/blk-core.c	2011-04-28 10:53:18.000000000 +0800
> @@ -929,6 +929,8 @@ void blk_requeue_request(struct request_
>  
>  	BUG_ON(blk_queued_rq(rq));
>  
> +	if (rq == &q->flush_rq)
> +		q->flush_exclusive_running = 0;

I don't get this either.  What's requeueing got to do with it?  It
doesn't matter whether flush gets requeued or not.  Once flush is put
onto the dispatch list, isn't holding the queue until it's complete
enough?

Thanks.

-- 
tejun
