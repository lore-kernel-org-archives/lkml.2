Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab2HVUqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:46:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49265 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2HVUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:46:13 -0400
Date: Wed, 22 Aug 2012 13:46:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 10/13] block: Introduce new bio_split()
Message-ID: <20120822204608.GK19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-11-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-11-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 22, 2012 at 10:04:07AM -0700, Kent Overstreet wrote:
> @@ -672,7 +672,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
>  
>  	BUG_ON(bip == NULL);
>  	BUG_ON(bi == NULL);
> -	BUG_ON(!bio_flagged(bio, BIO_CLONED));
>  
>  	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
>  	bip->bip_sector = bip->bip_sector + offset;

It depends on what BIO_CLONED is supposed to do but maybe the right
thing to do is clearing BIO_CLONED on split bio?  The split bio isn't
a clone after all.

>  /**
> + * bio_split - split a bio
> + * @bio:	bio to split
> + * @sectors:	number of sectors to split from the front of @bio
> + * @gfp:	gfp mask
> + * @bs:		bio set to allocate from
> + *
> + * Allocates and returns a new bio which represents @sectors from the start of
> + * @bio, and updates @bio to represent the remaining sectors.
> + *
> + * If bio_sectors(@bio) was less than or equal to @sectors, returns @bio
> + * unchanged.

This is no longer true.

> + * The newly allocated bio will point to @bio's bi_io_vec, if the split was on a
> + * bvec boundry; it is the caller's responsibility to ensure that @bio is not
> + * freed before the split.
> + */
> +struct bio *bio_split(struct bio *bio, int sectors,
> +		      gfp_t gfp, struct bio_set *bs)
> +{
...
> +	if (bio_integrity(bio)) {
> +		bio_integrity_clone(split, bio, gfp, bs);

What happens if bio_integrity_clone() fails?

> +		bio_integrity_trim(split, 0, bio_sectors(split));
> +		bio_integrity_trim(bio, bio_sectors(split), bio_sectors(bio));

I complained pretty loudly about this not being mentioned in the
description of this patch or the following one and there still is no
explanation.  Come on, Kent.

> +static inline struct bio *bio_next_split(struct bio *bio, int sectors,
> +					 gfp_t gfp, struct bio_set *bs)
> +{
> +	if (sectors >= bio_sectors(bio))
> +		return bio;
> +
> +	return bio_split(bio, sectors, gfp, bs);
> +}

First of all, I don't think this is necessary.  In addition, this
doesn't have any comment explaining what it does and is never
mentioned or justified in patch description.  Kent, you're repeating
the same mistakes even after being explicitly pointed out multiple
times.  *Please* pay more attention.

Thanks.

-- 
tejun
