Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2IXIoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:44:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64345 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2IXIoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:44:03 -0400
X-AuditID: 9c930197-b7b6dae000000e70-f0-50601d5093a3
From: Namhyung Kim <namhyung@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
References: <20120924145639.3b65fd8b@notabene.brown>
Date: Mon, 24 Sep 2012 17:35:34 +0900
In-Reply-To: <20120924145639.3b65fd8b@notabene.brown> (NeilBrown's message of
	"Mon, 24 Sep 2012 14:56:39 +1000")
Message-ID: <87txunyg15.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 24 Sep 2012 14:56:39 +1000, NeilBrown wrote:
> Hi Jens,
>  this patch has been sitting in my -next tree for a little while and I was
>  hoping for it to go in for the next merge window.
>  It simply allows bio_split() to be used on bios without a payload, such as
>  'discard'.
>  Are you happy with it going in though my 'md' tree, or would you rather take
>  it though your 'block' tree?
>
> Thanks,
> NeilBrown
>
>
> From: Shaohua Li <shli@fusionio.com>
> Date: Thu, 20 Sep 2012 09:36:03 +1000
> Subject: [PATCH] block: makes bio_split support bio without data
>
> discard bio hasn't data attached. We hit a BUG_ON with such bio. This makes
> bio_split works for such bio.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/fs/bio.c b/fs/bio.c
> index 71072ab..dbb7a6c 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1501,7 +1501,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
>  	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
>  				bi->bi_sector + first_sectors);
>  
> -	BUG_ON(bi->bi_vcnt != 1);
> +	BUG_ON(bi->bi_vcnt != 1 && bi->bi_vcnt != 0);

Why not
	BUG_ON(bi->bi_vcnt > 1);
?

Thanks,
Namhyung


>  	BUG_ON(bi->bi_idx != 0);
>  	atomic_set(&bp->cnt, 3);
>  	bp->error = 0;
> @@ -1511,17 +1511,19 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
>  	bp->bio2.bi_size -= first_sectors << 9;
>  	bp->bio1.bi_size = first_sectors << 9;
>  
> -	bp->bv1 = bi->bi_io_vec[0];
> -	bp->bv2 = bi->bi_io_vec[0];
> -	bp->bv2.bv_offset += first_sectors << 9;
> -	bp->bv2.bv_len -= first_sectors << 9;
> -	bp->bv1.bv_len = first_sectors << 9;
> +	if (bi->bi_vcnt != 0) {
> +		bp->bv1 = bi->bi_io_vec[0];
> +		bp->bv2 = bi->bi_io_vec[0];
> +		bp->bv2.bv_offset += first_sectors << 9;
> +		bp->bv2.bv_len -= first_sectors << 9;
> +		bp->bv1.bv_len = first_sectors << 9;
>  
> -	bp->bio1.bi_io_vec = &bp->bv1;
> -	bp->bio2.bi_io_vec = &bp->bv2;
> +		bp->bio1.bi_io_vec = &bp->bv1;
> +		bp->bio2.bi_io_vec = &bp->bv2;
>  
> -	bp->bio1.bi_max_vecs = 1;
> -	bp->bio2.bi_max_vecs = 1;
> +		bp->bio1.bi_max_vecs = 1;
> +		bp->bio2.bi_max_vecs = 1;
> +	}
>  
>  	bp->bio1.bi_end_io = bio_pair_end_1;
>  	bp->bio2.bi_end_io = bio_pair_end_2;
