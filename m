Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab1IUVkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:40:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9593 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1IUVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:40:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=wOMilQwmL/tIc4Dr4Jna1UMqbvMm3Wp14fgC6zwOeM3BcRYQp4EwCMgunRXZH4WBG
	CWysj+geOQwhqdVKnDQew==
Date: Wed, 21 Sep 2011 14:39:58 -0700
From: Andrew Morton <akpm@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [patch, v2] aio: allocate kiocbs in batches
Message-Id: <20110921143958.df7105db.akpm@google.com>
In-Reply-To: <x49ipol3jfz.fsf@segfault.boston.devel.redhat.com>
References: <x49ipol3jfz.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011 13:16:00 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi,
> 
> In testing aio on a fast storage device, I found that the context lock
> takes up a fair amount of cpu time in the I/O submission path.  The
> reason is that we take it for every I/O submitted (see __aio_get_req).
> Since we know how many I/Os are passed to io_submit, we can preallocate
> the kiocbs in batches, reducing the number of times we take and release
> the lock.  In my testing, I was able to reduce the amount of time spent
> in _raw_spin_lock_irq by .56% (average of 3 runs).  The command I used
> to test this was:
>    aio-stress -O -o 2 -o 3 -r 8 -d 128 -b 32 -i 32 -s 16384 <dev>
> 
> I also tested the patch with various numbers of events passed to
> io_submit, and I ran the xfstests aio group of tests to ensure I didn't
> break anything.
>
> ...
>
> +/*
> + * struct kiocb's are allocated in batches to reduce the number of
> + * times the ctx lock is acquired and released.
> + */
> +#define KIOCB_BATCH_SIZE	32
> +struct kiocb_batch {
> +	struct list_head head;
> +	long total;	/* number of requests passed to sys_io_submit */
> +	long allocated;	/* number of requests allocated so far */
> +};

I don't see a reason why `total' and `allocated' need to be 64-bit. 
Making them 32-bit results in smaller code, smaller storage, smaller
d-cache footprint, etc.

Also, they should logically be unsigned types.

>
> ...
>
> +static int kiocb_batch_refill(struct kioctx *ctx, struct kiocb_batch *batch)
> +{
> +	int i;
> +	int to_alloc, avail;
> +	bool called_fput = false;
> +	struct kiocb *req, *n;
> +	struct aio_ring *ring;
> +
> +	to_alloc = min(batch->total - batch->allocated, KIOCB_BATCH_SIZE);

And this generates a compile-time warning due to the long/int mismatch.
Did your compiler not warn here?  (And why did `to_alloc' and `i' get
to be `int'?  The type choices are chaotic in there!)

I'd suggest going with "unsigned" for `total' and `allocated', and make
KIOCB_BATCH_SIZE 32U.  Then have a think about the appropriate types
for the derived locals such as `i', `to_alloc' and `avail'.

> +	for (i = 0; i < to_alloc; i++) {
> +		req = __aio_get_req(ctx);
> +		if (!req)
> +			/* allocation failed, go with what we've got */
> +			break;
> +		list_add(&req->ki_batch, &batch->head);
> +	}
> +
> +	if (i == 0)
> +		goto out;
> +
> +retry:
>  	spin_lock_irq(&ctx->ctx_lock);
> -	ring = kmap_atomic(ctx->ring_info.ring_pages[0], KM_USER0);
> -	if (ctx->reqs_active < aio_ring_avail(&ctx->ring_info, ring)) {
> +	ring = kmap_atomic(ctx->ring_info.ring_pages[0]);
> +
> +	avail = aio_ring_avail(&ctx->ring_info, ring) - ctx->reqs_active;
> +	BUG_ON(avail < 0);
> +	if (avail == 0 && !called_fput) {
> +		/*
> +		 * Handle a potential starvation case.  It is possible that
> +		 * we hold the last reference on a struct file, causing us
> +		 * to delay the final fput to non-irq context.  In this case,
> +		 * ctx->reqs_active is artificially high.  Calling the fput
> +		 * routine here may free up a slot in the event completion
> +		 * ring, allowing this allocation to succeed.
> +		 */
> +		spin_unlock_irq(&ctx->ctx_lock);
> +		kunmap_atomic(ring);

And there's a bug.  We need to maintain the thread's atomic state
across the kunmap_atomic().  This should have caused a might_sleep()
runtime warning from kunmap_atomic()'s smp_processor_id() (at least). 
That's assuming you tested on a 32-bit highmem box and were able to
exercise this codepath, neither of which seems likely ;)

> +		aio_fput_routine(NULL);
> +		called_fput = true;
> +		goto retry;
> +	}
> +
> +	if (avail < i) {
> +		/* Trim back the number of requests. */
> +		list_for_each_entry_safe(req, n, &batch->head, ki_batch) {
> +			list_del(&req->ki_batch);
> +			kmem_cache_free(kiocb_cachep, req);
> +			if (--i <= avail)
> +				break;
> +		}
> +	}
> +
> +	batch->allocated += i;
> +	list_for_each_entry(req, &batch->head, ki_batch) {
>  		list_add(&req->ki_list, &ctx->active_reqs);
>  		ctx->reqs_active++;
> -		okay = 1;
>  	}
> -	kunmap_atomic(ring, KM_USER0);
> -	spin_unlock_irq(&ctx->ctx_lock);
>  
> -	if (!okay) {
> -		kmem_cache_free(kiocb_cachep, req);
> -		req = NULL;
> -	}
> +	kunmap_atomic(ring);
> +	spin_unlock_irq(&ctx->ctx_lock);

Like that.

> -	return req;
> +out:
> +	return i;
>  }
>
> ...
>

I wouldn't want to do the long->unsigned conversion without runtime
testing it so can you please do a v3?

