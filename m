Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1EQNuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:50:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1EQNuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:50:39 -0400
Date: Tue, 17 May 2011 09:50:27 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        mingo@elte.hu
Subject: Re: [RFC] ACPI, APEI, Generic Hardware Error Source (GHES) injecting
 support
Message-ID: <20110517135027.GJ31888@redhat.com>
References: <1304996921-24881-1-git-send-email-ying.huang@intel.com>
 <20110516193301.GF29881@redhat.com>
 <4DD218B1.7080601@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD218B1.7080601@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 02:41:53PM +0800, Huang Ying wrote:
> On 05/17/2011 03:33 AM, Don Zickus wrote:
> > On Tue, May 10, 2011 at 11:08:41AM +0800, Huang Ying wrote:
> >> The testing of Generic Hardware Error Source (GHES) is quite
> >> difficult, because special hardware is needed to trigger the hardware
> >> error. So a software based hardware error injector for GHES is
> >> implemented.
> >>
> >> Error notification is not provided in this patch.  So you still need
> >> some NMI/SCI/IRQ injecting support to make it work.
> > 
> > Should we add that to this patch, otherwise it seems like the injection
> > isn't very useful or intuitive from the end-user perspective that they
> > have to provide their own notification source (ie NMI/SCI/MCE/IRQ).
> 
> We can provide the NMI/SCI/IRQ injecting in another patch.  What do you
> think about the NMI injecting patch attached?

I understand what the patch is doing and I like the various injection
points, but looking at your other injection modules I start to wonder if
there is a smarter and easier way to do all this.  I believe the software
injection is definitely useful but it does add bloat to the kernel.

I am starting to like Ingo's event filtering idea for stuff like this I
think (though I am still wrapping my head around it).  The beauty of
kprobes and tracepoints and even jump labels was that they were not very
intrusive, they did their work on the side.  It would be nice if we could
figure out a framework for the injection stuff that did something similar.

Perhaps Ingo has some ideas?

Cheers,
Don

> 
> BTW: MCE will not be processed by GHES.
> 
> Best Regards,
> Huang Ying

> Subject: [RFC] x86, NMI, NMI injecting support
> 
> This patch implements trigger NMI on specified CPUs. At the same time,
> the NMI reason (contents of port 0x61) can be faked too. This can be
> used to debug and test the NMI handler.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/Kconfig.debug            |   10 +++
>  arch/x86/include/asm/mach_traps.h |    9 ++
>  arch/x86/kernel/Makefile          |    1 
>  arch/x86/kernel/nmi_inject.c      |  117 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/traps.c           |   34 ++++++++++-
>  5 files changed, 167 insertions(+), 4 deletions(-)
> 
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -304,4 +304,14 @@ config DEBUG_STRICT_USER_COPY_CHECKS
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
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -113,6 +113,7 @@ obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
>  obj-$(CONFIG_OF)			+= devicetree.o
>  
>  obj-y					+= hwerr.o
> +obj-$(CONFIG_NMI_INJECT)		+= nmi_inject.o
>  
>  ###
>  # 64 bit specific files
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
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -316,6 +316,34 @@ static int __init setup_unknown_nmi_pani
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
> @@ -340,7 +368,7 @@ pci_serr_error(unsigned char reason, str
>  
>  	/* Clear and disable the PCI SERR error line. */
>  	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
> -	outb(reason, NMI_REASON_PORT);
> +	outb_nmi_reason(reason);
>  }
>  
>  static notrace __kprobes void
> @@ -358,7 +386,7 @@ io_check_error(unsigned char reason, str
>  
>  	/* Re-enable the IOCK line, wait for a few seconds */
>  	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
> -	outb(reason, NMI_REASON_PORT);
> +	outb_nmi_reason(reason);
>  
>  	i = 20000;
>  	while (--i) {
> @@ -367,7 +395,7 @@ io_check_error(unsigned char reason, str
>  	}
>  
>  	reason &= ~NMI_REASON_CLEAR_IOCHK;
> -	outb(reason, NMI_REASON_PORT);
> +	outb_nmi_reason(reason);
>  }
>  
>  void set_unknown_nmi_as_hwerr(void)

