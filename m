Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2GZVCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:02:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab2GZVCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:02:09 -0400
Message-ID: <5011AFEC.2040609@redhat.com>
Date: Thu, 26 Jul 2012 17:00:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] mm: hugetlbfs: Close race during teardown of hugetlbfs
 shared page tables v2
References: <20120720134937.GG9222@suse.de>
In-Reply-To: <20120720134937.GG9222@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 09:49 AM, Mel Gorman wrote:
> This V2 is still the mmap_sem approach that fixes a potential deadlock
> problem pointed out by Michal.

Larry and I were looking around the hugetlb code some
more, and found what looks like yet another race.

In hugetlb_no_page, we have the following code:


         spin_lock(&mm->page_table_lock);
         size = i_size_read(mapping->host) >> huge_page_shift(h);
         if (idx >= size)
                 goto backout;

         ret = 0;
         if (!huge_pte_none(huge_ptep_get(ptep)))
                 goto backout;

         if (anon_rmap)
                 hugepage_add_new_anon_rmap(page, vma, address);
         else
                 page_dup_rmap(page);
         new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
                                 && (vma->vm_flags & VM_SHARED)));
         set_huge_pte_at(mm, address, ptep, new_pte);
	...
	spin_unlock(&mm->page_table_lock);

Notice how we check !huge_pte_none with our own
mm->page_table_lock held.

This offers no protection at all against other
processes, that also hold their own page_table_lock.

In short, it looks like it is possible for multiple
processes to go through the above code simultaneously,
potentially resulting in:

1) one process overwriting the pte just created by
    another process

2) data corruption, as one partially written page
    gets superceded by an newly zeroed page, but no
    TLB invalidates get sent to other CPUs

3) a memory leak of a huge page

Is there anything that would make this race impossible,
or is this a real bug?

If so, are there more like it in the hugetlbfs code?
