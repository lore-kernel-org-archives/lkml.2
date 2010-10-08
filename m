Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab0JHXkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 19:40:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:56451 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab0JHXkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 19:40:03 -0400
Subject: Re: [RFC PATCH 02/11] ppc: allow direct and iommu to coexist
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: miltonm@bga.com, Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1286559192-10898-3-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
	 <1286559192-10898-3-git-send-email-nacc@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Oct 2010 10:38:56 +1100
Message-ID: <1286581136.2463.421.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 10:33 -0700, Nishanth Aravamudan wrote:
> Replace the union with just the multiple fields, ifdef on CONFIG_PPC64.
> 
> Future pseries boxes will allow a 64 bit dma mapping covering all
> memory, coexisting with a smaller iommu window in 32 bit pci space.
> 
> The cell fixed mapping would also like both to coexist.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
> ---
> I used the ifdef guard of CONFIG_PPC64 according to the current makefile
> for iommu.c.  One set is burried in the middle of iommu.h.

I dislike the ifdef's ...

Also, why remove the union ? IE. Do we really them to co-exist for a
given device ? I'm doing something similar for another (not released
yet) processor where I'm flicking between direct and iommu at
set_dma_mask time, it's easy enough to change the union content.

Cheers,
Ben.

> ---
>  arch/powerpc/include/asm/device.h      |   14 ++++++--------
>  arch/powerpc/include/asm/dma-mapping.h |    4 ++--
>  arch/powerpc/include/asm/iommu.h       |    6 ++++--
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/device.h b/arch/powerpc/include/asm/device.h
> index 16d25c0..ed883ea 100644
> --- a/arch/powerpc/include/asm/device.h
> +++ b/arch/powerpc/include/asm/device.h
> @@ -19,14 +19,12 @@ struct dev_archdata {
>  	/* DMA operations on that device */
>  	struct dma_map_ops	*dma_ops;
>  
> -	/*
> -	 * When an iommu is in use, dma_data is used as a ptr to the base of the
> -	 * iommu_table.  Otherwise, it is a simple numerical offset.
> -	 */
> -	union {
> -		dma_addr_t	dma_offset;
> -		void		*iommu_table_base;
> -	} dma_data;
> +	/* dma_offset is used by swiotlb and direct dma ops, but no iommu */
> +	dma_addr_t	dma_offset;
> +
> +#ifdef CONFIG_PPC64
> +	void		*iommu_table_base;
> +#endif
>  
>  #ifdef CONFIG_SWIOTLB
>  	dma_addr_t		max_direct_dma_addr;
> diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
> index 8c9c6ad..644103a 100644
> --- a/arch/powerpc/include/asm/dma-mapping.h
> +++ b/arch/powerpc/include/asm/dma-mapping.h
> @@ -100,7 +100,7 @@ static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
>  static inline dma_addr_t get_dma_offset(struct device *dev)
>  {
>  	if (dev)
> -		return dev->archdata.dma_data.dma_offset;
> +		return dev->archdata.dma_offset;
>  
>  	return PCI_DRAM_OFFSET;
>  }
> @@ -108,7 +108,7 @@ static inline dma_addr_t get_dma_offset(struct device *dev)
>  static inline void set_dma_offset(struct device *dev, dma_addr_t off)
>  {
>  	if (dev)
> -		dev->archdata.dma_data.dma_offset = off;
> +		dev->archdata.dma_offset = off;
>  }
>  
>  /* this will be removed soon */
> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
> index edfc980..0f605a4 100644
> --- a/arch/powerpc/include/asm/iommu.h
> +++ b/arch/powerpc/include/asm/iommu.h
> @@ -70,15 +70,17 @@ struct iommu_table {
>  
>  struct scatterlist;
>  
> +#ifdef CONFIG_PPC64
>  static inline void set_iommu_table_base(struct device *dev, void *base)
>  {
> -	dev->archdata.dma_data.iommu_table_base = base;
> +	dev->archdata.iommu_table_base = base;
>  }
>  
>  static inline void *get_iommu_table_base(struct device *dev)
>  {
> -	return dev->archdata.dma_data.iommu_table_base;
> +	return dev->archdata.iommu_table_base;
>  }
> +#endif
>  
>  /* Frees table for an individual device node */
>  extern void iommu_free_table(struct iommu_table *tbl, const char *node_name);


