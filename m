Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1GXLOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 07:14:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1GXLOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 07:14:44 -0400
Date: Sun, 24 Jul 2011 13:13:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andre Przywara <andre.przywara@amd.com>,
        Martin Pohlack <martin.pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110724111350.GD21120@elte.hu>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311340547-7861-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Linus and akpm)

* Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> This patch provides performance tuning for the "Bulldozer" CPU. With its
> shared instruction cache there is a chance of generating an excessive
> number of cache cross-invalidates when running specific workloads on the
> cores of a compute module.
> 
> This excessive amount of cross-invalidations can be observed if cache
> lines backed by shared physical memory alias in bits [14:12] of their
> virtual addresses, as those bits are used for the index generation.
> 
> This patch addresses the issue by zeroing out the slice [14:12] of
> the file mapping's virtual address at generation time, thus forcing
> those bits the same for all mappings of a single shared library across
> processes and, in doing so, avoids instruction cache aliases.

So all commonly-aliased virtual mappings of the same pages should be 
32K granular aligned for good performance? Seems rather unfortunate 
for a modern CPU - is this going to be the case for all family 0x15 
CPUs?

> It also adds the kernel command line option
> "unalias_va_addr=(32|64|off)" with which virtual address unaliasing
> can be enabled for 32-bit or 64-bit x86 individually, or be completely
> disabled.

So the default behavior is to have this aligning enabled.

> 
> This change leaves virtual region address allocation on other families
> and/or vendors unaffected.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> Signed-off-by: Martin Pohlack <martin.pohlack@amd.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  Documentation/kernel-parameters.txt |    6 ++++
>  arch/x86/include/asm/elf.h          |   36 +++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/amd.c           |    7 +++++
>  arch/x86/kernel/sys_x86_64.c        |   46 ++++++++++++++++++++++++++++++++--
>  arch/x86/mm/mmap.c                  |   15 -----------
>  arch/x86/vdso/vma.c                 |   10 +++++++
>  6 files changed, 102 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index fd248a31..17eda04 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2535,6 +2535,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Note that genuine overcurrent events won't be
>  			reported either.
>  
> +	unalias_va_addr
> +			[X86-64] Unalias VA address by clearing slice [14:12]
> +			1: only on 32-bit
> +			2: only on 64-bit
> +			off: disabled on both 32 and 64-bit

This says nothing about why it's cleared, what it does and why one 
would want to handle it differently on 32-bit and 64-bit.

> +
>  	unknown_nmi_panic
>  			[X86] Cause panic on unknown NMI.
>  
> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index f2ad216..89e38a4 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -4,6 +4,7 @@
>  /*
>   * ELF register definitions..
>   */
> +#include <linux/thread_info.h>
>  
>  #include <asm/ptrace.h>
>  #include <asm/user.h>
> @@ -320,4 +321,39 @@ extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
>  extern unsigned long arch_randomize_brk(struct mm_struct *mm);
>  #define arch_randomize_brk arch_randomize_brk
>  
> +/*
> + * True on X86_32 or when emulating IA32 on X86_64
> + */
> +static inline int mmap_is_ia32(void)
> +{
> +#ifdef CONFIG_X86_32
> +	return 1;
> +#endif
> +#ifdef CONFIG_IA32_EMULATION
> +	if (test_thread_flag(TIF_IA32))
> +		return 1;
> +#endif
> +	return 0;
> +}
> +
> +#define UNALIAS_VA_32 1
> +#define UNALIAS_VA_64 2
> +
> +extern int unalias_va_addr;
> +static inline unsigned long unalias_addr(unsigned long addr, bool incr)
> +{
> +	/* handle both 32- and 64-bit with a single conditional */
> +	if (!(unalias_va_addr & (2 - mmap_is_ia32())))
> +		return addr;
> +
> +	/* check if [14:12] are already cleared */
> +	if (!(addr & (0x7 << PAGE_SHIFT)))
> +		return addr;
> +
> +	addr = addr & ~(0x7 << PAGE_SHIFT);
> +	if (incr)
> +		addr += (0x8 << PAGE_SHIFT);
> +
> +	return addr;
> +}

Looks too big to be inlined.

Also, there's no explanation what the 'incr' logic is about and why 
it adds 32K to the address. Is this round-up logic in disguise?

>  #endif /* _ASM_X86_ELF_H */
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index b13ed39..2d380c6 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -458,6 +458,13 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
>  					"with P0 frequency!\n");
>  		}
>  	}
> +
> +	if (unalias_va_addr == -1) {
> +		if (c->x86 == 0x15)
> +			unalias_va_addr = UNALIAS_VA_32 | UNALIAS_VA_64;
> +		else
> +			unalias_va_addr = 0;

the placement here feels a bit wrong - don't we have run-once CPU 
quirks?

> +	}
>  }
>  
>  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
> index ff14a50..323c411 100644
> --- a/arch/x86/kernel/sys_x86_64.c
> +++ b/arch/x86/kernel/sys_x86_64.c
> @@ -18,6 +18,30 @@
>  #include <asm/ia32.h>
>  #include <asm/syscalls.h>
>  
> +/* see Documentation/kernel-parameters.txt */
> +int unalias_va_addr = -1;

used by hot VM code so this really wants to be __read_mostly ...

> +
> +static int __init control_va_addr_unaliasing(char *str)
> +{
> +	if (*str == 0)
> +		return 1;
> +
> +	if (*str == '=')
> +		str++;
> +
> +	if (!strcmp(str, "32"))
> +		unalias_va_addr = UNALIAS_VA_32;
> +	else if (!strcmp(str, "64"))
> +		unalias_va_addr = UNALIAS_VA_64;
> +	else if (!strcmp(str, "off"))
> +		unalias_va_addr = 0;
> +	else
> +		return 0;

there's no 'both'/'all' setting: while it can be achieved by leaving 
out this boot option (i.e. using the default) we generally try to 
allow the setting of all combinations.

> +
> +	return 1;
> +}
> +__setup("unalias_va_addr", control_va_addr_unaliasing);
> +
>  SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
>  		unsigned long, prot, unsigned long, flags,
>  		unsigned long, fd, unsigned long, off)
> @@ -92,6 +116,9 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
>  	start_addr = addr;
>  
>  full_search:
> +	if (filp)
> +		addr = unalias_addr(addr, true);
> +
>  	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
>  		/* At this point:  (!vma || addr < vma->vm_end). */
>  		if (end - len < addr) {
> @@ -117,6 +144,9 @@ full_search:
>  			mm->cached_hole_size = vma->vm_start - addr;
>  
>  		addr = vma->vm_end;
> +
> +		if (filp)
> +			addr = unalias_addr(addr, true);

Instead of polluting the code with 'if (filp)' conditions (which is 
really a property specific to this VA placement quirk) please push it 
into the address alignment function so that it looks like this:

	addr = cache_aliasing_quirk(addr, filp);

or so. (see further below about the 'unalias' naming.)

>  	}
>  }
>  
> @@ -161,10 +191,17 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
>  
>  	/* make sure it can fit in the remaining address space */
>  	if (addr > len) {
> -		vma = find_vma(mm, addr-len);
> -		if (!vma || addr <= vma->vm_start)
> +		unsigned long tmp_addr = addr;
> +
> +		if (filp)
> +			tmp_addr = unalias_addr(addr - len, false);
> +		else
> +			tmp_addr = tmp_addr - len;

This too could be written cleaner with the updated helper.

> +
> +		vma = find_vma(mm, tmp_addr);
> +		if (!vma || tmp_addr + len <= vma->vm_start)
>  			/* remember the address as a hint for next time */
> -			return mm->free_area_cache = addr-len;
> +			return mm->free_area_cache = tmp_addr;
>  	}
>  
>  	if (mm->mmap_base < len)
> @@ -173,6 +210,9 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
>  	addr = mm->mmap_base-len;
>  
>  	do {
> +		if (filp)
> +			addr = unalias_addr(addr, false);
> +
>  		/*
>  		 * Lookup failure means no vma is above this address,
>  		 * else if new region fits below vma->vm_start,
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 1dab519..d4c0736 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -51,21 +51,6 @@ static unsigned int stack_maxrandom_size(void)
>  #define MIN_GAP (128*1024*1024UL + stack_maxrandom_size())
>  #define MAX_GAP (TASK_SIZE/6*5)
>  
> -/*
> - * True on X86_32 or when emulating IA32 on X86_64
> - */
> -static int mmap_is_ia32(void)
> -{
> -#ifdef CONFIG_X86_32
> -	return 1;
> -#endif
> -#ifdef CONFIG_IA32_EMULATION
> -	if (test_thread_flag(TIF_IA32))
> -		return 1;
> -#endif
> -	return 0;
> -}
> -
>  static int mmap_is_legacy(void)
>  {
>  	if (current->personality & ADDR_COMPAT_LAYOUT)
> diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> index 7abd2be..a48dfd2 100644
> --- a/arch/x86/vdso/vma.c
> +++ b/arch/x86/vdso/vma.c
> @@ -69,6 +69,16 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
>  	addr = start + (offset << PAGE_SHIFT);
>  	if (addr >= end)
>  		addr = end;
> +
> +	if (unalias_va_addr) {
> +		/*
> +		 * page-align it here so that get_unmapped_area doesn't
> +		 * align it wrongfully again to the next page
> +		 */
> +		addr = PAGE_ALIGN(addr);
> +		addr = unalias_addr(addr, false);
> +	}

Well, this cuts 3 bits from the randomization granularity. It would 
be better to extend the scope/range of randomization beyond the 
current PMD_SIZE range instead of cutting it.

(Arguably it would also make sense to increase vdso randomization 
beyond a 2MB range as well, but that's beyond this patch.)

also, the PAGE_ALIGN() complication here looks unnecessary - can the 
vdso 'addr' ever be not 4K aligned above?

Thirdly, we stick this vdso_addr() result into a get_unmapped_area() 
call - which does an unalias_addr() call yet another time, right? So 
why the two separate calls?

> +
>  	return addr;
>  }

Also, a naming nit: i find the whole 'unalias' language above rather 
confusing in this context: AFAICS the point is to intentionally 
*align* those mappings. While that technically 'unaliases' them in 
CPU cache coherency lingo, the code you are modifying here is VM code 
where 'unaliasing' can mean a number of other things, none of which 
are related to this problem.

'Aligning' a mapping to a given granularity is a common expression 
though.

Thanks,

	Ingo
