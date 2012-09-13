Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2IMJSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:18:08 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40771 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2IMJRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:17:01 -0400
Message-ID: <5051A481.3090901@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2012 17:16:49 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] thp: move release mmap_sem lock out of khugepaged_alloc_page
References: <50508632.9090003@linux.vnet.ibm.com> <50508689.50904@linux.vnet.ibm.com> <20120912151844.a2f17f98.akpm@linux-foundation.org>
In-Reply-To: <20120912151844.a2f17f98.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091309-5490-0000-0000-00000220F12B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 06:18 AM, Andrew Morton wrote:
> On Wed, 12 Sep 2012 20:56:41 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> To make the code more clear, move release the lock out of khugepaged_alloc_page
>>
>> ...
>>
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1854,11 +1854,6 @@ static struct page
>>  	*hpage  = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
>>  				      node, __GFP_OTHER_NODE);
>>
>> -	/*
>> -	 * After allocating the hugepage, release the mmap_sem read lock in
>> -	 * preparation for taking it in write mode.
>> -	 */
>> -	up_read(&mm->mmap_sem);
>>  	if (unlikely(!*hpage)) {
>>  		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
>>  		*hpage = ERR_PTR(-ENOMEM);
>> @@ -1905,7 +1900,6 @@ static struct page
>>  		       struct vm_area_struct *vma, unsigned long address,
>>  		       int node)
>>  {
>> -	up_read(&mm->mmap_sem);
>>  	VM_BUG_ON(!*hpage);
>>  	return  *hpage;
>>  }
>> @@ -1931,8 +1925,14 @@ static void collapse_huge_page(struct mm_struct *mm,
>>
>>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>>
>> -	/* release the mmap_sem read lock. */
>>  	new_page = khugepaged_alloc_page(hpage, mm, vma, address, node);
>> +
>> +	/*
>> +	 * After allocating the hugepage, release the mmap_sem read lock in
>> +	 * preparation for taking it in write mode.
>> +	 */
>> +	up_read(&mm->mmap_sem);
>> +
>>  	if (!new_page)
>>  		return;
> 
> Well that's a pretty minor improvement: one still has to go off on a
> big hunt to locate the matching down_read().
> 
> And the patch will increase mmap_sem hold times by a teeny amount.  Do
> we really want to do this?

Andrew,

This is why i did in the previous patch (the lock is released in alloc function),
but as you noticed, this is really teeny overload after this patch - only increase
the load of count_vm_event() which operates a cpu-local variable. And, before i
posted this patch, i did kerbench test, no regression was found.

The another approach is, let the function name indicate the lock will be released,
how about just change the function name to khugepaged_alloc_page_release_lock?






