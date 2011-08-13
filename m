Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1HMN3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 09:29:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43653 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1HMN3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 09:29:15 -0400
Date: Sat, 13 Aug 2011 15:29:10 +0200
From: Tejun Heo <tj@kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, shaohua <shli@kernel.org>,
        Vivek Goyal <vgoyal@in.ibm.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [patch,v2] block: fix flush machinery for stacking drivers with
 differring flush flags
Message-ID: <20110813132910.GB4254@htj.dyndns.org>
References: <x497h6iphx4.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x497h6iphx4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 12, 2011 at 03:07:51PM -0400, Jeff Moyer wrote:
> Changes from v1->v2:
> - Moved the detection of empty flush requests into blk_insert_flush.
> - Got rid of REQ_FLUSH_SEQ in the CLONE_FLAGS.

Heh yeah, this looks pretty good to me. :)

> @@ -312,6 +309,19 @@ void blk_insert_flush(struct request *rq)
>  		rq->cmd_flags &= ~REQ_FUA;
>  
>  	/*
> +	 * An empty flush handed down from a stacking driver may
> +	 * translate into nothing if the underlying device does not
> +	 * advertise a write-back cache.  In this case, simply
> +	 * complete the request.
> +	 */
> +	if (!policy && !blk_rq_bytes(rq)) {
> +		__blk_end_bidi_request(rq, 0, 0, 0);
> +		return;
> +	}

Hmmm... doesn't !policy imply !blk_rq_bytes() with your change just
merged to Jens' tree?

> @@ -319,6 +329,7 @@ void blk_insert_flush(struct request *rq)
>  	if ((policy & REQ_FSEQ_DATA) &&
>  	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
>  		list_add_tail(&rq->queuelist, &q->queue_head);
> +		blk_run_queue_async(q);
>  		return;
>  	}

In the other message, you said,

> Well, the only time we need to run the queue is when the request has
> data, has REQ_FUA set, and the underlying queue's flush flags contain
> only REQ_FUA.  In code:
> 
> if (rq->cmd_flags & REQ_FUA && q->flush_flags == REQ_FUA)
>        blk_run_queue_async(q);

But this can't happen because a queue can't have REQ_FUA without
REQ_FLUSH (it doesn't make any sense).  blk_queue_flush() will trigger
WARN_ON_ONCE() and turn off REQ_FUA in such cases.

That said, it's kinda unclear who should be responsible for kicking
the queue.  __elv_add_request() does it for some but not all.
__make_request() always activates the queue which sometimes ends up
doing it again after __elv_add_request().  I think kicking the queue
after short circuit insert probably is the right thing to do.

Thank you.

-- 
tejun
