Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab2JITLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:11:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:1075 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab2JITLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:11:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,561,1344236400"; 
   d="scan'208";a="232631986"
Message-ID: <507476D8.7010906@intel.com>
Date: Tue, 09 Oct 2012 12:11:20 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org
Subject: Re: [RFC PATCH 2/7] swiotlb: Make io_tlb_start a physical address
 instead of a virtual address
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <20121004003853.5016.86765.stgit@gitlad.jf.intel.com> <20121004131829.GC9158@phenom.dumpdata.com> <506DC332.5000409@intel.com> <20121004171904.GA4466@phenom.dumpdata.com> <506DF022.4030400@intel.com> <20121009164344.GC25276@phenom.dumpdata.com>
In-Reply-To: <20121009164344.GC25276@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 09:43 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 04, 2012 at 01:22:58PM -0700, Alexander Duyck wrote:
>> On 10/04/2012 10:19 AM, Konrad Rzeszutek Wilk wrote:
>>>>>> @@ -450,7 +451,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
>>>>>>  				io_tlb_list[i] = 0;
>>>>>>  			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
>>>>>>  				io_tlb_list[i] = ++count;
>>>>>> -			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
>>>>>> +			dma_addr = (char *)phys_to_virt(io_tlb_start) + (index << IO_TLB_SHIFT);
>>>>> I think this is going to fall flat with the other user of
>>>>> swiotlb_tbl_map_single - Xen SWIOTLB. When it allocates the io_tlb_start
>>>>> and does it magic to make sure its under 4GB - the io_tlb_start swath
>>>>> of memory, ends up consisting of 2MB chunks of contingous spaces. But each
>>>>> chunk is not linearly in the DMA space (thought it is in the CPU space).
>>>>>
>>>>> Meaning the io_tlb_start region 0-2MB can fall within the DMA address space
>>>>> of 2048MB->2032MB, and io_tlb_start offset 2MB->4MB, can fall within 1024MB->1026MB,
>>>>> and so on (depending on the availability of memory under 4GB).
>>>>>
>>>>> There is a clear virt_to_phys(x) != virt_to_dma(x).
>>>> Just to be sure I understand you are talking about DMA address space,
>>>> not physical address space correct?  I am fully aware that DMA address
>>>> space can be all over the place.  When I was writing the patch set the
>>>> big reason why I decided to stop at physical address space was because
>>>> DMA address spaces are device specific.
>>>>
>>>> I understand that virt_to_phys(x) != virt_to_dma(x) for many platforms,
>>>> however that is not my assertion.  My assertion is (virt_to_phys(x) + y)
>>>> == virt_to_phys(x + y).  This should be true for any large block of
>>>> contiguous memory that is DMA accessible since the CPU and the device
>>>> should be able to view the memory in the same layout.  If that wasn't
>>> That is true mostly for x86 but not all platforms do this.
>>>
>>>> true I don't think is_swiotlb_buffer would be working correctly since it
>>>> is essentially operating on the same assumption prior to my patches.
>>> There are two pieces here - the is_swiotlb_buffer and the swiotlb_tbl_[map|unmap]
>>> functions.
>>>
>>> The is_swiotlb_buffer is operating on that principle (and your change
>>> to reflect that is OK). The swiotlb_tbl_[*] is not.
>>>> If you take a look at patches 4 and 5 I do address changes that end up
>>>> needing to be made to Xen SWIOTLB since it makes use of
>>>> swiotlb_tbl_map_single.  All that I effectively end up changing is that
>>>> instead of messing with a void pointer we instead are dealing with a
>>>> physical address, and instead of calling xen_virt_to_bus we end up
>>>> calling xen_phys_to_bus and thereby drop one extra virt_to_phys call in
>>>> the process.
>>> Sure that is OK. All of those changes when we bypass the bounce
>>> buffer look OK (thought I should double-check again the patch to make
>>> sure and also just take it for a little test spin).
>> I'm interesting in finding out what the results of your test spin are. 
> Haven't gotten to that yet :-(
>>> The issue is when we do _use_ the bounce buffer. At that point we
>>> run into the allocation from the bounce buffer where the patches
>>> assume that the 64MB swath of bounce buffer memory is bus (or DMA)
>>> memory contingous. And that is not the case sadly.
>> I think I understand what you are saying now.  However, I don't think
>> the issue applies to my patches.
> Great.
>> If I am not mistaken what you are talking about is the pseudo-physical
>> memory versus machine memory.  I understand the 64MB block is not
>> machine-memory contiguous, but it should be pseudo-physical contiguous
>> memory.  As such using the pseudo-physical addresses instead of virtual
>> addresses should function the same way as using true physical addresses
>> to replace virtual addresses.  All of the physical memory translation to
>> machine memory translation is happening in xen_phys_to_bus and all of
>> the changes I have made take place before that so the bounce buffers
>> should still be working correctly.  In addition none of the changes I
> OK.
>

I don't know if you saw but I submitted the patches, non-RFC.

I think I might have realized the point of confusion and attempted to
address it.  I went through and renamed several variables in the updated
patches.  Specifically I renamed things like "char *dma_addr" to
"phys_addr_t tlb_addr".  I figure it will help to avoid any confusion as
I can see how "phys_addr_t dma_addr" could make someone think I am using
physical addresses as DMA addresses.

Thanks,

Alex
