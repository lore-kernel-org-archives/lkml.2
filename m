Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0IXQDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:03:14 -0400
Received: from kroah.org ([198.145.64.141]:50923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032Ab0IXQDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:03:13 -0400
Date: Fri, 24 Sep 2010 09:02:06 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org
Subject: Re: Erratum 383 fix for 32 bit x86 kernels
Message-ID: <20100924160205.GB21235@kroah.com>
References: <20100924115239.GA9817@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100924115239.GA9817@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 01:52:40PM +0200, Joerg Roedel wrote:
> Hi Greg,
> 
> here is a patch which I want to ask you to include into the current
> -stable kernels. This patch fixes the occurence of AMD Erratum 383 on
> 32 bit x86 kernels when using CPU hotplug. This patch is a combined
> patch created by cherry-picking (and fixing a small compile error)
> upstream commits:
> 
> 	fd89a137924e0710078c3ae855e7cec1c43cb845
> 	b7d460897739e02f186425b7276e3fdb1595cea7
> 
> The second commit fixes a problem in the first one. The patch I attach
> here is against 2.6.32.22 but should also apply against 2.6.35 (At least
> cherry-picking from 2.6.36-rc gave no conflicts).
> Please consider to include this patch into the -stable kernel series.
> 
> Regards,
> 
> 	Joerg
> 
> >From d12a669119908f1c24a3b5037445c124c312eea5 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Thu, 22 Jul 2010 11:32:00 +0200
> Subject: [PATCH] x86-32: Fix crashes with CPU hotplug on AMD machines
> 
> This patch fixes machine crashes which occured when heavily
> testing cpu hotplug code on a 32 bit kernel. The kernel
> crashed because these tests triggered AMD erratum 383 which
> resulted in a machine check exception.
> The erratum triggered in the test cases because of the
> following steps:
> 
> 	1. On 32 bit the swapper_pg_dir page table is used
> 	   as the initial page table for booting a secondary
> 	   cpu.
> 
> 	2. To make this work swapper_pg_dir needs a direct
> 	   mapping of physical memory in it (the low
> 	   mappings)
> 
> 	3. Other cpus may use swapper_pg_dir while the low
> 	   mappings are present (when leave_mm is called).
> 
> 	4. This can result in TLB entries for addresses
> 	   below __PAGE_OFFSET to be established due to
> 	   speculative TLB loads. These TLB entries are
> 	   marked global and possibly large.
> 
> 	5. When the CPU which has this entry loaded switches
> 	   to another page table this global TLB entry is not
> 	   flushed.
> 
> 	6. The process accesses an address covered by this
> 	   TLB entry but there is a permission mismatch
> 	   (present TLB entry covers a large global page not
> 	    accessible for userspace).
> 
> 	7. Due to the permission mismatch the hardware
> 	   walks the new page table and establishes a new
> 	   4kb TLB entry. Due to AMD erratum 383 there might
> 	   be a small window of time now where both TLB
> 	   entries are present.
> 
> 	8. After the page walk the hardware does a new TLB
> 	   lookup which may result in two matches. This
> 	   results in a machine check exception which
> 	   signals a TLB multimatch error. The machine
> 	   crashes.
> 
> There are two ways to fix this issue:
> 
> 	1. Always do a global TLB flush when a new cr3 is
> 	   loaded and the old page table was swapper_pg_dir.
> 	   I consider this a hack hard to understand.
> 
> 	2. Do not use swapper_pg_dir to boot secondary cpus.
> 
> This patch implements solution 2. It introduces a
> trampoline_pg_dir which has the same layout as
> swapper_pg_dir with low_mappings. This page table is used as
> the initial page table of the booting cpu. Later in the
> bringup process it switches to swapper_pg_dir and does a
> global tlb flush. This fixes the crashes in our test cases.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/pgtable_32.h |    1 +
>  arch/x86/include/asm/trampoline.h |    3 +++
>  arch/x86/kernel/head_32.S         |    8 +++++++-
>  arch/x86/kernel/setup.c           |    2 ++
>  arch/x86/kernel/smpboot.c         |   21 ++++++---------------
>  arch/x86/kernel/trampoline.c      |   18 ++++++++++++++++++
>  6 files changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
> index 2984a25..f686f49 100644
> --- a/arch/x86/include/asm/pgtable_32.h
> +++ b/arch/x86/include/asm/pgtable_32.h
> @@ -26,6 +26,7 @@ struct mm_struct;
>  struct vm_area_struct;
>  
>  extern pgd_t swapper_pg_dir[1024];
> +extern pgd_t trampoline_pg_dir[1024];
>  
>  static inline void pgtable_cache_init(void) { }
>  static inline void check_pgt_cache(void) { }
> diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
> index cb507bb..8f78fdf 100644
> --- a/arch/x86/include/asm/trampoline.h
> +++ b/arch/x86/include/asm/trampoline.h
> @@ -13,14 +13,17 @@ extern unsigned char *trampoline_base;
>  
>  extern unsigned long init_rsp;
>  extern unsigned long initial_code;
> +extern unsigned long initial_page_table;
>  extern unsigned long initial_gs;
>  
>  #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
>  
>  extern unsigned long setup_trampoline(void);
> +extern void __init setup_trampoline_page_table(void);
>  extern void __init reserve_trampoline_memory(void);
>  #else
>  static inline void reserve_trampoline_memory(void) {};
> +extern void __init setup_trampoline_page_table(void) {};
>  #endif /* CONFIG_X86_TRAMPOLINE */

I don't think that last setup_trampoline_page_table() line is correct
here.

Shouldn't it be:
	static inline void setup_trampoline_page_table(void) {};
instead?

Otherwise I get the following error building the .32 code with this
patch:
	  CC      arch/x86/kernel/setup.o
	  arch/x86/kernel/setup.c: In function ‘setup_arch’:
	  arch/x86/kernel/setup.c:1001:2: error: implicit declaration of function ‘setup_trampoline_page_table’

Is this really how the code looks upstream?

Hm, even with changing the function prototype, I still get an error
building on the .32-stable tree on x86-64, so I'm dropping this patch
from there.

Also, it didn't apply cleanly to .32-stable, I had to apply this chunk
by hand, no big deal.

So, why not I just take the original git commits that are in Linus's
tree?  That should work, right?  If so, do I just need to use those two
above-mentioned commits?  Or something else?  I prefer taking the
original commits as it makes spelunking over time much easier.

thanks,

greg k-h


>  
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 37c3d4b..75e3981 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -328,7 +328,7 @@ ENTRY(startup_32_smp)
>  /*
>   * Enable paging
>   */
> -	movl $pa(swapper_pg_dir),%eax
> +	movl pa(initial_page_table), %eax
>  	movl %eax,%cr3		/* set the page table pointer.. */
>  	movl %cr0,%eax
>  	orl  $X86_CR0_PG,%eax
> @@ -608,6 +608,8 @@ ignore_int:
>  .align 4
>  ENTRY(initial_code)
>  	.long i386_start_kernel
> +ENTRY(initial_page_table)
> +	.long pa(swapper_pg_dir)
>  
>  /*
>   * BSS section
> @@ -623,6 +625,10 @@ ENTRY(swapper_pg_dir)
>  #endif
>  swapper_pg_fixmap:
>  	.fill 1024,4,0
> +#ifdef CONFIG_X86_TRAMPOLINE
> +ENTRY(trampoline_pg_dir)
> +	.fill 1024,4,0
> +#endif
>  ENTRY(empty_zero_page)
>  	.fill 4096,1,0
>  
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index b4ae4ac..6600cfd 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1008,6 +1008,8 @@ void __init setup_arch(char **cmdline_p)
>  	paging_init();
>  	x86_init.paging.pagetable_setup_done(swapper_pg_dir);
>  
> +	setup_trampoline_page_table();
> +
>  	tboot_probe();
>  
>  #ifdef CONFIG_X86_64
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index c4f33b2..7b05eb1 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -73,7 +73,6 @@
>  
>  #ifdef CONFIG_X86_32
>  u8 apicid_2_node[MAX_APICID];
> -static int low_mappings;
>  #endif
>  
>  /* State of each CPU */
> @@ -300,8 +299,8 @@ notrace static void __cpuinit start_secondary(void *unused)
>  	}
>  
>  #ifdef CONFIG_X86_32
> -	while (low_mappings)
> -		cpu_relax();
> +	/* switch away from the trampoline page-table */
> +	load_cr3(swapper_pg_dir);
>  	__flush_tlb_all();
>  #endif
>  
> @@ -765,6 +764,10 @@ do_rest:
>  	initial_code = (unsigned long)start_secondary;
>  	stack_start.sp = (void *) c_idle.idle->thread.sp;
>  
> +#ifdef CONFIG_X86_32
> +	initial_page_table = __pa(&trampoline_pg_dir);
> +#endif
> +
>  	/* start_ip had better be page-aligned! */
>  	start_ip = setup_trampoline();
>  
> @@ -894,20 +897,8 @@ int __cpuinit native_cpu_up(unsigned int cpu)
>  
>  	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
>  
> -#ifdef CONFIG_X86_32
> -	/* init low mem mapping */
> -	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
> -		min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
> -	flush_tlb_all();
> -	low_mappings = 1;
> -
>  	err = do_boot_cpu(apicid, cpu);
>  
> -	zap_low_mappings(false);
> -	low_mappings = 0;
> -#else
> -	err = do_boot_cpu(apicid, cpu);
> -#endif
>  	if (err) {
>  		pr_debug("do_boot_cpu failed %d\n", err);
>  		return -EIO;
> diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
> index c652ef6..a874495 100644
> --- a/arch/x86/kernel/trampoline.c
> +++ b/arch/x86/kernel/trampoline.c
> @@ -1,6 +1,7 @@
>  #include <linux/io.h>
>  
>  #include <asm/trampoline.h>
> +#include <asm/pgtable.h>
>  #include <asm/e820.h>
>  
>  #if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
> @@ -37,3 +38,20 @@ unsigned long __trampinit setup_trampoline(void)
>  	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
>  	return virt_to_phys(trampoline_base);
>  }
> +
> +void __init setup_trampoline_page_table(void)
> +{
> +#ifdef CONFIG_X86_32
> +	/* Copy kernel address range */
> +	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
> +			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
> +			min_t(unsigned long, KERNEL_PGD_PTRS,
> +			      KERNEL_PGD_BOUNDARY));
> +
> +	/* Initialize low mappings */
> +	clone_pgd_range(trampoline_pg_dir,
> +			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
> +			min_t(unsigned long, KERNEL_PGD_PTRS,
> +			      KERNEL_PGD_BOUNDARY));
> +#endif
> +}
> -- 
> 1.7.0.4
> 
> -- 
> AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
