Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1JKO74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:59:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51784 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab1JKO7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:59:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
	<1316195506-9777-2-git-send-email-ohad@wizery.com>
	<20110927100505.GH2138@amd.com>
	<CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
	<20110927131222.GL2138@amd.com>
	<CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
	<20110927181438.GM2138@amd.com>
	<CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
	<20111010094738.GW2138@amd.com>
	<CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
	<20111010153609.GB2138@amd.com>
	<CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
Date: Tue, 11 Oct 2011 23:59:53 +0900
X-Google-Sender-Auth: xk2-I8haUMjY562ky0o8_7w-Q_Y
Message-ID: <CAHQjnOPcetkp-XX0x4HQsR+iYN1SaCAhuBEE2nVTdhssFpUmJQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
From: KyongHo Cho <pullip.cho@samsung.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 7:49 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>  int iommu_map(struct iommu_domain *domain, unsigned long iova,
> -             phys_addr_t paddr, int gfp_order, int prot)
> +             phys_addr_t paddr, int size, int prot)
>  {
Even though it is not realistic that size becomes larger than 1 <<
((sizeof(int) * 8) - 1),
I think the type of size should be size_t.

> -       size_t size;
> +       unsigned long orig_iova = iova;
> +       int ret = 0, orig_size = size;
>
>        if (unlikely(domain->ops->map == NULL))
>                return -ENODEV;
>
> -       size         = PAGE_SIZE << gfp_order;
> +       /*
> +        * both the virtual address and the physical one, as well as
> +        * the size of the mapping, must be aligned (at least) to the
> +        * size of the smallest page supported by the hardware
> +        */
> +       if (!IS_ALIGNED(iova | paddr | size, domain->ops->min_pagesz)) {
> +               pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%x min_pagesz "
> +                       "0x%x\n", iova, (unsigned long)paddr,
> +                       size, domain->ops->min_pagesz);
> +               return -EINVAL;
> +       }
> +
> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%x\n", iova,
> +                               (unsigned long)paddr, size);
> +
> +       while (size) {
> +               unsigned long pgsize, addr_merge = iova | paddr;
> +               unsigned int pgsize_idx;
> +
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
> +               pgsize &= domain->ops->pgsize_bitmap;
> +
> +               /* make sure we're still sane */
> +               BUG_ON(!pgsize);
>
> -       BUG_ON(!IS_ALIGNED(iova | paddr, size));
> +               /* pick the biggest page */
> +               pgsize_idx = __fls(pgsize);
> +               pgsize = 1UL << pgsize_idx;
>
> -       return domain->ops->map(domain, iova, paddr, gfp_order, prot);
> +               /* convert index to page order */
> +               pgsize_idx -= PAGE_SHIFT;
> +
> +               pr_debug("mapping: iova 0x%lx pa 0x%lx order %u\n", iova,
> +                                       (unsigned long)paddr, pgsize_idx);
> +
> +               ret = domain->ops->map(domain, iova, paddr, pgsize_idx, prot);
> +               if (ret)
> +                       break;
> +
> +               iova += pgsize;
> +               paddr += pgsize;
> +               size -= pgsize;
> +       }
> +
> +       /* unroll mapping in case something went wrong */
> +       if (ret)
> +               iommu_unmap(domain, orig_iova, orig_size);
> +
domain->ops->map() might return error because a mapping already exists
in the range from iova until iova + size.
Thus, it should be
iommu_unmap(domain, orig_iova, orig_size - size)

Regards,

KyongHo
