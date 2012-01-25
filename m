Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292Ab2AYSeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:34:03 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:15451 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750877Ab2AYSeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:34:01 -0500
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 13:34:00 EST
Message-ID: <4F204719.7010709@shipmail.org>
Date: Wed, 25 Jan 2012 19:16:57 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        James Simmons <jsimmons@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] Future TTM DMA direction
References: <4F0AB558.3050902@vmware.com> <20120109101105.GC3723@phenom.ffwll.local> <20120110174649.GA3683@homer.localdomain>
In-Reply-To: <20120110174649.GA3683@homer.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, revisiting this again, please see inline below,


On 01/10/2012 06:46 PM, Jerome Glisse wrote:
> On Mon, Jan 09, 2012 at 11:11:06AM +0100, Daniel Vetter wrote:
>> On Mon, Jan 09, 2012 at 10:37:28AM +0100, Thomas Hellstrom wrote:
>>> Hi!
>>>
>>> When TTM was originally written, it was assumed that GPU apertures
>>> could address pages directly, and that the CPU could access those
>>> pages without explicit synchronization. The process of binding a
>>> page to a GPU translation table was a simple one-step operation, and
>>> we needed to worry about fragmentation in the GPU aperture only.
>>>
>>> Now that we "sort of" support DMA memory there are three things I
>>> think are missing:
>>>
>>> 1) We can't gracefully handle coherent DMA OOMs or coherent DMA
>>> (Including CMA) memory fragmentation leading to failed allocations.
>>> 2) We can't handle dynamic mapping of pages into and out of dma, and
>>> corresponding IOMMU space shortage or fragmentation, and CPU
>>> synchronization.
>>> 3) We have no straightforward way of moving pages between devices.
>>>
>>> I think a reasonable way to support this is to make binding to a
>>> non-fixed (system page based) TTM memory type a two-step binding
>>> process, so that a TTM placement consists of (DMA_TYPE, MEMORY_TYPE)
>>> instead of only (MEMORY_TYPE).
>>>
>>> In step 1) the bo is bound to a specific DMA type. These could be
>>> for example:
>>> (NONE, DYNAMIC, COHERENT, CMA), .... device dependent types could be
>>> allowed as well.
>>> In this step, we perform dma_sync_for_device, or allocate
>>> dma-specific pages maintaining LRU lists so that if we receive a DMA
>>> memory allocation OOM, we can unbind bo:s bound to the same DMA
>>> type. Standard graphics cards would then, for example, use the NONE
>>> DMA type when run on bare metal or COHERENT when run on Xen. A
>>> "COHERENT" OOM condition would then lead to eviction of another bo.
>>> (Note that DMA eviction might involve data copies and be costly, but
>>> still better than failing).
>>> Binding with the DYNAMIC memory type would mean that CPU accesses
>>> are disallowed, and that user-space CPU page mappings might need to
>>> be killed, with a corresponding sync_for_cpu if they are faulted in
>>> again (perhaps on a page-by-page basis). Any attempt to bo_kmap() a
>>> bo page bound to DYNAMIC DMA mapping should trigger a BUG.
>>>
>>> In step 2) The bo is bound to the GPU in the same way it's done
>>> today. Evicting from DMA will of course also trigger an evict from
>>> GPU, but an evict from GPU will not trigger a DMA evict.
>>>
>>> Making a bo "anonymous" and thus moveable between devices would then
>>> mean binding it to the "NONE" DMA type.
>>>
>>> Comments, suggestions?
>> Well I think we need to solve outstanding issues in the dma_buf framework
>> first. Currently dma_buf isn't really up to par to handle coherency
>> between the cpu and devices and there's also not yet any way to handle dma
>> address space fragmentation/exhaustion.
>>
>> I fear that if you jump ahead with improving the ttm support alone we
>> might end up with something incompatible to the stuff dma_buf eventually
>> will grow, resulting in decent amounts of wasted efforts.
>>
>> Cc'ed a bunch of relevant lists to foster input from people.
>>
>> For a starter you seem to want much more low-level integration with the
>> dma api than existing users commonly need. E.g. if I understand things
>> correctly drivers just call dma_alloc_coherent and the platform/board code
>> then decides whether the device needs a contigious allocation from cma or
>> whether something else is good, too (e.g. vmalloc for the cpu + iommu).
>> Another thing is that I think doing lru eviction in case of dma address
>> space exhaustion (or fragmentation) needs at least awereness of what's
>> going on in the upper layers. iommus are commonly shared between devices
>> and I presume that two ttm drivers sitting behind the same iommu and
>> fighting over it's resources can lead to some hilarious outcomes.
>>
>> Cheers, Daniel
> I am with Daniel here, while i think the ttm API change you propose are
> good idea, i think most of the issue you are listing need to be addressed
> at lower level. If ttm keeps doing its own things for GPU in its own little
> area we gonna endup in a dma getto ;)
>
> dma space exhaustion is somethings that is highly platform specific, on
> x86 platform it's very unlikely to happen for AMD, Intel or NVidia GPU.
> While on the ARM platform it's more likely situation, at least on current
> generation.

OK. You and Daniel have convinced me to leave OOM- and fragmentation 
handling
out of TTM, but I still think TTM DMA placement might be a good thing to 
look at
when time allows.

>
> I believe that the dma api to allocate memory are just too limited for the
> kind of device and support we are having. The association to a device is
> too restrictive. I would rather see some new API to allocate DMA/IOMMU,
> something more flexible and more in line with the dma-buf work.
>
> I believe all dma allocation have a set of restriction. dma mask of the
> device, is there an iommu or not, iommu dma mask if any, iommu has a limited
> address space (note that recent x86 iommu don't have such limit). In the
> end it's not only the device dma mask that matter but also the iommu.
> For space exhaustion core dma/iommu need to grow reclaim callback so each
> driver that use the dma/iommu space can try to free/unbind things.
>
> In the end what i would really like to see is all the ttm page allocation
> helper moved to core kernel helper, and getting rid of ttm memory accounting
> by properly hooking up into core memory accouting so that core kernel
> infrastructure have a clue about how much memory each process really use
> include memory use by device like GPU unlike today.

I agree it would be possible and desirable to do that for the movable 
pages backing bo data,
however for non-movable data structures (buffer object metadata, fence 
objects) etc.
there still needs to be a way to avoid exhausting kmalloced memory.

>
> Anyway my point is that the 3 point you want to address need to be addressed
> first at core common DMA code rather then at ttm level. This would benefit
> all user of dma-buf and also other devices.


agreed.

/Thomas



> Cheers,
> Jerome
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



