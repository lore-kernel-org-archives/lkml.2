Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2JBPhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:37:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2JBPhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:37:51 -0400
Date: Tue, 2 Oct 2012 11:37:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 02/26] block: Convert integrity to
 bvec_alloc_bs()
Message-ID: <20121002153736.GA3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-3-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348526106-17074-3-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 03:34:42PM -0700, Kent Overstreet wrote:

[..]
>  /**
>   * bio_integrity_alloc - Allocate integrity payload and attach it to bio
>   * @bio:	bio to attach integrity metadata to
> @@ -84,37 +47,39 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
>  						  unsigned int nr_vecs)
>  {
>  	struct bio_integrity_payload *bip;
> -	unsigned int idx = vecs_to_idx(nr_vecs);
>  	struct bio_set *bs = bio->bi_pool;
> +	unsigned long idx = BIO_POOL_NONE;
> +	unsigned inline_vecs;
> +
> +	if (!bs) {
> +		bip = kmalloc(sizeof(struct bio_integrity_payload) +
> +			      sizeof(struct bio_vec) * nr_vecs, gfp_mask);
> +		inline_vecs = nr_vecs;
> +	} else {
> +		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
> +		inline_vecs = BIP_INLINE_VECS;
> +	}
>  
> -	if (!bs)
> -		bs = fs_bio_set;

Ok, this is change of behavior. Previously we will fall back to fs_bio_set
and now you do kmalloc. This change looks to be independent of bip_vec
pointer. Can you please break it out in a separate patch and also explain
that how does this change help.

Thanks
Vivek
