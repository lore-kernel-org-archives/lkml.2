Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab1GXNlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 09:41:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42182 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab1GXNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 09:41:03 -0400
Date: Sun, 24 Jul 2011 15:40:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110724134046.GA10583@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <20110724111350.GD21120@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724111350.GD21120@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

thanks for taking the time to look at this in detail.

On Sun, Jul 24, 2011 at 07:13:50AM -0400, Ingo Molnar wrote:
> 
> (Cc:-ed Linus and akpm)
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > This patch provides performance tuning for the "Bulldozer" CPU. With its
> > shared instruction cache there is a chance of generating an excessive
> > number of cache cross-invalidates when running specific workloads on the
> > cores of a compute module.
> > 
> > This excessive amount of cross-invalidations can be observed if cache
> > lines backed by shared physical memory alias in bits [14:12] of their
> > virtual addresses, as those bits are used for the index generation.
> > 
> > This patch addresses the issue by zeroing out the slice [14:12] of
> > the file mapping's virtual address at generation time, thus forcing
> > those bits the same for all mappings of a single shared library across
> > processes and, in doing so, avoids instruction cache aliases.
> 
> So all commonly-aliased virtual mappings of the same pages should be 
> 32K granular aligned for good performance? Seems rather unfortunate 
> for a modern CPU - is this going to be the case for all family 0x15 
> CPUs?

Right, this gets enabled on all F15h by default for now... The thing
is, the invalidations appear only in certain cases and when the two
tasks run on the cores of one compute module. However, due to the
scheduler migrating them, we need to have those VA assignments aligned
(or unaliased) at process creation.

Another possibility would be to not 32K align but never schedule them
on the same compute module but that won't fly with n tasks and n cores
scenario.

> > It also adds the kernel command line option
> > "unalias_va_addr=(32|64|off)" with which virtual address unaliasing
> > can be enabled for 32-bit or 64-bit x86 individually, or be completely
> > disabled.
> 
> So the default behavior is to have this aligning enabled.

Yes, it gets enabled on F15h by default.

> > This change leaves virtual region address allocation on other families
> > and/or vendors unaffected.
> > 
> > Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> > Signed-off-by: Martin Pohlack <martin.pohlack@amd.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  Documentation/kernel-parameters.txt |    6 ++++
> >  arch/x86/include/asm/elf.h          |   36 +++++++++++++++++++++++++++
> >  arch/x86/kernel/cpu/amd.c           |    7 +++++
> >  arch/x86/kernel/sys_x86_64.c        |   46 ++++++++++++++++++++++++++++++++--
> >  arch/x86/mm/mmap.c                  |   15 -----------
> >  arch/x86/vdso/vma.c                 |   10 +++++++
> >  6 files changed, 102 insertions(+), 18 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index fd248a31..17eda04 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2535,6 +2535,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			Note that genuine overcurrent events won't be
> >  			reported either.
> >  
> > +	unalias_va_addr
> > +			[X86-64] Unalias VA address by clearing slice [14:12]
> > +			1: only on 32-bit
> > +			2: only on 64-bit
> > +			off: disabled on both 32 and 64-bit
> 
> This says nothing about why it's cleared, what it does and why one 
> would want to handle it differently on 32-bit and 64-bit.

This is there in case users care more about the 3bits ASLR granularity
than invalidations amount, for example. I'll make this more descriptive.

[..]

> > +extern int unalias_va_addr;
> > +static inline unsigned long unalias_addr(unsigned long addr, bool incr)
> > +{
> > +	/* handle both 32- and 64-bit with a single conditional */
> > +	if (!(unalias_va_addr & (2 - mmap_is_ia32())))
> > +		return addr;
> > +
> > +	/* check if [14:12] are already cleared */
> > +	if (!(addr & (0x7 << PAGE_SHIFT)))
> > +		return addr;
> > +
> > +	addr = addr & ~(0x7 << PAGE_SHIFT);
> > +	if (incr)
> > +		addr += (0x8 << PAGE_SHIFT);
> > +
> > +	return addr;
> > +}
> 
> Looks too big to be inlined.

Ok, will change.

> Also, there's no explanation what the 'incr' logic is about and why it
> adds 32K to the address. Is this round-up logic in disguise?

Basically yes. Round-up and -down, actually. The idea
is for the unalias_addr() helper to be called both from
arch_get_unmapped_area_topdown() and arch_get_unmapped_area() depending
on the search direction we take in the VA space. So 'incr' says whether
we increment the last cached VA addr (mm->free_area_cache) or we
decrement. In both cases, it changes addr so that its bits [14:12] are
zeros.

> >  #endif /* _ASM_X86_ELF_H */
> > diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> > index b13ed39..2d380c6 100644
> > --- a/arch/x86/kernel/cpu/amd.c
> > +++ b/arch/x86/kernel/cpu/amd.c
> > @@ -458,6 +458,13 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
> >  					"with P0 frequency!\n");
> >  		}
> >  	}
> > +
> > +	if (unalias_va_addr == -1) {
> > +		if (c->x86 == 0x15)
> > +			unalias_va_addr = UNALIAS_VA_32 | UNALIAS_VA_64;
> > +		else
> > +			unalias_va_addr = 0;
> 
> the placement here feels a bit wrong - don't we have run-once CPU 
> quirks?

Maybe another func ptr in struct x86_cpuinit_ops
(arch/x86/kernel/x86_init.c) would be a better place?

> > +	}
> >  }
> >  
> >  static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> > diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
> > index ff14a50..323c411 100644
> > --- a/arch/x86/kernel/sys_x86_64.c
> > +++ b/arch/x86/kernel/sys_x86_64.c
> > @@ -18,6 +18,30 @@
> >  #include <asm/ia32.h>
> >  #include <asm/syscalls.h>
> >  
> > +/* see Documentation/kernel-parameters.txt */
> > +int unalias_va_addr = -1;
> 
> used by hot VM code so this really wants to be __read_mostly ...

Ok.

> > +
> > +static int __init control_va_addr_unaliasing(char *str)
> > +{
> > +	if (*str == 0)
> > +		return 1;
> > +
> > +	if (*str == '=')
> > +		str++;
> > +
> > +	if (!strcmp(str, "32"))
> > +		unalias_va_addr = UNALIAS_VA_32;
> > +	else if (!strcmp(str, "64"))
> > +		unalias_va_addr = UNALIAS_VA_64;
> > +	else if (!strcmp(str, "off"))
> > +		unalias_va_addr = 0;
> > +	else
> > +		return 0;
> 
> there's no 'both'/'all' setting: while it can be achieved by leaving 
> out this boot option (i.e. using the default) we generally try to 
> allow the setting of all combinations.

My reasoning here was that it gets enabled on F15h by default but we
don't want it on the remaining families. This is additionally to tweak
the behavior on F15h only but theoretically you could enable it on
everything else. I think I want to restrict the visibility/modifiability
of this option to F15h only.

> > +
> > +	return 1;
> > +}
> > +__setup("unalias_va_addr", control_va_addr_unaliasing);
> > +
> >  SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
> >  		unsigned long, prot, unsigned long, flags,
> >  		unsigned long, fd, unsigned long, off)
> > @@ -92,6 +116,9 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
> >  	start_addr = addr;
> >  
> >  full_search:
> > +	if (filp)
> > +		addr = unalias_addr(addr, true);
> > +
> >  	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
> >  		/* At this point:  (!vma || addr < vma->vm_end). */
> >  		if (end - len < addr) {
> > @@ -117,6 +144,9 @@ full_search:
> >  			mm->cached_hole_size = vma->vm_start - addr;
> >  
> >  		addr = vma->vm_end;
> > +
> > +		if (filp)
> > +			addr = unalias_addr(addr, true);
> 
> Instead of polluting the code with 'if (filp)' conditions (which is 
> really a property specific to this VA placement quirk) please push it 
> into the address alignment function so that it looks like this:
> 
> 	addr = cache_aliasing_quirk(addr, filp);
> 
> or so. (see further below about the 'unalias' naming.)

Ok, will do.

I was also thinking of doing something similar to ALTERNATIVE_JUMP
but instead of looking at a CPU feature bit, it can check a generic
conditional evaluated at runtime and patch in an unconditional 'jmp' to
make this codepath even cheaper. But this maybe later.

> >  
> > @@ -161,10 +191,17 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
> >  
> >  	/* make sure it can fit in the remaining address space */
> >  	if (addr > len) {
> > -		vma = find_vma(mm, addr-len);
> > -		if (!vma || addr <= vma->vm_start)
> > +		unsigned long tmp_addr = addr;
> > +
> > +		if (filp)
> > +			tmp_addr = unalias_addr(addr - len, false);
> > +		else
> > +			tmp_addr = tmp_addr - len;
> 
> This too could be written cleaner with the updated helper.

Sure, will do.

[..]

> > diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
> > index 7abd2be..a48dfd2 100644
> > --- a/arch/x86/vdso/vma.c
> > +++ b/arch/x86/vdso/vma.c
> > @@ -69,6 +69,16 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
> >  	addr = start + (offset << PAGE_SHIFT);
> >  	if (addr >= end)
> >  		addr = end;
> > +
> > +	if (unalias_va_addr) {
> > +		/*
> > +		 * page-align it here so that get_unmapped_area doesn't
> > +		 * align it wrongfully again to the next page
> > +		 */
> > +		addr = PAGE_ALIGN(addr);
> > +		addr = unalias_addr(addr, false);
> > +	}
> 
> Well, this cuts 3 bits from the randomization granularity. It would 
> be better to extend the scope/range of randomization beyond the 
> current PMD_SIZE range instead of cutting it.
> 
> (Arguably it would also make sense to increase vdso randomization 
> beyond a 2MB range as well, but that's beyond this patch.)

AFAIU, this would cost us 2 pages: a PMD and a PTE if we don't keep the
vDSO in the same PTE as the comment above vdso_addr() puts it:

/* Put the vdso above the (randomized) stack with another randomized offset.
   This way there is no hole in the middle of address space.
   To save memory make sure it is still in the same PTE as the stack top.
   This doesn't give that many random bits */

Hmm..

> also, the PAGE_ALIGN() complication here looks unnecessary - can the 
> vdso 'addr' ever be not 4K aligned above?

Yeah, it can. I did some trace_printk runs and 'addr' wasn't 4K aligned
in some cases. I think this is because of the stack randomization we do
and we use mm->start_stack to get the vdso base address. Unfortunately,
I can't find those traces anymore but will do some again tomorrow.

> Thirdly, we stick this vdso_addr() result into a get_unmapped_area() 
> call - which does an unalias_addr() call yet another time, right? So 
> why the two separate calls?

Right, in order to unalias the address, I check if we have a file
mapping which backs it - if (filp) - and this is not the case for the
vDSO. And if the address is not 4K aligned and we unalias it first and
_then_ align it, resulting in not what we want.

But speaking of file mappings, the better fix should be to pass
protection flags down to get_unmapped_area() from do_mmap_pgoff()
so that we can check against PROT_EXEC and only then change the
address. However, this would require changes all over the place since
->get_unmapped_area is part of fs file_operations, etc, etc.

It still works this way too, anyway, because for example:

$ cat /proc/self/maps
...

7f19429b1000-7f1942b2b000 r-xp 00000000 08:01 4112535                    /lib/x86_64-linux-gnu/libc-2.13.so
7f1942b2b000-7f1942d2b000 ---p 0017a000 08:01 4112535                    /lib/x86_64-linux-gnu/libc-2.13.so
7f1942d2b000-7f1942d2f000 r--p 0017a000 08:01 4112535                    /lib/x86_64-linux-gnu/libc-2.13.so
7f1942d2f000-7f1942d30000 rw-p 0017e000 08:01 4112535                    /lib/x86_64-linux-gnu/libc-2.13.so

when we do the first "r-xp" mapping above, we do

get_unmapped_area(filp != NULL, addr = 0...)

and we change the address accordingly, but the follow-up mappings come
in either with MAP_FIXED set so we return the requested address early
or they're anonymous mappings for .bss and RO data which have no file
backing anyways.

> Also, a naming nit: i find the whole 'unalias' language above rather 
> confusing in this context: AFAICS the point is to intentionally 
> *align* those mappings. While that technically 'unaliases' them in 
> CPU cache coherency lingo, the code you are modifying here is VM code 
> where 'unaliasing' can mean a number of other things, none of which 
> are related to this problem.
> 
> 'Aligning' a mapping to a given granularity is a common expression 
> though.

Yes, makes sense, will change.

Thanks again for the review.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
