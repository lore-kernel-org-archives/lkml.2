Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab2GJCZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:25:46 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42742 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2GJCZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:25:45 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-03-4ffb92a6a17b
Message-ID: <4FFB92A9.4090203@kernel.org>
Date: Tue, 10 Jul 2012 11:25:45 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] zsmalloc: add single-page object fastpath in unmap
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-3-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1341263752-10210-3-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 06:15 AM, Seth Jennings wrote:
> Improve zs_unmap_object() performance by adding a fast path for
> objects that don't span pages.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index a7a6f22..4942d41 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -774,6 +774,7 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle)
>  	}
>  
>  	zs_copy_map_object(area->vm_buf, page, off, class->size);
> +	area->vm_addr = NULL;
>  	return area->vm_buf;
>  }
>  EXPORT_SYMBOL_GPL(zs_map_object);
> @@ -788,6 +789,14 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
>  	struct size_class *class;
>  	struct mapping_area *area;
>  
> +	area = &__get_cpu_var(zs_map_area);
> +	if (area->vm_addr) {
> +		/* single-page object fastpath */
> +		kunmap_atomic(area->vm_addr);
> +		put_cpu_var(zs_map_area);
> +		return;
> +	}
> +

Please locate this after below BUG_ON.
The BUG check is still effective regardless of your fast path patch.

>  	BUG_ON(!handle);
>  
>  	obj_handle_to_location(handle, &page, &obj_idx);
> @@ -795,11 +804,7 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
>  	class = &pool->size_class[class_idx];
>  	off = obj_idx_to_offset(page, obj_idx, class->size);
>  
> -	area = &__get_cpu_var(zs_map_area);
> -	if (off + class->size <= PAGE_SIZE)
> -		kunmap_atomic(area->vm_addr);
> -	else
> -		zs_copy_unmap_object(area->vm_buf, page, off, class->size);
> +	zs_copy_unmap_object(area->vm_buf, page, off, class->size);
>  	put_cpu_var(zs_map_area);
>  }
>  EXPORT_SYMBOL_GPL(zs_unmap_object);
> 


-- 
Kind regards,
Minchan Kim


