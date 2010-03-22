Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab0CVEOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:14:10 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:32954 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab0CVEOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:14:08 -0400
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.51,285,1267419600"; 
   d="scan'208";a="14359157"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Uclinux-dist-devel] [PATCH] mm/nommu.c:Dynamic alloc/freepercpu area for nommu
Date: Mon, 22 Mar 2010 12:14:50 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA05CAC4E4@chinexm1.ad.analog.com>
In-Reply-To: <4BA449E2.3080707@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Uclinux-dist-devel] [PATCH] mm/nommu.c:Dynamic alloc/freepercpu area for nommu
Thread-Index: AcrITIzEkYse7aCjT1KVTsSm4ae6BgBKMLCw
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com> <4BA449E2.3080707@kernel.org>
To: "Tejun Heo" <tj@kernel.org>, <graff.yang@gmail.com>
CC: <dhowells@redhat.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
       <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Mar 2010 04:14:07.0162 (UTC) FILETIME=[1D7E49A0:01CAC976]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: uclinux-dist-devel-bounces@blackfin.uclinux.org 
>[mailto:uclinux-dist-devel-bounces@blackfin.uclinux.org] On 
>Behalf Of Tejun Heo
>Sent: Saturday, March 20, 2010 12:07 PM
>To: graff.yang@gmail.com
>Cc: dhowells@redhat.com; 
>uclinux-dist-devel@blackfin.uclinux.org; 
>akpm@linux-foundation.org; linux-kernel@vger.kernel.org
>Subject: Re: [Uclinux-dist-devel] [PATCH] mm/nommu.c:Dynamic 
>alloc/freepercpu area for nommu
>
>Hello,
>
>On 03/19/2010 06:02 PM, graff.yang@gmail.com wrote:
>> From: Graff Yang<graff.yang@gmail.com>
>>
>> This patch supports dynamic alloc/free percpu area for nommu 
>arch like 
>> blackfin.
>> It allocates contiguous pages in funtion pcpu_get_vm_areas() instead 
>> of getting none contiguous pages then vmap it in mmu arch.
>> As we can not get the real page structure through vmalloc_to_page(), 
>> so it also modified the nommu version 
>vmalloc_to_page()/vmalloc_to_pfn().
>>
>> Signed-off-by: Graff Yang<graff.yang@gmail.com>
>
>Heh heh... I've never imagined there would be a SMP 
>architecture w/o mmu.  That's pretty interesting.  I mean, 
>there is real estate for multiple cores but not for mmu?
>

Yes, the bf561 from Analog Device is an embeded dual-core CPU without
MMU. And we successfully port the SMP kernel to it with software cache
coherency support. Although it doesn't support different threads on
different core, multi processors still runs well concurrently.


>> diff --git a/mm/nommu.c b/mm/nommu.c
>> index 605ace8..98bbdf4 100644
>> --- a/mm/nommu.c
>> +++ b/mm/nommu.c
>> @@ -255,13 +255,15 @@ EXPORT_SYMBOL(vmalloc_user);
>>
>>   struct page *vmalloc_to_page(const void *addr)
>>   {
>> -	return virt_to_page(addr);
>> +	return (struct page *)
>> +			(virt_to_page(addr)->index) ? : 
>virt_to_page(addr);
>
>Nothing major but isn't it more usual to write ?: without the 
>intervening space?
>
>> +#ifdef CONFIG_SMP
>> +int map_kernel_range_noflush(unsigned long addr, unsigned long size,
>> +					pgprot_t prot, struct 
>page **pages) {
>
>More nitpicks.
>
>> +	int i, nr_page = size>>  PAGE_SHIFT;
>
>	       nr_pages = size >> PAGE_SHIFT;
>
>> +	for (i = 0; i<  nr_page; i++, addr += PAGE_SIZE)
>
>		    i < nr_pages
>
>> +		virt_to_page(addr)->index = (pgoff_t)pages[i];
>> +	return size>>  PAGE_SHIFT;
>
>	return size >> PAGE_SHIFT;
>
>I think checkpatch would whine about these too.
>
>> +void unmap_kernel_range_noflush(unsigned long addr, unsigned long 
>> +size) {
>> +	int i, nr_page = size>>  PAGE_SHIFT;
>> +	for (i = 0; i<  nr_page; i++, addr += PAGE_SIZE)
>> +		virt_to_page(addr)->index = 0;
>> +}
>> +
>> +struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>> +					const size_t *sizes, int nr_vms,
>> +						size_t align, 
>gfp_t gfp_mask)
>
>Hmmm... in general, one of the reasons the percpu allocation 
>is complex is to avoid contiguous allocations while avoiding 
>additional TLB / NUMA overhead on machines with rather complex 
>memory configuration (which is pretty common these days).  If 
>the memory has to be allocated contiguous anyway, it probably 
>would be much simpler to hook at higher level and simply 
>allocate each chunk contiguously.
>I'll look into it.
>
It is more reasonable to handle the dynamic malloc of continous percpu
data for NOMMU arch in a high layer.


Sonic

>Thanks.
>
>--
>tejun
>_______________________________________________
>Uclinux-dist-devel mailing list
>Uclinux-dist-devel@blackfin.uclinux.org
>https://blackfin.uclinux.org/mailman/listinfo/uclinux-dist-devel
>
