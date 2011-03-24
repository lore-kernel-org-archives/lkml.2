Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab1CXHxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:53:16 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:19132 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932990Ab1CXHxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:53:14 -0400
Message-ID: <4D8AF834.8040700@shipmail.org>
Date: Thu, 24 Mar 2011 08:52:20 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be passed
 in for DMA API calls.
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com> <4D769726.2030307@shipmail.org> <20110322143137.GA25113@dumpdata.com> <4D89AB8F.6020500@shipmail.org> <20110323125105.GA6599@dumpdata.com> <4D89F2DE.7020209@shipmail.org> <20110323145246.GA7546@dumpdata.com>
In-Reply-To: <20110323145246.GA7546@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 03:52 PM, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 23, 2011 at 02:17:18PM +0100, Thomas Hellstrom wrote:
>    
>> On 03/23/2011 01:51 PM, Konrad Rzeszutek Wilk wrote:
>>      
>>>>> I was thinking about this a bit after I found that the PowerPC requires
>>>>> the 'struct dev'. But I got a question first, what do you with pages
>>>>> that were allocated to a device that can do 64-bit DMA and then
>>>>> move it to a device than can 32-bit DMA? Obviously the 32-bit card would
>>>>> set the TTM_PAGE_FLAG_DMA32 flag, but the 64-bit would not. What is the
>>>>> process then? Allocate a new page from the 32-bit device and then copy over the
>>>>> page from the 64-bit TTM and put the 64-bit TTM page?
>>>>>            
>>>> Yes, in certain situations we need to copy, and if it's necessary in
>>>> some cases to use coherent memory with a struct device assoicated
>>>> with it, I agree it may be reasonable to do a copy in that case as
>>>> well. I'm against, however, to make that the default case when
>>>> running on bare metal.
>>>>          
>>> This situation could occur on native/baremetal. When you say 'default
>>> case' you mean for every type of page without consulting whether it
>>> had the TTM_PAGE_FLAG_DMA32?
>>>        
>> No, Basically I mean a device that runs perfectly fine with
>> alloc_pages(DMA32) on bare metal shouldn't need to be using
>> dma_alloc_coherent() on bare metal, because that would mean we'd need
>> to take the copy path above.
>>      
> I think we got the scenarios confused (or I did at least).
> The scenario I used ("I was thinking.."), the 64-bit device would do
> alloc_page(GFP_HIGHUSER) and if you were to move it to a 32-bit device
> it would have to make a copy of the page as it could not reach the page
> from GFP_HIGUSER.
>
> The other scenario, which I think is what you are using, is that
> we have a 32-bit device allocating a page, so TTM_PAGE_FLAG_DMA32 is set
> and then we if we were to move it a 64-bit device it would need to
> copied. But I don't think that is the case - the page would be
> reachable by the 64-bit device. Help me out please if I am misunderstanding this.
>    

Yes, this is completely correct.

Now, with a struct dev attached to each page in a 32-bit system 
(coherent memory)
we would need to always copy in the 32-bit case, since you can't hand 
over pages
belonging to other physical devices.
But on bare metal you don't need coherent memory, but in this case you
need to copy anyway becase you choose to allocate coherent memory.

I see a sort of a hackish way around these problems.

Let's say ttm were trying to detect a hypervisor dummy virtual device 
sitting on the pci bus. That device would perhaps provide pci 
information detailing what GFP masks needing to
allocate coherent memory. The TTM page pool could then grab that device 
and create a struct dev to use for allocating "anonymous" TTM BO memory.

Could that be a way forward? The struct dev would then be private to the 
page pool code, bare metal wouldn't need to allocate coherent memory, 
since the virtual device wouldn't be present. The page pool code would 
need to be updated to be able to cache also coherent pages.

Xen would need to create such a device in the guest with a suitable PCI 
ID that it would be explicitly willing to share with other hypervisor 
suppliers....

It's ugly, I know, but it might work...

Thomas

