Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab1EMMpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:45:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600Ab1EMMpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:45:45 -0400
Date: Fri, 13 May 2011 08:45:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110513124523.GM13984@redhat.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 04:23:38PM +0800, Huang Ying wrote:
> In general, unknown NMI is used by hardware and firmware to notify
> fatal hardware errors to OS. So the Linux should treat unknown NMI as
> hardware error and go panic upon unknown NMI for better error
> containment.

I have a couple of concerns about this patch.  One I don't think BIOSes
are ready for this.  I have Intel Westmere boxes that say they have a
valid HEST, GHES, and EINJ table, but when I inject an error there is no
GHES record.  This leaves me with an unknown NMI and panic.  Yeah, it is a
BIOS bug I guess, but I think vendors are going to be slow fixing all this
stuff (my Nehalem box is in even worse shape with this stuff).

Also, is there any known issues with x86_64 platforms with bad NMIs?  RHEL
has had unknown NMI's panic on x86_64 since x86_64 first came out, I don't
recall any exceptions we had to add to handle 'quirky' hardware.

Then for the i686 case, because the 'quirky' hardware is so old, can't we
just leave it a kernel config option to switch between using a 'printk'
vs. a 'panic'?  Or even a kernel command line option.

I figure these 'quirky' hardware machines are more the exception nowdays,
do we really need to add code to whitelist machines?

Granted I am not familiar enough with the quirky hardware (in fact I don't
think I have seen any mainly because I haven't been around long enough).
Most cases I see when trolling through the fedora bugzilla list for
unknown NMIs, is just bad firmware or acpi power configurations.

Just wondering if we could just simplify the patch somehow with better
assumptions.

Cheers,
Don

> 
> But there are some legacy machine which would randomly send unknown
> NMIs for no good reason.  To support these machines, a white list
> mechanism is provided to treat unknown NMI as hardware error only on
> some known working system.
> 
> These systems are identified via the presentation of APEI HEST or
> some PCI ID of the host bridge. The PCI ID of host bridge instead of
> DMI ID is used, so that the checking can be done based on the platform
> type instead of motherboard. This should be simpler and sufficient.
> 
> The method to identify the platforms is designed by Andi Kleen.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/include/asm/nmi.h |    1 
>  arch/x86/kernel/Makefile   |    2 +
>  arch/x86/kernel/hwerr.c    |   61 +++++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kernel/traps.c    |   31 +++++++++++++++++-----
>  drivers/acpi/apei/hest.c   |    8 +++++
>  5 files changed, 96 insertions(+), 7 deletions(-)
>  create mode 100644 arch/x86/kernel/hwerr.c
> 
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -17,6 +17,7 @@ struct ctl_table;
>  extern int proc_nmi_enabled(struct ctl_table *, int ,
>  			void __user *, size_t *, loff_t *);
>  extern int unknown_nmi_panic;
> +extern void set_unknown_nmi_as_hwerr(void);
>  
>  void arch_trigger_all_cpu_backtrace(void);
>  #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -112,6 +112,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION)
>  obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
>  obj-$(CONFIG_OF)			+= devicetree.o
>  
> +obj-y					+= hwerr.o
> +
>  ###
>  # 64 bit specific files
>  ifeq ($(CONFIG_X86_64),y)
> --- /dev/null
> +++ b/arch/x86/kernel/hwerr.c
> @@ -0,0 +1,61 @@
> +/*
> + * Hardware error architecture dependent processing
> + *
> + * Copyright 2010,2011 Intel Corp.
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
> +#include <linux/pci.h>
> +#include <linux/init.h>
> +#include <linux/nmi.h>
> +
> +/*
> + * In general, unknown NMI is used by hardware and firmware to notify
> + * fatal hardware errors to OS. So the Linux should treat unknown NMI
> + * as hardware error and go panic upon unknown NMI for better error
> + * containment.
> + *
> + * But there are some legacy machine which would randomly send unknown
> + * NMIs for no good reason.  To support these systems, a white list
> + * mechanism is used to treat unknown NMI as hardware error only on
> + * some known working system.
> + *
> + * The PCI ID of host bridge instead of DMI ID is used, so that the
> + * checking can be done based on the platform instead of motherboard.
> + * This should be simpler and sufficient.
> + */
> +static const
> +struct pci_device_id unknown_nmi_as_hwerr_platform[] __initdata = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3406) },
> +	{ 0, }
> +};
> +
> +int __init check_unknown_nmi_as_hwerr(void)
> +{
> +	struct pci_dev *dev = NULL;
> +
> +	for_each_pci_dev(dev) {
> +		if (pci_match_id(unknown_nmi_as_hwerr_platform, dev)) {
> +			pr_info("System has working NMI, will treat unknown NMI as hardware error!\n");
> +			set_unknown_nmi_as_hwerr();
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +late_initcall(check_unknown_nmi_as_hwerr);
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -83,6 +83,8 @@ EXPORT_SYMBOL_GPL(used_vectors);
>  
>  static int ignore_nmis;
>  
> +static int unknown_nmi_as_hwerr;
> +
>  int unknown_nmi_panic;
>  /*
>   * Prevent NMI reason port (0x61) being accessed simultaneously, can
> @@ -368,12 +370,18 @@ io_check_error(unsigned char reason, str
>  	outb(reason, NMI_REASON_PORT);
>  }
>  
> +void set_unknown_nmi_as_hwerr(void)
> +{
> +	unknown_nmi_as_hwerr = 1;
> +}
> +
>  static notrace __kprobes void
>  unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
>  {
>  	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
>  			NOTIFY_STOP)
>  		return;
> +
>  #ifdef CONFIG_MCA
>  	/*
>  	 * Might actually be able to figure out what the guilty party
> @@ -384,14 +392,23 @@ unknown_nmi_error(unsigned char reason,
>  		return;
>  	}
>  #endif
> -	pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
> -		 reason, smp_processor_id());
> -
> -	pr_emerg("Do you have a strange power saving mode enabled?\n");
> -	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
> -		panic("NMI: Not continuing");
> +	/*
> +	 * On modern systems, unknown NMI means fatal hardware error, but
> +	 * this may be not true on some legacy system.
> +	 */
> +	if (unknown_nmi_as_hwerr) {
> +		panic("NMI for hardware error without error record: Not continuing\n"
> +		      "Please check BIOS/BMC log for further information.");
> +	} else {
> +		pr_emerg("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
> +			 reason, smp_processor_id());
> +
> +		pr_emerg("Do you have a strange power saving mode enabled?\n");
> +		if (unknown_nmi_panic || panic_on_unrecovered_nmi)
> +			panic("NMI: Not continuing");
>  
> -	pr_emerg("Dazed and confused, but trying to continue\n");
> +		pr_emerg("Dazed and confused, but trying to continue\n");
> +	}
>  }
>  
>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> --- a/drivers/acpi/apei/hest.c
> +++ b/drivers/acpi/apei/hest.c
> @@ -35,6 +35,7 @@
>  #include <linux/highmem.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
> +#include <linux/nmi.h>
>  #include <acpi/apei.h>
>  
>  #include "apei-internal.h"
> @@ -225,6 +226,13 @@ void __init acpi_hest_init(void)
>  	if (rc)
>  		goto err;
>  
> +	/*
> +	 * System has proper HEST should treat unknown NMI as fatal
> +	 * hardware error notification
> +	 */
> +	pr_info(HEST_PFX "HEST is valid, will treat unknown NMI as hardware error!\n");
> +	set_unknown_nmi_as_hwerr();
> +
>  	rc = hest_ghes_dev_register(ghes_count);
>  	if (!rc) {
>  		pr_info(HEST_PFX "Table parsing has been initialized.\n");
