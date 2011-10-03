Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1JCQhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:37:47 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:4433 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424Ab1JCQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:37:40 -0400
Message-ID: <4E89E45E.7010009@vmware.com>
Date: Mon, 03 Oct 2011 18:35:42 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, j.glisse@redhat.com, thomas@shipmail.org,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v1.8
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com> <4E8568E8.1070800@vmware.com> <20110930140949.GA18905@phenom.oracle.com>
In-Reply-To: <20110930140949.GA18905@phenom.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 04:09 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 30, 2011 at 08:59:52AM +0200, Thomas Hellstrom wrote:
>    
>> Konrad,
>>
>> I'm really sorry for taking so long to review this.
>>      
> That is OK. We all are busy - and it gave me some time to pretty
> up the code even more.
>
>    
>> I'd like to go through a couple of high-level things first before
>> reviewing the coding itself.
>>
>> The page_alloc_func structure looks nice, but I'd like to have it
>> per ttm backend,
>>      
> Meaning the 'struct ttm_backend_func' right?
>
>    

Yes, that's right.

>> we would just need to make sure that the backend is alive when we
>> alloc / free pages.
>> The reason for this is that there may be backends that want to
>> allocate dma memory running simultaneously with those who don't.
>>      
> As in for some TTM manager use the non-DMA, and for other DMA
> (is_dma32 is set?) Or say two cards - one that has the concept
> of MMU and one that does not and both of them are readeon?
>    

For example, or let's say you have a low-end system that in the future 
needs to
allocate DMA memory, and want to plug in a high-end graphics card, like 
Radeon.



>    
>> When the backend fires up, it can determine whether to use DMA
>> memory or not.
>>      
> Or more of backends (and drivers) that do not have any concept
> of MMU and just use framebuffers and such?
>
> I think we would just have to stick in a pointer to the
> appropiate 'struct ttm_page_alloc_func' (and the 'struct device')
> in the 'struct ttm_backend_func'. And this would be done by
> backend that would decided which one to use.
>    

Yes, either that, or merge the two structs.

> And the TTM could find out which page_alloc_func to use straight
> from the ttm_backend_func and call that (along with the 'struct device'
> also gathered from that structure). Rough idea (on top of the patches):
>
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> index dd05db3..e7a0c3c 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> @@ -902,12 +902,12 @@ struct ttm_page_alloc_func ttm_page_alloc_default = {
>
>   int ttm_get_pages(struct list_head *pages, int flags,
>   		  enum ttm_caching_state cstate, unsigned count,
> -		  dma_addr_t *dma_address, struct device *dev)
> +		  dma_addr_t *dma_address, struct ttm_backend *be)
>    

I'd like to see it even more simple. If the ttm_backend_func is 
responsible for allocating pages,
ttm_get_pages would be called by the backend code, and the dma_addr_t 
pointer can be kept
in the backend object. No need to expose neither device nor dma address 
to core ttm that
really doesn't want to care. The dma_address is then available in the 
backend only
for binding / unbinding, and ttm_get_pages will be called exclusively by 
the backend, and its
interface can pass struct device.

> And "ttm/tt: Move ttm_tt_set_page_caching implementation in TTM page pool code."
> would still be there, except it would be done per ttm-backend. Well
> by choosing which TTM page pool the TTM backend would use.
>
>    

Yes.

>> 2) Memory accounting: If the number DMA pages are limited in a way
>> that the ttm memory global routines are not aware of. How do we
>> handle memory accounting? (How do we avoid exhausting IOMMU space)?
>>      
> Good question. Not entirely sure about that. I know that on
> SWIOTLB there is no limit (as you do not use the bounce buffer)
> but not sure about VT-D, AMD-VI, GART, or when there is no IOMMU.
>
> Let me get back to you on that.
>
> Granted, the code _only_ gets activated when we use SWIOTLB right
> now so the answer is "no exhausting" currently. Either way let me
> dig a bit deeper.
>    

I'm fine with it working OK with SWIOTLB now.
When we need to handle other situations, let's find out how to do it then.

>> 3) Page swapping. Currently we just copy pages to shmem pages and
>> then free device pages. In the future we'd probably like to insert
>> non-dma pages directly into the swap cache. Is it possible to
>> differentiate dma pages from pages that are directly insertable?
>>      
> Yes. The TTM DMA pool keeps track of which pages belong to which
> pool and will reject non-dma pages (or pages which belong to
> a different pool). It is fairly easy to expose that check
> so that the generic TTM code can make the proper distinction.
>
> But also - once you free a device page ('cached') it gets freed.
> The other pages (writecombine,  writeback, uncached) end up sitting
> in a recycle pool to be used. This is believe how the current
> TTM page code works right now (and this TTM DMA pool follows).
>    

Yes, that's OK, as long as the system shrinker can free those pages.

> The swapping code back (so from swap to pool) does not seem to
> distinguish it that much - it just allocates a new page - and
> then copies from whatever was in the swap cache?
>
> This is something you were thinking to do in the future I presume?
>    

Yes. If / when I do that, I might be adding a new backend function to 
put a ttm in an
"anonymous state", that is using only pages that can be inserted in the 
swap cache or passed
around to other devices, and to put a ttm in a "device" state, that 
copies it to device mappable pages.

Thanks,
/Thomas

