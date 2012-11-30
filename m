Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2K3G6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 01:58:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53811 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2K3G6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 01:58:32 -0500
Message-ID: <50B85915.8020005@vflare.org>
Date: Thu, 29 Nov 2012 22:58:29 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: zram: fix invalid memory references during disk write
References: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
In-Reply-To: <1354257909-2380-1-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(somehow mail didn't go to the stable email alias and [PATCH] prefix was 
not added. CC'ed stable now)

On 11/29/2012 10:45 PM, Nitin Gupta wrote:
> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> of incompressible pages") which caused invalid memory references
> during disk write. Invalid references could occur in two cases:
>   - Incoming data expands on compression: In this case, reference was
> made to kunmap()'ed bio page.
>   - Partial (non PAGE_SIZE) write with incompressible data: In this
> case, reference was made to a kfree()'ed buffer.
>
> Fixes bug 50081:
> https://bugzilla.kernel.org/show_bug.cgi?id=50081
>
> Upstream commit ID: c8f2f0d: zram: Fix handling of incompressible pages
> Apply to versions: 3.6.5, 3.6.6, 3.6.7, 3.6.8
>
> Cc: <stable@vger.kernel.org> # staging-next: 37b51fd: zram: factor-out
> 				# zram_decompress_page() function
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
> Reported-by: Tomas M <tomas@slax.org>
> Reviewed-by: Minchan Kim <minchan@kernel.org>
> ---
>   drivers/staging/zram/zram_drv.c |   39 ++++++++++++++++++++++++---------------
>   1 file changed, 24 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index fb4a7c9..f2a73bd 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -265,7 +265,7 @@ out_cleanup:
>   static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>   			   int offset)
>   {
> -	int ret;
> +	int ret = 0;
>   	size_t clen;
>   	unsigned long handle;
>   	struct page *page;
> @@ -286,10 +286,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>   			goto out;
>   		}
>   		ret = zram_decompress_page(zram, uncmem, index);
> -		if (ret) {
> -			kfree(uncmem);
> +		if (ret)
>   			goto out;
> -		}
>   	}
>
>   	/*
> @@ -302,16 +300,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>
>   	user_mem = kmap_atomic(page);
>
> -	if (is_partial_io(bvec))
> +	if (is_partial_io(bvec)) {
>   		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
>   		       bvec->bv_len);
> -	else
> +		kunmap_atomic(user_mem);
> +		user_mem = NULL;
> +	} else {
>   		uncmem = user_mem;
> +	}
>
>   	if (page_zero_filled(uncmem)) {
> -		kunmap_atomic(user_mem);
> -		if (is_partial_io(bvec))
> -			kfree(uncmem);
> +		if (!is_partial_io(bvec))
> +			kunmap_atomic(user_mem);
>   		zram_stat_inc(&zram->stats.pages_zero);
>   		zram_set_flag(zram, index, ZRAM_ZERO);
>   		ret = 0;
> @@ -321,9 +321,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>   	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
>   			       zram->compress_workmem);
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
>   	if (unlikely(ret != LZO_E_OK)) {
>   		pr_err("Compression failed! err=%d\n", ret);
> @@ -332,8 +334,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>
>   	if (unlikely(clen > max_zpage_size)) {
>   		zram_stat_inc(&zram->stats.bad_compress);
> -		src = uncmem;
>   		clen = PAGE_SIZE;
> +		src = NULL;
> +		if (is_partial_io(bvec))
> +			src = uncmem;
>   	}
>
>   	handle = zs_malloc(zram->mem_pool, clen);
> @@ -345,7 +349,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>   	}
>   	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
>
> +	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
> +		src = kmap_atomic(page);
>   	memcpy(cmem, src, clen);
> +	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
> +		kunmap_atomic(src);
>
>   	zs_unmap_object(zram->mem_pool, handle);
>
> @@ -358,9 +366,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>   	if (clen <= PAGE_SIZE / 2)
>   		zram_stat_inc(&zram->stats.good_compress);
>
> -	return 0;
> -
>   out:
> +	if (is_partial_io(bvec))
> +		kfree(uncmem);
> +
>   	if (ret)
>   		zram_stat64_inc(zram, &zram->stats.failed_writes);
>   	return ret;
> --
> 1.7.10.4
>

