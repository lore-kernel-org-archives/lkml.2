Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737Ab2EOQTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:19:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45772 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965660Ab2EOQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:19:09 -0400
Date: Tue, 15 May 2012 09:19:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 01/16] Only clone bio vecs that are in use
Message-ID: <20120515161904.GA17216@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, May 09, 2012 at 11:08:13PM -0400, Kent Overstreet wrote:
> Bcache creates large bios internally, and then splits them according to
> the requirements of the underlying device. If the underlying device then
> needs to clone the bio, the clone will fail if the original bio had more
> than 256 segments - even if bi_vcnt - bi_idx was smaller.

I think this is a useful change outside the context of bcache.  How
about generalizing the description a bit and send it to Jens w/ block:
tag?

> @@ -1078,28 +1078,22 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
>   * Creates a bio that consists of range of complete bvecs.
>   */
>  static struct bio *clone_bio(struct bio *bio, sector_t sector,
> -			     unsigned short idx, unsigned short bv_count,
> +			     unsigned short bv_count,
>  			     unsigned int len, struct bio_set *bs)
>  {
>  	struct bio *clone;
>  
> -	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
> -	__bio_clone(clone, bio);
> -	clone->bi_destructor = dm_bio_destructor;
> +	clone = bio_clone_bioset(bio, GFP_NOIO, bs);
>  	clone->bi_sector = sector;
> -	clone->bi_idx = idx;
> -	clone->bi_vcnt = idx + bv_count;
> +	clone->bi_vcnt = bv_count;
>  	clone->bi_size = to_bytes(len);
>  	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
> -
> -	if (bio_integrity(bio)) {
> -		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
> -
> +#if 0
> +	if (bio_integrity(bio))
>  		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
>  			bio_integrity_trim(clone,
>  					   bio_sector_offset(bio, idx, 0), len);
> -	}
> -
> +#endif
>  	return clone;
>  }

Hmmm... I wish these changes are done in separate steps.  ie.

1. Add void *bi_destructor_data to bio so that BIO_HAS_POOL trickery,
   which BTW is broken - this patch doesn't build, isn't necessary and
   destructors can be consolidated - bio_alloc_bioset() can set
   bi_destructor() and bi_destructor_data automatically so that only
   the ones which want to override the default allocation need to
   bother.

2. Introduce bio_clone_bioset() without the allocation change and
   convert md (and whoever applicable).

3. Change the behavior such that only bio_segments() is copied.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ce88755..961c995 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -194,7 +194,8 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
>  	if (!mddev || !mddev->bio_set)
>  		return bio_clone(bio, gfp_mask);
>  
> -	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs,
> +	b = bio_alloc_bioset(gfp_mask,
> +			     bio_segments(bio),
>  			     mddev->bio_set);

Line broken unnecessarily?

> @@ -53,6 +53,7 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
>   * IO code that does not need private memory pools.
>   */
>  struct bio_set *fs_bio_set;
> +EXPORT_SYMBOL(fs_bio_set);

Is making bio_clone() an inline function really worth it?

> @@ -341,8 +337,10 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
>  {
>  	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
>  
> -	if (bio)
> -		bio->bi_destructor = bio_fs_destructor;
> +	if (bio) {
> +		bio->bi_flags |= 1 << BIO_HAS_POOL;
> +		bio->bi_destructor = (void *) fs_bio_set;
> +	}

Wrote above but it looks like the patch is missing some part of
BIO_HAS_POOL handling.  Doesn't build.  Also, it's a pretty ugly hack.

>  /**
> - * 	__bio_clone	-	clone a bio
> - * 	@bio: destination bio
> - * 	@bio_src: bio to clone
> + *	__bio_clone	-	clone a bio
> + *	@bio: destination bio
> + *	@bio_src: bio to clone
>   *
>   *	Clone a &bio. Caller will own the returned bio, but not
>   *	the actual data it points to. Reference count of returned
> - * 	bio will be one.
> + *	bio will be one.

Whilespace cleanup?  I'm okay with doing these as part of larger
changes but would appreciate if these were noted in the commit message
in the form of "while at it, blah blah...".

>   */
>  void __bio_clone(struct bio *bio, struct bio *bio_src)
>  {
> -	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
> -		bio_src->bi_max_vecs * sizeof(struct bio_vec));
> +	memcpy(bio->bi_io_vec,
> +	       bio_iovec(bio_src),
> +	       bio_segments(bio_src) * sizeof(struct bio_vec));

Unnecessary line break?

> -struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> +struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
> +			     struct bio_set *bs)
>  {
> -	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
> -
> +	struct bio *b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);

Blank line between var decls and body please.

>  	if (!b)
>  		return NULL;
>  
> -	b->bi_destructor = bio_fs_destructor;
>  	__bio_clone(b, bio);
> +	b->bi_flags	|= 1 << BIO_HAS_POOL;

No indenting of assignments please.  There are some exceptions when
there are a lot of assignments and not aligning makes it very
difficult to read but I don't think that applies here.

> +	b->bi_destructor = (void *) bs;
>  
>  	if (bio_integrity(bio)) {
>  		int ret;
>  
> -		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
> +		ret = bio_integrity_clone(b, bio, gfp_mask, bs);

You'll probably need to update bio_integrity about the same way.  It
does about the same thing as bio alloc path.

Thanks.

-- 
tejun
