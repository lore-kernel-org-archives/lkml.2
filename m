Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2IXMGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:06:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33167 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2IXMGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:06:46 -0400
Date: Mon, 24 Sep 2012 13:06:37 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux@arm.linux.org.uk, catalin.marinas@arm.com, linus.walleij@linaro.org,
        will.deacon@arm.com, grant.likely@secretlab.ca,
        paul.gortmaker@windriver.com, vincent.guittot@linaro.org,
        nico@linaro.org, davidb@codeaurora.org, plagnioj@jcrosoft.com,
        arnd@arndb.de, marc.zyngier@arm.com, rob.herring@calxeda.com,
        vitalya@ti.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        frank.rowand@am.sony.com, sjg@chromium.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, rabin@rab.in,
        hsweeten@visionengravers.com, tj@kernel.org
Subject: Re: [PATCH v3 RESEND 01/17] ARM: add mechanism for late code patching
Message-ID: <20120924120637.GB2122@linaro.org>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
 <1348242975-19184-2-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348242975-19184-2-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:55:59AM -0400, Cyril Chemparathy wrote:
> The original phys_to_virt/virt_to_phys patching implementation relied on early
> patching prior to MMU initialization.  On PAE systems running out of >4G
> address space, this would have entailed an additional round of patching after
> switching over to the high address space.
> 
> The approach implemented here conceptually extends the original PHYS_OFFSET
> patching implementation with the introduction of "early" patch stubs.  Early
> patch code is required to be functional out of the box, even before the patch
> is applied.  This is implemented by inserting functional (but inefficient)
> load code into the .runtime.patch.code init section.  Having functional code
> out of the box then allows us to defer the init time patch application until
> later in the init sequence.

There are currently a few different patching mechanisms in the kernel, and
it would be good if we could collect more of them under some common
framework.

For example, it might be possible to do the SMP-on-UP fixups using the same
framework you propose.  Best not to attempt that yet, though.


Overall, this looks well thought out and useful, though it looks like it
has a few issues that need attention.

Comments below.

Cheers
---Dave

> In addition to fitting better with our need for physical address-space
> switch-over, this implementation should be somewhat more extensible by virtue
> of its more readable (and hackable) C implementation.  This should prove
> useful for other similar init time specialization needs, especially in light
> of our multi-platform kernel initiative.
> 
> This code has been boot tested in both ARM and Thumb-2 modes on an ARMv7
> (Cortex-A8) device.
> 
> Note: the obtuse use of stringified symbols in patch_stub() and
> early_patch_stub() is intentional.  Theoretically this should have been
> accomplished with formal operands passed into the asm block, but this requires
> the use of the 'c' modifier for instantiating the long (e.g. .long %c0).
> However, the 'c' modifier has been found to ICE certain versions of GCC, and
> therefore we resort to stringified symbols here.

You might find that the "n" constraint works.  The explanation in the
GCC docs is pretty incomprehensible, but at least it exists.

__stringify hacks are not uncommon anyway though, so it's not a problem
either way.

> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> ---
>  arch/arm/Kconfig                     |    3 +
>  arch/arm/include/asm/module.h        |    7 ++
>  arch/arm/include/asm/runtime-patch.h |  208 ++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/Makefile             |    1 +
>  arch/arm/kernel/module.c             |    9 +-
>  arch/arm/kernel/runtime-patch.c      |  193 +++++++++++++++++++++++++++++++
>  arch/arm/kernel/setup.c              |    3 +
>  arch/arm/kernel/vmlinux.lds.S        |   10 ++
>  8 files changed, 433 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/include/asm/runtime-patch.h
>  create mode 100644 arch/arm/kernel/runtime-patch.c
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 2f88d8d..98a3a1a 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -60,6 +60,9 @@ config ARM
>  config ARM_HAS_SG_CHAIN
>  	bool
>  
> +config ARM_RUNTIME_PATCH
> +	bool
> +
>  config NEED_SG_DMA_LENGTH
>  	bool
>  
> diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
> index 6c6809f..2090486 100644
> --- a/arch/arm/include/asm/module.h
> +++ b/arch/arm/include/asm/module.h
> @@ -43,9 +43,16 @@ struct mod_arch_specific {
>  #define MODULE_ARCH_VERMAGIC_ARMTHUMB ""
>  #endif
>  
> +#ifdef CONFIG_ARM_RUNTIME_PATCH
> +#define MODULE_ARCH_VERMAGIC_RT_PATCH "rt-patch "
> +#else
> +#define MODULE_ARCH_VERMAGIC_RT_PATCH ""
> +#endif
> +
>  #define MODULE_ARCH_VERMAGIC \
>  	MODULE_ARCH_VERMAGIC_ARMVSN \
>  	MODULE_ARCH_VERMAGIC_ARMTHUMB \
> +	MODULE_ARCH_VERMAGIC_RT_PATCH \
>  	MODULE_ARCH_VERMAGIC_P2V
>  
>  #endif /* _ASM_ARM_MODULE_H */
> diff --git a/arch/arm/include/asm/runtime-patch.h b/arch/arm/include/asm/runtime-patch.h
> new file mode 100644
> index 0000000..366444d
> --- /dev/null
> +++ b/arch/arm/include/asm/runtime-patch.h
> @@ -0,0 +1,208 @@
> +/*
> + * arch/arm/include/asm/runtime-patch.h
> + * Note: this file should not be included by non-asm/.h files
> + *
> + * Copyright 2012 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_ARM_RUNTIME_PATCH_H
> +#define __ASM_ARM_RUNTIME_PATCH_H
> +
> +#include <linux/stringify.h>
> +
> +#ifndef __ASSEMBLY__
> +
> +#ifdef CONFIG_ARM_RUNTIME_PATCH
> +
> +struct patch_info {
> +	void		*insn;
> +	u16		 type;
> +	u8		 insn_size;
> +	u8		 data_size;
> +	u32		 data[0];
> +};
> +
> +#define PATCH_IMM8		0x0001
> +struct patch_info_imm8 {
> +	u32		*imm;
> +	u32		 insn;
> +};
> +
> +#define patch_next(p)	((void *)(p) + sizeof(*(p)) + (p)->data_size)
> +#define patch_data(p)	((void *)&(p)->data[0])
> +
> +#define patch_stub(type, code, patch_data, ...)				\
> +	__asm__("@ patch stub\n"					\
> +		"1:\n"							\
> +		code							\
> +		"2:\n"							\
> +		"	.pushsection .runtime.patch.table, \"a\"\n"	\
> +		"3:\n"							\
> +		"	.word 1b\n"					\
> +		"	.hword (" __stringify(type) ")\n"		\
> +		"	.byte (2b-1b)\n"				\
> +		"	.byte (5f-4f)\n"				\
> +		"4:\n"							\
> +		patch_data						\
> +		"	.align\n"					\
> +		"5:\n"							\
> +		"	.popsection\n"					\
> +		__VA_ARGS__)
> +
> +#define early_patch_stub(type, code, pad, patch_data, ...)		\
> +	__asm__("@ patch stub\n"					\
> +		"1:\n"							\
> +		"	b	6f\n"					\
> +		"	.fill	" __stringify(pad) ", 1, 0\n"		\

What is the pad argument for?  It never seems to be set to anything other
than 0 in your series.

The compiler uses a pretty dumb heuristic to guess the size of asms:
4 * (number of ; or \n in the string)

Directives that the compiler can't predict the size of are not safe if
they output into any segment that the compiler uses.  .fill/.skip are
obvious candidates, but macro expansions, .rept, .irp etc. can cause
these problems too.

For example:

	void g(int);
	void f(void)
	{
		g(0xd00dfeed);
		asm(".skip 0x1000");
	}

If you try building this with gcc -marm -Os for example:

/tmp/ccXYm1uP.s: Assembler messages:
/tmp/ccXYm1uP.s:21: Error: bad immediate value for offset (4100)

...because the assembler assumes that it can dump a literal at the end
of the function and reference it from the g() callsite.


It may be that you have some intended future use for pad (such as
pasting one instruction sequence in place of another possibly
differently-sized sequence at fixup time), in which case this might
require a bit more thought.

> +		"2:\n"							\
> +		"	.pushsection .runtime.patch.table, \"a\"\n"	\
> +		"3:\n"							\
> +		"	.word 1b\n"					\
> +		"	.hword (" __stringify(type) ")\n"		\
> +		"	.byte (2b-1b)\n"				\
> +		"	.byte (5f-4f)\n"				\
> +		"4:\n"							\
> +		patch_data						\
> +		"	.align\n"					\
> +		"5:\n"							\
> +		"	.popsection\n"					\
> +		"	.pushsection .runtime.patch.code, \"ax\"\n"	\

I have a vague feeling that this should have .text in the name somewhere,
since it is code that gets executed in place.

> +		"6:\n"							\
> +		code							\
> +		"	b 2b\n"						\

.ltorg

(See [1] below.)

> +		"	.popsection\n"					\
> +		__VA_ARGS__)
> +
> +/* constant used to force encoding */
> +#define __IMM8		(0x81 << 24)
> +
> +/*
> + * patch_imm8() - init-time specialized binary operation (imm8 operand)
> + *		  This effectively does: to = from "insn" sym,
> + *		  where the value of sym is fixed at init-time, and is patched

If I've understood correctly, then this description is a bit misleading.
sym is not an absolute operand, but rather *(sym + ofs) is a
variable containing the fixup operand.

> + *		  in as an immediate operand.  This value must be
> + *		  representible as an 8-bit quantity with an optional
> + *		  rotation.
> + *
> + *		  The stub code produced by this variant is non-functional
> + *		  prior to patching.  Use early_patch_imm8() if you need the
> + *		  code to be functional early on in the init sequence.
> + */
> +#define patch_imm8(_insn, _to, _from, _sym, _ofs)			\

Why are the _sym and _ofs parameters separate?  Nothing in your series
seems to requre _sym to be a symbol or _ofs to be a number; and nothing
passes _ofs != 0, but anyway I don't see why the caller can't add those
two values together in the macro argument.

> +	patch_stub(							\
> +		/* type */						\
> +			PATCH_IMM8,					\
> +		/* code */						\
> +			_insn "	%[to], %[from], %[imm]\n",		\
> +		/* patch_data */					\
> +			".long " __stringify(_sym + _ofs) "\n"		\

If _sym or _ofs is a complex expression, the + may mis-bind.  If the
_ofs parameter is needed at all, it would probably be a good idea to
have parentheses around _sym and _ofs.

> +			_insn "	%[to], %[from], %[imm]\n",		\
> +		/* operands */						\
> +			: [to]	 "=r" (_to)				\
> +			: [from] "r"  (_from),				\
> +			  [imm]	 "I"  (__IMM8),				\
> +				 "i"  (&(_sym))				\
> +			: "cc")
> +
> +/*
> + * patch_imm8_mov() - same as patch_imm8(), but for mov/mvn instructions
> + */
> +#define patch_imm8_mov(_insn, _to, _sym, _ofs)				\
> +	patch_stub(							\
> +		/* type */						\
> +			PATCH_IMM8,					\
> +		/* code */						\
> +			_insn "	%[to], %[imm]\n",			\
> +		/* patch_data */					\
> +			".long " __stringify(_sym + _ofs) "\n"		\
> +			_insn "	%[to], %[imm]\n",			\
> +		/* operands */						\
> +			: [to]	"=r" (_to)				\
> +			: [imm]	"I"  (__IMM8),				\
> +				"i"  (&(_sym))				\
> +			: "cc")
> +
> +/*
> + * early_patch_imm8() - early functional variant of patch_imm8() above.  The
> + *			same restrictions on the constant apply here.  This
> + *			version emits workable (albeit inefficient) code at
> + *			compile-time, and therefore functions even prior to
> + *			patch application.
> + */
> +#define early_patch_imm8(_insn, _to, _from, _sym, _ofs)			\
> +do {									\
> +	unsigned long __tmp;						\
> +	early_patch_stub(						\
> +		/* type */						\
> +			PATCH_IMM8,					\
> +		/* code */						\
> +			"ldr	%[tmp], =" __stringify(_sym + _ofs) "\n"\

This would not be OK if assembled into the .text section, for the reasons
described above.  (The compiler doesn't know about the extra data word
injected by the ldr= pseudo-instruction.)

early_patch_stub puts <code> into a custom section, so that's OK.

However, there's still nothing to ensure that the literal word is in
range of the load.  That can be fixed with an .ltorg to dump out the
literal(s) right after the branch following <code> in early_patch_stub.

> +			"ldr	%[tmp], [%[tmp]]\n"			\
> +			_insn "	%[to], %[from], %[tmp]\n",		\
> +		/* pad */						\
> +			0,						\
> +		/* patch_data */					\
> +			".long " __stringify(_sym + _ofs) "\n"		\
> +			_insn "	%[to], %[from], %[imm]\n",		\
> +		/* operands */						\
> +			: [to]	 "=r"  (_to),				\
> +			  [tmp]	 "=&r" (__tmp)				\
> +			: [from] "r"   (_from),				\
> +			  [imm]	 "I"   (__IMM8),			\
> +				 "i"   (&(_sym))			\
> +			: "cc");					\

Should we have "cc" here?

Since this macro is only used with a single instruction _insn, there
would be no way to make use of a condition set by that instruction.

Therefore, flag-setting instructions don't really make any sense here,
and "cc" could be removed.

If so, it could make sense for the apply_patch_imm8() implementation
to check for and reject flag-setting encodings.

> +} while (0)
> +
> +#define early_patch_imm8_mov(_insn, _to, _sym, _ofs)			\
> +do {									\
> +	unsigned long __tmp;						\
> +	early_patch_stub(						\
> +		/* type */						\
> +			PATCH_IMM8					\
> +		/* code */						\
> +			"ldr	%[tmp], =" __stringify(_sym + _ofs) "\n"\
> +			"ldr	%[tmp], [%[tmp]]\n"			\
> +			_insn "	%[to], %[tmp]\n",			\
> +		/* pad */						\
> +			0,						\
> +		/* patch_data */					\
> +			".long " __stringify(_sym + _ofs) "\n"		\
> +			_insn " %[to], %[imm]\n",			\
> +		/* operands */						\
> +			: [to]	"=r"  (_to),				\
> +			  [tmp]	"=&r" (__tmp)				\
> +			: [imm]	"I"   (__IMM8),				\
> +				"i"   (&(_sym))				\
> +			: "cc");					\
> +} while (0)
> +
> +int runtime_patch(const void *table, unsigned size);
> +void runtime_patch_kernel(void);
> +
> +#else
> +
> +static inline int runtime_patch(const void *table, unsigned size)
> +{
> +	return 0;
> +}
> +
> +static inline void runtime_patch_kernel(void)
> +{
> +}
> +
> +#endif /* CONFIG_ARM_RUNTIME_PATCH */
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* __ASM_ARM_RUNTIME_PATCH_H */
> diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
> index 7ad2d5c..0b16b94 100644
> --- a/arch/arm/kernel/Makefile
> +++ b/arch/arm/kernel/Makefile
> @@ -81,5 +81,6 @@ endif
>  head-y			:= head$(MMUEXT).o
>  obj-$(CONFIG_DEBUG_LL)	+= debug.o
>  obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
> +obj-$(CONFIG_ARM_RUNTIME_PATCH)	+= runtime-patch.o patch.o
>  
>  extra-y := $(head-y) vmlinux.lds
> diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
> index 1e9be5d..10a2922 100644
> --- a/arch/arm/kernel/module.c
> +++ b/arch/arm/kernel/module.c
> @@ -24,6 +24,7 @@
>  #include <asm/sections.h>
>  #include <asm/smp_plat.h>
>  #include <asm/unwind.h>
> +#include <asm/runtime-patch.h>
>  
>  #ifdef CONFIG_XIP_KERNEL
>  /*
> @@ -276,7 +277,7 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
>  	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
>  	const Elf_Shdr *sechdrs_end = sechdrs + hdr->e_shnum;
>  	struct mod_unwind_map maps[ARM_SEC_MAX];
> -	int i;
> +	int i, err;
>  
>  	memset(maps, 0, sizeof(maps));
>  
> @@ -321,6 +322,12 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
>  	if (s)
>  		fixup_pv_table((void *)s->sh_addr, s->sh_size);
>  #endif
> +	s = find_mod_section(hdr, sechdrs, ".runtime.patch.table");
> +	if (s) {
> +		err = runtime_patch((void *)s->sh_addr, s->sh_size);
> +		if (err)
> +			return err;
> +	}
>  	s = find_mod_section(hdr, sechdrs, ".alt.smp.init");
>  	if (s && !is_smp())
>  #ifdef CONFIG_SMP_ON_UP
> diff --git a/arch/arm/kernel/runtime-patch.c b/arch/arm/kernel/runtime-patch.c
> new file mode 100644
> index 0000000..28a6367
> --- /dev/null
> +++ b/arch/arm/kernel/runtime-patch.c
> @@ -0,0 +1,193 @@
> +/*
> + * arch/arm/kernel/runtime-patch.c
> + *
> + * Copyright 2012 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +
> +#include <asm/opcodes.h>
> +#include <asm/cacheflush.h>
> +#include <asm/runtime-patch.h>
> +
> +#include "patch.h"
> +
> +static inline void flush_icache_insn(void *insn_ptr, int bytes)
> +{
> +	unsigned long insn_addr = (unsigned long)insn_ptr;
> +	flush_icache_range(insn_addr, insn_addr + bytes - 1);
> +}

This function appears unused.

Do we actually do the cache flushing anywhere?

> +
> +#ifdef CONFIG_THUMB2_KERNEL
> +
> +static int do_patch_imm8(u32 insn, u32 imm, u32 *ninsn)
> +{
> +	u32 op, rot, val;
> +	const u32 supported_ops = (BIT(0)  | /* and */
> +				   BIT(1)  | /* bic */
> +				   BIT(2)  | /* orr/mov */
> +				   BIT(3)  | /* orn/mvn */
> +				   BIT(4)  | /* eor */
> +				   BIT(8)  | /* add */
> +				   BIT(10) | /* adc */
> +				   BIT(11) | /* sbc */
> +				   BIT(12) | /* sub */
> +				   BIT(13)); /* rsb */
> +
> +	insn = __mem_to_opcode_thumb32(insn);
> +
> +	if (!__opcode_is_thumb32(insn)) {
> +		pr_err("patch: invalid thumb2 insn %08x\n", insn);
> +		return -EINVAL;
> +	}
> +
> +	/* allow only data processing (immediate)
> +	 * 1111 0x0x xxx0 xxxx 0xxx xxxx xxxx xxxx */
> +	if ((insn & 0xfa008000) != 0xf0000000) {
> +		pr_err("patch: unknown insn %08x\n", insn);
> +		return -EINVAL;
> +	}
> +
> +	/* extract op code */
> +	op = (insn >> 21) & 0xf;
> +
> +	/* disallow unsupported opcodes */
> +	if ((supported_ops & BIT(op)) == 0) {
> +		pr_err("patch: unsupported opcode %x\n", op);
> +		return -EINVAL;
> +	}
> +
> +	if (imm <= 0xff) {
> +		rot = 0;
> +		val = imm;
> +	} else {
> +		rot = 32 - fls(imm); /* clz */
> +		if (imm & ~(0xff000000 >> rot)) {
> +			pr_err("patch: constant overflow %08x\n", imm);
> +			return -EINVAL;
> +		}
> +		val  = (imm >> (24 - rot)) & 0x7f;
> +		rot += 8; /* encoded i:imm3:a */
> +
> +		/* pack least-sig rot bit into most-sig val bit */
> +		val |= (rot & 1) << 7;
> +		rot >>= 1;
> +	}
> +
> +	*ninsn  = insn & ~(BIT(26) | 0x7 << 12 | 0xff);
> +	*ninsn |= (rot >> 3) << 26;	/* field "i" */
> +	*ninsn |= (rot & 0x7) << 12;	/* field "imm3" */
> +	*ninsn |= val;

You need to convert this back to memory order.  If fixups might be
applied while the MMU is off, misaligned 32-bit accesses will fail.
It's better to store the two halfwords separately:

	__opcode_to_mem_thumb16(__opcode_thumb32_first(foo))
	__opcode_to_mem_thumb16(__opcode_thumb32_second(foo))

If the MMU is on, you can use __opcode_to_mem_thumb32(foo) and do
a possibly misaligned store, though.

This may be a good idea even if the MMU is on, because fixup is a
once-only process and we don't expect a meaningful performance
impact from that, especially when caching is enabled.  But splitting
the access may also make it easier to reuse the framework in
situations where the cache and MMU are off.

Because of all this, I suggest you don't repeatedly modify *ninsn.
Preparing the value and then writing it (or each half) once is probably
cleaner.

> +
> +	return 0;
> +}
> +
> +#else
> +
> +static int do_patch_imm8(u32 insn, u32 imm, u32 *ninsn)
> +{
> +	u32 rot, val, op;
> +
> +	insn = __mem_to_opcode_arm(insn);
> +
> +	/* disallow special unconditional instructions
> +	 * 1111 xxxx xxxx xxxx xxxx xxxx xxxx xxxx */
> +	if ((insn >> 24) == 0xf) {
> +		pr_err("patch: unconditional insn %08x\n", insn);
> +		return -EINVAL;
> +	}
> +
> +	/* allow only data processing (immediate)
> +	 * xxxx 001x xxxx xxxx xxxx xxxx xxxx xxxx */
> +	if (((insn >> 25) & 0x3) != 1) {
> +		pr_err("patch: unknown insn %08x\n", insn);
> +		return -EINVAL;
> +	}
> +
> +	/* extract op code */
> +	op = (insn >> 20) & 0x1f;
> +
> +	/* disallow unsupported 10xxx op codes */
> +	if (((op >> 3) & 0x3) == 2) {
> +		pr_err("patch: unsupported opcode %08x\n", insn);
> +		return -EINVAL;
> +	}
> +
> +	rot = imm ? __ffs(imm) / 2 : 0;
> +	val = imm >> (rot * 2);
> +	rot = (-rot) & 0xf;
> +
> +	/* does this fit in 8-bit? */
> +	if (val > 0xff) {
> +		pr_err("patch: constant overflow %08x\n", imm);
> +		return -EINVAL;
> +	}
> +
> +	/* patch in new immediate and rotation */
> +	*ninsn = (insn & ~0xfff) | (rot << 8) | val;

You need __opcode_to_mem_arm() to convert this back to memory order.

> +
> +	return 0;
> +}
> +
> +#endif	/* CONFIG_THUMB2_KERNEL */
> +
> +static int apply_patch_imm8(const struct patch_info *p)
> +{
> +	u32 *insn_ptr = p->insn, ninsn;
> +	int count = p->insn_size / sizeof(u32);
> +	const struct patch_info_imm8 *info;
> +	int err;
> +
> +
> +	if (count <= 0 || p->data_size != count * sizeof(*info)) {
> +		pr_err("patch: bad patch, insn size %d, data size %d\n",
> +		       p->insn_size, p->data_size);
> +		return -EINVAL;
> +	}
> +
> +	for (info = patch_data(p); count; count--, info++, insn_ptr++) {
> +		err = do_patch_imm8(info->insn, *info->imm, &ninsn);
> +		if (err)
> +			return err;
> +		__patch_text(insn_ptr, ninsn);
> +	}
> +
> +
> +	return 0;
> +}
> +
> +int runtime_patch(const void *table, unsigned size)

Minor nits: the type-unsafety could be dealt with outside this function;
table could be struct patch_info const *.

Also, why do we not just pass end to this function instead of subtracting
the table base and then adding it back again?

> +{
> +	const struct patch_info *p = table, *end = (table + size);
> +
> +	for (p = table; p < end; p = patch_next(p)) {
> +		int err = -EINVAL;
> +
> +		if (p->type == PATCH_IMM8)
> +			err = apply_patch_imm8(p);
> +		if (err)
> +			return err;
> +	}
> +	return 0;
> +}
> +
> +void __init runtime_patch_kernel(void)
> +{
> +	extern unsigned __runtime_patch_table_begin, __runtime_patch_table_end;
> +	const void *start = &__runtime_patch_table_begin;
> +	const void *end   = &__runtime_patch_table_end;
> +
> +	BUG_ON(runtime_patch(start, end - start));
> +}
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index a81dcec..669bbf0 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -55,6 +55,7 @@
>  #include <asm/traps.h>
>  #include <asm/unwind.h>
>  #include <asm/memblock.h>
> +#include <asm/runtime-patch.h>
>  
>  #if defined(CONFIG_DEPRECATED_PARAM_STRUCT)
>  #include "compat.h"
> @@ -998,6 +999,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	if (mdesc->init_early)
>  		mdesc->init_early();
> +
> +	runtime_patch_kernel();
>  }
>  
>  
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index 36ff15b..ea35ca0 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -167,6 +167,16 @@ SECTIONS
>  		*(.pv_table)
>  		__pv_table_end = .;
>  	}
> +	.init.runtime_patch_table : {
> +		__runtime_patch_table_begin = .;
> +		*(.runtime.patch.table)
> +		__runtime_patch_table_end = .;
> +	}
> +	.init.runtime_patch_code : {
> +		__runtime_patch_code_begin = .;
> +		*(.runtime.patch.code)
> +		__runtime_patch_code_end = .;
> +	}
>  	.init.data : {
>  #ifndef CONFIG_XIP_KERNEL
>  		INIT_DATA
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
