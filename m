Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1H0CwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 22:52:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46469 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1H0CwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 22:52:10 -0400
Message-ID: <4E585B72.9070401@casparzhang.com>
Date: Sat, 27 Aug 2011 10:50:26 +0800
From: Caspar Zhang <caspar@casparzhang.com>
Organization: Red Hat Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110703 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm <linux-mm@kvack.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/mempolicy.c: fix pgoff in mbind vma merge
References: <14efb4b829a69f8c13d65de60a4508c0bbb0a5f5.1312212325.git.caspar@casparzhang.com> <20110826142328.ab4726cb.akpm@linux-foundation.org>
In-Reply-To: <20110826142328.ab4726cb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2011 05:23 AM, Andrew Morton wrote:
> On Mon,  1 Aug 2011 23:28:55 +0800
> Caspar Zhang<caspar@casparzhang.com>  wrote:
>
>> commit 9d8cebd4bcd7c3878462fdfda34bbcdeb4df7ef4 didn't real fix the
>> mbind vma merge problem due to wrong pgoff value passing to vma_merge(),
>> which made vma_merge() always return NULL.
>>
>> Re-tested the patched kernel with the reproducer provided in commit
>> 9d8cebd, got correct result like below:
>>
>> addr = 0x7ffa5aaa2000
>> [snip]
>> 7ffa5aaa2000-7ffa5aaa6000 rw-p 00000000 00:00 0
>> 7fffd556f000-7fffd5584000 rw-p 00000000 00:00 0                          [stack]
>>
>
> Please also describe the output before the patch is applied, and tell
> us what you believe is wrong with it?

Sure. Before the patch applied, we are getting a result like:

addr = 0x7fa58f00c000
[snip]
7fa58f00c000-7fa58f00d000 rw-p 00000000 00:00 0
7fa58f00d000-7fa58f00e000 rw-p 00000000 00:00 0
7fa58f00e000-7fa58f00f000 rw-p 00000000 00:00 0

here 7fa58f00c000->7fa58f00f000 we get 3 VMAs which are expected to be 
merged described in commit 9d8cebd.

commit 9d8cebd says:

-------------------------------------------------------------------
commit 9d8cebd4bcd7c3878462fdfda34bbcdeb4df7ef4
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Fri Mar 5 13:41:57 2010 -0800

     mm: fix mbind vma merge problem

     Strangely, current mbind() doesn't merge vma with neighbor vma 
although it's possible.
     Unfortunately, many vma can reduce performance...

     This patch fixes it.
-------------------------------------------------------------------

mbind_range() invokes vma_range() to merge current VMA with its successor:

	prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
			  vma->anon_vma, vma->vm_file, pgoff, new_pol);

in vma_merge(), it should go into:

	if (next && end == next->vm_start &&
  			mpol_equal(policy, vma_policy(next)) &&
			can_vma_merge_before(next, vm_flags,
					anon_vma, file, pgoff+pglen)) {
	...
	}

while in can_vma_merge_before(), we have:

static int
can_vma_merge_before(struct vm_area_struct *vma, unsigned long vm_flags,
	struct anon_vma *anon_vma, struct file *file, pgoff_t vm_pgoff)
{
	if (is_mergeable_vma(vma, file, vm_flags) &&
	    is_mergeable_anon_vma(anon_vma, vma->anon_vma, vma)) {
		if (vma->vm_pgoff == vm_pgoff)
			return 1;
	}
	return 0;
}

to make can_vma_merge_before() return 1, we should have (next->vm_pgoff 
== pgoff + pglen) in vma_merge(), i.e., pgoff should be the page offset 
of *current* VMA.

However from the current codes in mbind_range(), we get:

	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);

start is the beginning addr of the range, so here pgoff will always be 
the page offset of the beginning VMA, that makes merging VMAs impossible 
in mbind_range().

To solve this bug, we simply need to pass vma->pgoff instead of the 
calculated pgoff value to vma_merge().

Thanks,
Caspar

>
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -636,7 +636,6 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
>>   	struct vm_area_struct *prev;
>>   	struct vm_area_struct *vma;
>>   	int err = 0;
>> -	pgoff_t pgoff;
>>   	unsigned long vmstart;
>>   	unsigned long vmend;
>>
>> @@ -649,9 +648,9 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
>>   		vmstart = max(start, vma->vm_start);
>>   		vmend   = min(end, vma->vm_end);
>>
>> -		pgoff = vma->vm_pgoff + ((start - vma->vm_start)>>  PAGE_SHIFT);
>>   		prev = vma_merge(mm, prev, vmstart, vmend, vma->vm_flags,
>> -				  vma->anon_vma, vma->vm_file, pgoff, new_pol);
>> +				  vma->anon_vma, vma->vm_file, vma->vm_pgoff,
>> +				  new_pol);
>>   		if (prev) {
>>   			vma = prev;
>>   			next = vma->vm_next;
>> --
>> 1.7.6

