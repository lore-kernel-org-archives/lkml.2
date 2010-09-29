Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0I2G1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:27:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61783 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0I2G1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:27:13 -0400
Date: Wed, 29 Sep 2010 15:27:10 +0900
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
        edgar.iglesias@gmail.com, duyl@xilinx.com, linnj@xilinx.com,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 7/7] microblaze: Add support for little-endian
 Microblaze
Message-ID: <20100929062710.GC2439@angua.secretlab.ca>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
 <1285739538-29058-2-git-send-email-monstr@monstr.eu>
 <1285739538-29058-3-git-send-email-monstr@monstr.eu>
 <1285739538-29058-4-git-send-email-monstr@monstr.eu>
 <1285739538-29058-5-git-send-email-monstr@monstr.eu>
 <1285739538-29058-6-git-send-email-monstr@monstr.eu>
 <1285739538-29058-7-git-send-email-monstr@monstr.eu>
 <1285739538-29058-8-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285739538-29058-8-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 03:52:18PM +1000, Michal Simek wrote:
> Microblaze little-endian toolchain exports __MICROBLAZEEL__
> which is used in the kernel to identify little/big endian.
> 
> The most of the changes are in loading values from DTB which
> is always big endian.
> 
> Little endian platforms are based on new AXI bus which has
> impact to early uartlite initialization.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Hi Michal,

Looks pretty good, but a few comments below.

> ---
>  arch/microblaze/include/asm/byteorder.h |    4 ++++
>  arch/microblaze/include/asm/checksum.h  |    9 +++++++--
>  arch/microblaze/include/asm/cpuinfo.h   |    3 ++-
>  arch/microblaze/include/asm/elf.h       |    2 +-
>  arch/microblaze/include/asm/unaligned.h |   12 +++++++++---
>  arch/microblaze/kernel/heartbeat.c      |    3 ++-
>  arch/microblaze/kernel/intc.c           |    9 ++++++---
>  arch/microblaze/kernel/prom.c           |    7 ++++---
>  arch/microblaze/kernel/timer.c          |    8 +++++---
>  arch/microblaze/kernel/vmlinux.lds.S    |    4 ++++
>  10 files changed, 44 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/byteorder.h b/arch/microblaze/include/asm/byteorder.h
> index ce9c587..3190276 100644
> --- a/arch/microblaze/include/asm/byteorder.h
> +++ b/arch/microblaze/include/asm/byteorder.h
> @@ -1,6 +1,10 @@
>  #ifndef _ASM_MICROBLAZE_BYTEORDER_H
>  #define _ASM_MICROBLAZE_BYTEORDER_H
>  
> +#ifdef __MICROBLAZEEL__
> +#include <linux/byteorder/little_endian.h>
> +#else
>  #include <linux/byteorder/big_endian.h>
> +#endif
>  
>  #endif /* _ASM_MICROBLAZE_BYTEORDER_H */
> diff --git a/arch/microblaze/include/asm/checksum.h b/arch/microblaze/include/asm/checksum.h
> index 128bf03..0185cbe 100644
> --- a/arch/microblaze/include/asm/checksum.h
> +++ b/arch/microblaze/include/asm/checksum.h
> @@ -24,8 +24,13 @@ csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
>  		"addc %0, %0, %3\n\t"
>  		"addc %0, %0, r0\n\t"
>  		: "+&d" (sum)
> -		: "d" (saddr), "d" (daddr), "d" (len + proto));
> -
> +		: "d" (saddr), "d" (daddr),
> +#ifdef __MICROBLAZEEL__
> +	"d" ((len + proto) << 8)
> +#else
> +	"d" (len + proto)
> +#endif
> +);
>  	return sum;
>  }
>  
> diff --git a/arch/microblaze/include/asm/cpuinfo.h b/arch/microblaze/include/asm/cpuinfo.h
> index 0d4f0ce..7fab800 100644
> --- a/arch/microblaze/include/asm/cpuinfo.h
> +++ b/arch/microblaze/include/asm/cpuinfo.h
> @@ -98,7 +98,8 @@ void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu);
>  static inline unsigned int fcpu(struct device_node *cpu, char *n)
>  {
>  	int *val;
> -	return (val = (int *) of_get_property(cpu, n, NULL)) ? *val : 0;
> +	return (val = (int *) of_get_property(cpu, n, NULL)) ?
> +							be32_to_cpup(val) : 0;
>  }
>  
>  #endif /* _ASM_MICROBLAZE_CPUINFO_H */
> diff --git a/arch/microblaze/include/asm/elf.h b/arch/microblaze/include/asm/elf.h
> index 732caf1..098dfdd 100644
> --- a/arch/microblaze/include/asm/elf.h
> +++ b/arch/microblaze/include/asm/elf.h
> @@ -71,7 +71,7 @@ typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
>  
>  #define ELF_ET_DYN_BASE         (0x08000000)
>  
> -#ifdef __LITTLE_ENDIAN__
> +#ifdef __MICROBLAZEEL__
>  #define ELF_DATA	ELFDATA2LSB
>  #else
>  #define ELF_DATA	ELFDATA2MSB
> diff --git a/arch/microblaze/include/asm/unaligned.h b/arch/microblaze/include/asm/unaligned.h
> index 3658d91..2b97cbe 100644
> --- a/arch/microblaze/include/asm/unaligned.h
> +++ b/arch/microblaze/include/asm/unaligned.h
> @@ -12,12 +12,18 @@
>  
>  # ifdef __KERNEL__
>  
> -# include <linux/unaligned/be_struct.h>
> +# include <linux/unaligned/be_byteshift.h>
>  # include <linux/unaligned/le_byteshift.h>
>  # include <linux/unaligned/generic.h>
>  
> -# define get_unaligned	__get_unaligned_be
> -# define put_unaligned	__put_unaligned_be
> +
> +#  ifdef __MICROBLAZEEL__
> +#   define get_unaligned	__get_unaligned_le
> +#   define put_unaligned	__put_unaligned_le
> +#  else
> +#   define get_unaligned	__get_unaligned_be
> +#   define put_unaligned	__put_unaligned_be
> +#  endif
>  
>  # endif	/* __KERNEL__ */
>  #endif /* _ASM_MICROBLAZE_UNALIGNED_H */
> diff --git a/arch/microblaze/kernel/heartbeat.c b/arch/microblaze/kernel/heartbeat.c
> index 5c24eb8..efb9a9d 100644
> --- a/arch/microblaze/kernel/heartbeat.c
> +++ b/arch/microblaze/kernel/heartbeat.c
> @@ -59,7 +59,8 @@ void setup_heartbeat(void)
>  	}
>  
>  	if (gpio) {
> -		base_addr = *(int *) of_get_property(gpio, "reg", NULL);
> +		base_addr = be32_to_cpup((int *)of_get_property(gpio,
> +								"reg", NULL));
>  		base_addr = (unsigned long) ioremap(base_addr, PAGE_SIZE);
>  		printk(KERN_NOTICE "Heartbeat GPIO at 0x%x\n", base_addr);
>  
> diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
> index e85bbea..d175a5b 100644
> --- a/arch/microblaze/kernel/intc.c
> +++ b/arch/microblaze/kernel/intc.c
> @@ -138,12 +138,15 @@ void __init init_IRQ(void)
>  	}
>  	BUG_ON(!intc);
>  
> -	intc_baseaddr = *(int *) of_get_property(intc, "reg", NULL);
> +	intc_baseaddr = be32_to_cpup((int *) of_get_property(intc,
> +								"reg", NULL));
>  	intc_baseaddr = (unsigned long) ioremap(intc_baseaddr, PAGE_SIZE);
> -	nr_irq = *(int *) of_get_property(intc, "xlnx,num-intr-inputs", NULL);
> +	nr_irq = be32_to_cpup((int *) of_get_property(intc,
> +						"xlnx,num-intr-inputs", NULL));
>  
>  	intr_type =
> -		*(int *) of_get_property(intc, "xlnx,kind-of-intr", NULL);
> +		be32_to_cpup((int *) of_get_property(intc,
> +						"xlnx,kind-of-intr", NULL));

Unnecessary casts (see comment below)

>  	if (intr_type >= (1 << (nr_irq + 1)))
>  		printk(KERN_INFO " ERROR: Mismatch in kind-of-intr param\n");
>  
> diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
> index 3617b17..14c81c1 100644
> --- a/arch/microblaze/kernel/prom.c
> +++ b/arch/microblaze/kernel/prom.c
> @@ -77,7 +77,8 @@ static int __init early_init_dt_scan_serial(unsigned long node,
>  /* find compatible node with uartlite */
>  	p = of_get_flat_dt_prop(node, "compatible", &l);
>  	if ((strncmp(p, "xlnx,xps-uartlite", 17) != 0) &&
> -			(strncmp(p, "xlnx,opb-uartlite", 17) != 0))
> +			(strncmp(p, "xlnx,opb-uartlite", 17) != 0) &&
> +			(strncmp(p, "xlnx,axi-uartlite", 17) != 0))
>  		return 0;
>  
>  	addr = of_get_flat_dt_prop(node, "reg", &l);
> @@ -87,7 +88,7 @@ static int __init early_init_dt_scan_serial(unsigned long node,
>  /* this function is looking for early uartlite console - Microblaze specific */
>  int __init early_uartlite_console(void)
>  {
> -	return of_scan_flat_dt(early_init_dt_scan_serial, NULL);
> +	return be32_to_cpu(of_scan_flat_dt(early_init_dt_scan_serial, NULL));

of_scan_flat_dt returns a rc that should already by in cpu endianess.
of_scan_flat_dt needs to be fixed instead.

>  }
>  
>  /* MS this is Microblaze specifig function */
> @@ -121,7 +122,7 @@ static int __init early_init_dt_scan_serial2(unsigned long node,
>  /* this function is looking for early uartlite console - Microblaze specific */
>  int __init early_uart16550_console(void)
>  {
> -	return of_scan_flat_dt(early_init_dt_scan_serial2, NULL);
> +	return be32_to_cpu(of_scan_flat_dt(early_init_dt_scan_serial2, NULL));

Ditto

>  }
>  #endif
>  
> diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
> index 64ca14d..b4d5ce4 100644
> --- a/arch/microblaze/kernel/timer.c
> +++ b/arch/microblaze/kernel/timer.c
> @@ -270,11 +270,13 @@ void __init time_init(void)
>  	}
>  	BUG_ON(!timer);
>  
> -	timer_baseaddr = *(int *) of_get_property(timer, "reg", NULL);
> +	timer_baseaddr = be32_to_cpup((int *) of_get_property(timer,
> +								"reg", NULL));

The (int*) casting shouldn't be needed.  of_get_property returns a
'const void *', and be32_to_cpup accepts a 'const __be32 *'.  Ditto
through the other instances of this casting.

>  	timer_baseaddr = (unsigned long) ioremap(timer_baseaddr, PAGE_SIZE);
> -	irq = *(int *) of_get_property(timer, "interrupts", NULL);
> +	irq = be32_to_cpup((int *) of_get_property(timer, "interrupts", NULL));
>  	timer_num =
> -		*(int *) of_get_property(timer, "xlnx,one-timer-only", NULL);
> +		be32_to_cpup((int *) of_get_property(timer,
> +						"xlnx,one-timer-only", NULL));
>  	if (timer_num) {
>  		eprintk(KERN_EMERG "Please enable two timers in HW\n");
>  		BUG();
> diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
> index 20b0552..96a88c3 100644
> --- a/arch/microblaze/kernel/vmlinux.lds.S
> +++ b/arch/microblaze/kernel/vmlinux.lds.S
> @@ -15,7 +15,11 @@ ENTRY(microblaze_start)
>  #include <asm-generic/vmlinux.lds.h>
>  #include <asm/thread_info.h>
>  
> +#ifdef __MICROBLAZEEL__
> +jiffies = jiffies_64;
> +#else
>  jiffies = jiffies_64 + 4;
> +#endif

I comment would go nicely hear to explain to reviewers what this is
about.

Cheers,
g.

