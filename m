Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0FQG3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 02:29:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47357 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab0FQG3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 02:29:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C19C090.20904@jp.fujitsu.com>
Date: Thu, 17 Jun 2010 15:28:32 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       macro@linux-mips.org, kamezawa.hiroyu@jp.fujitsu.com,
       eike-kernel@sf-tec.de
Subject: Re: [PATCH 1/2] x86: ioremap: fix wrong physical address handling
References: <4C197A49.6020400@jp.fujitsu.com> <4C197A9E.5040509@jp.fujitsu.com> <20100617025052.GH9298@parisc-linux.org>
In-Reply-To: <20100617025052.GH9298@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/17 11:50), Matthew Wilcox wrote:
> On Thu, Jun 17, 2010 at 10:30:06AM +0900, Kenji Kaneshige wrote:
>> Index: linux-2.6.34/arch/x86/mm/ioremap.c
>> ===================================================================
>> --- linux-2.6.34.orig/arch/x86/mm/ioremap.c	2010-06-15 04:43:00.978332015 +0900
>> +++ linux-2.6.34/arch/x86/mm/ioremap.c	2010-06-15 05:32:59.291693007 +0900
>> @@ -62,8 +62,8 @@
>>   static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>>   		unsigned long size, unsigned long prot_val, void *caller)
>>   {
>> -	unsigned long pfn, offset, vaddr;
>> -	resource_size_t last_addr;
>> +	unsigned long offset, vaddr;
>> +	resource_size_t pfn, last_pfn, last_addr;
>
> I have a hard time understanding this change.  pfn is always a physical
> address shifted by PAGE_SHIFT.  So a 32-bit pfn supports up to 44-bit
> physical addresses.  Are your addresses above 44-bits?
>
>> @@ -115,7 +113,7 @@
>>   	 * Mappings have to be page-aligned
>>   	 */
>>   	offset = phys_addr&  ~PAGE_MASK;
>> -	phys_addr&= PAGE_MASK;
>> +	phys_addr = (phys_addr>>  PAGE_SHIFT)<<  PAGE_SHIFT;
>
> I'd rather see PAGE_MASK fixed.  Would this work?
>
>   #define PAGE_SIZE       (_AC(1,UL)<<  PAGE_SHIFT)
> -#define PAGE_MASK       (~(PAGE_SIZE-1))
> +#define PAGE_MASK       (~(PAGE_SIZE-1ULL))
>

I think it should work. But I'm worrying about regressions.
Now I think using PHYSICAL_PAGE_MASK (as my v.1 patch did) is good idea
again. What do you think about this?

Thanks,
Kenji Kaneshige

