Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1JKKia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:38:30 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:36524 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab1JKKi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:38:28 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz179dN1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LSWDJX-01-5YO-02
X-M-MSG: 
Date: Tue, 11 Oct 2011 12:38:20 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111011103820.GF2138@amd.com>
References: <20110927100505.GH2138@amd.com>
 <CAK=WgbahwY+7Ux-RjW2Tw9WBSwZnYuTMZ2NQASWyOXQ3zF6qFg@mail.gmail.com>
 <20110927131222.GL2138@amd.com>
 <CAK=WgbYG2tpMJ2SikZhm=R9j5kQ6Hm8CGg=q1bko3idzF53Q3Q@mail.gmail.com>
 <20110927181438.GM2138@amd.com>
 <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com>
 <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com>
 <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 06:49:32PM -0400, Ohad Ben-Cohen wrote:
> -int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
> +int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int size)
>  {
> -       size_t size;
> +       int order, unmapped_size, unmapped_order, total_unmapped = 0;
> 
>         if (unlikely(domain->ops->unmap == NULL))
>                 return -ENODEV;
> 
> -       size         = PAGE_SIZE << gfp_order;
> +       /*
> +        * The virtual address, as well as the size of the mapping, must be
> +        * aligned (at least) to the size of the smallest page supported
> +        * by the hardware
> +        */
> +       if (!IS_ALIGNED(iova | size, domain->ops->min_pagesz)) {
> +               pr_err("unaligned: iova 0x%lx size 0x%x min_pagesz 0x%x\n",
> +                       iova, size, domain->ops->min_pagesz);
> +               return -EINVAL;
> +       }
> +
> +       pr_debug("unmap this: iova 0x%lx size 0x%x\n", iova, size);
> +
> +       while (size > total_unmapped) {
> +               order = get_order(size - total_unmapped);

Hmm, this actually unmaps more than requested, even in the symetric
case. Imgine the user wants to unmap a 12kb region, then order
will be 4 and this code will tell the iommu-driver to unmap 16kb.

You need to make sure that you don;t pass larger regions then requested
to the low-level driver. Some logic like in the iommu_map function
should do it.

> +
> +               unmapped_order = domain->ops->unmap(domain, iova, order);
> +               if (unmapped_order < 0)
> +                       break;
> +
> +               pr_debug("unmapped: iova 0x%lx order %d\n", iova,
> +                                                       unmapped_order);
> +
> +               unmapped_size = 0x1000UL << unmapped_order;

Please use PAGE_SIZE instead of 0x1000UL.

> 
> -       BUG_ON(!IS_ALIGNED(iova, size));
> +               iova += unmapped_size;
> +               total_unmapped += unmapped_size;
> +       }
> 
> -       return domain->ops->unmap(domain, iova, gfp_order);
> +       return total_unmapped;
>  }
>  EXPORT_SYMBOL_GPL(iommu_unmap);
> 
> diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
> index e8fdb88..4a8f761 100644
> --- a/drivers/iommu/omap-iovmm.c
> +++ b/drivers/iommu/omap-iovmm.c
> @@ -409,7 +409,6 @@ static int map_iovm_area(struct iommu_domain
> *domain, struct iovm_struct *new,
>         unsigned int i, j;
>         struct scatterlist *sg;
>         u32 da = new->da_start;
> -       int order;
> 
>         if (!domain || !sgt)
>                 return -EINVAL;
> @@ -428,12 +427,10 @@ static int map_iovm_area(struct iommu_domain
> *domain, struct iovm_struct *new,
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
> @@ -474,13 +470,11 @@ static void unmap_iovm_area(struct iommu_domain
> *domain, struct omap_iommu *obj,
>         start = area->da_start;
>         for_each_sg(sgt->sgl, sg, sgt->nents, i) {
>                 size_t bytes;
> -               int order;
> 
>                 bytes = sg->length + sg->offset;
> -               order = get_order(bytes);
> 
> -               err = iommu_unmap(domain, start, order);
> -               if (err < 0)
> +               err = iommu_unmap(domain, start, bytes);
> +               if (err < bytes)
>                         break;
> 
>                 dev_dbg(obj->dev, "%s: unmap %08x(%x) %08x\n",
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 710291f..a10a86c 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -48,6 +48,22 @@ struct iommu_domain {
> 
>  #ifdef CONFIG_IOMMU_API
> 
> +/**
> + * struct iommu_ops - iommu ops and capabilities
> + * @domain_init: init iommu domain
> + * @domain_destroy: destroy iommu domain
> + * @attach_dev: attach device to an iommu domain
> + * @detach_dev: detach device from an iommu domain
> + * @map: map a physically contiguous memory region to an iommu domain
> + * @unmap: unmap a physically contiguous memory region from an iommu domain
> + * @iova_to_phys: translate iova to physical address
> + * @domain_has_cap: domain capabilities query
> + * @commit: commit iommu domain
> + * @pgsize_bitmap: bitmap of supported page sizes
> + * @min_pagesz: smallest page size supported. note: this member is private
> + *             to the IOMMU core, and maintained only for efficiency sake;
> + *             drivers don't need to set it.
> + */
>  struct iommu_ops {
>         int (*domain_init)(struct iommu_domain *domain);
>         void (*domain_destroy)(struct iommu_domain *domain);
> @@ -62,6 +78,8 @@ struct iommu_ops {
>         int (*domain_has_cap)(struct iommu_domain *domain,
>                               unsigned long cap);
>         void (*commit)(struct iommu_domain *domain);
> +       unsigned long pgsize_bitmap;
> +       unsigned int min_pagesz;
>  };
> 
>  extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
> @@ -73,9 +91,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
>  extern void iommu_detach_device(struct iommu_domain *domain,
>                                 struct device *dev);
>  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
> -                    phys_addr_t paddr, int gfp_order, int prot);
> +                    phys_addr_t paddr, int size, int prot);
>  extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
> -                      int gfp_order);
> +                      int size);
>  extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
>                                       unsigned long iova);
>  extern int iommu_domain_has_cap(struct iommu_domain *domain,
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index ca409be..26b3199 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -111,7 +111,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct
> kvm_memory_slot *slot)
> 
>                 /* Map into IO address space */
>                 r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
> -                             get_order(page_size), flags);
> +                             page_size, flags);
>                 if (r) {
>                         printk(KERN_ERR "kvm_iommu_map_address:"
>                                "iommu failed to map pfn=%llx\n", pfn);
> @@ -292,15 +292,15 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
> 
>         while (gfn < end_gfn) {
>                 unsigned long unmap_pages;
> -               int order;
> +               int size;
> 
>                 /* Get physical address */
>                 phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
>                 pfn  = phys >> PAGE_SHIFT;
> 
>                 /* Unmap address from IO address space */
> -               order       = iommu_unmap(domain, gfn_to_gpa(gfn), 0);
> -               unmap_pages = 1ULL << order;
> +               size       = iommu_unmap(domain, gfn_to_gpa(gfn), PAGE_SIZE);
> +               unmap_pages = 1ULL << get_order(size);
> 
>                 /* Unpin all pages we just unmapped to not leak any memory */
>                 kvm_unpin_pages(kvm, pfn, unmap_pages);

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

