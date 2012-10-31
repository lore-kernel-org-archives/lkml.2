Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2JaHH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:07:59 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62626 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2JaHH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:07:58 -0400
Date: Wed, 31 Oct 2012 10:05:31 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: zram: use after free
Message-ID: <20121031070531.GA2332@swordfish.minsk.epam.com>
References: <20121027160052.GA4771@swordfish>
 <508EB96C.4040505@vflare.org>
 <20121030210403.GA2635@swordfish>
 <5090A14E.3050902@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090A14E.3050902@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've renamed the topic.


On (10/30/12 20:55), Nitin Gupta wrote:
> >>======
> >>zram: Fix use-after-free in partial I/O case
> >>
> >>When the compressed size of a page exceeds a threshold, the page is
> >>stored as-is i.e. in uncompressed form. In the partial I/O i.e.
> >>non-PAGE_SIZE'ed I/O case, however, the uncompressed memory was being
> >>freed before it could be copied into the zsmalloc pool resulting in
> >>use-after-free bug.
> >>
> >
> >Hello Nitin,
> >hope you are fine.
> >
> >how about the following one? I moved some of the code to zram_compress_page()
> >(very similar to zram_decompress_page()), so errors are easier to care in
> >zram_bvec_write(). now we handle both use after-kfree (as you did in your patch),
> >and use after-kunmap.
> >
> >  drivers/staging/zram/zram_drv.c | 91 +++++++++++++++++++++--------------------
> >  1 file changed, 46 insertions(+), 45 deletions(-)
> >
> >diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> >index 47f2e3a..5f37be1 100644
> >--- a/drivers/staging/zram/zram_drv.c
> >+++ b/drivers/staging/zram/zram_drv.c
> >@@ -213,6 +213,44 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> >  	return 0;
> >  }
> >
> >+static int zram_compress_page(struct zram *zram, char *uncmem, u32 index)
> >+{
> >+	int ret;
> >+	size_t clen;
> >+	unsigned long handle;
> >+	unsigned char *cmem, *src;
> >+
> >+	src = zram->compress_buffer;
> >+	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
> >+			       zram->compress_workmem);
> >+	if (unlikely(ret != LZO_E_OK)) {
> >+		pr_err("Page compression failed: err=%d\n", ret);
> >+		return ret;
> >+	}
> >+
> >+	if (unlikely(clen > max_zpage_size)) {
> >+		zram_stat_inc(&zram->stats.bad_compress);
> >+		src = uncmem;
> >+		clen = PAGE_SIZE;
> >+	}
> >+
> >+	handle = zs_malloc(zram->mem_pool, clen);
> >+	if (!handle) {
> >+		pr_info("Error allocating memory for compressed "
> >+			"page: %u, size=%zu\n", index, clen);
> >+		return -ENOMEM;
> >+	}
> >+
> >+	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
> >+	memcpy(cmem, src, clen);
> >+	zs_unmap_object(zram->mem_pool, handle);
> >+
> >+	zram->table[index].handle = handle;
> >+	zram->table[index].size = clen;
> >+
> >+	return 0;
> >+}
> >+
> >  static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  			  u32 index, int offset, struct bio *bio)
> >  {
> >@@ -267,13 +305,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  {
> >  	int ret;
> >  	size_t clen;
> >-	unsigned long handle;
> >  	struct page *page;
> >-	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
> >+	unsigned char *user_mem, *uncmem = NULL;
> >
> >  	page = bvec->bv_page;
> >-	src = zram->compress_buffer;
> >-
> >  	if (is_partial_io(bvec)) {
> >  		/*
> >  		 * This is a partial IO. We need to read the full page
> >@@ -286,10 +321,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  			goto out;
> >  		}
> >  		ret = zram_decompress_page(zram, uncmem, index);
> >-		if (ret) {
> >-			kfree(uncmem);
> >+		if (ret)
> >  			goto out;
> >-		}
> >  	}
> >
> >  	/*
> >@@ -309,58 +342,26 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  		uncmem = user_mem;
> >
> >  	if (page_zero_filled(uncmem)) {
> >-		kunmap_atomic(user_mem);
> >-		if (is_partial_io(bvec))
> >-			kfree(uncmem);
> >  		zram_stat_inc(&zram->stats.pages_zero);
> >  		zram_set_flag(zram, index, ZRAM_ZERO);
> >  		ret = 0;
> >  		goto out;
> >  	}
> >
> >-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
> >-			       zram->compress_workmem);
> >-
> >-	kunmap_atomic(user_mem);
> >-	if (is_partial_io(bvec))
> >-			kfree(uncmem);
> >-
> >-	if (unlikely(ret != LZO_E_OK)) {
> >-		pr_err("Compression failed! err=%d\n", ret);
> >-		goto out;
> >-	}
> >-
> >-	if (unlikely(clen > max_zpage_size)) {
> >-		zram_stat_inc(&zram->stats.bad_compress);
> >-		src = uncmem;
> >-		clen = PAGE_SIZE;
> >-	}
> >-
> >-	handle = zs_malloc(zram->mem_pool, clen);
> >-	if (!handle) {
> >-		pr_info("Error allocating memory for compressed "
> >-			"page: %u, size=%zu\n", index, clen);
> >-		ret = -ENOMEM;
> >+	ret = zram_compress_page(zram, uncmem, index);
> >+	if (ret)
> >  		goto out;
> >-	}
> >-	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
> >-
> >-	memcpy(cmem, src, clen);
> >-
> >-	zs_unmap_object(zram->mem_pool, handle);
> >-
> >-	zram->table[index].handle = handle;
> >-	zram->table[index].size = clen;
> >
> >+	clen = zram->table[index].size;
> >  	/* Update stats */
> >  	zram_stat64_add(zram, &zram->stats.compr_size, clen);
> >  	zram_stat_inc(&zram->stats.pages_stored);
> >  	if (clen <= PAGE_SIZE / 2)
> >  		zram_stat_inc(&zram->stats.good_compress);
> >-
> >-	return 0;
> >-
> >  out:
> >+	kunmap_atomic(user_mem);
> 
> We are doing zs_malloc + zs_map/unmap + memcpy while keeping a page
> kmap'ed. We must really release it as soon as possible, so
> zs_compress_page() should just do compression and return with
> results, or just keep direct can to lzo_compress in bvec_write()
> since we are not gaining anything by this refactoring, unlike the
> decompress case.
>

yeah, we can unmap and map again as a slow-path for
	`clen > max_zpage_size'
 

in that case zs_compress_page() is not helping. the main reason behind this
function was to make bvec_write() easier, if we count our fingers for
what bvec_write() is capable of, it turns out to be a pretty mighty function.
I'll think about this.


> Do we have a way to generate these partial I/Os so we can exercise
> these code paths?
> 

I'll try.

	-ss

> Thanks,
> Nitin
> 
