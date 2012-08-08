Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab2HHXV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:21:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39992 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2HHXVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:21:25 -0400
Date: Wed, 8 Aug 2012 16:21:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 11/12] block: Add bio_clone_bioset()
Message-ID: <20120808232120.GK6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-12-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344290921-25154-12-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 03:08:40PM -0700, Kent Overstreet wrote:
> This consolidates some code, and will help in a later patch changing how
> bio cloning works.

I think it would be better to introduce bio_clone*() functions in a
separate patch and convert the users in a different one.

>  /**
> - *	bio_clone	-	clone a bio
> + *	bio_clone_bioset -	clone a bio
>   *	@bio: bio to clone
>   *	@gfp_mask: allocation priority
> + *	@bs: bio_set to allocate from
>   *
>   * 	Like __bio_clone, only also allocates the returned bio
>   */
> -struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> +struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
> +			     struct bio_set *bs)
>  {
> -	struct bio *b = bio_alloc(gfp_mask, bio->bi_max_vecs);
> +	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
>  
>  	if (!b)
>  		return NULL;
> @@ -485,7 +487,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
>  	if (bio_integrity(bio)) {
>  		int ret;
>  
> -		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
> +		ret = bio_integrity_clone(b, bio, gfp_mask, bs);
>  
>  		if (ret < 0) {
>  			bio_put(b);
> @@ -495,6 +497,12 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
>  
>  	return b;
>  }
> +EXPORT_SYMBOL(bio_clone_bioset);
> +
> +struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> +{
> +	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
> +}

So, bio_clone() loses its function comment.  Also, does it even make
sense to call bio_clone() from fs_bio_set?  Let's say it's so, then
what's the difference from using _kmalloc variant?

Thanks.

-- 
tejun
