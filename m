Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1EIHi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:38:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56274 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1EIHi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:38:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH 2/8] mm: use walk_page_range() instead of custom page table walking code
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1303947349-3620-3-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca> <1303947349-3620-3-git-send-email-wilsons@start.ca>
Message-Id: <20110509164034.164C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  9 May 2011 16:38:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sorry for the long delay.

> In the specific case of show_numa_map(), the custom page table walking
> logic implemented in mempolicy.c does not provide any special service
> beyond that provided by walk_page_range().
> 
> Also, converting show_numa_map() to use the generic routine decouples
> the function from mempolicy.c, allowing it to be moved out of the mm
> subsystem and into fs/proc.
> 
> Signed-off-by: Stephen Wilson <wilsons@start.ca>
> ---
>  mm/mempolicy.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 46 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 5bfb03e..dfe27e3 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2568,6 +2568,22 @@ static void gather_stats(struct page *page, void *private, int pte_dirty)
>  	md->node[page_to_nid(page)]++;
>  }
>  
> +static int gather_pte_stats(pte_t *pte, unsigned long addr,
> +		unsigned long pte_size, struct mm_walk *walk)
> +{
> +	struct page *page;
> +
> +	if (pte_none(*pte))
> +		return 0;
> +
> +	page = pte_page(*pte);
> +	if (!page)
> +		return 0;

original check_pte_range() has following logic.

        orig_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
        do {
                struct page *page;
                int nid;

                if (!pte_present(*pte))
                        continue;
                page = vm_normal_page(vma, addr, *pte);
                if (!page)
                        continue;
                /*
                 * vm_normal_page() filters out zero pages, but there might
                 * still be PageReserved pages to skip, perhaps in a VDSO.
                 * And we cannot move PageKsm pages sensibly or safely yet.
                 */
                if (PageReserved(page) || PageKsm(page))
                        continue;
                gather_stats(page, private, pte_dirty(*pte));

Why did you drop a lot of check? Is it safe?

Other parts looks good to me.


