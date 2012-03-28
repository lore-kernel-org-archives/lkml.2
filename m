Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab2C1NRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:17:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab2C1NRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:17:08 -0400
Date: Wed, 28 Mar 2012 15:17:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
Message-ID: <20120328131706.GF20949@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 16-03-12 23:09:25, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> This adds necessary charge/uncharge calls in the HugeTLB code

This begs for more description...
Other than that it looks correct.

> Acked-by: Hillf Danton <dhillf@gmail.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  mm/hugetlb.c    |   21 ++++++++++++++++++++-
>  mm/memcontrol.c |    5 +++++
>  2 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index c672187..91361a0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -21,6 +21,8 @@
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
>  #include <linux/swapops.h>
> +#include <linux/memcontrol.h>
> +#include <linux/page_cgroup.h>
>  
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
> @@ -542,6 +544,9 @@ static void free_huge_page(struct page *page)
>  	BUG_ON(page_mapcount(page));
>  	INIT_LIST_HEAD(&page->lru);
>  
> +	if (mapping)
> +		mem_cgroup_hugetlb_uncharge_page(hstate_index(h),
> +						 pages_per_huge_page(h), page);
>  	spin_lock(&hugetlb_lock);
>  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
>  		update_and_free_page(h, page);
> @@ -1019,12 +1024,15 @@ static void vma_commit_reservation(struct hstate *h,
>  static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  				    unsigned long addr, int avoid_reserve)
>  {
> +	int ret, idx;
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *page;
> +	struct mem_cgroup *memcg = NULL;
>  	struct address_space *mapping = vma->vm_file->f_mapping;
>  	struct inode *inode = mapping->host;
>  	long chg;
>  
> +	idx = hstate_index(h);
>  	/*
>  	 * Processes that did not create the mapping will have no reserves and
>  	 * will not have accounted against quota. Check that the quota can be
> @@ -1039,6 +1047,12 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  		if (hugetlb_get_quota(inode->i_mapping, chg))
>  			return ERR_PTR(-ENOSPC);
>  
> +	ret = mem_cgroup_hugetlb_charge_page(idx, pages_per_huge_page(h),
> +					     &memcg);
> +	if (ret) {
> +		hugetlb_put_quota(inode->i_mapping, chg);
> +		return ERR_PTR(-ENOSPC);
> +	}
>  	spin_lock(&hugetlb_lock);
>  	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
>  	spin_unlock(&hugetlb_lock);
> @@ -1046,6 +1060,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	if (!page) {
>  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
>  		if (!page) {
> +			mem_cgroup_hugetlb_uncharge_memcg(idx,
> +							 pages_per_huge_page(h),
> +							 memcg);
>  			hugetlb_put_quota(inode->i_mapping, chg);
>  			return ERR_PTR(-ENOSPC);
>  		}
> @@ -1054,7 +1071,9 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	set_page_private(page, (unsigned long) mapping);
>  
>  	vma_commit_reservation(h, vma, addr);
> -
> +	/* update page cgroup details */
> +	mem_cgroup_hugetlb_commit_charge(idx, pages_per_huge_page(h),
> +					 memcg, page);
>  	return page;
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4b36c5e..7a9ea94 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2901,6 +2901,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
>  
>  	if (PageSwapCache(page))
>  		return NULL;
> +	/*
> +	 * HugeTLB page uncharge happen in the HugeTLB compound page destructor
> +	 */
> +	if (PageHuge(page))
> +		return NULL;
>  
>  	if (PageTransHuge(page)) {
>  		nr_pages <<= compound_order(page);
> -- 
> 1.7.9
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
