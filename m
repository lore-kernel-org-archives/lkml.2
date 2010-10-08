Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916Ab0JHXtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 19:49:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:37841 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab0JHXtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 19:49:22 -0400
Subject: Re: [RFC PATCH 03/11] ppc: Create ops to choose between direct
 window and iommu based on device mask
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: miltonm@bga.com, Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Anton Vorontsov <avorontsov@mvista.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1286559192-10898-4-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
	 <1286559192-10898-4-git-send-email-nacc@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Oct 2010 10:44:53 +1100
Message-ID: <1286581493.2463.428.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 10:33 -0700, Nishanth Aravamudan wrote:
> Also allow the coherent ops to be iommu if only the coherent mask is too
> small, mostly for driver that do not set set the coherent mask but also
> don't use the coherent api.

You are doing the transition at map_sg time which is a hot path, I don't
like that. Also you add all those "choose" variants of the dma ops...
not very nice at all.

You may want to look at the patches I posted to the list a while back
for doing direct DMA on Bimini:

[PATCH 1/2] powerpc/dma: Add optional platform override of dma_set_mask()
[PATCH 2/2] powerpc/dart_iommu: Support for 64-bit iommu bypass window on PCIe

Cheers,
Ben.

> Signed-off-by: Milton Miller <miltonm@bga.com>
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> ---
>  arch/powerpc/include/asm/dma-mapping.h |    2 +
>  arch/powerpc/kernel/Makefile           |    2 +-
>  arch/powerpc/kernel/dma-choose64.c     |  167 ++++++++++++++++++++++++++++++++
>  3 files changed, 170 insertions(+), 1 deletions(-)
>  create mode 100644 arch/powerpc/kernel/dma-choose64.c
> 
> diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
> index 644103a..9ffb16a 100644
> --- a/arch/powerpc/include/asm/dma-mapping.h
> +++ b/arch/powerpc/include/asm/dma-mapping.h
> @@ -68,6 +68,8 @@ static inline unsigned long device_to_mask(struct device *dev)
>   */
>  #ifdef CONFIG_PPC64
>  extern struct dma_map_ops dma_iommu_ops;
> +extern struct dma_map_ops dma_choose64_ops;
> +extern struct dma_map_ops dma_iommu_coherent_ops;
>  #endif
>  extern struct dma_map_ops dma_direct_ops;
>  
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 1dda701..21b8ea1 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -82,7 +82,7 @@ obj-y				+= time.o prom.o traps.o setup-common.o \
>  				   udbg.o misc.o io.o dma.o \
>  				   misc_$(CONFIG_WORD_SIZE).o
>  obj-$(CONFIG_PPC32)		+= entry_32.o setup_32.o
> -obj-$(CONFIG_PPC64)		+= dma-iommu.o iommu.o
> +obj-$(CONFIG_PPC64)		+= dma-iommu.o iommu.o dma-choose64.o
>  obj-$(CONFIG_KGDB)		+= kgdb.o
>  obj-$(CONFIG_PPC_OF_BOOT_TRAMPOLINE)	+= prom_init.o
>  obj-$(CONFIG_MODULES)		+= ppc_ksyms.o
> diff --git a/arch/powerpc/kernel/dma-choose64.c b/arch/powerpc/kernel/dma-choose64.c
> new file mode 100644
> index 0000000..17c716f
> --- /dev/null
> +++ b/arch/powerpc/kernel/dma-choose64.c
> @@ -0,0 +1,167 @@
> +/*
> + * Copyright (C) 2006 Benjamin Herrenschmidt, IBM Corporation
> + *
> + * Provide default implementations of the DMA mapping callbacks for
> + * directly mapped busses.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/bug.h>
> +
> +/*
> + * DMA operations that choose between a 64-bit direct mapping and and iommu
> + *
> + * This set of dma ops chooses between directing to a static 1:1 mapping
> + * that may require a 64 bit address and a iommu based on the declared
> + * streaming and coherent masks for the device.  The choice is made on
> + * the first dma map call.
> + */
> +
> +/* first BUG ops for calls out of sequence */
> +
> +void *dma_bug_alloc_coherent(struct device *dev, size_t size,
> +				dma_addr_t *dma_handle, gfp_t flag)
> +{
> +	BUG();
> +
> +	return NULL;
> +}
> +
> +void dma_bug_free_coherent(struct device *dev, size_t size,
> +			      void *vaddr, dma_addr_t dma_handle)
> +{
> +	BUG();
> +}
> +
> +static int dma_bug_dma_supported(struct device *dev, u64 mask)
> +{
> +	BUG();
> +
> +	return 0;
> +}
> +
> +static int dma_bug_map_sg(struct device *dev, struct scatterlist *sgl,
> +			     int nents, enum dma_data_direction direction,
> +			     struct dma_attrs *attrs)
> +{
> +	BUG();
> +
> +	return 0;
> +}
> +
> +
> +static void dma_bug_unmap_sg(struct device *dev, struct scatterlist *sg,
> +				int nents, enum dma_data_direction direction,
> +				struct dma_attrs *attrs)
> +{
> +	BUG();
> +}
> +
> +static dma_addr_t dma_bug_map_page(struct device *dev,
> +					     struct page *page,
> +					     unsigned long offset,
> +					     size_t size,
> +					     enum dma_data_direction dir,
> +					     struct dma_attrs *attrs)
> +{
> +	BUG();
> +
> +	return DMA_ERROR_CODE;
> +}
> +
> +
> +static void dma_bug_unmap_page(struct device *dev,
> +					 dma_addr_t dma_address,
> +					 size_t size,
> +					 enum dma_data_direction direction,
> +					 struct dma_attrs *attrs)
> +{
> +	BUG();
> +}
> +
> +
> +static struct dma_map_ops *choose(struct device *dev)
> +{
> +	if (dma_direct_ops.dma_supported(dev, device_to_mask(dev))) {
> +		if (dma_direct_ops.dma_supported(dev, dev->coherent_dma_mask))
> +			return &dma_direct_ops;
> +		return &dma_iommu_coherent_ops;
> +	}
> +	return &dma_iommu_ops;
> +}
> +
> +void *dma_choose64_alloc_coherent(struct device *dev, size_t size,
> +				dma_addr_t *dma_handle, gfp_t flag)
> +{
> +	struct dma_map_ops *new = choose(dev);
> +
> +	set_dma_ops(dev, new);
> +	return new->alloc_coherent(dev, size, dma_handle, flag);
> +}
> +
> +static int dma_choose64_map_sg(struct device *dev, struct scatterlist *sgl,
> +			     int nents, enum dma_data_direction direction,
> +			     struct dma_attrs *attrs)
> +{
> +	struct dma_map_ops *new = choose(dev);
> +
> +	set_dma_ops(dev, new);
> +	return new->map_sg(dev, sgl, nents, direction, attrs);
> +}
> +
> +
> +static int dma_choose64_dma_supported(struct device *dev, u64 mask)
> +{
> +	return dma_direct_ops.dma_supported(dev, mask) ||
> +		dma_iommu_ops.dma_supported(dev, mask);
> +}
> +
> +static dma_addr_t dma_choose64_map_page(struct device *dev,
> +					     struct page *page,
> +					     unsigned long offset,
> +					     size_t size,
> +					     enum dma_data_direction dir,
> +					     struct dma_attrs *attrs)
> +{
> +	struct dma_map_ops *new = choose(dev);
> +
> +	set_dma_ops(dev, new);
> +	return new->map_page(dev, page, offset, size, dir, attrs);
> +}
> +
> +struct dma_map_ops dma_choose64_ops = {
> +	.alloc_coherent	= dma_choose64_alloc_coherent,
> +	.free_coherent	= dma_bug_free_coherent,
> +	.map_sg		= dma_choose64_map_sg,
> +	.unmap_sg	= dma_bug_unmap_sg,
> +	.dma_supported	= dma_choose64_dma_supported,
> +	.map_page	= dma_choose64_map_page,
> +	.unmap_page	= dma_bug_unmap_page,
> +};
> +EXPORT_SYMBOL(dma_choose64_ops);
> +
> +/* set these up to BUG() until we initialze them in the arch initcall below */
> +struct dma_map_ops dma_iommu_coherent_ops = {
> +	.alloc_coherent	= dma_bug_alloc_coherent,
> +	.free_coherent	= dma_bug_free_coherent,
> +	.map_sg		= dma_bug_map_sg,
> +	.unmap_sg	= dma_bug_unmap_sg,
> +	.dma_supported	= dma_bug_dma_supported,
> +	.map_page	= dma_bug_map_page,
> +	.unmap_page	= dma_bug_unmap_page,
> +};
> +EXPORT_SYMBOL(dma_iommu_coherent_ops);
> +
> +static int setup_choose64_ops(void)
> +{
> +	dma_iommu_coherent_ops = dma_direct_ops;
> +	dma_iommu_coherent_ops.alloc_coherent = dma_iommu_ops.alloc_coherent;
> +	dma_iommu_coherent_ops.free_coherent = dma_iommu_ops.free_coherent;
> +
> +	/* should we be stricter? */
> +	dma_iommu_coherent_ops.dma_supported = dma_choose64_dma_supported;
> +
> +	return 0;
> +}
> +arch_initcall(setup_choose64_ops);



