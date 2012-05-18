Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966290Ab2ERRwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:52:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966171Ab2ERRwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:52:21 -0400
Date: Fri, 18 May 2012 10:52:16 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 12/13] Make generic_make_request handle arbitrarily
 large bios
Message-ID: <20120518175216.GL19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Thu, May 17, 2012 at 10:59:59PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> The way the block layer is currently written, it goes to great lengths
> to avoid having to split bios; upper layer code (such as bio_add_page())
> checks what the underlying device can handle and tries to always create
> bios that don't need to be split.
> 
> But this approach becomes unwieldy and eventually breaks down with
> stacked devices and devices with dynamic limits, and it adds a lot of
> complexity. If the block layer could split bios as needed, we could
> eliminate a lot of complexity elsewhere - particularly in stacked
> drivers. Code that creates bios can then create whatever size bios are
> convenient, and more importantly stacked drivers don't have to deal with
> both their own bio size limitations and the limitations of the
> (potentially multiple) devices underneath them.

I generally like the idea.  Device limit directly being propagated to
high level users is cumbersome.  Somebody has to be splitting anyway
and doing it at top makes things, including limit propagation through
stacked drivers, unnecessarily complicated.  Jens, what are your
thoughts?

> +static void bio_submit_split_done(struct closure *cl)
> +{
> +	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
> +
> +	s->bio->bi_end_io	= s->bi_end_io;
> +	s->bio->bi_private	= s->bi_private;
> +	bio_endio(s->bio, 0);

I'd rather you didn't indent assignments.

> +	closure_debug_destroy(&s->cl);
> +	mempool_free(s, s->q->bio_split_hook);
> +}
...
> +static int bio_submit_split(struct bio *bio)

bool?

> +{
> +	struct bio_split_hook *s;
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +
> +	if (!bio_has_data(bio) ||
> +	    !q ||
> +	    !q->bio_split_hook ||
> +	    bio_sectors(bio) <= bio_max_sectors(bio))

Style issues.

> +		return 0;
> +
> +	s = mempool_alloc(q->bio_split_hook, GFP_NOIO);
> +
> +	closure_init(&s->cl, NULL);

Please use workqueue with open coded sequencer or maybe implement bio
sequencer which can be used by other stacking drivers too.

> +	s->bio		= bio;
> +	s->q		= q;
> +	s->bi_end_io	= bio->bi_end_io;
> +	s->bi_private	= bio->bi_private;
> +
> +	bio_get(bio);
> +	bio->bi_end_io	= bio_submit_split_endio;
> +	bio->bi_private	= &s->cl;

Maybe it's okay but I *hope* bi_private override weren't necessary -
it's way too subtle.  If there's no other way and this is gonna be an
integral part of block layer, just add a field to bio.

> +unsigned __bio_max_sectors(struct bio *bio, struct block_device *bdev,
> +			   sector_t sector)
> +{
> +	unsigned ret = bio_sectors(bio);
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	struct bio_vec *bv, *end = bio_iovec(bio) +
> +		min_t(int, bio_segments(bio), queue_max_segments(q));
> +
> +	struct bvec_merge_data bvm = {
> +		.bi_bdev	= bdev,
> +		.bi_sector	= sector,
> +		.bi_size	= 0,
> +		.bi_rw		= bio->bi_rw,
> +	};
> +
> +	if (bio_segments(bio) > queue_max_segments(q) ||
> +	    q->merge_bvec_fn) {
> +		ret = 0;
> +
> +		for (bv = bio_iovec(bio); bv < end; bv++) {
> +			if (q->merge_bvec_fn &&
> +			    q->merge_bvec_fn(q, &bvm, bv) < (int) bv->bv_len)
> +				break;
> +
> +			ret		+= bv->bv_len >> 9;
> +			bvm.bi_size	+= bv->bv_len;
> +		}
> +
> +		if (ret >= (BIO_MAX_PAGES * PAGE_SIZE) >> 9)
> +			return (BIO_MAX_PAGES * PAGE_SIZE) >> 9;
> +	}
> +
> +	ret = min(ret, queue_max_sectors(q));
> +
> +	WARN_ON(!ret);
> +	ret = max_t(int, ret, bio_iovec(bio)->bv_len >> 9);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(__bio_max_sectors);

Does this by any chance allow killing ->merge_bvec_fn()?  That would
be *awesome*.

Thanks.

-- 
tejun
