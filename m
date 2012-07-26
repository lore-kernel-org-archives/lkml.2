Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2GZSdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:33:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab2GZSdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:33:31 -0400
Message-ID: <50118D16.4050603@redhat.com>
Date: Thu, 26 Jul 2012 14:31:50 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Ken Chen <kenchen@google.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -alternative] mm: hugetlbfs: Close race during teardown
 of hugetlbfs shared page tables V2 (resend)
References: <20120720134937.GG9222@suse.de> <20120720141108.GH9222@suse.de> <20120720143635.GE12434@tiehlicka.suse.cz>
In-Reply-To: <20120720143635.GE12434@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 10:36 AM, Michal Hocko wrote:

> --- a/arch/x86/mm/hugetlbpage.c
> +++ b/arch/x86/mm/hugetlbpage.c
> @@ -81,7 +81,12 @@ static void huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
>   		if (saddr) {
>   			spte = huge_pte_offset(svma->vm_mm, saddr);
>   			if (spte) {
> -				get_page(virt_to_page(spte));
> +				struct page *spte_page = virt_to_page(spte);
> +				if (!is_hugetlb_pmd_page_valid(spte_page)) {

What prevents somebody else from marking the hugetlb
pmd invalid, between here...

> +					spte = NULL;
> +					continue;
> +				}

... and here?

> +				get_page(spte_page);
>   				break;
>   			}

I think need to take the refcount before checking whether
the hugetlb pmd is still valid.

Also, disregard my previous email in this thread, I just
read Mel's detailed explanation and wrapped my brain
around the bug :)
