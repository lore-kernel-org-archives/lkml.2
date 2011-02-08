Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab1BHFQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:16:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63508 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab1BHFQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rhT0XBDDtQpra+0GFpmPqDoWrfNkVA71KdfvzZYEH+HSYor/RXsjXvA3BZ5CPtPXD3
         so86FjV8U8f4vGxe0RxWR5eOrbmxQL8xvGMW6X55W3c0R0x54ZhoglWqj7Dhgcat63pv
         T3rltM+qHH2uDWi7Qj9tD4JQYBKi64unSQQxM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102071858230.7277@kaball-desktop>
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop>
	<4D4A3782.3050702@zytor.com>
	<alpine.DEB.2.00.1102031114030.7277@kaball-desktop>
	<4D4ADFAD.7060507@zytor.com>
	<alpine.DEB.2.00.1102041130060.7277@kaball-desktop>
	<4D4CA568.70907@goop.org>
	<AANLkTi=nEQka_19+nKQC-yJn2Czn9GCqsUWN6Byy7rCF@mail.gmail.com>
	<4D4E4E0D.2080806@zytor.com>
	<4D4EF553.6000000@kernel.org>
	<alpine.DEB.2.00.1102071524140.7277@kaball-desktop>
	<alpine.DEB.2.00.1102071858230.7277@kaball-desktop>
Date: Mon, 7 Feb 2011 21:16:27 -0800
X-Google-Sender-Auth: 0-alprStSC9R11CPWMdoXUA35pM
Message-ID: <AANLkTimcdVvmhBr6g_Eo0kWX9mdeNmXjd=CBQrvUGm8S@mail.gmail.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 11:00 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 7 Feb 2011, Stefano Stabellini wrote:
>> On Sun, 6 Feb 2011, Yinghai Lu wrote:
>> > On 02/05/2011 11:30 PM, H. Peter Anvin wrote:
>> > > On 02/05/2011 11:02 PM, Yinghai Lu wrote:
>> > >> why not just move calling cleanup_highmap down?
>> > >>
>> > >> something like attached patch.
>> > >
>> > > This patch looks very clean and looks on the surface of it like it is
>> > > removing some ugly ad hoc code, but (as always) it needs a description
>> > > about the problem it solves and why it is correct.
>> >
>> > Sure.
>> >
>> >
>> > Jeremy and xen guys, can you please check if it works well with xen ?
>> >
>>
>> Actually this patch makes things worse on xen, because before
>> cleanup_highmap() wasn't called at all on xen (on purpose) and now it
>> is, fully destroying all the mappings we have at _end.
>>
>> Can we add a check on memblock reserved regions in cleanup_highmap()?
>
> In case you are wondering how Yinghai Lu's patch would look like with
> the added check, here it is:
>
>
> diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
> index 19ae14b..184f778 100644
> --- a/arch/x86/include/asm/memblock.h
> +++ b/arch/x86/include/asm/memblock.h
> @@ -3,6 +3,7 @@
>
>  #define ARCH_DISCARD_MEMBLOCK
>
> +bool memblock_check_reserved_size(u64 *addrp, u64 *sizep, u64 align);
>  u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
>  void memblock_x86_to_bootmem(u64 start, u64 end);
>
> diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
> index 975f709..28686b6 100644
> --- a/arch/x86/include/asm/pgtable_64.h
> +++ b/arch/x86/include/asm/pgtable_64.h
> @@ -165,7 +165,7 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
>  #define __swp_entry_to_pte(x)          ((pte_t) { .pte = (x).val })
>
>  extern int kern_addr_valid(unsigned long addr);
> -extern void cleanup_highmap(void);
> +extern void cleanup_highmap(unsigned long end);
>
>  #define HAVE_ARCH_UNMAPPED_AREA
>  #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 2d2673c..5655c22 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -77,9 +77,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
>        /* Make NULL pointers segfault */
>        zap_identity_mappings();
>
> -       /* Cleanup the over mapped high alias */
> -       cleanup_highmap();
> -
>        max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
>
>        for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index d3cfe26..91afde6 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -297,6 +297,9 @@ static void __init init_gbpages(void)
>  static inline void init_gbpages(void)
>  {
>  }
> +static void __init cleanup_highmap(unsigned long end)
> +{
> +}
>  #endif
>
>  static void __init reserve_brk(void)
> @@ -922,6 +925,9 @@ void __init setup_arch(char **cmdline_p)
>         */
>        reserve_brk();
>
> +       /* Cleanup the over mapped high alias after _brk_end*/
> +       cleanup_highmap(_brk_end);
> +
>        memblock.current_limit = get_max_mapped();
>        memblock_x86_fill();
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 947f42a..f13ff3a 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -279,25 +279,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>        load_cr3(swapper_pg_dir);
>  #endif
>
> -#ifdef CONFIG_X86_64
> -       if (!after_bootmem && !start) {
> -               pud_t *pud;
> -               pmd_t *pmd;
> -
> -               mmu_cr4_features = read_cr4();
> -
> -               /*
> -                * _brk_end cannot change anymore, but it and _end may be
> -                * located on different 2M pages. cleanup_highmap(), however,
> -                * can only consider _end when it runs, so destroy any
> -                * mappings beyond _brk_end here.
> -                */
> -               pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
> -               pmd = pmd_offset(pud, _brk_end - 1);
> -               while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
> -                       pmd_clear(pmd);
> -       }
> -#endif
>        __flush_tlb_all();
>
>        if (!after_bootmem && e820_table_end > e820_table_start)
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 71a5929..028c49e 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -297,18 +297,26 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
>  * rounded up to the 2MB boundary. This catches the invalid pmds as
>  * well, as they are located before _text:
>  */
> -void __init cleanup_highmap(void)
> +void __init cleanup_highmap(unsigned long end)
>  {
>        unsigned long vaddr = __START_KERNEL_map;
> -       unsigned long end = roundup((unsigned long)_end, PMD_SIZE) - 1;
>        pmd_t *pmd = level2_kernel_pgt;
>        pmd_t *last_pmd = pmd + PTRS_PER_PMD;
> +       u64 size, addrp;
> +       bool changed;
> +
> +       end = roundup(end, PMD_SIZE) - 1;
>
>        for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
>                if (pmd_none(*pmd))
>                        continue;
> -               if (vaddr < (unsigned long) _text || vaddr > end)
> -                       set_pmd(pmd, __pmd(0));
> +               if (vaddr < (unsigned long) _text || vaddr > end) {
> +                       addrp = __pa(vaddr);
> +                       size = PMD_SIZE;
> +                       changed = memblock_check_reserved_size(&addrp, &size, PMD_SIZE);
> +                       if (!changed && size)
> +                               set_pmd(pmd, __pmd(0));
> +               }

for native path, memblock_check_reserved_size() are called 256 times
without obvious reasons.

Yinghai
