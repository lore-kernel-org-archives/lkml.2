Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2AIC5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:57:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59763 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2AIC5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:57:46 -0500
X-AuditID: 9c930197-b7ba0ae00000500f-16-4f0a57a79884
Message-ID: <4F0A57A7.4070508@lge.com>
Date: Mon, 09 Jan 2012 11:57:43 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: introduce BIO_IN_FLIGHT flag
References: <1324996113-1837-1-git-send-email-namhyung@gmail.com> <1324996113-1837-2-git-send-email-namhyung@gmail.com> <20120109015628.GB16360@mtj.dyndns.org>
In-Reply-To: <20120109015628.GB16360@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-09 10:56 AM, Tejun Heo wrote:
> On Tue, Dec 27, 2011 at 11:28:32PM +0900, Namhyung Kim wrote:
>> BIO_IN_FLIGHT flag is used for tracing block I/O completion.
>> This patch fixes tracing bio-based devices - except DM which
>> inserts completion tracepoint explicitly - that could not be
>> traced such event using blktrace.
>>
>> It won't affect tracing normal (request-based) disk devices
>> and nested bio handling paths.
>>
>> Signed-off-by: Namhyung Kim<namhyung@gmail.com>
>> ---
>>   block/blk-core.c          |    5 +++++
>>   fs/bio.c                  |    7 +++++++
>>   include/linux/blk_types.h |    1 +
>>   3 files changed, 13 insertions(+), 0 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 1b4fd93af2c0..f61310323954 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -165,6 +165,9 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
>>   	if (unlikely(rq->cmd_flags&  REQ_QUIET))
>>   		set_bit(BIO_QUIET,&bio->bi_flags);
>>
>> +	/* completion event was already reported in blk_update_request */
>> +	clear_bit(BIO_IN_FLIGHT,&bio->bi_flags);
>> +
>>   	bio->bi_size -= nbytes;
>>   	bio->bi_sector += (nbytes>>  9);
>>
>> @@ -1662,6 +1665,8 @@ void generic_make_request(struct bio *bio)
> p>   	do {
>>   		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>>
>> +		set_bit(BIO_IN_FLIGHT,&bio->bi_flags);
>> +
>>   		q->make_request_fn(q, bio);
>>
>>   		bio = bio_list_pop(current->bio_list);
>> diff --git a/fs/bio.c b/fs/bio.c
>> index b1fe82cf88cf..10fb7a1d74ba 100644
>> --- a/fs/bio.c
>> +++ b/fs/bio.c
>> @@ -1447,6 +1447,13 @@ void bio_endio(struct bio *bio, int error)
>>   	else if (!test_bit(BIO_UPTODATE,&bio->bi_flags))
>>   		error = -EIO;
>>
>> +	if (test_bit(BIO_IN_FLIGHT,&bio->bi_flags)) {
>> +		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>> +
>> +		trace_block_bio_complete(q, bio, error);
>> +		clear_bit(BIO_IN_FLIGHT,&bio->bi_flags);
>> +	}
>
> This really should be filtered from the consumer side.  Not on TP
> itself.  Doing it like this makes the TP useless for other consumers
> and adds unnecessary flag and operations on it even when the TP is not
> in use.  Why not just trigger the TP on boi_endio() and let blktrace
> probe filter out bounced or cloned completions?

I understand your concerns. However, the blktrace cannot get 
bio->bi_flags info in its current form AFAIK. Doing it will require 
extending struct blk_io_trace and it'll cause a compatibility issue,
I guess.

Anyway I think the needs of tracing bio based drivers are growing so 
it'd be great the blktrace supports it as well. Also as we've run out of 
act_mask bits, it might be needed a room for extending.

But before proceeding, I'd like to listen comments/advices from people. 
Jens?

Thanks,
Namhyung Kim
