Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1EJOsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:48:25 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43523 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab1EJOsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:48:21 -0400
Date: Tue, 10 May 2011 16:48:12 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 1/6] x86-64: Clean up vdso/kernel shared variables
Message-ID: <20110510144811.GA3347@gere.osrc.amd.com>
References: <cover.1305035945.git.luto@mit.edu>
 <83043199068052b26ba63edc088f1d0be7d0df1d.1305035945.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83043199068052b26ba63edc088f1d0be7d0df1d.1305035945.git.luto@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:15:03AM -0400, Andy Lutomirski wrote:
> Variables that are shared between the vdso and the kernel are
> currently a bit of a mess.  They are each defined with their own
> magic, they are accessed differently in the kernel, the vsyscall page,
> and the vdso, and one of them (vsyscall_clock) doesn't even really
> exist.
> 
> This changes them all to use a common mechanism.  All of them are
> delcared in vvar.h with a fixed address (validated by the linker
> script).  In the kernel (as before), they look like ordinary
> read-write variables.  In the vsyscall page and the vdso, they are
> accessed through a new macro VVAR, which gives read-only access.
> 
> The vdso is now loaded verbatim into memory without any fixups.  As a
> side bonus, access from the vdso is faster because a level of
> indirection is removed.
> ---
>  arch/x86/include/asm/vdso.h     |   14 ----------
>  arch/x86/include/asm/vgtod.h    |    2 -
>  arch/x86/include/asm/vsyscall.h |   12 +-------
>  arch/x86/include/asm/vvar.h     |   52 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/time.c          |    2 +-
>  arch/x86/kernel/tsc.c           |    4 +-
>  arch/x86/kernel/vmlinux.lds.S   |   34 ++++++++-----------------
>  arch/x86/kernel/vsyscall_64.c   |   46 +++++++++++++++-------------------
>  arch/x86/vdso/Makefile          |    2 +-
>  arch/x86/vdso/vclock_gettime.c  |    3 +-
>  arch/x86/vdso/vdso.lds.S        |    7 -----
>  arch/x86/vdso/vextern.h         |   16 ------------
>  arch/x86/vdso/vgetcpu.c         |    3 +-
>  arch/x86/vdso/vma.c             |   27 --------------------
>  arch/x86/vdso/vvar.c            |   12 ---------
>  15 files changed, 91 insertions(+), 145 deletions(-)
>  create mode 100644 arch/x86/include/asm/vvar.h
>  delete mode 100644 arch/x86/vdso/vextern.h
>  delete mode 100644 arch/x86/vdso/vvar.c
> 
> diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
> index 9064052..bb05228 100644
> --- a/arch/x86/include/asm/vdso.h
> +++ b/arch/x86/include/asm/vdso.h
> @@ -1,20 +1,6 @@
>  #ifndef _ASM_X86_VDSO_H
>  #define _ASM_X86_VDSO_H
>  
> -#ifdef CONFIG_X86_64
> -extern const char VDSO64_PRELINK[];
> -
> -/*
> - * Given a pointer to the vDSO image, find the pointer to VDSO64_name
> - * as that symbol is defined in the vDSO sources or linker script.
> - */
> -#define VDSO64_SYMBOL(base, name)					\
> -({									\
> -	extern const char VDSO64_##name[];				\
> -	(void *)(VDSO64_##name - VDSO64_PRELINK + (unsigned long)(base)); \
> -})
> -#endif
> -
>  #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
>  extern const char VDSO32_PRELINK[];
>  
> diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
> index 3d61e20..646b4c1 100644
> --- a/arch/x86/include/asm/vgtod.h
> +++ b/arch/x86/include/asm/vgtod.h
> @@ -23,8 +23,6 @@ struct vsyscall_gtod_data {
>  	struct timespec wall_to_monotonic;
>  	struct timespec wall_time_coarse;
>  };
> -extern struct vsyscall_gtod_data __vsyscall_gtod_data
> -__section_vsyscall_gtod_data;
>  extern struct vsyscall_gtod_data vsyscall_gtod_data;
>  
>  #endif /* _ASM_X86_VGTOD_H */
> diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
> index d0983d2..d555973 100644
> --- a/arch/x86/include/asm/vsyscall.h
> +++ b/arch/x86/include/asm/vsyscall.h
> @@ -16,27 +16,19 @@ enum vsyscall_num {
>  #ifdef __KERNEL__
>  #include <linux/seqlock.h>
>  
> -#define __section_vgetcpu_mode __attribute__ ((unused, __section__ (".vgetcpu_mode"), aligned(16)))
> -#define __section_jiffies __attribute__ ((unused, __section__ (".jiffies"), aligned(16)))
> -
>  /* Definitions for CONFIG_GENERIC_TIME definitions */
> -#define __section_vsyscall_gtod_data __attribute__ \
> -	((unused, __section__ (".vsyscall_gtod_data"),aligned(16)))
> -#define __section_vsyscall_clock __attribute__ \
> -	((unused, __section__ (".vsyscall_clock"),aligned(16)))
>  #define __vsyscall_fn \
>  	__attribute__ ((unused, __section__(".vsyscall_fn"))) notrace
>  
>  #define VGETCPU_RDTSCP	1
>  #define VGETCPU_LSL	2
>  
> -extern int __vgetcpu_mode;
> -extern volatile unsigned long __jiffies;
> -
>  /* kernel space (writeable) */
>  extern int vgetcpu_mode;
>  extern struct timezone sys_tz;
>  
> +#include <asm/vvar.h>
> +
>  extern void map_vsyscall(void);
>  
>  #endif /* __KERNEL__ */
> diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
> new file mode 100644
> index 0000000..131ce61
> --- /dev/null
> +++ b/arch/x86/include/asm/vvar.h
> @@ -0,0 +1,52 @@
> +/*
> + * vvar.h: Shared vDSO/kernel variable declarations
> + * Copyright (c) 2011 Andy Lutomirski
> + * Subject to the GNU General Public License, version 2
> + *
> + * A handful of variables are accessible (read-only) from userspace
> + * code in the vsyscall page and the vdso.  They are declared here.
> + * Some other file must define them with DEFINE_VVAR.
> + *
> + * In normal kernel code, they are used like any other variable.
> + * In user code, they are accessed through the VVAR macro.
> + *
> + * Each of these variables lives in the vsyscall page, and each
> + * one needs a unique offset within the little piece of the page
> + * reserved for vvars.  Specify that offset in DECLARE_VVAR.
> + * (There are 896 bytes available.  If you mess up, the linker will
> + * catch it.)
> + */
> +
> +/* Offset of vars within vsyscall page */
> +#define VSYSCALL_VARS_OFFSET (3072 + 128)
> +
> +#if defined(__VVAR_KERNEL_LDS)
> +
> +/* The kernel linker script defines its own magic to put vvars in the
> + * right place.
> + */
> +#define DECLARE_VVAR(offset, type, name) \
> +	EMIT_VVAR(name, VSYSCALL_VARS_OFFSET + offset)
> +
> +#else
> +
> +#define DECLARE_VVAR(offset, type, name)				\
> +	static type const * const vvaraddr_ ## name =			\
> +		(void *)(VSYSCALL_START + VSYSCALL_VARS_OFFSET + (offset));
> +
> +#define DEFINE_VVAR(type, name)						\
> +	type __vvar_ ## name						\
> +	__attribute__((section(".vsyscall_var_" #name), aligned(16)))
> +
> +#define VVAR(name) (*vvaraddr_ ## name)
> +
> +#endif
> +
> +/* DECLARE_VVAR(offset, type, name) */
> +
> +DECLARE_VVAR(0, volatile unsigned long, jiffies)
> +DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
> +DECLARE_VVAR(256, int, vgetcpu_mode)

Why so spread out? Maybe put each on a single cacheline instead?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
