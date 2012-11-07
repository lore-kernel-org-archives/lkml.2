Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2KGHzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:55:40 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:41264 "HELO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751380Ab2KGHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:55:39 -0500
Message-ID: <509A137C.3020903@mellanox.com>
Date: Wed, 7 Nov 2012 09:53:32 +0200
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [patch] mm: fix build warning for uninitialized value
References: <alpine.DEB.2.00.1210312234180.31758@chino.kir.corp.google.com> <alpine.DEB.2.00.1211051334490.5296@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211051334490.5296@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 23:36, David Rientjes wrote:
> do_wp_page() sets mmun_called if mmun_start and mmun_end were initialized 
> and, if so, may call mmu_notifier_invalidate_range_end() with these 
> values.  This doesn't prevent gcc from emitting a build warning though:
> 
> mm/memory.c: In function ‘do_wp_page’:
> mm/memory.c:2530: warning: ‘mmun_start’ may be used uninitialized in this function
> mm/memory.c:2531: warning: ‘mmun_end’ may be used uninitialized in this function

I haven't seen these warning. Perhaps I used a different compiler
version, or the right flags.

> 
> It's much easier to initialize the variables to impossible values and do a 
> simple comparison to determine if they were initialized to remove the bool 
> entirely.

This solution looks great to me.

> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/memory.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2527,9 +2527,8 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	int ret = 0;
>  	int page_mkwrite = 0;
>  	struct page *dirty_page = NULL;
> -	unsigned long mmun_start;	/* For mmu_notifiers */
> -	unsigned long mmun_end;		/* For mmu_notifiers */
> -	bool mmun_called = false;	/* For mmu_notifiers */
> +	unsigned long mmun_start = 0;	/* For mmu_notifiers */
> +	unsigned long mmun_end = 0;	/* For mmu_notifiers */
>  
>  	old_page = vm_normal_page(vma, address, orig_pte);
>  	if (!old_page) {
> @@ -2708,8 +2707,7 @@ gotten:
>  		goto oom_free_new;
>  
>  	mmun_start  = address & PAGE_MASK;
> -	mmun_end    = (address & PAGE_MASK) + PAGE_SIZE;
> -	mmun_called = true;
> +	mmun_end    = mmun_start + PAGE_SIZE;
>  	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
>  
>  	/*
> @@ -2778,7 +2776,7 @@ gotten:
>  		page_cache_release(new_page);
>  unlock:
>  	pte_unmap_unlock(page_table, ptl);
> -	if (mmun_called)
> +	if (mmun_end > mmun_start)
>  		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
>  	if (old_page) {
>  		/*
> 

