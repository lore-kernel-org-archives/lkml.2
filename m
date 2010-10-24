Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0JXKQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 06:16:40 -0400
Received: from www.tglx.de ([62.245.132.106]:46448 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0JXKQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 06:16:39 -0400
Date: Sun, 24 Oct 2010 12:15:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Disabling x2apic if nox2apic is specified
In-Reply-To: <1287882149-29275-16-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241204470.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-16-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010, Yinghai Lu wrote:

> For
> 1. x2apic preenabled system
> 2. first kernel have x2apic enabled, and try to boot second kernel with "nox2apic"
> 
> Will put back cpu with apic id < 255 into xapic mode, instead of panic.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/apic.h    |    6 ++++
>  arch/x86/include/asm/apicdef.h |    1 +
>  arch/x86/kernel/acpi/boot.c    |   10 ++++++-
>  arch/x86/kernel/apic/apic.c    |   54 +++++++++++++++++++++++++++++++--------
>  arch/x86/mm/srat_64.c          |   12 ++++++++-
>  5 files changed, 69 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 69879dd..522f39b 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -176,6 +176,7 @@ static inline u64 native_x2apic_icr_read(void)
>  }
>  
>  extern int x2apic_phys;
> +extern int nox2apic;

Can you please use a sensible variable name like  x2apic_disabled ?

>  extern void check_x2apic(void);
>  extern void enable_x2apic(void);
>  extern void x2apic_icr_write(u32 low, u32 id);
> @@ -186,6 +187,10 @@ static inline int x2apic_enabled(void)
>  	if (!cpu_has_x2apic)
>  		return 0;
>  
> +	/* avoid to read msr */

That comment is useless. I wish you would add comments to complex code
not to obvious one.

Also it can be folded into the above check

     if (!cpu_has_x2apic || x2apic_disabled)
     	

> +	if (nox2apic)
> +		return 0;
> +
>  	rdmsr(MSR_IA32_APICBASE, msr, msr2);
>  	if (msr & X2APIC_ENABLE)
>  		return 1;

> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index d286db1..ebb13e8 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -138,15 +138,14 @@ int x2apic_mode;
>  #ifdef CONFIG_X86_X2APIC
>  /* x2apic enabled before OS handover */
>  static int x2apic_preenabled;
> +int nox2apic;
>  static __init int setup_nox2apic(char *str)
>  {
> -	if (x2apic_enabled()) {
> -		pr_warning("Bios already enabled x2apic, "
> -			   "can't enforce nox2apic");
> -		return 0;
> -	}
> +	if (x2apic_enabled())
> +		pr_warning("Bios already enabled x2apic, will disable it");
> +
> +	nox2apic = 1;
>  
> -	setup_clear_cpu_cap(X86_FEATURE_X2APIC);

Why is this removed ?

>  	return 0;
>  }
>  early_param("nox2apic", setup_nox2apic);
> @@ -1393,8 +1392,33 @@ void __cpuinit end_local_APIC_setup(void)
>  }
>  
>  #ifdef CONFIG_X86_X2APIC
> +
> +static void disable_x2apic(void)
> +{
> +	int msr, msr2;
> +
> +	if (!cpu_has_x2apic)
> +		return;
> +
> +	rdmsr(MSR_IA32_APICBASE, msr, msr2);
> +	if (msr & X2APIC_ENABLE) {
> +		pr_info("Disabling x2apic\n");
> +		/*
> +		 * Need to disable xapic and x2apic at the same time at first
> +		 *  then enable xapic
> +		 */
> +		wrmsr(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE),
> +			 0);
> +		wrmsr(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE, 0);
> +	}
> +}
>  void check_x2apic(void)
>  {
> +	if (nox2apic) {
> +		disable_x2apic();
> +		return;
> +	}
> +
>  	if (x2apic_enabled()) {
>  		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
>  		x2apic_preenabled = x2apic_mode = 1;
> @@ -1405,6 +1429,11 @@ void enable_x2apic(void)
>  {
>  	int msr, msr2;
>  
> +	if (nox2apic) {
> +		disable_x2apic();
> +		return;
> +	}
> +
>  	if (!x2apic_mode)
>  		return;
>  
> @@ -1430,7 +1459,7 @@ int __init enable_IR(void)
>  		return 0;
>  	}
>  
> -	if (enable_intr_remapping(x2apic_supported()))
> +	if (enable_intr_remapping(x2apic_supported() && !nox2apic))

Do we really need all these extra checks ? Can't we simply make all
this one variable wich is set to 1 when x2apic is available and not
disabled on the kernel command line ?

> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index a35cb9d..baa9eab 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -126,6 +126,13 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>  	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
>  		return;
>  	pxm = pa->proximity_domain;
> +	apic_id = pa->apic_id;
> +#ifdef CONFIG_X86_X2APIC

Why conditional? No need to duplicate the printk. It just needs some
thought.

> +	if (nox2apic && (apic_id >= 0xff)) {
> +		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
> +			 pxm, apic_id);
> +		return;
> +	}
>  	node = setup_node(pxm);
>  	if (node < 0) {
>  		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> @@ -133,12 +140,15 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>  		return;
>  	}
>  
> -	apic_id = pa->apic_id;
>  	apicid_to_node[apic_id] = node;
>  	node_set(node, cpu_nodes_parsed);
>  	acpi_numa = 1;
>  	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
>  	       pxm, apic_id, node);
> +#else
> +	printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
> +		 pxm, apic_id);
> +#endif
>  }
>  
>  /* Callback for Proximity Domain -> LAPIC mapping */
> -- 
> 1.7.1
> 
