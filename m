Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2ERQFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:05:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58681 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788Ab2ERQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:05:15 -0400
Date: Fri, 18 May 2012 09:05:11 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 03/13] block: Add bio_clone_bioset()
Message-ID: <20120518160511.GC19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Thu, May 17, 2012 at 10:59:50PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> This consolidates some code, and will help in a later patch changing how
> bio cloning works.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

I'd prefer a bit more explanation on what's going on generally and why
and how dm conversion is different.

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3cc2169..3e33039 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1072,26 +1072,19 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
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
> +	clone = bio_clone_bioset(bio, GFP_NOIO, bs);
>  	clone->bi_sector = sector;
> -	clone->bi_idx = idx;
> -	clone->bi_vcnt = idx + bv_count;
> +	clone->bi_vcnt = bv_count;
>  	clone->bi_size = to_bytes(len);
> -	clone->bi_flags &= ~(1 << BIO_SEG_VALID);

Maybe removal of @idx deserves a separate patch?

> -	if (bio_integrity(bio)) {
> -		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
> -
> -		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
> -			bio_integrity_trim(clone,
> -					   bio_sector_offset(bio, idx, 0), len);
> -	}
> +	if (bio_integrity(bio) &&
> +	    clone->bi_size < bio->bi_size)

Unnecessary line break.

Other than that, looks good to me.

Thanks.

-- 
tejun
