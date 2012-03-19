Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab2CSCmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:42:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34886 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567Ab2CSCmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:42:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F669CC3.9070007@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 11:41:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/17 2:39), Aneesh Kumar K.V wrote:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> This adds necessary charge/uncharge calls in the HugeTLB code
> 
> Acked-by: Hillf Danton <dhillf@gmail.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
A nitpick below.

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


Can't we this initialization in mem_cgroup_hugetlb_charge_page() ?

Thanks,
-Kame

