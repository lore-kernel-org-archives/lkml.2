Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1KXMxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 07:53:43 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11650 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1KXMxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 07:53:41 -0500
Date: Thu, 24 Nov 2011 13:52:33 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Changing IOMMU-API for generic DMA-mapping supported by the
 hardware
In-reply-to: <20111111131728.GG13213@amd.com>
To: "'Joerg Roedel'" <Joerg.Roedel@amd.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>
Cc: "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'KyongHo Cho'" <pullip.cho@samsung.com>,
        "'Kai Huang'" <mail.kai.huang@gmail.com>, kvm@vger.kernel.org,
        "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'David Brown'" <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        "'Stepan Moskovchenko'" <stepanm@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Message-id: <023b01ccaaa7$ef16c910$cd445b30$%szyprowski@samsung.com>
Organization: SPRC
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcygdnNsx6UCTaAXT6Cec5Yhzvb/FAKLFQKw
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <1320938930.22195.17.camel@i7.infradead.org> <20111110170918.GE13213@amd.com>
 <1320953319.535.11.camel@i7.infradead.org> <20111111131728.GG13213@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, November 11, 2011 2:17 PM Joerg Roedel wrote:

> Okay, seperate thread for this one.

If possible, I would like to be CCed: in the next mails in this topic. 

For a last few months I've been working on DMA-mapping changes on ARM
architecture in order to add support for IOMMU-aware DMA mapper. The
last version of my patches are available here:
http://lists.linaro.org/pipermail/linaro-mm-sig/2011-October/000745.html

The next version will be posted soon.
 
> On Thu, Nov 10, 2011 at 07:28:39PM +0000, David Woodhouse wrote:
> > > The plan is to have a single DMA-API implementation for all IOMMU
> > > drivers (X86 and ARM) which just uses the IOMMU-API. But to make this
> > > performing reasonalbly well a few changes to the IOMMU-API are required.
> > > I already have some ideas which we can discuss if you want.
> >
> > Yeah, that sounds useful.
> 
> As I said some changes to the IOMMU-API are required in my opinion.
> These changes should also allow it to move over old-style IOMMUs like
> Calgary or GART later.
> 
> The basic idea is that IOMMU drivers should be required to put every
> device they are responsible for into a default domain. The DMA mapping
> code can query this default domain for each device.

Good idea.
 
> Also the default domain has capabilities that can be queried. Those
> capabilities include the size and offset of the address space they can
> re-map. For GART and Calgary this will be the aperture, for VT-d and AMD
> IOMMU the whole 64bit address space. Another capability is whether
> addresses outside of that area are 1-1 mapped or no accessible to the
> device.
>
> The generic DMA-mapping code will use that information to initialize its
> allocator and uses iommu_map/iommu_unmap to create and destroy mappings
> as requested by the DMA-API (but the DMA-mapping code does not need to
> create a domain of its own).
> 
> The good thing about these default domains is that IOMMU drivers can
> implement their own optimizations on it. The AMD IOMMU driver for
> example already makes a distinction between dma-mapping domains and
> other protection-domains. The optimization for dma-mapping domains is
> that the leaf-pages of the page-table are keept in an array so that it
> is very easy to find the PTE for an address. Those optimizations are
> still possible with the default-domain concept.
> 
> In short, the benefits of the default-domain concept are:
> 
> 	1) It allows existing optimizations for the DMA-mapping code
> 	   paths to persist
> 	2) It also fits old-style IOMMUs like GART, Calgary and others
> 
> An open problem is how to report reserved ranges of an address-space.
> These ranges might exist from a BIOS requirement for 1-1 mapping of
> certain address ranges (in AMD jargon: Unity mapped ranges, something
> similar exists on VT-d afaik) or hardware requirements like the reserved
> address range used for MSI interrupts.

In my DMA-mapping IOMMU integration I've used a dma_iommu_mapping structure,
which contains a pointer to iommu domain, a bitmap and a lock. Maybe we 
should consider extending iommu domain with allocation bitmap (or other 
structure that hold information about used/unused iova ranges)? From the
DMA-mapping (as a IOMMU client) perspective we only need 2 more callbacks
in IOMMU API: alloc_iova_range() and free_iova_range(). 

Each IOMMU implementation can provide these calls based on internal bitmap
allocator which will also cover the issue with reserved ranges. What do you
think about such solution?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



