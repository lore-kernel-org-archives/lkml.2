Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042Ab0EZErR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 00:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab0EZErP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 00:47:15 -0400
Date: Wed, 26 May 2010 00:47:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, dm-devel@redhat.com,
       Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: block: avoid unconditionally freeing previously allocated
 request_queue
Message-ID: <20100526044703.GA24702@redhat.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
 <1274744795-9825-3-git-send-email-snitzer@redhat.com>
 <4BFBB21A.3030105@ct.jp.nec.com>
 <20100525124912.GA7447@redhat.com>
 <20100525163455.GA10155@redhat.com>
 <4BFC896A.6050306@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFC896A.6050306@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25 2010 at 10:37pm -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/26/2010 01:34 AM +0900, Mike Snitzer wrote:
> > Mike Snitzer <snitzer@redhat.com> wrote:
> >> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> >>>> +/*
> >>>> + * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
> >>>> + */
> >>>> +static int dm_init_request_based_queue(struct mapped_device *md)
> >>>> +{
> >>>> +	struct request_queue *q = NULL;
> >>>> +
> >>>> +	/* Avoid re-initializing the queue if already fully initialized */
> >>>> +	if (!md->queue->elevator) {
> >>>> +		/* Fully initialize the queue */
> >>>> +		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> >>>> +		if (!q)
> >>>> +			return 0;
> >>>
> >>> When blk_init_allocated_queue() fails, the block-layer seems not to
> >>> guarantee that the queue is still available.
> >>
> >> Ouch, yes this portion of blk_init_allocated_queue_node() is certainly
> >> problematic:
> >>
> >>         if (blk_init_free_list(q)) {
> >>                 kmem_cache_free(blk_requestq_cachep, q);
> >>                 return NULL;
> >>         }
> 
> Not only that.  The blk_put_queue() in blk_init_allocated_queue_node()
> will also free the queue:
> 
> 	if (!elevator_init(q, NULL)) {
> 		blk_queue_congestion_threshold(q);
> 		return q;
> 	}
> 
> 	blk_put_queue(q);
> 	return NULL;

OK, I'll post v2 that addresses this and we'll see what Jens says.

Mike
