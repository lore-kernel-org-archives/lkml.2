Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab2ERRIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 13:08:07 -0400
Received: from natasha.panasas.com ([67.152.220.90]:59770 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988Ab2ERRIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 13:08:01 -0400
Message-ID: <4FB681DC.7000700@panasas.com>
Date: Fri, 18 May 2012 20:07:40 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: <koverstreet@google.com>
CC: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
        <tj@kernel.org>, <axboe@kernel.dk>, <agk@redhat.com>, <neilb@suse.de>
Subject: Re: [PATCH 09/13] block: Add an explicit bio flag for bios that own
 their bvec
References: <cover.1337308722.git.koverstreet@google.com> <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet@google.com>
In-Reply-To: <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 05:59 AM, koverstreet@google.com wrote:

> From: Kent Overstreet <koverstreet@google.com>
> 
> This is for the new bio splitting code. When we split a bio, if the
> split occured on a bvec boundry we reuse the bvec for the new bio. But
> that means bio_free() can't free it, hence the explicit flag.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  fs/bio.c                  |    3 ++-
>  include/linux/blk_types.h |    1 +
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index ecc9088..3332800 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -234,7 +234,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
>  {
>  	void *p;
>  
> -	if (bio_has_allocated_vec(bio))
> +	if (bio_flagged(bio, BIO_HAS_VEC))
>  		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
>  
>  	if (bio_integrity(bio))
> @@ -305,6 +305,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
>  			goto err_free;
>  
>  		nr_iovecs = bvec_nr_vecs(idx);
> +		bio->bi_flags |= 1 << BIO_HAS_VEC;
>  	}
>  out_set:
>  	bio->bi_flags |= idx << BIO_POOL_OFFSET;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index bd9a610..10fca21 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -101,6 +101,7 @@ struct bio {
>  #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
>  #define BIO_QUIET	10	/* Make BIO Quiet */
>  #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
> +#define BIO_HAS_VEC	12	/* bio_free() should free bvec */


Just an English nit
BIO with out any VECs is when bi_max_vecs is zero. Id prefer a name that
denotes allocation or ownership.
BIO_OWN_VEC or BIO_ALLOC_VEC or BIO_DELETE_VEC

And one technical problem.

I would prefer to negate this bit. Zero is the default, set on
the exception. Safer and also more logical.

 BIO_NO_DELETE_VEC

>  #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
>  
>  /*



Thanks
Boaz
