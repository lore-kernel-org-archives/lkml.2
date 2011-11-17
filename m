Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1KQBAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:00:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:32884 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab1KQBAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:00:35 -0500
Message-ID: <4EC45CAE.1000704@gmail.com>
Date: Wed, 16 Nov 2011 17:00:30 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] hugetlb: Provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
References: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111161327180.16596@chino.kir.corp.google.com> <4EC43488.3070400@gmail.com> <alpine.DEB.2.00.1111161512371.16596@chino.kir.corp.google.com> <4EC44AD0.5070800@gmail.com> <alpine.DEB.2.00.1111161552450.25089@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111161552450.25089@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 04:08 PM, David Rientjes wrote:
> On Wed, 16 Nov 2011, David Daney wrote:
>
>>>>>> This is required now to get MIPS kernels to compile with
>>>>>> !CONFIG_HUGETLB_PAGE.
>>>>>>
>>>>>
>>>>> Why?
>>>>
>>>> I should have been more specific.  The failure is in Ralf's
>>>> mips-for-linux-next branch.
>>>>
>>>
>>> I can't find that branch (it's not in Ralf's tree at git.kernel.org), so
>>> I'm looking at next-20111116.  It doesn't compile for mips for other
>>> reasons related to arch/mips/sgi-ip22/ip22-gio.c.
>>
>> Ralf's various trees are accessible via linux-mips.org
>>
>
> Wow, we've certainly gone a long way from a patch that appears to be
> fixing a problem in Linus' tree based on your commit message.  You're
> working from ralf/upstream-sfr.git#mips-for-linux-next from
> git.linux-mips.org.
>

Yes, as I already said, I should have been more specific about this.

> Might want to have mentioned that for a patch labeled "hugetlb".
>
>>> Which is wrong.  MIPS code should not be using HPAGE_SHIFT without
>>> CONFIG_HUGETLB_PAGE and in fact defines it itself for such a configuration
>>> in arch/mips/include/asm/page.h.  The only generic uses are in
>>> page_alloc.c where we need CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, which isn't
>>> available on mips, and in mm/hugetlb.c which requires CONFIG_HUGETLB_PAGE
>>> by way of CONFIG_HUGETLBFS.
>>>
>>> So feel free to show the actual compile error this time and I'll suggest a
>>> mips fix for it.
>>
>> arch/mips/mm/tlb-r4k.c: In function ‘local_flush_tlb_range’:
>> arch/mips/mm/tlb-r4k.c:129:28: error: ‘HPAGE_SHIFT’ undeclared (first use in
>> this function)
>>
>
> Do you see where that file has #ifdef's for CONFIG_HUGETLB_PAGE?

Yes I see that.  With git annotate we can even see who wrote it.

The code would be much cleaner if that #ifdef were removed.  The author 
was unaware that a dummy version of pmd_huge() existed in hugetlb.h, 
making the entire if(pmd_huge()) huge block dead code.

I will prepare a patch that gets rid of the #ifdef CONFIG_HUGETLB_PAGE 
in that file.

>  You need
> them here too.  The problem is that is_vm_hugetlb_page() is not #define to
> 0 for CONFIG_HUGETLB_PAGE=n so the clauses using HPAGE_* aren't compiled
> out like the author is expecting.
>
>> However, I call B.S. on your reasoning.
>>
>> It is a well established kernel idiom to supply dummy values for symbols that
>> are required to be defined in order to form a syntactically correct C program,
>> but that are known by the programmer to be used only on dead code paths.
>>
>> This is exactly what we are doing here.
>>
>> To do otherwise requires that code be cluttered with #ifdefery.
>>
>
> You're wrong,

Ok, then please tell me why:

1) the dummy version of is_vm_hugetlb_page() exists in hugetlb_inline.h?
2) the dummy version of PageHuge() exists in hugetlb.h
3) the dummy version of reset_vma_resv_huge_pages()
4) the dummy version of hugetlb_total_pages() exists in hugetlb.h
5) the dummy version of follow_hugetlb_page() exists in hugetlb.h
6) the dummy version of follow_huge_addr() exists in hugetlb.h
7) the dummy version of copy_hugetlb_page_range() exists in hugetlb.h
8) the dummy version of hugetlb_prefault() exists in hugetlb.h
9) the dummy version of unmap_hugepage_range() exists in hugetlb.h
10) the dummy version of hugetlb_report_meminfo() exists in hugetlb.h
11) the dummy version of hugetlb_report_node_meminfo() exists in hugetlb.h
12) the dummy version of follow_huge_pmd() exists in hugetlb.h
13) the dummy version of follow_huge_pud() exists in hugetlb.h
14) the dummy version of prepare_hugepage_range() exists in hugetlb.h
15) the dummy version of pmd_huge() exists in hugetlb.h
16) the dummy version of pud_huge() exists in hugetlb.h
17) the dummy version of is_hugepage_only_range() exists in hugetlb.h
17) the dummy version of hugetlb_free_pgd_range() exists in hugetlb.h
18) the dummy version of hugetlb_fault() exists in hugetlb.h
19) the dummy version of huge_pte_offset() exists in hugetlb.h
20) the dummy version of dequeue_hwpoisoned_huge_page() exists in hugetlb.h
21) the dummy version of copy_huge_page() exists in hugetlb.h
22) the dummy version of hugetlb_change_protection() exists in hugetlb.h
.
.
.
[Other non HUGETLB_PAGE examples omitted for conciseness]

> nobody should be using HPAGE_SHIFT unless they are working
> with hugepages and, in fact, that code that placed those "dummy values"
> for HPAGE_MASK and HPAGE_SIZE there has since been removed since 2005.
>
> Defining HPAGE_SHIFT to be PAGE_SHIFT is just stupid and doing so may
> allow the program to compile but will hide real bugs later on.  In
> fact if you merged your patch, it would be a bug since the vma would have
> VM_HUGETLB but you'd now be operating on PAGE_SIZE pages!
>
> Like I said, we should be removing those existing definitions of
> HPAGE_MASK and HPAGE_SIZE rather than leaving them so someone like you can
> come along and pretend there's any legitimacy to them whatsoever and
> extend the insanity.
>
> You may not realize it, but changes to include/linux/hugetlb.h go through
> Andrew; Ralf won't be merging anything into this generic header file
> because of a mips problem.

Indeed, you may not realize that akpm has been on the to or cc list for 
this entire thread because I explicitly put him there for this exact reason.

Thanks,
David Daney

