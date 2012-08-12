Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2HLDDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 23:03:13 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62087 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2HLDDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 23:03:12 -0400
Date: Sat, 11 Aug 2012 23:03:09 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/22] ARM: use late patch framework for phys-virt
 patching
In-Reply-To: <1344648306-15619-4-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208112238270.5231@xanadu.home>
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-4-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Cyril Chemparathy wrote:

> This patch replaces the original physical offset patching implementation
> with one that uses the newly added patching framework.  In the process, we now
> unconditionally initialize the __pv_phys_offset and __pv_offset globals in the
> head.S code.

This last sentence is now wrong.

[...]
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index e965f1b..3d93779 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -18,6 +18,8 @@
>  #include <linux/types.h>
>  #include <linux/sizes.h>
>  
> +#include <asm/runtime-patch.h>
> +
>  #ifdef CONFIG_NEED_MACH_MEMORY_H
>  #include <mach/memory.h>
>  #endif
> @@ -151,35 +153,21 @@
>  #ifndef __virt_to_phys
>  #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
>  
> -/*
> - * Constants used to force the right instruction encodings and shifts
> - * so that all we need to do is modify the 8-bit constant field.
> - */
> -#define __PV_BITS_31_24	0x81000000
> -
> -extern unsigned long __pv_phys_offset;
> -#define PHYS_OFFSET __pv_phys_offset
> -
> -#define __pv_stub(from,to,instr,type)			\
> -	__asm__("@ __pv_stub\n"				\
> -	"1:	" instr "	%0, %1, %2\n"		\
> -	"	.pushsection .pv_table,\"a\"\n"		\
> -	"	.long	1b\n"				\
> -	"	.popsection\n"				\
> -	: "=r" (to)					\
> -	: "r" (from), "I" (type))
> +extern unsigned long	__pv_offset;
> +extern unsigned long	__pv_phys_offset;
> +#define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)

What was wrong with the former PHYS_OFFSET = __pv_phys_offset ?

If you really want to have it optimized at run time, you could simply 
use your new stub to patch a mov instruction instead of going through 
__virt_to_phys which uses and add on top of a constant.

>  static inline unsigned long __virt_to_phys(unsigned long x)
>  {
>  	unsigned long t;
> -	__pv_stub(x, t, "add", __PV_BITS_31_24);
> +	early_patch_imm8("add", t, x, __pv_offset, 0);
>  	return t;
>  }
>  
>  static inline unsigned long __phys_to_virt(unsigned long x)
>  {
>  	unsigned long t;
> -	__pv_stub(x, t, "sub", __PV_BITS_31_24);
> +	early_patch_imm8("sub", t, x, __pv_offset, 0);
>  	return t;
>  }
>  #else
> diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
> index 60d3b73..6b388f8 100644
> --- a/arch/arm/kernel/armksyms.c
> +++ b/arch/arm/kernel/armksyms.c
> @@ -152,7 +152,3 @@ EXPORT_SYMBOL(mcount);
>  #endif
>  EXPORT_SYMBOL(__gnu_mcount_nc);
>  #endif
> -
> -#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
> -EXPORT_SYMBOL(__pv_phys_offset);
> -#endif
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 3db960e..69a3c09 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -117,7 +117,7 @@ ENTRY(stext)
>  	bl	__fixup_smp
>  #endif
>  #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
> -	bl	__fixup_pv_table
> +	bl	__fixup_pv_offsets
>  #endif
>  	bl	__create_page_tables
>  
> @@ -511,92 +511,29 @@ ENDPROC(fixup_smp)
>  
>  #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
>  
> -/* __fixup_pv_table - patch the stub instructions with the delta between
> - * PHYS_OFFSET and PAGE_OFFSET, which is assumed to be 16MiB aligned and
> - * can be expressed by an immediate shifter operand. The stub instruction
> - * has a form of '(add|sub) rd, rn, #imm'.
> +/*
> + * __fixup_pv_offsets - update __pv_offset and __pv_phys_offset based on the
> + * runtime location of the kernel.
>   */
>  	__HEAD
> -__fixup_pv_table:
> +__fixup_pv_offsets:
>  	adr	r0, 1f
> -	ldmia	r0, {r3-r5, r7}
> +	ldmia	r0, {r3-r6}
>  	sub	r3, r0, r3	@ PHYS_OFFSET - PAGE_OFFSET
> -	add	r4, r4, r3	@ adjust table start address
> -	add	r5, r5, r3	@ adjust table end address
> -	add	r7, r7, r3	@ adjust __pv_phys_offset address
> -	str	r8, [r7]	@ save computed PHYS_OFFSET to __pv_phys_offset
> -	mov	r6, r3, lsr #24	@ constant for add/sub instructions
> -	teq	r3, r6, lsl #24 @ must be 16MiB aligned
> -THUMB(	it	ne		@ cross section branch )
> -	bne	__error
> -	str	r6, [r7, #4]	@ save to __pv_offset
> -	b	__fixup_a_pv_table
> -ENDPROC(__fixup_pv_table)
> +	add	r4, r4, r3	@ virt_to_phys(__pv_phys_offset)
> +	add	r5, r5, r3	@ virt_to_phys(__pv_offset)
> +	add	r6, r6, r3	@ virt_to_phys(PAGE_OFFSET) = PHYS_OFFSET
> +	str	r6, [r4]	@ save __pv_phys_offset
> +	str	r3, [r5]	@ save __pv_offset
> +	mov	pc, lr
> +ENDPROC(__fixup_pv_offsets)
>  
>  	.align
>  1:	.long	.
> -	.long	__pv_table_begin
> -	.long	__pv_table_end
> -2:	.long	__pv_phys_offset
> -
> -	.text
> -__fixup_a_pv_table:
> -#ifdef CONFIG_THUMB2_KERNEL
> -	lsls	r6, #24
> -	beq	2f
> -	clz	r7, r6
> -	lsr	r6, #24
> -	lsl	r6, r7
> -	bic	r6, #0x0080
> -	lsrs	r7, #1
> -	orrcs	r6, #0x0080
> -	orr	r6, r6, r7, lsl #12
> -	orr	r6, #0x4000
> -	b	2f
> -1:	add     r7, r3
> -	ldrh	ip, [r7, #2]
> -	and	ip, 0x8f00
> -	orr	ip, r6	@ mask in offset bits 31-24
> -	strh	ip, [r7, #2]
> -2:	cmp	r4, r5
> -	ldrcc	r7, [r4], #4	@ use branch for delay slot
> -	bcc	1b
> -	bx	lr
> -#else
> -	b	2f
> -1:	ldr	ip, [r7, r3]
> -	bic	ip, ip, #0x000000ff
> -	orr	ip, ip, r6	@ mask in offset bits 31-24
> -	str	ip, [r7, r3]
> -2:	cmp	r4, r5
> -	ldrcc	r7, [r4], #4	@ use branch for delay slot
> -	bcc	1b
> -	mov	pc, lr
> +	.long	__pv_phys_offset
> +	.long	__pv_offset
> +	.long	PAGE_OFFSET
>  #endif
> -ENDPROC(__fixup_a_pv_table)
> -
> -ENTRY(fixup_pv_table)
> -	stmfd	sp!, {r4 - r7, lr}
> -	ldr	r2, 2f			@ get address of __pv_phys_offset
> -	mov	r3, #0			@ no offset
> -	mov	r4, r0			@ r0 = table start
> -	add	r5, r0, r1		@ r1 = table size
> -	ldr	r6, [r2, #4]		@ get __pv_offset
> -	bl	__fixup_a_pv_table
> -	ldmfd	sp!, {r4 - r7, pc}
> -ENDPROC(fixup_pv_table)
>  
> -	.align
> -2:	.long	__pv_phys_offset
> -
> -	.data
> -	.globl	__pv_phys_offset
> -	.type	__pv_phys_offset, %object
> -__pv_phys_offset:
> -	.long	0
> -	.size	__pv_phys_offset, . - __pv_phys_offset
> -__pv_offset:
> -	.long	0
> -#endif
>  
>  #include "head-common.S"
> diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
> index dcebf80..ac13dd5 100644
> --- a/arch/arm/kernel/module.c
> +++ b/arch/arm/kernel/module.c
> @@ -317,11 +317,6 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
>  					         maps[i].txt_sec->sh_addr,
>  					         maps[i].txt_sec->sh_size);
>  #endif
> -#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
> -	s = find_mod_section(hdr, sechdrs, ".pv_table");
> -	if (s)
> -		fixup_pv_table((void *)s->sh_addr, s->sh_size);
> -#endif
>  	s = find_mod_section(hdr, sechdrs, ".runtime.patch.table");
>  	if (s)
>  		runtime_patch((void *)s->sh_addr, s->sh_size);

I missed this in the previous patch, but could you fail the module 
loading by returning an error if runtime_patch() fails?  That would take 
care of not accepting modules that might have been compiled with future 
runtime patching extensions that are not yet supported in an earlier 
kernel.

You also should remove the MODULE_ARCH_VERMAGIC_P2V definitions now that 
the corresponding code is no longer there.


Nicolas
