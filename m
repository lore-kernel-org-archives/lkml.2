Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2LQWZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:25:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51582 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2LQWZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:25:53 -0500
Message-ID: <50CF9BCE.90000@zytor.com>
Date: Mon, 17 Dec 2012 14:25:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: stefani@seibold.net
CC: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, luto@amacapital.net, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH] Add 32 bit VDSO time function support
References: <1355782365-11307-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1355782365-11307-1-git-send-email-stefani@seibold.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 02:12 PM, stefani@seibold.net wrote:
>  arch/x86/Kconfig                      |   4 +-
>  arch/x86/include/asm/clocksource.h    |   4 -
>  arch/x86/include/asm/fixmap.h         |   6 +-
>  arch/x86/include/asm/vgtod.h          |  10 ++-
>  arch/x86/include/asm/vsyscall.h       |   1 -
>  arch/x86/include/asm/vvar.h           |   5 ++
>  arch/x86/kernel/Makefile              |   1 +
>  arch/x86/kernel/hpet.c                |  11 ++-
>  arch/x86/kernel/setup.c               |   2 +
>  arch/x86/kernel/tsc.c                 |   2 -
>  arch/x86/kernel/vmlinux.lds.S         |   4 -
>  arch/x86/kernel/vsyscall_64.c         |  49 -----------
>  arch/x86/kernel/vsyscall_gtod.c       |  93 +++++++++++++++++++++
>  arch/x86/mm/init_32.c                 |   1 +
>  arch/x86/vdso/Makefile                |   6 ++
>  arch/x86/vdso/vclock_gettime.c        | 108 ++++++++++++++++++------
>  arch/x86/vdso/vdso32-setup.c          |  41 ++++++++++
>  arch/x86/vdso/vdso32/vclock_gettime.c |  29 +++++++
>  arch/x86/vdso/vdso32/vdso32.lds.S     |   3 +
>  include/linux/clocksource.h           |   1 -
>  include/linux/mm.h                    |   3 +
>  include/linux/seqcount.h              | 150 ++++++++++++++++++++++++++++++++++
>  include/linux/seqlock.h               | 145 +-------------------------------
>  include/linux/time.h                  |   3 +-
>  include/linux/timekeeper_internal.h   |   1 +
>  include/linux/types.h                 |   2 +
>  mm/mmap.c                             |  20 ++++-
>  27 files changed, 457 insertions(+), 248 deletions(-)
>  create mode 100644 arch/x86/kernel/vsyscall_gtod.c
>  create mode 100644 arch/x86/vdso/vdso32/vclock_gettime.c
>  create mode 100644 include/linux/seqcount.h

Please break this up in a series with the generic changes separately first.

> diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
> index 46e24d3..74c80d4 100644
> --- a/arch/x86/include/asm/vgtod.h
> +++ b/arch/x86/include/asm/vgtod.h
> @@ -1,8 +1,8 @@
>  #ifndef _ASM_X86_VGTOD_H
>  #define _ASM_X86_VGTOD_H
>  
> -#include <asm/vsyscall.h>
> -#include <linux/clocksource.h>
> +#include <linux/seqcount.h>
> +#include <uapi/linux/time.h>
>  
>  struct vsyscall_gtod_data {
>  	seqcount_t	seq;
> @@ -13,7 +13,7 @@ struct vsyscall_gtod_data {
>  		cycle_t	mask;
>  		u32	mult;
>  		u32	shift;
> -	} clock;
> +	} __attribute__((aligned(4),packed)) clock;
>  
>  	/* open coded 'struct timespec' */
>  	time_t		wall_time_sec;
> @@ -24,7 +24,9 @@ struct vsyscall_gtod_data {
>  	struct timezone sys_tz;
>  	struct timespec wall_time_coarse;
>  	struct timespec monotonic_time_coarse;
> -};
> +} __attribute__((aligned(4),packed));
> +
>  extern struct vsyscall_gtod_data vsyscall_gtod_data;
>  
> +extern void map_vgtod(void);
>  #endif /* _ASM_X86_VGTOD_H */

Please use the macros from <linux/compiler.h>.  Also, aligned(4) raises
a huge red flag for me.  Why??

> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> index de656ac..1e71e6c 100644
> --- a/arch/x86/include/asm/vvar.h
> +++ b/arch/x86/include/asm/vvar.h
> @@ -17,7 +17,11 @@
>   */
>  
>  /* Base address of vvars.  This is not ABI. */
> +#ifdef CONFIG_X86_64
>  #define VVAR_ADDRESS (-10*1024*1024 - 4096)
> +#else
> +#define VVAR_ADDRESS 0xffffd000
> +#endif
> 

I thought we had agreed this was going to be part of the vdso and not a
fixmap?

> +		struct vm_area_struct *vma = _install_special_mapping(mm,
> +				__fix_to_virt(VSYSCALL_HPET) & 0xffffffff,
> +				PAGE_SIZE, VM_READ|VM_EXEC|VM_IO|VM_LOCKED,
> +				NULL);

This style is generally frowned upon; please separate the declaration
and the assignment.  The & 0xffffffff there also looks... "special"...
but again, see previous statement about fixed addresses.

	-hpa

