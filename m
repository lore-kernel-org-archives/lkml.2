Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2LFWgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:36:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2LFWgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:36:54 -0500
Date: Thu, 6 Dec 2012 14:36:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing
 hwpoisoned hugepage
Message-Id: <20121206143652.29c4922f.akpm@linux-foundation.org>
In-Reply-To: <1354744058-26373-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1354744058-26373-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Dec 2012 16:47:36 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> This patch fixes the warning from __list_del_entry() which is triggered
> when a process tries to do free_huge_page() for a hwpoisoned hugepage.
> 
> Originally, page->lru of hugetlbfs head page was dangling when the
> hugepage was in use. This behavior has changed by commit 0edaecfab218d7
> ("hugetlb: add a list for tracking in-use HugeTLB pages"), where hugepages
> in use are linked to hugepage_activelist. HWpoisoned hugepages should not
> be charged to any process, so we introduce another list to link hwpoisoned
> hugepages.
> 
> ...
>
> --- v3.7-rc8.orig/include/linux/hugetlb.h
> +++ v3.7-rc8/include/linux/hugetlb.h
> @@ -230,6 +230,9 @@ struct hstate {
>  	unsigned long nr_overcommit_huge_pages;
>  	struct list_head hugepage_activelist;
>  	struct list_head hugepage_freelists[MAX_NUMNODES];
> +#ifdef CONFIG_MEMORY_FAILURE
> +	struct list_head hugepage_hwpoisonedlist;
> +#endif
>  	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>  	unsigned int free_huge_pages_node[MAX_NUMNODES];
>  	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
> diff --git v3.7-rc8.orig/mm/hugetlb.c v3.7-rc8/mm/hugetlb.c
> index 59a0059..e61a749 100644
> --- v3.7-rc8.orig/mm/hugetlb.c
> +++ v3.7-rc8/mm/hugetlb.c
> @@ -1939,6 +1939,7 @@ void __init hugetlb_add_hstate(unsigned order)
>  	for (i = 0; i < MAX_NUMNODES; ++i)
>  		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
>  	INIT_LIST_HEAD(&h->hugepage_activelist);
> +	INIT_LIST_HEAD(&h->hugepage_hwpoisonedlist);
>  	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
>  	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
>  	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
> @@ -3170,7 +3171,7 @@ int dequeue_hwpoisoned_huge_page(struct page *hpage)
>  
>  	spin_lock(&hugetlb_lock);
>  	if (is_hugepage_on_freelist(hpage)) {
> -		list_del(&hpage->lru);
> +		list_move(&hpage->lru, &h->hugepage_hwpoisonedlist);
>  		set_page_refcounted(hpage);
>  		h->free_huge_pages--;
>  		h->free_huge_pages_node[nid]--;

Do we actually need to new list?  We could use list_del_init() to leave
the page's list_head pointing at itself.  In this state, it is its own
list_head and further list_del()s are a no-op.

I don't know whether this would trigger list-debug warnings.
