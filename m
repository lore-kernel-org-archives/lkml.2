Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1AZRsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:48:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41227 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1AZRsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:48:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=TJH9FrHPPhbV872m1eYWK4991I7f62ekSNPJHCoEJ+VlQ/Wi6AcVkwjKR0ifXYqiYb
         BWQrJwLB1hKb5waILT+fwk+2tGrwRYg0UlPh5y2JyMZl9J8NcY5BaE4ZU8+TMJW/AEFI
         d9hs/gWgCWyUFbZlElF5b9f677GVhKHQkjd44=
MIME-Version: 1.0
In-Reply-To: <20110126172243.GC8446@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172243.GC8446@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 19:48:45 +0200
X-Google-Sender-Auth: 6uTQiT7flx0K_v-lLvblLJ1FCuc
Message-ID: <AANLkTi=gehk1_ogsb-A6uWyb0a1Y2GqwKVu4k1p0Z-D1@mail.gmail.com>
Subject: Re: [PATCH 1/7] zram/vmalloc: Correct tunings to enable use with 64K pages
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:22 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> xvmalloc will not currently function with 64K pages.  Newly allocated
> pages will be inserted at an offset beyond the end of the first-level
> index.  This tuning is needed to properly size the allocator for 64K
> pages.
>
> The default 3 byte shift results in a second level list size which can not
> be indexed using the 64 bits of the flbitmap in the xv_pool structure.
> The shift must increase to 4 bytes between second level list entries to
> fit the size of the first level bitmap.
>
> Here are a few statistics for structure sizes on 32- and 64-bit CPUs
> with 4KB and 64KB page sizes.
>
> bits_per_long              32        64        64
> page_size               4,096     4,096    65,535
> xv_align                    4         8         8
> fl_delta                    3         3         4
> num_free_lists            508       508     4,094
> xv_pool size            4,144b    8,216b   66,040b
> per object overhead        32        64        64
> zram struct 0.5GB disk    512KB    1024KB      64KB
>
> This patch maintains the current tunings for 4K pages, adds an optimal
> sizing for 64K pages and adds a safe tuning for any other page sizes.
>
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
>  drivers/staging/zram/xvmalloc_int.h |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/zram/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
> index e23ed5c..051a49b 100644
> --- a/drivers/staging/zram/xvmalloc_int.h
> +++ b/drivers/staging/zram/xvmalloc_int.h
> @@ -19,7 +19,11 @@
>  /* User configurable params */
>
>  /* Must be power of two */
> +#ifdef CONFIG_64BIT
> +#define XV_ALIGN_SHIFT 3
> +#else
>  #define XV_ALIGN_SHIFT 2
> +#endif
>  #define XV_ALIGN       (1 << XV_ALIGN_SHIFT)
>  #define XV_ALIGN_MASK  (XV_ALIGN - 1)
>
> @@ -27,8 +31,18 @@
>  #define XV_MIN_ALLOC_SIZE      32
>  #define XV_MAX_ALLOC_SIZE      (PAGE_SIZE - XV_ALIGN)
>
> -/* Free lists are separated by FL_DELTA bytes */
> -#define FL_DELTA_SHIFT 3
> +/*
> + * Free lists are separated by FL_DELTA bytes
> + * This value is 3 for 4k pages and 4 for 64k pages, for any
> + * other page size, a conservative (PAGE_SHIFT - 9) is used.
> + */
> +#if PAGE_SHIFT == 12
> +#define FL_DELTA_SHIFT 3

This is handled by the else branch already, no?

> +#elif PAGE_SHIFT == 16
> +#define FL_DELTA_SHIFT 4
> +#else
> +#define FL_DELTA_SHIFT (PAGE_SHIFT - 9)
> +#endif
