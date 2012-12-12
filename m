Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2LLRGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 12:06:09 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57141 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2LLRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 12:06:07 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jianguo Wu <wujianguo@huawei.com>, tj@kernel.org, lizefan@huawei.com,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Liujiang <jiang.liu@huawei.com>,
        dhillf@gmail.com, Jiang Liu <liuj97@gmail.com>,
        qiuxishi <qiuxishi@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: create hugetlb cgroup file in hugetlb_init
In-Reply-To: <50C83F97.3040009@huawei.com>
References: <50C83F97.3040009@huawei.com>
User-Agent: Notmuch/0.14+166~ge7bd40a (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 12 Dec 2012 22:35:54 +0530
Message-ID: <8738zb9p59.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121217-8878-0000-0000-00000524055C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianguo Wu <wujianguo@huawei.com> writes:

> Build kernel with CONFIG_HUGETLBFS=y,CONFIG_HUGETLB_PAGE=y
> and CONFIG_CGROUP_HUGETLB=y, then specify hugepagesz=xx boot option,
> system will boot fail.
>
> This failure is caused by following code path:
> setup_hugepagesz
> 	hugetlb_add_hstate
> 		hugetlb_cgroup_file_init
> 			cgroup_add_cftypes
> 				kzalloc <--slab is *not available* yet
>
> For this path, slab is not available yet, so memory allocated will be
> failed, and cause WARN_ON() in hugetlb_cgroup_file_init().
>
> So I move hugetlb_cgroup_file_init() into hugetlb_init().
>
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  include/linux/hugetlb_cgroup.h |    7 ++-----
>  mm/hugetlb.c                   |   11 +----------
>  mm/hugetlb_cgroup.c            |   23 +++++++++++++++++++++--
>  3 files changed, 24 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index d73878c..5bb9c28 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -62,7 +62,7 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>  					 struct page *page);
>  extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>  					   struct hugetlb_cgroup *h_cg);
> -extern int hugetlb_cgroup_file_init(int idx) __init;
> +extern void hugetlb_cgroup_file_init(void) __init;
>  extern void hugetlb_cgroup_migrate(struct page *oldhpage,
>  				   struct page *newhpage);
>
> @@ -111,10 +111,7 @@ hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>  	return;
>  }
>
> -static inline int __init hugetlb_cgroup_file_init(int idx)
> -{
> -	return 0;
> -}
> +static inline void __init hugetlb_cgroup_file_init() {}
>
>  static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
>  					  struct page *newhpage)
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1ef2cd4..a30da48 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1906,14 +1906,12 @@ static int __init hugetlb_init(void)
>  		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
>
>  	hugetlb_init_hstates();
> -
>  	gather_bootmem_prealloc();
> -
>  	report_hugepages();
>
>  	hugetlb_sysfs_init();
> -
>  	hugetlb_register_all_nodes();
> +	hugetlb_cgroup_file_init();
>
>  	return 0;
>  }
> @@ -1943,13 +1941,6 @@ void __init hugetlb_add_hstate(unsigned order)
>  	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
>  	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
>  					huge_page_size(h)/1024);
> -	/*
> -	 * Add cgroup control files only if the huge page consists
> -	 * of more than two normal pages. This is because we use
> -	 * page[2].lru.next for storing cgoup details.
> -	 */
> -	if (order >= HUGETLB_CGROUP_MIN_ORDER)
> -		hugetlb_cgroup_file_init(hugetlb_max_hstate - 1);
>
>  	parsed_hstate = h;
>  }
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index a3f358f..284cb68 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -340,7 +340,7 @@ static char *mem_fmt(char *buf, int size, unsigned long hsize)
>  	return buf;
>  }
>
> -int __init hugetlb_cgroup_file_init(int idx)
> +static void __init __hugetlb_cgroup_file_init(int idx)
>  {
>  	char buf[32];
>  	struct cftype *cft;
> @@ -382,7 +382,26 @@ int __init hugetlb_cgroup_file_init(int idx)
>
>  	WARN_ON(cgroup_add_cftypes(&hugetlb_subsys, h->cgroup_files));
>
> -	return 0;
> +	return;
> +}
> +
> +void __init hugetlb_cgroup_file_init()
> +{
> +	struct hstate *h;
> +	int idx;
> +
> +	idx = 0;
> +	for_each_hstate(h) {
> +		/*
> +		 * Add cgroup control files only if the huge page consists
> +		 * of more than two normal pages. This is because we use
> +		 * page[2].lru.next for storing cgoup details.
> +		 */
> +		if (h->order >= HUGETLB_CGROUP_MIN_ORDER)
> +			__hugetlb_cgroup_file_init(idx);

Is it better to say ?

             if (huge_page_order(h) >= HUGETLB_CGROUP_MIN_ORDER)
                          __hugetlb_cgroup_file_init(hstate_index(h));                                

It should be ok both case.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> +
> +		idx++;
> +	}
>  }
>
>  /*
> -- 1.7.1

-anesh

