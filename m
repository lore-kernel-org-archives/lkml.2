Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0HQErQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:47:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50854 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0HQErP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:47:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C6A146C.5030807@np.css.fujitsu.com>
Date: Tue, 17 Aug 2010 13:47:40 +0900
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
References: <4C69DE57.9070608@np.css.fujitsu.com>	 <1282009063.2744.1495.camel@yhuang-dev>	 <4C69F758.5030300@np.css.fujitsu.com> <1282018540.2744.1505.camel@yhuang-dev>
In-Reply-To: <1282018540.2744.1505.camel@yhuang-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/08/17 13:15), Huang Ying wrote:
> On Tue, 2010-08-17 at 10:43 +0800, Jin Dongming wrote:
>> (2010/08/17 10:37), Huang Ying wrote:
>>> On Tue, 2010-08-17 at 08:56 +0800, Jin Dongming wrote:
>>>> acpi_pre_map() is used for remapping the physical address of I/O, so
>>>> it should be return NULL or remapped virtual address. The problem
>>>> is whether I/O remapping is successful or not, the function returns
>>>> NULL always.
>>>
>>> No. NULL is returned for error path only. Please check the code again.
>>
>> There three places used the local variable vaddr in acpi_pre_map() in next-tree.
>>    1. 115         vaddr = __acpi_try_ioremap(paddr, size);
>>    2. 122         vaddr = ioremap(pg_off, pg_sz);
>>    3. 135         vaddr = __acpi_try_ioremap(paddr, size);
>>
>> Let's think about the following statement.
>>    Assumption: the physical address has never been remapped.
>>    Step:
>>        1. vaddr == NULL
>>           Because the physical address is not registered in the acpi_iomaps,
>>           it should be returned NULL from __acpi_try_ioremap().
>>
>>        2. vaddr == the virtual address of the physical address.
>>           Here if ioremap is successful, the value of vaddr should be 
>>           the virtual address returned from ioremap().
>>
>>        3. vaddr == NULL                <== IMPORTANT
>>           Here it is because the physical address has not been registered
>>           in the acpi_iomaps yet, it still return NULL from __acpi_try_ioremap().
>>           So it is why vaddr == NULL, even if the physical address has never
>>           been remapped.
>>
>>     Result: vaddr == NULL.
> 
> return vaddr + (paddr - pg_off), is not NULL for common cases.
> 
>> And if the vaddr is not NULL, it could not be added into acpi_iomaps.
>> Codes in acpi_pre_map() is like following.
>>
>> 134         spin_lock_irqsave(&acpi_iomaps_lock, flags);
>> 135         vaddr = __acpi_try_ioremap(paddr, size);           <== the 3rd step
>> 136         if (vaddr) {
>> 137                 spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
>> 138                 iounmap(map->vaddr);
>> 139                 kfree(map);
>> 140                 return vaddr;
>> 141         }
>> 142         list_add_tail_rcu(&map->list, &acpi_iomaps);      <== add into acpi_iomaps.
>> 143         spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
> 
> Oops, this is a bug, and your patch really fix it. But I think you
> should change the patch description. NULL is not returned in almost all
> cases. Because (paddr - pg_off) is not zero in common cases.
> 
> Best Regards,
> Huang Ying
> 
OK. I will modify the description of this patch and resend it.

Best Regards,
Jin Dongming
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


