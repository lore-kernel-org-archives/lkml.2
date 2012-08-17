Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848Ab2HQJlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:41:21 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:36431 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964874Ab2HQJlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:41:17 -0400
Message-ID: <502E11B6.4020104@ti.com>
Date: Fri, 17 Aug 2012 15:11:10 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-3-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012 11:22 PM, Catalin Marinas wrote:
> The patch adds the kernel booting and the initial setup code.
> Documentation/arm64/booting.txt describes the booting protocol on the
> AArch64 Linux kernel. This is subject to change following the work on
> boot standardisation, ACPI.
>
> Signed-off-by: Will Deacon<will.deacon@arm.com>
> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> ---
>   Documentation/arm64/booting.txt |  141 +++++++++++
>   arch/arm64/include/asm/setup.h  |   26 ++
>   arch/arm64/kernel/head.S        |  521 +++++++++++++++++++++++++++++++++++++++
>   arch/arm64/kernel/setup.c       |  357 +++++++++++++++++++++++++++
>   4 files changed, 1045 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/arm64/booting.txt
>   create mode 100644 arch/arm64/include/asm/setup.h
>   create mode 100644 arch/arm64/kernel/head.S
>   create mode 100644 arch/arm64/kernel/setup.c
>
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> new file mode 100644
> index 0000000..3197820
> --- /dev/null
> +++ b/Documentation/arm64/booting.txt

[...]

> +
> +The boot loader is expected to enter the kernel on each CPU in the
> +following manner:
> +
> +- The primary CPU must jump directly to the first instruction of the
> +  kernel image.  The device tree blob passed by this CPU must contain
> +  for each CPU node:
> +
> +    1. An 'enable-method' property. Currently, the only supported value
> +       for this field is the string "spin-table".
> +
> +    2. A 'cpu-release-addr' property identifying a 64-bit,
> +       zero-initialised memory location.
> +
> +  It is expected that the bootloader will generate these device tree
> +  properties and insert them into the blob prior to kernel entry.
> +
> +- Any secondary CPUs must spin outside of the kernel in a reserved area
> +  of memory (communicated to the kernel by a /memreserve/ region in the
> +  device tree) polling their cpu-release-addr location, which must be
> +  contained in the reserved region.  A wfe instruction may be inserted
> +  to reduce the overhead of the busy-loop and a sev will be issued by
> +  the primary CPU.  When a read of the location pointed to by the
> +  cpu-release-addr returns a non-zero value, the CPU must jump directly
> +  to this value.

So you expect all the secondary CPUs to be in wakeup state and probably
looping in WFE for a signal from kernel to boot. There is one issue
with this requirement though. For large CPU system, you need to reset
all the CPUs and hit this waiting loop. This will lead to large inrush
current need at bootup which may be not be supported. To avoid this
issue, secondary CPUs are kept in OFF state and then they are woken
up from kernel one by one whenever they need to be brought into the
system. This requirement should be considered.


> diff --git a/arch/arm64/include/asm/setup.h b/arch/arm64/include/asm/setup.h
> new file mode 100644
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
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_SETUP_H
> +#define __ASM_SETUP_H
> +
> +#include<linux/types.h>
> +
> +#define COMMAND_LINE_SIZE 1024
> +
> +#endif
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> new file mode 100644
> index 0000000..34ccdc0
> --- /dev/null
> +++ b/arch/arm64/kernel/head.S
> @@ -0,0 +1,521 @@
> +/*
> + * Low-level CPU initialisation
> + * Based on arch/arm/kernel/head.S
> + *
> + * Copyright (C) 1994-2002 Russell King
> + * Copyright (C) 2003-2012 ARM Ltd.
> + * Authors:	Catalin Marinas<catalin.marinas@arm.com>
> + *		Will Deacon<will.deacon@arm.com>
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
> + * along with this program.  If not, see<http://www.gnu.org/licenses/>.
> + */
> +

[..]

> +
> +	/*
> +	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
> +	 */
> +	b	stext				// branch to kernel start, magic
> +	.long	0				// reserved
> +	.quad	TEXT_OFFSET			// Image load offset from start of RAM
> +	.quad	0				// reserved
> +	.quad	0				// reserved
> +

Minor nit. Avoid C++ commenting style "//"  here and rest of the patch.

Regards
santosh

