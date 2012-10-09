Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2JINb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:31:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64159 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab2JINbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:31:39 -0400
Date: Tue, 9 Oct 2012 22:31:28 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [staging][zram] Fix handling of incompressible pages
Message-ID: <20121009133128.GA3244@barrios>
References: <1349746364-8051-1-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349746364-8051-1-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Mon, Oct 08, 2012 at 06:32:44PM -0700, Nitin Gupta wrote:
> Change 130f315a introduced a bug in the handling of incompressible
> pages which resulted in memory allocation failure for such pages.
> The fix is to store the page as-is i.e. without compression if the
> compressed size exceeds a threshold (max_zpage_size) and request
> exactly PAGE_SIZE sized buffer from zsmalloc.

It seems you found a bug and already fixed it with below helpers.
But unfortunately, description isn't enough to understand the problem for me.
Could you explain in detail?
You said it results in memory allocation failure. What is failure?
You mean this code by needing a few pages for zspage to meet class size?

        handle = zs_malloc(zram->mem_pool, clen);
        if (!handle) {
                pr_info("Error allocating memory for compressed "
                        "page: %u, size=%zu\n", index, clen);
                ret = -ENOMEM;
                goto out;
        }

So instead of allocating more pages for incompressible page to make zspage,
just allocate a page for PAGE_SIZE class without compression?

> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reported-by: viechweg@gmail.com
> Reported-by: paerley@gmail.com
> Reported-by: wu.tommy@gmail.com
> Tested-by: wu.tommy@gmail.com
> Tested-by: michael@zugelder.org
> ---
>  drivers/staging/zram/zram_drv.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 653b074..6edefde 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -223,8 +223,13 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
>  				ZS_MM_RO);
>  
> -	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
> +	if (zram->table[index].size == PAGE_SIZE) {
> +		memcpy(uncmem, cmem, PAGE_SIZE);
> +		ret = LZO_E_OK;
> +	} else {
> +		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
>  				    uncmem, &clen);
> +	}
>  
>  	if (is_partial_io(bvec)) {
>  		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
> @@ -342,8 +347,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		goto out;
>  	}
>  
> -	if (unlikely(clen > max_zpage_size))
> +	if (unlikely(clen > max_zpage_size)) {
>  		zram_stat_inc(&zram->stats.bad_compress);
> +		src = uncmem;
> +		clen = PAGE_SIZE;
> +	}
>  
>  	handle = zs_malloc(zram->mem_pool, clen);
>  	if (!handle) {
> -- 
> 1.7.9.5
> 

-- 
Kind Regards,
Minchan Kim
