Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab1GKRwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:52:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49180 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab1GKRwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <4E1B37B1.9030608@fusionio.com>
References: <CAFR8uec5MxvHEWS=hgRXo1eunjQqWrpPCVXthdGMfWR+Yitw_A@mail.gmail.com>
	<4E1B37B1.9030608@fusionio.com>
Date: Mon, 11 Jul 2011 10:52:02 -0700
Message-ID: <CAFR8ueetLzSwTEc7D1zW4Yhd8t8iFbKvjJ07onWVQJbhzSOXLQ@mail.gmail.com>
Subject: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
 bio_add can make use of it.
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For this particular case, doing it when the bio is allocated makes more
> sense. That will avoid a similar error in there in the future.
>

Sounds good. Thanks. How about for other cases that alloc a new bio
and do bio_add_page() - like blkdev_issue_zeroout() and similar.
Should we add there too?


> Something ala the below.
>
> diff --git a/fs/mpage.c b/fs/mpage.c
> index fdfae9f..a2b8604 100644
> --- a/fs/mpage.c
> +++ b/fs/mpage.c
> @@ -80,7 +80,7 @@ static struct bio *mpage_bio_submit(int rw, struct bio *bio)
>
>  static struct bio *
>  mpage_alloc(struct block_device *bdev,
> -               sector_t first_sector, int nr_vecs,
> +               sector_t first_sector, int nr_vecs, int rw,
>                gfp_t gfp_flags)
>  {
>        struct bio *bio;
> @@ -93,8 +93,9 @@ mpage_alloc(struct block_device *bdev,
>        }
>
>        if (bio) {
> -               bio->bi_bdev = bdev;
>                bio->bi_sector = first_sector;
> +               bio->bi_bdev = bdev;
> +               bio->bi_rw = rw;
>        }
>        return bio;
>  }
> @@ -288,7 +289,7 @@ alloc_new:
>        if (bio == NULL) {
>                bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
>                                min_t(int, nr_pages, bio_get_nr_vecs(bdev)),
> -                               GFP_KERNEL);
> +                               READ, GFP_KERNEL);
>                if (bio == NULL)
>                        goto confused;
>        }
> @@ -580,7 +581,8 @@ page_is_mapped:
>  alloc_new:
>        if (bio == NULL) {
>                bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
> -                               bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
> +                               bio_get_nr_vecs(bdev), WRITE,
> +                               GFP_NOFS|__GFP_HIGH);
>                if (bio == NULL)
>                        goto confused;
>        }
>
> --
> Jens Axboe
>
>
