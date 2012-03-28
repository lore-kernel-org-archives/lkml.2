Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab2C1Ri7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:38:59 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:49608 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab2C1Ri5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:38:57 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 08/10] hugetlbfs: Add a list for tracking in-use HugeTLB pages
In-Reply-To: <20120328135845.GH20949@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120328135845.GH20949@tiehlicka.suse.cz>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 28 Mar 2012 23:08:34 +0530
Message-ID: <87vclo1v8l.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12032807-5490-0000-0000-00000108B888
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Fri 16-03-12 23:09:28, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> hugepage_activelist will be used to track currently used HugeTLB pages.
>> We need to find the in-use HugeTLB pages to support memcg removal.
>> On memcg removal we update the page's memory cgroup to point to
>> parent cgroup.
>> 
>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>  include/linux/hugetlb.h |    1 +
>>  mm/hugetlb.c            |   23 ++++++++++++++++++-----
>>  2 files changed, 19 insertions(+), 5 deletions(-)
>> 
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index cbd8dc5..6919100 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
> [...]
>> @@ -2319,14 +2322,24 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>>  		page = pte_page(pte);
>>  		if (pte_dirty(pte))
>>  			set_page_dirty(page);
>> -		list_add(&page->lru, &page_list);
>> +
>> +		spin_lock(&hugetlb_lock);
>> +		list_move(&page->lru, &page_list);
>> +		spin_unlock(&hugetlb_lock);
>
> Why do we really need the spinlock here?


It does a list_del from hugepage_activelist.


>
>>  	}
>>  	spin_unlock(&mm->page_table_lock);
>>  	flush_tlb_range(vma, start, end);
>>  	mmu_notifier_invalidate_range_end(mm, start, end);
>>  	list_for_each_entry_safe(page, tmp, &page_list, lru) {
>>  		page_remove_rmap(page);
>> -		list_del(&page->lru);
>> +		/*
>> +		 * We need to move it back huge page active list. If we are
>> +		 * holding the last reference, below put_page will move it
>> +		 * back to free list.
>> +		 */
>> +		spin_lock(&hugetlb_lock);
>> +		list_move(&page->lru, &h->hugepage_activelist);
>> +		spin_unlock(&hugetlb_lock);
>
> This spinlock usage doesn't look nice but I guess we do not have many
> other options.
>

-aneesh

