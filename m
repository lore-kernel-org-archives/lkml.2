Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2HOAKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:10:45 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48778 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2HOAKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:10:43 -0400
Date: Tue, 14 Aug 2012 17:10:43 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 08/31] arm64: CPU support
Message-ID: <20120815001043.GD19607@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-9-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-9-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 14, 2012 at 06:52:09PM +0100, Catalin Marinas wrote:

> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> new file mode 100644
> index 0000000..ef54125
> --- /dev/null
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -0,0 +1,49 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_CPUTYPE_H
> +#define __ASM_CPUTYPE_H
> +
> +#define ID_MIDR_EL1		"midr_el1"
> +#define ID_CTR_EL0		"ctr_el0"
> +
> +#define ID_AA64PFR0_EL1		"id_aa64pfr0_el1"
> +#define ID_AA64DFR0_EL1		"id_aa64dfr0_el1"
> +#define ID_AA64AFR0_EL1		"id_aa64afr0_el1"
> +#define ID_AA64ISAR0_EL1	"id_aa64isar0_el1"
> +#define ID_AA64MMFR0_EL1	"id_aa64mmfr0_el1"
> +
> +#define read_cpuid(reg) ({						\
> +	u64 __val;							\
> +	asm("mrs	%0, " reg : "=r" (__val));			\
> +	__val;								\
> +})
> +
> +/*
> + * The CPU ID never changes at run time, so we might as well tell the
> + * compiler that it's constant.  Use this function to read the CPU ID
> + * rather than directly reading processor_id or read_cpuid() directly.
> + */
> +static inline u32 __attribute_const__ read_cpuid_id(void)
> +{
> +	return read_cpuid(ID_MIDR_EL1);
> +}
> +
> +static inline u32 __attribute_const__ read_cpuid_cachetype(void)
> +{
> +	return read_cpuid(ID_CTR_EL0);
> +}

Is this perhaps a carry-over from arch/arm? Abstracting out read_cpuid()
doesn't seem to buy anything here, just opencode the one-line assembly
in each.

Might as well cleanup the naming a little too while you're at it, i.e.
read_cpu_id() and read_cpu_cachetype().


> diff --git a/arch/arm64/include/asm/procinfo.h b/arch/arm64/include/asm/procinfo.h
> new file mode 100644
> index 0000000..81fece9
> --- /dev/null
> +++ b/arch/arm64/include/asm/procinfo.h
> @@ -0,0 +1,44 @@
> +/*
> + * Based on arch/arm/include/asm/procinfo.h
> + *
> + * Copyright (C) 1996-1999 Russell King
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_PROCINFO_H
> +#define __ASM_PROCINFO_H
> +
> +#ifdef __KERNEL__
> +
> +/*
> + * Note!  struct processor is always defined if we're
> + * using MULTI_CPU, otherwise this entry is unused,
> + * but still exists.

Stale comment?

> + *
> + * NOTE! The following structure is defined by assembly
> + * language, NOT C code.  For more information, check:
> + *  arch/arm/mm/proc-*.S and arch/arm/kernel/head.S

Stale references. Also, no current arm64 implementation uses this. Premature
abstraction perhaps?

> +struct proc_info_list {
> +	unsigned int		cpu_val;
> +	unsigned int		cpu_mask;
> +	unsigned long		__cpu_flush;		/* used by head.S */
> +	const char		*cpu_name;
> +};
> +
> +#else	/* __KERNEL__ */
> +#include <asm/elf.h>
> +#warning "Please include asm/elf.h instead"
> +#endif	/* __KERNEL__ */
> +#endif
> diff --git a/arch/arm64/mm/proc-syms.c b/arch/arm64/mm/proc-syms.c
> new file mode 100644
> index 0000000..2d99ef9
> --- /dev/null
> +++ b/arch/arm64/mm/proc-syms.c
> @@ -0,0 +1,31 @@
> +/*
> + * Based on arch/arm/mm/proc-syms.c
> + *
> + * Copyright (C) 2000-2002 Russell King
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/export.h>
> +#include <linux/mm.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/proc-fns.h>
> +#include <asm/tlbflush.h>
> +#include <asm/page.h>
> +
> +EXPORT_SYMBOL(__cpuc_flush_kern_all);
> +EXPORT_SYMBOL(__cpuc_flush_user_all);
> +EXPORT_SYMBOL(__cpuc_flush_user_range);
> +EXPORT_SYMBOL(__cpuc_coherent_kern_range);
> +EXPORT_SYMBOL(__cpuc_flush_dcache_area);

See comment on other email about putting function pointers in a struct
instead.

> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> new file mode 100644
> index 0000000..453f517
> --- /dev/null
> +++ b/arch/arm64/mm/proc.S
> @@ -0,0 +1,193 @@
> +	.section ".proc.info.init", #alloc, #execinstr
> +
> +	.type	__v8_proc_info, #object
> +__v8_proc_info:
> +	.long	0x000f0000			// Required ID value
> +	.long	0x000f0000			// Mask for ID
> +	b	__cpu_setup
> +	nop
> +	.quad	cpu_name
> +	.long	0
> +	.size	__v8_proc_info, . - __v8_proc_info

I know this is a carry-over from arch/arm, but how about moving this
to more of a C construct similar to arch/powerpc/kernel/cputable.c
instead? It's considerably easier to read that way, and it's convenient
to have the definitions all in one place, making it easier to share some
of the functions, etc.


-Olof
