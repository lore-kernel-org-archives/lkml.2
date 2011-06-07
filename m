Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1FGJFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:05:06 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:51737 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1FGJFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:05:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 2/6] omap: iovmm: generic iommu api migration
Date: Tue, 7 Jun 2011 11:05:15 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r3; KDE/4.6.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <1307053663-24572-3-git-send-email-ohad@wizery.com>
In-Reply-To: <1307053663-24572-3-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071105.16262.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Thanks for the patch.

On Friday 03 June 2011 00:27:39 Ohad Ben-Cohen wrote:
> Migrate omap's iovmm (virtual memory manager) to the generic iommu api.
> 
> This brings iovmm a step forward towards being completely non
> omap-specific (it's still assuming omap's iommu page sizes, and also
> maintaining state inside omap's internal iommu structure, but it no
> longer calls omap-specific iommu map/unmap api).
> 
> Further generalizing of iovmm (or complete removal) should take place
> together with broader plans of providing a generic virtual memory manager
> and allocation framework (de-coupled from specific mappers).
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

[snip]

> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index 51ef43e..80bb2b6 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c

[snip]

> @@ -473,22 +475,22 @@ static int map_iovm_area(struct iommu *obj, struct
> iovm_struct *new, u32 pa;
>  		int pgsz;
>  		size_t bytes;
> -		struct iotlb_entry e;
> 
>  		pa = sg_phys(sg);
>  		bytes = sg_dma_len(sg);
> 
>  		flags &= ~IOVMF_PGSZ_MASK;
> +
>  		pgsz = bytes_to_iopgsz(bytes);
>  		if (pgsz < 0)
>  			goto err_out;
> -		flags |= pgsz;

pgsz isn't used anymore, you can remove it.

> +
> +		order = get_order(bytes);

Does iommu_map() handle offsets correctly, or does it expect pa to be aligned 
to an order (or other) boundary ? Same comment for iommu_unmap() in 
unmap_iovm_area().

>  		pr_debug("%s: [%d] %08x %08x(%x)\n", __func__,
>  			 i, da, pa, bytes);
> 
> -		iotlb_init_entry(&e, da, pa, flags);
> -		err = iopgtable_store_entry(obj, &e);
> +		err = iommu_map(domain, da, pa, order, flags);
>  		if (err)
>  			goto err_out;
> 
> @@ -502,9 +504,11 @@ err_out:
>  	for_each_sg(sgt->sgl, sg, i, j) {
>  		size_t bytes;
> 
> -		bytes = iopgtable_clear_entry(obj, da);
> +		bytes = sg_dma_len(sg);

As Russell pointed out, we should use sg->length instead of sg_dma_length(sg). 
sg_dma_length(sg) is only valid after the scatter list has been DMA-mapped, 
which doesn't happen in the iovmm driver. This applies to all sg_dma_len(sg) 
calls.

> +		order = get_order(bytes);
> 
> -		BUG_ON(!iopgsz_ok(bytes));
> +		/* ignore failures.. we're already handling one */
> +		iommu_unmap(domain, da, order);
> 
>  		da += bytes;
>  	}

-- 
Regards,

Laurent Pinchart
