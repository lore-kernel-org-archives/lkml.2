Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1CKPPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:15:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1CKPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:15:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Fri, 11 Mar 2011 16:15:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        kgene.kim@samsung.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        " =?euc-kr?q?=27=B4=EB=C0=CE=B1=E2=27?=" <inki.dae@samsung.com>,
        " =?euc-kr?q?=27=B0=AD=B9=CE=B1=D4=27?=" <mk7.kang@samsung.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>, linux-kernel@vger.kernel.org
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com> <201103111507.59825.arnd@arndb.de> <000101cbdffb$e1844b00$a48ce100$%szyprowski@samsung.com>
In-Reply-To: <000101cbdffb$e1844b00$a48ce100$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111615.01829.arnd@arndb.de>
X-Provags-ID: V02:K0:6yGSCcxMFCT3TTg76rSE3Btgq6rLVpmZd8zJfdZMl9I
 xHie/0vMF6Yw+ZKq/gMWK+uTfTz7RHAhahpfR+XTmMoACf485j
 LZ2qnokdjtxMtDDzSlHaRyIxJvEbOaH7jrfTQcPhOiGeYBHesN
 JtqD4y7LLmEnUey6XK23sebusxhcZFadhHnHiEs75+hpXHa7Zw
 NMFL/0wGkCUr5lC6xiRHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Marek Szyprowski wrote:
> On Friday, March 11, 2011 3:08 PM Arnd Bergmann wrote:
> 
> > On Friday 11 March 2011, Marek Szyprowski wrote:
> > > > The iommu API is not really meant to be KVM specific, it's just that the
> > > > in-tree users are basically limited to KVM at the moment. Another user that
> > > > is coming up soon is the vmio device driver that can be used to transparently
> > > > pass devices to user space. The idea behind the IOMMU API is that you can
> > > > map arbitrary bus addresses to physical memory addresses, but it does not
> > > > deal with allocating the bus addresses or providing buffer management such
> > > > as cache flushes.
> > >
> > > Yea, I've noticed this and this basically what we expect from iommu driver.
> > > However the iommu.h API requires a separate call to map each single memory page.
> > > This is quite ineffective approach and imho the API need to be extended to allow
> > > mapping of the arbitrary set of pages.
> > 
> > We can always discuss extensions to the existing infrastructure, adding
> > an interface for mapping an array of page pointers in the iommu API
> > sounds like a good idea.
> 
> We will investigate this API further. From the first sight it looks it won't take
> much work to port/rewrite our driver to fit into iommu.h API.

Ok, sounds good.

> > I also think that we should not really have separate iommu and dma-mapping
> > interfaces, but rather have a portable way to define an iommu so that it
> > can be used through the dma-mapping interfaces. I'm not asking you to
> > do that as a prerequisite to merging your driver, but it may be good to
> > keep in mind that the current situation is still lacking and that any
> > suggestion for improving this as part of your work to support the
> > samsung IOMMU is welcome.
> 
> Well creating a portable iommu framework and merging it with dma-mapping interface
> looks like a much harder (and time consuming) task. There is definitely a need for
> it. I hope that it can be developed incrementally starting from the current iommu.h
> and dma-mapping.h interfaces.

Yes, that is the idea. Maybe we should add it to the list things that the
Linaro kernel working group can target for the November release?

> Please note that there might be some subtle differences
> in the hardware that such framework must be aware. The first obvious one is the
> hardware design. Some platform has central iommu unit, other (like Samsung Exynos4)
> has a separate iommu unit per each device driver (this is still a simplification,
> because a video codec device has 2 memory interfaces and 2 iommu units). Currently
> I probably have not enough knowledge to predict the other possible issues that need
> to be taken into account in the portable and generic iommu/dma-mapping frame-work.

The dma-mapping API can deal well with one IOMMU per device, but would
need some tricks to work with one device that has two separate IOMMUs.

I'm not very familar with the iommu API, but in the common KVM scenario,
you need one IOMMU per device, so it should handle that just fine as well.

> > Note that the ARM implementation of the dma-mapping.h interface currently
> > does not support IOMMUs, but that could be changed by wrapping it
> > using the include/asm-generic/dma-mapping-common.h infrastructure.
> 
> ARM dma-mapping framework also requires some additional research for better DMA
> support (there are still issues with multiple mappings to be resolved).

You mean mapping the same memory into multiple devices, or a different problem?

	Arnd
