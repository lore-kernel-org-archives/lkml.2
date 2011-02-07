Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1BGOuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:50:10 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:34637 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1BGOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:50:09 -0500
Date: Mon, 7 Feb 2011 15:50:00 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, mhopf@suse.de, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, nx: Mark the ACPI resume trampoline code
 as +x - fixed
Message-ID: <20110207145000.GA20671@marc.osknowledge.org>
References: <4D4F8019.2090104@zytor.com>
 <tip-d344e38b2c151ca5e5e39f562017127e93912528@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d344e38b2c151ca5e5e39f562017127e93912528@git.kernel.org>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.38-rc3-dezzy-00238-g8dbdea8-dirty
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* tip-bot for H. Peter Anvin <hpa@zytor.com> [2011-02-07 09:24:55 +0000]:

Great! That one fixes ACPI S3 resume on i7.

Regards,
Marc

> Commit-ID:  d344e38b2c151ca5e5e39f562017127e93912528
> Gitweb:     http://git.kernel.org/tip/d344e38b2c151ca5e5e39f562017127e93912528
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Sun, 6 Feb 2011 21:16:09 -0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 7 Feb 2011 09:07:13 +0100
> 
> x86, nx: Mark the ACPI resume trampoline code as +x
> 
> We reserve lowmem for the things that need it, like the ACPI
> wakeup code, way early to guarantee availability.  This happens
> before we set up the proper pagetables, so set_memory_x() has no
> effect.
> 
> Until we have a better solution, use an initcall to mark the
> wakeup code executable.
> 
> Originally-by: Matthieu Castet <castet.matthieu@free.fr>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Matthias Hopf <mhopf@suse.de>
> Cc: rjw@sisk.pl
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> LKML-Reference: <4D4F8019.2090104@zytor.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/acpi/sleep.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 4d9ebba..68d1537 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -12,10 +12,8 @@
>  #include <linux/cpumask.h>
>  #include <asm/segment.h>
>  #include <asm/desc.h>
> -
> -#ifdef CONFIG_X86_32
>  #include <asm/pgtable.h>
> -#endif
> +#include <asm/cacheflush.h>
>  
>  #include "realmode/wakeup.h"
>  #include "sleep.h"
> @@ -149,6 +147,15 @@ void __init acpi_reserve_wakeup_memory(void)
>  	memblock_x86_reserve_range(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
>  }
>  
> +int __init acpi_configure_wakeup_memory(void)
> +{
> +	if (acpi_realmode)
> +		set_memory_x(acpi_realmode, WAKEUP_SIZE >> PAGE_SHIFT);
> +
> +	return 0;
> +}
> +arch_initcall(acpi_configure_wakeup_memory);
> +
>  
>  static int __init acpi_sleep_setup(char *str)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
