Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2LKThg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:37:36 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62671 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2LKThf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:37:35 -0500
MIME-Version: 1.0
In-Reply-To: <1355242260-28762-1-git-send-email-stefani@seibold.net>
References: <1355242260-28762-1-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Dec 2012 11:37:14 -0800
Message-ID: <CALCETrWDkA8Xkp==okP8xERRSM8tcryRDr_+2RYcSK=vSQV9kQ@mail.gmail.com>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 8:11 AM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This small patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> and vdso_time() support to the VDSO for x86 32-bit kernels.
>
> The reason to do this was to get a fast reliable time stamp. Many developers
> uses TSC to get a fast time time stamp, without knowing the pitfalls. VDSO
> time functions a fast and reliable way, because the kernel knows the best time
> source and the P- and C-state of the CPU.
>
> For x86 the vclock_gettime.c currently supports only the HPET and TSC timer,
> the ACPI timer should be easily to add with an other patch.
>
> The helper library to use the VDSO functions can be download at
> http://http://seibold.net/vdso.c

Wow -- another implementation.  See Documentation/vDSO/parse_vdso.c.
(Also, I think your code will break if anyone ever strips the vdso.)

> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -59,14 +59,23 @@ notrace static cycle_t vread_tsc(void)
>
>  static notrace cycle_t vread_hpet(void)
>  {
> +#ifdef CONFIG_X86_64
>         return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
> +#else
> +       return readl(VVAR(vsyscall_hpet) + HPET_COUNTER);
> +#endif
>  }

Is 0xf0 not equal to HPET_COUNTER?

>
>  notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
>  {
>         long ret;
> +#ifdef CONFIG_X86_64
>         asm("syscall" : "=a" (ret) :
>             "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
> +#else
> +       asm("int $0x80" : "=a" (ret) :
> +           "a" (__NR_clock_gettime), "b" (clock), "c" (ts) : "memory");
> +#endif
>         return ret;
>  }

__kernel_vsyscall is probably much faster if you can figure out how to
call it from here :)

>
> @@ -74,15 +83,20 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
>  {
>         long ret;
>
> +#ifdef CONFIG_X86_64
>         asm("syscall" : "=a" (ret) :
>             "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
> +#else
> +       asm("int $0x80" : "=a" (ret) :
> +           "a" (__NR_gettimeofday), "b" (tv), "c" (tz) : "memory");
> +#endif
>         return ret;
>  }
>

Ditto.

> --- a/arch/x86/vdso/vdso32/vdso32.lds.S
> +++ b/arch/x86/vdso/vdso32/vdso32.lds.S
> @@ -24,6 +24,16 @@ VERSION
>                 __kernel_vsyscall;
>                 __kernel_sigreturn;
>                 __kernel_rt_sigreturn;
> +#ifdef CONFIG_X86_32
> +               clock_gettime;
> +               __vdso_clock_gettime;
> +               gettimeofday;
> +               __vdso_gettimeofday;
> +               gettimeofday;
> +               __vdso_gettimeofday;
> +               time;
> +               __vdso_time;
> +#endif

Please remove the non-__vdso versions.  They're not useful and x86-64
only has them for backwards compatibility.

>         local: *;
>         };
>  }
> @@ -35,3 +45,8 @@ VDSO32_PRELINK                = VDSO_PRELINK;
>  VDSO32_vsyscall                = __kernel_vsyscall;
>  VDSO32_sigreturn       = __kernel_sigreturn;
>  VDSO32_rt_sigreturn    = __kernel_rt_sigreturn;
> +#ifdef CONFIG_X86_32
> +VDSO32_clock_gettime   = clock_gettime;
> +VDSO32_gettimeofday    = gettimeofday;
> +VDSO32_time            = time;
> +#endif

Yikes.  What's this?  (Just curious.)
