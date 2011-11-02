Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1KBSIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:08:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43228 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932240Ab1KBSIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:08:17 -0400
Date: Wed, 2 Nov 2011 18:07:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 16/16] ARM: LPAE: Add the Kconfig entries
Message-ID: <20111102180758.GK29782@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
 <1312988619-16804-17-git-send-email-catalin.marinas@arm.com>
 <20111102172142.GB12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102172142.GB12913@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 05:21:42PM +0000, Russell King - ARM Linux wrote:
> On Wed, Aug 10, 2011 at 04:03:39PM +0100, Catalin Marinas wrote:
> > +config ARCH_DMA_ADDR_T_64BIT
> > +	def_bool ARM_LPAE
> > +
> 
> I think this should be selected only when we have a DMA engine supporting
> 64-bit addresses.  Technically LPAE itself doesn't give us that assurance.
> 
> If you have this kind of a setup:
> 
> CPU <==++==> RAM
>        ||
>      IOMMU
>        |
>    DMA device
> 
> where == and || means >32-bit addressing, and | means 32-bit addressing.

That's one configuration but there are other configurations with PCI
devices that can access 64-bit addresses without requiring an IOMMU.

> In such a setup, having dma_addr_t be 64-bit is pointless because it
> should never see 64-bit addresses (the DMA API should deal with the
> IOMMU and provide a list of DMA addresses to be placed into RAM for
> the DMA device which takes account of the mappings setup in the IOMMU.)
> 
> So, I think 64-bit dma_addr_t should be a property of the DMA devices
> present in the system rather than whether the CPUs MMU can deal with
> >32-bit addresses or not.

I agree, that's a property of the device but it doesn't mean that we
can't have a dma_addr_t as u64.

The current DMA allocator uses pages that can be placed anywhere if the
mask is 0xffffffff, so just making this type u32 does not change such
allocation, just ignoring the top bits of the bus address. What I think
we need for this case is GFP_DMA32, assuming that ZONE_DMA32 is set up:

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e4e7f6c..a51026b 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -81,6 +81,8 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 
 	if (mask < 0xffffffffULL)
 		gfp |= GFP_DMA;
+	else if (mask == 0xffffffffULL)
+		gfp |= GFP_DMA32;
 
 	page = alloc_pages(gfp, order);
 	if (!page)

-- 
Catalin
