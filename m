Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1HIRNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:13:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab1HIRNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:13:52 -0400
Date: Tue, 9 Aug 2011 13:13:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        msnitzer@redhat.com
Subject: Re: [patch] blk-flush: fix flush policy calculation
Message-ID: <20110809171349.GE6482@redhat.com>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
 <x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
 <20110802181739.GE6399@redhat.com>
 <x49ty9zsm1n.fsf@segfault.boston.devel.redhat.com>
 <20110802184125.GF6399@redhat.com>
 <x49oc07sija.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49oc07sija.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 03:46:49PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> >> In testing, I did this:
> >> 
> >> @@ -1817,6 +1817,14 @@ int blk_insert_cloned_request(struct
> >> request_queue *q, struct request *rq)
> >>                 return -EIO;
> >>  #endif
> >>  
> >> +       if ((rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) && !q->flush_flags) {
> >> +               rq->cmd_flags &= ~(REQ_FLUSH|REQ_FUA);
> >> +               if (!blk_rq_bytes(rq)) {
> >> +                       blk_end_request(rq, 0, 0);
> >> +                       return 0;
> >> +               }
> >> +       }
> >> +
> >
> > Will it make more sense to take care resetting flush/fua flags in
> > blk_insert_flush()
> 
> Yes, that's much cleaner.
> 
> > and also the part which will end the request if request is empty.
> 
> Mmm-hmm.
> 
> I tried this, and it blew up in my face.  ;-)  Cloned requests from
> device-mapper-land have rq->end_io filled in, which causes
> blk_insert_flush to BUG here:
> 
>         BUG_ON(rq->end_io);

So how does it work when underlying device supports FLUSH/FUA? That means
that dm-multipath requets never go through flush machinery? So if a
queue does not support FUA but supports FLUSH, then FUA will not be
honored by the underlying driver and request can very well be in cache?

IOW, looks like even if component devices of a multipath device support
FLUSH, requests don't go through it and hence atleast FUA is broken? And
that would also mean that these don't benefit from flush merge logic.

I guess we need to sort out this req->end_io issue and if both caller
and flush machinery needs to make use of this pointer, then flush 
machinery should save it and restore on completion path.

Thanks
Vivek
