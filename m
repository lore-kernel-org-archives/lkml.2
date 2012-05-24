Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2EXQij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:38:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2EXQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:38:36 -0400
Date: Thu, 24 May 2012 09:38:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 03/14] block: Add bio_clone_bioset()
Message-ID: <20120524163831.GE27983@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337817771-25038-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 05:02:40PM -0700, Kent Overstreet wrote:
> This consolidates some code, and will help in a later patch changing how
> bio cloning works.

Which consolidations are happening and which drivers are being
affected how?

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index e6e7b19..e5076f2 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1062,26 +1062,19 @@ static struct bio *split_bvec(struct bio *bio, sector_t sector,
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

Why is this safe?  If it's only bioset related API changes, why are
there other changes at all?  If the new clone interface can handle
bioset fine, do we still need to expose __bio_clone()?

> -	if (bio_integrity(bio)) {
> -		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
> -
> -		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
> -			bio_integrity_trim(clone,
> -					   bio_sector_offset(bio, idx, 0), len);
> -	}
> +	if (bio_integrity(bio) &&
> +	    clone->bi_size < bio->bi_size)
> +		bio_integrity_trim(clone, 0, len);

Why is idx != bi_idx test dropped?

I'm gonna stop here on this series.  It doesn't seem like the issues
pointed out before have been addressed.  I recommend spending more
effort on patch descriptions.  Writing descriptions is not only
important for reviewing and history but it's a good step in ensuring
the patches are sane and properly split.  If you can't explain each
change in the patch, it generally means either the changes themselves
are wrong or wrongly split.

Thanks.

-- 
tejun
