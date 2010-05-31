Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0EaPvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:51:21 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:39141 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab0EaPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DVuwiJNzruEi/jSVWOz6LOnKg2jV/CCFHzqeNDWuEWu7UwQ+RcYMvooZm6rpgndKkH
         q0WPm96FU0RhpMWiSxOdX0+5Vm2r/y+nC8FkGFGWmAoHS6XzcbJeUsP+hMFPdfc6oqZm
         10CW/NCKJ8jKUjTWKHwgO7VFLL6hC383Uclz8=
Subject: Re: [PATCH 1/3] Support generic I/O requests
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1274710685-2351-2-git-send-email-ngupta@vflare.org>
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org>
	 <1274710685-2351-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 00:41:11 +0900
Message-ID: <1275320471.15980.24.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Nitin.
Sorry for late review. 

On Mon, 2010-05-24 at 19:48 +0530, Nitin Gupta wrote:
> Currently, ramzwap devices (/dev/ramzswapX) can only
> be used as swap disks since it was hard-coded to consider
> only the first request in bio vector.
> 
> Now, we iterate over all the segments in an incoming
> bio which allows us to handle all kinds of I/O requests.
> 
> ramzswap devices can still handle PAGE_SIZE aligned and
> multiple of PAGE_SIZE sized I/O requests only. To ensure
> that we get always get such requests only, we set following
> request_queue attributes to PAGE_SIZE:
>  - physical_block_size
>  - logical_block_size
>  - io_min
>  - io_opt
> 
> Note: physical and logical block sizes were already set
> equal to PAGE_SIZE and that seems to be sufficient to get
> PAGE_SIZE aligned I/O.
> 
> Since we are no longer limited to handling swap requests
> only, the next few patches rename ramzswap to zram. So,
> the devices will then be called /dev/zram{0, 1, 2, ...}
> 
> Usage/Examples:
>  1) Use as /tmp storage
>  - mkfs.ext4 /dev/zram0
>  - mount /dev/zram0 /tmp
> 
>  2) Use as swap:
>  - mkswap /dev/zram0
>  - swapon /dev/zram0 -p 10 # give highest priority to zram0
> 
> Performance:
> 
>  - I/O benchamark done with 'dd' command. Details can be
> found here:
> http://code.google.com/p/compcache/wiki/zramperf
> Summary:
>  - Maximum read speed (approx):
>    - ram disk: 1200 MB/sec
>    - zram disk: 600 MB/sec
>  - Maximum write speed (approx):
>    - ram disk: 500 MB/sec
>    - zram disk: 160 MB/sec
> 
> Issues:
> 
>  - Double caching: We can potentially waste memory by having
> two copies of a page -- one in page cache (uncompress) and
> second in the device memory (compressed). However, during
> reclaim, clean page cache pages are quickly freed, so this
> does not seem to be a big problem.
> 
>  - Stale data: Not all filesystems support issuing 'discard'
> requests to underlying block devices. So, if such filesystems
> are used over zram devices, we can accumulate lot of stale
> data in memory. Even for filesystems to do support discard
> (example, ext4), we need to see how effective it is.
> 
>  - Scalability: There is only one (per-device) de/compression
> buffer stats. This can lead to significant contention, especially
> when used for generic (non-swap) purposes.

Later, we could enhance it by per-cpu counter. 

> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
> ---
>  drivers/staging/ramzswap/ramzswap_drv.c |  325 ++++++++++++++-----------------
>  1 files changed, 148 insertions(+), 177 deletions(-)
> 
> diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
> index d14bf91..9d20d23 100644
> --- a/drivers/staging/ramzswap/ramzswap_drv.c
> +++ b/drivers/staging/ramzswap/ramzswap_drv.c
> @@ -101,20 +101,6 @@ static void ramzswap_set_disksize(struct ramzswap *rzs, size_t totalram_bytes)
>  	rzs->disksize &= PAGE_MASK;
>  }
>  
> -/*
> - * Swap header (1st page of swap device) contains information
> - * about a swap file/partition. Prepare such a header for the
> - * given ramzswap device so that swapon can identify it as a
> - * swap partition.
> - */
> -static void setup_swap_header(struct ramzswap *rzs, union swap_header *s)
> -{
> -	s->info.version = 1;
> -	s->info.last_page = (rzs->disksize >> PAGE_SHIFT) - 1;
> -	s->info.nr_badpages = 0;
> -	memcpy(s->magic.magic, "SWAPSPACE2", 10);
> -}
> -
>  static void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
>  			struct ramzswap_ioctl_stats *s)
>  {
> @@ -202,31 +188,22 @@ out:
>  	rzs->table[index].offset = 0;
>  }
>  
> -static int handle_zero_page(struct bio *bio)
> +static void handle_zero_page(struct page *page, u32 index)

It doesn't use index. 

>  {
>  	void *user_mem;
> -	struct page *page = bio->bi_io_vec[0].bv_page;
>  
>  	user_mem = kmap_atomic(page, KM_USER0);
>  	memset(user_mem, 0, PAGE_SIZE);
>  	kunmap_atomic(user_mem, KM_USER0);
>  
>  	flush_dcache_page(page);
> -
> -	set_bit(BIO_UPTODATE, &bio->bi_flags);
> -	bio_endio(bio, 0);
> -	return 0;
>  }
>  
> -static int handle_uncompressed_page(struct ramzswap *rzs, struct bio *bio)
> +static void handle_uncompressed_page(struct ramzswap *rzs,
> +				struct page *page, u32 index)
>  {
> -	u32 index;
> -	struct page *page;
>  	unsigned char *user_mem, *cmem;
>  
> -	page = bio->bi_io_vec[0].bv_page;
> -	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
> -
>  	user_mem = kmap_atomic(page, KM_USER0);
>  	cmem = kmap_atomic(rzs->table[index].page, KM_USER1) +
>  			rzs->table[index].offset;
> @@ -236,79 +213,72 @@ static int handle_uncompressed_page(struct ramzswap *rzs, struct bio *bio)
>  	kunmap_atomic(cmem, KM_USER1);
>  
>  	flush_dcache_page(page);
> -
> -	set_bit(BIO_UPTODATE, &bio->bi_flags);
> -	bio_endio(bio, 0);
> -	return 0;
> -}
> -
> -/*
> - * Called when request page is not present in ramzswap.
> - * This is an attempt to read before any previous write
> - * to this location - this happens due to readahead when
> - * swap device is read from user-space (e.g. during swapon)
> - */
> -static int handle_ramzswap_fault(struct ramzswap *rzs, struct bio *bio)
> -{
> -	pr_debug("Read before write on swap device: "
> -		"sector=%lu, size=%u, offset=%u\n",
> -		(ulong)(bio->bi_sector), bio->bi_size,
> -		bio->bi_io_vec[0].bv_offset);
> -
> -	/* Do nothing. Just return success */
> -	set_bit(BIO_UPTODATE, &bio->bi_flags);
> -	bio_endio(bio, 0);
> -	return 0;
>  }
>  
>  static int ramzswap_read(struct ramzswap *rzs, struct bio *bio)
>  {
> -	int ret;
> +
> +	int i;
>  	u32 index;
> -	size_t clen;
> -	struct page *page;
> -	struct zobj_header *zheader;
> -	unsigned char *user_mem, *cmem;
> +	struct bio_vec *bvec;
>  
>  	rzs_stat64_inc(rzs, &rzs->stats.num_reads);
>  
> -	page = bio->bi_io_vec[0].bv_page;
>  	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
> +	bio_for_each_segment(bvec, bio, i) {
> +		int ret;
> +		size_t clen;
> +		struct page *page;
> +		struct zobj_header *zheader;
> +		unsigned char *user_mem, *cmem;
>  
> -	if (rzs_test_flag(rzs, index, RZS_ZERO))
> -		return handle_zero_page(bio);
> +		page = bvec->bv_page;
>  
> -	/* Requested page is not present in compressed area */
> -	if (!rzs->table[index].page)
> -		return handle_ramzswap_fault(rzs, bio);
> +		if (rzs_test_flag(rzs, index, RZS_ZERO)) {
> +			handle_zero_page(page, index);
> +			continue;
> +		}
>  
> -	/* Page is stored uncompressed since it's incompressible */
> -	if (unlikely(rzs_test_flag(rzs, index, RZS_UNCOMPRESSED)))
> -		return handle_uncompressed_page(rzs, bio);
> +		/* Requested page is not present in compressed area */
> +		if (unlikely(!rzs->table[index].page)) {
> +			pr_debug("Read before write on swap device: "
                                                         ^^^^
It's not ramzswap any more. It is zram. :)

> +				"sector=%lu, size=%u",
> +				(ulong)(bio->bi_sector), bio->bi_size);
> +			/* Do nothing */
> +			continue;
> +		}
>  
> -	user_mem = kmap_atomic(page, KM_USER0);
> -	clen = PAGE_SIZE;
> +		/* Page is stored uncompressed since it's incompressible */
> +		if (unlikely(rzs_test_flag(rzs, index, RZS_UNCOMPRESSED))) {
> +			handle_uncompressed_page(rzs, page, index);
> +			continue;
> +		}
>  
> -	cmem = kmap_atomic(rzs->table[index].page, KM_USER1) +
> -			rzs->table[index].offset;
> +		user_mem = kmap_atomic(page, KM_USER0);
> +		clen = PAGE_SIZE;
>  
> -	ret = lzo1x_decompress_safe(
> -		cmem + sizeof(*zheader),
> -		xv_get_object_size(cmem) - sizeof(*zheader),
> -		user_mem, &clen);
> +		cmem = kmap_atomic(rzs->table[index].page, KM_USER1) +
> +				rzs->table[index].offset;
>  
> -	kunmap_atomic(user_mem, KM_USER0);
> -	kunmap_atomic(cmem, KM_USER1);
> +		ret = lzo1x_decompress_safe(
> +			cmem + sizeof(*zheader),
> +			xv_get_object_size(cmem) - sizeof(*zheader),
> +			user_mem, &clen);
>  
> -	/* should NEVER happen */
> -	if (unlikely(ret != LZO_E_OK)) {
> -		pr_err("Decompression failed! err=%d, page=%u\n",
> -			ret, index);
> -		rzs_stat64_inc(rzs, &rzs->stats.failed_reads);
> -		goto out;
> -	}
> +		kunmap_atomic(user_mem, KM_USER0);
> +		kunmap_atomic(cmem, KM_USER1);
>  
> -	flush_dcache_page(page);
> +		/* should NEVER happen */
> +		if (unlikely(ret != LZO_E_OK)) {
> +			pr_err("Decompression failed! err=%d, page=%u\n",
> +				ret, index);
> +			rzs_stat64_inc(rzs, &rzs->stats.failed_reads);
> +			goto out;
> +		}
> +
> +		flush_dcache_page(page);
> +		index++;
> +	}
>  
>  	set_bit(BIO_UPTODATE, &bio->bi_flags);
>  	bio_endio(bio, 0);
> @@ -321,108 +291,120 @@ out:
>  
>  static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
>  {
> -	int ret;
> -	u32 offset, index;
> -	size_t clen;
> -	struct zobj_header *zheader;
> -	struct page *page, *page_store;
> -	unsigned char *user_mem, *cmem, *src;
> +	int i;
> +	u32 index;
> +	struct bio_vec *bvec;
>  
>  	rzs_stat64_inc(rzs, &rzs->stats.num_writes);
>  
> -	page = bio->bi_io_vec[0].bv_page;
>  	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
>  
> -	src = rzs->compress_buffer;
> +	bio_for_each_segment(bvec, bio, i) {
> +		int ret;
> +		u32 offset;
> +		size_t clen;
> +		struct zobj_header *zheader;
> +		struct page *page, *page_store;
> +		unsigned char *user_mem, *cmem, *src;
>  
> -	mutex_lock(&rzs->lock);
> +		page = bvec->bv_page;
> +		src = rzs->compress_buffer;
>  
> -	user_mem = kmap_atomic(page, KM_USER0);
> -	if (page_zero_filled(user_mem)) {
> -		kunmap_atomic(user_mem, KM_USER0);
> -		mutex_unlock(&rzs->lock);
> -		rzs_stat_inc(&rzs->stats.pages_zero);
> -		rzs_set_flag(rzs, index, RZS_ZERO);
> +		/*
> +		 * System overwrites unused sectors. Free memory associated
> +		 * with this sector now.
> +		 */
> +		if (rzs->table[index].page ||
> +				rzs_test_flag(rzs, index, RZS_ZERO))
> +			ramzswap_free_page(rzs, index);
>  
> -		set_bit(BIO_UPTODATE, &bio->bi_flags);
> -		bio_endio(bio, 0);
> -		return 0;
> -	}
> +		mutex_lock(&rzs->lock);
>  
> -	ret = lzo1x_1_compress(user_mem, PAGE_SIZE, src, &clen,
> -				rzs->compress_workmem);
> +		user_mem = kmap_atomic(page, KM_USER0);
> +		if (page_zero_filled(user_mem)) {
> +			kunmap_atomic(user_mem, KM_USER0);
> +			mutex_unlock(&rzs->lock);
> +			rzs_stat_inc(&rzs->stats.pages_zero);
> +			rzs_set_flag(rzs, index, RZS_ZERO);
> +			continue;
> +		}
>  
> -	kunmap_atomic(user_mem, KM_USER0);
> +		ret = lzo1x_1_compress(user_mem, PAGE_SIZE, src, &clen,
> +					rzs->compress_workmem);
>  
> -	if (unlikely(ret != LZO_E_OK)) {
> -		mutex_unlock(&rzs->lock);
> -		pr_err("Compression failed! err=%d\n", ret);
> -		rzs_stat64_inc(rzs, &rzs->stats.failed_writes);
> -		goto out;
> -	}
> +		kunmap_atomic(user_mem, KM_USER0);
>  
> -	/*
> -	 * Page is incompressible. Store it as-is (uncompressed)
> -	 * since we do not want to return too many swap write
> -	 * errors which has side effect of hanging the system.
> -	 */
> -	if (unlikely(clen > max_zpage_size)) {
> -		clen = PAGE_SIZE;
> -		page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
> -		if (unlikely(!page_store)) {
> +		if (unlikely(ret != LZO_E_OK)) {
>  			mutex_unlock(&rzs->lock);
> -			pr_info("Error allocating memory for incompressible "
> -				"page: %u\n", index);
> +			pr_err("Compression failed! err=%d\n", ret);
>  			rzs_stat64_inc(rzs, &rzs->stats.failed_writes);
>  			goto out;
>  		}
>  
> -		offset = 0;
> -		rzs_set_flag(rzs, index, RZS_UNCOMPRESSED);
> -		rzs_stat_inc(&rzs->stats.pages_expand);
> -		rzs->table[index].page = page_store;
> -		src = kmap_atomic(page, KM_USER0);
> -		goto memstore;
> -	}
> +		/*
> +		 * Page is incompressible. Store it as-is (uncompressed)
> +		 * since we do not want to return too many swap write
> +		 * errors which has side effect of hanging the system.
> +		 */
> +		if (unlikely(clen > max_zpage_size)) {
> +			clen = PAGE_SIZE;
> +			page_store = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
> +			if (unlikely(!page_store)) {
> +				mutex_unlock(&rzs->lock);

What's purpose of rzs->lock?
Please, Document it. 

And please, take care of "swap" mentioned in comments. 

I think code doesn't have big problem. 
But my feel is we can clean up some portion of codes. But it's not a big
deal. It doesn't have any problem to work. 
So I want to add zram into linux-next, too. 

-- 
Kind regards,
Minchan Kim


