Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851Ab2J2Cmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 22:42:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748Ab2J2Cmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 22:42:52 -0400
Message-ID: <508DEDA2.9030503@redhat.com>
Date: Mon, 29 Oct 2012 10:44:50 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 00/31] numa/core patches
References: <20121025121617.617683848@chello.nl> <508A52E1.8020203@redhat.com> <1351242480.12171.48.camel@twins> <20121028175615.GC29827@cmpxchg.org>
In-Reply-To: <20121028175615.GC29827@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 01:56 AM, Johannes Weiner wrote:
> On Fri, Oct 26, 2012 at 11:08:00AM +0200, Peter Zijlstra wrote:
>> On Fri, 2012-10-26 at 17:07 +0800, Zhouping Liu wrote:
>>> [  180.918591] RIP: 0010:[<ffffffff8118c39a>]  [<ffffffff8118c39a>] mem_cgroup_prepare_migration+0xba/0xd0
>>> [  182.681450]  [<ffffffff81183b60>] do_huge_pmd_numa_page+0x180/0x500
>>> [  182.775090]  [<ffffffff811585c9>] handle_mm_fault+0x1e9/0x360
>>> [  182.863038]  [<ffffffff81632b62>] __do_page_fault+0x172/0x4e0
>>> [  182.950574]  [<ffffffff8101c283>] ? __switch_to_xtra+0x163/0x1a0
>>> [  183.041512]  [<ffffffff8101281e>] ? __switch_to+0x3ce/0x4a0
>>> [  183.126832]  [<ffffffff8162d686>] ? __schedule+0x3c6/0x7a0
>>> [  183.211216]  [<ffffffff81632ede>] do_page_fault+0xe/0x10
>>> [  183.293705]  [<ffffffff8162f518>] page_fault+0x28/0x30
>> Johannes, this looks like the thp migration memcg hookery gone bad,
>> could you have a look at this?
> Oops.  Here is an incremental fix, feel free to fold it into #31.

Hi Johannes,

Tested the below patch, and I'm sure it has fixed the above issue, thank 
you.

  Zhouping

>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5c30a14..0d7ebd3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -801,8 +801,6 @@ void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
>   	if (!new_page)
>   		goto alloc_fail;
>   
> -	mem_cgroup_prepare_migration(page, new_page, &memcg);
> -
>   	lru = PageLRU(page);
>   
>   	if (lru && isolate_lru_page(page)) /* does an implicit get_page() */
> @@ -835,6 +833,14 @@ void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
>   
>   		return;
>   	}
> +	/*
> +	 * Traditional migration needs to prepare the memcg charge
> +	 * transaction early to prevent the old page from being
> +	 * uncharged when installing migration entries.  Here we can
> +	 * save the potential rollback and start the charge transfer
> +	 * only when migration is already known to end successfully.
> +	 */
> +	mem_cgroup_prepare_migration(page, new_page, &memcg);
>   
>   	entry = mk_pmd(new_page, vma->vm_page_prot);
>   	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> @@ -845,6 +851,12 @@ void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
>   	set_pmd_at(mm, haddr, pmd, entry);
>   	update_mmu_cache_pmd(vma, address, entry);
>   	page_remove_rmap(page);
> +	/*
> +	 * Finish the charge transaction under the page table lock to
> +	 * prevent split_huge_page() from dividing up the charge
> +	 * before it's fully transferred to the new page.
> +	 */
> +	mem_cgroup_end_migration(memcg, page, new_page, true);
>   	spin_unlock(&mm->page_table_lock);
>   
>   	put_page(page);			/* Drop the rmap reference */
> @@ -856,18 +868,14 @@ void do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
>   
>   	unlock_page(new_page);
>   
> -	mem_cgroup_end_migration(memcg, page, new_page, true);
> -
>   	unlock_page(page);
>   	put_page(page);			/* Drop the local reference */
>   
>   	return;
>   
>   alloc_fail:
> -	if (new_page) {
> -		mem_cgroup_end_migration(memcg, page, new_page, false);
> +	if (new_page)
>   		put_page(new_page);
> -	}
>   
>   	unlock_page(page);
>   
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7acf43b..011e510 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3255,15 +3255,18 @@ void mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
>   				  struct mem_cgroup **memcgp)
>   {
>   	struct mem_cgroup *memcg = NULL;
> +	unsigned int nr_pages = 1;
>   	struct page_cgroup *pc;
>   	enum charge_type ctype;
>   
>   	*memcgp = NULL;
>   
> -	VM_BUG_ON(PageTransHuge(page));
>   	if (mem_cgroup_disabled())
>   		return;
>   
> +	if (PageTransHuge(page))
> +		nr_pages <<= compound_order(page);
> +
>   	pc = lookup_page_cgroup(page);
>   	lock_page_cgroup(pc);
>   	if (PageCgroupUsed(pc)) {
> @@ -3325,7 +3328,7 @@ void mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
>   	 * charged to the res_counter since we plan on replacing the
>   	 * old one and only one page is going to be left afterwards.
>   	 */
> -	__mem_cgroup_commit_charge(memcg, newpage, 1, ctype, false);
> +	__mem_cgroup_commit_charge(memcg, newpage, nr_pages, ctype, false);
>   }
>   
>   /* remove redundant charge if migration failed*/

