Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1FHAsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 20:48:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:41391 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab1FHAsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 20:48:00 -0400
Subject: Re: [PATCH] [RFC][V3] bluegene: use MMU feature flag to
 conditionalize L1 writethrough code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
In-Reply-To: <1307482573-25440-1-git-send-email-ericvh@gmail.com>
References: <1307482573-25440-1-git-send-email-ericvh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 10:47:37 +1000
Message-ID: <1307494057.2874.212.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 16:36 -0500, Eric Van Hensbergen wrote:
> BG/P nodes need to be configured for writethrough to work in SMP
> configurations.  This patch adds the right hooks in the MMU code
> to make sure BGP_L1_WRITETHROUGH configurations are setup for BG/P.

Ok so getting better, some comments tho :-)

> RFC note: this essentially just changes the ifdefs to use the
> BEGIN_MMU_FTR_SECTION macros.  A couple of things that I really didn't
> like about this:
>   a) we introduced at least one extra op that isn't needed to get around
>      otherwise having multiple labels

Not 100% which one you are talking about but that's fixable, I'll put
comments inline in the code. Note that you can nest feature sections
using the _NESTED variants and you can use "alternates" to replace
sequences of code.

>   b) we are introducting a bunch of no-ops in places that could be critical
>      paths and jimix says this may not be the best thing for multiple reasons
>      including having no-ops around the DCBZs is a bad thing

Right, best to use code sequence replacement with the "alternate"
variants, see below

>   c) the ELSE_MMU_FTR_SECTION stuff appears to be broken (or I don't know
>      how to use it, it gave me the error:
>        Error: non-constant expression in ".if" statement
>      so I switched out the else clauses with redundant FTR_SECTIONS
>      (one for IFSET and on for IFCLR).  Please someone throw me a clue
>      as to what I was doing wrong.  I'm running gcc 4.3.2 from crosstools-ng
>      if it has some sort of impact.

Hrm, not sure how you tried to use it, it should work, but you need to
use the "ALT" variants.

> Jimix has thrown me some code to try and do a better job by branching
> to stub code inside of the MMU_FTRs so I don't have so many no-ops.  I'm
> open to alternatives.  jimix also suggested changing NEED_L1_WRITETHROUGH
> to DCBZ_BROKEN, which I'm open to if you think appropriate, or maybe
> DCBZ_BROKEN_DAMNIT would be more apt.

:-)

I think NEED_L1_WRITETHROUGH isn't great since we are dealing with more
than just that here. Let's call it 44x_SMP since afaik, all
implementations, whether it's BG or other variants of the same hack
(AMCC/APM has one too) need the same stuff here, no ?

Let's not use more than one feature bit, it's not needed in practice, a
better name is all we need. Might even call it MMU_FTR_BLUEGENE_44x_SMP
if you want.

I'll add comments inline:

>  #define PPC44x_MMUCR_TID	0x000000ff
>  #define PPC44x_MMUCR_STS	0x00010000
> +#define PPC44x_MMUCR_U2		0x00200000

Please document in a comment what is the effect of U2 on the BG/P ASIC
caches.

>  #define	PPC44x_TLB_PAGEID	0
>  #define	PPC44x_TLB_XLAT		1
> @@ -32,6 +33,7 @@
>  
>  /* Storage attribute and access control fields */
>  #define PPC44x_TLB_ATTR_MASK	0x0000ff80
> +#define PPC44x_TLB_WL1		0x00100000	/* Write-through L1 */
>  #define PPC44x_TLB_U0		0x00008000      /* User 0 */
>  #define PPC44x_TLB_U1		0x00004000      /* User 1 */
>  #define PPC44x_TLB_U2		0x00002000      /* User 2 */
> diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
> index 5e12b74..9a9a4ee 100644
> --- a/arch/powerpc/kernel/head_44x.S
> +++ b/arch/powerpc/kernel/head_44x.S
> @@ -429,7 +429,17 @@ finish_tlb_load_44x:
>  	andi.	r10,r12,_PAGE_USER		/* User page ? */
>  	beq	1f				/* nope, leave U bits empty */
>  	rlwimi	r11,r11,3,26,28			/* yes, copy S bits to U */
> -1:	tlbwe	r11,r13,PPC44x_TLB_ATTRIB	/* Write ATTRIB */
> +1:
> +BEGIN_MMU_FTR_SECTION
> +	andi.	r10, r11, PPC44x_TLB_I
> +	bne	2f
> +	oris    r11,r11,PPC44x_TLB_WL1@h	/* Add coherency for */
> +						/* non-inhibited */
> +	ori	r11,r11,PPC44x_TLB_U2|PPC44x_TLB_M
> +END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)

That will do for now, tho it does add 4 nops in the normal case, we can
look at putting it out of line etc.. later. However, it would be
generally better if we could instead have those bits in the PTE.

We can look at doing that as a later optimisation. For example, we could
define _PAGE_COHERENT as a variable when BGP support is enabled, and
initialize it to contain the U2 and WL1 bits.

Something like this in pte-44x.h

#ifdef CONFIG_PPC_BLUEGENE_SMP
#ifndef __ASSEMBLY__
extern unsigned int _page_coherent;
#define _PAGE_COHERENT _page_coherent
#define __PAGE_COHERENT	0x200
#define __PAGE_U2 0x2000
#endif
#else
#define _PAGE_COHERENT 0x200
#endif

And somewhere in 44x-mmu.c:MMU_init_hw()

if (mmu_has_feature(....))
	_page_coherent = __PAGE_COHERENT | _PAGE_U2;

You still need -one- single instruction in the TLB code to
rlwimi either bit into WL1 (why the heck did the HW need that many bits
for the same thing ?) because WL1 falls outside of the current attrib
mask and it would be more work to actually sort that out, but that's
a single instruction, and it can still be inside the feature section.

That has the advantage of removing the conditional on I from the hot
path as well.

> +2:
> +	tlbwe	r11,r13,PPC44x_TLB_ATTRIB	/* Write ATTRIB */
>  
>  	/* Done...restore registers and get out of here.
>  	*/
> @@ -799,7 +809,12 @@ skpinv:	addi	r4,r4,1				/* Increment */
>  	sync
>  
>  	/* Initialize MMUCR */
> +BEGIN_MMU_FTR_SECTION
> +	lis	r5, PPC44x_MMUCR_U2@h
> +END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
> +BEGIN_MMU_FTR_SECTION
>  	li	r5,0
> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>  	mtspr	SPRN_MMUCR,r5
>  	sync

Use an alternate, something like:

BEGIN_MMU_FTR_SECTION
	lis	r5, PPC44x_MMUCR_U2@h
MMU_FTR_SECTION_ELSE
  	li	r5,0
ALT_END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)

BTW. Care to explain to me why you have U2 -both- in the arguments to
tlbwe and in MMUCR ? That doesn't look right to me... which one is used
where and when ?

> @@ -814,7 +829,15 @@ skpinv:	addi	r4,r4,1				/* Increment */
>  	/* attrib fields */
>  	/* Added guarded bit to protect against speculative loads/stores */
>  	li	r5,0
> -	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
> +BEGIN_MMU_FTR_SECTION
> +	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
> +						PPC44x_TLB_G | PPC44x_TLB_U2)
> +	oris	r5,r5,PPC44x_TLB_WL1@h
> +END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
> +BEGIN_MMU_FTR_SECTION
> +	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
> +			PPC44x_TLB_G)
> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>  
>          li      r0,63                    /* TLB slot 63 */

This isn't going to work. This happens before the CPU feature bits are
established.

I see two ways out of that dilemna:

 - One is you find a way to identify the BG case at runtime from that
very early asm code. It's a bit tricky since we never added the MMU type
information to the device-tree blob header (but we're adding it to ePAPR
via a register iirc, so we could hijack that), or maybe via inspecting
what the FW left behind in the TLB...

 - Another one is to leave the stuff as-is, and "fixup" the TLB entry
from MMU_init_hw(). At that point, we haven't started the secondary CPU
yet anyways, tho we'd have to make sure we flush the cache before we
"switch" the TLB entry to make sure all changes we made are visible
before we change the cache setting.

> diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
> index 998a100..b54e2e8 100644
> --- a/arch/powerpc/kernel/misc_32.S
> +++ b/arch/powerpc/kernel/misc_32.S
> @@ -506,7 +506,27 @@ _GLOBAL(clear_pages)
>  	li	r0,PAGE_SIZE/L1_CACHE_BYTES
>  	slw	r0,r0,r4
>  	mtctr	r0
> -1:	dcbz	0,r3
> +	li      r4, 0
> +1:
> +BEGIN_MMU_FTR_SECTION
> +	/* assuming 32 byte cacheline */
> +	stw     r4, 0(r3)
> +	stw     r4, 4(r3)
> +	stw     r4, 8(r3)
> +	stw     r4, 12(r3)
> +	stw     r4, 16(r3)
> +	stw     r4, 20(r3)
> +	stw     r4, 24(r3)
> +	stw     r4, 28(r3)
> +END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
> +/*
> + * would have used an ELSE_MMU_FTR_SECTION here but it
> + * broke the code with Error: non-constant expression in ".if" statement
> + *
> + */
> +BEGIN_MMU_FTR_SECTION
> +	dcbz	0,r3
> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>  	addi	r3,r3,L1_CACHE_BYTES
>  	bdnz	1b
>  	blr
> @@ -550,7 +570,9 @@ _GLOBAL(copy_page)
>  	mtctr	r0
>  1:
>  	dcbt	r11,r4
> +BEGIN_MMU_FTR_SECTION
>  	dcbz	r5,r3
> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>  	COPY_16_BYTES
>  #if L1_CACHE_BYTES >= 32
>  	COPY_16_BYTES

Instead here I would just do a single feature section as the first
instruction of clear_pages() that covers a branch out of line to an
alternate implementation of the whole function.

_GLOBAL(clear_pages)
BEGIN_MMU_FTR_SECTION
  	b	clear_pages_no_dcbz
END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
	.../...

> diff --git a/arch/powerpc/lib/copy_32.S b/arch/powerpc/lib/copy_32.S
> index 55f19f9..2646838 100644
> --- a/arch/powerpc/lib/copy_32.S
> +++ b/arch/powerpc/lib/copy_32.S
> @@ -12,6 +12,7 @@
>  #include <asm/cache.h>
>  #include <asm/errno.h>
>  #include <asm/ppc_asm.h>
> +#include <asm/mmu.h>

This is a bit more nasty. At some point we'll have to butcher that code
in order to deal with 440 and 476 that have different cache line sizes
and which we still want in the same kernel binary. In the meantime
I'd do like previously and just duplicate the whole lot with just a
single branch out.

Note that I fail to see how your cachable_memzero can be correct since
you don't replace dcbz with anything. On the other hand, the only user
of it in the entire tree is ... clearing the hash table in ppc_mmu_32.c
which we don't use on 440.

So why don't you just make a separate patch that just completely gets
rid of cachable_memzero() and use a memset in ppc_mmu_32.c ? I don't
think anybody will notice the difference....

For cachable_memcpy and copy_tofrom_user, just removing the dcbz's will
do for now, though I wonder whether we could just remove cachable_memcpy
as well. The only user is the EMAC driver and I doubt anybody will be
able to measure the difference. It will make everbody life easier in the
long term to remove those.

>  #define COPY_16_BYTES		\
>  	lwz	r7,4(r4);	\
> @@ -98,7 +99,10 @@ _GLOBAL(cacheable_memzero)
>  	bdnz	4b
>  3:	mtctr	r9
>  	li	r7,4
> -10:	dcbz	r7,r6
> +10:
> +BEGIN_MMU_FTR_SECTION
> +	dcbz	r7,r6
> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>  	addi	r6,r6,CACHELINE_BYTES
>  	bdnz	10b
>  	clrlwi	r5,r8,32-LG_CACHELINE_BYTES
> @@ -187,7 +191,9 @@ _GLOBAL(cacheable_memcpy)
>  	mtctr	r0
>  	beq	63f
>  53:
> +BEGIN_MMU_FTR_SECTION
>  	dcbz	r11,r6
> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>  	COPY_16_BYTES
>  #if L1_CACHE_BYTES >= 32
>  	COPY_16_BYTES
> @@ -368,7 +374,10 @@ _GLOBAL(__copy_tofrom_user)
>  	mtctr	r8
>  
>  53:	dcbt	r3,r4
> -54:	dcbz	r11,r6
> +54:
> +BEGIN_MMU_FTR_SECTION
> +	dcbz	r11,r6
> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>  	.section __ex_table,"a"
>  	.align	2
>  	.long	54b,105f
> diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
> index 024acab..f5c60b3 100644
> --- a/arch/powerpc/mm/44x_mmu.c
> +++ b/arch/powerpc/mm/44x_mmu.c
> @@ -80,9 +80,12 @@ static void __init ppc44x_pin_tlb(unsigned int virt, unsigned int phys)
>  	:
>  #ifdef CONFIG_PPC47x
>  	: "r" (PPC47x_TLB2_S_RWX),
> -#else
> +#elseif CONFIG_BGP_L1_WRITETHROUGH
> +	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_WL1 \
> +		| PPC44x_TLB_U2 | PPC44x_TLB_M),
> +#else /* neither CONFIG_PPC47x or CONFIG_BGP_L1_WRITETHROUGH */
>  	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G),
> -#endif
> +#endif /* CONFIG_PPC47x */
>  	  "r" (phys),
>  	  "r" (virt | PPC44x_TLB_VALID | PPC44x_TLB_256M),
>  	  "r" (entry),

Make this conditional at runtime.

Cheers,
Ben.

