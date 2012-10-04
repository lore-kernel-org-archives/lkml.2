Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2JDRLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:11:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:52669 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab2JDRLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:11:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,537,1344236400"; 
   d="scan'208";a="201633691"
Message-ID: <506DC332.5000409@intel.com>
Date: Thu, 04 Oct 2012 10:11:14 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org
Subject: Re: [RFC PATCH 2/7] swiotlb: Make io_tlb_start a physical address
 instead of a virtual address
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com> <20121004003853.5016.86765.stgit@gitlad.jf.intel.com> <20121004131829.GC9158@phenom.dumpdata.com>
In-Reply-To: <20121004131829.GC9158@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 06:18 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 03, 2012 at 05:38:53PM -0700, Alexander Duyck wrote:
>> This change makes it so that io_tlb_start contains a physical address instead
>> of a virtual address.  The advantage to this is that we can avoid costly
>> translations between virtual and physical addresses when comparing the
>> io_tlb_start against DMA addresses.
>>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>> ---
>>
>>  lib/swiotlb.c |   61 +++++++++++++++++++++++++++++----------------------------
>>  1 files changed, 31 insertions(+), 30 deletions(-)
>>
>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>> index 5cc4d4e..02abb72 100644
>> --- a/lib/swiotlb.c
>> +++ b/lib/swiotlb.c
>> @@ -57,7 +57,7 @@ int swiotlb_force;
>>   * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
>>   * API.
>>   */
>> -static char *io_tlb_start;
>> +phys_addr_t io_tlb_start;
>>  
>>  /*
>>   * The number of IO TLB blocks (in groups of 64).
>> @@ -125,14 +125,15 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
>>  void swiotlb_print_info(void)
>>  {
>>  	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
>> -	phys_addr_t pstart, pend;
>> +	unsigned char *vstart, *vend;
>>  
>> -	pstart = virt_to_phys(io_tlb_start);
>> -	pend = pstart + bytes;
>> +	vstart = phys_to_virt(io_tlb_start);
>> +	vend = vstart + bytes;
>>  
>>  	printk(KERN_INFO "software IO TLB [mem %#010llx-%#010llx] (%luMB) mapped at [%p-%p]\n",
>> -	       (unsigned long long)pstart, (unsigned long long)pend - 1,
>> -	       bytes >> 20, io_tlb_start, io_tlb_start + bytes - 1);
>> +	       (unsigned long long)io_tlb_start,
>> +	       (unsigned long long)io_tlb_start + bytes - 1,
>> +	       bytes >> 20, vstart, vend - 1);
>>  }
>>  
>>  void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>> @@ -142,7 +143,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>>  	bytes = nslabs << IO_TLB_SHIFT;
>>  
>>  	io_tlb_nslabs = nslabs;
>> -	io_tlb_start = tlb;
>> +	io_tlb_start = __pa(tlb);
> Why not 'virt_to_phys' ?

I had originally done it as a virt_to_phys, however I then noticed in
swiotlb_free that the bootmem was being converted to a physical address
via __pa.  I did a bit of digging and everything seemed to indicate that
the preferred approach in early boot to get a physical address was __pa
so I decided to switch it from virt_to_phys to __pa for the early init
versions of the calls.  If virt_to_phys is preferred though I can switch
it back.

>>  
>>  	/*
>>  	 * Allocate and initialize the free list array.  This array is used
>> @@ -171,6 +172,7 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>>  static void __init
>>  swiotlb_init_with_default_size(size_t default_size, int verbose)
>>  {
>> +	unsigned char *vstart;
>>  	unsigned long bytes;
>>  
>>  	if (!io_tlb_nslabs) {
>> @@ -183,11 +185,11 @@ swiotlb_init_with_default_size(size_t default_size, int verbose)
>>  	/*
>>  	 * Get IO TLB memory from the low pages
>>  	 */
>> -	io_tlb_start = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
>> -	if (!io_tlb_start)
>> +	vstart = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
>> +	if (!vstart)
>>  		panic("Cannot allocate SWIOTLB buffer");
>>  
>> -	swiotlb_init_with_tbl(io_tlb_start, io_tlb_nslabs, verbose);
>> +	swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose);
>>  }
>>  
>>  void __init
>> @@ -205,6 +207,7 @@ int
>>  swiotlb_late_init_with_default_size(size_t default_size)
>>  {
>>  	unsigned long bytes, req_nslabs = io_tlb_nslabs;
>> +	unsigned char *vstart = NULL;
>>  	unsigned int order;
>>  	int rc = 0;
>>  
>> @@ -221,14 +224,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
>>  	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
>>  
>>  	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
>> -		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
>> -							order);
>> -		if (io_tlb_start)
>> +		vstart = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
>> +						  order);
>> +		if (vstart)
>>  			break;
>>  		order--;
>>  	}
>>  
>> -	if (!io_tlb_start) {
>> +	if (!vstart) {
>>  		io_tlb_nslabs = req_nslabs;
>>  		return -ENOMEM;
>>  	}
>> @@ -237,9 +240,9 @@ swiotlb_late_init_with_default_size(size_t default_size)
>>  		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
>>  		io_tlb_nslabs = SLABS_PER_PAGE << order;
>>  	}
>> -	rc = swiotlb_late_init_with_tbl(io_tlb_start, io_tlb_nslabs);
>> +	rc = swiotlb_late_init_with_tbl(vstart, io_tlb_nslabs);
>>  	if (rc)
>> -		free_pages((unsigned long)io_tlb_start, order);
>> +		free_pages((unsigned long)vstart, order);
>>  	return rc;
>>  }
>>  
>> @@ -251,9 +254,9 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
>>  	bytes = nslabs << IO_TLB_SHIFT;
>>  
>>  	io_tlb_nslabs = nslabs;
>> -	io_tlb_start = tlb;
>> +	io_tlb_start = virt_to_phys(tlb);
>>  
>> -	memset(io_tlb_start, 0, bytes);
>> +	memset(tlb, 0, bytes);
>>  
>>  	/*
>>  	 * Allocate and initialize the free list array.  This array is used
>> @@ -300,7 +303,7 @@ cleanup3:
>>  	                                                 sizeof(int)));
>>  	io_tlb_list = NULL;
>>  cleanup2:
>> -	io_tlb_start = NULL;
>> +	io_tlb_start = 0;
>>  	io_tlb_nslabs = 0;
>>  	return -ENOMEM;
>>  }
>> @@ -317,7 +320,7 @@ void __init swiotlb_free(void)
>>  			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
>>  		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
>>  								 sizeof(int)));
>> -		free_pages((unsigned long)io_tlb_start,
>> +		free_pages((unsigned long)phys_to_virt(io_tlb_start),
>>  			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
>>  	} else {
>>  		free_bootmem_late(__pa(io_tlb_overflow_buffer),
>> @@ -326,7 +329,7 @@ void __init swiotlb_free(void)
>>  				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
>>  		free_bootmem_late(__pa(io_tlb_list),
>>  				  PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
>> -		free_bootmem_late(__pa(io_tlb_start),
>> +		free_bootmem_late(io_tlb_start,
>>  				  PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
>>  	}
>>  	io_tlb_nslabs = 0;
>> @@ -334,10 +337,8 @@ void __init swiotlb_free(void)
>>  
>>  static int is_swiotlb_buffer(phys_addr_t paddr)
>>  {
>> -	phys_addr_t swiotlb_start = virt_to_phys(io_tlb_start);
>> -
>> -	return paddr >= swiotlb_start &&
>> -		paddr < (swiotlb_start + (io_tlb_nslabs << IO_TLB_SHIFT));
>> +	return paddr >= io_tlb_start &&
>> +		paddr < (io_tlb_start + (io_tlb_nslabs << IO_TLB_SHIFT));
>>  }
>>  
>>  /*
>> @@ -450,7 +451,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
>>  				io_tlb_list[i] = 0;
>>  			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
>>  				io_tlb_list[i] = ++count;
>> -			dma_addr = io_tlb_start + (index << IO_TLB_SHIFT);
>> +			dma_addr = (char *)phys_to_virt(io_tlb_start) + (index << IO_TLB_SHIFT);
> I think this is going to fall flat with the other user of
> swiotlb_tbl_map_single - Xen SWIOTLB. When it allocates the io_tlb_start
> and does it magic to make sure its under 4GB - the io_tlb_start swath
> of memory, ends up consisting of 2MB chunks of contingous spaces. But each
> chunk is not linearly in the DMA space (thought it is in the CPU space).
>
> Meaning the io_tlb_start region 0-2MB can fall within the DMA address space
> of 2048MB->2032MB, and io_tlb_start offset 2MB->4MB, can fall within 1024MB->1026MB,
> and so on (depending on the availability of memory under 4GB).
>
> There is a clear virt_to_phys(x) != virt_to_dma(x).

Just to be sure I understand you are talking about DMA address space,
not physical address space correct?  I am fully aware that DMA address
space can be all over the place.  When I was writing the patch set the
big reason why I decided to stop at physical address space was because
DMA address spaces are device specific.

I understand that virt_to_phys(x) != virt_to_dma(x) for many platforms,
however that is not my assertion.  My assertion is (virt_to_phys(x) + y)
== virt_to_phys(x + y).  This should be true for any large block of
contiguous memory that is DMA accessible since the CPU and the device
should be able to view the memory in the same layout.  If that wasn't
true I don't think is_swiotlb_buffer would be working correctly since it
is essentially operating on the same assumption prior to my patches.

If you take a look at patches 4 and 5 I do address changes that end up
needing to be made to Xen SWIOTLB since it makes use of
swiotlb_tbl_map_single.  All that I effectively end up changing is that
instead of messing with a void pointer we instead are dealing with a
physical address, and instead of calling xen_virt_to_bus we end up
calling xen_phys_to_bus and thereby drop one extra virt_to_phys call in
the process.

Thanks,

Alex

