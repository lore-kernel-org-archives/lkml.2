Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2HGDSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:18:02 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64022 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab2HGDSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <1343160689-12378-13-git-send-email-koverstreet@google.com>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
	<1343160689-12378-13-git-send-email-koverstreet@google.com>
Date: Mon, 6 Aug 2012 20:17:58 -0700
Message-ID: <CAFR8ued4XmZUAL9RVnmdSspRom14u6rCZmhohJGChPqwfPOdfQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/12] block: Only clone bio vecs that are in use
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com,
        neilb@suse.de, drbd-dev@lists.linbit.com, bharrosh@panasas.com,
        vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net,
        yehuda@hq.newdream.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 24, 2012 at 1:11 PM, Kent Overstreet <koverstreet@google.com> wrote:
> bcache creates large bios internally, and then splits them according to
> the device requirements before it sends them down. If a lower level
> device tries to clone the bio, and the original bio had more than
> BIO_MAX_PAGES, the clone will fail unecessarily.
>
> We can fix this by only cloning the bio vecs that are actually in use.
>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

<snip>

>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3f3c26e..193fb19 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1057,11 +1057,10 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
>  {
>         struct bio *clone;
>
> -       clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
> +       clone = bio_alloc_bioset(GFP_NOIO, bv_count, bs);

Number of io_vecs allocated in clone is different. Please see my comment below.

>         __bio_clone(clone, bio);
>         clone->bi_sector = sector;
> -       clone->bi_idx = idx;
> -       clone->bi_vcnt = idx + bv_count;
> +       clone->bi_vcnt = bv_count;
>         clone->bi_size = to_bytes(len);
>         clone->bi_flags &= ~(1 << BIO_SEG_VALID);
>
> diff --git a/fs/bio.c b/fs/bio.c
> index 7a0801d..ec6a357 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -451,8 +451,9 @@ EXPORT_SYMBOL(bio_phys_segments);
>   */
>  void __bio_clone(struct bio *bio, struct bio *bio_src)
>  {
> -       memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
> -               bio_src->bi_max_vecs * sizeof(struct bio_vec));
> +       memcpy(bio->bi_io_vec,
> +              bio_iovec(bio_src),
> +              bio_segments(bio_src) * sizeof(struct bio_vec));
>


You are changing the meaning of __bio_clone() here. In old code, the
number of io_vecs, bi_idx, bi_vcnt are preserved. But in this modified
code, you are mapping bio_src's bi_iovec[bi_idx] to bio_dests
bi_iovec[0] and also restricting the number of allocated io_vecs of
the clone. It may be useful for cases were we would like a identical
copy of the original bio (may not be in current code base, but this
implementation is definitely not what one would expect from the name
"clone").

May be, call this new implementation some thing else (and use it for bcache)?

Regards,
Muthu



>         /*
>          * most users will be overriding ->bi_bdev with a new target,
> @@ -461,10 +462,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
>         bio->bi_sector = bio_src->bi_sector;
>         bio->bi_bdev = bio_src->bi_bdev;
>         bio->bi_flags |= 1 << BIO_CLONED;
> +       bio->bi_flags &= ~(1 << BIO_SEG_VALID);
>         bio->bi_rw = bio_src->bi_rw;
> -       bio->bi_vcnt = bio_src->bi_vcnt;
> +       bio->bi_vcnt = bio_segments(bio_src);
>         bio->bi_size = bio_src->bi_size;
> -       bio->bi_idx = bio_src->bi_idx;
>  }
>  EXPORT_SYMBOL(__bio_clone);
>
> @@ -479,7 +480,7 @@ EXPORT_SYMBOL(__bio_clone);
>  struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
>                              struct bio_set *bs)
>  {
> -       struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
> +       struct bio *b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);
>
>         if (!b)
>                 return NULL;
> @@ -509,7 +510,7 @@ EXPORT_SYMBOL(bio_clone);
>
>  struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
>  {
> -       struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
> +       struct bio *b = bio_kmalloc(gfp_mask, bio_segments(bio));
>
>         if (!b)
>                 return NULL;
> --
> 1.7.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
