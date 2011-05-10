Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1EJNH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:07:58 -0400
Received: from 8bytes.org ([88.198.83.132]:34623 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1EJNH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:07:56 -0400
Date: Tue, 10 May 2011 15:07:55 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        David Woodhouse <dwmw2@infradead.org>,
        Muli Ben-Yehuda <muli@il.ibm.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC] Generic dma_ops using iommu-api - some thoughts
Message-ID: <20110510130755.GD19909@8bytes.org>
References: <20110509132439.GC19909@8bytes.org> <4DC8EC5A.7000006@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC8EC5A.7000006@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 09:42:18AM +0200, Marek Szyprowski wrote:
> On 2011-05-09 15:24, Joerg Roedel wrote:

>> Type 2: Full-isolation capable IOMMUs. There are only two of them known
>>          to me: VT-d and AMD-Vi. These IOMMUs support a full 64 bit
>> 	device address space and have support for full-isolation. This
>> 	means that they can configure a seperate address space for each
>> 	device.
>> 	These IOMMUs may also have support for Interrupt remapping. But
>> 	this feature is not subject of the IOMMU-API

> I think that most IOMMUs on SoC can be also put into the type 2  
> cathegory, at least the one that I'm working with fits there.

Fine, probably it turns out that we only care about type 2, good to know
that the user-base there grows.

>> The DMA-API manages the address allocator, so it needs to keep track of
>> the allocator state for each domain. This can be solved by storing a
>> private pointer into a domain.

> Embedding address allocator into the iommu domain seems resonable to me.  
> In my initial POC implementation of iommu for Samsung ARM platform I've  
> put the default domain and address allocator directly into archdata.

Seems like I was a bit unclear :) What I meant was that the IOMMU driver
is responsible for allocating a default-domain for each device and
provide that via the IOMMU-API. Storing the dev-->domain relation in
dev->archdata certainly makes sense.

>> Also, the IOMMU driver may need to put multiple devices into the same
>> domain. This is necessary for type 2 IOMMUs too because the hardware
>> may not be able to distinguisch between all devices (so it is usually
>> not possible to distinguish between different 32-bit PCI devices on the
>> same bus). Support for different domains is even more limited on type 1
>> IOMMUs. The AMD NB-GART supports only one domain for all devices.
>> Therefore it may be helpful to find the domain associated with one
>> device. This is also needed for the DMA-API to get a pointer to the
>> default domain for each device.

> I wonder if the device's default domain is really a property of the  
> IOMMU driver. IMHO it is more related to the specific architecture  
> configuration rather the iommu chip itself, especially in the embedded  
> world. On Samsung Exynos4 platform we have separate iommu blocks for  
> each multimedia device block. The iommu controllers are exactly the  
> same, but the multimedia device they controll have different memory  
> requirements in therms of supported address space limits or alignment.  
> That's why I would prefer to put device's default iommu domain (with  
> address space allocator and restrictions) to dev->archdata instead of  
> extending iommu api.

When the devices differ in their alignment requirements and alignment
then this is fine. Things like the dma_mask and the coherent_dma_mask
are part of the device structure anyway and a DMA-API implementation
needs to take care of them. As long as all IOMMUs look the same the
IOMMU driver can handle them. Things get more difficult if you want to
manage different types of IOMMUs at the same time. Does this requirement
exist?

>> DMA-API Considerations
>> -----------------------------------------------------------------------
>>
>> The question here is which address allocator should be implemented.
>> Almost all IOMMU drivers today implement a bitmap based allocator. This
>> one has advantages because it is very simple, has proven existing code
>> which can be reused and allows neat optimizations in IOMMU TLB flushing.
>> Flushing the TLB of an IOMMU is usually an expensive operation.
>>
>> On the other hand the bitmap allocator does not scale very well with the
>> size of the remapable area. Therefore the VT-d driver implements a
>> tree-based allocator which can handle a large address space efficiently,
>> but does not allow to optimize IO/TLB flushing.

> How IO/TLB flush operation can be optimized with bitmap-based allocator?  
> Creating a bitmap for the whole 32-bit area (4GiB) is a waste of memory  
> imho, but with so large address space the size of a bitmap can be  
> reduced by using lower granularity than a page size - for example 64KiB,  
> what will reduce the size of the bitmap by 16 times.

Interesting point. We need to make the IO-page-size part of the API. But
to answer your questions, the bitmap-allocator allows to optimize
io-tlb-flushes as follows:

The allocator needs to keep track of a next_bit field which points to
the end of the last allocation made. After every successful allocation
the next_bit pointer is increased. New alloctions start searching the
bit-field from the next_bit position instead of 0. When doing this, the
io-tlb only needs to be flushed in two cases:

	a) When next_bit wraps around, because then old mapping may be
	   reused
	b) When addresses beyond the next_bit pointer are freed

Otherwise we need to do io-tlb flushes every time we free addresses
which is more expensive.

Also, you don't need to keep a bitmap for all 4GB at the same time. The
AMD IOMMU driver also supports aperture sizes up to 4GB, but it manages
the aperture in 128MB chunks. This means that initially the aperture is
only 128MB in size. If allocation within this range fails the aperture
is exented by another 128MB chunk and so on. The aperture can grow up to
4GB. So this can be optimized too. You can have a look into the AMD
IOMMU driver which implements this (and also the optimized flushing I
explained above).

Another option is that you only emulate a 128MB aperture and direct-map
everything outside of the aperture. This brings the best performance
because you don't need to remap every time. The downside is that you
loose device isolation.

A combination of both approaches is the third option. You still have the
aperture and the direct-mapping. But instead of direct-mapping
everything in advance you just direct-map the areas the device asks
for. This gives you device-isolation back.  It still lowers pressure on
the address allocator but is certainly more expensive and more difficult
to implement (you need to reference-count mappings for example).

>> It remains to be determined which allocator algortihm fits best.

> Bitmap allocators usually use first fit algorithm. IMHO the allocation  
> algorithm matters only if the address space size is small (like the GART  
> case), in other cases there is usually not enough memory in the system  
> to cause so much fragmentation of the virtual address space.

Yes, fragmentation is not a big issue, even with smapp address spaces.
Most mappings fit into one page so that they can not cause
fragmentation.

Regards,

	Joerg

