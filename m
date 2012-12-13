Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2LMNbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:31:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab2LMNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:31:13 -0500
Message-ID: <50C9D882.7000808@kernel.dk>
Date: Thu, 13 Dec 2012 14:30:42 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Jan Kara <jack@suse.cz>, Shaohua Li <shli@kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Read starvation by sync writes
References: <20121210221222.GA25700@quack.suse.cz> <CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com> <20121212101108.GC18885@quack.suse.cz> <50C8A07B.6040508@kernel.dk> <x49vcc7kyza.fsf@segfault.boston.devel.redhat.com> <x49obhzkqhy.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49obhzkqhy.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-12 20:41, Jeff Moyer wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
> 
>>> I agree. This isn't about scheduling, we haven't even reached that part
>>> yet. Back when we split the queues into read vs write, this problem
>>> obviously wasn't there. Now we have sync writes and reads, both eating
>>> from the same pool. The io scheduler can impact this a bit by forcing
>>> reads to must allocate (Jan, which io scheduler are you using?). CFQ
>>> does this when it's expecting a request from this process queue.
>>>
>>> Back in the day, we used to have one list. To avoid a similar problem,
>>> we reserved the top of the list for reads. With the batching, it's a bit
>>> more complicated. If we make the request allocation (just that, not the
>>> scheduling) be read vs write instead of sync vs async, then we have the
>>> same issue for sync vs buffered writes.
>>>
>>> How about something like the below? Due to the nature of sync reads, we
>>> should allow a much longer timeout. The batch is really tailored towards
>>> writes at the moment. Also shrink the batch count, 32 is pretty large...
>>
>> Does batching even make sense for dependent reads?  I don't think it
>> does.
> 
> Having just read the batching code in detail, I'd like to ammend this
> misguided comment.  Batching logic kicks in when you happen to be lucky
> enough to use up the last request.  As such, I'd be surprised if the
> patch you posted helped.  Jens, don't you think the writer is way more
> likely to become the batcher?  I do agree with shrinking the batch count
> to 16, whether or not the rest of the patch goes in.
> 
>>  Assuming you disagree, then you'll have to justify that fixed
>> time value of 2 seconds.  The amount of time between dependent reads
>> will vary depending on other I/O sent to the device, the properties of
>> the device, the I/O scheduler, and so on.  If you do stick 2 seconds in
>> there, please comment it.  Maybe it's time we started keeping track of
>> worst case Q->C time?  That could be used to tell worst case latency,
>> and adjust magic timeouts like this one.
>>
>> I'm still thinking about how we might solve this in a cleaner way.
> 
> The way things stand today, you can do a complete end run around the I/O
> scheduler by queueing up enough I/O.  To address that, I think we need
> to move to a request list per io_context as Jan had suggested.  That
> way, we can keep the logic about who gets to submit I/O when in one
> place.
> 
> Jens, what do you think?

I think that is pretty extreme. We have way too much accounting around
this already, and I'd rather just limit the batching than make
per-ioc request lists too.

I agree the batch addition isn't super useful for the reads. It really
is mostly a writer thing, and the timing reflects that.

The problem is really that the WRITE_SYNC is (for Jan's case) behaving
like buffered writes, so it eats up a queue of requests very easily. On
the allocation side, the assumption is that WRITE_SYNC behaves like
dependent reads. Similar to a dd with oflag=direct, not like a flood of
requests. For dependent sync writes, our current behaviour is fine, we
treat them like reads. For commits of WRITE_SYNC, they should be treated
like async WRITE instead.

-- 
Jens Axboe

