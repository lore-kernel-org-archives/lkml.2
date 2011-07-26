Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1GZNF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:05:26 -0400
Received: from [95.166.99.235] ([95.166.99.235]:51836 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab1GZNFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:05:22 -0400
Message-ID: <4E2EBB8F.7000908@kernel.dk>
Date: Tue, 26 Jul 2011 15:05:19 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Preempt & smp_processor_id in __make_request
References: <1311672726.2700.5.camel@menhir> <20110726114330.GA12704@infradead.org>
In-Reply-To: <20110726114330.GA12704@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-26 13:43, Christoph Hellwig wrote:
> On Tue, Jul 26, 2011 at 10:32:06AM +0100, Steven Whitehouse wrote:
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index f8cb099..f925581 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1283,7 +1283,7 @@ get_rq:
>>  
>>  	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
>>  	    bio_flagged(bio, BIO_CPU_AFFINE))
>> -		req->cpu = smp_processor_id();
>> +		req->cpu = raw_smp_processor_id();
>>  
>>  	plug = current->plug;
>>  	if (plug) {
>>
>> However this fixes the symptoms, rather than the cause, so I'm not at
>> all sure that this is the correct solution,
> 
> It doesn't fix the symptoms - the warning is one of those 98% percent
> right types of warnings.  In this case get_cpu/put_cpu doesn't buy you
> anthing - we want to stash away the cpu id that we submitted the I/O
> from, to compare it when we later process the I/O completion from
> a different context.  With some PREEMPT options we might actually get
> rescheduled to a different CPU during the rest of this function, but
> as we submit the plugged requests at this point we'll still be correct.
> 
> Even if wasn't we would already thrash the cache badly enough for this
> optimization not to matter in that case.

This was reported earlier today as well, and I suggested the same fix.
raw_smp_processor_id() is fine, since it's just a hint.

-- 
Jens Axboe

