Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0FUBly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:41:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42705 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab0FUBls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:41:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C1EC326.3020409@jp.fujitsu.com>
Date: Mon, 21 Jun 2010 10:40:54 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, matthew@wil.cx, macro@linux-mips.org,
       kamezawa.hiroyu@jp.fujitsu.com, eike-kernel@sf-tec.de,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C1AE64C.6040609@jp.fujitsu.com> <4C1AE680.7090408@jp.fujitsu.com> <4C1B537F.30300@goop.org>
In-Reply-To: <4C1B537F.30300@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/18 20:07), Jeremy Fitzhardinge wrote:
> On 06/18/2010 04:22 AM, Kenji Kaneshige wrote:
>> Current x86 ioremap() doesn't handle physical address higher than
>> 32-bit properly in X86_32 PAE mode. When physical address higher than
>> 32-bit is passed to ioremap(), higher 32-bits in physical address is
>> cleared wrongly. Due to this bug, ioremap() can map wrong address to
>> linear address space.
>>
>> In my case, 64-bit MMIO region was assigned to a PCI device (ioat
>> device) on my system. Because of the ioremap()'s bug, wrong physical
>> address (instead of MMIO region) was mapped to linear address space.
>> Because of this, loading ioatdma driver caused unexpected behavior
>> (kernel panic, kernel hangup, ...).
>>
>> Signed-off-by: Kenji Kaneshige<kaneshige.kenji@jp.fujitsu.com>
>>
>> ---
>>   arch/x86/mm/ioremap.c   |   12 +++++-------
>>   include/linux/io.h      |    4 ++--
>>   include/linux/vmalloc.h |    2 +-
>>   lib/ioremap.c           |   10 +++++-----
>>   mm/vmalloc.c            |    2 +-
>>   5 files changed, 14 insertions(+), 16 deletions(-)
>>
>> Index: linux-2.6.34/arch/x86/mm/ioremap.c
>> ===================================================================
>> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c
>> +++ linux-2.6.34/arch/x86/mm/ioremap.c
>> @@ -62,8 +62,8 @@ int ioremap_change_attr(unsigned long va
>>   static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>>   		unsigned long size, unsigned long prot_val, void *caller)
>>   {
>> -	unsigned long pfn, offset, vaddr;
>> -	resource_size_t last_addr;
>> +	unsigned long offset, vaddr;
>> +	resource_size_t pfn, last_pfn, last_addr;
>>
>
> Why is pfn resource_size_t here? Is it to avoid casting, or does it
> actually need to hold more than 32 bits? I don't see any use of pfn
> aside from the page_is_ram loop, and I don't think that can go beyond 32
> bits. If you're worried about boundary conditions at the 2^44 limit,
> then you can make last_pfn inclusive, or compute num_pages and use that
> for the loop condition.
>

The reason I changed here was phys_addr might be higher than 2^44. After
the discussion, I realized there would probably be many other codes that
cannot handle more than 32-bits pfn, and this would cause problems even
if I changed ioremap() to be able to handle more than 32-bits pfn. So I
decided to focus on making 44-bits physical address work properly this
time. But, I didn't find any reason to make it go back to unsigned long.
So I still make it resource_size_t even in v.3. Is there any problem on
this change? And I don't understand why pfn can't go beyond 32-bits.
Could you tell me why?


>>   	const resource_size_t unaligned_phys_addr = phys_addr;
>>   	const unsigned long unaligned_size = size;
>>   	struct vm_struct *area;
>> @@ -100,10 +100,8 @@ static void __iomem *__ioremap_caller(re
>>   	/*
>>   	 * Don't allow anybody to remap normal RAM that we're using..
>>   	 */
>> -	for (pfn = phys_addr>>  PAGE_SHIFT;
>> -				(pfn<<  PAGE_SHIFT)<  (last_addr&  PAGE_MASK);
>> -				pfn++) {
>> -
>> +	last_pfn = last_addr>>  PAGE_SHIFT;
>>
>
> If last_addr can be non-page aligned, should it be rounding up to the
> next pfn rather than rounding down? Ah, looks like you fix it in the
> second patch.
>

Yes, I fixed it in the [PATCH 2/2].

Thanks,
Kenji Kaneshige


