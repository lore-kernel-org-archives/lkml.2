Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424232Ab2LGFg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 00:36:58 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:36166 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2LGFg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 00:36:57 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned hugepage
In-Reply-To: <1354845824-5734-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1354845824-5734-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.14+97~g3977b25 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Fri, 07 Dec 2012 11:06:41 +0530
Message-ID: <87ehj2ctjq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120705-7014-0000-0000-0000024F743D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> On Thu, Dec 06, 2012 at 02:36:52PM -0800, Andrew Morton wrote:
>> On Wed,  5 Dec 2012 16:47:36 -0500
>> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
>> 
>> > This patch fixes the warning from __list_del_entry() which is triggered
>> > when a process tries to do free_huge_page() for a hwpoisoned hugepage.
>> > 
>> > Originally, page->lru of hugetlbfs head page was dangling when the
>> > hugepage was in use. This behavior has changed by commit 0edaecfab218d7
>> > ("hugetlb: add a list for tracking in-use HugeTLB pages"), where hugepages
>> > in use are linked to hugepage_activelist. HWpoisoned hugepages should not
>> > be charged to any process, so we introduce another list to link hwpoisoned
>> > hugepages.
>> > 
>> > ...
>> >
>> > --- v3.7-rc8.orig/include/linux/hugetlb.h
>> > +++ v3.7-rc8/include/linux/hugetlb.h
>> > @@ -230,6 +230,9 @@ struct hstate {
>> >  	unsigned long nr_overcommit_huge_pages;
>> >  	struct list_head hugepage_activelist;
>> >  	struct list_head hugepage_freelists[MAX_NUMNODES];
>> > +#ifdef CONFIG_MEMORY_FAILURE
>> > +	struct list_head hugepage_hwpoisonedlist;
>> > +#endif
>> >  	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>> >  	unsigned int free_huge_pages_node[MAX_NUMNODES];
>> >  	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
>> > diff --git v3.7-rc8.orig/mm/hugetlb.c v3.7-rc8/mm/hugetlb.c
>> > index 59a0059..e61a749 100644
>> > --- v3.7-rc8.orig/mm/hugetlb.c
>> > +++ v3.7-rc8/mm/hugetlb.c
>> > @@ -1939,6 +1939,7 @@ void __init hugetlb_add_hstate(unsigned order)
>> >  	for (i = 0; i < MAX_NUMNODES; ++i)
>> >  		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
>> >  	INIT_LIST_HEAD(&h->hugepage_activelist);
>> > +	INIT_LIST_HEAD(&h->hugepage_hwpoisonedlist);
>> >  	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
>> >  	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
>> >  	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
>> > @@ -3170,7 +3171,7 @@ int dequeue_hwpoisoned_huge_page(struct page *hpage)
>> >  
>> >  	spin_lock(&hugetlb_lock);
>> >  	if (is_hugepage_on_freelist(hpage)) {
>> > -		list_del(&hpage->lru);
>> > +		list_move(&hpage->lru, &h->hugepage_hwpoisonedlist);
>> >  		set_page_refcounted(hpage);
>> >  		h->free_huge_pages--;
>> >  		h->free_huge_pages_node[nid]--;
>> 
>> Do we actually need to new list?  We could use list_del_init() to leave
>> the page's list_head pointing at itself.  In this state, it is its own
>> list_head and further list_del()s are a no-op.
>
> OK, it's better, thanks.
>
>> I don't know whether this would trigger list-debug warnings.
>
> I tested your idea (with attached patch) and confirmed that
> we never get the warnings.
>
> Thanks,
> Naoya
> ---
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Thu, 6 Dec 2012 20:54:30 -0500
> Subject: [PATCH v2] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned
>  hugepage
>
> This patch fixes the warning from __list_del_entry() which is triggered
> when a process tries to do free_huge_page() for a hwpoisoned hugepage.


Can you get a dump stack for that. I am confused because the page was
already in freelist, and we deleted it from the list and set the
refcount to 1. So how are we reaching free_huge_page() again ?


>
> ChangeLog v2:
>  - simply use list_del_init instead of introducing new hugepage list
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/hugetlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 59a0059..9308752 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3170,7 +3170,7 @@ int dequeue_hwpoisoned_huge_page(struct page *hpage)
>
>  	spin_lock(&hugetlb_lock);
>  	if (is_hugepage_on_freelist(hpage)) {
> -		list_del(&hpage->lru);
> +		list_del_init(&hpage->lru);
>  		set_page_refcounted(hpage);
>  		h->free_huge_pages--;
>  		h->free_huge_pages_node[nid]--;
> -- 

-aneesh

