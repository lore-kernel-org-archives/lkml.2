Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1AJO0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:26:06 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:60742 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752994Ab1AJO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:26:03 -0500
Message-ID: <4D2B16F3.1070105@shipmail.org>
Date: Mon, 10 Jan 2011 15:25:55 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

Before looking further into the patch series, I need to make sure I've 
completely understood the problem and why you've chosen this solution: 
Please see inline.

On 01/07/2011 06:11 PM, Konrad Rzeszutek Wilk wrote:
> Attached is a set of patches that make it possible for drivers using TTM API
> (nouveau and radeon graphic drivers) to work under Xen. The explanation
> is a bit complex and I am not sure if I am explaining it that well..so if
> something is unclear please do ping me.
>
> Changes since v1: [https://lkml.org/lkml/2010/12/6/516]
>   - Cleaned up commit message (forgot to add my SoB).
>
> Short explanation of problem: What we are hitting under Xen is that instead
> of programming the GART with the physical DMA address of the TTM page, we
> end up programming the bounce buffer DMA (bus) address!
>
> Long explanation:
> The reason we end up doing this is that:
>
>   1). alloc_page with GFP_DMA32 does not allocate "real" (Machine Frame Numbers
>       - MFN) under the 4GB in Xen. That is b/c if actually made the pages underneath
>       4GB available to the the Linux page allocator we would not be able to
>       give those to other guest devices. This would mean if we tried to pass
>       in a USB device to one guest and in another were running the Xorg server
>       we wouldn't be able to do so as we would run out of pages under 4GB. So
>       pages that we get from alloc_page have a PFN that is under 4GB but in
>       reality the real physical address (MFN) is above 4GB. Ugh..
>    
>   2). The backends for "struct ttm_backend_func" utilize the PCI API. When
>       they get a page allocated via alloc_page, the use 'pci_map_page' and
>       program the DMA (bus) address in the GART - which is correct. But then
>       the calls that kick off the graphic driver to process the pages do not
>       use the pci_page_sync_* calls. If the physical address of the page
>       is the same as the DMA bus address returned from pci_map_page then there
>       are no trouble. But if they are different:
> 	virt_to_phys(page_address(p)) != pci_map_page(p,..)
>       then the graphic card fetches data from the DMA (bus) address (so the
>       value returned from pci_map_page). The data however that the user wrote
>       to (the page p) ends up being untouched. You are probably saying:
>       "What? Nonsense, we stitch the page in ttm_bo_vm_fault using the PFN
>       and .. and even if the virt_to_phys(page_address(p)) != pci_map_page(p)
>       the GART ends up with the bus (DMA) address of the PFN!" That is true.
>       But if you combine this with 1) where you end up with page that is
>       above the dma_mask (even if you called it with GFP_DMA32) and then
>       make a call on pci_map_page you would end up with a bounce buffer!
>
>
> The problem above can be easily reproduced on bare-metal if you pass in
> "swiotlb=force iommu=soft".
>
>    

At a first glance, this would seem to be a driver error since the 
drivers are not calling pci_page_sync(), however I understand that the 
TTM infrastructure and desire to avoid bounce buffers add more 
implications to this...

> There are two ways of fixing this:
>
>   1). Use the 'dma_alloc_coherent' (or pci_alloc_consistent if there is
>       struct pcidev present), instead of alloc_page for GFP_DMA32. The
>       'dma_alloc_coherent' guarantees that the allocated page fits
>       within the device dma_mask (or uses the default DMA32 if no device
>       is passed in). This also guarantees that any subsequent call
>       to the PCI API for this page will return the same DMA (bus) address
>       as the first call (so pci_alloc_consistent, and then pci_map_page
>       will give the same DMA bus address).
>    


I guess dma_alloc_coherent() will allocate *real* DMA32 pages? that 
brings up a couple of questions:
1) Is it possible to change caching policy on pages allocated using 
dma_alloc_coherent?
2) What about accounting? In a *non-Xen* environment, will the number of 
coherent pages be less than the number of DMA32 pages, or will 
dma_alloc_coherent just translate into a alloc_page(GFP_DMA32)?
3) Same as above, but in a Xen environment, what will stop multiple 
guests to exhaust the coherent pages? It seems that the TTM accounting 
mechanisms will no longer be valid unless the number of available 
coherent pages are split across the guests?

>   2). Use the pci_sync_range_* after sending a page to the graphics
>       engine. If the bounce buffer is used then we end up copying the
>       pages.
>    

Is the reason for choosing 1) instead of 2) purely a performance concern?


Finally, I wanted to ask why we need to pass / store the dma address of 
the TTM pages? Isn't it possible to just call into the DMA / PCI api to 
obtain it, and the coherent allocation will make sure it doesn't change?


Thanks,
Thomas

