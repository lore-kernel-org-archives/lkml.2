Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2JEO6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:58:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36145 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab2JEO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:58:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210051205390.29232@kaball.uk.xensource.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
	<20121004164551.GA2244@phenom.dumpdata.com>
	<CAE9FiQWjXhat85JpXhCLApGe62mdCwb2HKhWGLjQdj2ed=6buA@mail.gmail.com>
	<CAE9FiQVnTqWx808F_CWaiGXT12Y4rfKPOERtSgGb=2t_4T44+A@mail.gmail.com>
	<506E029E.3000102@zytor.com>
	<CAE9FiQWPNmsw9OMrdP7Q0JnjGv66PBkAcJQhizUm0Kji-yvw8g@mail.gmail.com>
	<506E059B.40808@zytor.com>
	<CAE9FiQW2-mZHbBeUZcLY-nyb41TDvr7uonnfdAeAML5rc_ZhfA@mail.gmail.com>
	<alpine.DEB.2.02.1210051205390.29232@kaball.uk.xensource.com>
Date: Fri, 5 Oct 2012 07:58:22 -0700
X-Google-Sender-Auth: fAiyNmFMc_vtPaUD2-kCOHbMUho
Message-ID: <CAE9FiQV_xVsHN_+6ui_Vgnn6tk8UBOEKL+0XnoEN9VLw3gcOXA@mail.gmail.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 4:27 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Fri, 5 Oct 2012, Yinghai Lu wrote:
>> On Thu, Oct 4, 2012 at 2:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> >
>> > See my other post.  This is bringing up the Kernel Summit algorithm again.
>> >
>>
>> sure. please check if you are ok with attached one on top of x86/mm2
>>
>> Subject: [PATCH] x86: get early page table from BRK
>>
>> set pgt_buf early from BRK, and use it to map page table at first.
>>
>> also use the left at first, then use new extend one.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> If I read the patch correctly, it wouldn't actually change the pagetable
> allocation flow or implement Peter's suggestion.
> However it would pre-map (pgt_buf_start-pgt_buf_top) using brk memory.
>
> So, if that's correct, we could remove the early_memremap call from
> alloc_low_page and map_low_page, right?
>
> Also the patch introduces an additional range of pagetable pages
> (early_pgt_buf_start-early_pgt_buf_top) and that would need to be
> communicated somehow to Xen (that at the moment assumes that the range
> is pgt_buf_start-pgt_buf_top. Pretty bad).

that will need extra two lines for xen:
@@ -430,6 +439,8 @@ void __init init_mem_mapping(void)
 		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
 				PFN_PHYS(pgt_buf_end));
 	}
+	x86_init.mapping.pagetable_reserve(PFN_PHYS(early_pgt_buf_start),
+					PFN_PHYS(early_pgt_buf_end));

 	/* stop the wrong using */
 	pgt_buf_top = 0;


>
> Overall I still prefer Peter's suggestion :)
>
>
>> ---
>>  arch/x86/include/asm/init.h    |    4 ++++
>>  arch/x86/include/asm/pgtable.h |    1 +
>>  arch/x86/kernel/setup.c        |    2 ++
>>  arch/x86/mm/init.c             |   23 +++++++++++++++++++++++
>>  arch/x86/mm/init_32.c          |    8 ++++++--
>>  arch/x86/mm/init_64.c          |    8 ++++++--
>>  6 files changed, 42 insertions(+), 4 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/pgtable.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/pgtable.h
>> +++ linux-2.6/arch/x86/include/asm/pgtable.h
>> @@ -599,6 +599,7 @@ static inline int pgd_none(pgd_t pgd)
>>
>>  extern int direct_gbpages;
>>  void init_mem_mapping(void);
>> +void early_alloc_pgt_buf(void);
>>
>>  /* local pte updates need not use xchg for locking */
>>  static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
>> Index: linux-2.6/arch/x86/kernel/setup.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/setup.c
>> +++ linux-2.6/arch/x86/kernel/setup.c
>> @@ -950,6 +950,8 @@ void __init setup_arch(char **cmdline_p)
>>
>>       reserve_ibft_region();
>>
>> +     early_alloc_pgt_buf();
>> +
>>       /*
>>        * Need to conclude brk, before memblock_x86_fill()
>>        *  it could use memblock_find_in_range, could overlap with
>> Index: linux-2.6/arch/x86/mm/init.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/init.c
>> +++ linux-2.6/arch/x86/mm/init.c
>> @@ -21,6 +21,10 @@ unsigned long __initdata pgt_buf_start;
>>  unsigned long __meminitdata pgt_buf_end;
>>  unsigned long __meminitdata pgt_buf_top;
>>
>> +unsigned long __initdata early_pgt_buf_start;
>> +unsigned long __meminitdata early_pgt_buf_end;
>> +unsigned long __meminitdata early_pgt_buf_top;
>> +
>>  int after_bootmem;
>>
>>  int direct_gbpages
>> @@ -291,6 +295,11 @@ static void __init find_early_table_spac
>>       if (!base)
>>               panic("Cannot find space for the kernel page tables");
>>
>> +     init_memory_mapping(base, base + tables);
>> +     printk(KERN_DEBUG "kernel direct mapping tables from %#llx to %#llx @ [mem %#010lx-%#010lx]\n",
>> +             base, base + tables - 1, early_pgt_buf_start << PAGE_SHIFT,
>> +             (early_pgt_buf_end << PAGE_SHIFT) - 1);
>> +
>>       pgt_buf_start = base >> PAGE_SHIFT;
>>       pgt_buf_end = pgt_buf_start;
>>       pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
>> @@ -437,6 +446,20 @@ void __init init_mem_mapping(void)
>>       early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
>>  }
>>
>> +RESERVE_BRK(early_pgt_alloc, 16384);
>> +
>> +void  __init early_alloc_pgt_buf(void)
>> +{
>> +     unsigned long tables = 13864;
>> +     phys_addr_t base;
>> +
>> +     base = __pa(extend_brk(tables, PAGE_SIZE));
>> +
>> +     early_pgt_buf_start = base >> PAGE_SHIFT;
>> +     early_pgt_buf_end = early_pgt_buf_start;
>> +     early_pgt_buf_top = early_pgt_buf_start + (tables >> PAGE_SHIFT);
>> +}
>> +
>>  /*
>>   * devmem_is_allowed() checks to see if /dev/mem access to a certain address
>>   * is valid. The argument is a physical page number.
>> Index: linux-2.6/arch/x86/mm/init_32.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/init_32.c
>> +++ linux-2.6/arch/x86/mm/init_32.c
>> @@ -61,10 +61,14 @@ bool __read_mostly __vmalloc_start_set =
>>
>>  static __init void *alloc_low_page(void)
>>  {
>> -     unsigned long pfn = pgt_buf_end++;
>> +     unsigned long pfn;
>>       void *adr;
>>
>> -     if (pfn >= pgt_buf_top)
>> +     if (early_pgt_buf_end < early_pgt_buf_top)
>> +             pfn = early_pgt_buf_end++;
>> +     else if (pgt_buf_end < pgt_buf_top)
>> +             pfn = pgt_buf_end++;
>> +     else
>>               panic("alloc_low_page: ran out of memory");
>>
>>       adr = __va(pfn * PAGE_SIZE);
>> Index: linux-2.6/arch/x86/mm/init_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/mm/init_64.c
>> +++ linux-2.6/arch/x86/mm/init_64.c
>> @@ -318,7 +318,7 @@ void __init cleanup_highmap(void)
>>
>>  static __ref void *alloc_low_page(unsigned long *phys)
>>  {
>> -     unsigned long pfn = pgt_buf_end++;
>> +     unsigned long pfn;
>>       void *adr;
>>
>>       if (after_bootmem) {
>> @@ -328,7 +328,11 @@ static __ref void *alloc_low_page(unsign
>>               return adr;
>>       }
>>
>> -     if (pfn >= pgt_buf_top)
>> +     if (early_pgt_buf_end < early_pgt_buf_top)
>> +             pfn = early_pgt_buf_end++;
>> +     else if (pgt_buf_end < pgt_buf_top)
>> +             pfn = pgt_buf_end++;
>> +     else
>>               panic("alloc_low_page: ran out of memory");
>>
>>       adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
