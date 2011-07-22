Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1GVVJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:09:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:47772 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab1GVVJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:09:06 -0400
Subject: Re: [PATCH 2/5] hugetlb: add phys addr to struct huge_bootmem_page
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Becky Bruce <beckyb@kernel.crashing.org>
In-Reply-To: <20110721154427.53e8fd5b.akpm@linux-foundation.org>
Date: Fri, 22 Jul 2011 16:08:58 -0500
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        david@gibson.dropbear.id.au, galak@kernel.crashing.org,
        benh@kernel.crashing.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A8DD821C-06F9-462C-8037-28AC17C00F7B@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org> <13092909493748-git-send-email-beckyb@kernel.crashing.org> <13092910103675-git-send-email-beckyb@kernel.crashing.org> <20110721154427.53e8fd5b.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21, 2011, at 5:44 PM, Andrew Morton wrote:

> On Tue, 28 Jun 2011 14:54:45 -0500
> Becky Bruce <beckyb@kernel.crashing.org> wrote:
> 
>> From: Becky Bruce <beckyb@kernel.crashing.org>
>> 
>> This is needed on HIGHMEM systems - we don't always have a virtual
>> address so store the physical address and map it in as needed.
>> 
>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
>> ---
>> include/linux/hugetlb.h |    3 +++
>> mm/hugetlb.c            |    8 +++++++-
>> 2 files changed, 10 insertions(+), 1 deletions(-)
>> 
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 59225ef..19644e0 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -231,6 +231,9 @@ struct hstate {
>> struct huge_bootmem_page {
>> 	struct list_head list;
>> 	struct hstate *hstate;
>> +#ifdef CONFIG_HIGHMEM
>> +	phys_addr_t phys;
>> +#endif
>> };
>> 
>> struct page *alloc_huge_page_node(struct hstate *h, int nid);
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 6402458..2db81ea 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1105,8 +1105,14 @@ static void __init gather_bootmem_prealloc(void)
>> 	struct huge_bootmem_page *m;
>> 
>> 	list_for_each_entry(m, &huge_boot_pages, list) {
>> -		struct page *page = virt_to_page(m);
>> 		struct hstate *h = m->hstate;
>> +#ifdef CONFIG_HIGHMEM
>> +		struct page *page = pfn_to_page(m->phys >> PAGE_SHIFT);
>> +		free_bootmem_late((unsigned long)m,
>> +				  sizeof(struct huge_bootmem_page));
>> +#else
>> +		struct page *page = virt_to_page(m);
>> +#endif
>> 		__ClearPageReserved(page);
>> 		WARN_ON(page_count(page) != 1);
>> 		prep_compound_huge_page(page, h->order);
> 
> nit: wrapping both definitions and statements in an ifdef like this is
> a bit nasty from a readability and maintainability point of view - it's
> inviting people to later make changes which fail to compile when the
> config option is flipped.
> 
> This is better:
> 
> --- a/mm/hugetlb.c~hugetlb-add-phys-addr-to-struct-huge_bootmem_page-fix
> +++ a/mm/hugetlb.c
> @@ -1106,12 +1106,14 @@ static void __init gather_bootmem_preall
> 
> 	list_for_each_entry(m, &huge_boot_pages, list) {
> 		struct hstate *h = m->hstate;
> +		struct page *page;
> +
> #ifdef CONFIG_HIGHMEM
> -		struct page *page = pfn_to_page(m->phys >> PAGE_SHIFT);
> +		page = pfn_to_page(m->phys >> PAGE_SHIFT);
> 		free_bootmem_late((unsigned long)m,
> 				  sizeof(struct huge_bootmem_page));
> #else
> -		struct page *page = virt_to_page(m);
> +		page = virt_to_page(m);
> #endif
> 		__ClearPageReserved(page);
> 		WARN_ON(page_count(page) != 1);

Andrew,

I totally agree, this is better, thanks.   I see you've put my original patch and your fix into -mm;  I'd like it to percolate there for a bit before it goes to Linus to be sure I haven't broken anything.  It should be safe, as I don't think this particular function was ever expected to work on highmem platforms, but it's possible I'm overlooking something.

Cheers,
-Becky

