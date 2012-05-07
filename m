Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2EGNYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:24:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40036 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab2EGNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:24:38 -0400
Date: Mon, 7 May 2012 15:24:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2 1/2] vsmp: Fix number of CPUs when vsmp is disabled
Message-ID: <20120507132433.GA9808@gmail.com>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
 <1334561976-13965-1-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334561976-13965-1-git-send-email-ido@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> From: Shai Fultheim <shai@scalemp.com>
> 
> In case CONFIG_X86_VSMP is not set, limit the number of CPUs to the
> number of CPUs of the first board.
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased, fixed minor coding-style issues]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  arch/x86/kernel/vsmp_64.c |   48 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
> index a1d804b..61571fd 100644
> --- a/arch/x86/kernel/vsmp_64.c
> +++ b/arch/x86/kernel/vsmp_64.c
> @@ -15,6 +15,7 @@
>  #include <linux/init.h>
>  #include <linux/pci_ids.h>
>  #include <linux/pci_regs.h>
> +#include <linux/smp.h>
>  
>  #include <asm/apic.h>
>  #include <asm/pci-direct.h>
> @@ -22,6 +23,8 @@
>  #include <asm/paravirt.h>
>  #include <asm/setup.h>
>  
> +#define TOPOLOGY_REGISTER_OFFSET 0x10
> +
>  #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
>  /*
>   * Interrupt control on vSMPowered systems:
> @@ -149,12 +152,57 @@ int is_vsmp_box(void)
>  	return 0;
>  }
>  #endif
> +
> +#ifdef CONFIG_X86_VSMP
> +
> +static void __init vsmp_cap_cpus(void)
> +{
> +	/* VSMP is enabled, no need to cap cpus */
> +}
> +
> +#else


Please move this int the vsmp_cap_cpus() function and you can 
simplify the #ifdef block to:

 #ifdef CONFIG_X86_VSMP
	/* VSMP is enabled, no need to cap cpus */
	return;
 #endif

> +
> +static void __init vsmp_cap_cpus(void)
> +{
> +	/*
> +	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to the
> +	 * ones present in the first board, unless explicitly overridden by
> +	 * setup_max_cpus
> +	 */
> +	if (setup_max_cpus == NR_CPUS) {


you can simplify the function and save a level of indentation by 
turning this into:

	if (setup_max_cpus != NR_CPUS)
		return;


> +		void __iomem *address;
> +		unsigned int cfg, topology, node_shift, maxcpus;
> +
> +		/* Read the vSMP Foundation topology register */
> +		cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
> +		address = early_ioremap(cfg + TOPOLOGY_REGISTER_OFFSET, 4);
> +		if (WARN_ON(!address))
> +			return;
> +
> +		topology = readl(address);
> +		node_shift = (topology >> 16) & 0x7;
> +		if (!node_shift)
> +			/* The value 0 should be decoded as 8 */
> +			node_shift = 8;
> +		maxcpus = (topology & ((1 << node_shift) - 1)) + 1;
> +
> +		printk(KERN_INFO "vSMP CTL: Capping CPUs to %d "
> +				 "(CONFIG_X86_VSMP is unset)\n", maxcpus);

Please don't break up format strings - just leave them long and 
use pr_info().

> +		setup_max_cpus = maxcpus;
> +		early_iounmap(address, 4);
> +	}
> +}
> +
> +#endif

Looks good and useful otherwise.

Thanks,

	Ingo
