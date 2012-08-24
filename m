Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298Ab2HXU3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:29:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57984 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab2HXU3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:29:01 -0400
Date: Fri, 24 Aug 2012 13:28:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 07/13] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120824202855.GE21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-8-git-send-email-koverstreet@google.com>
 <20120822203003.GJ19212@google.com>
 <20120824055554.GC11977@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824055554.GC11977@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 23, 2012 at 10:55:54PM -0700, Kent Overstreet wrote:
> > Why aren't we turning off __GFP_WAIT instead?  e.g. What if the caller
> > has one of NUMA flags or __GFP_COLD specified?
> 
> Didn't think of that. The reason I did it that way is I wasn't sure if
> just doing &= ~__GFP_WAIT would be correct, since that would leave
> __GFP_IO|__GFP_FS set.

Using the appropriate __GFP_IO/FS flags is the caller's
responsibility.  The only thing bioset needs to worry and take action
about here is __GFP_WAIT causing indefinite wait in mempool.

> > Plesae don't mix struct definition relocation (or any relocation
> > really) with actual changes.  It buries the actual changes and makes
> > reviewing difficult.
> 
> Make a new patch that does nothing more than reorder the definitions,
> then?

Yeap, with justification.

>     block: Avoid deadlocks with bio allocation by stacking drivers
>     
>     Previously, if we ever try to allocate more than once from the same bio
>     set while running under generic_make_request() (i.e. a stacking block
>     driver), we risk deadlock.
>     
>     This is because of the code in generic_make_request() that converts
>     recursion to iteration; any bios we submit won't actually be submitted
>     (so they can complete and eventually be freed) until after we return -
>     this means if we allocate a second bio, we're blocking the first one
>     from ever being freed.
>     
>     Thus if enough threads call into a stacking block driver at the same
>     time with bios that need multiple splits, and the bio_set's reserve gets
>     used up, we deadlock.
>     
>     This can be worked around in the driver code - we could check if we're
>     running under generic_make_request(), then mask out __GFP_WAIT when we
>     go to allocate a bio, and if the allocation fails punt to workqueue and
>     retry the allocation.
>     
>     But this is tricky and not a generic solution. This patch solves it for
>     all users by inverting the previously described technique. We allocate a
>     rescuer workqueue for each bio_set, and then in the allocation code if
>     there are bios on current->bio_list we would be blocking, we punt them
>     to the rescuer workqueue to be submitted.
>     
>     Tested it by forcing the rescue codepath to be taken (by disabling the
>     first GFP_NOWAIT) attempt, and then ran it with bcache (which does a lot
>     of arbitrary bio splitting) and verified that the rescuer was being
>     invoked.

Yeah, the description looks good to me.

>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> +	gfp_t saved_gfp = gfp_mask;
>  	unsigned front_pad;
>  	unsigned inline_vecs;
>  	unsigned long idx = BIO_POOL_NONE;
> @@ -318,16 +336,44 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  		p = kmalloc(sizeof(struct bio) +
>  			    nr_iovecs * sizeof(struct bio_vec),
>  			    gfp_mask);
> +
>  		front_pad = 0;
>  		inline_vecs = nr_iovecs;
>  	} else {
> +		/*
> +		 * generic_make_request() converts recursion to iteration; this
> +		 * means if we're running beneath it, any bios we allocate and
> +		 * submit will not be submitted (and thus freed) until after we
> +		 * return.
> +		 *
> +		 * This exposes us to a potential deadlock if we allocate
> +		 * multiple bios from the same bio_set() while running
> +		 * underneath generic_make_request(). If we were to allocate
> +		 * multiple bios (say a stacking block driver that was splitting
> +		 * bios), we would deadlock if we exhausted the mempool's
> +		 * reserve.
> +		 *
> +		 * We solve this, and guarantee forward progress, with a rescuer
> +		 * workqueue per bio_set. If we go to allocate and there are
> +		 * bios on current->bio_list, we first try the allocation
> +		 * without __GFP_WAIT; if that fails, we punt those bios we
> +		 * would be blocking to the rescuer workqueue before we retry
> +		 * with the original gfp_flags.
> +		 */

Can you please add a comment in generic_make_request() to describe the
issue briefly and link back here?

>  void bioset_free(struct bio_set *bs)
>  {
> +	if (bs->rescue_workqueue)

Why is the conditional necessary?  Is it possible to have a bioset w/o
rescue_workqueue?

> +		destroy_workqueue(bs->rescue_workqueue);
> +
>  	if (bs->bio_pool)
>  		mempool_destroy(bs->bio_pool);

This makes bioset_free() require process context, which probably is
okay for bioset but still isn't nice.  Might worth noting in the patch
description.

Thanks.

-- 
tejun
