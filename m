Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1IVNYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:24:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab1IVNYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:24:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [patch, v2] aio: allocate kiocbs in batches
References: <x49ipol3jfz.fsf@segfault.boston.devel.redhat.com>
	<20110921143958.df7105db.akpm@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 22 Sep 2011 09:24:04 -0400
In-Reply-To: <20110921143958.df7105db.akpm@google.com> (Andrew Morton's
	message of "Wed, 21 Sep 2011 14:39:58 -0700")
Message-ID: <x49aa9whfrf.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@google.com> writes:

> On Wed, 21 Sep 2011 13:16:00 -0400
> Jeff Moyer <jmoyer@redhat.com> wrote:
>
>>
>> +/*
>> + * struct kiocb's are allocated in batches to reduce the number of
>> + * times the ctx lock is acquired and released.
>> + */
>> +#define KIOCB_BATCH_SIZE	32
>> +struct kiocb_batch {
>> +	struct list_head head;
>> +	long total;	/* number of requests passed to sys_io_submit */
>> +	long allocated;	/* number of requests allocated so far */
>> +};
>
> I don't see a reason why `total' and `allocated' need to be 64-bit. 
> Making them 32-bit results in smaller code, smaller storage, smaller
> d-cache footprint, etc.
>
> Also, they should logically be unsigned types.

The number of iocbs passed into sys_io_submit is of type long, and so
the total and the number allocated need to be of the same size.  I
considered unsigned, but seeing as the value would be capped at long, I
didn't see a real compelling reason to switch to unsigned.

Now, I suppose I could do with a single variable there, and just
decrement it as kiocbs are allocated.

>>
>> +static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
>> +{
>> +	int i;
>> +	int to_alloc, avail;
>> +	bool called_fput = false;
>> +	struct kiocb *req, *n;
>> +	struct aio_ring *ring;
>> +
>> +	to_alloc = min(batch->total - batch->allocated, KIOCB_BATCH_SIZE);
>
> And this generates a compile-time warning due to the long/int mismatch.
> Did your compiler not warn here?  (And why did `to_alloc' and `i' get
> to be `int'?  The type choices are chaotic in there!)

Oops, I missed the warning.  to_alloc and i won't be very big, since
they are capped at KIOCB_BATCH_SIZE.  I could use an unsigned short.

> I'd suggest going with "unsigned" for `total' and `allocated', and make
> KIOCB_BATCH_SIZE 32U.  Then have a think about the appropriate types
> for the derived locals such as `i', `to_alloc' and `avail'.

As mentioned above, I'd like to stick with signed types, and I'll use
just a single long for the number of kiocbs left to allocate.

>> +		spin_unlock_irq(&ctx->ctx_lock);
>> +		kunmap_atomic(ring);
>
> And there's a bug.  We need to maintain the thread's atomic state
> across the kunmap_atomic().  This should have caused a might_sleep()
> runtime warning from kunmap_atomic()'s smp_processor_id() (at least). 
> That's assuming you tested on a 32-bit highmem box and were able to
> exercise this codepath, neither of which seems likely ;)

I'll fix it.  You are right, I didn't test 32-bit highmem....

>> ...
>>
>
> I wouldn't want to do the long->unsigned conversion without runtime
> testing it so can you please do a v3?

No problem.

Cheers,
Jeff
