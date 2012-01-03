Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2ACVGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 16:06:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53962 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2ACVG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 16:06:27 -0500
Message-ID: <4F036DD4.2060709@jp.fujitsu.com>
Date: Tue, 03 Jan 2012 16:06:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: n-horiguchi@ah.jp.nec.com
CC: kosaki.motohiro@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org,
        rientjes@google.com, andi@firstfloor.org, fengguang.wu@intel.com,
        aarcange@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pagemap: avoid splitting thp when reading /proc/pid/pagemap
References: <1324506228-18327-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324506228-18327-2-git-send-email-n-horiguchi@ah.jp.nec.com> <4EFD3266.4080701@gmail.com> <4F035FF6.7020206@ah.jp.nec.com>
In-Reply-To: <4F035FF6.7020206@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/2012 3:07 PM, Naoya Horiguchi wrote:
> Hi,
> 
> Thank you for your reviewing.
> 
> On Thu, Dec 29, 2011 at 10:39:18PM -0500, KOSAKI Motohiro wrote:
> ...
>>> --- 3.2-rc5.orig/fs/proc/task_mmu.c
>>> +++ 3.2-rc5/fs/proc/task_mmu.c
>>> @@ -600,6 +600,9 @@ struct pagemapread {
>>>   	u64 *buffer;
>>>   };
>>>
>>> +#define PAGEMAP_WALK_SIZE	(PMD_SIZE)
>>> +#define PAGEMAP_WALK_MASK	(PMD_MASK)
>>> +
>>>   #define PM_ENTRY_BYTES      sizeof(u64)
>>>   #define PM_STATUS_BITS      3
>>>   #define PM_STATUS_OFFSET    (64 - PM_STATUS_BITS)
>>> @@ -658,6 +661,22 @@ static u64 pte_to_pagemap_entry(pte_t pte)
>>>   	return pme;
>>>   }
>>>
>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +static u64 thp_pte_to_pagemap_entry(pte_t pte, int offset)
>>> +{
>>> +	u64 pme = 0;
>>> +	if (pte_present(pte))
>>
>> When does pte_present() return 0?
> 
> It does when the page pointed to by pte is swapped-out, under page migration,
> or HWPOISONed. But currenly it can't happen on thp because thp will be
> splitted before these operations are processed.
> So this if-sentense is not necessary for now, but I think it's not a bad idea
> to put it now to prepare for future implementation.

You certainly need to add a comment. otherwise you add *unnecessary* complexity
and people is going to be puzzled.


>>> +				pfn = thp_pte_to_pagemap_entry(*(pte_t *)pmd,
>>> +							       offset);
>>
>> This (pte_t*) cast looks introduce new implicit assumption. Please don't
>> put x86 assumption here directly.
> 
> OK, I think it's better to write a separate patch for this job because
> similar assumption is used in smaps_pte_range() and gather_pte_stats().

Sound sane.


>>> +	} else {
>>> +		spin_unlock(&walk->mm->page_table_lock);
>>> +	}
>>
>> coding standard violation. plz run check_patch.pl.
> 
> checkpatch.pl says nothing for here. According to Documentation/CodingStyle,
> "no braces for single statement" rule is not applicable for else-blocks with
> one statement if corresponding if-blocks have multiple statements.


ok
