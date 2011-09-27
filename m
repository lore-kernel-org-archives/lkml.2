Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1I0KFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:05:23 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:17374
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab1I0KFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:05:20 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LS6EOG-02-77X-02
X-M-MSG: 
Date: Tue, 27 Sep 2011 12:05:05 +0200
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
Message-ID: <20110927100505.GH2138@amd.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
 <1316195506-9777-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316195506-9777-2-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 01:51:41PM -0400, Ohad Ben-Cohen wrote:
>  drivers/iommu/iommu.c      |  158 +++++++++++++++++++++++++++++++++++++++++---
>  drivers/iommu/omap-iovmm.c |   12 +---
>  include/linux/iommu.h      |    6 +-
>  virt/kvm/iommu.c           |    4 +-
>  4 files changed, 157 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index c68ff29..7c01c8c 100644
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
> @@ -23,15 +25,73 @@
>  #include <linux/slab.h>
>  #include <linux/errno.h>
>  #include <linux/iommu.h>
> +#include <linux/bitmap.h>
> 
>  static struct iommu_ops *iommu_ops;
> 
> +/* bitmap of supported page sizes */
> +static unsigned long *iommu_pgsize_bitmap;
> +
> +/* number of bits used to represent the supported pages */
> +static unsigned int iommu_nr_page_bits;
> +
> +/* size of the smallest supported page (in bytes) */
> +static unsigned int iommu_min_pagesz;
> +
> +/* bit number of the smallest supported page */
> +static unsigned int iommu_min_page_idx;
> +
> +/**
> + * register_iommu() - register an IOMMU hardware
> + * @ops: iommu handlers
> + * @pgsize_bitmap: bitmap of page sizes supported by the hardware
> + * @nr_page_bits: size of @pgsize_bitmap (in bits)
> + *
> + * Note: this is a temporary function, which will be removed once
> + * all IOMMU drivers are converted. The only reason it exists is to
> + * allow splitting the pgsizes changes to several patches in order to ease
> + * the review.
> + */
> +void register_iommu_pgsize(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
> +                                       unsigned int nr_page_bits)

I think a plain unsigned long value is sufficient to encode the
supported page-sizes. No need to use a full bitmap.

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
> +
> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
> +                               (unsigned long)paddr, (unsigned long)size);
> +
> +       while (size) {
> +               unsigned long pgsize = iommu_min_pagesz;
> +               unsigned long idx = iommu_min_page_idx;
> +               unsigned long addr_merge = iova | paddr;
> +               int order;
> +
> +               /* find the max page size with which iova, paddr are aligned */
> +               for (;;) {
> +                       unsigned long try_pgsize;
> +
> +                       idx = find_next_bit(iommu_pgsize_bitmap,
> +                                               iommu_nr_page_bits, idx + 1);
> +
> +                       /* no more pages to check ? */
> +                       if (idx >= iommu_nr_page_bits)
> +                               break;
> +
> +                       try_pgsize = 1 << idx;
> 
> -       size         = 0x1000UL << gfp_order;
> +                       /* page too big ? addresses not aligned ? */
> +                       if (size < try_pgsize ||
> +                                       !IS_ALIGNED(addr_merge, try_pgsize))
> +                               break;
> 
> -       BUG_ON(!IS_ALIGNED(iova | paddr, size));
> +                       pgsize = try_pgsize;
> +               }

With an unsigned long you can use plain and fast bit_ops instead of the
full bitmap functions. 

> 
> -       return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
> +               order = get_order(pgsize);
> +
> +               pr_debug("mapping: iova 0x%lx pa 0x%lx order %d\n", iova,
> +                                       (unsigned long)paddr, order);
> +
> +               ret = iommu_ops->map(domain, iova, paddr, order, prot);
> +               if (ret)
> +                       break;
> +
> +               size -= pgsize;
> +               iova += pgsize;
> +               paddr += pgsize;
> +       }
> +
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_map);
> 

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

