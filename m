Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2J2RO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:14:26 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49517 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109Ab2J2ROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:14:24 -0400
Message-ID: <508EB96C.4040505@vflare.org>
Date: Mon, 29 Oct 2012 10:14:20 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] zram: factor-out zram_decompress_page() function
References: <20121027160052.GA4771@swordfish>
In-Reply-To: <20121027160052.GA4771@swordfish>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 09:00 AM, Sergey Senozhatsky wrote:
>    zram: factor-out zram_decompress_page() function
>
>    zram_bvec_read() shared decompress functionality with zram_read_before_write() function.
>    Factor-out and make commonly used zram_decompress_page() function, which also simplified
>    error handling in zram_bvec_read().
>
>    Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>
> ---
>
>   drivers/staging/zram/zram_drv.c | 115 +++++++++++++++++-----------------------
>   1 file changed, 50 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 6edefde..7585467 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -183,62 +183,25 @@ static inline int is_partial_io(struct bio_vec *bvec)
>   	return bvec->bv_len != PAGE_SIZE;
>   }
>
> -static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> -			  u32 index, int offset, struct bio *bio)
> +static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>   {
> -	int ret;
> -	size_t clen;
> -	struct page *page;
> -	unsigned char *user_mem, *cmem, *uncmem = NULL;
> -
> -	page = bvec->bv_page;
> -
> -	if (zram_test_flag(zram, index, ZRAM_ZERO)) {
> -		handle_zero_page(bvec);
> -		return 0;
> -	}
> +	int ret = LZO_E_OK;
> +	size_t clen = PAGE_SIZE;
> +	unsigned char *cmem;
> +	unsigned long handle = zram->table[index].handle;
>
> -	/* Requested page is not present in compressed area */
> -	if (unlikely(!zram->table[index].handle)) {
> -		pr_debug("Read before write: sector=%lu, size=%u",
> -			 (ulong)(bio->bi_sector), bio->bi_size);
> -		handle_zero_page(bvec);
> +	if (!handle || zram_test_flag(zram, index, ZRAM_ZERO)) {
> +		memset(mem, 0, PAGE_SIZE);
>   		return 0;
>   	}
>
> -	if (is_partial_io(bvec)) {
> -		/* Use  a temporary buffer to decompress the page */
> -		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -		if (!uncmem) {
> -			pr_info("Error allocating temp memory!\n");
> -			return -ENOMEM;
> -		}
> -	}
> -
> -	user_mem = kmap_atomic(page);
> -	if (!is_partial_io(bvec))
> -		uncmem = user_mem;
> -	clen = PAGE_SIZE;
> -
> -	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
> -				ZS_MM_RO);
> -
> -	if (zram->table[index].size == PAGE_SIZE) {
> -		memcpy(uncmem, cmem, PAGE_SIZE);
> -		ret = LZO_E_OK;
> -	} else {
> +	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
> +	if (zram->table[index].size == PAGE_SIZE)
> +		memcpy(mem, cmem, PAGE_SIZE);
> +	else
>   		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
> -				    uncmem, &clen);
> -	}
> -
> -	if (is_partial_io(bvec)) {
> -		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
> -		       bvec->bv_len);
> -		kfree(uncmem);
> -	}
> -
> -	zs_unmap_object(zram->mem_pool, zram->table[index].handle);
> -	kunmap_atomic(user_mem);
> +						mem, &clen);
> +	zs_unmap_object(zram->mem_pool, handle);
>
>   	/* Should NEVER happen. Return bio error if it does. */
>   	if (unlikely(ret != LZO_E_OK)) {
> @@ -247,36 +210,58 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>   		return ret;
>   	}
>
> -	flush_dcache_page(page);
> -
>   	return 0;
>   }
>
> -static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
> +static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> +			  u32 index, int offset, struct bio *bio)
>   {
>   	int ret;
> -	size_t clen = PAGE_SIZE;
> -	unsigned char *cmem;
> -	unsigned long handle = zram->table[index].handle;
> +	struct page *page;
> +	unsigned char *user_mem, *uncmem = NULL;
>
> -	if (zram_test_flag(zram, index, ZRAM_ZERO) || !handle) {
> -		memset(mem, 0, PAGE_SIZE);
> +	page = bvec->bv_page;
> +
> +	if (unlikely(!zram->table[index].handle) ||
> +			zram_test_flag(zram, index, ZRAM_ZERO)) {
> +		pr_debug("Read before write: sector=%lu, size=%u",
> +			 (ulong)(bio->bi_sector), bio->bi_size);


"Read before write" message is not valid in case ZRAM_ZERO flag is set. 
Its true only in !handle case.

Otherwise, the patch looks good to me.

On a side note, zram still contains a known use-after-free bug reported 
by Fengguang Wu (CC'ed) which happens in the "partial I/O" i.e. non 
PAGE_SIZE'ed I/O case which is fixed by the following patch.

Please let me know if you can include the following patch when you 
resend this patch series, or I can do the same or will wait for this to 
be merged and then send it later.

======
zram: Fix use-after-free in partial I/O case

When the compressed size of a page exceeds a threshold, the page is 
stored as-is i.e. in uncompressed form. In the partial I/O i.e. 
non-PAGE_SIZE'ed I/O case, however, the uncompressed memory was being 
freed before it could be copied into the zsmalloc pool resulting in 
use-after-free bug.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

diff --git a/drivers/staging/zram/zram_drv.c 
b/drivers/staging/zram/zram_drv.c
index 7585467..635736b 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -288,10 +288,8 @@ static int zram_bvec_write(struct zram *zram, 
struct bio_vec *bvec, u32 index,
  			goto out;
  		}
  		ret = zram_decompress_page(zram, uncmem, index);
-		if (ret) {
-			kfree(uncmem);
+		if (ret)
  			goto out;
-		}
  	}

  	/*
@@ -312,8 +310,6 @@ static int zram_bvec_write(struct zram *zram, struct 
bio_vec *bvec, u32 index,

  	if (page_zero_filled(uncmem)) {
  		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
  		zram_stat_inc(&zram->stats.pages_zero);
  		zram_set_flag(zram, index, ZRAM_ZERO);
  		ret = 0;
@@ -324,8 +320,6 @@ static int zram_bvec_write(struct zram *zram, struct 
bio_vec *bvec, u32 index,
  			       zram->compress_workmem);

  	kunmap_atomic(user_mem);
-	if (is_partial_io(bvec))
-			kfree(uncmem);

  	if (unlikely(ret != LZO_E_OK)) {
  		pr_err("Compression failed! err=%d\n", ret);
@@ -360,11 +354,15 @@ static int zram_bvec_write(struct zram *zram, 
struct bio_vec *bvec, u32 index,
  	if (clen <= PAGE_SIZE / 2)
  		zram_stat_inc(&zram->stats.good_compress);

-	return 0;
+	ret = 0;

  out:
  	if (ret)
  		zram_stat64_inc(zram, &zram->stats.failed_writes);
+
+	if (is_partial_io(bvec))
+		kfree(uncmem);
+
  	return ret;
  }


BTW, I could not trigger this partial I/O case, so please let me know if 
you hit any issue during your testing.

There is another sparse warning to be fixed: zram_reset_device should be 
static.

Thanks,
Nitin

