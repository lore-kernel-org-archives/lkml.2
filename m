Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2J2RgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:36:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58721 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2J2RgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:36:12 -0400
Date: Mon, 29 Oct 2012 20:33:45 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] zram: factor-out zram_decompress_page() function
Message-ID: <20121029173345.GC3706@swordfish.minsk.epam.com>
References: <20121027160052.GA4771@swordfish>
 <508EB96C.4040505@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508EB96C.4040505@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/29/12 10:14), Nitin Gupta wrote:
> 
> "Read before write" message is not valid in case ZRAM_ZERO flag is
> set. Its true only in !handle case.
> 

do we actually need this message?


> Otherwise, the patch looks good to me.
> 
> On a side note, zram still contains a known use-after-free bug
> reported by Fengguang Wu (CC'ed) which happens in the "partial I/O"
> i.e. non PAGE_SIZE'ed I/O case which is fixed by the following patch.
> 
> Please let me know if you can include the following patch when you
> resend this patch series, or I can do the same or will wait for this
> to be merged and then send it later.
>

Nitin, I think let's deal with one change at a time. I'll try to resend my patch
shortly, then we can continue with your fix (I didn't hit that problem, though
will be happy to help with testing).

	-ss

 
> ======
> zram: Fix use-after-free in partial I/O case
> 
> When the compressed size of a page exceeds a threshold, the page is
> stored as-is i.e. in uncompressed form. In the partial I/O i.e.
> non-PAGE_SIZE'ed I/O case, however, the uncompressed memory was being
> freed before it could be copied into the zsmalloc pool resulting in
> use-after-free bug.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
> 
> diff --git a/drivers/staging/zram/zram_drv.c
> b/drivers/staging/zram/zram_drv.c
> index 7585467..635736b 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -288,10 +288,8 @@ static int zram_bvec_write(struct zram *zram,
> struct bio_vec *bvec, u32 index,
>  			goto out;
>  		}
>  		ret = zram_decompress_page(zram, uncmem, index);
> -		if (ret) {
> -			kfree(uncmem);
> +		if (ret)
>  			goto out;
> -		}
>  	}
> 
>  	/*
> @@ -312,8 +310,6 @@ static int zram_bvec_write(struct zram *zram,
> struct bio_vec *bvec, u32 index,
> 
>  	if (page_zero_filled(uncmem)) {
>  		kunmap_atomic(user_mem);
> -		if (is_partial_io(bvec))
> -			kfree(uncmem);
>  		zram_stat_inc(&zram->stats.pages_zero);
>  		zram_set_flag(zram, index, ZRAM_ZERO);
>  		ret = 0;
> @@ -324,8 +320,6 @@ static int zram_bvec_write(struct zram *zram,
> struct bio_vec *bvec, u32 index,
>  			       zram->compress_workmem);
> 
>  	kunmap_atomic(user_mem);
> -	if (is_partial_io(bvec))
> -			kfree(uncmem);
> 
>  	if (unlikely(ret != LZO_E_OK)) {
>  		pr_err("Compression failed! err=%d\n", ret);
> @@ -360,11 +354,15 @@ static int zram_bvec_write(struct zram *zram,
> struct bio_vec *bvec, u32 index,
>  	if (clen <= PAGE_SIZE / 2)
>  		zram_stat_inc(&zram->stats.good_compress);
> 
> -	return 0;
> +	ret = 0;
> 
>  out:
>  	if (ret)
>  		zram_stat64_inc(zram, &zram->stats.failed_writes);
> +
> +	if (is_partial_io(bvec))
> +		kfree(uncmem);
> +
>  	return ret;
>  }
> 
> 
> BTW, I could not trigger this partial I/O case, so please let me know
> if you hit any issue during your testing.
> 
> There is another sparse warning to be fixed: zram_reset_device should
> be static.
> 
> Thanks,
> Nitin
> 
