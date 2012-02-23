Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2BWUMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:12:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2BWUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:12:43 -0500
Date: Thu, 23 Feb 2012 12:12:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: hugetlb: bail out unmapping after serving reference
 page
Message-Id: <20120223121238.b597e7e4.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBA53nS70Q7GEeskKFas-hfg4GKmUf=Zut5anSN0P+d1KA@mail.gmail.com>
References: <CAJd=RBALNtedfq+PLPnGKd4i4D0mLiVPdW_7pWWopnSZNC_vqA@mail.gmail.com>
	<20120222130659.d75b6f69.akpm@linux-foundation.org>
	<CAJd=RBA53nS70Q7GEeskKFas-hfg4GKmUf=Zut5anSN0P+d1KA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 21:05:41 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> and a follow-up cleanup also attached.

Please, never put more than one patches in an email - it is rather a
pain to manually unpick everything.

> When unmapping given VM range, a couple of code duplicate, such as pte_page()
> and huge_pte_none(), so a cleanup needed to compact them together.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/hugetlb.c	Thu Feb 23 20:13:06 2012
> +++ b/mm/hugetlb.c	Thu Feb 23 20:30:16 2012
> @@ -2245,16 +2245,23 @@ void __unmap_hugepage_range(struct vm_ar
>  		if (huge_pmd_unshare(mm, &address, ptep))
>  			continue;
> 
> +		pte = huge_ptep_get(ptep);
> +		if (huge_pte_none(pte))
> +			continue;
> +
> +		/*
> +		 * HWPoisoned hugepage is already unmapped and dropped reference
> +		 */
> +		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
> +			continue;
> +
> +		page = pte_page(pte);
>  		/*
>  		 * If a reference page is supplied, it is because a specific
>  		 * page is being unmapped, not a range. Ensure the page we
>  		 * are about to unmap is the actual page of interest.
>  		 */
>  		if (ref_page) {
> -			pte = huge_ptep_get(ptep);
> -			if (huge_pte_none(pte))
> -				continue;
> -			page = pte_page(pte);
>  			if (page != ref_page)
>  				continue;
> 
> @@ -2267,16 +2274,6 @@ void __unmap_hugepage_range(struct vm_ar
>  		}
> 
>  		pte = huge_ptep_get_and_clear(mm, address, ptep);
> -		if (huge_pte_none(pte))
> -			continue;
> -
> -		/*
> -		 * HWPoisoned hugepage is already unmapped and dropped reference
> -		 */
> -		if (unlikely(is_hugetlb_entry_hwpoisoned(pte)))
> -			continue;
> -
> -		page = pte_page(pte);
>  		if (pte_dirty(pte))
>  			set_page_dirty(page);
>  		list_add(&page->lru, &page_list);

This changes behaviour when ref_page refers to a hwpoisoned page.
