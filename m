Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1KJGR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:17:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58258 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1KJGR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:17:27 -0500
MIME-Version: 1.0
In-Reply-To: <1318850846-16066-3-git-send-email-ohad@wizery.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
	<1318850846-16066-3-git-send-email-ohad@wizery.com>
Date: Thu, 10 Nov 2011 14:17:24 +0800
Message-ID: <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as
 supported by the hardware
From: Kai Huang <mail.kai.huang@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> -int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
> +size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
>  {
> -       size_t size, unmapped;
> +       size_t unmapped_page, unmapped = 0;
> +       unsigned int min_pagesz;
>
>        if (unlikely(domain->ops->unmap == NULL))
>                return -ENODEV;
>
> -       size         = PAGE_SIZE << gfp_order;
> -
> -       BUG_ON(!IS_ALIGNED(iova, size));
> -
> -       unmapped = domain->ops->unmap(domain, iova, size);
> -
> -       return get_order(unmapped);
> +       /* find out the minimum page size supported */
> +       min_pagesz = 1 << __ffs(domain->ops->pgsize_bitmap);
> +
> +       /*
> +        * The virtual address, as well as the size of the mapping, must be
> +        * aligned (at least) to the size of the smallest page supported
> +        * by the hardware
> +        */
> +       if (!IS_ALIGNED(iova | size, min_pagesz)) {
> +               pr_err("unaligned: iova 0x%lx size 0x%lx min_pagesz 0x%x\n",
> +                                       iova, (unsigned long)size, min_pagesz);
> +               return -EINVAL;
> +       }
> +
> +       pr_debug("unmap this: iova 0x%lx size 0x%lx\n", iova,
> +                                                       (unsigned long)size);
> +
> +       /*
> +        * Keep iterating until we either unmap 'size' bytes (or more)
> +        * or we hit an area that isn't mapped.
> +        */
> +       while (unmapped < size) {
> +               size_t left = size - unmapped;
> +
> +               unmapped_page = domain->ops->unmap(domain, iova, left);
> +               if (!unmapped_page)
> +                       break;
> +
> +               pr_debug("unmapped: iova 0x%lx size %lx\n", iova,
> +                                       (unsigned long)unmapped_page);
> +
> +               iova += unmapped_page;
> +               unmapped += unmapped_page;
> +       }
> +
> +       return unmapped;
>  }
>  EXPORT_SYMBOL_GPL(iommu_unmap);
>

Seems the unmap function don't take phys as parameter, does this mean
domain->ops->unmap will walk through the page table to find out the
actual page size?

And another question: have we considered the IOTLB flush operation? I
think we need to implement similar logic when flush the DVMA range.
Intel VT-d's manual says software needs to specify the appropriate
mask value to flush large pages, but it does not say we need to
exactly match the page size as it is mapped. I guess it's not
necessary for Intel IOMMU, but other vendor's IOMMU may have such
limitation (or some other limitations). In my understanding current
implementation does not provide page size information for particular
DVMA ranges that has been mapped, and it's not flexible to implement
IOTLB flush code (ex, we may need to walk through page table to find
out actual page size). Maybe we can also add iommu_ops->flush_iotlb ?

-cody
