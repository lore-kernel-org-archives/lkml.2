Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1CKQtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:49:32 -0500
Received: from www.tglx.de ([62.245.132.106]:40746 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab1CKQtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:49:31 -0500
Date: Fri, 11 Mar 2011 17:49:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: linux-kernel@vger.kernel.org, x86@kernel.org, sodaville@linutronix.de
Subject: Re: [PATCH] x86/ce4100: set pci ops via callback instead of module
 init
In-Reply-To: <20110311152247.GA14273@www.tglx.de>
Message-ID: <alpine.LFD.2.00.1103111747460.2787@localhost6.localdomain6>
References: <20110311152247.GA14273@www.tglx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Sebastian Andrzej Siewior wrote:
>  
>  struct sim_reg {
> @@ -306,10 +307,8 @@ struct pci_raw_ops ce4100_pci_conf = {
>  	.write = ce4100_conf_write,
>  };
>  
> -static int __init ce4100_pci_init(void)

Why don't you keep the function name and make it non static, add the
call to pci_legacy_init() and just set the init.pci pointer to this?

So all pci is stuff is where it belongs

Thanks,

	tglx

> +void __init ce4100_init_pci_ops(void)
>  {
>  	init_sim_regs();
>  	raw_pci_ops = &ce4100_pci_conf;
> -	return 0;
>  }
> -subsys_initcall(ce4100_pci_init);
> diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
> index 68c0dbc..93b4e3c 100644
> --- a/arch/x86/platform/ce4100/ce4100.c
> +++ b/arch/x86/platform/ce4100/ce4100.c
> @@ -15,6 +15,7 @@
>  #include <linux/serial_reg.h>
>  #include <linux/serial_8250.h>
>  
> +#include <asm/ce4100.h>
>  #include <asm/prom.h>
>  #include <asm/setup.h>
>  #include <asm/i8259.h>
> @@ -125,6 +126,13 @@ static void __cpuinit sdv_pci_init(void)
>  }
>  #endif
>  
> +static int __cpuinit ce4100_pci_init(void)
> +{
> +	ce4100_init_pci_ops();
> +	pci_legacy_init();
> +	return 0;
> +}
> +
>  /*
>   * CE4100 specific x86_init function overrides and early setup
>   * calls.
> @@ -136,6 +144,7 @@ void __init x86_ce4100_early_setup(void)
>  	x86_init.resources.probe_roms = x86_init_noop;
>  	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
>  	x86_init.mpparse.find_smp_config = x86_init_noop;
> +	x86_init.pci.init = ce4100_pci_init;
>  
>  #ifdef CONFIG_X86_IO_APIC
>  	x86_init.pci.init_irq = sdv_pci_init;
> -- 
> 1.7.4
> 
