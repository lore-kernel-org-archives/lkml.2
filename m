Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1HBSmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab1HBSmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:42:00 -0400
Date: Tue, 2 Aug 2011 14:41:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        msnitzer@redhat.com
Subject: Re: [patch] blk-flush: fix flush policy calculation
Message-ID: <20110802184125.GF6399@redhat.com>
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
 <CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
 <x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
 <20110802181739.GE6399@redhat.com>
 <x49ty9zsm1n.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ty9zsm1n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 02:31:00PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Tue, Aug 02, 2011 at 01:39:46PM -0400, Jeff Moyer wrote:
> >> OK, sorry for top-posting here, but I chased the problem down further.
> >> 
> >> Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
> >> FLUSH/FUA to support merge, introduced a regression when running any
> >> sort of fsyncing workload using dm-multipath and certain storage (in our
> >> case, an HP EVA).  It turns out that dm-multipath always advertised
> >> flush+fua support, and passed commands on down the stack, where they
> >> used to get stripped off.  The above commit, unfortunately, changed that
> >> behavior:
> >> 
> >> static inline struct request *__elv_next_request(struct request_queue *q)
> >> {
> >>         struct request *rq;
> >> 
> >>         while (1) {
> >> -               while (!list_empty(&q->queue_head)) {
> >> +               if (!list_empty(&q->queue_head)) {
> >>                         rq = list_entry_rq(q->queue_head.next);
> >> -                       if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
> >> -                           (rq->cmd_flags & REQ_FLUSH_SEQ))
> >> -                               return rq;
> >> -                       rq = blk_do_flush(q, rq);
> >> -                       if (rq)
> >> -                               return rq;
> >> +                       return rq;
> >>                 }
> >> 
> >> Note that previously, a command would come in here, have
> >> REQ_FLUSH|REQ_FUA set, and then get handed off to blk_do_flush:
> >> 
> >> struct request *blk_do_flush(struct request_queue *q, struct request *rq)
> >> {
> >>         unsigned int fflags = q->flush_flags; /* may change, cache it */
> >>         bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
> >>         bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
> >>         bool do_postflush = has_flush && !has_fua && (rq->cmd_flags &
> >>         REQ_FUA);
> >>         unsigned skip = 0;
> >> ...
> >>         if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
> >>                 rq->cmd_flags &= ~REQ_FLUSH;
> >> 		if (!has_fua)
> >> 			rq->cmd_flags &= ~REQ_FUA;
> >> 	        return rq;
> >> 	}
> >> 
> >> So, the flush machinery was bypassed in such cases (q->flush_flags == 0
> >> && rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).
> >> 
> >> Now, however, we don't get into the flush machinery at all (which is why
> >> my initial patch didn't help this situation).  Instead,
> >> __elv_next_request just hands a request with flush and fua bits set to
> >> the scsi_request_fn, even though the underlying request_queue does not
> >> support flush or fua.
> >> 
> >> So, where do we fix this?  We could just accept Mike's patch to not send
> >> such requests down from dm-mpath, but that seems short-sighted.  We
> >> could reinstate some checks in __elv_next_request.  Or, we could put the
> >> checks into blk_insert_cloned_request.
> >> 
> >> Suggestions?
> >
> > IMHO, we should fix it at multiple places.
> >
> > - Your initial fix in blk_insert_flush makes sense. blk_insert_flush()
> >   is equivalent of blk_do_flush() so resetting REQ_FLUSH and REQ_FUA there
> >   makes sense to me. 
> 
> Right, I still stand by that fix.  It was a thinko.
> 
> > - Fixing blk_insert_cloned_request() also makes sense to me so that if
> >   a request is REQ_FLUSH or REQ_FUA set, we try to add it to underlying
> >   device using ELEVATOR_INSERT_FLUSH and not ELEVATOR_INSERT_BACK.
> 
> Good point.
> 
> > - Fixing dm-multipath makes sense too as what's the point in dispatching
> >   unnecessary flush/fua requests to underlying devices if underlying
> >   queue does not have FLUSH capability.
> >
> > So I would say, fix it at all the places. :-)
> 
> You missed __elv_next_request.  :)

Actually we will take care of resetting FLUSH/FUA flag when request is
being queued on request queue (blk_insert_flush()). So I think there is
no need to fix __elv_next_request(). That's why I had skipped it. 

> 
> > I have one question though. What happens if we have an empty request
> > with REQ_FLUSH set and request queue does not support flush. Where
> > will we complete the IO for that request? I see that __generic_make_request()
> > takes care of that but we might have to take care of if it insert_cloned
> > path too.
> 
> In testing, I did this:
> 
> @@ -1817,6 +1817,14 @@ int blk_insert_cloned_request(struct
> request_queue *q, struct request *rq)
>                 return -EIO;
>  #endif
>  
> +       if ((rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) && !q->flush_flags) {
> +               rq->cmd_flags &= ~(REQ_FLUSH|REQ_FUA);
> +               if (!blk_rq_bytes(rq)) {
> +                       blk_end_request(rq, 0, 0);
> +                       return 0;
> +               }
> +       }
> +

Will it make more sense to take care resetting flush/fua flags in
blk_insert_flush() and also the part which will end the request if
request is empty. And in cloned request we just take care of using
ELVATOR_FLUSH_INSERT. 

The reason being that it will make __elv_insert() path safe for all
the cases and insert_cloned_request is just one of the consumers.

But this is just a minor point. At the end of the day, I think both
the solutions will work.

Thanks
Vivek
