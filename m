Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2GYLT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:19:56 -0400
Received: from natasha.panasas.com ([67.152.220.90]:34298 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab2GYLTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:19:55 -0400
Message-ID: <500FD63F.7050501@panasas.com>
Date: Wed, 25 Jul 2012 14:19:27 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dm-devel@redhat.com>, <tj@kernel.org>, <axboe@kernel.dk>,
        <agk@redhat.com>, <neilb@suse.de>, <drbd-dev@lists.linbit.com>,
        <vgoyal@redhat.com>, <mpatocka@redhat.com>, <sage@newdream.net>,
        <yehuda@hq.newdream.net>
Subject: Re: [PATCH v4 03/12] block: Add bio_reset()
References: <1343160689-12378-1-git-send-email-koverstreet@google.com> <1343160689-12378-4-git-send-email-koverstreet@google.com>
In-Reply-To: <1343160689-12378-4-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 11:11 PM, Kent Overstreet wrote:

> Reusing bios is something that's been highly frowned upon in the past,
> but driver code keeps doing it anyways. If it's going to happen anyways,
> we should provide a generic method.
> 
> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> was open coding it, by doing a bio_init() and resetting bi_destructor.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  fs/bio.c                  |   10 ++++++++++
>  include/linux/bio.h       |    1 +
>  include/linux/blk_types.h |    6 ++++++
>  3 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 1c6c8b7..252e253 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -261,6 +261,16 @@ void bio_init(struct bio *bio)
>  }
>  EXPORT_SYMBOL(bio_init);
>  
> +void bio_reset(struct bio *bio)
> +{
> +	/* Clear all flags below BIO_OWNS_VEC */
> +	unsigned long flags = bio->bi_flags & (~0UL << BIO_OWNS_VEC);
> +


Hey I have not seen these FLAGS thing before. Are these new?

Anyway. Please NO!!! for one you need to put a big fat comment
over at flags definitions. And two what happens when one adds
a new flag. Is it reset or not reset?

I'd rather you define a flags mask for those that need to be
preserved, at header, plus a comment that any needed-to-be-preserved
cross init flags, must be added to the mask.

Never, ever, hide such crap so deep in the code.

Boaz

> +	memset(bio, 0, BIO_RESET_BYTES);
> +	bio->bi_flags = flags|(1 << BIO_UPTODATE);
> +}
> +EXPORT_SYMBOL(bio_reset);
> +
>  /**
>   * bio_alloc_bioset - allocate a bio for I/O
>   * @gfp_mask:   the GFP_ mask given to the slab allocator
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 2643589..ba60319 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -226,6 +226,7 @@ extern void __bio_clone(struct bio *, struct bio *);
>  extern struct bio *bio_clone(struct bio *, gfp_t);
>  
>  extern void bio_init(struct bio *);
> +extern void bio_reset(struct bio *);
>  
>  extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
>  extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 293547e..40411e2 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -59,6 +59,10 @@ struct bio {
>  	unsigned int		bi_seg_front_size;
>  	unsigned int		bi_seg_back_size;
>  
> +	/*
> +	 * Everything starting with bi_max_vecs will be preserved by bio_reset()
> +	 */
> +
>  	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
>  
>  	atomic_t		bi_cnt;		/* pin count */
> @@ -93,6 +97,8 @@ struct bio {
>  	struct bio_vec		bi_inline_vecs[0];
>  };
>  
> +#define BIO_RESET_BYTES		offsetof(struct bio, bi_max_vecs)
> +
>  /*
>   * bio flags
>   */


