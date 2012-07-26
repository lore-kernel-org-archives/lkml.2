Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2GZVzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:55:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34433 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2GZVzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:55:40 -0400
Date: Thu, 26 Jul 2012 14:54:43 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Rik van Riel <riel@redhat.com>
cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.cz>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] mm: hugetlbfs: Close race during teardown of hugetlbfs
 shared page tables v2
In-Reply-To: <5011AFEC.2040609@redhat.com>
Message-ID: <alpine.LSU.2.00.1207261451180.1705@eggly.anvils>
References: <20120720134937.GG9222@suse.de> <5011AFEC.2040609@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, Rik van Riel wrote:
> On 07/20/2012 09:49 AM, Mel Gorman wrote:
> > This V2 is still the mmap_sem approach that fixes a potential deadlock
> > problem pointed out by Michal.
> 
> Larry and I were looking around the hugetlb code some
> more, and found what looks like yet another race.
> 
> In hugetlb_no_page, we have the following code:
> 
> 
>         spin_lock(&mm->page_table_lock);
>         size = i_size_read(mapping->host) >> huge_page_shift(h);
>         if (idx >= size)
>                 goto backout;
> 
>         ret = 0;
>         if (!huge_pte_none(huge_ptep_get(ptep)))
>                 goto backout;
> 
>         if (anon_rmap)
>                 hugepage_add_new_anon_rmap(page, vma, address);
>         else
>                 page_dup_rmap(page);
>         new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
>                                 && (vma->vm_flags & VM_SHARED)));
>         set_huge_pte_at(mm, address, ptep, new_pte);
> 	...
> 	spin_unlock(&mm->page_table_lock);
> 
> Notice how we check !huge_pte_none with our own
> mm->page_table_lock held.
> 
> This offers no protection at all against other
> processes, that also hold their own page_table_lock.
> 
> In short, it looks like it is possible for multiple
> processes to go through the above code simultaneously,
> potentially resulting in:
> 
> 1) one process overwriting the pte just created by
>    another process
> 
> 2) data corruption, as one partially written page
>    gets superceded by an newly zeroed page, but no
>    TLB invalidates get sent to other CPUs
> 
> 3) a memory leak of a huge page
> 
> Is there anything that would make this race impossible,
> or is this a real bug?

I believe it's protected by the unloved hugetlb_instantiation_mutex.

> 
> If so, are there more like it in the hugetlbfs code?

What, more than one bug in that code?
Surely that would defy the laws of probability ;)

Hugh
