Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1CXJlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:41:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46325 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1CXJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:41:50 -0400
Date: Thu, 24 Mar 2011 09:41:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Hong XU <hong.xu@atmel.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Hit BUG_ON in dma-mapping.c:425 (RFC)
Message-ID: <20110324094122.GB19935@n2100.arm.linux.org.uk>
References: <4D24A108.2080609@atmel.com> <4D8AFE45.8050609@atmel.com> <20110324082521.GB9844@n2100.arm.linux.org.uk> <1300955778.2735.68.camel@localhost> <20110324092732.GA19935@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324092732.GA19935@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 09:27:32AM +0000, Russell King - ARM Linux wrote:
> I have no idea.  The problem comes down to MTDs interfaces being designed
> only for PIO - it's expected that the CPU places data into the virtual
> address being passed.  This virtual address can be a vmalloc address,
> a kmalloc'd address or a page address.
> 
> As long as that happens, everything all works because there's no cache
> aliasing problems to consider as the buffers are always accessed through
> the same mappings.
> 
> As soon as there's any attempt to move away from PIO, things get really
> sticky because, with *any* DMA noncoherent architecture (it's not limited
> to ARM) you run into issues with cache coherency causing data corruption.
> 
> When cache maintainence ends up having to deal with virtual addresses for
> one level of cache and physical addresses for subseqent levels, the
> problems are compounded even more.
> 
> The only real answer I can give is: if you want to deal with DMA, you
> absolutely must conform to the restrictions on DMA which means that you
> can't pass vmalloc addresses to the DMA API.
> 
> You can't work around that by converting a vmalloc address to a physical
> address and then its coresponding virtual page address as that means the
> DMA API will flush the wrong virtual address range and you'll again have
> cache incoherency.  That goes for *all* of the DMA API interfaces.

I should add - from asm-generic/dma-mapping-common.h:

static inline dma_addr_t dma_map_single_attrs(struct device *dev, void *ptr,
                                              size_t size,
                                              enum dma_data_direction dir,
                                              struct dma_attrs *attrs)
{
        struct dma_map_ops *ops = get_dma_ops(dev);
        dma_addr_t addr;

        kmemcheck_mark_initialized(ptr, size);
        BUG_ON(!valid_dma_direction(dir));
        addr = ops->map_page(dev, virt_to_page(ptr),
                             (unsigned long)ptr & ~PAGE_MASK, size,
                             dir, attrs);

And note that virt_to_page() only works for addresses in the kernel's
direct mapped memory region (iow, kmalloc et.al, not vmalloc).  The
above will probably go wrong silently (or maybe oops if you're lucky)
rather than BUG.  The difference is that on ARM we ensure that such bad
cases are always caught.
