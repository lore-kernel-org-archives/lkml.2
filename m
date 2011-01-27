Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1A0CoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 21:44:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1A0Cn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 21:43:59 -0500
Date: Wed, 26 Jan 2011 21:43:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash_dump: export is_kdump_kernel to modules,
 consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
Message-ID: <20110127024352.GC20334@redhat.com>
References: <20110125161052.GA20105@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125161052.GA20105@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 05:10:52PM +0100, Olaf Hering wrote:
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

Olaf, 

I think your HVM guest has booted into kdump kernel after the crash and
now you want Xen PV driver to reset the connection with Dom0.

If that's the case, I think instead of exporting is_kdump_kernel(), better
make use of symbol "reset_devices". Kexec-tools passes this kernel command
line option to kdump kernel which tells the kernel that it is booting
in an unreliable environment and device drivers should reset the
underlying devices and not rely on BIOS to have put devices in a known
good state. So if reset_devices=1, then Xen PV driver should reset the
underlying device hence the connection with Dom0.

Apart from that, moving the code from arch specific section to generic
code helps. So that bit you can retain and get rid of export of
is_kdump_kernel() and elfcorehdr_addr.

Thanks
Vivek
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
> 
> --- linux-2.6.38.rc.orig/arch/arm/kernel/crash_dump.c
> +++ linux-2.6.38.rc/arch/arm/kernel/crash_dump.c
> @@ -18,9 +18,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
>  
> -/* stores the physical address of elf header of crash image */
> -unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> -
>  /**
>   * copy_oldmem_page() - copy one page from old kernel memory
>   * @pfn: page frame number to be copied
> --- linux-2.6.38.rc.orig/arch/arm/kernel/setup.c
> +++ linux-2.6.38.rc/arch/arm/kernel/setup.c
> @@ -765,30 +765,6 @@ static void __init reserve_crashkernel(v
>  static inline void reserve_crashkernel(void) {}
>  #endif /* CONFIG_KEXEC */
>  
> -/*
> - * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> - * is_kdump_kernel() to determine if we are booting after a panic. Hence
> - * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> - */
> -
> -#ifdef CONFIG_CRASH_DUMP
> -/*
> - * elfcorehdr= specifies the location of elf core header stored by the crashed
> - * kernel. This option will be passed by kexec loader to the capture kernel.
> - */
> -static int __init setup_elfcorehdr(char *arg)
> -{
> -	char *end;
> -
> -	if (!arg)
> -		return -EINVAL;
> -
> -	elfcorehdr_addr = memparse(arg, &end);
> -	return end > arg ? 0 : -EINVAL;
> -}
> -early_param("elfcorehdr", setup_elfcorehdr);
> -#endif /* CONFIG_CRASH_DUMP */
> -
>  static void __init squash_mem_tags(struct tag *tag)
>  {
>  	for (; tag->hdr.size; tag = tag_next(tag))
> --- linux-2.6.38.rc.orig/arch/ia64/kernel/crash_dump.c
> +++ linux-2.6.38.rc/arch/ia64/kernel/crash_dump.c
> @@ -13,9 +13,6 @@
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
>  
> -/* Stores the physical address of elf header of crash image. */
> -unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> -
>  /**
>   * copy_oldmem_page - copy one page from "oldmem"
>   * @pfn: page frame number to be copied
> --- linux-2.6.38.rc.orig/arch/ia64/kernel/efi.c
> +++ linux-2.6.38.rc/arch/ia64/kernel/efi.c
> @@ -23,6 +23,7 @@
>   */
>  #include <linux/module.h>
>  #include <linux/bootmem.h>
> +#include <linux/crash_dump.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> --- linux-2.6.38.rc.orig/arch/ia64/kernel/setup.c
> +++ linux-2.6.38.rc/arch/ia64/kernel/setup.c
> @@ -479,25 +479,7 @@ static __init int setup_nomca(char *s)
>  }
>  early_param("nomca", setup_nomca);
>  
> -/*
> - * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> - * is_kdump_kernel() to determine if we are booting after a panic. Hence
> - * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> - */
>  #ifdef CONFIG_CRASH_DUMP
> -/* elfcorehdr= specifies the location of elf core header
> - * stored by the crashed kernel.
> - */
> -static int __init parse_elfcorehdr(char *arg)
> -{
> -	if (!arg)
> -		return -EINVAL;
> -
> -        elfcorehdr_addr = memparse(arg, &arg);
> -	return 0;
> -}
> -early_param("elfcorehdr", parse_elfcorehdr);
> -
>  int __init reserve_elfcorehdr(u64 *start, u64 *end)
>  {
>  	u64 length;
> --- linux-2.6.38.rc.orig/arch/powerpc/kernel/crash_dump.c
> +++ linux-2.6.38.rc/arch/powerpc/kernel/crash_dump.c
> @@ -28,9 +28,6 @@
>  #define DBG(fmt...)
>  #endif
>  
> -/* Stores the physical address of elf header of crash image. */
> -unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> -
>  #ifndef CONFIG_RELOCATABLE
>  void __init reserve_kdump_trampoline(void)
>  {
> @@ -72,20 +69,6 @@ void __init setup_kdump_trampoline(void)
>  }
>  #endif /* CONFIG_RELOCATABLE */
>  
> -/*
> - * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> - * is_kdump_kernel() to determine if we are booting after a panic. Hence
> - * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> - */
> -static int __init parse_elfcorehdr(char *p)
> -{
> -	if (p)
> -		elfcorehdr_addr = memparse(p, &p);
> -
> -	return 1;
> -}
> -__setup("elfcorehdr=", parse_elfcorehdr);
> -
>  static int __init parse_savemaxmem(char *p)
>  {
>  	if (p)
> --- linux-2.6.38.rc.orig/arch/sh/kernel/crash_dump.c
> +++ linux-2.6.38.rc/arch/sh/kernel/crash_dump.c
> @@ -9,28 +9,6 @@
>  #include <linux/io.h>
>  #include <asm/uaccess.h>
>  
> -/* Stores the physical address of elf header of crash image. */
> -unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> -
> -/*
> - * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> - * is_kdump_kernel() to determine if we are booting after a panic. Hence
> - * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> - *
> - * elfcorehdr= specifies the location of elf core header
> - * stored by the crashed kernel.
> - */
> -static int __init parse_elfcorehdr(char *arg)
> -{
> -	if (!arg)
> -		return -EINVAL;
> -
> -	elfcorehdr_addr = memparse(arg, &arg);
> -
> -	return 0;
> -}
> -early_param("elfcorehdr", parse_elfcorehdr);
> -
>  /**
>   * copy_oldmem_page - copy one page from "oldmem"
>   * @pfn: page frame number to be copied
> --- linux-2.6.38.rc.orig/arch/x86/kernel/crash_dump_32.c
> +++ linux-2.6.38.rc/arch/x86/kernel/crash_dump_32.c
> @@ -14,9 +14,6 @@
>  
>  static void *kdump_buf_page;
>  
> -/* Stores the physical address of elf header of crash image. */
> -unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> -
>  static inline bool is_crashed_pfn_valid(unsigned long pfn)
>  {
>  #ifndef CONFIG_X86_PAE
> --- linux-2.6.38.rc.orig/arch/x86/kernel/crash_dump_64.c
> +++ linux-2.6.38.rc/arch/x86/kernel/crash_dump_64.c
> @@ -10,9 +10,6 @@
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
>  
> -/* Stores the physical address of elf header of crash image. */
> -unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> -
>  /**
>   * copy_oldmem_page - copy one page from "oldmem"
>   * @pfn: page frame number to be copied
> --- linux-2.6.38.rc.orig/arch/x86/kernel/e820.c
> +++ linux-2.6.38.rc/arch/x86/kernel/e820.c
> @@ -11,6 +11,7 @@
>  #include <linux/kernel.h>
>  #include <linux/types.h>
>  #include <linux/init.h>
> +#include <linux/crash_dump.h>
>  #include <linux/bootmem.h>
>  #include <linux/pfn.h>
>  #include <linux/suspend.h>
> --- linux-2.6.38.rc.orig/arch/x86/kernel/setup.c
> +++ linux-2.6.38.rc/arch/x86/kernel/setup.c
> @@ -601,28 +601,6 @@ void __init reserve_standard_io_resource
>  
>  }
>  
> -/*
> - * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
> - * is_kdump_kernel() to determine if we are booting after a panic. Hence
> - * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
> - */
> -
> -#ifdef CONFIG_CRASH_DUMP
> -/* elfcorehdr= specifies the location of elf core header
> - * stored by the crashed kernel. This option will be passed
> - * by kexec loader to the capture kernel.
> - */
> -static int __init setup_elfcorehdr(char *arg)
> -{
> -	char *end;
> -	if (!arg)
> -		return -EINVAL;
> -	elfcorehdr_addr = memparse(arg, &end);
> -	return end > arg ? 0 : -EINVAL;
> -}
> -early_param("elfcorehdr", setup_elfcorehdr);
> -#endif
> -
>  static __init void reserve_ibft_region(void)
>  {
>  	unsigned long addr, size = 0;
> --- linux-2.6.38.rc.orig/include/linux/bootmem.h
> +++ linux-2.6.38.rc/include/linux/bootmem.h
> @@ -19,10 +19,6 @@ extern unsigned long min_low_pfn;
>   */
>  extern unsigned long max_pfn;
>  
> -#ifdef CONFIG_CRASH_DUMP
> -extern unsigned long saved_max_pfn;
> -#endif
> -
>  #ifndef CONFIG_NO_BOOTMEM
>  /*
>   * node_bootmem_map is a map pointer - the bits represent all physical 
> --- linux-2.6.38.rc.orig/kernel/Makefile
> +++ linux-2.6.38.rc/kernel/Makefile
> @@ -107,6 +107,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.
>  obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>  obj-$(CONFIG_PADATA) += padata.o
> +obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
>  
>  ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
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
> --- linux-2.6.38.rc.orig/mm/bootmem.c
> +++ linux-2.6.38.rc/mm/bootmem.c
> @@ -27,14 +27,6 @@ unsigned long max_low_pfn;
>  unsigned long min_low_pfn;
>  unsigned long max_pfn;
>  
> -#ifdef CONFIG_CRASH_DUMP
> -/*
> - * If we have booted due to a crash, max_pfn will be a very low value. We need
> - * to know the amount of memory that the previous kernel used.
> - */
> -unsigned long saved_max_pfn;
> -#endif
> -
>  #ifndef CONFIG_NO_BOOTMEM
>  bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
