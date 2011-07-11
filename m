Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1GKTFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:05:37 -0400
Received: from d1.icnet.pl ([212.160.220.21]:39926 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab1GKTFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:05:35 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [Linaro-mm-sig] [PATCH 6/8] drivers: add Contiguous Memory Allocator
Date: Mon, 11 Jul 2011 21:01:17 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Marin Mitov'" <mitov@issp.bas.bg>,
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
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <201107091657.07925.jkrzyszt@tis.icnet.pl> <001e01cc3fd1$159f7bf0$40de73d0$%szyprowski@samsung.com>
In-Reply-To: <001e01cc3fd1$159f7bf0$40de73d0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107112101.18601.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia poniedziałek, 11 lipca 2011 o 15:47:32 Marek Szyprowski napisał(a):
> Hello,
> 
> On Saturday, July 09, 2011 4:57 PM Janusz Krzysztofik	wrote:
> > On Wed, 6 Jul 2011 at 16:59:45 Arnd Bergmann wrote:
> > > On Wednesday 06 July 2011, Nicolas Pitre wrote:
> > > > On Wed, 6 Jul 2011, Russell King - ARM Linux wrote:
> > > > > Another issue is that when a platform has restricted DMA
> > > > > regions, they typically don't fall into the highmem zone. 
> > > > > As the dmabounce code allocates from the DMA coherent
> > > > > allocator to provide it with guaranteed DMA-able memory,
> > > > > that would be rather inconvenient.
> > > > 
> > > > Do we encounter this in practice i.e. do those platforms
> > > > requiring large contiguous allocations motivating this work
> > > > have such DMA restrictions?
> > > 
> > > You can probably find one or two of those, but we don't have to
> > > optimize for that case. I would at least expect the maximum size
> > > of the allocation to be smaller than the DMA limit for these,
> > > and consequently mandate that they define a sufficiently large
> > > CONSISTENT_DMA_SIZE for the crazy devices, or possibly add a
> > > hack to unmap some low memory and call
> > > dma_declare_coherent_memory() for the device.
> > 
> > Once found that Russell has dropped his "ARM: DMA: steal memory for
> > DMA coherent mappings" for now, let me get back to this idea of a
> > hack that would allow for safely calling
> > dma_declare_coherent_memory() in order to assign a device with a
> > block of contiguous memory for exclusive use.
> 
> We tested such approach and finally with 3.0-rc1 it works fine. You
> can find an example for dma_declare_coherent() together with
> required memblock_remove() calls in the following patch series:
> http://www.spinics.net/lists/linux-samsung-soc/msg05026.html
> "[PATCH 0/3 v2] ARM: S5P: Add support for MFC device on S5PV210 and
> EXYNOS4"
> 
> > Assuming there should be no problem with successfully allocating a
> > large continuous block of coherent memory at boot time with
> > dma_alloc_coherent(), this block could be reserved for the device.
> > The only problem is with the dma_declare_coherent_memory() calling
> > ioremap(), which was designed with a device's dedicated physical
> > memory in mind, but shouldn't be called on a memory already
> > mapped.
> 
> All these issues with ioremap has been finally resolved in 3.0-rc1.
> Like Russell pointed me in
> http://www.spinics.net/lists/arm-kernel/msg127644.html, ioremap can
> be fixed to work on early reserved memory areas by selecting
> ARCH_HAS_HOLES_MEMORYMODEL Kconfig option.

I'm not sure. Recently I tried to refresh my now 7 months old patch in 
which I used that 'memblock_remove() then dma_declare_coherent_memery()' 
method[1]. It was different from your S5P MFC example in that it didn't 
punch any holes in the system memory, only stole a block of SDRAM from 
its tail. But Russell reminded me again: "we should not be mapping SDRAM 
using device mappings."[2]. Would defining ARCH_HAS_HOLES_MEMORYMODEL 
(even if it was justified) make any diference in my case? I don't think 
so. Wnat I think, after Russell, is that we still need that obligatory 
ioremap() removed from dma_declare_coherent_memory(), or made it 
optional, or a separate dma_declare_coherent_memory()-like function 
without (obligatory) ioremap() provided by the DMA API, in order to get 
the dma_declare_coherent_memery() method being accepted without any 
reservations when used inside arch/arm, I'm afraid.

Thanks,
Janusz

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/034644.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2011-June/052488.html
