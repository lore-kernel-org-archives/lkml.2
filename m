Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab2LKTfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:35:06 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50215 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2LKTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:35:04 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2012 14:35:04 EST
Message-ID: <50C78927.6080302@linaro.org>
Date: Tue, 11 Dec 2012 11:27:35 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: stefani@seibold.net
CC: linux-kernel@vger.kernel.org, ak@linux.intel.com, aarcange@redhat.com,
        luto@amacapital.net
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
References: <1355242260-28762-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1355242260-28762-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 08:11 AM, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This small patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> and vdso_time() support to the VDSO for x86 32-bit kernels.
>
> The reason to do this was to get a fast reliable time stamp. Many developers
> uses TSC to get a fast time time stamp, without knowing the pitfalls. VDSO
> time functions a fast and reliable way, because the kernel knows the best time
> source and the P- and C-state of the CPU.
Very cool. There have been similar implementations of this patch over 
the years, but they were all bit more hackish then this.


> For x86 the vclock_gettime.c currently supports only the HPET and TSC timer,
> the ACPI timer should be easily to add with an other patch.
Although the ACPI PM timer requires port-io which would need tweaking to 
allow normal users to access it. And I'm not sure if the performance 
would be much improved, as the port-io probably dominates the 
performance cost.

> The helper library to use the VDSO functions can be download at
> http://http://seibold.net/vdso.c
> The libary is very small, only 228 lines of code. Compile it with
> gcc -Wall -O3 -fpic vdso.c -lrt -shared -o libvdso.so
> and use it with LD_PRELOAD=<path>/libvdso.so
>
> This kind of helper must be integrated into glibc, for x86 64-bit and
> PowerPC it is already there.
>
A few notes below...


> diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
> index 59c6c40..45ba688 100644
> --- a/arch/x86/include/asm/compat.h
> +++ b/arch/x86/include/asm/compat.h
> @@ -295,6 +295,10 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
>   
>   static inline void __user *arch_compat_alloc_user_space(long len)
>   {
> +#ifdef CONFIG_X86_32
> +	struct pt_regs *regs = task_pt_regs(current);
> +	return (void __user *)regs->sp - len;
> +#else
>   	compat_uptr_t sp;
>   
>   	if (test_thread_flag(TIF_IA32)) {
> @@ -305,6 +309,7 @@ static inline void __user *arch_compat_alloc_user_space(long len)
>   	}
>   
>   	return (void __user *)round_down(sp - len, 16);
> +#endif
>   }

This style of in-line ifdefs are ugly and hard to read.

So instead of doing:
void myfunction (void)
{
#ifdef 32bits
     32_bit_implementation();
#else
     64_bit_implementation();
#endif
}

Where possible, please do:
#ifdef 32bits
void myfunction1(void)
{
     32_bit implementation();
}
void myfunction2(void)
{
....
#else /*64 bit versions */
void myfunction1(void)
{
     64_bit implementation();
}
void myfunction2(void)
....
#endif

> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index 4df6c37..2dc6b72 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -59,14 +59,23 @@ notrace static cycle_t vread_tsc(void)
>   
>   static notrace cycle_t vread_hpet(void)
>   {
> +#ifdef CONFIG_X86_64
>   	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
> +#else
> +	return readl(VVAR(vsyscall_hpet) + HPET_COUNTER);
> +#endif
>   }
>   
>   notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
>   {
>   	long ret;
> +#ifdef CONFIG_X86_64
>   	asm("syscall" : "=a" (ret) :
>   	    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
> +#else
> +	asm("int $0x80" : "=a" (ret) :
> +	    "a" (__NR_clock_gettime), "b" (clock), "c" (ts) : "memory");
> +#endif
>   	return ret;
>   }
Same point here.


> diff --git a/arch/x86/vdso/vdso32/vclock_gettime.c b/arch/x86/vdso/vdso32/vclock_gettime.c
> new file mode 100644
> index 0000000..c9a1909
> --- /dev/null
> +++ b/arch/x86/vdso/vdso32/vclock_gettime.c
> @@ -0,0 +1,7 @@
> +/*
> + * since vgtod layout differs between X86_64 and x86_32, it is not possible to
> + * provide a 32 bit vclock with a 64 bit kernel
> + */
> +#ifdef CONFIG_X86_32
> +#include "../vclock_gettime.c"
> +#endif
Could you expand a bit as to why a compat layer isn't possible? It seems 
we could easily convert the vsyscall_gtod_data to a more explicit 
arch-neutral size. Or is it the actual data page mapping?

thanks
-john
