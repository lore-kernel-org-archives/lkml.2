Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0LHHzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:55:13 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:44032 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0LHHzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:55:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vU6XTd7XWhuuN/2vQJzWr7lMrdc2SmHatABoTZ5VPQgS/9550BZ2z9fTdephF73sfT
         hH21XpKffEAiNEZ2LdOZ3d8lx6Oi5VuTj53VoxME4OyyRJaFe+7DXV+98W5r0BbZzSLX
         3RPpyPKCzfRTxJfiAh+eR6nyntw62U2rxF028=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1012072258420.5260@sister.anvils>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<ca25c4e33beceeb3a96e8437671e5e0a188602fa.1291568905.git.minchan.kim@gmail.com>
	<alpine.LSU.2.00.1012062027100.8572@tigran.mtv.corp.google.com>
	<AANLkTindkfPJxxjR-nVy+Tmu6Q=fs2c=KOmdOQyfXaCP@mail.gmail.com>
	<alpine.LSU.2.00.1012072258420.5260@sister.anvils>
Date: Wed, 8 Dec 2010 16:55:11 +0900
Message-ID: <AANLkTinx6wBUxQKWeCfcLbqB60qvTFWd8EHS0cGTj-Ma@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] Prevent activation of page in madvise_dontneed
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 4:26 PM, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 7 Dec 2010, Minchan Kim wrote:
>>
>> How about this? Although it doesn't remove null dependency, it meet my
>> goal without big overhead.
>> It's just quick patch.
>
> Roughly, yes; by "just quick patch" I take you to mean that I should
> not waste time on all the minor carelessnesses scattered through it.
>
>> If you agree, I will resend this version as formal patch.
>> (If you suffered from seeing below word-wrapped source, see the
>> attachment. I asked to google two time to support text-plain mode in
>> gmail web but I can't receive any response until now. ;(. Lots of
>> kernel developer in google. Please support this mode for us who can't
>> use SMTP although it's a very small VOC)
>
> Tiresome.  Seems not to be high on gmail's priorities.
> It's sad to see even Linus attaching patches these days.

That encourages me(But I don't mean I will use attachment again. :)).

>
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index e097df6..14ae918 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -771,6 +771,7 @@ struct zap_details {
>>         pgoff_t last_index;                     /* Highest page->index
>> to unmap */
>>         spinlock_t *i_mmap_lock;                /* For unmap_mapping_range: */
>>         unsigned long truncate_count;           /* Compare vm_truncate_count */
>> +       int ignore_reference;
>>  };
>>
>>  struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 319528b..fdb0253 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -162,18 +162,22 @@ static long madvise_dontneed(struct vm_area_struct * vma,
>>                              struct vm_area_struct ** prev,
>>                              unsigned long start, unsigned long end)
>>  {
>> +       struct zap_details details ;
>> +
>>         *prev = vma;
>>         if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
>>                 return -EINVAL;
>>
>>         if (unlikely(vma->vm_flags & VM_NONLINEAR)) {
>> -               struct zap_details details = {
>> -                       .nonlinear_vma = vma,
>> -                       .last_index = ULONG_MAX,
>> -               };
>> -               zap_page_range(vma, start, end - start, &details);
>> -       } else
>> -               zap_page_range(vma, start, end - start, NULL);
>> +               details.nonlinear_vma = vma;
>> +               details.last_index = ULONG_MAX;
>> +       } else {
>> +               details.nonlinear_vma = NULL;
>> +               details.last_index = NULL;
>> +       }
>> +
>> +       details.ignore_references = true;
>> +       zap_page_range(vma, start, end - start, &details);
>>         return 0;
>>  }
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index ebfeedf..d46ac42 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -897,9 +897,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>         pte_t *pte;
>>         spinlock_t *ptl;
>>         int rss[NR_MM_COUNTERS];
>> -
>> +       bool ignore_reference = false;
>>         init_rss_vec(rss);
>>
>> +       if (details && ((!details->check_mapping && !details->nonlinear_vma)
>> +                                        || !details->ignore_reference))
>> +               details = NULL;
>> +
>
>        bool mark_accessed = true;
>
>        if (VM_SequentialReadHint(vma) ||
>            (details && details->ignore_reference))
>                mark_accessed = false;
>        if (details && !details->check_mapping && !details->nonlinear_vma)
>                details = NULL;
>
>
>>         pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
>>         arch_enter_lazy_mmu_mode();
>>         do {
>> @@ -949,7 +955,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>>                                 if (pte_dirty(ptent))
>>                                         set_page_dirty(page);
>>                                 if (pte_young(ptent) &&
>> -                                   likely(!VM_SequentialReadHint(vma)))
>> +                                   likely(!VM_SequentialReadHint(vma)) &&
>> +                                   likely(!ignore_reference))
>>                                         mark_page_accessed(page);
>
>                                if (pte_young(ptent) && mark_accessed)
>                                        mark_page_accessed(page);
>
>

Much clean.

>>                                 rss[MM_FILEPAGES]--;
>>                         }
>> @@ -1038,8 +1045,6 @@ static unsigned long unmap_page_range(struct
>> mmu_gather *tlb,
>>         pgd_t *pgd;
>>         unsigned long next;
>>
>> -       if (details && !details->check_mapping && !details->nonlinear_vma)
>> -               details = NULL;
>>
>>         BUG_ON(addr >= end);
>>         mem_cgroup_uncharge_start();
>> @@ -1102,7 +1107,8 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
>>         unsigned long tlb_start = 0;    /* For tlb_finish_mmu */
>>         int tlb_start_valid = 0;
>>         unsigned long start = start_addr;
>> -       spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
>> +       spinlock_t *i_mmap_lock = details ?
>> +               (detais->check_mapping ? details->i_mmap_lock: NULL) : NULL;
>
> Why that change?

It has done very careless. Sorry for that. I thought i_mmap_lock
always is used with check_mapping. Clear wrong!
My concern is that if we don't have such routine, caller use only
ingore_reference should initialize i_mmap_lock with NULL.
It's bad.

Hmm...

>
> Hugh
>



-- 
Kind regards,
Minchan Kim
