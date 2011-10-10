Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab1JJJtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 05:49:09 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26629 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJJtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 05:49:06 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz179dN1432N98dKzz1202hzz15d4R8275dhz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LSUGK4-02-0C8-02
X-M-MSG: 
Date: Mon, 10 Oct 2011 11:47:38 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
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
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111010094738.GW2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com>
 <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com>
 <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com>
 <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

sorry, I was on vacation last week and had no time to look into this.

On Sun, Oct 02, 2011 at 11:58:12AM -0400, Ohad Ben-Cohen wrote:
>  drivers/iommu/iommu.c      |  138 ++++++++++++++++++++++++++++++++++++++++---
>  drivers/iommu/omap-iovmm.c |   12 +---
>  include/linux/iommu.h      |    6 +-
>  virt/kvm/iommu.c           |    4 +-
>  4 files changed, 137 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index a7b0862..f23563f 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -16,6 +16,8 @@
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
>   */
> 
> +#define pr_fmt(fmt)    "%s: " fmt, __func__
> +
>  #include <linux/kernel.h>
>  #include <linux/bug.h>
>  #include <linux/types.h>
> @@ -23,15 +25,54 @@
>  #include <linux/slab.h>
>  #include <linux/errno.h>
>  #include <linux/iommu.h>
> +#include <linux/bitmap.h>

Is this still required?

> 
>  static struct iommu_ops *iommu_ops;
> 
> +/* bitmap of supported page sizes */
> +static unsigned long iommu_pgsize_bitmap;
> +
> +/* size of the smallest supported page (in bytes) */
> +static unsigned int iommu_min_pagesz;
> +
> +/**
> + * register_iommu() - register an IOMMU hardware
> + * @ops: iommu handlers
> + * @pgsize_bitmap: bitmap of page sizes supported by the hardware
> + *
> + * Note: this is a temporary function, which will be removed once
> + * all IOMMU drivers are converted. The only reason it exists is to
> + * allow splitting the pgsizes changes to several patches in order to ease
> + * the review.
> + */
> +void register_iommu_pgsize(struct iommu_ops *ops, unsigned long pgsize_bitmap)
> +{
> +       if (iommu_ops || iommu_pgsize_bitmap || !pgsize_bitmap)
> +               BUG();
> +
> +       iommu_ops = ops;
> +       iommu_pgsize_bitmap = pgsize_bitmap;
> +
> +       /* find out the minimum page size only once */
> +       iommu_min_pagesz = 1 << __ffs(pgsize_bitmap);
> +}

Hmm, I thought a little bit about that and came to the conculusion it
might be best to just keep the page-sizes as a part of the iommu_ops
structure. So there is no need to extend the register_iommu interface.

Also, the bus_set_iommu interface is now in the -next branch. Would be
good if you rebase the patches to that interface.

You can find the current iommu tree with these changes at

	git://git.8bytes.org/scm/iommu.git

> @@ -115,26 +156,103 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
>  EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
> 
>  int iommu_map(struct iommu_domain *domain, unsigned long iova,
> -             phys_addr_t paddr, int gfp_order, int prot)
> +             phys_addr_t paddr, size_t size, int prot)
>  {
> -       size_t size;
> +       int ret = 0;
> +
> +       /*
> +        * both the virtual address and the physical one, as well as
> +        * the size of the mapping, must be aligned (at least) to the
> +        * size of the smallest page supported by the hardware
> +        */
> +       if (!IS_ALIGNED(iova | paddr | size, iommu_min_pagesz)) {
> +               pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%lx min_pagesz "
> +                       "0x%x\n", iova, (unsigned long)paddr,
> +                       (unsigned long)size, iommu_min_pagesz);
> +               return -EINVAL;
> +       }
> 
> -       size         = 0x1000UL << gfp_order;
> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
> +                               (unsigned long)paddr, (unsigned long)size);
> 
> -       BUG_ON(!IS_ALIGNED(iova | paddr, size));
> +       while (size) {
> +               unsigned long pgsize, addr_merge = iova | paddr;
> +               unsigned int pgsize_idx;
> 
> -       return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
> +               /* Max page size that still fits into 'size' */
> +               pgsize_idx = __fls(size);
> +
> +               /* need to consider alignment requirements ? */
> +               if (likely(addr_merge)) {
> +                       /* Max page size allowed by both iova and paddr */
> +                       unsigned int align_pgsize_idx = __ffs(addr_merge);
> +
> +                       pgsize_idx = min(pgsize_idx, align_pgsize_idx);
> +               }
> +
> +               /* build a mask of acceptable page sizes */
> +               pgsize = (1UL << (pgsize_idx + 1)) - 1;
> +
> +               /* throw away page sizes not supported by the hardware */
> +               pgsize &= iommu_pgsize_bitmap;

I think we need some care here and check pgsize for 0. A BUG_ON should
do.

> +
> +               /* pick the biggest page */
> +               pgsize_idx = __fls(pgsize);
> +               pgsize = 1UL << pgsize_idx;
> +
> +               /* convert index to page order */
> +               pgsize_idx -= PAGE_SHIFT;
> +
> +               pr_debug("mapping: iova 0x%lx pa 0x%lx order %u\n", iova,
> +                                       (unsigned long)paddr, pgsize_idx);
> +
> +               ret = iommu_ops->map(domain, iova, paddr, pgsize_idx, prot);
> +               if (ret)
> +                       break;
> +
> +               iova += pgsize;
> +               paddr += pgsize;
> +               size -= pgsize;
> +       }
> +
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_map);

Otherwise this looks much better, thanks.

> 
> -int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
> +int iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
>  {
> -       size_t size;
> +       int order, unmapped_size, unmapped_order, total_unmapped = 0;
> +
> +       /*
> +        * The virtual address, as well as the size of the mapping, must be
> +        * aligned (at least) to the size of the smallest page supported
> +        * by the hardware
> +        */
> +       if (!IS_ALIGNED(iova | size, iommu_min_pagesz)) {
> +               pr_err("unaligned: iova 0x%lx size 0x%lx min_pagesz 0x%x\n",
> +                               iova, (unsigned long)size, iommu_min_pagesz);
> +               return -EINVAL;
> +       }
> +
> +       pr_debug("unmap this: iova 0x%lx size 0x%lx\n", iova,
> +                                                       (unsigned long)size);
> +
> +       while (size > total_unmapped) {
> +               order = get_order(size - total_unmapped);
> +
> +               unmapped_order = iommu_ops->unmap(domain, iova, order);

I think we should make sure that we call iommu_ops->unmap with the same
parameters as iommu_ops->map. Otherwise we still need some page-size
complexity in the iommu-drivers.

> +               if (unmapped_order < 0)
> +                       return unmapped_order;
> +
> +               pr_debug("unmapped: iova 0x%lx order %d\n", iova,
> +                                                       unmapped_order);
> 
> -       size         = 0x1000UL << gfp_order;
> +               unmapped_size = 0x1000UL << unmapped_order;
> 
> -       BUG_ON(!IS_ALIGNED(iova, size));
> +               iova += unmapped_size;
> +               total_unmapped += unmapped_size;
> +       }
> 
> -       return iommu_ops->unmap(domain, iova, gfp_order);
> +       return get_order(total_unmapped);
>  }

When we pass the size now it makes sense to also return the
unmapped-size instead of the order.

Also the semantics of iommu_unmap need some more discussion I think. We
should require that iommu_map/iommu_unmap are called with the same
parameters for the same range. Otherwise we can give no guarantees what
a unmap-call will unmap.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

