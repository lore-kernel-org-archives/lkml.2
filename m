Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1CWIN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:13:59 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53464 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab1CWIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:13:57 -0400
Message-ID: <4D89AB8F.6020500@shipmail.org>
Date: Wed, 23 Mar 2011 09:13:03 +0100
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
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com> <4D769726.2030307@shipmail.org> <20110322143137.GA25113@dumpdata.com>
In-Reply-To: <20110322143137.GA25113@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 03:31 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 08, 2011 at 09:52:54PM +0100, Thomas Hellstrom wrote:
>    
>> Hi, Konrad,
>>
>> Is passing a struct device to the DMA api really *strictly* necessary?
>>      
> Soo.. it seems it is on PowerPC, which I sadly didn't check for, does require
> this.
>    
>> I'd like to avoid that at all cost, since we don't want pages that
>> are backing buffer objects
>> (coherent pages) to be associated with a specific device.
>>
>> The reason for this is that we probably soon will want to move ttm
>> buffer objects between devices, and that should ideally be a simple
>> operation: If the memory type the buffer object currently resides in
>> is not shared between two devices, then move it out to system memory
>> and change its struct bo_device pointer.
>>      
> I was thinking about this a bit after I found that the PowerPC requires
> the 'struct dev'. But I got a question first, what do you with pages
> that were allocated to a device that can do 64-bit DMA and then
> move it to a device than can 32-bit DMA? Obviously the 32-bit card would
> set the TTM_PAGE_FLAG_DMA32 flag, but the 64-bit would not. What is the
> process then? Allocate a new page from the 32-bit device and then copy over the
> page from the 64-bit TTM and put the 64-bit TTM page?
>    

Yes, in certain situations we need to copy, and if it's necessary in 
some cases to use coherent memory with a struct device assoicated with 
it, I agree it may be reasonable to do a copy in that case as well. I'm 
against, however, to make that the default case when running on bare metal.

However, I've looked a bit deeper into all this, and it looks like we 
already have other problems that need to be addressed, and that exists 
with the code already in git:

Consider a situation where you allocate a cached DMA32 page from the ttm 
page allocator. You'll end up with a coherent page. Then you make it 
uncached and finally you return it to the ttm page allocator. Since it's 
uncached, it will not be freed by the dma api, but kept in the uncached 
pool, and later the incorrect page free function will be called.

I think we might need to take a few steps back and rethink this whole idea:

1) How does this work in the AGP case? Let's say you allocate 
write-combined DMA32 pages from the ttm page pool (in this case you 
won't get coherent memory) and then use them in an AGP gart? Why is it 
that we don't need coherent pages then in the Xen case?

2) http://www.mjmwired.net/kernel/Documentation/DMA-API.txt, line 33 
makes me scared.
We should identify what platforms may have problems with this.

3) When hacking on the unichrome DMA engine it wasn't that hard to use 
the synchronization functions of the DMA api correctly:

  When binding a TTM, the backend calls dma_map_page() on pages, When 
unbinding, the backend calls dma_unmap_page(), If we need cpu access 
when bound, we need to call dma_sync_single_for_[cpu|device]. If this is 
done, it will be harder to implement user-space sub-allocation, but 
possible. There will be a performance loss on some platforms, though.

/Thomas





