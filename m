Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab2IEKH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:07:29 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:44461 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2IEKH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:07:27 -0400
Date: Wed, 5 Sep 2012 12:07:24 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120905100724.GA27527@soda.linbit>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, drbd-dev@lists.linbit.com
References: <8439412.RChiDciQdh@fat-tyre>
 <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <3029802.oqG0dEY71l@fat-tyre>
 <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:49:15AM -0700, Tejun Heo wrote:
> On Wed, Sep 05, 2012 at 10:44:55AM +0200, Philipp Reisner wrote:
> > > Currently, FLUSH/FUA doesn't enforce any ordering requirement.  File
> > > systems are responsible for draining all writes which have to happen
> > > before and not issue further writes which should come after.
> > 
> > Ok. That is a clear statement. So we will do it that way.
> > 
> > The "Currently" in you statement, suggests that there might be something
> > more mighty in the future. Is that true?
> 
> Heh, I was more thinking about the past.  We used to have barrier
> support with much stricter ordering.  I don't think we're gonna change
> the ordering requirement in any foreseeable future.

So reiterating the situation:

If I'd submit a non-empty bio with FLUSH/FUA set,
on a queue that does support flush, we get to
	blk_queue_bio()
		if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
			spin_lock_irq(q->queue_lock);
			where = ELEVATOR_INSERT_FLUSH;
			goto get_rq;

This bio ends up *not* being merged or reordered by the elevator.
(and, by means of flush/fua not by the hardware, either, obviously)


If the queue does not support it, flags are stripped away in
generic_make_request_checks(), and we will not take that branch
in blk_queue_bio(), but enter the normal elevator code path,
attempting a merge, or doing ELEVATOR_INSERT_SORT.

This same bio, happening to be submitted on a different IO stack,
now *is* being reordered in the elevator already,
even before being sent to the hardware.




If we somehow can express at submit_bio time that we would like
this bio, once it reaches the elevator, to not be reordered,
regardless of whether or not FLUSH is supported respectively required
by the IO stack in use, that would be better than now, IMO.
In fact, for our particular use case it would even be good enough.


Could we "just" strip these flags a "little bit later"?
Or set some other indicator when stripping them?


Thanks,

	Lars

