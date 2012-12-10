Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab2LJKnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:43:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37271 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2LJKnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:43:33 -0500
Date: Mon, 10 Dec 2012 11:43:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20121210104327.GA7264@gmail.com>
References: <20121210195402.1042a8ea5bfb57bb758007ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210195402.1042a8ea5bfb57bb758007ac@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> mm/migrate.c: In function 'migrate_misplaced_transhuge_page_put':
> mm/migrate.c:1666:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'
> arch/x86/include/asm/pgtable.h:792:20: note: expected 'struct pmd_t *' but argument is of type 'pmd_t'
> 
> Caused by commit 7f7f03ce3820 ("mm, numa: Implement migrate-on-fault lazy
> NUMA strategy for regular and THP pages") from the tip tree and expose by
> commit "x86: convert update_mmu_cache() and update_mmu_cache_pmd() to
> functions" from the akpm tree.
> 
> I applied the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 10 Dec 2012 19:50:57 +1100
> Subject: [PATCH] mm,numa: fix update_mmu_cache_pmd call
> 
> Fixes this build error:
> 
> mm/migrate.c: In function 'migrate_misplaced_transhuge_page_put':
> mm/migrate.c:1666:2: error: incompatible type for argument 3 of 'update_mmu_cache_pmd'
> arch/x86/include/asm/pgtable.h:792:20: note: expected 'struct pmd_t *' but argument is of type 'pmd_t'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/migrate.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 5be98e5..964a8c1 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1663,7 +1663,7 @@ int migrate_misplaced_transhuge_page_put(struct mm_struct *mm,
>  	page_add_new_anon_rmap(new_page, vma, haddr);
>  
>  	set_pmd_at(mm, haddr, pmd, entry);
> -	update_mmu_cache_pmd(vma, address, entry);
> +	update_mmu_cache_pmd(vma, address, &entry);
>  	page_remove_rmap(page);
>  	/*
>  	 * Finish the charge transaction under the page table lock to

I think the real bug is not in the akpm but in the -tip tree: we 
copy & pasted a pre-existing buggy upstream place that also 
called update_mmu_cache_pmd() with a pmd value, not by address. 
akpm's patch fixed the original buggy place, but not our copy of 
it.

Practically this does not truly matter at the moment as only 
Sparc64 appears to be a real user of that function, and Sparc64 
does not turn on the NUMA feature (yet) - but nevertheless the 
change in akpm's tree which introduces correct typing for this 
method exposed the latent bug.

I'll pick up your fix.

Thanks,

	Ingo
