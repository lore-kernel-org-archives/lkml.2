Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2IVPLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:11:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46028 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2IVPLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:11:00 -0400
Date: Sat, 22 Sep 2012 11:10:57 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        davidb@codeaurora.org, frank.rowand@am.sony.com,
        hsweeten@visionengravers.com, linus.walleij@linaro.org,
        marc.zyngier@arm.com, paul.gortmaker@windriver.com,
        plagnioj@jcrosoft.com, rabin@rab.in, rmallon@gmail.com,
        rob.herring@calxeda.com, sboyd@codeaurora.org, sjg@chromium.org,
        tglx@linutronix.de, tj@kernel.org, vincent.guittot@linaro.org,
        vitalya@ti.com, will.deacon@arm.com, grant.likely@secretlab.ca
Subject: Re: [PATCH v3 RESEND 01/17] ARM: add mechanism for late code
 patching
In-Reply-To: <1348242975-19184-2-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1209221037561.6667@xanadu.home>
References: <1348242975-19184-1-git-send-email-cyril@ti.com> <1348242975-19184-2-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012, Cyril Chemparathy wrote:

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

There is another problem with this.

[...]
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

This causes the following compilation error:

  CC      sound/core/pcm.o
In file included from sound/core/pcm.c:293:0:
include/linux/soundcard.h:223:8: error: redefinition of 'struct patch_info'
arch/arm/include/asm/runtime-patch.h:28:8: note: originally defined here
make[2]: *** [sound/core/pcm.o] Error 1

The problem is that asm/runtime-patch.h gets included by asm/memory.h 
and asm/memory.h is included by almost the entire kernel. Something like 
"struct patch_info" is a bit too generic a name to be exported to the 
world as the likelihood of a name collision with some private definition 
in a driver or the like is rather high.  

In that context it might be worth moving everything that is not required 
for the patch stub definitions out of asm/runtime-patch.h.  For example, 
the definition of struct patch_info, struct patch_info_imm8, 
patch_next() and patch_data() could be moved to runtime-patch.c directly 
instead.  And then patch_stub() should be renamed to 
runtime_patch_stub(), early_patch_stub() to early_runtime_patch_stub(), 
patch_imm8() to runtime_patch_imm8(), etc.  Even the __IMM8 symbol name 
is rather weak for kernel wide scope.


Nicolas
