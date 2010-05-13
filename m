Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0EMGEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:04:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33593 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab0EMGEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] Cleanup migrate case in try_to_unmap_one
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <1272899957-11604-1-git-send-email-ngupta@vflare.org>
References: <1272899957-11604-1-git-send-email-ngupta@vflare.org>
Message-Id: <20100513144336.216D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 15:04:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove duplicate handling of TTU_MIGRATE case for
> anonymous and filesystem pages.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

This patch change swap cache case. I think this is not intentional.



> ---
>  mm/rmap.c |   17 ++++-------------
>  1 files changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 07fc947..8ccfe4a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -946,6 +946,10 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  			dec_mm_counter(mm, MM_FILEPAGES);
>  		set_pte_at(mm, address, pte,
>  				swp_entry_to_pte(make_hwpoison_entry(page)));
> +	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
> +		swp_entry_t entry;
> +		entry = make_migration_entry(page, pte_write(pteval));
> +		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
>
>  	} else if (PageAnon(page)) {
>  		swp_entry_t entry = { .val = page_private(page) };
>  
> @@ -967,22 +971,9 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>  			}
>  			dec_mm_counter(mm, MM_ANONPAGES);
>  			inc_mm_counter(mm, MM_SWAPENTS);
> -		} else if (PAGE_MIGRATION) {
> -			/*
> -			 * Store the pfn of the page in a special migration
> -			 * pte. do_swap_page() will wait until the migration
> -			 * pte is removed and then restart fault handling.
> -			 */
> -			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATION);
> -			entry = make_migration_entry(page, pte_write(pteval));
>  		}
>  		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
>  		BUG_ON(pte_file(*pte));
> -	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
> -		/* Establish migration entry for a file page */
> -		swp_entry_t entry;
> -		entry = make_migration_entry(page, pte_write(pteval));
> -		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
>  	} else
>  		dec_mm_counter(mm, MM_FILEPAGES);
>  
> -- 
> 1.6.6.1
> 



