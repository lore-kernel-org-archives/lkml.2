Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab2HHWWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:22:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41526 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2HHWW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:22:29 -0400
Date: Wed, 8 Aug 2012 15:22:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Message-ID: <20120808222223.GD6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344290921-25154-6-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 06, 2012 at 03:08:34PM -0700, Kent Overstreet wrote:
> Now that we've got generic code for freeing bios allocated from bio
> pools, this isn't needed anymore.
> 
> This also changes the semantics of bio_free() a bit - it now also frees
> bios allocated by bio_kmalloc(). It's also no longer exported, as
> without bi_destructor there should be no need for it to be called
> anywhere else.
> 
> v5: Switch to BIO_KMALLOC_POOL ((void *)~0), per Boaz
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> index 920ede2..19bf632 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -161,23 +161,12 @@ static const struct block_device_operations drbd_ops = {
>  	.release = drbd_release,
>  };
>  
> -static void bio_destructor_drbd(struct bio *bio)
> -{
> -	bio_free(bio, drbd_md_io_bio_set);
> -}
> -
>  struct bio *bio_alloc_drbd(gfp_t gfp_mask)
>  {
> -	struct bio *bio;
> -
>  	if (!drbd_md_io_bio_set)
>  		return bio_alloc(gfp_mask, 1);
>  
> -	bio = bio_alloc_bioset(gfp_mask, 1, drbd_md_io_bio_set);
> -	if (!bio)
> -		return NULL;
> -	bio->bi_destructor = bio_destructor_drbd;
> -	return bio;
> +	return bio_alloc_bioset(gfp_mask, 1, drbd_md_io_bio_set);
>  }

Does this chunk belong to this patch?

> @@ -56,6 +56,8 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
>   */
>  struct bio_set *fs_bio_set;
>  
> +#define BIO_KMALLOC_POOL ((void *) ~0)

What's wrong with good ol' NULL?

Thanks.

-- 
tejun
