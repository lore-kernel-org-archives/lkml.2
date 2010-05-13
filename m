Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0EMHS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:18:57 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:45063 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0EMHSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:18:55 -0400
Message-ID: <4BEBA70C.9050404@vflare.org>
Date: Thu, 13 May 2010 12:45:24 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] Cleanup migrate case in try_to_unmap_one
References: <1272899957-11604-1-git-send-email-ngupta@vflare.org> <20100513144336.216D.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100513144336.216D.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 11:34 AM, KOSAKI Motohiro wrote:
>> Remove duplicate handling of TTU_MIGRATE case for
>> anonymous and filesystem pages.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> 
> This patch change swap cache case. I think this is not intentional.
> 
> 

IIUC, we never call this function with TTU_MIGRATE for swap cache pages.
So, the behavior after this patch remains unchanged.

Thanks,
Nitin




> 
>> ---
>>  mm/rmap.c |   17 ++++-------------
>>  1 files changed, 4 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 07fc947..8ccfe4a 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -946,6 +946,10 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>>  			dec_mm_counter(mm, MM_FILEPAGES);
>>  		set_pte_at(mm, address, pte,
>>  				swp_entry_to_pte(make_hwpoison_entry(page)));
>> +	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
>> +		swp_entry_t entry;
>> +		entry = make_migration_entry(page, pte_write(pteval));
>> +		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
>>
>>  	} else if (PageAnon(page)) {
>>  		swp_entry_t entry = { .val = page_private(page) };
>>  
>> @@ -967,22 +971,9 @@ int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
>>  			}
>>  			dec_mm_counter(mm, MM_ANONPAGES);
>>  			inc_mm_counter(mm, MM_SWAPENTS);
>> -		} else if (PAGE_MIGRATION) {
>> -			/*
>> -			 * Store the pfn of the page in a special migration
>> -			 * pte. do_swap_page() will wait until the migration
>> -			 * pte is removed and then restart fault handling.
>> -			 */
>> -			BUG_ON(TTU_ACTION(flags) != TTU_MIGRATION);
>> -			entry = make_migration_entry(page, pte_write(pteval));
>>  		}
>>  		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
>>  		BUG_ON(pte_file(*pte));
>> -	} else if (PAGE_MIGRATION && (TTU_ACTION(flags) == TTU_MIGRATION)) {
>> -		/* Establish migration entry for a file page */
>> -		swp_entry_t entry;
>> -		entry = make_migration_entry(page, pte_write(pteval));
>> -		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
>>  	} else
>>  		dec_mm_counter(mm, MM_FILEPAGES);
>>  
>> -- 
>> 1.6.6.1
>>
> 
> 
> 
> 

