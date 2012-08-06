Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2HFNhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:37:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42487 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab2HFNhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:37:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120806132410.GA6150@dhcp22.suse.cz>
References: <CAJd=RBC9HhKh5Q0-yXi3W0x3guXJPFz4BNsniyOFmp0TjBdFqg@mail.gmail.com>
	<20120806132410.GA6150@dhcp22.suse.cz>
Date: Mon, 6 Aug 2012 21:37:45 +0800
Message-ID: <CAJd=RBCuvpG49JcTUY+qw-tTdH_vFLgOfJDE3sW97+M04TR+hg@mail.gmail.com>
Subject: Re: [patch v2] hugetlb: correct page offset index for sharing pmd
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 9:24 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Sat 04-08-12 14:08:31, Hillf Danton wrote:
>> The computation of page offset index is incorrect to be used in scanning
>> prio tree, as huge page offset is required, and is fixed with well
>> defined routine.
>>
>> Changes from v1
>>       o s/linear_page_index/linear_hugepage_index/ for clearer code
>>       o hp_idx variable added for less change
>>
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/arch/x86/mm/hugetlbpage.c       Fri Aug  3 20:34:58 2012
>> +++ b/arch/x86/mm/hugetlbpage.c       Fri Aug  3 20:40:16 2012
>> @@ -62,6 +62,7 @@ static void huge_pmd_share(struct mm_str
>>  {
>>       struct vm_area_struct *vma = find_vma(mm, addr);
>>       struct address_space *mapping = vma->vm_file->f_mapping;
>> +     pgoff_t hp_idx;
>>       pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
>>                       vma->vm_pgoff;
>
> So we have two indexes now. That is just plain ugly!
>

Two indexes result in less code change here and no change
in page_table_shareable. Plus linear_hugepage_index tells
clearly readers that hp_idx and idx are different.

Anyway I have no strong opinion to keep
page_table_shareable unchanged, but prefer less changes.

Thanks,
              Hillf

>>       struct prio_tree_iter iter;
>> @@ -72,8 +73,10 @@ static void huge_pmd_share(struct mm_str
>>       if (!vma_shareable(vma, addr))
>>               return;
>>
>> +     hp_idx = linear_hugepage_index(vma, addr);
>> +
>>       mutex_lock(&mapping->i_mmap_mutex);
>> -     vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
>> +     vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, hp_idx, hp_idx) {
>>               if (svma == vma)
>>                       continue;
>>
>> --
>
> --
> Michal Hocko
> SUSE Labs
