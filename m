Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0HQCnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:43:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58643 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0HQCnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:43:11 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C69F758.5030300@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 11:43:36 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        ACPI <linux-acpi@vger.kernel.org>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] [Patch-next] ACPI, APEI Fix the return value(==NULL)
 of acpi_pre_map always.
References: <4C69DE57.9070608@np.css.fujitsu.com> <1282009063.2744.1495.camel@yhuang-dev>
In-Reply-To: <1282009063.2744.1495.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/17 10:37), Huang Ying wrote:
> On Tue, 2010-08-17 at 08:56 +0800, Jin Dongming wrote:
>> acpi_pre_map() is used for remapping the physical address of I/O, so
>> it should be return NULL or remapped virtual address. The problem
>> is whether I/O remapping is successful or not, the function returns
>> NULL always.
> 
> No. NULL is returned for error path only. Please check the code again.

There three places used the local variable vaddr in acpi_pre_map() in next-tree.
   1. 115         vaddr = __acpi_try_ioremap(paddr, size);
   2. 122         vaddr = ioremap(pg_off, pg_sz);
   3. 135         vaddr = __acpi_try_ioremap(paddr, size);

Let's think about the following statement.
   Assumption: the physical address has never been remapped.
   Step:
       1. vaddr == NULL
          Because the physical address is not registered in the acpi_iomaps,
          it should be returned NULL from __acpi_try_ioremap().

       2. vaddr == the virtual address of the physical address.
          Here if ioremap is successful, the value of vaddr should be 
          the virtual address returned from ioremap().

       3. vaddr == NULL                <== IMPORTANT
          Here it is because the physical address has not been registered
          in the acpi_iomaps yet, it still return NULL from __acpi_try_ioremap().
          So it is why vaddr == NULL, even if the physical address has never
          been remapped.

    Result: vaddr == NULL.

And if the vaddr is not NULL, it could not be added into acpi_iomaps.
Codes in acpi_pre_map() is like following.

134         spin_lock_irqsave(&acpi_iomaps_lock, flags);
135         vaddr = __acpi_try_ioremap(paddr, size);           <== the 3rd step
136         if (vaddr) {
137                 spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
138                 iounmap(map->vaddr);
139                 kfree(map);
140                 return vaddr;
141         }
142         list_add_tail_rcu(&map->list, &acpi_iomaps);      <== add into acpi_iomaps.
143         spin_unlock_irqrestore(&acpi_iomaps_lock, flags);

> 
>> In acpi_pre_map(), after the physical address is remapped sucessfully,
>> it will check whether the physical address has been added into acpi_iomaps
>> list again. If the physical address has beed added into acpi_iomaps,
>> the virtual address will be saved in vaddr. Otherwise, NULL be saved in
>> vaddr.
>>
>> So if the physical address has never been remapped, the return value of
>> acpi_pre_map will be NULL always.
>>
>> This patch fixed it and I confirmed it on x86_64 next-tree.
>>
>> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
>> ---
>>  drivers/acpi/atomicio.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/atomicio.c b/drivers/acpi/atomicio.c
>> index 8f8bd73..1bc2614 100644
>> --- a/drivers/acpi/atomicio.c
>> +++ b/drivers/acpi/atomicio.c
>> @@ -133,7 +133,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
>>  
>>  	spin_lock_irqsave(&acpi_iomaps_lock, flags);
>>  	vaddr = __acpi_try_ioremap(paddr, size);
>> -	if (vaddr) {
>> +	if (unlikely(vaddr)) {
> 
> pre_map is not performance critical, so "unlikely" here helps little.
> 
>>  		spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
>>  		iounmap(map->vaddr);
>>  		kfree(map);
>> @@ -142,7 +142,7 @@ static void __iomem *acpi_pre_map(phys_addr_t paddr,
>>  	list_add_tail_rcu(&map->list, &acpi_iomaps);
>>  	spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
>>  
>> -	return vaddr + (paddr - pg_off);
>> +	return map->vaddr + (paddr - pg_off);
>>  err_unmap:
>>  	iounmap(vaddr);
>>  	return NULL;
> 
> When will vaddr != map->vaddr?
> 
> Best Regards,
> Huang Ying
> 
> 
> 
> 


