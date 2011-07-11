Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1GKNrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:47:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11820 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1GKNrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:47:39 -0400
Date: Mon, 11 Jul 2011 15:47:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Linaro-mm-sig] [PATCH 6/8] drivers: add Contiguous Memory
 Allocator
In-reply-to: <201107091657.07925.jkrzyszt@tis.icnet.pl>
To: "'Janusz Krzysztofik'" <jkrzyszt@tis.icnet.pl>,
        "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Marin Mitov'" <mitov@issp.bas.bg>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        linaro-mm-sig@lists.linaro.org,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
        "'Andrew Morton'" <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <001e01cc3fd1$159f7bf0$40de73d0$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acw+SPB6PnXMwQuiTJGvsC5GK5XVWgBhQprw
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com>
 <alpine.LFD.2.00.1107061034200.14596@xanadu.home>
 <201107061659.45253.arnd@arndb.de> <201107091657.07925.jkrzyszt@tis.icnet.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Saturday, July 09, 2011 4:57 PM Janusz Krzysztofik	wrote:

> On Wed, 6 Jul 2011 at 16:59:45 Arnd Bergmann wrote:
> > On Wednesday 06 July 2011, Nicolas Pitre wrote:
> > > On Wed, 6 Jul 2011, Russell King - ARM Linux wrote:
> > > > Another issue is that when a platform has restricted DMA regions,
> > > > they typically don't fall into the highmem zone.  As the
> > > > dmabounce code allocates from the DMA coherent allocator to
> > > > provide it with guaranteed DMA-able memory, that would be rather
> > > > inconvenient.
> > >
> > > Do we encounter this in practice i.e. do those platforms requiring
> > > large contiguous allocations motivating this work have such DMA
> > > restrictions?
> >
> > You can probably find one or two of those, but we don't have to
> > optimize for that case. I would at least expect the maximum size of
> > the allocation to be smaller than the DMA limit for these, and
> > consequently mandate that they define a sufficiently large
> > CONSISTENT_DMA_SIZE for the crazy devices, or possibly add a hack to
> > unmap some low memory and call
> > dma_declare_coherent_memory() for the device.
> 
> Once found that Russell has dropped his "ARM: DMA: steal memory for DMA
> coherent mappings" for now, let me get back to this idea of a hack that
> would allow for safely calling dma_declare_coherent_memory() in order to
> assign a device with a block of contiguous memory for exclusive use.

We tested such approach and finally with 3.0-rc1 it works fine. You can find
an example for dma_declare_coherent() together with required memblock_remove()
calls in the following patch series:
http://www.spinics.net/lists/linux-samsung-soc/msg05026.html 
"[PATCH 0/3 v2] ARM: S5P: Add support for MFC device on S5PV210 and EXYNOS4"

> Assuming there should be no problem with successfully allocating a large
> continuous block of coherent memory at boot time with
> dma_alloc_coherent(), this block could be reserved for the device. The
> only problem is with the dma_declare_coherent_memory() calling
> ioremap(), which was designed with a device's dedicated physical memory
> in mind, but shouldn't be called on a memory already mapped.

All these issues with ioremap has been finally resolved in 3.0-rc1. Like
Russell pointed me in http://www.spinics.net/lists/arm-kernel/msg127644.html,
ioremap can be fixed to work on early reserved memory areas by selecting
ARCH_HAS_HOLES_MEMORYMODEL Kconfig option.

> There were three approaches proposed, two of them in August 2010:
> http://www.spinics.net/lists/linux-media/msg22179.html,
> http://www.spinics.net/lists/arm-kernel/msg96318.html,
> and a third one in January 2011:
> http://www.spinics.net/lists/linux-arch/msg12637.html.
> 
> As far as I can understand the reason why both of the first two were
> NAKed, it was suggested that videobuf-dma-contig shouldn't use coherent
> if all it requires is a contiguous memory, and a new API should be
> invented, or dma_pool API extended, for providing contiguous memory.

This is another story. DMA-mapping framework definitely needs some 
extensions to allow more detailed specification of the allocated memory
(currently we have only coherent and nearly ARM-specific writecombine).
During Linaro Memory Management summit we agreed that the 
dma_alloc_attrs() function might be needed to clean-up the API and
provide a nice way of adding new memory parameters. Having a possibility
to allocate contiguous cached buffers might be one of the new DMA
attributes. Here are some details of my proposal:
http://www.spinics.net/lists/linux-mm/msg21235.html

> The
> CMA was pointed out as a new work in progress contiguous memory API.

That was probably the biggest mistake at the beginning. We definitely 
should have learned dma-mapping framework and its internals.

> Now
> it turns out it's not, it's only a helper to ensure that
> dma_alloc_coherent() always succeeds, and videobuf2-dma-contig is still
> going to allocate buffers from coherent memory.

I hope that once the dma_alloc_attrs() API will be accepted, I will add
support for memory attributes to videobuf2-dma-contig allocator. 
 
> (CCing both authors, Marin Mitov and Guennadi Liakhovetski, and their
> main opponent, FUJITA Tomonori)
> 
> The third solution was not discussed much after it was pointed out as
> being not very different from those two in terms of the above mentioned
> rationale.
> 
> All three solutions was different from now suggested method of unmapping
> some low memory and then calling dma_declare_coherent_memory() which
> ioremaps it in that those tried to reserve some boot time allocated
> coherent memory, already mapped correctly, without (io)remapping it.
> 
> If there are still problems with the CMA on one hand, and a need for a
> hack to handle "crazy devices" is still seen, regardless of CMA
> available and working or not, on the other, maybe we should get back to
> the idea of adopting coherent API to new requirements, review those
> three proposals again and select one which seems most acceptable to
> everyone? Being a submitter of the third, I'll be happy to refresh it if
> selected.

I'm open to discussion.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


