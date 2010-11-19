Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab0KSBZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:25:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56941 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0KSBZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:25:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Nov 2010 10:19:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 39 of 66] memcg huge memory
Message-Id: <20101119101938.2edf889f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <877d2f205026b0463450.1288798094@v2.random>
References: <patchbomb.1288798055@v2.random>
	<877d2f205026b0463450.1288798094@v2.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Nov 2010 16:28:14 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Add memcg charge/uncharge to hugepage faults in huge_memory.c.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -233,6 +233,7 @@ static int __do_huge_pmd_anonymous_page(
>  	VM_BUG_ON(!PageCompound(page));
>  	pgtable = pte_alloc_one(mm, haddr);
>  	if (unlikely(!pgtable)) {
> +		mem_cgroup_uncharge_page(page);
>  		put_page(page);
>  		return VM_FAULT_OOM;
>  	}
> @@ -243,6 +244,7 @@ static int __do_huge_pmd_anonymous_page(
>  	spin_lock(&mm->page_table_lock);
>  	if (unlikely(!pmd_none(*pmd))) {
>  		spin_unlock(&mm->page_table_lock);
> +		mem_cgroup_uncharge_page(page);
>  		put_page(page);
>  		pte_free(mm, pgtable);
>  	} else {
> @@ -286,6 +288,10 @@ int do_huge_pmd_anonymous_page(struct mm
>  		page = alloc_hugepage(transparent_hugepage_defrag(vma));
>  		if (unlikely(!page))
>  			goto out;
> +		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
> +			put_page(page);
> +			goto out;
> +		}
>  
>  		return __do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page);
>  	}
> @@ -402,9 +408,15 @@ static int do_huge_pmd_wp_page_fallback(
>  	for (i = 0; i < HPAGE_PMD_NR; i++) {
>  		pages[i] = alloc_page_vma(GFP_HIGHUSER_MOVABLE,
>  					  vma, address);
> -		if (unlikely(!pages[i])) {
> -			while (--i >= 0)
> +		if (unlikely(!pages[i] ||
> +			     mem_cgroup_newpage_charge(pages[i], mm,
> +						       GFP_KERNEL))) {
> +			if (pages[i])
>  				put_page(pages[i]);
> +			while (--i >= 0) {
> +				mem_cgroup_uncharge_page(pages[i]);
> +				put_page(pages[i]);
> +			}

Maybe you can use batched-uncharge here.
==
mem_cgroup_uncharge_start()
{
	do loop;
}
mem_cgroup_uncharge_end();
==
Then, many atomic ops can be reduced.


>  			kfree(pages);
>  			ret |= VM_FAULT_OOM;
>  			goto out;
> @@ -455,8 +467,10 @@ out:
>  
>  out_free_pages:
>  	spin_unlock(&mm->page_table_lock);
> -	for (i = 0; i < HPAGE_PMD_NR; i++)
> +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +		mem_cgroup_uncharge_page(pages[i]);
>  		put_page(pages[i]);
> +	}

here, too.

>  	kfree(pages);
>  	goto out;
>  }
> @@ -501,14 +515,22 @@ int do_huge_pmd_wp_page(struct mm_struct
>  		goto out;
>  	}
>  
> +	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
> +		put_page(new_page);
> +		put_page(page);
> +		ret |= VM_FAULT_OOM;
> +		goto out;
> +	}
> +
>  	copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
>  	__SetPageUptodate(new_page);
>  
>  	spin_lock(&mm->page_table_lock);
>  	put_page(page);
> -	if (unlikely(!pmd_same(*pmd, orig_pmd)))
> +	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
> +		mem_cgroup_uncharge_page(new_page);
>  		put_page(new_page);
> -	else {
> +	} else {
>  		pmd_t entry;
>  		VM_BUG_ON(!PageHead(page));
>  		entry = mk_pmd(new_page, vma->vm_page_prot);


Hmm...it seems there are no codes for move_account() hugepage in series.
I think it needs some complicated work to walk page table.

Thanks,
-Kame

