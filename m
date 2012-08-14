Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2HNXGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:06:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38942 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2HNXGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:06:47 -0400
Date: Tue, 14 Aug 2012 16:06:45 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Message-ID: <20120814230645.GA19607@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, Aug 14, 2012 at 06:52:03PM +0100, Catalin Marinas wrote:

> +Before jumping into the kernel, the following conditions must be met:
> +
> +- Quiesce all DMA capable devices so that memory does not get
> +  corrupted by bogus network packets or disk data.  This will save
> +  you many hours of debug.
> +
> +- Primary CPU general-purpose register settings
> +  x0 = physical address of device tree blob (dtb) in system RAM.
> +
> +- CPU mode
> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
> +  IRQ and FIQ).
> +  The CPU must be in either EL2 (RECOMMENDED in order to have access to
> +  the virtualisation extensions) or non-secure EL1.
> +
> +- Caches, MMUs
> +  The MMU must be off.
> +  Instruction cache may be on or off.
> +  Data cache must be off and invalidated.
> +
> +- Architected timers
> +  CNTFRQ must be programmed with the timer frequency.
> +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
> +  set where available.
> +
> +- Coherency
> +  All CPUs to be booted by the kernel must be part of the same coherency
> +  domain on entry to the kernel.  This may require IMPLEMENTATION DEFINED
> +  initialisation to enable the receiving of maintenance operations on
> +  each CPU.
> +
> +- System registers
> +  All writable architected system registers at the exception level where
> +  the kernel image will be entered must be initialised by software at a
> +  higher exception level to prevent execution in an UNKNOWN state.

Given the recent development of ARM platforms, you might want to mandate
the state of IOMMUs as well (they should probably be off, since there
should be no active DMA activity). Graphics would be the exception to
this, since if you want to keep scanning out a splash screen, you'll
have to keep doing DMA...

> +- The primary CPU must jump directly to the first instruction of the
> +  kernel image.  The device tree blob passed by this CPU must contain
> +  for each CPU node:
> +
> +    1. An 'enable-method' property. Currently, the only supported value
> +       for this field is the string "spin-table".
> +
> +    2. A 'cpu-release-addr' property identifying a 64-bit,
> +       zero-initialised memory location.

These would be good to have documented in the
Documentation/devicetree/bindings hierarchy as well.

> index 0000000..d766493
> --- /dev/null
> +++ b/arch/arm64/include/asm/setup.h
> @@ -0,0 +1,26 @@
> +/*
> + * Based on arch/arm/include/asm/setup.h
> + *
> + * Copyright (C) 1997-1999 Russell King
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
> +#ifndef __ASM_SETUP_H
> +#define __ASM_SETUP_H
> +
> +#include <linux/types.h>
> +
> +#define COMMAND_LINE_SIZE 1024

Probably not a huge deal, and other architectures seem to be all over
the map on this, but you might want to go with a larger value now rather
than later. 2048 or 4096 perhaps?

> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> new file mode 100644
> index 0000000..34ccdc0
> --- /dev/null
> +++ b/arch/arm64/kernel/head.S

[...]

> +/*
> + * Setup common bits before finally enabling the MMU. Essentially this is just
> + * loading the page table pointer and vector base registers.
> + *
> + * On entry to this code, x0 must contain the SCTLR_EL1 value for turning on
> + * the MMU.
> + */
> +__enable_mmu:

ENTRY()?

> +	ldr	x5, =vectors
> +	msr	vbar_el1, x5
> +	msr	ttbr0_el1, x25			// load TTBR0
> +	msr	ttbr1_el1, x26			// load TTBR1
> +	isb
> +	b	__turn_mmu_on
> +ENDPROC(__enable_mmu)

...or just END()? Same for a few of the other functions below.

> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> new file mode 100644
> index 0000000..f25186f
> --- /dev/null
> +++ b/arch/arm64/kernel/setup.c

[...]

> +static void __init setup_processor(void)
> +{
> +	struct proc_info_list *list;
> +
> +	/*
> +	 * locate processor in the list of supported processor
> +	 * types.  The linker builds this table for us from the
> +	 * entries in arch/arm/mm/proc.S
> +	 */

Probably from arch/arm64/... somewhere?


[...]

> +	printk("CPU: %s [%08x] revision %d\n",
> +	       cpu_name, read_cpuid_id(), read_cpuid_id() & 15);
> +
> +	sprintf(init_utsname()->machine, "aarch64");

> +	initial_boot_params = devtree;
> +	dt_root = of_get_flat_dt_root();
> +
> +	machine_name = of_get_flat_dt_prop(dt_root, "model", NULL);
> +	if (!machine_name)
> +		machine_name = of_get_flat_dt_prop(dt_root, "compatible", NULL);
> +	if (!machine_name)
> +		machine_name = "<unknown>";
> +	pr_info("Machine: %s\n", machine_name);

This property is an array of strings. It would be more valuable to print out
the entry that was matched for a platform instead of the provided one from the
device tree.


-Olof
