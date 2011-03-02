Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1CBL7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:59:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53395 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1CBL67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:58:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kFveNvQQ6kmKIoa91g0PUP2+5NhEwLqiT2TyePJRQzXEWqWaEAO999oLam0JvHsusI
         WXU2NT9/6zgw1g7dL1uRntBVUCXiqddyJfuTZhMn+PYIvlPfca/09pvWLF10+YbwU1fN
         YODHaSraenrNUR8v+rYark1ORy3/Li96bYc+Y=
MIME-Version: 1.0
In-Reply-To: <1299008793-27428-1-git-send-email-fernando.lugo@ti.com>
References: <1299008793-27428-1-git-send-email-fernando.lugo@ti.com>
Date: Wed, 2 Mar 2011 13:58:58 +0200
Message-ID: <AANLkTi=ULWw2CsZgcYpkXrA+qQe3ufDhW5es0dwe66ph@mail.gmail.com>
Subject: Re: [PATCH] omap:iommu-added cache flushing operation for L2 cache
From: David Cohen <dacohen@gmail.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: hiroshi.doyu@nokia.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ramesh Gupta <grgupta@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 1, 2011 at 9:46 PM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> From: Ramesh Gupta <grgupta@ti.com>

No patch body description at all?
Can we get at least something here?

Regards,

David

>
> Signed-off-by: Ramesh Gupta <grgupta@ti.com>
> Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
> ---
>  arch/arm/plat-omap/iommu.c |   22 ++++++++--------------
>  1 files changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
> index e3eb038..aeb2c33 100644
> --- a/arch/arm/plat-omap/iommu.c
> +++ b/arch/arm/plat-omap/iommu.c
> @@ -471,22 +471,15 @@ EXPORT_SYMBOL_GPL(foreach_iommu_device);
>  */
>  static void flush_iopgd_range(u32 *first, u32 *last)
>  {
> -       /* FIXME: L2 cache should be taken care of if it exists */
> -       do {
> -               asm("mcr        p15, 0, %0, c7, c10, 1 @ flush_pgd"
> -                   : : "r" (first));
> -               first += L1_CACHE_BYTES / sizeof(*first);
> -       } while (first <= last);
> +       dmac_flush_range(first, last);
> +       outer_flush_range(virt_to_phys(first), virt_to_phys(last));
>  }
>
> +
>  static void flush_iopte_range(u32 *first, u32 *last)
>  {
> -       /* FIXME: L2 cache should be taken care of if it exists */
> -       do {
> -               asm("mcr        p15, 0, %0, c7, c10, 1 @ flush_pte"
> -                   : : "r" (first));
> -               first += L1_CACHE_BYTES / sizeof(*first);
> -       } while (first <= last);
> +       dmac_flush_range(first, last);
> +       outer_flush_range(virt_to_phys(first), virt_to_phys(last));
>  }
>
>  static void iopte_free(u32 *iopte)
> @@ -750,7 +743,7 @@ size_t iopgtable_clear_entry(struct iommu *obj, u32 da)
>  }
>  EXPORT_SYMBOL_GPL(iopgtable_clear_entry);
>
> -static void iopgtable_clear_entry_all(struct iommu *obj)
> +void iopgtable_clear_entry_all(struct iommu *obj)
>  {
>        int i;
>
> @@ -777,7 +770,7 @@ static void iopgtable_clear_entry_all(struct iommu *obj)
>
>        spin_unlock(&obj->page_table_lock);
>  }
> -
> +EXPORT_SYMBOL_GPL(iopgtable_clear_entry_all);
>  /*
>  *     Device IOMMU generic operations
>  */
> @@ -1068,6 +1061,7 @@ static void iopte_cachep_ctor(void *iopte)
>        clean_dcache_area(iopte, IOPTE_TABLE_SIZE);
>  }
>
> +
>  static int __init omap_iommu_init(void)
>  {
>        struct kmem_cache *p;
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
