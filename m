Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1AJUuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:50:13 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:51037 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528Ab1AJUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:50:11 -0500
Message-ID: <4D2B70FB.3000504@shipmail.org>
Date: Mon, 10 Jan 2011 21:50:03 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com> <4D2B16F3.1070105@shipmail.org> <20110110152135.GA9732@dumpdata.com> <4D2B2CC1.2050203@shipmail.org> <20110110164519.GA27066@dumpdata.com>
In-Reply-To: <20110110164519.GA27066@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 05:45 PM, Konrad Rzeszutek Wilk wrote:
> . snip ..
>    
>>>> 2) What about accounting? In a *non-Xen* environment, will the
>>>> number of coherent pages be less than the number of DMA32 pages, or
>>>> will dma_alloc_coherent just translate into a alloc_page(GFP_DMA32)?
>>>>          
>>> The code in the IOMMUs end up calling __get_free_pages, which ends up
>>> in alloc_pages. So the call doe ends up in alloc_page(flags).
>>>
>>>
>>> native SWIOTLB (so no IOMMU): GFP_DMA32
>>> GART (AMD's old IOMMU): GFP_DMA32:
>>>
>>> For the hardware IOMMUs:
>>>
>>> AMD VI: if it is in Passthrough mode, it calls it with GFP_DMA32.
>>>     If it is in DMA translation mode (normal mode) it allocates a page
>>>     with GFP_ZERO | ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32) and immediately
>>>     translates the bus address.
>>>
>>> The flags change a bit:
>>> VT-d: if there is no identity mapping, nor the PCI device is one of the special ones
>>>     (GFX, Azalia), then it will pass it with GFP_DMA32.
>>>     If it is in identity mapping state, and the device is a GFX or Azalia sound
>>>     card, then it will ~(__GFP_DMA | GFP_DMA32) and immediately translate
>>>     the buss address.
>>>
>>> However, the interesting thing is that I've passed in the 'NULL' as
>>> the struct device (not intentionally - did not want to add more changes
>>> to the API) so all of the IOMMUs end up doing GFP_DMA32.
>>>
>>> But it does mess up the accounting with the AMD-VI and VT-D as they strip
>>> of the __GFP_DMA32 flag off. That is a big problem, I presume?
>>>        
>> Actually, I don't think it's a big problem. TTM allows a small
>> discrepancy between allocated pages and accounted pages to be able
>> to account on actual allocation result. IIRC, This means that a
>> DMA32 page will always be accounted as such, or at least we can make
>> it behave that way. As long as the device can always handle the
>> page, we should be fine.
>>      
> Excellent.
>    
>>      
>>>> 3) Same as above, but in a Xen environment, what will stop multiple
>>>> guests to exhaust the coherent pages? It seems that the TTM
>>>> accounting mechanisms will no longer be valid unless the number of
>>>> available coherent pages are split across the guests?
>>>>          
>>> Say I pass in four ATI Radeon cards (wherein each is a 32-bit card) to
>>> four guests. Lets also assume that we are doing heavy operations in all
>>> of the guests.  Since there are no communication between each TTM
>>> accounting in each guest you could end up eating all of the 4GB physical
>>> memory that is available to each guest. It could end up that the first
>>> guess gets a lion share of the 4GB memory, while the other ones are
>>> less so.
>>>
>>> And if one was to do that on baremetal, with four ATI Radeon cards, the
>>> TTM accounting mechanism would realize it is nearing the watermark
>>> and do.. something, right? What would it do actually?
>>>
>>> I think the error path would be the same in both cases?
>>>        
>> Not really. The really dangerous situation is if TTM is allowed to
>> exhaust all GFP_KERNEL memory. Then any application or kernel task
>>      
> Ok, since GFP_KERNEL does not contain the GFP_DMA32 flag then
> this should be OK?
>    

No, Unless I miss something, on a machine with 4GB or less, GFP_DMA32 
and GFP_KERNEL are allocated from the same pool of pages?

>
>> What *might* be possible, however, is that the GFP_KERNEL memory on
>> the host gets exhausted due to extensive TTM allocations in the
>> guest, but I guess that's a problem for XEN to resolve, not TTM.
>>      
> Hmm. I think I am missing something here. The GFP_KERNEL is any memory
> and the GFP_DMA32 is memory from the ZONE_DMA32. When we do start
> using the PCI-API, what happens underneath (so under Linux) is that
> "real PFNs" (Machine Frame Numbers) which are above the 0x100000 mark
> get swizzled in for the guest's PFNs (this is for the PCI devices
> that have the dma_mask set to 32bit). However, that is a Xen MMU
> accounting issue.
>    


So I was under the impression that when you allocate coherent memory in 
the guest, the physical page comes from DMA32 memory in the host. On a 
4GB machine or less, that would be the same as kernel memory. Now, if 4 
guests think they can allocate 2GB of coherent memory each, you might 
run out of kernel memory on the host?


Another thing that I was thinking of is what happens if you have a huge 
gart and allocate a lot of coherent memory. Could that potentially 
exhaust IOMMU resources?

>> /Thomas
>>
>> *) I think gem's flink still is vulnerable to this, though, so it
>>      
> Is there a good test-case for this?
>    


Not put in code. What you can do (for example in an openGL app) is to 
write some code that tries to flink with a guessed bo name until it 
succeeds. Then repeatedly from within the app, try to flink the same 
name until something crashes. I don't think the linux OOM killer can 
handle that situation. Should be fairly easy to put together.

/Thomas

