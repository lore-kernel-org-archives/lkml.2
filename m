Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2KWAQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:16:54 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47869 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2KWAQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:16:53 -0500
X-AuditID: 9c930179-b7c9dae000000e53-86-50aec0739b1c
Date: Fri, 23 Nov 2012 09:17:09 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: zram: Prevent use of unmapped buffer
Message-ID: <20121123001709.GF5121@bbox>
References: <1353580873-5227-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353580873-5227-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

Current next-20121115(I don't know why linux-next stay at the version. Is there
any problem on the tree? or Stephen go to holiday?) has a 37b51fdd(staging:
zram: factor-out zram_decompress_page() function) so this patch should be based
on that.

Thanks.

On Thu, Nov 22, 2012 at 02:41:13AM -0800, Nitin Gupta wrote:
> The commit c8f2f0db1 ("zram: Fix handling of incompressible pages")
> introduced a bug which caused a kunmap()'ed buffer to be used in case
> of partial writes where the data was found to be incompressible.
> 
> This fixes bug 50081:
> https://bugzilla.kernel.org/show_bug.cgi?id=50081
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
> Reported-by: Tomas M <tomas@slax.org>
> ---
>  drivers/staging/zram/zram_drv.c |   46 +++++++++++++++++++++++++--------------
>  1 file changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 6edefde..8d9133f 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -265,8 +265,13 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
>  	}
>  
>  	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
> -	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
> +	if (zram->table[index].size == PAGE_SIZE) {
> +		memcpy(mem, cmem, PAGE_SIZE);
> +		ret = LZO_E_OK;
> +	} else {
> +		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
>  				    mem, &clen);
> +	}
>  	zs_unmap_object(zram->mem_pool, handle);
>  
>  	/* Should NEVER happen. Return bio error if it does. */
> @@ -282,7 +287,7 @@ static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
>  static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  			   int offset)
>  {
> -	int ret;
> +	int ret = 0;
>  	size_t clen;
>  	unsigned long handle;
>  	struct page *page;
> @@ -303,10 +308,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  			goto out;
>  		}
>  		ret = zram_read_before_write(zram, uncmem, index);
> -		if (ret) {
> -			kfree(uncmem);
> +		if (ret)
>  			goto out;
> -		}
>  	}
>  
>  	/*
> @@ -319,16 +322,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  
>  	user_mem = kmap_atomic(page);
>  
> -	if (is_partial_io(bvec))
> +	if (is_partial_io(bvec)) {
>  		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
>  		       bvec->bv_len);
> -	else
> +		kunmap_atomic(user_mem);
> +		user_mem = NULL;
> +	} else {
>  		uncmem = user_mem;
> +	}
>  
>  	if (page_zero_filled(uncmem)) {
> -		kunmap_atomic(user_mem);
> -		if (is_partial_io(bvec))
> -			kfree(uncmem);
> +		if (!is_partial_io(bvec))
> +			kunmap_atomic(user_mem);
>  		zram_stat_inc(&zram->stats.pages_zero);
>  		zram_set_flag(zram, index, ZRAM_ZERO);
>  		ret = 0;
> @@ -338,9 +343,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
>  			       zram->compress_workmem);
>  
> -	kunmap_atomic(user_mem);
> -	if (is_partial_io(bvec))
> -			kfree(uncmem);
> +	if (!is_partial_io(bvec)) {
> +		kunmap_atomic(user_mem);
> +		user_mem = NULL;
> +		uncmem = NULL;
> +	}
>  
>  	if (unlikely(ret != LZO_E_OK)) {
>  		pr_err("Compression failed! err=%d\n", ret);
> @@ -349,8 +356,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  
>  	if (unlikely(clen > max_zpage_size)) {
>  		zram_stat_inc(&zram->stats.bad_compress);
> -		src = uncmem;
>  		clen = PAGE_SIZE;
> +		src = NULL;
> +		if (is_partial_io(bvec))
> +			src = uncmem;
>  	}
>  
>  	handle = zs_malloc(zram->mem_pool, clen);
> @@ -362,7 +371,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	}
>  	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
>  
> +	if ((clen == PAGE_SIZE) && !(is_partial_io(bvec)))
> +		src = kmap_atomic(page);
>  	memcpy(cmem, src, clen);
> +	if ((clen == PAGE_SIZE) && !(is_partial_io(bvec)))
> +		kunmap_atomic(src);
>  
>  	zs_unmap_object(zram->mem_pool, handle);
>  
> @@ -375,9 +388,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	if (clen <= PAGE_SIZE / 2)
>  		zram_stat_inc(&zram->stats.good_compress);
>  
> -	return 0;
> -
>  out:
> +	if (is_partial_io(bvec))
> +		kfree(uncmem);
> +
>  	if (ret)
>  		zram_stat64_inc(zram, &zram->stats.failed_writes);
>  	return ret;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
