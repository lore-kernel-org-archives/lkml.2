Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1JJMwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:52:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63851 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1JJMwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
	<1316195506-9777-2-git-send-email-ohad@wizery.com>
	<20110927100505.GH2138@amd.com>
	<CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
	<20110927131222.GL2138@amd.com>
	<CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
	<20110927181438.GM2138@amd.com>
	<CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
Date: Mon, 10 Oct 2011 21:52:05 +0900
X-Google-Sender-Auth: TLAhBC9nHaCwrbSMUBUXeb-SeBk
Message-ID: <CAHQjnOOhtSiivWf34S8mjB9nqQfUwadLzE8zOm4jYvsgL_d+Wg@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
From: KyongHo Cho <pullip.cho@samsung.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 12:58 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>  int iommu_map(struct iommu_domain *domain, unsigned long iova,
> -             phys_addr_t paddr, int gfp_order, int prot)
> +             phys_addr_t paddr, size_t size, int prot)
>  {
> -       size_t size;
> +       int ret = 0;
> +
> +       /*
> +        * both the virtual address and the physical one, as well as
> +        * the size of the mapping, must be aligned (at least) to the
> +        * size of the smallest page supported by the hardware
> +        */
> +       if (!IS_ALIGNED(iova | paddr | size, iommu_min_pagesz)) {
> +               pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%lx min_pagesz "
> +                       "0x%x\n", iova, (unsigned long)paddr,
> +                       (unsigned long)size, iommu_min_pagesz);
> +               return -EINVAL;
> +       }
>
> -       size         = 0x1000UL << gfp_order;
> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
> +                               (unsigned long)paddr, (unsigned long)size);
>
> -       BUG_ON(!IS_ALIGNED(iova | paddr, size));
> +       while (size) {
> +               unsigned long pgsize, addr_merge = iova | paddr;
> +               unsigned int pgsize_idx;
>
> -       return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
> +               /* Max page size that still fits into 'size' */
> +               pgsize_idx = __fls(size);
> +
> +               /* need to consider alignment requirements ? */
> +               if (likely(addr_merge)) {
> +                       /* Max page size allowed by both iova and paddr */
> +                       unsigned int align_pgsize_idx = __ffs(addr_merge);
> +
> +                       pgsize_idx = min(pgsize_idx, align_pgsize_idx);
> +               }
> +
> +               /* build a mask of acceptable page sizes */
> +               pgsize = (1UL << (pgsize_idx + 1)) - 1;
> +
> +               /* throw away page sizes not supported by the hardware */
> +               pgsize &= iommu_pgsize_bitmap;
> +
> +               /* pick the biggest page */
> +               pgsize_idx = __fls(pgsize);
> +               pgsize = 1UL << pgsize_idx;
> +
> +               /* convert index to page order */
> +               pgsize_idx -= PAGE_SHIFT;
> +
> +               pr_debug("mapping: iova 0x%lx pa 0x%lx order %u\n", iova,
> +                                       (unsigned long)paddr, pgsize_idx);
> +
> +               ret = iommu_ops->map(domain, iova, paddr, pgsize_idx, prot);
> +               if (ret)
> +                       break;
> +
> +               iova += pgsize;
> +               paddr += pgsize;
> +               size -= pgsize;
> +       }
> +
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_map);

Do not we need to unmap all intermediate mappings if iommu_map() is failed?

I think iommu_map() must map the entire given area if it successes.
Otherwise, it should map nothing.

I think it can be simply done with calling iommu_unmap()
with Joerg's previous suggestion about iommu_unmap().

Regards,
KyongHo.
