Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab2IDOHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:07:45 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:34824 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2IDOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:07:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,367,1344211200"; 
   d="scan'208";a="14337520"
Message-ID: <50460B2E.3020200@citrix.com>
Date: Tue, 4 Sep 2012 15:07:42 +0100
From: Stefano Panella <stefano.panella@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/1] XEN: Use correct masking in xen_swiotlb_alloc_coherent.
References: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com> <5040B249.4000306@citrix.com> <20120831164010.GA18929@localhost.localdomain>
In-Reply-To: <20120831164010.GA18929@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 05:40 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 31, 2012 at 01:47:05PM +0100, David Vrabel wrote:
>> On 31/08/12 10:57, Stefano Panella wrote:
>>> When running 32-bit pvops-dom0 and a driver tries to allocate a coherent
>>> DMA-memory the xen swiotlb-implementation returned memory beyond 4GB.
>>>
>>> This caused for example not working sound on a system with 4 GB and a 64-bit
>>> compatible sound-card with sets the DMA-mask to 64bit.
>>>
>>> On bare-metal and the forward-ported xen-dom0 patches from OpenSuse a coherent
>>> DMA-memory is always allocated inside the 32-bit address-range by calling
>>> dma_alloc_coherent_mask.
>> We should have the same behaviour under Xen as bare metal so:
>>
>> Acked-By: David Vrabel <david.vrabel@citrix.com>
>>
>> This does limit the DMA mask to 32-bits by passing it through an
>> unsigned long, which seems a bit sneaky...
> so is the issue that we are not casting it from 'u64' to 'u32'
> (unsigned long) on 32-bit?

Yes. I do not completely understand why but I think on 32-bit kernel we need to cast dma_mask to u32. This is done automatically using dma_alloc_coherent_mask()

>
>> Presumably the sound card is capable of handling 64 bit physical
>> addresses (or it would break under 64-bit kernels) so it's not clear why
>> this sound driver requires this restriction.
>>
>> Is there a bug in the sound driver or sound subsystem where it's
>> truncating a dma_addr_t by assigning it to an unsigned long or similar?
>>
>>> --- a/drivers/xen/swiotlb-xen.c
>>> +++ b/drivers/xen/swiotlb-xen.c
>>> @@ -232,7 +232,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
>>>   		return ret;
>>>   
>>>   	if (hwdev && hwdev->coherent_dma_mask)
>>> -		dma_mask = hwdev->coherent_dma_mask;
>>> +		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
>> Suggest
>>
>>      if (hwdev)
>>          dma_mask = dma_alloc_coherent_mask(hwdev, flags)

I can change the patch like that if you like.

> Isn't that code just doing this:
> atic inline unsigned long dma_alloc_coherent_mask(struct device *dev,
>                                                      gfp_t gfp)
> {
>          unsigned long dma_mask = 0;
>
>          dma_mask = dev->coherent_dma_mask;
>          if (!dma_mask)
>                  dma_mask = (gfp & GFP_DMA) ? DMA_BIT_MASK(24) :
> DMA_BIT_MASK(32);
>
>          return dma_mask;
> }
>
> and in our code, the dma_mask by default is DMA_BIT_MASK(32):
>
> u64 dma_mask = DMA_BIT_MASK(32);
>
> So what I am missing?

I am not sure what you mean with "what am I missing?"

Current code looks like:

void *
xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
                            dma_addr_t *dma_handle, gfp_t flags,
                            struct dma_attrs *attrs)
{
         void *ret;
         int order = get_order(size);
         u64 dma_mask = DMA_BIT_MASK(32);
         unsigned long vstart;
         phys_addr_t phys;
         dma_addr_t dev_addr;

         /*
         * Ignore region specifiers - the kernel's ideas of
         * pseudo-phys memory layout has nothing to do with the
         * machine physical layout.  We can't allocate highmem
         * because we can't return a pointer to it.
         */
         flags &= ~(__GFP_DMA | __GFP_HIGHMEM);

         if (dma_alloc_from_coherent(hwdev, size, dma_handle, &ret))
                 return ret;

         vstart = __get_free_pages(flags, order);
         ret = (void *)vstart;

         if (!ret)
                 return ret;

         if (hwdev && hwdev->coherent_dma_mask)
                 dma_mask = hwdev->coherent_dma_mask;


So if hwdev->coherent_dma_mask is set to 0xffffffffffffffff our dma_mask will
be u64 set to 0xffffffffffffffff even if we set it to DMA_BIT_MASK(32) previously.

I hope I am not getting this wrong and let me know if I should send an updated version
of the patch including David V. change.

Regards,

Stefano

