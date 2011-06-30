Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1F3Sui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:50:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:60904 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1F3Suh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:50:37 -0400
Subject: Re: [PATCH 2/5] hugetlb: add phys addr to struct huge_bootmem_page
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Becky Bruce <beckyb@kernel.crashing.org>
In-Reply-To: <1309297166.32158.461.camel@pasglop>
Date: Thu, 30 Jun 2011 13:50:24 -0500
Cc: "List linux-kernel@vger.kernel.org Mailing" 
	<linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Kumar Gala <galak@kernel.crashing.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <786B027A-4EC8-4175-A18D-9DA57E9549D6@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org> <13092909493748-git-send-email-beckyb@kernel.crashing.org> <13092910103675-git-send-email-beckyb@kernel.crashing.org> <1309297166.32158.461.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 28, 2011, at 4:39 PM, Benjamin Herrenschmidt wrote:

> On Tue, 2011-06-28 at 14:54 -0500, Becky Bruce wrote:
>> struct page *alloc_huge_page_node(struct hstate *h, int nid);
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 6402458..2db81ea 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1105,8 +1105,14 @@ static void __init
>> gather_bootmem_prealloc(void)
>>        struct huge_bootmem_page *m;
>> 
>>        list_for_each_entry(m, &huge_boot_pages, list) {
>> -               struct page *page = virt_to_page(m);
>>                struct hstate *h = m->hstate;
>> +#ifdef CONFIG_HIGHMEM
>> +               struct page *page = pfn_to_page(m->phys >>
>> PAGE_SHIFT);
>> +               free_bootmem_late((unsigned long)m,
>> +                                 sizeof(struct huge_bootmem_page));
>> +#else
>> +               struct page *page = virt_to_page(m);
>> +#endif
>>                __ClearPageReserved(page);
> 
> Why do you add free_bootmem_late() in the highmem case and not the
> normal case ?

Because there was no bootmem allocation in the normal case - the non-highmem version stores data structure in the huge page itself.  This is perfectly fine as long as you have a mapping.  Since this isn't true for HIGHMEM pages, I allocate bootmem to store the early data structure that stores information about the hugepage (this happens in arch-specific code in alloc_bootmem_huge_page).

-Becky

