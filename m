Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab2GBLGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:06:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8500 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2GBLGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:06:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jul 2012 04:06:04 -0700
Date: Mon, 2 Jul 2012 14:06:01 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Subash Patel <subashrp@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCHv4 2/2] ARM: dma-mapping: remove custom consistent dma
 region
Message-ID: <20120702140601.124e307e493bff4f05efb0b1@nvidia.com>
In-Reply-To: <1340614047-5824-3-git-send-email-m.szyprowski@samsung.com>
References: <1340614047-5824-1-git-send-email-m.szyprowski@samsung.com>
	<1340614047-5824-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Mon, 25 Jun 2012 10:47:27 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> This patch changes dma-mapping subsystem to use generic vmalloc areas
> for all consistent dma allocations. This increases the total size limit
> of the consistent allocations and removes platform hacks and a lot of
> duplicated code.
> 
> Atomic allocations are served from special pool preallocated on boot,
> becasue vmalloc areas cannot be reliably created in atomic context.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/kernel-parameters.txt |    2 +-
>  arch/arm/include/asm/dma-mapping.h  |    2 +-
>  arch/arm/mm/dma-mapping.c           |  505 +++++++++++++----------------------
>  arch/arm/mm/mm.h                    |    3 +
>  include/linux/vmalloc.h             |    1 +
>  mm/vmalloc.c                        |   10 +-
>  6 files changed, 194 insertions(+), 329 deletions(-)
> 
......
> -static int __init consistent_init(void)
> -{
> -       int ret = 0;
> -       pgd_t *pgd;
> -       pud_t *pud;
> -       pmd_t *pmd;
> -       pte_t *pte;
> -       int i = 0;
> -       unsigned long base = consistent_base;
> -       unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
> -
> -       if (IS_ENABLED(CONFIG_CMA) && !IS_ENABLED(CONFIG_ARM_DMA_USE_IOMMU))
> -               return 0;
> -
> -       consistent_pte = kmalloc(num_ptes * sizeof(pte_t), GFP_KERNEL);
> -       if (!consistent_pte) {
> -               pr_err("%s: no memory\n", __func__);
> -               return -ENOMEM;
> -       }
> -
> -       pr_debug("DMA memory: 0x%08lx - 0x%08lx:\n", base, CONSISTENT_END);
> -       consistent_head.vm_start = base;
> -
> -       do {
> -               pgd = pgd_offset(&init_mm, base);
> -
> -               pud = pud_alloc(&init_mm, pgd, base);
> -               if (!pud) {
> -                       pr_err("%s: no pud tables\n", __func__);
> -                       ret = -ENOMEM;
> -                       break;
> -               }
> -
> -               pmd = pmd_alloc(&init_mm, pud, base);
> -               if (!pmd) {
> -                       pr_err("%s: no pmd tables\n", __func__);
> -                       ret = -ENOMEM;
> -                       break;
> -               }
> -               WARN_ON(!pmd_none(*pmd));
> -
> -               pte = pte_alloc_kernel(pmd, base);
> -               if (!pte) {
> -                       pr_err("%s: no pte tables\n", __func__);
> -                       ret = -ENOMEM;
> -                       break;
> -               }
> -
> -               consistent_pte[i++] = pte;
> -               base += PMD_SIZE;
> -       } while (base < CONSISTENT_END);
> -
> -       return ret;
> -}
> -core_initcall(consistent_init);
> -
>  static void *__alloc_from_contiguous(struct device *dev, size_t size,
>                                      pgprot_t prot, struct page **ret_page);
> 
> -static struct arm_vmregion_head coherent_head = {
> -       .vm_lock        = __SPIN_LOCK_UNLOCKED(&coherent_head.vm_lock),
> -       .vm_list        = LIST_HEAD_INIT(coherent_head.vm_list),
> +static void *__alloc_remap_buffer(struct device *dev, size_t size, gfp_t gfp,
> +                                pgprot_t prot, struct page **ret_page,
> +                                const void *caller);
> +
> +static void *
> +__dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot,
> +       const void *caller)
> +{
> +       struct vm_struct *area;
> +       unsigned long addr;
> +
> +       area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> +                                 caller);
> +       if (!area)
> +               return NULL;
> +       addr = (unsigned long)area->addr;
> +       area->phys_addr = __pfn_to_phys(page_to_pfn(page));
> +
> +       if (ioremap_page_range(addr, addr + size, area->phys_addr, prot)) {
> +               vunmap((void *)addr);
> +               return NULL;
> +       }
> +       return (void *)addr;
> +}

The above "ioremap_page_range()" seems to be executed against normal
pages(liner kernel mapping) with setting a new prot, because pages were
passed from __dma_alloc_buffer(){..alloc_pages()...}. For me, this is
creating another page mapping with different pgprot, and it can cause
the pgprot inconsistency. This reminds me of the following old patch.

  [RFC PATCH] Avoid aliasing mappings in DMA coherent allocator
  http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/106815.html

I think that this is why ioremap() isn't allowed with RAM.

  __arm_ioremap_pfn_caller() doens't allow RAM remapping.
  
  193 void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
  194         unsigned long offset, size_t size, unsigned int mtype, void *caller)
  195 {
  196         const struct mem_type *type;
  197         int err;
  ... .
  240         /*                                                                                                                                                                                  
  241          * Don't allow RAM to be mapped - this causes problems with ARMv6+                                                                                                                  
  242          */
  243         if (WARN_ON(pfn_valid(pfn)))
  244                 return NULL;
  ...

So my question is:
1, is the above ioremap_page_range() creating another page mapping
   with a new pgprot, in addition to liner mapping?
2, If so, is it safe for pgprot inconsistency from different vaddrs?

I hope that my questins are making sense.
