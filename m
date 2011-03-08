Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1CHMP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:15:27 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:55128 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1CHMPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:15:21 -0500
X-ASG-Debug-ID: 1299586520-03d6a54f6124470001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D761DD4.9030105@fusionio.com>
Date: Tue, 8 Mar 2011 13:15:16 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com> <1295659049-2688-6-git-send-email-jaxboe@fusionio.com> <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299586520
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57405
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-03 22:23, Mike Snitzer wrote:
>> diff --git a/block/blk-flush.c b/block/blk-flush.c
>> index 54b123d..c0a07aa 100644
>> --- a/block/blk-flush.c
>> +++ b/block/blk-flush.c
>> @@ -59,7 +59,6 @@ static struct request *blk_flush_complete_seq(struct request_queue *q,
>>  static void blk_flush_complete_seq_end_io(struct request_queue *q,
>>                                          unsigned seq, int error)
>>  {
>> -       bool was_empty = elv_queue_empty(q);
>>        struct request *next_rq;
>>
>>        next_rq = blk_flush_complete_seq(q, seq, error);
>> @@ -68,7 +67,7 @@ static void blk_flush_complete_seq_end_io(struct request_queue *q,
>>         * Moving a request silently to empty queue_head may stall the
>>         * queue.  Kick the queue in those cases.
>>         */
>> -       if (was_empty && next_rq)
>> +       if (next_rq)
>>                __blk_run_queue(q);
>>  }
>>
> ...
>> diff --git a/block/elevator.c b/block/elevator.c
>> index a9fe237..d5d17a4 100644
>> --- a/block/elevator.c
>> +++ b/block/elevator.c
>> @@ -619,8 +619,6 @@ void elv_quiesce_end(struct request_queue *q)
> ...
>> -int elv_queue_empty(struct request_queue *q)
>> -{
>> -       struct elevator_queue *e = q->elevator;
>> -
>> -       if (!list_empty(&q->queue_head))
>> -               return 0;
>> -
>> -       if (e->ops->elevator_queue_empty_fn)
>> -               return e->ops->elevator_queue_empty_fn(q);
>> -
>> -       return 1;
>> -}
>> -EXPORT_SYMBOL(elv_queue_empty);
>> -
> 
> Your latest 'for-2.6.39/stack-unplug' rebase (commit 7703acb01e)
> misses removing a call to elv_queue_empty() in
> block/blk-flush.c:flush_data_end_io()
> 
>   CC      block/blk-flush.o
> block/blk-flush.c: In function ‘flush_data_end_io’:
> block/blk-flush.c:266: error: implicit declaration of function ‘elv_queue_empty’

Thanks, also fixed now.

-- 
Jens Axboe

