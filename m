Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0KBTMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:12:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab0KBTMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:12:03 -0400
Date: Tue, 2 Nov 2010 15:11:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
Message-ID: <20101102191117.GX4823@redhat.com>
References: <1286865447.7768.184.camel@yhuang-dev>
 <1286865629.2336.1490.camel@twins>
 <1286865923.7768.188.camel@yhuang-dev>
 <1286866193.2336.1503.camel@twins>
 <20101012135112.GE20436@basil.fritz.box>
 <1286892927.29097.42.camel@twins>
 <20101027164522.GA25738@redhat.com>
 <1288199324.3673.14.camel@laptop>
 <20101102174957.GA21468@redhat.com>
 <1288721764.3067.6.camel@yhuang-mobile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288721764.3067.6.camel@yhuang-mobile>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 02:16:03AM +0800, Huang Ying wrote:
> Hi, Don,
> > @@ -38,7 +38,7 @@ static int profile_timer_exceptions_notify(struct notifier_block *self,
> >  static struct notifier_block profile_timer_exceptions_nb = {
> >  	.notifier_call = profile_timer_exceptions_notify,
> >  	.next = NULL,
> > -	.priority = 0
> > +	.priority = NMI_EXT_LOW_PRIOR,
> 
> Do not find definition of NMI_EXT_LOW_PRIOR, forget to add it?

Gah.  I meant to use NMI_LOW_PRIOR there.  Thanks for finding that.  Guess
I should any randomness to my compiles.

> 
> BTW: Attach a patch I used to test external NMI. Hope that is useful to
> you.

It looks useful.  I'll try to play with later this week.

Thanks!

Cheers,
Don

> 
> Best Regards,
> Huang Ying
> 

> From 99a4accf4ccc36ac79c8663bd08e81884aedddaf Mon Sep 17 00:00:00 2001
> From: Huang Ying <ying.huang@intel.com>
> Date: Thu, 9 Sep 2010 14:28:44 +0800
> Subject: [PATCH 08/38] x86, NMI, NMI injecting support
> 
> This patch implements trigger NMI on specified CPUs. At the same time,
> the NMI reason (contents of port 0x61) can be faked too. This can be
> used to debug and test the NMI handler.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/Kconfig.debug            |   10 +++
>  arch/x86/include/asm/mach_traps.h |    9 +++-
>  arch/x86/kernel/Makefile          |    1 +
>  arch/x86/kernel/nmi_inject.c      |  117 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/traps.c           |   34 ++++++++++-
>  5 files changed, 167 insertions(+), 4 deletions(-)
>  create mode 100644 arch/x86/kernel/nmi_inject.c
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 7508508..d6bb833 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -299,4 +299,14 @@ config DEBUG_STRICT_USER_COPY_CHECKS
>  
>  	  If unsure, or if you run an older (pre 4.4) gcc, say N.
>  
> +config NMI_INJECT
> +	tristate "NMI injecting support"
> +	depends on DEBUG_KERNEL
> +	---help---
> +	  This can be used to trigger NMI on specified CPUs. And the
> +	  reason of NMI (contents of port 0x61) can be faked
> +	  too. This can be used to debug and test the NMI handler.
> +
> +	  If unsure, say N.
> +
>  endmenu
> diff --git a/arch/x86/include/asm/mach_traps.h b/arch/x86/include/asm/mach_traps.h
> index 72a8b52..4235bb3 100644
> --- a/arch/x86/include/asm/mach_traps.h
> +++ b/arch/x86/include/asm/mach_traps.h
> @@ -17,7 +17,7 @@
>  #define NMI_REASON_CLEAR_IOCHK	0x08
>  #define NMI_REASON_CLEAR_MASK	0x0f
>  
> -static inline unsigned char get_nmi_reason(void)
> +static inline unsigned char __get_nmi_reason(void)
>  {
>  	return inb(NMI_REASON_PORT);
>  }
> @@ -40,4 +40,11 @@ static inline void reassert_nmi(void)
>  		unlock_cmos();
>  }
>  
> +struct nmi_reason_inject_data {
> +	unsigned char reason;
> +	unsigned char valid : 1;
> +};
> +
> +extern struct nmi_reason_inject_data nmi_reason_inject_data;
> +
>  #endif /* _ASM_X86_MACH_DEFAULT_MACH_TRAPS_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 2dde3c7..5f98f33 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -119,6 +119,7 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
>  obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
>  
>  obj-y					+= hwerr.o
> +obj-$(CONFIG_NMI_INJECT)		+= nmi_inject.o
>  
>  ###
>  # 64 bit specific files
> diff --git a/arch/x86/kernel/nmi_inject.c b/arch/x86/kernel/nmi_inject.c
> new file mode 100644
> index 0000000..2b61148
> --- /dev/null
> +++ b/arch/x86/kernel/nmi_inject.c
> @@ -0,0 +1,117 @@
> +/*
> + * NMI injector, for NMI handler testing
> + *
> + * Copyright 2010 Intel Corp.
> + *   Author: Huang Ying <ying.huang@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/debugfs.h>
> +#include <linux/cpu.h>
> +#include <asm/mach_traps.h>
> +#include <asm/apic.h>
> +
> +static int nmi_reason_inject_get(void *data, u64 *val)
> +{
> +	if (nmi_reason_inject_data.valid)
> +		*val = nmi_reason_inject_data.reason;
> +	else
> +		*val = ~0ULL;
> +	return 0;
> +}
> +
> +static int nmi_reason_inject_set(void *data, u64 val)
> +{
> +	nmi_reason_inject_data.reason = val;
> +	nmi_reason_inject_data.valid = 1;
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(nmi_reason_inject_fops, nmi_reason_inject_get,
> +			nmi_reason_inject_set, "0x%llx\n");
> +
> +static int nmi_reason_uninject_set(void *data, u64 val)
> +{
> +	nmi_reason_inject_data.valid = 0;
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(nmi_reason_uninject_fops, NULL,
> +			nmi_reason_uninject_set, "%llu\n");
> +
> +static int nmi_inject_set(void *data, u64 val)
> +{
> +	int cpu;
> +	cpumask_var_t cpu_mask;
> +
> +	alloc_cpumask_var(&cpu_mask, GFP_KERNEL);
> +	cpumask_clear(cpu_mask);
> +	for_each_online_cpu(cpu) {
> +		if (cpu >= sizeof(val))
> +			continue;
> +		if (val & (1ULL << cpu))
> +			cpumask_set_cpu(cpu, cpu_mask);
> +	}
> +	if (!cpumask_empty(cpu_mask))
> +		apic->send_IPI_mask(cpu_mask, NMI_VECTOR);
> +	free_cpumask_var(cpu_mask);
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(nmi_inject_fops, NULL, nmi_inject_set, "0x%llx\n");
> +
> +static struct dentry *nmi_debug_dir;
> +
> +static int __init nmi_inject_init(void)
> +{
> +	int rc;
> +	struct dentry *de;
> +
> +	rc = -ENOMEM;
> +	nmi_debug_dir = debugfs_create_dir("nmi", NULL);
> +	if (!nmi_debug_dir)
> +		return rc;
> +	de = debugfs_create_file("inject", S_IWUSR, nmi_debug_dir,
> +				 NULL, &nmi_inject_fops);
> +	if (!de)
> +		goto err;
> +	de = debugfs_create_file("reason_inject", S_IRUSR | S_IWUSR,
> +				 nmi_debug_dir, NULL, &nmi_reason_inject_fops);
> +	if (!de)
> +		goto err;
> +	de = debugfs_create_file("reason_uninject", S_IWUSR,
> +				 nmi_debug_dir, NULL, &nmi_reason_uninject_fops);
> +	if (!de)
> +		goto err;
> +
> +	return 0;
> +err:
> +	debugfs_remove_recursive(nmi_debug_dir);
> +	return rc;
> +}
> +
> +static void __exit nmi_inject_exit(void)
> +{
> +	debugfs_remove_recursive(nmi_debug_dir);
> +}
> +
> +module_init(nmi_inject_init);
> +module_exit(nmi_inject_exit);
> +
> +MODULE_AUTHOR("Huang Ying");
> +MODULE_DESCRIPTION("NMI injecting support");
> +MODULE_LICENSE("GPL");
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 42f16f7..acfb1a9 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -316,6 +316,34 @@ static int __init setup_unknown_nmi_panic(char *str)
>  }
>  __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
>  
> +struct nmi_reason_inject_data nmi_reason_inject_data;
> +EXPORT_SYMBOL_GPL(nmi_reason_inject_data);
> +
> +static inline unsigned char get_nmi_reason(void)
> +{
> +	if (nmi_reason_inject_data.valid)
> +		return nmi_reason_inject_data.reason;
> +	else
> +		return __get_nmi_reason();
> +}
> +
> +static inline void outb_nmi_reason(unsigned char reason)
> +{
> +	static unsigned char prev_reason;
> +
> +	if (nmi_reason_inject_data.valid) {
> +		if (reason & NMI_REASON_CLEAR_SERR)
> +			nmi_reason_inject_data.reason &= ~NMI_REASON_SERR;
> +		if (prev_reason == (reason | NMI_REASON_CLEAR_IOCHK) &&
> +		    !(reason & NMI_REASON_CLEAR_IOCHK))
> +			nmi_reason_inject_data.reason &= ~NMI_REASON_IOCHK;
> +		if (!nmi_reason_inject_data.reason)
> +			nmi_reason_inject_data.valid = 0;
> +		prev_reason = reason;
> +	} else
> +		outb(reason, NMI_REASON_PORT);
> +}
> +
>  static notrace __kprobes void
>  pci_serr_error(unsigned char reason, struct pt_regs *regs)
>  {
> @@ -340,7 +368,7 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
>  
>  	/* Clear and disable the PCI SERR error line. */
>  	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
> -	outb(reason, NMI_REASON_PORT);
> +	outb_nmi_reason(reason);
>  }
>  
>  static notrace __kprobes void
> @@ -358,7 +386,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
>  
>  	/* Re-enable the IOCK line, wait for a few seconds */
>  	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
> -	outb(reason, NMI_REASON_PORT);
> +	outb_nmi_reason(reason);
>  
>  	i = 20000;
>  	while (--i) {
> @@ -367,7 +395,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
>  	}
>  
>  	reason &= ~NMI_REASON_CLEAR_IOCHK;
> -	outb(reason, NMI_REASON_PORT);
> +	outb_nmi_reason(reason);
>  }
>  
>  static notrace __kprobes void
> -- 
> 1.7.1
> 

