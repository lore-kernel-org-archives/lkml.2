Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1CKPjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:39:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:55478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1CKPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:39:19 -0500
Date: Fri, 11 Mar 2011 16:39:01 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU)
 driver
In-reply-to: <201103111615.01829.arnd@arndb.de>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        kgene.kim@samsung.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        =?ks_c_5601-1987?B?J7TrwM6x4ic=?= <inki.dae@samsung.com>,
        =?ks_c_5601-1987?B?J7Ctuc6x1Cc=?= <mk7.kang@samsung.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>, linux-kernel@vger.kernel.org
Message-id: <000201cbe002$768d9de0$63a8d9a0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acvf/x03iHfgd7W5TeS39Swkgdkp1wAAdiHA
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com>
 <201103111507.59825.arnd@arndb.de>
 <000101cbdffb$e1844b00$a48ce100$%szyprowski@samsung.com>
 <201103111615.01829.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, March 11, 2011 4:15 PM Arnd Bergmann wrote:

> On Friday 11 March 2011, Marek Szyprowski wrote:
> > On Friday, March 11, 2011 3:08 PM Arnd Bergmann wrote:
> >
> > > On Friday 11 March 2011, Marek Szyprowski wrote:
> > > > > The iommu API is not really meant to be KVM specific, it's just that the
> > > > > in-tree users are basically limited to KVM at the moment. Another user that
> > > > > is coming up soon is the vmio device driver that can be used to transparently
> > > > > pass devices to user space. The idea behind the IOMMU API is that you can
> > > > > map arbitrary bus addresses to physical memory addresses, but it does not
> > > > > deal with allocating the bus addresses or providing buffer management such
> > > > > as cache flushes.
> > > >
> > > > Yea, I've noticed this and this basically what we expect from iommu driver.
> > > > However the iommu.h API requires a separate call to map each single memory page.
> > > > This is quite ineffective approach and imho the API need to be extended to allow
> > > > mapping of the arbitrary set of pages.
> > >
> > > We can always discuss extensions to the existing infrastructure, adding
> > > an interface for mapping an array of page pointers in the iommu API
> > > sounds like a good idea.
> >
> > We will investigate this API further. From the first sight it looks it won't take
> > much work to port/rewrite our driver to fit into iommu.h API.
> 
> Ok, sounds good.
> 
> > > I also think that we should not really have separate iommu and dma-mapping
> > > interfaces, but rather have a portable way to define an iommu so that it
> > > can be used through the dma-mapping interfaces. I'm not asking you to
> > > do that as a prerequisite to merging your driver, but it may be good to
> > > keep in mind that the current situation is still lacking and that any
> > > suggestion for improving this as part of your work to support the
> > > samsung IOMMU is welcome.
> >
> > Well creating a portable iommu framework and merging it with dma-mapping interface
> > looks like a much harder (and time consuming) task. There is definitely a need for
> > it. I hope that it can be developed incrementally starting from the current iommu.h
> > and dma-mapping.h interfaces.
> 
> Yes, that is the idea. Maybe we should add it to the list things that the
> Linaro kernel working group can target for the November release?
> 
> > Please note that there might be some subtle differences
> > in the hardware that such framework must be aware. The first obvious one is the
> > hardware design. Some platform has central iommu unit, other (like Samsung Exynos4)
> > has a separate iommu unit per each device driver (this is still a simplification,
> > because a video codec device has 2 memory interfaces and 2 iommu units). Currently
> > I probably have not enough knowledge to predict the other possible issues that need
> > to be taken into account in the portable and generic iommu/dma-mapping frame-work.
> 
> The dma-mapping API can deal well with one IOMMU per device, but would
> need some tricks to work with one device that has two separate IOMMUs.

We need to investigate the internals of dma-mapping API first. Right now I know too
little in this area.
 
> I'm not very familar with the iommu API, but in the common KVM scenario,
> you need one IOMMU per device, so it should handle that just fine as well.

Well, afair there are also systems with one central iommu module, which is shared 
between devices. I have no idea how such model will fit into the dma-mapping API.
 
> > > Note that the ARM implementation of the dma-mapping.h interface currently
> > > does not support IOMMUs, but that could be changed by wrapping it
> > > using the include/asm-generic/dma-mapping-common.h infrastructure.
> >
> > ARM dma-mapping framework also requires some additional research for better DMA
> > support (there are still issues with multiple mappings to be resolved).
> 
> You mean mapping the same memory into multiple devices, or a different problem?

Mapping the same memory area multiple times with different cache settings is not
legal on ARMv7+ systems. Currently the problems might caused by the low-memory
kernel linear mapping and second mapping created for example by dma_alloc_coherent()
function.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


