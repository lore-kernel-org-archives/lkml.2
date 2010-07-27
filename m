Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab0G0Mrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 08:47:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48285 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0G0Mro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 08:47:44 -0400
Date: Tue, 27 Jul 2010 14:45:58 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <20100727120841.GC11468@n2100.arm.linux.org.uk>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org, "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        Pawel Osciak <p.osciak@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "'Hiremath Vaibhav'" <hvaibhav@ti.com>,
        "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Zach Pfeffer'" <zpfeffer@codeaurora.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-id: <003701cb2d89$adae4580$090ad080$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcsthKgjK94ZTFI1Qi2BH3LWPPl6rQAAb18Q
References: <cover.1280151963.git.m.nazarewicz@samsung.com>
 <743102607e2c5fb20e3c0676fadbcb93d501a78e.1280151963.git.m.nazarewicz@samsung.com>
 <dc4bdf3e0b02c0ac4770927f72b6cbc3f0b486a2.1280151963.git.m.nazarewicz@samsung.com>
 <20100727120841.GC11468@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, July 27, 2010 2:09 PM Russell King - ARM Linux wrote:

> On Mon, Jul 26, 2010 at 04:40:30PM +0200, Michal Nazarewicz wrote:
> > +** Why is it needed?
> > +
> > +    Various devices on embedded systems have no scatter-getter and/or
> > +    IO map support and as such require contiguous blocks of memory to
> > +    operate.  They include devices such as cameras, hardware video
> > +    decoders and encoders, etc.
> 
> Yes, this is becoming quite a big problem - and many ARM SoCs suffer
> from the existing memory allocators being extremely inadequate for
> their use.
> 
> One of the areas I've been working on is sorting out the DMA coherent
> allocator so we don't violate the architecture requirements for ARMv6
> and ARMv7 CPUs (which basically prohibits multiple mappings of memory
> with different attributes.)
> 
> One of the ideas that I've thought about for this is to reserve an
> amount of contiguous memory at boot time to fill the entire DMA coherent
> mapping, marking the memory in the main kernel memory map as 'no access',
> and allocate directly from the DMA coherent region.
> 
> However, discussing this with people who have the problem you're trying
> to solve indicates that they do not want to set aside an amount of
> memory as they perceive this to be a waste of resources.

Assuming your board have only 128MB of physical memory (quite common case
for some embedded boards), leaving 16MB unused just for DMA coherent
area is a huge waste imho.

> This concern also applies to 'cma'.

Yes, we know. We plan to recover some of that 'wasted' memory by providing
a way to allocate some kind of virtual swap device on it. This is just an
idea, no related works has been started yet.

> 
> > +/*
> > + * Don't call it directly, use cma_alloc(), cma_alloc_from() or
> > + * cma_alloc_from_region().
> > + */
> > +dma_addr_t __must_check
> > +__cma_alloc(const struct device *dev, const char *kind,
> > +	    size_t size, dma_addr_t alignment);
> 
> Does this really always return DMA-able memory (memory which can be
> DMA'd to/from without DMA-mapping etc?)
> 
> As it returns a dma_addr_t, it's returning a cookie for the memory which
> will be suitable for writing directly to the device 'dev' doing the DMA.
> (NB: DMA addresses may not be the same as physical addresses, especially
> if the device is on a downstream bus.  We have ARM platforms which have
> different bus offsets.)
> 
> How does one obtain the CPU address of this memory in order for the CPU
> to access it?

Right, we did not cover such case. In CMA approach we tried to separate
memory allocation from the memory mapping into user/kernel space. Mapping
a buffer is much more complicated process that cannot be handled in a
generic way, so we decided to leave this for the device drivers. Usually
video processing devices also don't need in-kernel mapping for such
buffers at all.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


