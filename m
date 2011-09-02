Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1IBIOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:14:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:43184 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab1IBIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:14:01 -0400
Date: Fri, 2 Sep 2011 10:13:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, andi@firstfloor.org,
        akpm@linux-foundation.org, x86@kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Integrate the time source driver with
 Hyper-V detection code
In-Reply-To: <1312300982-11609-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.LFD.2.02.1109021013390.2723@ionos>
References: <1312300982-11609-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011, K. Y. Srinivasan wrote:

> The Hyper-V timesource driver is best integrated with Hyper-V detection code
> since: (a) Linux guests running on Hyper-V need this timesource and (b)
> by integrating with Hyper-V detection, we could significantly  minimize the
> code in the timesource driver.
> 
> Andrew, could you take this patch for the -mm tree. I have sent this patch
> out multiple times and I have not recived any response or comments.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/x86/kernel/cpu/mshyperv.c     |   24 ++++++++
>  drivers/staging/hv/Makefile        |    2 +-
>  drivers/staging/hv/hv_timesource.c |  102 ------------------------------------
>  3 files changed, 25 insertions(+), 103 deletions(-)
>  delete mode 100644 drivers/staging/hv/hv_timesource.c
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index d944bf6..c97f88d 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -11,6 +11,8 @@
>   */
>  
>  #include <linux/types.h>
> +#include <linux/time.h>
> +#include <linux/clocksource.h>
>  #include <linux/module.h>
>  #include <asm/processor.h>
>  #include <asm/hypervisor.h>
> @@ -36,6 +38,25 @@ static bool __init ms_hyperv_platform(void)
>  		!memcmp("Microsoft Hv", hyp_signature, 12);
>  }
>  
> +static cycle_t read_hv_clock(struct clocksource *arg)
> +{
> +	cycle_t current_tick;
> +	/*
> +	 * Read the partition counter to get the current tick count. This count
> +	 * is set to 0 when the partition is created and is incremented in
> +	 * 100 nanosecond units.
> +	 */
> +	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
> +	return current_tick;
> +}
> +
> +static struct clocksource hyperv_cs = {
> +	.name           = "hyperv_clocksource",
> +	.rating         = 400, /* use this when running on Hyperv*/
> +	.read           = read_hv_clock,
> +	.mask           = CLOCKSOURCE_MASK(64),
> +};
> +
>  static void __init ms_hyperv_init_platform(void)
>  {
>  	/*
> @@ -46,6 +67,9 @@ static void __init ms_hyperv_init_platform(void)
>  
>  	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
>  	       ms_hyperv.features, ms_hyperv.hints);
> +
> +
> +	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
>  }
>  
>  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
> index bd176b1..3e0d7e6 100644
> --- a/drivers/staging/hv/Makefile
> +++ b/drivers/staging/hv/Makefile
> @@ -1,4 +1,4 @@
> -obj-$(CONFIG_HYPERV)		+= hv_vmbus.o hv_timesource.o
> +obj-$(CONFIG_HYPERV)		+= hv_vmbus.o
>  obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
>  obj-$(CONFIG_HYPERV_NET)	+= hv_netvsc.o
>  obj-$(CONFIG_HYPERV_UTILS)	+= hv_utils.o
> diff --git a/drivers/staging/hv/hv_timesource.c b/drivers/staging/hv/hv_timesource.c
> deleted file mode 100644
> index 0efb049..0000000
> --- a/drivers/staging/hv/hv_timesource.c
> +++ /dev/null
> @@ -1,102 +0,0 @@
> -/*
> - * A clocksource for Linux running on HyperV.
> - *
> - *
> - * Copyright (C) 2010, Novell, Inc.
> - * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> - * NON INFRINGEMENT.  See the GNU General Public License for more
> - * details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
> - *
> - */
> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> -
> -#include <linux/version.h>
> -#include <linux/clocksource.h>
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/pci.h>
> -#include <linux/dmi.h>
> -#include <asm/hyperv.h>
> -#include <asm/mshyperv.h>
> -#include <asm/hypervisor.h>
> -
> -#define HV_CLOCK_SHIFT	22
> -
> -static cycle_t read_hv_clock(struct clocksource *arg)
> -{
> -	cycle_t current_tick;
> -	/*
> -	 * Read the partition counter to get the current tick count. This count
> -	 * is set to 0 when the partition is created and is incremented in
> -	 * 100 nanosecond units.
> -	 */
> -	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
> -	return current_tick;
> -}
> -
> -static struct clocksource hyperv_cs = {
> -	.name           = "hyperv_clocksource",
> -	.rating         = 400, /* use this when running on Hyperv*/
> -	.read           = read_hv_clock,
> -	.mask           = CLOCKSOURCE_MASK(64),
> -	/*
> -	 * The time ref counter in HyperV is in 100ns units.
> -	 * The definition of mult is:
> -	 * mult/2^shift = ns/cyc = 100
> -	 * mult = (100 << shift)
> -	 */
> -	.mult           = (100 << HV_CLOCK_SHIFT),
> -	.shift          = HV_CLOCK_SHIFT,
> -};
> -
> -static const struct dmi_system_id __initconst
> -hv_timesource_dmi_table[] __maybe_unused  = {
> -	{
> -		.ident = "Hyper-V",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
> -			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
> -		},
> -	},
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(dmi, hv_timesource_dmi_table);
> -
> -static const struct pci_device_id __initconst
> -hv_timesource_pci_table[] __maybe_unused = {
> -	{ PCI_DEVICE(0x1414, 0x5353) }, /* VGA compatible controller */
> -	{ 0 }
> -};
> -MODULE_DEVICE_TABLE(pci, hv_timesource_pci_table);
> -
> -
> -static int __init init_hv_clocksource(void)
> -{
> -	if ((x86_hyper != &x86_hyper_ms_hyperv) ||
> -		!(ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE))
> -		return -ENODEV;
> -
> -	if (!dmi_check_system(hv_timesource_dmi_table))
> -		return -ENODEV;
> -
> -	pr_info("Registering HyperV clock source\n");
> -	return clocksource_register(&hyperv_cs);
> -}
> -
> -module_init(init_hv_clocksource);
> -MODULE_DESCRIPTION("HyperV based clocksource");
> -MODULE_AUTHOR("K. Y. Srinivasan <ksrinivasan@novell.com>");
> -MODULE_LICENSE("GPL");
> -- 
> 1.7.4.1
> 
> 
