Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1JSQSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:18:02 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36404 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1JSQSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <m2aa8yymcl.fsf@firstfloor.org>
References: <CAGWyFtpaHvgDVV6DrM8L18eiDGrTL=teH6TZqfJNpwafE+-Big@mail.gmail.com>
	<m2aa8yymcl.fsf@firstfloor.org>
Date: Wed, 19 Oct 2011 12:17:58 -0400
Message-ID: <CAGWyFtpxuGnOhw7ukE2J+aQddLx6FtnSBvwV=RFaB7-c81GeNA@mail.gmail.com>
Subject: Re: [RFC][PATCH] dm-cache (block level disk cache target): UPDATE
From: Stephen Bromfield <s.bromfield@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, dm-cache@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mr.  Kleen,

We are working to make a patch for the 3.1 kernel. Till the patch is
complete, we hope that some of our users can benefit from this update.
As for your other comments, DM-cache is a work in progress and we will
try to address some of your issues in later patches. Thanks for your
feedback.

-Stephen B

On Tue, Oct 18, 2011 at 6:19 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Stephen Bromfield <s.bromfield@gmail.com> writes:
>
>> A new patch for the 2.6.39 kernel. Please CC all comments to
>
> Why 2.6.39? Like living in the past? 3.1 is current.
>
>
>> + ****************************************************************************/
>> +#include <linux/blk_types.h>
>> +#include <asm/atomic.h>
>
> Should be linux/atomic.h
>
>> +
>> +#define DMC_DEBUG 0
>> +
>> +#define DM_MSG_PREFIX "cache"
>> +#define DMC_PREFIX "dm-cache: "
>> +
>> +#if DMC_DEBUG
>> +#define DPRINTK( s, arg... ) printk(DMC_PREFIX s "\n", ##arg)
>> +#else
>> +#define DPRINTK( s, arg... )
>> +#endif
>
> Please use the standard pr_* calls for all of this.
>
>> +
>> +/* Default cache parameters */
>> +#define DEFAULT_CACHE_SIZE   65536
>> +#define DEFAULT_CACHE_ASSOC  1024
>> +#define DEFAULT_BLOCK_SIZE   8
>> +#define CONSECUTIVE_BLOCKS   512
>> +
>> +/* Write policy */
>> +#define WRITE_THROUGH 0
>> +#define WRITE_BACK 1
>> +#define DEFAULT_WRITE_POLICY WRITE_THROUGH
>> +
>> +/* Number of pages for I/O */
>> +#define DMCACHE_COPY_PAGES 1024
>
> Runtime tunable?
>
>
>> +#define is_state(x, y)               (x & y)
>> +#define set_state(x, y)              (x |= y)
>> +#define clear_state(x, y)    (x &= ~y)
>
> Brackets around macro arguments. In fact i don't see what you need the
> macros for. Just seems like obfuscation.
>
>> +/****************************************************************************
>> + *  Wrapper functions for using the new dm_io API
>> + ****************************************************************************/
>> +static int dm_io_sync_vm(unsigned int num_regions, struct dm_io_region
>> +     *where, int rw, void *data, unsigned long *error_bits, struct
>> cache_c *dmc)
>
> Functions with that many parameters are usually a mistake. You'll need
> more eventually. And nobody can read the calls. Same below.
>
>> +{
>> +     struct dm_io_request iorq;
>> +
>> +     iorq.bi_rw= rw;
>> +     iorq.mem.type = DM_IO_VMA;
>> +     iorq.mem.ptr.vma = data;
>> +     iorq.notify.fn = NULL;
>> +     iorq.client = dmc->io_client;
>> +
>> +     return dm_io(&iorq, num_regions, where, error_bits);
>> +}
>> +
>> +/*
>> + * Functions for handling pages used by async I/O.
>> + * The data asked by a bio request may not be aligned with cache blocks, in
>> + * which case additional pages are required for the request that is forwarded
>> + * to the server. A pool of pages are reserved for this purpose.
>> + */
>
> I don't think you need the separate page_list structures, you could
> just use page->lru. That would drop a lot of code.
>
>
>> +             spin_unlock(&dmc->lock);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     dmc->nr_free_pages -= nr;
>> +     for (*pages = pl = dmc->pages; --nr; pl = pl->next)
>> +             ;
>
> I'm sure there are clearer and safer ways to write such a loop.
>
> For once what happens when nr == 0?
>
>> +static void kcached_put_pages(struct cache_c *dmc, struct page_list *pl)
>> +{
>> +     struct page_list *cursor;
>> +
>> +     spin_lock(&dmc->lock);
>> +     for (cursor = pl; cursor->next; cursor = cursor->next)
>> +             dmc->nr_free_pages++;
>> +
>> +     dmc->nr_free_pages++;
>> +     cursor->next = dmc->pages;
>> +     dmc->pages = pl;
>> +
>> +     spin_unlock(&dmc->lock);
>
> Does that actually put/free anything? It's at least misnamed.
>
>> +static DEFINE_SPINLOCK(_job_lock);
>
> Locks are supposed to come with documentation what they protect.
>
> And why the _s ?
>
>> +
>
>> +     spin_lock_irqsave(&_job_lock, flags);
>> +     list_add_tail(&job->list, jobs);
>> +     spin_unlock_irqrestore(&_job_lock, flags);
>
> Hmm so you have a global lock for a list used in every IO?
>
> That does not look like it will scale to multiple devices or larger systems.
>
> It would be better to have this locking local to each volume at least.
>
>> +}
>> +
>> +
>> +/****************************************************************************
>> + * Functions for asynchronously fetching data from source device and storing
>> + * data in cache device. Because the requested data may not align with the
>> + * cache blocks, extra handling is required to pad a block request and extract
>> + * the requested data from the results.
>> + ****************************************************************************/
>> +
>> +static void io_callback(unsigned long error, void *context)
>> +{
>> +     struct kcached_job *job = (struct kcached_job *) context;
>> +
>> +     if (error) {
>> +             /* TODO */
>
> So what happens? Not handling IO errors seems like a big omission.
>
> Will they just not get reported or will you leak memory or corrupt data?
>
>> +             DMERR("io_callback: io error");
>> +             return;
>> +     }
>> +             while (head) {
>> +                     bvec[i].bv_len = min(head, (unsigned
>> int)PAGE_SIZE);
>
> Use min_t with the right type like the warning suggested (think of sign issues)
> Same below.
>
>> +             }
>> +
>> +             job->bvec = bvec;
>> +             r = dm_io_async_bvec(1, &job->src, READ, job->bvec, io_callback, job);
>> +             return r;
>> +     } else { /* The original request is a WRITE */
>> +             pl = job->pages;
>> +
>> +             if (head && tail) { /* Special case */
>> +                     bvec = kmalloc(job->nr_pages * sizeof(*bvec),
>> GFP_KERNEL);
>
> Wait a moment. Is that in the IO path?
>
> Then it should be GFP_NOFS at least to avoid recursion? Same below in
> lots of other places (did you ever test that under low memory?)
>
>
> Stopped reading here so far, but looks like there is plenty to do still.
>
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
>
