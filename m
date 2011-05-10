Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1EJHmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:42:31 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32951 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1EJHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:42:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Date: Tue, 10 May 2011 09:42:18 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Generic dma_ops using iommu-api - some thoughts
In-reply-to: <20110509132439.GC19909@8bytes.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        David Woodhouse <dwmw2@infradead.org>,
        Muli Ben-Yehuda <muli@il.ibm.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4DC8EC5A.7000006@samsung.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; pl; rv:1.9.2.17)
 Gecko/20110414 Thunderbird/3.1.10
References: <20110509132439.GC19909@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-09 15:24, Joerg Roedel wrote:
> Hi,
>
> as promised here is a write-up of my thoughts about implementing generic
> dma_ops on-top of the IOMMU-API and what is required for that. I am
> pretty sure I forgot some people on the Cc-list, so if anybody is
> missing feel free to add her/him.
>
> All kinds of useful comments appreciated, too :-)

Thanks for starting the discussion!

> Okay, here is the text:
>
> Some Thoughts About a Generic DMA-API Implemention Using IOMMU-API
> =======================================================================
>
> This document describes some ideas about a generic implementation for
> the DMA-API which only uses the IOMMU-API as its backend. Many IOMMU
> drivers for Linux exist and they all implement their own implementation
> for the DMA-API. A generic implementation would allow to put all
> hardware specifics into the IOMMU-API and factor out the common code.
>
> Types of IOMMUs
> -----------------------------------------------------------------------
>
> Most IOMMUs around fit in one of two categories:
>
> Type 1: I call these GART-like IOMMUs. These IOMMUs provide an aperture
>          range which can be remapped by a page-table (often single-level)
> 	This type of IOMMU exists on different architectures and there
> 	are also multiple hardware variants of them on the same
> 	architecture.
> 	These IOMMUs have no or only limited support for
> 	device-isolation. The different hardware implementations vary in
> 	some side-parameters like the size of the aperture and whether
> 	devices are allowed to use addresses outside of the aperture.
>
> Type 2: Full-isolation capable IOMMUs. There are only two of them known
>          to me: VT-d and AMD-Vi. These IOMMUs support a full 64 bit
> 	device address space and have support for full-isolation. This
> 	means that they can configure a seperate address space for each
> 	device.
> 	These IOMMUs may also have support for Interrupt remapping. But
> 	this feature is not subject of the IOMMU-API.
I think that most IOMMUs on SoC can be also put into the type 2 
cathegory, at least the one that I'm working with fits there.

> Differences between DMA-API and IOMMU-API
> -----------------------------------------------------------------------
>
> The difference between these two APIs is basically the scope. The
> IOMMU-API only cares about address remapping for devices. This proposal
> does not intend to change that.
> The scope of the DMA-API is to provide dma handles for device drivers
> and to maintain the coherency between device and cpu view of memory. So
> the scope of the DMA-API is much larger. From an implementation pov it
> looks like that:
>
> 	IOMMU-API<-------------------- DMA-API
> 	(hardare access and		(implements address allocator
> 	 remapping setup)		 and maintains cache coherency)
>
> The IOMMU-API
> -----------------------------------------------------------------------
>
> The API to support IOMMUs does only handle type 2. This was sufficient
> when the IOMMU-API was introduced because the only reason was to provide
> device-passthrough support for KVM.
> When we want to write a a DMA-API layer on-top of that API is makes a
> lot of sense to extend it to type 1 because most IOMMUs belong to that
> type.
> Lets first look what the IOMMU-API provides today. A domain is an
> abstraction for a device address space. The most important
> data-structure there-in is the page-table.
>
> iommu_found()		All other functions can only called safely when
> 			this returns true
> iommu_domain_alloc()    Allocates a new domain
> iommu_domain_free()	Destroys a domain
> iommu_attach_device()   Put a device into a given domain
> iommu_detach_device()   Removes a device from a given domain
> iommu_map()		Maps a given system physical address to a given
> 			io virtual address in one domain
> iommu_unmap()		Removes a mapping from a domain
> iommu_iova_to_phys()    Returns physical address for a io virtual one if
> 			it exists
> iommu_domain_has_cap()	Check for IOMMU capablilities. Only used for
> 			PCIe snoop-bit forcing today
>
> Changes to the IOMMU-API
> -----------------------------------------------------------------------
>
> The current assumption about a domain is that any io virtual address can
> be mapped to any system physical address. This can not longer be assumed
> when type 1 IOMMUs are supported. The part of the io address space that
> can be remapped may be very small (ususally 64MB for an AMD NB-GART) and
> may not start at address zero. Additional function(s) are needed so that
> the DMA-API implementation can query these properties from a domain.
>
> Further it is currently undefined in which domain a device is per
> default. For supporting the DMA-API every device needs to be put into a
> default domain by the IOMMU driver. This domain is then used by the
> DMA-API code.
>
> The DMA-API manages the address allocator, so it needs to keep track of
> the allocator state for each domain. This can be solved by storing a
> private pointer into a domain.
Embedding address allocator into the iommu domain seems resonable to me. 
In my initial POC implementation of iommu for Samsung ARM platform I've 
put the default domain and address allocator directly into archdata.
> Also, the IOMMU driver may need to put multiple devices into the same
> domain. This is necessary for type 2 IOMMUs too because the hardware
> may not be able to distinguisch between all devices (so it is usually
> not possible to distinguish between different 32-bit PCI devices on the
> same bus). Support for different domains is even more limited on type 1
> IOMMUs. The AMD NB-GART supports only one domain for all devices.
> Therefore it may be helpful to find the domain associated with one
> device. This is also needed for the DMA-API to get a pointer to the
> default domain for each device.
I wonder if the device's default domain is really a property of the 
IOMMU driver. IMHO it is more related to the specific architecture 
configuration rather the iommu chip itself, especially in the embedded 
world. On Samsung Exynos4 platform we have separate iommu blocks for 
each multimedia device block. The iommu controllers are exactly the 
same, but the multimedia device they controll have different memory 
requirements in therms of supported address space limits or alignment. 
That's why I would prefer to put device's default iommu domain (with 
address space allocator and restrictions) to dev->archdata instead of 
extending iommu api.

> With these changes I think we can handle type 1 and 2 IOMMUs in the
> IOMMU-API and use it as a basis for the DMA-API. The IOMMU driver
> provides a default domain which contains an aperture where addresses can
> be remapped. Type 2 IOMMUs can provide apertures that cover the whole
> address space or emulate a type 1 IOMMU by providing a smaller aperture.
> The IOMMU driver also provides the capabilities of the aperture like if
> it is possible to use addresses outside of the aperture directly.
Right.
> DMA-API Considerations
> -----------------------------------------------------------------------
>
> The question here is which address allocator should be implemented.
> Almost all IOMMU drivers today implement a bitmap based allocator. This
> one has advantages because it is very simple, has proven existing code
> which can be reused and allows neat optimizations in IOMMU TLB flushing.
> Flushing the TLB of an IOMMU is usually an expensive operation.
>
> On the other hand the bitmap allocator does not scale very well with the
> size of the remapable area. Therefore the VT-d driver implements a
> tree-based allocator which can handle a large address space efficiently,
> but does not allow to optimize IO/TLB flushing.
How IO/TLB flush operation can be optimized with bitmap-based allocator? 
Creating a bitmap for the whole 32-bit area (4GiB) is a waste of memory 
imho, but with so large address space the size of a bitmap can be 
reduced by using lower granularity than a page size - for example 64KiB, 
what will reduce the size of the bitmap by 16 times.
> It remains to be determined which allocator algortihm fits best.
Bitmap allocators usually use first fit algorithm. IMHO the allocation 
algorithm matters only if the address space size is small (like the GART 
case), in other cases there is usually not enough memory in the system 
to cause so much fragmentation of the virtual address space.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


