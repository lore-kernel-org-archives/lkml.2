Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab1HBSbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 14:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1HBSbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 14:31:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        msnitzer@redhat.com
Subject: Re: [patch] blk-flush: fix flush policy calculation
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
	<x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
	<20110802181739.GE6399@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 02 Aug 2011 14:31:00 -0400
In-Reply-To: <20110802181739.GE6399@redhat.com> (Vivek Goyal's message of
	"Tue, 2 Aug 2011 14:17:39 -0400")
Message-ID: <x49ty9zsm1n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Aug 02, 2011 at 01:39:46PM -0400, Jeff Moyer wrote:
>> OK, sorry for top-posting here, but I chased the problem down further.
>> 
>> Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
>> FLUSH/FUA to support merge, introduced a regression when running any
>> sort of fsyncing workload using dm-multipath and certain storage (in our
>> case, an HP EVA).  It turns out that dm-multipath always advertised
>> flush+fua support, and passed commands on down the stack, where they
>> used to get stripped off.  The above commit, unfortunately, changed that
>> behavior:
>> 
>> static inline struct request *__elv_next_request(struct request_queue *q)
>> {
>>         struct request *rq;
>> 
>>         while (1) {
>> -               while (!list_empty(&q->queue_head)) {
>> +               if (!list_empty(&q->queue_head)) {
>>                         rq = list_entry_rq(q->queue_head.next);
>> -                       if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
>> -                           (rq->cmd_flags & REQ_FLUSH_SEQ))
>> -                               return rq;
>> -                       rq = blk_do_flush(q, rq);
>> -                       if (rq)
>> -                               return rq;
>> +                       return rq;
>>                 }
>> 
>> Note that previously, a command would come in here, have
>> REQ_FLUSH|REQ_FUA set, and then get handed off to blk_do_flush:
>> 
>> struct request *blk_do_flush(struct request_queue *q, struct request *rq)
>> {
>>         unsigned int fflags = q->flush_flags; /* may change, cache it */
>>         bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
>>         bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
>>         bool do_postflush = has_flush && !has_fua && (rq->cmd_flags &
>>         REQ_FUA);
>>         unsigned skip = 0;
>> ...
>>         if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
>>                 rq->cmd_flags &= ~REQ_FLUSH;
>> 		if (!has_fua)
>> 			rq->cmd_flags &= ~REQ_FUA;
>> 	        return rq;
>> 	}
>> 
>> So, the flush machinery was bypassed in such cases (q->flush_flags == 0
>> && rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).
>> 
>> Now, however, we don't get into the flush machinery at all (which is why
>> my initial patch didn't help this situation).  Instead,
>> __elv_next_request just hands a request with flush and fua bits set to
>> the scsi_request_fn, even though the underlying request_queue does not
>> support flush or fua.
>> 
>> So, where do we fix this?  We could just accept Mike's patch to not send
>> such requests down from dm-mpath, but that seems short-sighted.  We
>> could reinstate some checks in __elv_next_request.  Or, we could put the
>> checks into blk_insert_cloned_request.
>> 
>> Suggestions?
>
> IMHO, we should fix it at multiple places.
>
> - Your initial fix in blk_insert_flush makes sense. blk_insert_flush()
>   is equivalent of blk_do_flush() so resetting REQ_FLUSH and REQ_FUA there
>   makes sense to me. 

Right, I still stand by that fix.  It was a thinko.

> - Fixing blk_insert_cloned_request() also makes sense to me so that if
>   a request is REQ_FLUSH or REQ_FUA set, we try to add it to underlying
>   device using ELEVATOR_INSERT_FLUSH and not ELEVATOR_INSERT_BACK.

Good point.

> - Fixing dm-multipath makes sense too as what's the point in dispatching
>   unnecessary flush/fua requests to underlying devices if underlying
>   queue does not have FLUSH capability.
>
> So I would say, fix it at all the places. :-)

You missed __elv_next_request.  :)

> I have one question though. What happens if we have an empty request
> with REQ_FLUSH set and request queue does not support flush. Where
> will we complete the IO for that request? I see that __generic_make_request()
> takes care of that but we might have to take care of if it insert_cloned
> path too.

In testing, I did this:

@@ -1817,6 +1817,14 @@ int blk_insert_cloned_request(struct
request_queue *q, struct request *rq)
                return -EIO;
 #endif
 
+       if ((rq->cmd_flags & (REQ_FLUSH|REQ_FUA)) && !q->flush_flags) {
+               rq->cmd_flags &= ~(REQ_FLUSH|REQ_FUA);
+               if (!blk_rq_bytes(rq)) {
+                       blk_end_request(rq, 0, 0);
+                       return 0;
+               }
+       }
+

Cheers,
Jeff
