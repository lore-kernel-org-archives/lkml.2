Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab2J2ScN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:32:13 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43117 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760363Ab2J2ScJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <20121029180558.GE3706@swordfish.minsk.epam.com>
References: <20121027160052.GA4771@swordfish>
	<508EB96C.4040505@vflare.org>
	<20121029180558.GE3706@swordfish.minsk.epam.com>
Date: Mon, 29 Oct 2012 11:32:08 -0700
Message-ID: <CAPkvG_eZObsD=uCRGNygsrTs=ymjoA09XkoHD9KUUq_YWyuA3A@mail.gmail.com>
Subject: Re: [PATCH 1/2] zram: factor-out zram_decompress_page() function (v2)
From: Nitin Gupta <ngupta@vflare.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:05 AM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
>   zram: factor-out zram_decompress_page() function
>
>   zram_bvec_read() shared decompress functionality with zram_read_before_write() function.
>   Factor-out and make commonly used zram_decompress_page() function, which also simplified
>   error handling in zram_bvec_read().
>
>   V2: changed debug message for handle_zero_page() case to a more general one
>
>   Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>
> ---
>
>  drivers/staging/zram/zram_drv.c | 115 +++++++++++++++++-----------------------
>  1 file changed, 50 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 6edefde..bd5efdf 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -183,62 +183,25 @@ static inline int is_partial_io(struct bio_vec *bvec)
>         return bvec->bv_len != PAGE_SIZE;
>  }
>
> -static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> -                         u32 index, int offset, struct bio *bio)
> +static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  {
> -       int ret;
> -       size_t clen;
> -       struct page *page;
> -       unsigned char *user_mem, *cmem, *uncmem = NULL;
> -
> -       page = bvec->bv_page;
> -
> -       if (zram_test_flag(zram, index, ZRAM_ZERO)) {
> -               handle_zero_page(bvec);
> -               return 0;
> -       }
> +       int ret = LZO_E_OK;
> +       size_t clen = PAGE_SIZE;
> +       unsigned char *cmem;
> +       unsigned long handle = zram->table[index].handle;
>
> -       /* Requested page is not present in compressed area */
> -       if (unlikely(!zram->table[index].handle)) {
> -               pr_debug("Read before write: sector=%lu, size=%u",
> -                        (ulong)(bio->bi_sector), bio->bi_size);
> -               handle_zero_page(bvec);
> +       if (!handle || zram_test_flag(zram, index, ZRAM_ZERO)) {
> +               memset(mem, 0, PAGE_SIZE);
>                 return 0;
>         }
>
> -       if (is_partial_io(bvec)) {
> -               /* Use  a temporary buffer to decompress the page */
> -               uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -               if (!uncmem) {
> -                       pr_info("Error allocating temp memory!\n");
> -                       return -ENOMEM;
> -               }
> -       }
> -
> -       user_mem = kmap_atomic(page);
> -       if (!is_partial_io(bvec))
> -               uncmem = user_mem;
> -       clen = PAGE_SIZE;
> -
> -       cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
> -                               ZS_MM_RO);
> -
> -       if (zram->table[index].size == PAGE_SIZE) {
> -               memcpy(uncmem, cmem, PAGE_SIZE);
> -               ret = LZO_E_OK;
> -       } else {
> +       cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
> +       if (zram->table[index].size == PAGE_SIZE)
> +               memcpy(mem, cmem, PAGE_SIZE);
> +       else
>                 ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
> -                                   uncmem, &clen);
> -       }
> -
> -       if (is_partial_io(bvec)) {
> -               memcpy(user_mem + bvec->bv_offset, uncmem + offset,
> -                      bvec->bv_len);
> -               kfree(uncmem);
> -       }
> -
> -       zs_unmap_object(zram->mem_pool, zram->table[index].handle);
> -       kunmap_atomic(user_mem);
> +                                               mem, &clen);
> +       zs_unmap_object(zram->mem_pool, handle);
>
>         /* Should NEVER happen. Return bio error if it does. */
>         if (unlikely(ret != LZO_E_OK)) {
> @@ -247,36 +210,58 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>                 return ret;
>         }
>
> -       flush_dcache_page(page);
> -
>         return 0;
>  }
>
> -static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
> +static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> +                         u32 index, int offset, struct bio *bio)
>  {
>         int ret;
> -       size_t clen = PAGE_SIZE;
> -       unsigned char *cmem;
> -       unsigned long handle = zram->table[index].handle;
> +       struct page *page;
> +       unsigned char *user_mem, *uncmem = NULL;
>
> -       if (zram_test_flag(zram, index, ZRAM_ZERO) || !handle) {
> -               memset(mem, 0, PAGE_SIZE);
> +       page = bvec->bv_page;
> +
> +       if (unlikely(!zram->table[index].handle) ||
> +                       zram_test_flag(zram, index, ZRAM_ZERO)) {
> +               pr_debug("Handle zero page: sector=%lu, size=%u",
> +                        (ulong)(bio->bi_sector), bio->bi_size);
> +               handle_zero_page(bvec);

Nothing should be printed (even a debug only message) for
the ZRAM_ZERO case. This case can be quite common for certain
kinds of data and would cause a huge log spew.  Also (!handle) case
is not the same as zero-filled page case, so this message would
be misleading.

So, we should either get rid of this warning entirely or only do
pr_debug("Read before write ....") for (!handle) case and log nothing
for ZRAM_ZERO case.

Nitin
