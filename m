Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1AKXyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 18:54:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44554 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab1AKXy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 18:54:29 -0500
Date: Tue, 11 Jan 2011 16:54:26 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH 11/15] x86/ce4100: use OF for ioapic
Message-ID: <20110111235426.GH2131@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-12-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-12-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:49PM +0100, Sebastian Andrzej Siewior wrote:
> and hpet and a few others things....
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/x86/platform/ce4100/ce4100.c |   24 +++++++++++++++++-------
>  1 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
> index d2c0d51..7877453 100644
> --- a/arch/x86/platform/ce4100/ce4100.c
> +++ b/arch/x86/platform/ce4100/ce4100.c
> @@ -15,21 +15,19 @@
>  #include <linux/serial_reg.h>
>  #include <linux/serial_8250.h>
>  
> +#include <asm/prom.h>
>  #include <asm/setup.h>
> +#include <asm/i8259.h>
>  #include <asm/io.h>
> +#include <asm/io_apic.h>
>  
>  static int ce4100_i8042_detect(void)
>  {
>  	return 0;
>  }
>  
> -static void __init sdv_find_smp_config(void)
> -{
> -}
> -
>  #ifdef CONFIG_SERIAL_8250
>  
> -
>  static unsigned int mem_serial_in(struct uart_port *p, int offset)
>  {
>  	offset = offset << p->regshift;
> @@ -118,6 +116,13 @@ static void __init sdv_arch_setup(void)
>  	sdv_serial_fixup();
>  }
>  
> +static void __cpuinit sdv_pci_init(void)
> +{
> +	x86_of_pci_init();
> +	/* We can't set this earlier, because we need calibrate the timer */
> +	legacy_pic = &null_legacy_pic;
> +}
> +
>  /*
>   * CE4100 specific x86_init function overrides and early setup
>   * calls.
> @@ -127,6 +132,11 @@ void __init x86_ce4100_early_setup(void)
>  	x86_init.oem.arch_setup = sdv_arch_setup;
>  	x86_platform.i8042_detect = ce4100_i8042_detect;
>  	x86_init.resources.probe_roms = x86_init_noop;
> -	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
> -	x86_init.mpparse.find_smp_config = sdv_find_smp_config;
> +	x86_init.mpparse.get_smp_config = x86_dtb_get_config;
> +	x86_init.mpparse.find_smp_config = x86_dtb_find_config;
> +
> +#ifdef CONFIG_X86_IO_APIC
> +	x86_init.pci.init_irq = sdv_pci_init;
> +	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
> +#endif
>  }
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
