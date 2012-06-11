Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2FKIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:16:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2FKIQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:16:56 -0400
Date: Mon, 11 Jun 2012 10:16:53 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 10/16] hugetlb/cgroup: Add the cgroup pointer to page
 lru
Message-ID: <20120611081653.GB12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339232401-14392-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 09-06-12 14:29:55, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> Add the hugetlb cgroup pointer to 3rd page lru.next.

Interesting and I really like the idea much more than tracking by
page_cgroup.

> This limit the usage to hugetlb cgroup to only hugepages with 3 or
> more normal pages. I guess that is an acceptable limitation.

Agreed.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Other than some nits I like this.
Thanks!

> ---
>  include/linux/hugetlb_cgroup.h |   31 +++++++++++++++++++++++++++++++
>  mm/hugetlb.c                   |    4 ++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index 5794be4..ceff1d5 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -26,6 +26,26 @@ struct hugetlb_cgroup {
>  };
>  
>  #ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
> +static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
> +{
> +	if (!PageHuge(page))
> +		return NULL;
> +	if (compound_order(page) < 3)

Why 3? I think you wanted 2 here, right?

> +		return NULL;
> +	return (struct hugetlb_cgroup *)page[2].lru.next;
> +}
> +
> +static inline
> +int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
> +{
> +	if (!PageHuge(page))
> +		return -1;
> +	if (compound_order(page) < 3)

Here as well.

> +		return -1;
> +	page[2].lru.next = (void *)h_cg;
> +	return 0;
> +}
> +
>  static inline bool hugetlb_cgroup_disabled(void)
>  {
>  	if (hugetlb_subsys.disabled)
> @@ -43,6 +63,17 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>  extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>  					   struct hugetlb_cgroup *h_cg);
>  #else
> +static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
> +{
> +	return NULL;
> +}
> +
> +static inline
> +int set_hugetlb_cgroup(struct page *page, struct hugetlb_cgroup *h_cg)
> +{
> +	return 0;
> +}
> +
>  static inline bool hugetlb_cgroup_disabled(void)
>  {
>  	return true;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e899a2d..1ca2d8f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -28,6 +28,7 @@
>  
>  #include <linux/io.h>
>  #include <linux/hugetlb.h>
> +#include <linux/hugetlb_cgroup.h>
>  #include <linux/node.h>
>  #include "internal.h"
>  
> @@ -591,6 +592,7 @@ static void update_and_free_page(struct hstate *h, struct page *page)
>  				1 << PG_active | 1 << PG_reserved |
>  				1 << PG_private | 1 << PG_writeback);
>  	}
> +	BUG_ON(hugetlb_cgroup_from_page(page));

What about VM_BUG_ON?

>  	set_compound_page_dtor(page, NULL);
>  	set_page_refcounted(page);
>  	arch_release_hugepage(page);
> @@ -643,6 +645,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
>  	INIT_LIST_HEAD(&page->lru);
>  	set_compound_page_dtor(page, free_huge_page);
>  	spin_lock(&hugetlb_lock);
> +	set_hugetlb_cgroup(page, NULL);

Why inside the spin lock?

>  	h->nr_huge_pages++;
>  	h->nr_huge_pages_node[nid]++;
>  	spin_unlock(&hugetlb_lock);
> @@ -892,6 +895,7 @@ static struct page *alloc_buddy_huge_page(struct hstate *h, int nid)
>  		INIT_LIST_HEAD(&page->lru);
>  		r_nid = page_to_nid(page);
>  		set_compound_page_dtor(page, free_huge_page);
> +		set_hugetlb_cgroup(page, NULL);
>  		/*
>  		 * We incremented the global counters already
>  		 */
> -- 
> 1.7.10
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
