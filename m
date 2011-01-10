Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1AJQrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:47:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24605 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1AJQr3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 11:47:29 -0500
Date: Mon, 10 Jan 2011 11:45:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
Message-ID: <20110110164519.GA27066@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <4D2B16F3.1070105@shipmail.org>
 <20110110152135.GA9732@dumpdata.com>
 <4D2B2CC1.2050203@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B2CC1.2050203@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. snip ..
> >>2) What about accounting? In a *non-Xen* environment, will the
> >>number of coherent pages be less than the number of DMA32 pages, or
> >>will dma_alloc_coherent just translate into a alloc_page(GFP_DMA32)?
> >The code in the IOMMUs end up calling __get_free_pages, which ends up
> >in alloc_pages. So the call doe ends up in alloc_page(flags).
> >
> >
> >native SWIOTLB (so no IOMMU): GFP_DMA32
> >GART (AMD's old IOMMU): GFP_DMA32:
> >
> >For the hardware IOMMUs:
> >
> >AMD VI: if it is in Passthrough mode, it calls it with GFP_DMA32.
> >    If it is in DMA translation mode (normal mode) it allocates a page
> >    with GFP_ZERO | ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32) and immediately
> >    translates the bus address.
> >
> >The flags change a bit:
> >VT-d: if there is no identity mapping, nor the PCI device is one of the special ones
> >    (GFX, Azalia), then it will pass it with GFP_DMA32.
> >    If it is in identity mapping state, and the device is a GFX or Azalia sound
> >    card, then it will ~(__GFP_DMA | GFP_DMA32) and immediately translate
> >    the buss address.
> >
> >However, the interesting thing is that I've passed in the 'NULL' as
> >the struct device (not intentionally - did not want to add more changes
> >to the API) so all of the IOMMUs end up doing GFP_DMA32.
> >
> >But it does mess up the accounting with the AMD-VI and VT-D as they strip
> >of the __GFP_DMA32 flag off. That is a big problem, I presume?
> 
> Actually, I don't think it's a big problem. TTM allows a small
> discrepancy between allocated pages and accounted pages to be able
> to account on actual allocation result. IIRC, This means that a
> DMA32 page will always be accounted as such, or at least we can make
> it behave that way. As long as the device can always handle the
> page, we should be fine.

Excellent.
> 
> >>3) Same as above, but in a Xen environment, what will stop multiple
> >>guests to exhaust the coherent pages? It seems that the TTM
> >>accounting mechanisms will no longer be valid unless the number of
> >>available coherent pages are split across the guests?
> >Say I pass in four ATI Radeon cards (wherein each is a 32-bit card) to
> >four guests. Lets also assume that we are doing heavy operations in all
> >of the guests.  Since there are no communication between each TTM
> >accounting in each guest you could end up eating all of the 4GB physical
> >memory that is available to each guest. It could end up that the first
> >guess gets a lion share of the 4GB memory, while the other ones are
> >less so.
> >
> >And if one was to do that on baremetal, with four ATI Radeon cards, the
> >TTM accounting mechanism would realize it is nearing the watermark
> >and do.. something, right? What would it do actually?
> >
> >I think the error path would be the same in both cases?
> 
> Not really. The really dangerous situation is if TTM is allowed to
> exhaust all GFP_KERNEL memory. Then any application or kernel task

Ok, since GFP_KERNEL does not contain the GFP_DMA32 flag then
this should be OK?

> might fail with an OOM, so TTM doesn't really allow that to happen
> *). Within a Xen guest OS using this patch that won't happen either,
> but TTM itself may receive unexpected allocation failures, since the
> amount of GFP_DMA32 memory TTM thinks is available is larger than
> actually available.

Ooooh, perfect opportunity to test the error paths then :-)

> It is possible to trigger such allocation failures on bare metal as
> well, but they'd be much less likely. Those errors should result in
> application OOM errors with a possible application crash.
> Anyway it's possible to adjust TTM's memory limits using sysfs (even
> on the fly) so any advanced user should be able to do that.
> 
> What *might* be possible, however, is that the GFP_KERNEL memory on
> the host gets exhausted due to extensive TTM allocations in the
> guest, but I guess that's a problem for XEN to resolve, not TTM.

Hmm. I think I am missing something here. The GFP_KERNEL is any memory
and the GFP_DMA32 is memory from the ZONE_DMA32. When we do start
using the PCI-API, what happens underneath (so under Linux) is that
"real PFNs" (Machine Frame Numbers) which are above the 0x100000 mark
get swizzled in for the guest's PFNs (this is for the PCI devices
that have the dma_mask set to 32bit). However, that is a Xen MMU
accounting issue.

The GFP_KERNEL memory on the other hand does not get the same treatment,
so whichever MFNs were allocated for that memory are still the same.

The amount of memory in the guest during the treatment that the PCI API does
when running under Xen remains the same. The PFNs, the zone's, etc
are all the same. It is just that when you program the PTE's or
pass in the (DMA) bus address to the devices, the numbers are different
from what a 'virt_to_phys' call would return.

.. snip..
> >>Finally, I wanted to ask why we need to pass / store the dma address
> >>of the TTM pages? Isn't it possible to just call into the DMA / PCI
> >>api to obtain it, and the coherent allocation will make sure it
> >>doesn't change?
> >It won't change, but you need the dma address during de-allocation:
> >dma_free_coherent..
> 
> Isn't there a quick way to determine the DMA address from the struct

Sadly no. You need to squirrel it away.
> page pointer, or would that require an explicit dma_map() operation?

<nods> The DMA API only offers two ways to get the (DMA) bus address.

The first is the 'dma_alloc_coherent' (pci_create_coherent) and the other
is the 'dma_map_page' (or pci_map_page). Both calls return the DMA address
and there is no "translate this virtual address to a DMA address please
API call."

One way to potentially not carry this dma address around is in the
de-alloc path do this:

  dma_addr_t _d = pci_map_page(...);
  pci_unmap_page(..);
  dma_free_coherent(_d, ... )

which would be one way of avoiding carrying around the dma_addr_t
array.

> 
> /Thomas
> 
> *) I think gem's flink still is vulnerable to this, though, so it

Is there a good test-case for this?

> affects Nvidia and Radeon.
