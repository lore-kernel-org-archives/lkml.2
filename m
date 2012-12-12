Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2LLQiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:38:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab2LLQit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:38:49 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, Shaohua Li <shli@kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Read starvation by sync writes
References: <20121210221222.GA25700@quack.suse.cz>
	<CANejiEW2+iUVnyV0EV2n=vi_+bjX42SkeT9F6EUV5LkwXH4e0g@mail.gmail.com>
	<20121212101108.GC18885@quack.suse.cz> <50C8A07B.6040508@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 12 Dec 2012 11:38:01 -0500
In-Reply-To: <50C8A07B.6040508@kernel.dk> (Jens Axboe's message of "Wed, 12
	Dec 2012 16:19:23 +0100")
Message-ID: <x49vcc7kyza.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2012-12-12 11:11, Jan Kara wrote:
>> On Wed 12-12-12 10:55:15, Shaohua Li wrote:
>>> 2012/12/11 Jan Kara <jack@suse.cz>:
>>>>   Hi,
>>>>
>>>>   I was looking into IO starvation problems where streaming sync writes (in
>>>> my case from kjournald but DIO would look the same) starve reads. This is
>>>> because reads happen in small chunks and until a request completes we don't
>>>> start reading further (reader reads lots of small files) while writers have
>>>> plenty of big requests to submit. Both processes end up fighting for IO
>>>> requests and writer writes nr_batching 512 KB requests while reader reads
>>>> just one 4 KB request or so. Here the effect is magnified by the fact that
>>>> the drive has relatively big queue depth so it usually takes longer than
>>>> BLK_BATCH_TIME to complete the read request. The net result is it takes
>>>> close to two minutes to read files that can be read under a second without
>>>> writer load. Without the big drive's queue depth, results are not ideal but
>>>> they are bearable - it takes about 20 seconds to do the reading. And for
>>>> comparison, when writer and reader are not competing for IO requests (as it
>>>> happens when writes are submitted as async), it takes about 2 seconds to
>>>> complete reading.
>>>>
>>>> Simple reproducer is:
>>>>
>>>> echo 3 >/proc/sys/vm/drop_caches
>>>> dd if=/dev/zero of=/tmp/f bs=1M count=10000 &
>>>> sleep 30
>>>> time cat /etc/* 2>&1 >/dev/null
>>>> killall dd
>>>> rm /tmp/f
>>>>
>>>>   The question is how can we fix this? Two quick hacks that come to my mind
>>>> are remove timeout from the batching logic (is it that important?) or
>>>> further separate request allocation logic so that reads have their own
>>>> request pool. More systematic fix would be to change request allocation
>>>> logic to always allow at least a fixed number of requests per IOC. What do
>>>> people think about this?
>>>
>>> As long as queue depth > workload iodepth, there is little we can do
>>> to prioritize tasks/IOC. Because throttling a task/IOC means queue
>>> will be idle. We don't want to idle a queue (especially for SSD), so
>>> we always push as more requests as possible to the queue, which
>>> will break any prioritization. As far as I know we always have such
>>> issue in CFQ for big queue depth disk.
>>   Yes, I understand that. But actually big queue depth on its own doesn't
>> make the problem really bad (at least for me). When the reader doesn't have
>> to wait for free IO requests, it progresses at a reasonable speed. What
>> makes it really bad is that big queue depth effectively disallows any use
>> of ioc_batching() mode for the reader and thus it blocks in request
>> allocation for every single read request unlike writer which always uses
>> its full batch (32 requests).
>
> I agree. This isn't about scheduling, we haven't even reached that part
> yet. Back when we split the queues into read vs write, this problem
> obviously wasn't there. Now we have sync writes and reads, both eating
> from the same pool. The io scheduler can impact this a bit by forcing
> reads to must allocate (Jan, which io scheduler are you using?). CFQ
> does this when it's expecting a request from this process queue.
>
> Back in the day, we used to have one list. To avoid a similar problem,
> we reserved the top of the list for reads. With the batching, it's a bit
> more complicated. If we make the request allocation (just that, not the
> scheduling) be read vs write instead of sync vs async, then we have the
> same issue for sync vs buffered writes.
>
> How about something like the below? Due to the nature of sync reads, we
> should allow a much longer timeout. The batch is really tailored towards
> writes at the moment. Also shrink the batch count, 32 is pretty large...

Does batching even make sense for dependent reads?  I don't think it
does.  Assuming you disagree, then you'll have to justify that fixed
time value of 2 seconds.  The amount of time between dependent reads
will vary depending on other I/O sent to the device, the properties of
the device, the I/O scheduler, and so on.  If you do stick 2 seconds in
there, please comment it.  Maybe it's time we started keeping track of
worst case Q->C time?  That could be used to tell worst case latency,
and adjust magic timeouts like this one.

I'm still thinking about how we might solve this in a cleaner way.

Cheers,
Jeff
