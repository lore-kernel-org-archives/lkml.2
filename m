Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1AJP7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:59:06 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:31138 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752529Ab1AJP7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:59:04 -0500
Message-ID: <4D2B2CC1.2050203@shipmail.org>
Date: Mon, 10 Jan 2011 16:58:57 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com> <4D2B16F3.1070105@shipmail.org> <20110110152135.GA9732@dumpdata.com>
In-Reply-To: <20110110152135.GA9732@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 04:21 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 10, 2011 at 03:25:55PM +0100, Thomas Hellstrom wrote:
>    
>> Konrad,
>>
>> Before looking further into the patch series, I need to make sure
>> I've completely understood the problem and why you've chosen this
>> solution: Please see inline.
>>      
> Of course.
>
> .. snip ..
>    
>>> The problem above can be easily reproduced on bare-metal if you pass in
>>> "swiotlb=force iommu=soft".
>>>
>>>        
>> At a first glance, this would seem to be a driver error since the
>> drivers are not calling pci_page_sync(), however I understand that
>> the TTM infrastructure and desire to avoid bounce buffers add more
>> implications to this...
>>      
> <nods>
>    
>>      
>>> There are two ways of fixing this:
>>>
>>>   1). Use the 'dma_alloc_coherent' (or pci_alloc_consistent if there is
>>>       struct pcidev present), instead of alloc_page for GFP_DMA32. The
>>>       'dma_alloc_coherent' guarantees that the allocated page fits
>>>       within the device dma_mask (or uses the default DMA32 if no device
>>>       is passed in). This also guarantees that any subsequent call
>>>       to the PCI API for this page will return the same DMA (bus) address
>>>       as the first call (so pci_alloc_consistent, and then pci_map_page
>>>       will give the same DMA bus address).
>>>        
>>
>> I guess dma_alloc_coherent() will allocate *real* DMA32 pages? that
>> brings up a couple of questions:
>> 1) Is it possible to change caching policy on pages allocated using
>> dma_alloc_coherent?
>>      
> Yes. They are the same "form-factor" as any normal page, except
> that the IOMMU makes extra efforts to set this page up.
>
>    
>> 2) What about accounting? In a *non-Xen* environment, will the
>> number of coherent pages be less than the number of DMA32 pages, or
>> will dma_alloc_coherent just translate into a alloc_page(GFP_DMA32)?
>>      
> The code in the IOMMUs end up calling __get_free_pages, which ends up
> in alloc_pages. So the call doe ends up in alloc_page(flags).
>
>
> native SWIOTLB (so no IOMMU): GFP_DMA32
> GART (AMD's old IOMMU): GFP_DMA32:
>
> For the hardware IOMMUs:
>
> AMD VI: if it is in Passthrough mode, it calls it with GFP_DMA32.
>     If it is in DMA translation mode (normal mode) it allocates a page
>     with GFP_ZERO | ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32) and immediately
>     translates the bus address.
>
> The flags change a bit:
> VT-d: if there is no identity mapping, nor the PCI device is one of the special ones
>     (GFX, Azalia), then it will pass it with GFP_DMA32.
>     If it is in identity mapping state, and the device is a GFX or Azalia sound
>     card, then it will ~(__GFP_DMA | GFP_DMA32) and immediately translate
>     the buss address.
>
> However, the interesting thing is that I've passed in the 'NULL' as
> the struct device (not intentionally - did not want to add more changes
> to the API) so all of the IOMMUs end up doing GFP_DMA32.
>
> But it does mess up the accounting with the AMD-VI and VT-D as they strip
> of the __GFP_DMA32 flag off. That is a big problem, I presume?
>    

Actually, I don't think it's a big problem. TTM allows a small 
discrepancy between allocated pages and accounted pages to be able to 
account on actual allocation result. IIRC, This means that a DMA32 page 
will always be accounted as such, or at least we can make it behave that 
way. As long as the device can always handle the page, we should be fine.

>    
>> 3) Same as above, but in a Xen environment, what will stop multiple
>> guests to exhaust the coherent pages? It seems that the TTM
>> accounting mechanisms will no longer be valid unless the number of
>> available coherent pages are split across the guests?
>>      
> Say I pass in four ATI Radeon cards (wherein each is a 32-bit card) to
> four guests. Lets also assume that we are doing heavy operations in all
> of the guests.  Since there are no communication between each TTM
> accounting in each guest you could end up eating all of the 4GB physical
> memory that is available to each guest. It could end up that the first
> guess gets a lion share of the 4GB memory, while the other ones are
> less so.
>
> And if one was to do that on baremetal, with four ATI Radeon cards, the
> TTM accounting mechanism would realize it is nearing the watermark
> and do.. something, right? What would it do actually?
>
> I think the error path would be the same in both cases?
>    

Not really. The really dangerous situation is if TTM is allowed to 
exhaust all GFP_KERNEL memory. Then any application or kernel task might 
fail with an OOM, so TTM doesn't really allow that to happen *). Within 
a Xen guest OS using this patch that won't happen either, but TTM itself 
may receive unexpected allocation failures, since the amount of 
GFP_DMA32 memory TTM thinks is available is larger than actually available.
It is possible to trigger such allocation failures on bare metal as 
well, but they'd be much less likely. Those errors should result in 
application OOM errors with a possible application crash.
Anyway it's possible to adjust TTM's memory limits using sysfs (even on 
the fly) so any advanced user should be able to do that.

What *might* be possible, however, is that the GFP_KERNEL memory on the 
host gets exhausted due to extensive TTM allocations in the guest, but I 
guess that's a problem for XEN to resolve, not TTM.

>    
>>      
>>>   2). Use the pci_sync_range_* after sending a page to the graphics
>>>       engine. If the bounce buffer is used then we end up copying the
>>>       pages.
>>>        
>> Is the reason for choosing 1) instead of 2) purely a performance concern?
>>      
> Yes, and also not understanding where I should insert the pci_sync_range
> calls in the drivers.
>
>    
>>
>> Finally, I wanted to ask why we need to pass / store the dma address
>> of the TTM pages? Isn't it possible to just call into the DMA / PCI
>> api to obtain it, and the coherent allocation will make sure it
>> doesn't change?
>>      
> It won't change, but you need the dma address during de-allocation:
> dma_free_coherent..
>    

Isn't there a quick way to determine the DMA address from the struct 
page pointer, or would that require an explicit dma_map() operation?

/Thomas

*) I think gem's flink still is vulnerable to this, though, so it 
affects Nvidia and Radeon.
