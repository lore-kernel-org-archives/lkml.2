Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2LLTmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:42:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab2LLTmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:42:09 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, Shaohua Li <shli@kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Read starvation by sync writes
References: <20121210221222.GA25700@quack.suse.cz>
	<CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com>
	<20121212101108.GC18885@quack.suse.cz> <50C8A07B.6040508@kernel.dk>
	<x49vcc7kyza.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 12 Dec 2012 14:41:13 -0500
In-Reply-To: <x49vcc7kyza.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Wed, 12 Dec 2012 11:38:01 -0500")
Message-ID: <x49obhzkqhy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

>> I agree. This isn't about scheduling, we haven't even reached that part
>> yet. Back when we split the queues into read vs write, this problem
>> obviously wasn't there. Now we have sync writes and reads, both eating
>> from the same pool. The io scheduler can impact this a bit by forcing
>> reads to must allocate (Jan, which io scheduler are you using?). CFQ
>> does this when it's expecting a request from this process queue.
>>
>> Back in the day, we used to have one list. To avoid a similar problem,
>> we reserved the top of the list for reads. With the batching, it's a bit
>> more complicated. If we make the request allocation (just that, not the
>> scheduling) be read vs write instead of sync vs async, then we have the
>> same issue for sync vs buffered writes.
>>
>> How about something like the below? Due to the nature of sync reads, we
>> should allow a much longer timeout. The batch is really tailored towards
>> writes at the moment. Also shrink the batch count, 32 is pretty large...
>
> Does batching even make sense for dependent reads?  I don't think it
> does.

Having just read the batching code in detail, I'd like to ammend this
misguided comment.  Batching logic kicks in when you happen to be lucky
enough to use up the last request.  As such, I'd be surprised if the
patch you posted helped.  Jens, don't you think the writer is way more
likely to become the batcher?  I do agree with shrinking the batch count
to 16, whether or not the rest of the patch goes in.

>  Assuming you disagree, then you'll have to justify that fixed
> time value of 2 seconds.  The amount of time between dependent reads
> will vary depending on other I/O sent to the device, the properties of
> the device, the I/O scheduler, and so on.  If you do stick 2 seconds in
> there, please comment it.  Maybe it's time we started keeping track of
> worst case Q->C time?  That could be used to tell worst case latency,
> and adjust magic timeouts like this one.
>
> I'm still thinking about how we might solve this in a cleaner way.

The way things stand today, you can do a complete end run around the I/O
scheduler by queueing up enough I/O.  To address that, I think we need
to move to a request list per io_context as Jan had suggested.  That
way, we can keep the logic about who gets to submit I/O when in one
place.

Jens, what do you think?

Jan, for now, try bumping nr_requests up really high.  ;-)

Cheers,
Jeff
