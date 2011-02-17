Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1BQSM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:12:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879Ab1BQSMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:12:53 -0500
Message-ID: <4D5D6517.5060600@redhat.com>
Date: Thu, 17 Feb 2011 16:12:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, arozansk@redhat.com,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] x86/PCI: don't export a __devinit function
References: <4D5D562A0200007800032744@vpn.id2.novell.com>
In-Reply-To: <4D5D562A0200007800032744@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 17-02-2011 14:08, Jan Beulich escreveu:
> Exporting a __devinit function (pcibios_scan_specific_bus()) isn't
> correct. (Michal, any reason why modpost only warns about exported
> __init functions?) Short of being able to think of a better solution,
> and short of making the whole call tree (reaching into the arch-
> independent part of the PCI subsystem) non-__devinit, export the
> symbol only when HOTPLUG is enabled (which is always the case for non-
> expert configurations), use section mismatch avoidance annotations for
> that case (knowing that __devinit functions will not be discarded),
> and mark the symbol __devinit only in the !HOTPLUG case.
> 
> Consequently, EDAC_I7CORE (consuming the export) then has to depend on
> HOTPLUG. 

Having the entire i7core_edac driver depending on HOTPLUG, just because
a few BIOSes want to hide the non-core PCI devices doesn't seem nice.
One alternative would be to enclose the code that needs this function
with #ifdef CONFIG_HOTPLUG.

> A fundamental question of course if whether this driver has
> to use that function in the first place (i.e. whether it wouldn't be
> better to just remove the export) - the problem it tries to address
> happens on other systems too, but the PCI bus the devices in question
> live on isn't necessarily bus 255. For the affected system I have, the
> alternative approach is to set pcibios_last_bus from __pci_mmcfg_init()
> based on the highest bus number on segment 0 being covered by MCFG.

I received a few days ago a report that some BIOSes that hide those
PCI devices also use a different address for the last bus (0x3f, instead
of 0xff). So, it seems that the better would be to use an alternative
way to retrieve the last bus.

> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Aristeu Sergio <arozansk@redhat.com>
> Cc: Michal Marek <mmarek@suse.cz>
> 
> ---
>  arch/x86/pci/legacy.c |   21 ++++++++++++++++++---
>  drivers/edac/Kconfig  |    2 +-
>  2 files changed, 19 insertions(+), 4 deletions(-)
> 
> --- 2.6.38-rc5/arch/x86/pci/legacy.c
> +++ 2.6.38-rc5-x86-pci-section-conflict/arch/x86/pci/legacy.c
> @@ -36,7 +36,23 @@ int __init pci_legacy_init(void)
>  	return 0;
>  }
>  
> -void __devinit pcibios_scan_specific_bus(int busn)
> +#ifdef CONFIG_HOTPLUG
> +static void __ref
> +#else
> +static inline void
> +#endif
> +_pci_scan_bus_on_node(int busno, int node)
> +{
> +	pci_scan_bus_on_node(busno, &pci_root_ops, node);
> +}
> +
> +#ifdef CONFIG_HOTPLUG
> +EXPORT_SYMBOL_GPL(pcibios_scan_specific_bus);
> +void
> +#else
> +void __devinit
> +#endif
> +pcibios_scan_specific_bus(int busn)
>  {
>  	int devfn;
>  	long node;
> @@ -51,12 +67,11 @@ void __devinit pcibios_scan_specific_bus
>  		    l != 0x0000 && l != 0xffff) {
>  			DBG("Found device at %02x:%02x [%04x]\n", busn, devfn, l);
>  			printk(KERN_INFO "PCI: Discovered peer bus %02x\n", busn);
> -			pci_scan_bus_on_node(busn, &pci_root_ops, node);
> +			_pci_scan_bus_on_node(busn, node);
>  			return;
>  		}
>  	}
>  }
> -EXPORT_SYMBOL_GPL(pcibios_scan_specific_bus);
>  
>  int __init pci_subsys_init(void)
>  {
> --- 2.6.38-rc5/drivers/edac/Kconfig
> +++ 2.6.38-rc5-x86-pci-section-conflict/drivers/edac/Kconfig
> @@ -173,7 +173,7 @@ config EDAC_I5400
>  
>  config EDAC_I7CORE
>  	tristate "Intel i7 Core (Nehalem) processors"
> -	depends on EDAC_MM_EDAC && PCI && X86
> +	depends on EDAC_MM_EDAC && PCI && X86 && HOTPLUG
>  	select EDAC_MCE
>  	help
>  	  Support for error detection and correction the Intel
> 
> 
> 

