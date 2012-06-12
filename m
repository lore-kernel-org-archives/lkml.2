Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab2FLIyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:54:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40690 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2FLIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:53:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD70329.4080009@jp.fujitsu.com>
Date: Tue, 12 Jun 2012 17:51:53 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 15/16] hugetlb/cgroup: migrate hugetlb cgroup info
 from oldpage to new page during migration
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339232401-14392-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/09 18:00), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
> 
> With HugeTLB pages, hugetlb cgroup is uncharged in compound page destructor.  Since
> we are holding a hugepage reference, we can be sure that old page won't
> get uncharged till the last put_page().
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

one comment.

> ---
>   include/linux/hugetlb_cgroup.h |    8 ++++++++
>   mm/hugetlb_cgroup.c            |   21 +++++++++++++++++++++
>   mm/migrate.c                   |    5 +++++
>   3 files changed, 34 insertions(+)
> 
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index ba4836f..b64d067 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -63,6 +63,8 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>   extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>   					   struct hugetlb_cgroup *h_cg);
>   extern int hugetlb_cgroup_file_init(int idx) __init;
> +extern void hugetlb_cgroup_migrate(struct page *oldhpage,
> +				   struct page *newhpage);
>   #else
>   static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
>   {
> @@ -112,5 +114,11 @@ static inline int __init hugetlb_cgroup_file_init(int idx)
>   {
>   	return 0;
>   }
> +
> +static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
> +					  struct page *newhpage)
> +{
> +	return;
> +}
>   #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
>   #endif
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index c2b7b8e..2d384fe 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -394,6 +394,27 @@ int __init hugetlb_cgroup_file_init(int idx)
>   	return 0;
>   }
> 
> +void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
> +{
> +	struct hugetlb_cgroup *h_cg;
> +
> +	VM_BUG_ON(!PageHuge(oldhpage));
> +
> +	if (hugetlb_cgroup_disabled())
> +		return;
> +
> +	spin_lock(&hugetlb_lock);
> +	h_cg = hugetlb_cgroup_from_page(oldhpage);
> +	set_hugetlb_cgroup(oldhpage, NULL);
> +	cgroup_exclude_rmdir(&h_cg->css);
> +
> +	/* move the h_cg details to new cgroup */
> +	set_hugetlb_cgroup(newhpage, h_cg);
> +	spin_unlock(&hugetlb_lock);
> +	cgroup_release_and_wakeup_rmdir(&h_cg->css);
> +	return;


Why do you need  cgroup_exclude/release rmdir here ? you holds hugetlb_lock()
and charges will not be empty, here.

Thanks,
-Kame

