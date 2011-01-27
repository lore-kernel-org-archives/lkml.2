Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1A0AEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:04:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389Ab1A0AE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:04:29 -0500
Date: Wed, 26 Jan 2011 16:04:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash_dump: export is_kdump_kernel to modules,
 consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
Message-Id: <20110126160426.796b0669.akpm@linux-foundation.org>
In-Reply-To: <20110125161052.GA20105@aepfle.de>
References: <20110125161052.GA20105@aepfle.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 17:10:52 +0100
Olaf Hering <olaf@aepfle.de> wrote:

> 
> The Xen PV drivers in a crashed HVM guest can not connect to the dom0
> backend drivers because both frontend and backend drivers are still in
> connected state. To run the connection reset function only in case of a
> crashdump, the is_kdump_kernel() function needs to be available for the
> PV driver modules.
> 
> Consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn into
> kernel/crash_dump.c Also export elfcorehdr_addr to make
> is_kdump_kernel() usable for modules.
> 
> Leave 'elfcorehdr' as early_param().  This changes powerpc from
> __setup() to early_param().  It adds an address range check from x86
> also on ia64 and powerpc.
> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  arch/arm/kernel/crash_dump.c     |    3 ---
>  arch/arm/kernel/setup.c          |   24 ------------------------
>  arch/ia64/kernel/crash_dump.c    |    3 ---
>  arch/ia64/kernel/efi.c           |    1 +
>  arch/ia64/kernel/setup.c         |   18 ------------------
>  arch/powerpc/kernel/crash_dump.c |   17 -----------------
>  arch/sh/kernel/crash_dump.c      |   22 ----------------------
>  arch/x86/kernel/crash_dump_32.c  |    3 ---
>  arch/x86/kernel/crash_dump_64.c  |    3 ---
>  arch/x86/kernel/e820.c           |    1 +
>  arch/x86/kernel/setup.c          |   22 ----------------------
>  include/linux/bootmem.h          |    4 ----
>  kernel/Makefile                  |    1 +
>  kernel/crash_dump.c              |   33 +++++++++++++++++++++++++++++++++
>  mm/bootmem.c                     |    8 --------
>  15 files changed, 36 insertions(+), 127 deletions(-)

That was a decent cleanup.

>
> ...
>
> --- /dev/null
> +++ linux-2.6.38.rc/kernel/crash_dump.c
> @@ -0,0 +1,33 @@
> +#include <linux/crash_dump.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +
> +/*
> + * If we have booted due to a crash, max_pfn will be a very low value. We need
> + * to know the amount of memory that the previous kernel used.
> + */
> +unsigned long saved_max_pfn;
> +
> +/*
> + * stores the physical address of elf header of crash image
> + *
> + * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> + * is_kdump_kernel() to determine if we are booting after a panic. Hence put
> + * it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> + */
> +unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> +EXPORT_SYMBOL_GPL(elfcorehdr_addr);
> +
> +/*
> + * elfcorehdr= specifies the location of elf core header stored by the crashed
> + * kernel. This option will be passed by kexec loader to the capture kernel.
> + */
> +static int __init setup_elfcorehdr(char *arg)
> +{
> +	char *end;
> +	if (!arg)
> +		return -EINVAL;
> +	elfcorehdr_addr = memparse(arg, &end);
> +	return end > arg ? 0 : -EINVAL;
> +}
> +early_param("elfcorehdr", setup_elfcorehdr);

Please check that this file is #including everything it needs.  Just
looking at it I'd expect a build error with CONFIG_KEXEC=n,
CONFIG_CRASH_DUMP=y due to a missed ELFCORE_ADDR_MAX definition.


