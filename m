Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab2GKIct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:32:49 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53020 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GKIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:32:44 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Wanpeng Li <liwp.linux@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] mm/hugetlb_cgroup: Add list_del to remove unused page from hugepage_activelist when hugepage migration
In-Reply-To: <1341978718-6423-1-git-send-email-liwp.linux@gmail.com>
References: <1341978718-6423-1-git-send-email-liwp.linux@gmail.com>
User-Agent: Notmuch/0.13.2+63~g548a9bf (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 11 Jul 2012 14:02:23 +0530
Message-ID: <87wr2aitpk.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12071022-7014-0000-0000-0000018A6680
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <liwp.linux@gmail.com> writes:

> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>
> hugepage_activelist is used to track currently used HugeTLB pages.
> We can find the in-use HugeTLB pages to support HugeTLB cgroup
> removal. Don't keep unused page in hugetlb_activelist too long.
> Otherwise, on cgroup removal we should update the unused page's 
> charge to parent count. To reduce this overhead, remove unused page 
> from hugepage_activelist immediately.
>
> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
>  mm/hugetlb_cgroup.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index b834e8d..d819d66 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -398,6 +398,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
>  	spin_lock(&hugetlb_lock);
>  	h_cg = hugetlb_cgroup_from_page(oldhpage);
>  	set_hugetlb_cgroup(oldhpage, NULL);
> +	list_del(&oldhpage->lru);
>
>  	/* move the h_cg details to new cgroup */
>  	set_hugetlb_cgroup(newhpage, h_cg);

put_page on the oldhpage will do that. If we do list_del here
free_huge_page() will have error list_move().

-aneesh

