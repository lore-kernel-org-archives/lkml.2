Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2ASBOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:14:51 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50280 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab2ASBOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:14:49 -0500
X-AuditID: 9c930179-b7bf0ae00000132b-d2-4f176e84a76e
To: undisclosed-recipients:;
Message-ID: <4F176E82.6030808@gmail.com>
Date: Thu, 19 Jan 2012 10:14:42 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
CC: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/3] block: prevent duplicated bio completion report
References: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com> <1326763928-1972-2-git-send-email-namhyung.kim@lge.com> <20120117174520.GB6762@google.com> <4F161E43.5040705@gmail.com>
In-Reply-To: <4F161E43.5040705@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2012-01-18 10:20 AM, Namhyung Kim wrote:
> Hi,
> 
> 2012-01-18 2:45 AM, Tejun Heo wrote:
>>
>>> /*
>>> * top 4 bits of bio flags indicate the pool this bio came from
>>> */
>>> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
>>> index 96955f4828b3..72888542e186 100644
>>> --- a/include/trace/events/block.h
>>> +++ b/include/trace/events/block.h
>>> @@ -219,7 +219,8 @@ TRACE_EVENT_CONDITION(block_bio_complete,
>>>
>>>  	TP_ARGS(q, bio, error),
>>>
>>> - TP_CONDITION(bio->bi_bdev != NULL),
>>> + TP_CONDITION(bio->bi_bdev != NULL &&
>>> + 		!(bio->bi_flags & BIO_COMPLETE_MASK)),
>>
>> Bounced bio's are separate bio's too and I don't think masking its
>> completion from the TP itself is a good idea. As I wrote before, why
>> not do this from blktrace code?
> 
> Because blktrace cannot know about the bi_flags, as I said before. :) 
> And although the bounced bio's are separate ones, they aren't queued 
> separately. They just get replaced on the way.

Oh, now I guess you meant this:

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 16fc34a0806f..2ef57fb2566e 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -792,6 +792,9 @@ static void blk_add_trace_bio_complete(void *ignore,
                                       struct request_queue *q, struct bio *bio,
                                       int error)
 {
+       if (bio->bi_flags & BIO_COMPLETE_MASK)
+               return;
+
        blk_add_trace_bio(q, bio, BLK_TA_COMPLETE, error);
 }


Anyway do you still think masking on TP is not a good idea?


Thanks,
Namhyung
