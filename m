Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1HBP3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 11:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab1HBP3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 11:29:04 -0400
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
Date: Tue, 02 Aug 2011 11:28:26 -0400
In-Reply-To: <CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
	(Shaohua Li's message of "Tue, 2 Aug 2011 09:20:57 +0800")
Message-ID: <x49mxfru92d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

dm-multipath exports flush and fua, even if underlying devices do not
support those flags (but this will change shortly).  It then issues I/O
using blk_insert_cloned_request, which bypasses generic_make_request.
Plus, the logic was clearly wrong so I think we should take the proposed
patch.

Cheers,
Jeff
