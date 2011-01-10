Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1AJPXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:23:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46690 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1AJPXv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 10:23:51 -0500
Date: Mon, 10 Jan 2011 10:21:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
Message-ID: <20110110152135.GA9732@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <4D2B16F3.1070105@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B16F3.1070105@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 03:25:55PM +0100, Thomas Hellstrom wrote:
> Konrad,
> 
> Before looking further into the patch series, I need to make sure
> I've completely understood the problem and why you've chosen this
> solution: Please see inline.

Of course.

.. snip ..
> >The problem above can be easily reproduced on bare-metal if you pass in
> >"swiotlb=force iommu=soft".
> >
> 
> At a first glance, this would seem to be a driver error since the
> drivers are not calling pci_page_sync(), however I understand that
> the TTM infrastructure and desire to avoid bounce buffers add more
> implications to this...

<nods>
> 
> >There are two ways of fixing this:
> >
> >  1). Use the 'dma_alloc_coherent' (or pci_alloc_consistent if there is
> >      struct pcidev present), instead of alloc_page for GFP_DMA32. The
> >      'dma_alloc_coherent' guarantees that the allocated page fits
> >      within the device dma_mask (or uses the default DMA32 if no device
> >      is passed in). This also guarantees that any subsequent call
> >      to the PCI API for this page will return the same DMA (bus) address
> >      as the first call (so pci_alloc_consistent, and then pci_map_page
> >      will give the same DMA bus address).
> 
> 
> I guess dma_alloc_coherent() will allocate *real* DMA32 pages? that
> brings up a couple of questions:
> 1) Is it possible to change caching policy on pages allocated using
> dma_alloc_coherent?

Yes. They are the same "form-factor" as any normal page, except
that the IOMMU makes extra efforts to set this page up.

> 2) What about accounting? In a *non-Xen* environment, will the
> number of coherent pages be less than the number of DMA32 pages, or
> will dma_alloc_coherent just translate into a alloc_page(GFP_DMA32)?

The code in the IOMMUs end up calling __get_free_pages, which ends up
in alloc_pages. So the call doe ends up in alloc_page(flags).


native SWIOTLB (so no IOMMU): GFP_DMA32
GART (AMD's old IOMMU): GFP_DMA32:

For the hardware IOMMUs:

AMD VI: if it is in Passthrough mode, it calls it with GFP_DMA32.
   If it is in DMA translation mode (normal mode) it allocates a page
   with GFP_ZERO | ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32) and immediately
   translates the bus address.

The flags change a bit:
VT-d: if there is no identity mapping, nor the PCI device is one of the special ones
   (GFX, Azalia), then it will pass it with GFP_DMA32.
   If it is in identity mapping state, and the device is a GFX or Azalia sound
   card, then it will ~(__GFP_DMA | GFP_DMA32) and immediately translate
   the buss address.

However, the interesting thing is that I've passed in the 'NULL' as
the struct device (not intentionally - did not want to add more changes
to the API) so all of the IOMMUs end up doing GFP_DMA32.

But it does mess up the accounting with the AMD-VI and VT-D as they strip
of the __GFP_DMA32 flag off. That is a big problem, I presume?

> 3) Same as above, but in a Xen environment, what will stop multiple
> guests to exhaust the coherent pages? It seems that the TTM
> accounting mechanisms will no longer be valid unless the number of
> available coherent pages are split across the guests?

Say I pass in four ATI Radeon cards (wherein each is a 32-bit card) to
four guests. Lets also assume that we are doing heavy operations in all
of the guests.  Since there are no communication between each TTM
accounting in each guest you could end up eating all of the 4GB physical
memory that is available to each guest. It could end up that the first
guess gets a lion share of the 4GB memory, while the other ones are
less so.

And if one was to do that on baremetal, with four ATI Radeon cards, the
TTM accounting mechanism would realize it is nearing the watermark
and do.. something, right? What would it do actually?

I think the error path would be the same in both cases?

> 
> >  2). Use the pci_sync_range_* after sending a page to the graphics
> >      engine. If the bounce buffer is used then we end up copying the
> >      pages.
> 
> Is the reason for choosing 1) instead of 2) purely a performance concern?

Yes, and also not understanding where I should insert the pci_sync_range
calls in the drivers.

> 
> 
> Finally, I wanted to ask why we need to pass / store the dma address
> of the TTM pages? Isn't it possible to just call into the DMA / PCI
> api to obtain it, and the coherent allocation will make sure it
> doesn't change?

It won't change, but you need the dma address during de-allocation:
dma_free_coherent..
