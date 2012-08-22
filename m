Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2HVURh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:17:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44344 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2HVURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:17:35 -0400
Date: Wed, 22 Aug 2012 13:17:30 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 06/13] block: Consolidate bio_alloc_bioset(),
 bio_kmalloc()
Message-ID: <20120822201730.GI19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-7-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-7-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 22, 2012 at 10:04:03AM -0700, Kent Overstreet wrote:
> Previously, bio_kmalloc() and bio_alloc_bioset() behaved slightly
> different because there was some almost-duplicated code - this fixes
> that issue.

What were those slight differences?  Why is it safe to change the
behaviors to match each other?

>  struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  {
> +	unsigned front_pad;
> +	unsigned inline_vecs;
>  	unsigned long idx = BIO_POOL_NONE;
>  	struct bio_vec *bvl = NULL;
>  	struct bio *bio;
>  	void *p;
>  
> -	p = mempool_alloc(bs->bio_pool, gfp_mask);
> +	if (nr_iovecs > UIO_MAXIOV)
> +		return NULL;

This test used to only happen for bio_kmalloc().  If I follow the code
I can see that UIO_MAXIOV is larger than BIOVEC_MAX_IDX, so this
doesn't really affect the capability of bioset allocs; however, given
that bioset allocation already checks against BIOVEC_MAX_IDX, I don't
see why this test is now also applied to them.

> +	if (bs == BIO_KMALLOC_POOL) {
> +		p = kmalloc(sizeof(struct bio) +
> +			    nr_iovecs * sizeof(struct bio_vec),
> +			    gfp_mask);
> +		front_pad = 0;
> +		inline_vecs = nr_iovecs;
> +	} else {
> +		p = mempool_alloc(bs->bio_pool, gfp_mask);
> +		front_pad = bs->front_pad;
> +		inline_vecs = BIO_INLINE_VECS;
> +	}
> +
>  	if (unlikely(!p))
>  		return NULL;
> -	bio = p + bs->front_pad;
>  
> +	bio = p + front_pad;
>  	bio_init(bio);
> -	bio->bi_pool = bs;
>  
> -	if (unlikely(!nr_iovecs))
> -		goto out_set;
> -
> -	if (nr_iovecs <= BIO_INLINE_VECS) {
> -		bvl = bio->bi_inline_vecs;
> -		nr_iovecs = BIO_INLINE_VECS;
> -	} else {
> +	if (nr_iovecs > inline_vecs) {
>  		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
>  		if (unlikely(!bvl))
>  			goto err_free;
> -
> -		nr_iovecs = bvec_nr_vecs(idx);
> +	} else if (nr_iovecs) {
> +		bvl = bio->bi_inline_vecs;
>  	}
> -out_set:
> +
> +	bio->bi_pool = bs;
>  	bio->bi_flags |= idx << BIO_POOL_OFFSET;
>  	bio->bi_max_vecs = nr_iovecs;
>  	bio->bi_io_vec = bvl;
> @@ -331,63 +340,6 @@ err_free:
>  }
>  EXPORT_SYMBOL(bio_alloc_bioset);

> +extern struct bio_set *fs_bio_set;
> +
> +static inline struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
> +{
> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
> +}
> +
> +#define BIO_KMALLOC_POOL NULL
> +
> +static inline struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
> +{
> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, BIO_KMALLOC_POOL);
> +}

And we lose /** comments on two exported functions and
bio_alloc_bioset() comment doesn't explain that it now also handles
NULL bioset case.  Now that they share common implementation, you can
update bio_alloc_bioset() and refer to it from its wrappers but please
don't drop them like this.

Thanks.

-- 
tejun
