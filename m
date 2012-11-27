Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab2K0H6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:58:46 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:35145 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170Ab2K0H6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:58:45 -0500
MIME-Version: 1.0
X-Originating-IP: [2a00:1028:d800:d6:7d01:dfb0:7940:e183]
In-Reply-To: <1354001167-24878-1-git-send-email-ngupta@vflare.org>
References: <1354001167-24878-1-git-send-email-ngupta@vflare.org>
From: Tomas M <tomas@slax.org>
Date: Tue, 27 Nov 2012 08:52:39 +0100
Message-ID: <CAL1oBhrp+6bWRPh30QA6tg3hKKBjz05Qdb8yZtJ9zSMWtX8w-Q@mail.gmail.com>
Subject: Re: [PATCH] zram: Prevent use of unmapped buffer
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good work. The patch fixes a serious bug on 3.6.5, 3.6.6, 3.6.7 and 3.6.8
I hope it gets mainlined ASAP

Tomas M
slax.org


On Tue, Nov 27, 2012 at 8:26 AM, Nitin Gupta <ngupta@vflare.org> wrote:
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
>  drivers/staging/zram/zram_drv.c |   39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index fb4a7c9..f2a73bd 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -265,7 +265,7 @@ out_cleanup:
>  static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>                            int offset)
>  {
> -       int ret;
> +       int ret = 0;
>         size_t clen;
>         unsigned long handle;
>         struct page *page;
> @@ -286,10 +286,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>                         goto out;
>                 }
>                 ret = zram_decompress_page(zram, uncmem, index);
> -               if (ret) {
> -                       kfree(uncmem);
> +               if (ret)
>                         goto out;
> -               }
>         }
>
>         /*
> @@ -302,16 +300,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>
>         user_mem = kmap_atomic(page);
>
> -       if (is_partial_io(bvec))
> +       if (is_partial_io(bvec)) {
>                 memcpy(uncmem + offset, user_mem + bvec->bv_offset,
>                        bvec->bv_len);
> -       else
> +               kunmap_atomic(user_mem);
> +               user_mem = NULL;
> +       } else {
>                 uncmem = user_mem;
> +       }
>
>         if (page_zero_filled(uncmem)) {
> -               kunmap_atomic(user_mem);
> -               if (is_partial_io(bvec))
> -                       kfree(uncmem);
> +               if (!is_partial_io(bvec))
> +                       kunmap_atomic(user_mem);
>                 zram_stat_inc(&zram->stats.pages_zero);
>                 zram_set_flag(zram, index, ZRAM_ZERO);
>                 ret = 0;
> @@ -321,9 +321,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>         ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
>                                zram->compress_workmem);
>
> -       kunmap_atomic(user_mem);
> -       if (is_partial_io(bvec))
> -                       kfree(uncmem);
> +       if (!is_partial_io(bvec)) {
> +               kunmap_atomic(user_mem);
> +               user_mem = NULL;
> +               uncmem = NULL;
> +       }
>
>         if (unlikely(ret != LZO_E_OK)) {
>                 pr_err("Compression failed! err=%d\n", ret);
> @@ -332,8 +334,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>
>         if (unlikely(clen > max_zpage_size)) {
>                 zram_stat_inc(&zram->stats.bad_compress);
> -               src = uncmem;
>                 clen = PAGE_SIZE;
> +               src = NULL;
> +               if (is_partial_io(bvec))
> +                       src = uncmem;
>         }
>
>         handle = zs_malloc(zram->mem_pool, clen);
> @@ -345,7 +349,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>         }
>         cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
>
> +       if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
> +               src = kmap_atomic(page);
>         memcpy(cmem, src, clen);
> +       if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
> +               kunmap_atomic(src);
>
>         zs_unmap_object(zram->mem_pool, handle);
>
> @@ -358,9 +366,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>         if (clen <= PAGE_SIZE / 2)
>                 zram_stat_inc(&zram->stats.good_compress);
>
> -       return 0;
> -
>  out:
> +       if (is_partial_io(bvec))
> +               kfree(uncmem);
> +
>         if (ret)
>                 zram_stat64_inc(zram, &zram->stats.failed_writes);
>         return ret;
> --
> 1.7.10.4
>
