Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2LQWWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:22:51 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36797 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2LQWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:22:50 -0500
MIME-Version: 1.0
In-Reply-To: <1355782365-11307-1-git-send-email-stefani@seibold.net>
References: <1355782365-11307-1-git-send-email-stefani@seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Dec 2012 14:22:28 -0800
Message-ID: <CALCETrXnm1ew+CCfSu3fP_sBKhFTtX35z1qhapXhrRC3s=PpXQ@mail.gmail.com>
Subject: Re: [PATCH] Add 32 bit VDSO time function support
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, xemul@parallels.com,
        gorcunov@openvz.org, andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 2:12 PM,  <stefani@seibold.net> wrote:
> From: Stefani Seibold <stefani@seibold.net>
>
> This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
> and vdso_time() to the 32 bit VDSO.
>
> The reason to do this was to get a fast reliable time stamp. Many developers
> uses TSC to get a fast time time stamp, without knowing the pitfalls. VDSO
> time functions a fast and reliable way, because the kernel knows the
> best time source and the P- and C-state of the CPU.
>
> The helper library to use the VDSO functions can be download at
> http://http://seibold.net/vdso.c
> The libary is very small, only 228 lines of code. Compile it with
> gcc -Wall -O3 -fpic vdso.c -lrt -shared -o libvdso.so
> and use it with LD_PRELOAD=<path>/libvdso.so
>
> This kind of helper must be integrated into glibc, for x86 64-bit and
> PowerPC it is already there.
>
> Some benchmark linux 32 bit results (all measurements are in nano seconds):
>
> Intel(R) Celeron(TM) CPU 400MHz
>
> Average time kernel call:
>  gettimeofday(): 1039
>  clock_gettime(): 1578
>  time(): 526
> Average time VDSO call:
>  gettimeofday(): 378
>  clock_gettime(): 303
>  time(): 60
>
> Celeron(R) Dual-Core CPU T3100 1.90GHz
>
> Average time kernel call:
>  gettimeofday(): 209
>  clock_gettime(): 406
>  time(): 135
> Average time VDSO call:
>  gettimeofday(): 51
>  clock_gettime(): 43
>  time(): 10
>
> So you can see a performance increase between 4 and 13, depending on the
> CPU and the function.
>
> The patch is against kernel 3.7. Please apply if you like it.

This would probably be a lot more readable if you split out the
preparation parts -- i.e. struct rearrangement and bitness issues, and
then added the new code on top of it.

>
> Changelog:
> 25.11.2012 - first release and proof of concept for linux 3.4
> 11.12.2012 - Port to linux 3.7 and code cleanup
> 12.12.2012 - fixes suggested by Andy Lutomirski
>            - fixes suggested by John Stultz
>            - use call VDSO32_vsyscall instead of int 80
>            - code cleanup
> 17.12.2012 - support for IA32_EMULATION, this includes
>              - code cleanup
>              - include cleanup to fix compile warnings and errors
>              - move out seqcount from seqlock, enable use in VDSO
>              - map FIXMAP and HPET into the 32 bit address space
>
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> ---
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
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 46c3bff..b8c2c74 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -100,9 +100,9 @@ config X86
>         select GENERIC_CMOS_UPDATE
>         select CLOCKSOURCE_WATCHDOG
>         select GENERIC_CLOCKEVENTS
> -       select ARCH_CLOCKSOURCE_DATA if X86_64
> +       select ARCH_CLOCKSOURCE_DATA
>         select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
> -       select GENERIC_TIME_VSYSCALL if X86_64
> +       select GENERIC_TIME_VSYSCALL
>         select KTIME_SCALAR if X86_32
>         select GENERIC_STRNCPY_FROM_USER
>         select GENERIC_STRNLEN_USER
> diff --git a/arch/x86/include/asm/clocksource.h b/arch/x86/include/asm/clocksource.h
> index 0bdbbb3..67d68b9 100644
> --- a/arch/x86/include/asm/clocksource.h
> +++ b/arch/x86/include/asm/clocksource.h
> @@ -3,8 +3,6 @@
>  #ifndef _ASM_X86_CLOCKSOURCE_H
>  #define _ASM_X86_CLOCKSOURCE_H
>
> -#ifdef CONFIG_X86_64
> -
>  #define VCLOCK_NONE 0  /* No vDSO clock available.     */
>  #define VCLOCK_TSC  1  /* vDSO should use vread_tsc.   */
>  #define VCLOCK_HPET 2  /* vDSO should use vread_hpet.  */
> @@ -13,6 +11,4 @@ struct arch_clocksource_data {
>         int vclock_mode;
>  };
>
> -#endif /* CONFIG_X86_64 */
> -
>  #endif /* _ASM_X86_CLOCKSOURCE_H */
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 4da3c0c..75ebc52 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -16,7 +16,8 @@
>
>  #ifndef __ASSEMBLY__
>  #include <linux/kernel.h>
> -#include <asm/acpi.h>
> +#include <linux/bug.h>
> +#include <asm/pgtable_types.h>
>  #include <asm/apicdef.h>
>  #include <asm/page.h>
>  #ifdef CONFIG_X86_32
> @@ -78,9 +79,10 @@ enum fixed_addresses {
>         VSYSCALL_LAST_PAGE,
>         VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
>                             + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
> +#endif
>         VVAR_PAGE,
>         VSYSCALL_HPET,
> -#endif
> +
>         FIX_DBGP_BASE,
>         FIX_EARLYCON_MEM_BASE,
>  #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
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
>         seqcount_t      seq;
> @@ -13,7 +13,7 @@ struct vsyscall_gtod_data {
>                 cycle_t mask;
>                 u32     mult;
>                 u32     shift;
> -       } clock;
> +       } __attribute__((aligned(4),packed)) clock;
>
>         /* open coded 'struct timespec' */
>         time_t          wall_time_sec;
> @@ -24,7 +24,9 @@ struct vsyscall_gtod_data {
>         struct timezone sys_tz;
>         struct timespec wall_time_coarse;
>         struct timespec monotonic_time_coarse;
> -};
> +} __attribute__((aligned(4),packed));
> +
>  extern struct vsyscall_gtod_data vsyscall_gtod_data;
>
> +extern void map_vgtod(void);
>  #endif /* _ASM_X86_VGTOD_H */
> diff --git a/arch/x86/include/asm/vsyscall.h b/arch/x86/include/asm/vsyscall.h
> index eaea1d3..24730cb 100644
> --- a/arch/x86/include/asm/vsyscall.h
> +++ b/arch/x86/include/asm/vsyscall.h
> @@ -14,7 +14,6 @@ enum vsyscall_num {
>  #define VSYSCALL_ADDR(vsyscall_nr) (VSYSCALL_START+VSYSCALL_SIZE*(vsyscall_nr))
>
>  #ifdef __KERNEL__
> -#include <linux/seqlock.h>
>
>  #define VGETCPU_RDTSCP 1
>  #define VGETCPU_LSL    2
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
>  #if defined(__VVAR_KERNEL_LDS)
>
> @@ -46,5 +50,6 @@
>  DECLARE_VVAR(0, volatile unsigned long, jiffies)
>  DECLARE_VVAR(16, int, vgetcpu_mode)
>  DECLARE_VVAR(128, struct vsyscall_gtod_data, vsyscall_gtod_data)
> +DECLARE_VVAR(512, const void __iomem *, vsyscall_hpet)

This looks suspicious.  Is that a 64-bit pointer or a 32-bit pointer?

> diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
> index 0faad64..02fe183 100644
> --- a/arch/x86/vdso/vdso32-setup.c
> +++ b/arch/x86/vdso/vdso32-setup.c
> @@ -16,6 +16,7 @@
>  #include <linux/mm.h>
>  #include <linux/err.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>
>  #include <asm/cpufeature.h>
>  #include <asm/msr.h>
> @@ -194,6 +195,9 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
>  }
>
>  static struct page *vdso32_pages[1];
> +#ifdef CONFIG_IA32_EMULATION
> +static struct page *vvar_pages[1];
> +#endif
>
>  #ifdef CONFIG_X86_64
>
> @@ -279,7 +283,11 @@ int __init sysenter_setup(void)
>         void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
>         const void *vsyscall;
>         size_t vsyscall_len;
> +#ifdef CONFIG_IA32_EMULATION
> +       extern char __vvar_page;
>
> +       vvar_pages[0] = virt_to_page(&__vvar_page);
> +#endif
>         vdso32_pages[0] = virt_to_page(syscall_page);
>
>  #ifdef CONFIG_X86_32
> @@ -310,6 +318,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
>         unsigned long addr;
>         int ret = 0;
>         bool compat;
> +#ifdef CONFIG_IA32_EMULATION
> +       extern unsigned long hpet_address;
> +#endif
>
>  #ifdef CONFIG_X86_X32_ABI
>         if (test_thread_flag(TIF_X32))
> @@ -352,6 +363,36 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
>                         goto up_fail;
>         }
>
> +#ifdef CONFIG_IA32_EMULATION
> +       ret = install_special_mapping(mm, VVAR_ADDRESS & 0xffffffff, PAGE_SIZE,
> +                       VM_READ|VM_EXEC, vvar_pages);
> +
> +       if (ret)
> +               goto up_fail;
> +
> +       if (hpet_address) {
> +               struct vm_area_struct *vma = _install_special_mapping(mm,
> +                               __fix_to_virt(VSYSCALL_HPET) & 0xffffffff,
> +                               PAGE_SIZE, VM_READ|VM_EXEC|VM_IO|VM_LOCKED,
> +                               NULL);
> +
> +               if (IS_ERR(vma)) {
> +                       ret = PTR_ERR(vma);
> +                       goto up_fail;
> +               }
> +
> +               vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +
> +               ret = io_remap_pfn_range(vma,
> +                               vma->vm_start,
> +                               hpet_address >> PAGE_SHIFT,
> +                               PAGE_SIZE,
> +                               vma->vm_page_prot);
> +               if (ret)
> +                       goto up_fail;
> +       }
> +#endif
> +

IMO this really wants to only happen if the program has the 32-bit vdso mapped.

>         current_thread_info()->sysenter_return =
>                 VDSO32_SYMBOL(addr, SYSENTER_RETURN);
>


--Andy
