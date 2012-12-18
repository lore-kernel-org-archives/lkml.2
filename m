Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2LREpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 23:45:08 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58411 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LREpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 23:45:06 -0500
Date: Mon, 17 Dec 2012 20:45:13 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] mm/swap: add independed bio pool for swap
In-Reply-To: <20121214110118.8387.66431.stgit@zurg>
Message-ID: <alpine.LNX.2.00.1212172024500.5927@eggly.anvils>
References: <20121214110118.8387.66431.stgit@zurg>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012, Konstantin Khlebnikov wrote:

> This bio pool guarantees reclaiming progress for anonymous pages.
> All avaliable bio in fs_bio_set may be borrowed by writeback which may
> never ends, because disk too slow or broken. I have seen this situation in
> real life in system where was a lot of bio requests to a loop device which
> laying on top of special fuse-based filesystem.

Hmm, perhaps, I'm not at all sure.

I don't particularly want to fragment off yet another pool if it's
not the right approach.  Or maybe it's loop or fuse which should
have the pool, rather than swap.

If the disk is slow, I'd expect us to be okay; but if it's not
responding at all, then yes, those mempools will remain exhausted.
You're imagining swap going to a more reliable disk, but it's being
starved by the unresponding disk, so deserves a separate pool?

Let's Cc Mel and Jens, who will each have plenty of experience of
running out of bios/mempools, and the proper way to avoid or accept it.

(Note that BIO_POOL_SIZE is only 2 nowadays: when mempools were
first introduced, indeed they were sized larger; but once we found so
much memory disappearing into them, they got cut down to the minimum
needed for forward progress - I forget why that's 2 not 1).

Hugh

> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>
> ---
>  mm/page_io.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 78eee32..699f85e 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -22,12 +22,14 @@
>  #include <linux/frontswap.h>
>  #include <asm/pgtable.h>
>  
> +static struct bio_set *swap_bio_set;
> +
>  static struct bio *get_swap_bio(gfp_t gfp_flags,
>  				struct page *page, bio_end_io_t end_io)
>  {
>  	struct bio *bio;
>  
> -	bio = bio_alloc(gfp_flags, 1);
> +	bio = bio_alloc_bioset(gfp_flags, 1, swap_bio_set);
>  	if (bio) {
>  		bio->bi_sector = map_swap_page(page, &bio->bi_bdev);
>  		bio->bi_sector <<= PAGE_SHIFT - 9;
> @@ -290,3 +292,12 @@ int swap_set_page_dirty(struct page *page)
>  		return __set_page_dirty_no_writeback(page);
>  	}
>  }
> +
> +static int __init swap_bio_init(void)
> +{
> +	swap_bio_set = bioset_create(SWAP_CLUSTER_MAX, 0);
> +	if (!swap_bio_set)
> +		panic("can't allocate swap_bio_set\n");
> +	return 0;
> +}
> +late_initcall(swap_bio_init);
