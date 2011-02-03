Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1BCWAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:00:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1BCWAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:00:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K3vp748TcWd1Z7zRoLy9Hq6yxhuSYmbq4wDJn+4w0WjJbsgLwbB67QqpkauNUSjgaW
         ekxDKHIsX8As1VYS8/LO/JaTg7u7muVRc/+R1rLYrAqg7d3rxQtJU1FoxBwv/4fghxaW
         Yjv+CVPYtYhRWGioUFL9TrctF7tGkeXkd/lM4=
MIME-Version: 1.0
In-Reply-To: <20110203175657.GD14627@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	<1295891761-18366-10-git-send-email-catalin.marinas@arm.com>
	<20110203175657.GD14627@n2100.arm.linux.org.uk>
Date: Thu, 3 Feb 2011 22:00:12 +0000
X-Google-Sender-Auth: V_kkkOH1HCFXel61T-OugMFyZto
Message-ID: <AANLkTi=A+cNYm4gvCksw7+LfT0tx6JnXLv3YYuf9M0YB@mail.gmail.com>
Subject: Re: [PATCH v4 09/19] ARM: LPAE: Page table maintenance for the
 3-level format
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 February 2011 17:56, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jan 24, 2011 at 05:55:51PM +0000, Catalin Marinas wrote:
>> The patch also introduces the L_PGD_SWAPPER flag to mark pgd entries
>> pointing to pmd tables pre-allocated in the swapper_pg_dir and avoid
>> trying to free them at run-time. This flag is 0 with the classic page
>> table format.
>
> This shouldn't be necessary.

I tried hard to find a simple way around this but couldn't, so any
suggestion is welcomed. Basically we have two situations where
pgd_alloc/pgd_free are called: (1) new user mm and (2) identity
mapping. As long as we allocate a PMD for the modules/pkmap mappings,
we need to make sure it is freed (more why this allocation is needed
below).

For (1), we can (safely?) assume that we always have a vma in the same
1GB range with the MODULES_VADDR. I suspect the stack always gets at
the top of TASK_SIZE.

For (2), there is no guarantee that this PMD is freed, so we need to
explicit freeing in pgd_free().

But we can't simply try to free the previously allocated PMD
corresponding to MODULES_VADDR. There is a situation when the user
page tables had been cleared and we get an abort for modules/pkmap. We
than copy (safely, that's only temporarily used) the corresponding
pgd_k entry (1GB) into the soon to be freed pgd. At this point
pgd_free() would try to free the PMD from swapper_pg_dir and that's
not possible.

The L_PGD_SWAPPER also comes in handy when setting up identity
mappings. Since the top PGD entries (starting with PAGE_OFFSET >>
PGDIR_SHIFT) are copied by pgd_alloc from swapper_pg_dir, we don't
want the init pgd being corrupted when PHYS_OFFSET > PAGE_OFFSET.
Hence we check L_PGD_SWAPPER and allocate another PMD if necessary.
But at some point we need to free such PMD and can't blindly try to
free the swapper_pg_dir pages.

>> diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
>> index 709244c..003587d 100644
>> --- a/arch/arm/mm/pgd.c
>> +++ b/arch/arm/mm/pgd.c
>> @@ -10,6 +10,7 @@
>>  #include <linux/mm.h>
>>  #include <linux/gfp.h>
>>  #include <linux/highmem.h>
>> +#include <linux/slab.h>
>>
>>  #include <asm/pgalloc.h>
>>  #include <asm/page.h>
>> @@ -17,6 +18,14 @@
>>
>>  #include "mm.h"
>>
>> +#ifdef CONFIG_ARM_LPAE
>> +#define __pgd_alloc()        kmalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL)
>> +#define __pgd_free(pgd)      kfree(pgd)
>> +#else
>> +#define __pgd_alloc()        (pgd_t *)__get_free_pages(GFP_KERNEL, 2)
>> +#define __pgd_free(pgd)      free_pages((unsigned long)pgd, 2)
>> +#endif
>> +
>>  /*
>>   * need to get a 16k page for level 1
>>   */
>> @@ -26,7 +35,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>>       pmd_t *new_pmd, *init_pmd;
>>       pte_t *new_pte, *init_pte;
>>
>> -     new_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL, 2);
>> +     new_pgd = __pgd_alloc();
>>       if (!new_pgd)
>>               goto no_pgd;
>>
>> @@ -41,12 +50,21 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>>
>>       clean_dcache_area(new_pgd, PTRS_PER_PGD * sizeof(pgd_t));
>>
>> +#ifdef CONFIG_ARM_LPAE
>> +     /*
>> +      * Allocate PMD table for modules and pkmap mappings.
>> +      */
>> +     new_pmd = pmd_alloc(mm, new_pgd + pgd_index(MODULES_VADDR), 0);
>> +     if (!new_pmd)
>> +             goto no_pmd;
>
> This should be a copy of the same page tables found in swapper_pg_dir -
> that's what the memcpy() above is doing.

The memcpy() above only copied between 1 and 3 entries in the pgd_k
(corresponding to 1 to 3GB kernel space). It doesn't copy the entry
corresponding to 1GB below PAGE_OFFSET that would be used by modules.
We need to allocate a new PMD for that.

The problem with the current memory map is that one PGD entry covers
1GB and the one corresponding to MODULES_VADDR is shared between user
and kernel. An alternative would be to move the kernel a bit higher
(and allow MODULES_VADDR at a 1GB boundary. The PAGE_OFFSET would be
something like 3GB + 16M, though I'm not sure what other implications
this would have.

Yet another alternative which I don't like at all is to pretend that
we only have 2 levels of page tables and always allocate 4 PMD pages +
1 PGD.

>> +#endif
>> +
>>       if (!vectors_high()) {
>>               /*
>>                * On ARM, first page must always be allocated since it
>>                * contains the machine vectors.
>>                */
>> -             new_pmd = pmd_alloc(mm, new_pgd, 0);
>> +             new_pmd = pmd_alloc(mm, new_pgd + pgd_index(0), 0);
>
> However, the first pmd table, and the first pte table only need to be
> present for the reason stated in the comment, and these need to be
> allocated.

The above change is harmless, I just added it for correctness.

>>               if (!new_pmd)
>>                       goto no_pmd;
>>
>> @@ -66,7 +84,7 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>>  no_pte:
>>       pmd_free(mm, new_pmd);
>>  no_pmd:
>> -     free_pages((unsigned long)new_pgd, 2);
>> +     __pgd_free(new_pgd);
>>  no_pgd:
>>       return NULL;
>>  }
>> @@ -80,20 +98,36 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd_base)
>>       if (!pgd_base)
>>               return;
>>
>> -     pgd = pgd_base + pgd_index(0);
>> -     if (pgd_none_or_clear_bad(pgd))
>> -             goto no_pgd;
>> +     if (!vectors_high()) {
>
> No, that's wrong.  As FIRST_USER_ADDRESS is nonzero, the first pmd and
> pte table will remain allocated in spite of free_pgtables(), so this
> results in a memory leak.

I agree (and I replied to my own post earlier today), we found the
leak in testing. It is safe to remove this hunk (I had a thought that
it may trigger a bad pmd because of the identity mapping but that's
cleared already via identity_mapping_del().

>> +             pgd = pgd_base + pgd_index(0);
>> +             if (pgd_none_or_clear_bad(pgd))
>> +                     goto no_pgd;
>>
>> -     pmd = pmd_offset(pgd, 0);
>> -     if (pmd_none_or_clear_bad(pmd))
>> -             goto no_pmd;
>> +             pmd = pmd_offset(pgd, 0);
>> +             if (pmd_none_or_clear_bad(pmd))
>> +                     goto no_pmd;
>>
>> -     pte = pmd_pgtable(*pmd);
>> -     pmd_clear(pmd);
>> -     pte_free(mm, pte);
>> +             pte = pmd_pgtable(*pmd);
>> +             pmd_clear(pmd);
>> +             pte_free(mm, pte);
>>  no_pmd:
>> -     pgd_clear(pgd);
>> -     pmd_free(mm, pmd);
>> +             pgd_clear(pgd);
>> +             pmd_free(mm, pmd);
>> +     }
>>  no_pgd:
>> -     free_pages((unsigned long) pgd_base, 2);
>> +#ifdef CONFIG_ARM_LPAE
>> +     /*
>> +      * Free modules/pkmap or identity pmd tables.
>> +      */
>> +     for (pgd = pgd_base; pgd < pgd_base + PTRS_PER_PGD; pgd++) {
>> +             if (pgd_none_or_clear_bad(pgd))
>> +                     continue;
>> +             if (pgd_val(*pgd) & L_PGD_SWAPPER)
>> +                     continue;
>> +             pmd = pmd_offset(pgd, 0);
>> +             pgd_clear(pgd);
>> +             pmd_free(mm, pmd);
>> +     }
>> +#endif
>
> And as kernel mappings in the pgd above TASK_SIZE are supposed to be
> identical across all page tables, this shouldn't be necessary.

For tasks yes, but what about the identity mapping allocations? We
could change the name of pgd_alloc() and add another parameter to
distinguish between these two scenarios.

-- 
Catalin
