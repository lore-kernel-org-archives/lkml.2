Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1HBRj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1HBRju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:39:50 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, msnitzer@redhat.com
Subject: Re: [patch] blk-flush: fix flush policy calculation
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 02 Aug 2011 13:39:46 -0400
In-Reply-To: <CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
	(Shaohua Li's message of "Tue, 2 Aug 2011 09:20:57 +0800")
Message-ID: <x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, sorry for top-posting here, but I chased the problem down further.

Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
FLUSH/FUA to support merge, introduced a regression when running any
sort of fsyncing workload using dm-multipath and certain storage (in our
case, an HP EVA).  It turns out that dm-multipath always advertised
flush+fua support, and passed commands on down the stack, where they
used to get stripped off.  The above commit, unfortunately, changed that
behavior:

static inline struct request *__elv_next_request(struct request_queue *q)
{
        struct request *rq;

        while (1) {
-               while (!list_empty(&q->queue_head)) {
+               if (!list_empty(&q->queue_head)) {
                        rq = list_entry_rq(q->queue_head.next);
-                       if (!(rq->cmd_flags & (REQ_FLUSH | REQ_FUA)) ||
-                           (rq->cmd_flags & REQ_FLUSH_SEQ))
-                               return rq;
-                       rq = blk_do_flush(q, rq);
-                       if (rq)
-                               return rq;
+                       return rq;
                }

Note that previously, a command would come in here, have
REQ_FLUSH|REQ_FUA set, and then get handed off to blk_do_flush:

struct request *blk_do_flush(struct request_queue *q, struct request *rq)
{
        unsigned int fflags = q->flush_flags; /* may change, cache it */
        bool has_flush = fflags & REQ_FLUSH, has_fua = fflags & REQ_FUA;
        bool do_preflush = has_flush && (rq->cmd_flags & REQ_FLUSH);
        bool do_postflush = has_flush && !has_fua && (rq->cmd_flags &
        REQ_FUA);
        unsigned skip = 0;
...
        if (blk_rq_sectors(rq) && !do_preflush && !do_postflush) {
                rq->cmd_flags &= ~REQ_FLUSH;
		if (!has_fua)
			rq->cmd_flags &= ~REQ_FUA;
	        return rq;
	}

So, the flush machinery was bypassed in such cases (q->flush_flags == 0
&& rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).

Now, however, we don't get into the flush machinery at all (which is why
my initial patch didn't help this situation).  Instead,
__elv_next_request just hands a request with flush and fua bits set to
the scsi_request_fn, even though the underlying request_queue does not
support flush or fua.

So, where do we fix this?  We could just accept Mike's patch to not send
such requests down from dm-mpath, but that seems short-sighted.  We
could reinstate some checks in __elv_next_request.  Or, we could put the
checks into blk_insert_cloned_request.

Suggestions?

Cheers,
Jeff


Shaohua Li <shli@kernel.org> writes:

> 2011/8/2 Jeff Moyer <jmoyer@redhat.com>:
>> Hi,
>>
>> Reading through the code in blk-flush.c, it appears that there is an
>> oversight in the policy returned from blk_flush_policy:
>>
>>        if (fflags & REQ_FLUSH) {
>>                if (rq->cmd_flags & REQ_FLUSH)
>>                        policy |= REQ_FSEQ_PREFLUSH;
>>                if (blk_rq_sectors(rq))
>>                        policy |= REQ_FSEQ_DATA;
>>                if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
>>                        policy |= REQ_FSEQ_POSTFLUSH;
>>        }
>>        return policy;
>>
>> This means that REQ_FSEQ_DATA can only be set if the queue flush_flags
>> include FLUSH and/or FUA.  However, the short-circuit for not issuing
>> flushes when the device doesn't need/support them depends on
>> REQ_FSEQ_DATA being set while the other two bits are clear:
>>
>>        /*
>>         * If there's data but flush is not necessary, the request can be
>>         * processed directly without going through flush machinery.  Queue
>>         * for normal execution.
>>         */
>>        if ((policy & REQ_FSEQ_DATA) &&
>>            !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
>>                list_add_tail(&rq->queuelist, &q->queue_head);
>>                return;
>>        }
>>
>> Given the code as it stands, I don't think the body of this if statement
>> will ever be executed.  I've attached a fix for this below.  It seems
>> like this could be both a performance and a correctness issue, though
>> I've not run into any problems I can directly attribute to this (perhaps
>> due to file systems not issuing flushes when support is not advertised?).
>>
>> Comments are appreciated.
>>
>> Cheers,
>> Jeff
>>
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>
>> diff --git a/block/blk-flush.c b/block/blk-flush.c
>> index bb21e4c..3a06118 100644
>> --- a/block/blk-flush.c
>> +++ b/block/blk-flush.c
>> @@ -95,11 +95,11 @@ static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
>>  {
>>        unsigned int policy = 0;
>>
>> +       if (blk_rq_sectors(rq))
>> +               policy |= REQ_FSEQ_DATA;
>>        if (fflags & REQ_FLUSH) {
>>                if (rq->cmd_flags & REQ_FLUSH)
>>                        policy |= REQ_FSEQ_PREFLUSH;
>> -               if (blk_rq_sectors(rq))
>> -                       policy |= REQ_FSEQ_DATA;
>>                if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
>>                        policy |= REQ_FSEQ_POSTFLUSH;
>>        }
>> --
> __generic_make_request always handles this:
> if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
>                         bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
>                         if (!nr_sectors) {
>                                 err = 0;
>                                 goto end_io;
>                         }
>                 }
>
> Thanks,
> Shaohua
