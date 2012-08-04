Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2HDFih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 01:38:37 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44028 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2HDFid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 01:38:33 -0400
Date: Sat, 4 Aug 2012 01:38:29 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, linux@arm.linux.org.uk,
        will.deacon@arm.com
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
In-Reply-To: <1343775898-28345-2-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208040045360.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Cyril Chemparathy wrote:

> The original phys_to_virt/virt_to_phys patching implementation relied on early
> patching prior to MMU initialization.  On PAE systems running out of >4G
> address space, this would have entailed an additional round of patching after
> switching over to the high address space.
> 
> The approach implemented here conceptually extends the original PHYS_OFFSET
> patching implementation with the introduction of "early" patch stubs.  Early
> patch code is required to be functional out of the box, even before the patch
> is applied.  This is implemented by inserting functional (but inefficient)
> load code into the .patch.code init section.  Having functional code out of
> the box then allows us to defer the init time patch application until later
> in the init sequence.
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

This looks very nice.  Comments below.

> ---
>  arch/arm/include/asm/patch.h  |  123 +++++++++++++++++++++++++++++

Please find a better name for this file. "patch" is way too generic and 
commonly referring to something different. "runtime-patching" or similar 
would be more descriptive.

>  arch/arm/kernel/module.c      |    4 +
>  arch/arm/kernel/setup.c       |  175 +++++++++++++++++++++++++++++++++++++++++

This is complex enough to waarrant aa separate source file.  Please move 
those additions out from setup.c.  Given a good name for the header file 
above, the c file could share the same name.

> new file mode 100644
> index 0000000..a89749f
> --- /dev/null
> +++ b/arch/arm/include/asm/patch.h
> @@ -0,0 +1,123 @@
> +/*
> + *  arch/arm/include/asm/patch.h
> + *
> + *  Copyright (C) 2012, Texas Instruments
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + *  Note: this file should not be included by non-asm/.h files
> + */
> +#ifndef __ASM_ARM_PATCH_H
> +#define __ASM_ARM_PATCH_H
> +
> +#include <linux/stringify.h>
> +
> +#ifndef __ASSEMBLY__
> +
> extern unsigned __patch_table_begin, __patch_table_end;

You could use "exttern void __patch_table_begin" so those symbols don't 
get any type that could be misused by mistake, while you still can take 
their addresses.

> +
> +struct patch_info {
> +	u32	 type;
> +	u32	 size;

Given the possibly large number of table entries, some effort at making 
those entries as compact as possible should be considered. For instance, 
the type and size fields could be u8's and insn_end pointer replaced 
with another size expressed as an u8.  By placing all the u8's together 
they would occupy a single word by themselves.  The assembly stub would 
only need a .align statement to reflect the c structure's padding.

[...]

Did you verify with some test program that your patching routines do 
produce the same opcodes as the assembled equivalent for all possible 
shift values?  Especially for Thumb2 code which isn't as trivial to get 
right as the ARM one.


Nicolas
