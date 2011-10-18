Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1JRWTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 18:19:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:17689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416Ab1JRWTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 18:19:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,366,1315206000"; 
   d="scan'208";a="63913039"
From: Andi Kleen <andi@firstfloor.org>
To: Stephen Bromfield <s.bromfield@gmail.com>
Cc: linux-kernel@vger.kernel.org, dm-cache@googlegroups.com
Subject: Re: [RFC][PATCH] dm-cache (block level disk cache target): UPDATE
References: <CAGWyFtpaHvgDVV6DrM8L18eiDGrTL=teH6TZqfJNpwafE+-Big@mail.gmail.com>
Date: Tue, 18 Oct 2011 15:19:06 -0700
In-Reply-To: <CAGWyFtpaHvgDVV6DrM8L18eiDGrTL=teH6TZqfJNpwafE+-Big@mail.gmail.com>
	(Stephen Bromfield's message of "Tue, 18 Oct 2011 16:46:00 -0400")
Message-ID: <m2aa8yymcl.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Bromfield <s.bromfield@gmail.com> writes:

> A new patch for the 2.6.39 kernel. Please CC all comments to

Why 2.6.39? Like living in the past? 3.1 is current.


> + ****************************************************************************/
> +#include <linux/blk_types.h>
> +#include <asm/atomic.h>

Should be linux/atomic.h

> +
> +#define DMC_DEBUG 0
> +
> +#define DM_MSG_PREFIX "cache"
> +#define DMC_PREFIX "dm-cache: "
> +
> +#if DMC_DEBUG
> +#define DPRINTK( s, arg... ) printk(DMC_PREFIX s "\n", ##arg)
> +#else
> +#define DPRINTK( s, arg... )
> +#endif

Please use the standard pr_* calls for all of this.

> +
> +/* Default cache parameters */
> +#define DEFAULT_CACHE_SIZE	65536
> +#define DEFAULT_CACHE_ASSOC	1024
> +#define DEFAULT_BLOCK_SIZE	8
> +#define CONSECUTIVE_BLOCKS	512
> +
> +/* Write policy */
> +#define WRITE_THROUGH 0
> +#define WRITE_BACK 1
> +#define DEFAULT_WRITE_POLICY WRITE_THROUGH
> +
> +/* Number of pages for I/O */
> +#define DMCACHE_COPY_PAGES 1024

Runtime tunable?


> +#define is_state(x, y)		(x & y)
> +#define set_state(x, y)		(x |= y)
> +#define clear_state(x, y)	(x &= ~y)

Brackets around macro arguments. In fact i don't see what you need the
macros for. Just seems like obfuscation.

> +/****************************************************************************
> + *  Wrapper functions for using the new dm_io API
> + ****************************************************************************/
> +static int dm_io_sync_vm(unsigned int num_regions, struct dm_io_region
> +	*where, int rw, void *data, unsigned long *error_bits, struct
> cache_c *dmc)

Functions with that many parameters are usually a mistake. You'll need
more eventually. And nobody can read the calls. Same below.

> +{
> +	struct dm_io_request iorq;
> +
> +	iorq.bi_rw= rw;
> +	iorq.mem.type = DM_IO_VMA;
> +	iorq.mem.ptr.vma = data;
> +	iorq.notify.fn = NULL;
> +	iorq.client = dmc->io_client;
> +
> +	return dm_io(&iorq, num_regions, where, error_bits);
> +}
> +
> +/*
> + * Functions for handling pages used by async I/O.
> + * The data asked by a bio request may not be aligned with cache blocks, in
> + * which case additional pages are required for the request that is forwarded
> + * to the server. A pool of pages are reserved for this purpose.
> + */

I don't think you need the separate page_list structures, you could
just use page->lru. That would drop a lot of code.
 

> +		spin_unlock(&dmc->lock);
> +		return -ENOMEM;
> +	}
> +
> +	dmc->nr_free_pages -= nr;
> +	for (*pages = pl = dmc->pages; --nr; pl = pl->next)
> +		;

I'm sure there are clearer and safer ways to write such a loop.

For once what happens when nr == 0?

> +static void kcached_put_pages(struct cache_c *dmc, struct page_list *pl)
> +{
> +	struct page_list *cursor;
> +
> +	spin_lock(&dmc->lock);
> +	for (cursor = pl; cursor->next; cursor = cursor->next)
> +		dmc->nr_free_pages++;
> +
> +	dmc->nr_free_pages++;
> +	cursor->next = dmc->pages;
> +	dmc->pages = pl;
> +
> +	spin_unlock(&dmc->lock);

Does that actually put/free anything? It's at least misnamed.

> +static DEFINE_SPINLOCK(_job_lock);

Locks are supposed to come with documentation what they protect.

And why the _s ? 

> +

> +	spin_lock_irqsave(&_job_lock, flags);
> +	list_add_tail(&job->list, jobs);
> +	spin_unlock_irqrestore(&_job_lock, flags);

Hmm so you have a global lock for a list used in every IO?

That does not look like it will scale to multiple devices or larger systems.

It would be better to have this locking local to each volume at least.

> +}
> +
> +
> +/****************************************************************************
> + * Functions for asynchronously fetching data from source device and storing
> + * data in cache device. Because the requested data may not align with the
> + * cache blocks, extra handling is required to pad a block request and extract
> + * the requested data from the results.
> + ****************************************************************************/
> +
> +static void io_callback(unsigned long error, void *context)
> +{
> +	struct kcached_job *job = (struct kcached_job *) context;
> +
> +	if (error) {
> +		/* TODO */

So what happens? Not handling IO errors seems like a big omission.

Will they just not get reported or will you leak memory or corrupt data?

> +		DMERR("io_callback: io error");
> +		return;
> +	}
> +		while (head) {
> +			bvec[i].bv_len = min(head, (unsigned
> int)PAGE_SIZE);

Use min_t with the right type like the warning suggested (think of sign issues)
Same below.

> +		}
> +
> +		job->bvec = bvec;
> +		r = dm_io_async_bvec(1, &job->src, READ, job->bvec, io_callback, job);
> +		return r;
> +	} else { /* The original request is a WRITE */
> +		pl = job->pages;
> +
> +		if (head && tail) { /* Special case */
> +			bvec = kmalloc(job->nr_pages * sizeof(*bvec),
> GFP_KERNEL);

Wait a moment. Is that in the IO path? 

Then it should be GFP_NOFS at least to avoid recursion? Same below in
lots of other places (did you ever test that under low memory?)


Stopped reading here so far, but looks like there is plenty to do still.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
