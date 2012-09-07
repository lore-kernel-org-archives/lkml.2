Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab2IGIm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:42:29 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:42714 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2IGImZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:42:25 -0400
Date: Fri, 7 Sep 2012 10:42:21 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120907084221.GD7028@soda.linbit>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, drbd-dev@lists.linbit.com
References: <8439412.RChiDciQdh@fat-tyre>
 <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <3029802.oqG0dEY71l@fat-tyre>
 <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120905100724.GA27527@soda.linbit>
 <20120906212952.GP29092@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906212952.GP29092@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 02:29:52PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 05, 2012 at 12:07:24PM +0200, Lars Ellenberg wrote:
> > So reiterating the situation:
> > 
> > If I'd submit a non-empty bio with FLUSH/FUA set,
> > on a queue that does support flush, we get to
> > 	blk_queue_bio()
> > 		if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
> > 			spin_lock_irq(q->queue_lock);
> > 			where = ELEVATOR_INSERT_FLUSH;
> > 			goto get_rq;
> > 
> > This bio ends up *not* being merged or reordered by the elevator.
> > (and, by means of flush/fua not by the hardware, either, obviously)
> > 
> > If the queue does not support it, flags are stripped away in
> > generic_make_request_checks(), and we will not take that branch
> > in blk_queue_bio(), but enter the normal elevator code path,
> > attempting a merge, or doing ELEVATOR_INSERT_SORT.
> 
> which is an implementation detail.
> 
> > This same bio, happening to be submitted on a different IO stack,
> > now *is* being reordered in the elevator already,
> > even before being sent to the hardware.
> 
> and this is perfectly fine.

Absolutely.

It was just "unexpected" ;-)

BTW, out of curiosity, if it is fine to take the normal elevator path in
the case the flags are stripped, why would it not be ok to take that
same normal path in the case the flags are not stripped?

I'd assume it is not about ordering, but only about merging, as the flush
machinery seems to rely on requests with single bios attached?

> I really don't see what problem you're trying to solve here.  The
> ordering requirement is weak.  Certain implementation path uses
> stronger requirement for convenience / historical reasons.  If any
> change makes sense, it's relaxing the unnecessarily strict ordering if
> possible.

Ok.

> What actual problem are you seeing?

We have a kernel thread that is receiving data blocks,
and some "boundary" information (in the sense that between such
boundaries, we have a reorder domain, where requests may reorder freely,
but no requests may be reordered across such boundaries).

This same thread submits the assembled bios.

With the old, stronger, BIO_RW_BARRIER implementation,
if it was supported, we could just submit the first bio of a reorder
domain (plus some special cases) with that flag,
and could keep receiving -> assembling -> submitting.

Now, we assumed that with FLUSH/FUA, we can do the same.
And we could, as long as it is supported through the whole stack.

But if it is not supported at some level in the stack, we must first drain.

And since it is all "transparent", we just cannot determine
if the whole stack does or does not support it.

So we have to drain always.

We did not realize that. 
In certain cases, where we submitted in the right order, and even
indicated what we thought would amount to at least a "soft barrier"
(reorder boundary) for the elevator, we ended up with data corruption
because the elevator never sees these indicators, and reorders.

Fine, our mistake/misunderstanding of the drain requirement.
That's fixed now, we do always drain
(unless specifically configured not to, where the admin takes the blame
if that does not work on his stack).


To always drain is also a performance hit, as we would rather keep
receiving data and assembling bios and submitting them.

We can possibly work around that by introducing an additional submitter thread,
or at least our own list where we queue assembled bios until the lower
level device queue drains.

But we'd rather have the elevator see the FLUSH/FUA,
and treat them as at least a soft barrier/reorder boundary.

I may be wrong here, but all the necessary bits for this seem to be in
place already, if the information would even reach the elevator in one
way or other, and not be completely stripped away early.


What would you rather see, the elevator recognizing reorder boundaries?
Or additional higher level queueing and extra thread/work queue/whatever?

Both are fine with me, I'm just asking for an opinion.


Thanks,
	Lars

