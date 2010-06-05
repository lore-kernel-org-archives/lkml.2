Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0FED3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 23:29:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58098 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab0FED3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 23:29:32 -0400
Date: Sat, 5 Jun 2010 05:29:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, dilinger@queued.net, hpa@zytor.com,
       jordan.crouse@amd.com, tglx@linutronix.de
Subject: Re: + x86-olpc-add-support-for-calling-into-openfirmware.patch added
 to -mm tree
Message-ID: <20100605032905.GD5246@elte.hu>
References: <201006042248.o54MmSgH022854@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006042248.o54MmSgH022854@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

>  arch/x86/Kconfig                        |    9 ++
>  arch/x86/include/asm/olpc_ofw.h         |   33 ++++++++
>  arch/x86/include/asm/pgtable_32_types.h |   14 ++-
>  arch/x86/include/asm/setup.h            |    1 
>  arch/x86/kernel/Makefile                |    1 
>  arch/x86/kernel/head_32.S               |   31 +++++++
>  arch/x86/kernel/olpc.c                  |    8 +-
>  arch/x86/kernel/olpc_ofw.c              |   88 ++++++++++++++++++++++
>  arch/x86/kernel/setup.c                 |    3 
>  arch/x86/mm/dump_pagetables.c           |    7 +
>  arch/x86/mm/init_32.c                   |   17 ++++
>  11 files changed, 205 insertions(+), 7 deletions(-)

(Also needs an ack from hpa after you are done with addressing my review 
feedback.)

> 
> diff -puN arch/x86/Kconfig~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/Kconfig
> --- a/arch/x86/Kconfig~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/Kconfig
> @@ -2060,6 +2060,15 @@ config OLPC
>  	  Add support for detecting the unique features of the OLPC
>  	  XO hardware.
>  
> +config OLPC_OPENFIRMWARE
> +	bool "Support for OLPC's Open Firmware"
> +	depends on !X86_64 && !X86_PAE
> +	default y if OLPC
> +	help
> +	  This option adds support for the implementation of Open Firmware
> +	  that is used on the OLPC XO-1 Children's Machine.
> +	  If unsure, say N here.
> +
>  endif # X86_32
>  
>  config K8_NB
> diff -puN /dev/null arch/x86/include/asm/olpc_ofw.h
> --- /dev/null
> +++ a/arch/x86/include/asm/olpc_ofw.h
> @@ -0,0 +1,33 @@
> +#ifndef _ASM_X86_OLPC_OFW_H
> +#define _ASM_X86_OLPC_OFW_H
> +
> +/* hardcode addresses to make life easier dealing w/ VMALLOC_END and others */
> +#define OLPC_OFW_START 0xff800000UL
> +#define OLPC_OFW_SIZE (PGDIR_SIZE)
> +#define OLPC_OFW_END (OLPC_OFW_START + OLPC_OFW_SIZE)
> +
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +
> +#ifndef __ASSEMBLER__

We use __ASSEMBLY__ for such things.

> +
> +/* address of OFW callback interface; will be NULL if OFW isn't found */
> +extern int (*olpc_ofw_cif)(int *);
> +
> +/* page dir entry containing OFW's current memory */
> +extern pgdval_t olpc_ofw_pgd;
> +
> +/* run an OFW command by calling into the firmware */
> +extern int olpc_ofw(const char *name, int nr_args, int nr_res, ...);

extern.

> +
> +/* determine/ensure OFW lives in the proper place in (virtual) memory */
> +void olpc_ofw_detect_range(void);

Non-extern. Pick one.

> +
> +#endif
> +
> +#else

else which one? We use comments to indicate where it came from.

> +
> +static inline void olpc_ofw_detect_range(void) { }
> +
> +#endif

Ditto.

> +
> +#endif

Ditto.

> diff -puN arch/x86/include/asm/pgtable_32_types.h~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/include/asm/pgtable_32_types.h
> --- a/arch/x86/include/asm/pgtable_32_types.h~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/include/asm/pgtable_32_types.h
> @@ -37,13 +37,21 @@ extern bool __vmalloc_start_set; /* set 
>  #define LAST_PKMAP 1024
>  #endif
>  
> -#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP + 1))	\
> -		    & PMD_MASK)
> +#include <asm/olpc_ofw.h>
> +
> +/* make sure we have enough space for PKMAP region *and* OFW after VMALLOC*/
> +#define PKMAP_BASE ((FIXADDR_BOOT_START - PAGE_SIZE * (LAST_PKMAP + 1) \
> +		- OLPC_OFW_SIZE) & PMD_MASK)
>  
>  #ifdef CONFIG_HIGHMEM
>  # define VMALLOC_END	(PKMAP_BASE - 2 * PAGE_SIZE)
>  #else
> -# define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
> +# ifdef CONFIG_OLPC_OPENFIRMWARE
> +   /* dumppages looks a lot saner if we leave a PGDIR_SIZEd gap */
> +#  define VMALLOC_END	(OLPC_OFW_START - PGDIR_SIZE)
> +# else
> +#  define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
> +# endif
>  #endif

So why does it have a different pagetable layout from rest of x86?

>  #define MODULES_VADDR	VMALLOC_START
> diff -puN arch/x86/include/asm/setup.h~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/include/asm/setup.h
> --- a/arch/x86/include/asm/setup.h~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/include/asm/setup.h
> @@ -21,6 +21,7 @@
>  #define OLD_CL_MAGIC		0xA33F

The 'A' is capitalized.

>  #define OLD_CL_ADDRESS		0x020	/* Relative to real mode data */
>  #define NEW_CL_POINTER		0x228	/* Relative to real mode data */
> +#define OLPC_OFW_INFO_OFFSET	0xb0	/* Relative to real mode data */

The 'b' is not capitalized.

Please read the code you are modifying and try to adopt to its style 
precisely, so that people looking at you code later on get the feeling that we 
care about its quality.

>  #ifndef __ASSEMBLY__
>  #include <asm/bootparam.h>
> diff -puN arch/x86/kernel/Makefile~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/Makefile
> --- a/arch/x86/kernel/Makefile~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/kernel/Makefile
> @@ -104,6 +104,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
>  scx200-y			+= scx200_32.o
>  
>  obj-$(CONFIG_OLPC)		+= olpc.o
> +obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
>  obj-$(CONFIG_X86_MRST)		+= mrst.o
>  
>  microcode-y				:= microcode_core.o
> diff -puN arch/x86/kernel/head_32.S~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/head_32.S
> --- a/arch/x86/kernel/head_32.S~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/kernel/head_32.S
> @@ -131,6 +131,29 @@ ENTRY(startup_32)
>  	movsl
>  1:
>  
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +	movl $0x0, pa(olpc_ofw_cif)
> +
> +	/* Did OpenFirmware boot us? */

Comment in front of an instruction.

> +	movl $pa(boot_params) + OLPC_OFW_INFO_OFFSET, %ebp
> +	cmpl $0x2057464F, (%ebp)	/* Magic number "OFW " */

Comment next to an instruction.

Inconsistent. Pick one variant and stick to it.

> +	jne 3f
> +
> +	/* Save the callback address for calling into OFW from linux */
> +	mov 0x8(%ebp), %eax
> +	mov %eax, pa(olpc_ofw_cif)
> +
> +	/* %cr3 holds OFW's pgdir table.  For calling info OFW, we need to
> +	 * the save next-to-last pgdir table entry, which points to a page
> +	 * table that lives within OFW's memory.  The pgdir table contains
> +	 * 1024 entries (each a 4 byte pde), so we want
> +	 * ((int *) %cr3)[1022]. */

Please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

> +	movl %cr3, %eax
> +	movl 1022*4(%eax), %ebx
> +	movl %ebx, pa(olpc_ofw_pgd)
> +3:
> +#endif
> +
>  #ifdef CONFIG_PARAVIRT
>  	/* This is can only trip for a broken bootloader... */
>  	cmpw $0x207, pa(boot_params + BP_version)
> @@ -658,6 +681,14 @@ ENTRY(stack_start)
>  	.long init_thread_union+THREAD_SIZE
>  	.long __BOOT_DS
>  
> +.globl olpc_ofw_cif
> +.globl olpc_ofw_pgd
> +
> +olpc_ofw_cif:
> +	.long olpc_ofw_cif
> +olpc_ofw_pgd:
> +	.long olpc_ofw_pgd
> +
>  ready:	.byte 0
>  
>  early_recursion_flag:
> diff -puN arch/x86/kernel/olpc.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/olpc.c
> --- a/arch/x86/kernel/olpc.c~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/kernel/olpc.c
> @@ -22,8 +22,8 @@
>  #include <asm/setup.h>
>  #include <asm/olpc.h>
>  
> -#ifdef CONFIG_OPEN_FIRMWARE
> -#include <asm/ofw.h>
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +#include <asm/olpc_ofw.h>
>  #endif

Headers ought to be includable without any #ifdef protectors in .c files.

>  
>  struct olpc_platform_t olpc_platform_info;
> @@ -188,13 +188,13 @@ err:
>  }
>  EXPORT_SYMBOL_GPL(olpc_ec_cmd);
>  
> -#ifdef CONFIG_OPEN_FIRMWARE
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
>  static void __init platform_detect(void)
>  {
>  	size_t propsize;
>  	__be32 rev;
>  
> -	if (ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
> +	if (olpc_ofw("getprop", 4, 1, NULL, "board-revision-int", &rev, 4,
>  			&propsize) || propsize != 4) {
>  		printk(KERN_ERR "ofw: getprop call failed!\n");
>  		rev = cpu_to_be32(0);
> diff -puN /dev/null arch/x86/kernel/olpc_ofw.c
> --- /dev/null
> +++ a/arch/x86/kernel/olpc_ofw.c
> @@ -0,0 +1,88 @@
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <asm/page.h>
> +#include <asm/pgtable.h>
> +#include <asm/olpc_ofw.h>
> +
> +static DEFINE_SPINLOCK(ofw_lock);
> +
> +#define MAXARGS 10
> +
> +/* handle actual call into OFW */
> +static int __olpc_ofw(int *ofw_args)
> +{
> +	pgd_t *base, *pde;
> +	pgdval_t oldval;
> +	int ret;
> +
> +	/* temporarily clobber %cr3[1022] w/ olpc_ofw_pgd */
> +	base = __va(read_cr3());

What if this is a PAE kernel (can the affected CPUs do PAE at all?)? We have 
proper generic primitives for pagetable manipulation.

> +	pde = &base[1022];

At minimum symbolize that magic 1022 value.

> +	oldval = pgd_val(*pde);
> +	set_pgd(pde, __pgd(olpc_ofw_pgd));

We just modified the pagetable - who does the TLB flush?

> +
> +	/* call into ofw */
> +	ret = olpc_ofw_cif(ofw_args);
> +
> +	/* restore %cr3[1022] */
> +	set_pgd(pde, __pgd(oldval));
> +
> +	return ret;
> +}
> +
> +
> +int olpc_ofw(const char *name, int nr_args, int nr_res, ...)
> +{
> +	int args[MAXARGS + 3];
> +	unsigned long flags;
> +	va_list ap;
> +	int ret, i, *ofw_ret;
> +
> +	if (!olpc_ofw_cif)
> +		return -1;

So here we return with an error.

> +	BUG_ON(nr_args + nr_res > MAXARGS);

But here we crash the machine.

Inconsistent, and crashing the machine is bad. Use WARN_ON_ONCE() please.

> +
> +	args[0] = (int) name;

Please run checkpatch against patches. (If it didnt warn about the spurious 
space tearing apart the type cast then please notify the checkpatch folks.)

> +	args[1] = nr_args;
> +	args[2] = nr_res;
> +
> +	va_start(ap, nr_res);

It's called only once. Why the whole vararg gunk, do you expect to call this 
for anything else but getprop/board-revision-int?

Also, even if it's used in multiple places, please dont hide the whole thing 
behind an unbelievably ugly 'int, int, vararg' obfuscation - instead declare 
this call structure openly, pass in _two_ int args arrays (and sizes for 
both), one for arguments and one for results, both set up at the callsite with 
the proper local pointers - or something like that.

> +	i = 3;
> +	while (nr_args) {
> +		args[i++] = va_arg(ap, int);
> +		nr_args--;
> +	}
> +
> +	spin_lock_irqsave(&ofw_lock, flags);
> +	ret = __olpc_ofw(args);
> +	spin_unlock_irqrestore(&ofw_lock, flags);

This is the only call-site of __olpc_ofw() but the lock is taken outside, why?

> +	if (ret == 0) {

(since it's an error return '(!ret)' is more canonical.)

> +		while (nr_res) {
> +			ofw_ret = va_arg(ap, int *);
> +			*ofw_ret = args[i++];
> +			nr_res--;
> +		}
> +	}
> +
> +	va_end(ap);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(olpc_ofw);
> +
> +void __init olpc_ofw_detect_range(void)
> +{
> +	if (!olpc_ofw_cif)
> +		return;
> +
> +	/* verify that the cif lies within a memory range that we expect */
> +	if ((unsigned long) olpc_ofw_cif < OLPC_OFW_START ||
> +				(unsigned long) olpc_ofw_cif > OLPC_OFW_END) {
> +		printk(KERN_WARNING "OFW detected, but cif has invalid address 0x%lx - disabling!\n",
> +				(unsigned long) olpc_ofw_cif);
> +		olpc_ofw_cif = NULL;
> +	} else
> +		printk(KERN_WARNING "OFW detected in memory, cif @ 0x%lx\n",
> +				(unsigned long) olpc_ofw_cif);

Unnecessary spaces after type casts too. Unnecessary and ugly line-breaks. 
Imbalanced curly braces. Ugly and avoidable type casts to begin with.

> +}
> diff -puN arch/x86/kernel/setup.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/kernel/setup.c
> --- a/arch/x86/kernel/setup.c~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/kernel/setup.c
> @@ -102,6 +102,7 @@
>  
>  #include <asm/paravirt.h>
>  #include <asm/hypervisor.h>
> +#include <asm/olpc_ofw.h>
>  
>  #include <asm/percpu.h>
>  #include <asm/topology.h>
> @@ -859,6 +860,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	dmi_check_system(bad_bios_dmi_table);
>  
> +	olpc_ofw_detect_range();
> +
>  	/*
>  	 * VMware detection requires dmi to be available, so this
>  	 * needs to be done after dmi_scan_machine, for the BP.
> diff -puN arch/x86/mm/dump_pagetables.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/mm/dump_pagetables.c
> --- a/arch/x86/mm/dump_pagetables.c~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/mm/dump_pagetables.c
> @@ -18,6 +18,7 @@
>  #include <linux/seq_file.h>
>  
>  #include <asm/pgtable.h>
> +#include <asm/olpc_ofw.h>
>  
>  /*
>   * The dumper groups pagetable entries of the same type into one, and for
> @@ -55,6 +56,9 @@ enum address_markers_idx {
>  # ifdef CONFIG_HIGHMEM
>  	PKMAP_BASE_NR,
>  # endif
> +# ifdef CONFIG_OLPC_OPENFIRMWARE
> +	OLPC_OFW_START_NR,
> +# endif
>  	FIXADDR_START_NR,
>  #endif
>  };
> @@ -77,6 +81,9 @@ static struct addr_marker address_marker
>  # ifdef CONFIG_HIGHMEM
>  	{ 0/*PKMAP_BASE*/,      "Persisent kmap() Area" },
>  # endif
> +# ifdef CONFIG_OLPC_OPENFIRMWARE
> +	{ OLPC_OFW_START,	"OpenFirmware Mapping" },
> +# endif
>  	{ 0/*FIXADDR_START*/,   "Fixmap Area" },
>  #endif
>  	{ -1, NULL }		/* End of list */
> diff -puN arch/x86/mm/init_32.c~x86-olpc-add-support-for-calling-into-openfirmware arch/x86/mm/init_32.c
> --- a/arch/x86/mm/init_32.c~x86-olpc-add-support-for-calling-into-openfirmware
> +++ a/arch/x86/mm/init_32.c
> @@ -49,6 +49,7 @@
>  #include <asm/paravirt.h>
>  #include <asm/setup.h>
>  #include <asm/cacheflush.h>
> +#include <asm/olpc_ofw.h>
>  #include <asm/page_types.h>
>  #include <asm/init.h>
>  
> @@ -903,6 +904,9 @@ void __init mem_init(void)
>  
>  	printk(KERN_INFO "virtual kernel memory layout:\n"
>  		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +		"    ofw     : 0x%08lx - 0x%08lx   (%4ld MB)\n"
> +#endif
>  #ifdef CONFIG_HIGHMEM
>  		"    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
>  #endif
> @@ -914,6 +918,12 @@ void __init mem_init(void)
>  		FIXADDR_START, FIXADDR_TOP,
>  		(FIXADDR_TOP - FIXADDR_START) >> 10,
>  
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +		olpc_ofw_cif ? OLPC_OFW_START : 0,
> +		olpc_ofw_cif ? OLPC_OFW_END : 0,
> +		olpc_ofw_cif ? (OLPC_OFW_END - OLPC_OFW_START) >> 20 : 0,
> +#endif
> +
>  #ifdef CONFIG_HIGHMEM
>  		PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
>  		(LAST_PKMAP*PAGE_SIZE) >> 10,
> @@ -941,7 +951,14 @@ void __init mem_init(void)
>  	 */
>  #define __FIXADDR_TOP (-PAGE_SIZE)
>  #ifdef CONFIG_HIGHMEM
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +	BUILD_BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> OLPC_OFW_START);
> +#else
>  	BUILD_BUG_ON(PKMAP_BASE + LAST_PKMAP*PAGE_SIZE	> FIXADDR_START);
> +#endif
> +#ifdef CONFIG_OLPC_OPENFIRMWARE
> +	BUILD_BUG_ON(OLPC_OFW_END			>= FIXADDR_START);
> +#endif
>  	BUILD_BUG_ON(VMALLOC_END			> PKMAP_BASE);
>  #endif

The conditionals jungle here makes my head hurt. No way to avoid this 
complication to the basic x86 pagetable layout? Is cr3[1022] hardcoded into 
the BIOS that requires this open heart surgery of our vmalloc area?

	Ingo
