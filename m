Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1CYUBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:01:51 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:45012 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875Ab1CYUBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:01:50 -0400
Message-ID: <4D8CF46F.2070206@shipmail.org>
Date: Fri, 25 Mar 2011 21:00:47 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexdeucher@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be passed
 in for DMA API calls.
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com> <4D769726.2030307@shipmail.org> <20110322143137.GA25113@dumpdata.com> <4D89AB8F.6020500@shipmail.org> <20110323125105.GA6599@dumpdata.com> <4D89F2DE.7020209@shipmail.org> <20110323145246.GA7546@dumpdata.com> <4D8AF834.8040700@shipmail.org> <20110324142509.GA32416@dumpdata.com> <AANLkTinUGjwTzMFbHHckkiuCQ8sF+i5iMQsXesG34f6U@mail.gmail.com> <20110324162135.GA835@dumpdata.com>
In-Reply-To: <20110324162135.GA835@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 05:21 PM, Konrad Rzeszutek Wilk wrote:
>>> When a page in the TTM pool is being moved back and forth and also changes
>>> the caching model, what happens on the free part? Is the original caching
>>> state put back on it? Say I allocated a DMA32 page (GFP_DMA32), and move it
>>> to another pool for another radeon device. I also do some cache changes:
>>> make it write-back, then  un-cached, then writeback, and when I am done, I
>>> return it back to the pool (DMA32). Once that is done I want to unload
>>> the DRM/TTM driver. Does that page get its caching state reverted
>>> back to what it originally had (probably un-cached)? And where is this done?
>>>
>> When ultimately being free all the page are set to write back again as
>> it's default of all allocated page (see ttm_pages_put). ttm_put_pages
>> will add page to the correct pool (uc or wc).
>>
> OK.
>
> .. snip ..
>
>>> How about a backend TTM alloc API? So the calls to 'ttm_get_page'
>>> and 'ttm_put_page' call to a TTM-alloc API to do allocation.
>>>
>>> The default one is the native, and it would have those 'dma_alloc_coherent'
>>> removed.  When booting under virtualized
>>> environment a virtualisation "friendly" backend TTM alloc would
>>> register and all calls to 'put/get/probe' would be diverted to it.
>>> 'probe' would obviously check whether it should use this backend or not.
>>>
>>> It would mean two new files: drivers/gpu/drm/ttm/ttm-memory-xen.c and
>>> a ttm-memory-generic.c and some header work.
>>>
>>> It would still need to keep the 'dma_address[i]' around so that
>>> those can be passed to the radeon/nouveau GTT, but for native it
>>> could just contain BAD_DMA_ADDRESS - and the code in the radeon/nouveau
>>> GTT binding is smart to figure out to do 'pci_map_single' if the
>>> dma_addr_t has BAD_DMA_ADDRESS.
>>>
>>> The issuer here is with the caching I had a question about. We
>>> would need to reset the caching state back to the original one
>>> before free-ing it. So does the TTM pool de-alloc code deal with this?
>>>
>>>
>> Sounds doable. Thought i don't understand why you want virtualized
>>
> Thomas, Jerome, Dave,
>
> I can start this next week if you guys are comfortable with this idea.
>
>

Konrad,

1) A couple of questions first. Where are the memory pools going to end 
up in this design. Could you draft an API? How is page accounting going 
to be taken care of? How do we differentiate between running on bare 
metal and running on a hypervisor?

2) When a page changes caching policy, I guess that needs to be 
propagated to any physical hypervisor mappings of that page. We don't 
allow for different maps with different caching policies in the general 
case.

3) TTM needs to be able to query the bo whether its pages can be
a) moved between devices (I guess this is the case for coherent pages 
with a phony device).
b) inserted into the swap cache (I guess this is in general not the case 
for coherent pages).

4) We'll probably need to move ttm page alloc and put and the query in 
3) to the ttm backend. The backend can then hide things like DMA address 
and device-specific memory to the rest of TTM as long as the query in 3) 
is exposed, so the rest of TTM doesn't need to care. The backend can 
then plug in whatever memory allocation utility function it wants.

5) For the future we should probably make TTM support non-coherent 
memory if needed, with appropriate flushes and sync for device / cpu. 
However, that's something we can look at later.

/Thomas


>> guest to be able to use hw directly. From my point of view all device
>> in a virtualized guest should be virtualized device that talks to the
>> host system driver.
>>
> That "virtualized guest" in this case is the first Linux kernel that
> is booted under a hypervisor. It serves as the "driver domain"
> so that it can drive the network, storage, and graphics. To get the
> graphics working right the patchset that introduced using the PCI DMA
> in the TTM layer allows us to program the GTT with the bus address
> instead of programming the bus address of a bounce buffer. The first
> set of patches have a great lengthy explanation of this :-)
>
> https://lkml.org/lkml/2010/12/6/516
>
>
>> Cheers,
>> Jerome
>>

