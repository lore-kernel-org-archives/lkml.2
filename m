Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2CHHvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:51:12 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43659 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2CHHvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:51:08 -0500
Message-ID: <4F5864E2.3090509@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2012 15:50:58 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
References: <20120308175307.b295b1013728a5666fe4571a@canb.auug.org.au> <20120307233220.5a76aa3c.akpm@linux-foundation.org> <20120308184105.5b03ec90bcddf90562181277@canb.auug.org.au> <20120307235012.847af577.akpm@linux-foundation.org>
In-Reply-To: <20120307235012.847af577.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030807-5564-0000-0000-000001B75AED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 03:50 PM, Andrew Morton wrote:

> On Thu, 8 Mar 2012 18:41:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Andrew,
>>
>> On Wed, 7 Mar 2012 23:32:20 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>> Actually they're different.  I reworked the earlier patch as below.
>>
>> OK.  But some comments.
>>
>>> diff -puN arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown arch/x86/mm/hugetlbpage.c
>>> --- a/arch/x86/mm/hugetlbpage.c~hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown
>>> +++ a/arch/x86/mm/hugetlbpage.c
>>> @@ -308,7 +308,7 @@ static unsigned long hugetlb_get_unmappe
>>>  {
>>>  	struct hstate *h = hstate_file(file);
>>>  	struct mm_struct *mm = current->mm;
>>> -	struct vm_area_struct *vma, *prev_vma;
>>> +	struct vm_area_struct *vma;
>>
>> You still remove prev_vma ...
>>
>>>  	unsigned long base = mm->mmap_base, addr = addr0;
>>>  	unsigned long largest_hole = mm->cached_hole_size;
>>>  	int first_time = 1;
>>> @@ -334,25 +334,16 @@ try_again:
>>>  		 * i.e. return with success:
>>>  		 */
>>>  		vma = find_vma(mm, addr);
>>> -		if (!vma)
>>> -			return addr;
>>> -
>>> -		/*
>>> -		 * new region fits between prev_vma->vm_end and
>>> -		 * vma->vm_start, use it:
>>> -		 */
>>> -		prev_vma = vma->vm_prev;
>>> -		if (addr + len <= vma->vm_start &&
>>> -		            (!prev_vma || (addr >= prev_vma->vm_end))) {
>>> +		if (vma)
>>> +			prev_vma = vma->vm_prev;
>>
>> But then assign to it ...
>>
>>> +		if (!vma || addr + len <= vma->vm_start) {
>>>  			/* remember the address as a hint for next time */
>>>  		        mm->cached_hole_size = largest_hole;
>>>  		        return (mm->free_area_cache = addr);
>>> -		} else {
>>> +		} else if (mm->free_area_cache == vma->vm_end) {
>>>  			/* pull free_area_cache down to the first hole */
>>> -		        if (mm->free_area_cache == vma->vm_end) {
>>> -				mm->free_area_cache = vma->vm_start;
>>> -				mm->cached_hole_size = largest_hole;
>>> -			}
>>> +			mm->free_area_cache = vma->vm_start;
>>> +			mm->cached_hole_size = largest_hole;
>>>  		}
>>>  
>>>  		/* remember the largest hole we saw so far */
>>
>> But it never gets used.
> 
> Doh.  The author reviewed that for me too!
> 
> I'll drop it - please rework, retest and resend?


I am sorry, i will repost it!

