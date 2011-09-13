Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1IMKKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:10:22 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:54551
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147Ab1IMKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:10:19 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275dhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRGHKZ-02-3PK-02
X-M-MSG: 
Date: Tue, 13 Sep 2011 12:10:11 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH 3/3] iommu/core: split mapping to page sizes as supported
 by the hardware
Message-ID: <20110913101011.GK11701@amd.com>
References: <1315421604-12286-1-git-send-email-ohad@wizery.com>
 <1315421604-12286-3-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1315421604-12286-3-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 02:53:24PM -0400, Ohad Ben-Cohen wrote:

>  drivers/iommu/amd_iommu.c   |   20 ++++++-
>  drivers/iommu/intel-iommu.c |   20 ++++++-
>  drivers/iommu/iommu.c       |  129 +++++++++++++++++++++++++++++++++++++++----
>  drivers/iommu/msm_iommu.c   |    8 ++-
>  drivers/iommu/omap-iommu.c  |    6 ++-
>  drivers/iommu/omap-iovmm.c  |   12 +---
>  include/linux/iommu.h       |    7 +-
>  virt/kvm/iommu.c            |    4 +-
>  8 files changed, 176 insertions(+), 30 deletions(-)

Please split this patch into the core-change and patches for the
individual iommu-drivers and post this as a seperate patch-set.

> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index a14f8dc..5cdfa91 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -2488,12 +2488,30 @@ static unsigned device_dma_ops_init(void)
>  }
> 
>  /*
> + * This bitmap is used to advertise the page sizes our hardware support
> + * to the IOMMU core, which will then use this information to split
> + * physically contiguous memory regions it is mapping into page sizes
> + * that we support.
> + *
> + * Traditionally the IOMMU core just handed us the mappings directly,
> + * after making sure the size is an order of a 4KB page and that the
> + * mapping has natural alignment.
> + *
> + * To retain this behavior, we currently advertise that we support
> + * all page sizes that are an order of 4KB.
> + *
> + * If at some point we'd like to utilize the IOMMU core's new behavior,
> + * we could change this to advertise the real page sizes we support.
> + */
> +static unsigned long amd_iommu_pgsizes = ~0xFFFUL;
> +
> +/*
>   * The function which clues the AMD IOMMU driver into dma_ops.
>   */
> 
>  void __init amd_iommu_init_api(void)
>  {
> -       register_iommu(&amd_iommu_ops);
> +       register_iommu(&amd_iommu_ops, &amd_iommu_pgsizes, BITS_PER_LONG);
>  }
> 
>  int __init amd_iommu_init_dma_ops(void)
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index c621c98..a8c91a6 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3426,6 +3426,24 @@ static struct notifier_block device_nb = {
>         .notifier_call = device_notifier,
>  };
> 
> +/*
> + * This bitmap is used to advertise the page sizes our hardware support
> + * to the IOMMU core, which will then use this information to split
> + * physically contiguous memory regions it is mapping into page sizes
> + * that we support.
> + *
> + * Traditionally the IOMMU core just handed us the mappings directly,
> + * after making sure the size is an order of a 4KB page and that the
> + * mapping has natural alignment.
> + *
> + * To retain this behavior, we currently advertise that we support
> + * all page sizes that are an order of 4KB.
> + *
> + * If at some point we'd like to utilize the IOMMU core's new behavior,
> + * we could change this to advertise the real page sizes we support.
> + */
> +static unsigned long intel_iommu_pgsizes = ~0xFFFUL;

Intel IOMMU does not support arbitrary page-sizes, afaik.

> +
>  int __init intel_iommu_init(void)
>  {
>         int ret = 0;
> @@ -3486,7 +3504,7 @@ int __init intel_iommu_init(void)
> 
>         init_iommu_pm_ops();
> 
> -       register_iommu(&intel_iommu_ops);
> +       register_iommu(&intel_iommu_ops, &intel_iommu_pgsizes, BITS_PER_LONG);
> 
>         bus_register_notifier(&pci_bus_type, &device_nb);
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index c68ff29..e07ea03 100644
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
> @@ -23,15 +25,41 @@
>  #include <linux/slab.h>
>  #include <linux/errno.h>
>  #include <linux/iommu.h>
> +#include <linux/bitmap.h>
> 
>  static struct iommu_ops *iommu_ops;
> 
> -void register_iommu(struct iommu_ops *ops)
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
> + */
> +void register_iommu(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
> +                                       unsigned int nr_page_bits)
>  {
> -       if (iommu_ops)
> +       if (iommu_ops || iommu_pgsize_bitmap || !nr_page_bits)
>                 BUG();
> 
>         iommu_ops = ops;
> +       iommu_pgsize_bitmap = pgsize_bitmap;
> +       iommu_nr_page_bits = nr_page_bits;
> +
> +       /* find the minimum page size and its index only once */
> +       iommu_min_page_idx = find_first_bit(pgsize_bitmap, nr_page_bits);
> +       iommu_min_pagesz = 1 << iommu_min_page_idx;
>  }
> 
>  bool iommu_found(void)
> @@ -109,26 +137,103 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
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
> +                       "0x%x\n", iova, (unsigned long)paddr, size,
> +                       iommu_min_pagesz);
> +               return -EINVAL;
> +       }
> +
> +       pr_debug("map: iova 0x%lx pa 0x%lx size 0x%lx\n", iova,
> +                                       (unsigned long)paddr, size);

Please keep the debug-code in a seperate patch in your dev-tree. No need
for it to be merged upstream.

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
> 
> -       size         = 0x1000UL << gfp_order;
> +                       idx = find_next_bit(iommu_pgsize_bitmap,
> +                                               iommu_nr_page_bits, idx + 1);
> 
> -       BUG_ON(!IS_ALIGNED(iova | paddr, size));
> +                       /* no more pages to check ? */
> +                       if (idx >= iommu_nr_page_bits)
> +                               break;
> 
> -       return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
> +                       try_pgsize = 1 << idx;
> +
> +                       /* page too big ? addresses not aligned ? */
> +                       if (size < try_pgsize ||
> +                                       !IS_ALIGNED(addr_merge, try_pgsize))
> +                               break;
> +
> +                       pgsize = try_pgsize;
> +               }
> +
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
> +                               iova, size, iommu_min_pagesz);
> +               return -EINVAL;
> +       }
> +
> +       pr_debug("unmap this: iova 0x%lx size 0x%lx\n", iova, size);
> +
> +       while (size > total_unmapped) {
> +               order = get_order(size - total_unmapped);
> +
> +               unmapped_order = iommu_ops->unmap(domain, iova, order);
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
>  EXPORT_SYMBOL_GPL(iommu_unmap);
> diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
> index d1733f6..e59ced9 100644
> --- a/drivers/iommu/msm_iommu.c
> +++ b/drivers/iommu/msm_iommu.c
> @@ -676,6 +676,9 @@ fail:
>         return 0;
>  }
> 
> +/* bitmap of the page sizes currently supported */
> +static unsigned long msm_iommu_pgsizes = SZ_4K | SZ_64K | SZ_1M | SZ_16M;
> +
>  static struct iommu_ops msm_iommu_ops = {
>         .domain_init = msm_iommu_domain_init,
>         .domain_destroy = msm_iommu_domain_destroy,
> @@ -728,7 +731,10 @@ static void __init setup_iommu_tex_classes(void)
>  static int __init msm_iommu_init(void)
>  {
>         setup_iommu_tex_classes();
> -       register_iommu(&msm_iommu_ops);
> +
> +       /* we're only using the first 25 bits of the pgsizes bitmap */
> +       register_iommu(&msm_iommu_ops, &msm_iommu_pgsizes, 25);
> +
>         return 0;
>  }
> 
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index ef70a08..3e8b815 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -1202,6 +1202,9 @@ static int omap_iommu_domain_has_cap(struct iommu_domain *domain,
>         return 0;
>  }
> 
> +/* bitmap of the page sizes supported by the OMAP IOMMU hardware */
> +static unsigned long omap_iommu_pgsizes = SZ_4K | SZ_64K | SZ_1M | SZ_16M;
> +
>  static struct iommu_ops omap_iommu_ops = {
>         .domain_init    = omap_iommu_domain_init,
>         .domain_destroy = omap_iommu_domain_destroy,
> @@ -1225,7 +1228,8 @@ static int __init omap_iommu_init(void)
>                 return -ENOMEM;
>         iopte_cachep = p;
> 
> -       register_iommu(&omap_iommu_ops);
> +       /* we're only using the first 25 bits of the pgsizes bitmap */
> +       register_iommu(&omap_iommu_ops, &omap_iommu_pgsizes, 25);
> 
>         return platform_driver_register(&omap_iommu_driver);
>  }
> diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
> index e8fdb88..f4dea5a 100644
> --- a/drivers/iommu/omap-iovmm.c
> +++ b/drivers/iommu/omap-iovmm.c
> @@ -409,7 +409,6 @@ static int map_iovm_area(struct iommu_domain *domain, struct iovm_struct *new,
>         unsigned int i, j;
>         struct scatterlist *sg;
>         u32 da = new->da_start;
> -       int order;
> 
>         if (!domain || !sgt)
>                 return -EINVAL;
> @@ -428,12 +427,10 @@ static int map_iovm_area(struct iommu_domain *domain, struct iovm_struct *new,
>                 if (bytes_to_iopgsz(bytes) < 0)
>                         goto err_out;
> 
> -               order = get_order(bytes);
> -
>                 pr_debug("%s: [%d] %08x %08x(%x)\n", __func__,
>                          i, da, pa, bytes);
> 
> -               err = iommu_map(domain, da, pa, order, flags);
> +               err = iommu_map(domain, da, pa, bytes, flags);
>                 if (err)
>                         goto err_out;
> 
> @@ -448,10 +445,9 @@ err_out:
>                 size_t bytes;
> 
>                 bytes = sg->length + sg->offset;
> -               order = get_order(bytes);
> 
>                 /* ignore failures.. we're already handling one */
> -               iommu_unmap(domain, da, order);
> +               iommu_unmap(domain, da, bytes);
> 
>                 da += bytes;
>         }
> @@ -474,12 +470,10 @@ static void unmap_iovm_area(struct iommu_domain *domain, struct omap_iommu *obj,
>         start = area->da_start;
>         for_each_sg(sgt->sgl, sg, sgt->nents, i) {
>                 size_t bytes;
> -               int order;
> 
>                 bytes = sg->length + sg->offset;
> -               order = get_order(bytes);
> 
> -               err = iommu_unmap(domain, start, order);
> +               err = iommu_unmap(domain, start, bytes);
>                 if (err < 0)
>                         break;
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index d67bf8c..074acbd 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -73,7 +73,8 @@ struct iommu_ops {
> 
>  #ifdef CONFIG_IOMMU_API
> 
> -extern void register_iommu(struct iommu_ops *ops);
> +extern void register_iommu(struct iommu_ops *ops, unsigned long *pgsize_bitmap,
> +                                       unsigned int nr_page_bits);
>  extern bool iommu_found(void);
>  extern struct iommu_domain *iommu_domain_alloc(void);
>  extern void iommu_domain_free(struct iommu_domain *domain);
> @@ -82,9 +83,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
>  extern void iommu_detach_device(struct iommu_domain *domain,
>                                 struct device *dev);
>  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
> -                    phys_addr_t paddr, int gfp_order, int prot);
> +                    phys_addr_t paddr, size_t size, int prot);
>  extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> -                      int gfp_order);
> +                      size_t size);
>  extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
>                                       unsigned long iova);
>  extern int iommu_domain_has_cap(struct iommu_domain *domain,
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 78c80f6..ea142d3 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -111,7 +111,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
> 
>                 /* Map into IO address space */
>                 r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
> -                             get_order(page_size), flags);
> +                             page_size, flags);
>                 if (r) {
>                         printk(KERN_ERR "kvm_iommu_map_address:"
>                                "iommu failed to map pfn=%llx\n", pfn);
> @@ -293,7 +293,7 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
>                 pfn  = phys >> PAGE_SHIFT;
> 
>                 /* Unmap address from IO address space */
> -               order       = iommu_unmap(domain, gfn_to_gpa(gfn), 0);
> +               order       = iommu_unmap(domain, gfn_to_gpa(gfn), PAGE_SIZE);
>                 unmap_pages = 1ULL << order;
> 
>                 /* Unpin all pages we just unmapped to not leak any memory */
> --
> 1.7.4.1
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

