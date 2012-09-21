Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2IUSJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:09:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47576 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2IUSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:09:42 -0400
Date: Fri, 21 Sep 2012 14:09:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, catalin.marinas@arm.com, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, will.deacon@arm.com
Subject: Re: [PATCH v3 01/17] ARM: add mechanism for late code patching
In-Reply-To: <1347385155-11643-2-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1209211355490.6667@xanadu.home>
References: <1347385155-11643-1-git-send-email-cyril@ti.com> <1347385155-11643-2-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Cyril Chemparathy wrote:

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
> 
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
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>

I know I provided review before, but here's another nit I'd like fixed:

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

[...]

> +#else
> +
> +static inline int runtime_patch(const void *table, unsigned size)
> +{
> +	return 0;
> +}

This is wrong.  If runtime_patch() is ever called when 
CONFIG_ARM_RUNTIME_PATCH is not set, then i'd better return an error and 
not pretend it performed the requested action.  Returning -ENOSYS would 
be appropriate.

This is especially important in the following context:

> --- a/arch/arm/kernel/module.c
> +++ b/arch/arm/kernel/module.c
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

Despite the vermagic check, If ever a .runtime.patch.table section is 
found in a module to be loaded in a kernel with no support for it then 
it is best to return an error than see the kernel crashing later on when 
the fallback stubs have been discarded.


Nicolas
