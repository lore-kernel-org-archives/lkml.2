Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab0KWLiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:38:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37172 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0KWLiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:38:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uibH/ijahaHfuh3gIYlGFexwi6y0kmB0Q4Sa5765QLzZ8j0S4ROQLlLYMBo0FH7VhN
         pQjBG6ovEIxUd4YA2LOvNUhnN628AhLTy1KBOg3uHZmaFVQiGe0Sj8aKZIoJJILurAUq
         AeZKXgBisV3kmhxvbsaj7GQOd8u3qXlp7GoDE=
MIME-Version: 1.0
In-Reply-To: <20101122131010.GD31227@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-9-git-send-email-catalin.marinas@arm.com>
	<20101122131010.GD31227@n2100.arm.linux.org.uk>
Date: Tue, 23 Nov 2010 11:38:15 +0000
X-Google-Sender-Auth: -fPJhgXvCpJDNQHdc93j0_O1duU
Message-ID: <AANLkTikGVZ5Na0GSG5ynO+YM2M6x65yb3dwJeBZjzFMN@mail.gmail.com>
Subject: Re: [PATCH v2 08/20] ARM: LPAE: MMU setup for the 3-level page table format
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2010 13:10, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 12, 2010 at 06:00:28PM +0000, Catalin Marinas wrote:
>> This patch adds the MMU initialisation for the LPAE page table format.
>> The swapper_pg_dir size with LPAE is 5 rather than 4 pages. The
>> __v7_setup function configures the TTBRx split based on the PAGE_OFFSET
>> and sets the corresponding TTB control and MAIRx bits (similar to
>> PRRR/NMRR for TEX remapping). The 36-bit mappings (supersections) and
>> a few other memory types in mmu.c are conditionally compiled.
[...]
>> --- a/arch/arm/kernel/head.S
>> +++ b/arch/arm/kernel/head.S
>> @@ -21,6 +21,7 @@
>>  #include <asm/memory.h>
>>  #include <asm/thread_info.h>
>>  #include <asm/system.h>
>> +#include <asm/pgtable.h>
>>
>>  #ifdef CONFIG_DEBUG_LL
>>  #include <mach/debug-macro.S>
>> @@ -45,11 +46,20 @@
>>  #error KERNEL_RAM_VADDR must start at 0xXXXX8000
>>  #endif
>>
>> +#ifdef CONFIG_ARM_LPAE
>> +     /* LPAE requires an additional page for the PGD */
>> +#define PG_DIR_SIZE  0x5000
>> +#define PTE_WORDS    3
>> +#else
>> +#define PG_DIR_SIZE  0x4000
>> +#define PTE_WORDS    2
>
> PTE is not the right prefix here - we don't deal with the lowest level
> of page tables, which in Linux is called PTE.  I think you mean PMD_WORDS
> instead.

It should actually be something PMD_ORDER because of the log2 value.

>>  #ifdef CONFIG_XIP_KERNEL
>> @@ -129,11 +139,11 @@ __create_page_tables:
>>       pgtbl   r4                              @ page table address
>>
>>       /*
>> -      * Clear the 16K level 1 swapper page table
>> +      * Clear the swapper page table
>>        */
>>       mov     r0, r4
>>       mov     r3, #0
>> -     add     r6, r0, #0x4000
>> +     add     r6, r0, #PG_DIR_SIZE
>>  1:   str     r3, [r0], #4
>>       str     r3, [r0], #4
>>       str     r3, [r0], #4
>> @@ -141,6 +151,23 @@ __create_page_tables:
>>       teq     r0, r6
>>       bne     1b
>>
>> +#ifdef CONFIG_ARM_LPAE
>> +     /*
>> +      * Build the PGD table (first level) to point to the PMD table. A PGD
>> +      * entry is 64-bit wide and the top 32 bits are 0.
>> +      */
>> +     mov     r0, r4
>> +     add     r3, r4, #0x1000                 @ first PMD table address
>> +     orr     r3, r3, #3                      @ PGD block type
>> +     mov     r6, #4                          @ PTRS_PER_PGD
>> +1:   str     r3, [r0], #8                    @ set PGD entry
>> +     add     r3, r3, #0x1000                 @ next PMD table
>> +     subs    r6, r6, #1
>> +     bne     1b
>> +
>> +     add     r4, r4, #0x1000                 @ point to the PMD tables
>> +#endif
>> +
>>       ldr     r7, [r10, #PROCINFO_MM_MMUFLAGS] @ mm_mmuflags
>>
>>       /*
>> @@ -152,30 +179,30 @@ __create_page_tables:
>>       sub     r0, r0, r3                      @ virt->phys offset
>>       add     r5, r5, r0                      @ phys __enable_mmu
>>       add     r6, r6, r0                      @ phys __enable_mmu_end
>> -     mov     r5, r5, lsr #20
>> -     mov     r6, r6, lsr #20
>> +     mov     r5, r5, lsr #SECTION_SHIFT
>> +     mov     r6, r6, lsr #SECTION_SHIFT
>>
>> -1:   orr     r3, r7, r5, lsl #20             @ flags + kernel base
>> -     str     r3, [r4, r5, lsl #2]            @ identity mapping
>> -     teq     r5, r6
>> -     addne   r5, r5, #1                      @ next section
>> -     bne     1b
>> +1:   orr     r3, r7, r5, lsl #SECTION_SHIFT  @ flags + kernel base
>> +     str     r3, [r4, r5, lsl #PTE_WORDS]    @ identity mapping
>> +     cmp     r5, r6
>> +     addlo   r5, r5, #SECTION_SHIFT >> 20    @ next section
>> +     blo     1b
>>
>>       /*
>>        * Now setup the pagetables for our kernel direct
>>        * mapped region.
>>        */
>>       mov     r3, pc
>> -     mov     r3, r3, lsr #20
>> -     orr     r3, r7, r3, lsl #20
>> +     mov     r3, r3, lsr #SECTION_SHIFT
>> +     orr     r3, r7, r3, lsl #SECTION_SHIFT
>>       add     r0, r4,  #(KERNEL_START & 0xff000000) >> 18
>> -     str     r3, [r0, #(KERNEL_START & 0x00f00000) >> 18]!
>> +     str     r3, [r0, #(KERNEL_START & 0x00e00000) >> 18]!
>>       ldr     r6, =(KERNEL_END - 1)
>> -     add     r0, r0, #4
>> +     add     r0, r0, #1 << PTE_WORDS
>>       add     r6, r4, r6, lsr #18
>
> Are you sure these shifts by 18 places are correct?  They're actually
> (val >> SECTION_SHIFT) << 2, so maybe they should be (SECTION_SHIFT -
> PMD_WORDS) ?

SECTION_SHIFT - PMD_ORDER is (20 - 2) for classic page tables and (21
- 3) for LPAE. But we could change the 18 to some macros for
clarification (the line would be long though).

-- 
Catalin
