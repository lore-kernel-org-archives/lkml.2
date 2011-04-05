Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1DEIEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:04:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47864 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1DEIEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:04:37 -0400
Message-ID: <4D9ACD10.5090401@monstr.eu>
Date: Tue, 05 Apr 2011 10:04:32 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: John Linn <john.linn@xilinx.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com, arnd@arndb.de,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] ARM: Xilinx: add timer and on chip memory support
 for SMP
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com> <548833b1-f72d-4ede-8c67-07bb930f9c9c@VA3EHSMHS009.ehs.local>
In-Reply-To: <548833b1-f72d-4ede-8c67-07bb930f9c9c@VA3EHSMHS009.ehs.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

John Linn wrote:
> These changes are required to support SMP.
> 
> This includes an update so that the non-local timer is set
> to run on the 1st CPU, the addition of local timer support
> and support for on chip memory.
> 
> Signed-off-by: John Linn <john.linn@xilinx.com>
> ---
>  arch/arm/mach-xilinx/common.c                  |   16 ++++++++++-
>  arch/arm/mach-xilinx/include/mach/irqs.h       |    1 +
>  arch/arm/mach-xilinx/include/mach/xilinx_soc.h |   20 +++++++++++++
>  arch/arm/mach-xilinx/localtimer.c              |   36 ++++++++++++++++++++++++
>  arch/arm/mach-xilinx/timer.c                   |    4 +-
>  5 files changed, 74 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/mach-xilinx/localtimer.c
> 
> diff --git a/arch/arm/mach-xilinx/common.c b/arch/arm/mach-xilinx/common.c
> index 83b549d..2695b39 100644
> --- a/arch/arm/mach-xilinx/common.c
> +++ b/arch/arm/mach-xilinx/common.c
> @@ -101,7 +101,21 @@ static struct map_desc io_desc[] __initdata = {
>  		.type		= MT_DEVICE,
>  	},
>  #endif
> -
> +	/* create a mapping for the OCM  (256K) leaving a hole for the
> +	 * interrupt vectors which are handled in the kernel
> +	 */
> +	{
> +		.virtual	= OCM_LOW_VIRT,
> +		.pfn		= __phys_to_pfn(OCM_LOW_PHYS),
> +		.length		= (192 * SZ_1K),
> +		.type		= MT_DEVICE_CACHED,
> +	},
> +	{
> +		.virtual	= OCM_HIGH_VIRT,
> +		.pfn		= __phys_to_pfn(OCM_HIGH_PHYS),
> +		.length		= (60 * SZ_1K),
> +		.type		= MT_DEVICE,
> +	},
>  };
>  
>  /**
> diff --git a/arch/arm/mach-xilinx/include/mach/irqs.h b/arch/arm/mach-xilinx/include/mach/irqs.h
> index 47a8162..8c41b22 100644
> --- a/arch/arm/mach-xilinx/include/mach/irqs.h
> +++ b/arch/arm/mach-xilinx/include/mach/irqs.h
> @@ -22,6 +22,7 @@
>   * GIC Interrupts
>   */
>  
> +#define IRQ_SCU_CPU_TIMER	29
>  #define IRQ_GIC_SPI_START	32
>  #define IRQ_TIMERCOUNTER0	42
>  #define IRQ_UART0		59
> diff --git a/arch/arm/mach-xilinx/include/mach/xilinx_soc.h b/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
> index d181c5c..a55a46c 100644
> --- a/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
> +++ b/arch/arm/mach-xilinx/include/mach/xilinx_soc.h
> @@ -31,13 +31,33 @@
>  #define SCU_PERIPH_PHYS			0xF8F00000
>  #define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
>  
> +#define OCM_LOW_PHYS			0xFFFC0000
> +#define OCM_LOW_VIRT			OCM_LOW_PHYS
> +
> +#define OCM_HIGH_PHYS			0xFFFF1000
> +#define OCM_HIGH_VIRT			OCM_HIGH_PHYS
> +
>  /* The following are intended for the devices that are mapped early */
>  
>  #define TTC0_BASE			IOMEM(TTC0_VIRT)
>  #define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
>  #define SCU_GIC_CPU_BASE		(SCU_PERIPH_BASE + 0x100)
> +#define SCU_CPU_TIMER_BASE		(SCU_PERIPH_BASE + 0x600)
>  #define SCU_GIC_DIST_BASE		(SCU_PERIPH_BASE + 0x1000)
>  #define PL310_L2CC_BASE			IOMEM(PL310_L2CC_VIRT)
> +#define OCM_LOW_BASE			IOMEM(OCM_LOW_VIRT)
> +#define OCM_HIGH_BASE			IOMEM(OCM_HIGH_VIRT)
> +
> +/* There are a couple ram addresses needed for communication between the boot
> + * loader software and the linux kernel with multiple cpus in the kernel (SMP).
> + * The memory addresses are in the high on-chip RAM and these addresses are
> + * mapped flat (virtual = physical). The memory must be mapped early and
> + * non-cached.
> + */
> +
> +#define BOOT_ADDR_OFFSET	0xEFF0
> +#define BOOT_LOCK_OFFSET	0xEFF4
> +#define BOOT_LOCK_KEY		0xFACECAFE
>  
>  /*
>   * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
> diff --git a/arch/arm/mach-xilinx/localtimer.c b/arch/arm/mach-xilinx/localtimer.c
> new file mode 100644
> index 0000000..4bd0a0d
> --- /dev/null
> +++ b/arch/arm/mach-xilinx/localtimer.c
> @@ -0,0 +1,36 @@
> +/*
> + * arch/arm/mach-xilinx/localtimer.c
> + *
> + * Both cortex-a9 cores have their own timer in it's CPU domain.
> + *
> + * Copyright (C) 2011 Xilinx, Inc.
> + *
> + * This file is based on arch/arm/plat-versatile/localtimer.c
> + *
> + * Copyright (C) 2002 ARM Ltd.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/init.h>
> +#include <asm/smp_twd.h>
> +#include <mach/xilinx_soc.h>
> +
> +/*
> + * Setup the local clock events for a CPU.
> + */
> +int __cpuinit local_timer_setup(struct clock_event_device *evt)
> +{
> +	twd_base = SCU_CPU_TIMER_BASE;
> +
> +	evt->irq = IRQ_SCU_CPU_TIMER;
> +	twd_timer_setup(evt);
> +	return 0;
> +}

I have question here about SCU_CPU_TIMER_BASE.
I have looked at your arm-next branch and you are using there TTC0_BASE
at 0xF8001000 address which is external timer.
Here you are using SCU internal timer at 0xF8F00600.

You are using TTC with three counters (from your comment).
T1: Timer 1, clocksource for generic timekeeping
T2: Timer 2, clockevent source for hrtimers
T3: Timer 3, <unused>

 From twd_timer_setup I see that it looks like that only new clockevent is 
registered.

Please correct me if I am wrong.
Would it be possible to use timer 3 for the second cpu? I expect that your code 
just register new clockevent device. System will contain 2 CPU that's why this 
shouldn't be a problem.

TGLX: Is it correct assumption that SMP system has one clocksource and one 
clockevent device for every CPU in the system? (Sorry I don't have any 
experience with SMP)

I don't know if there is an option to use only internal CPU timers for Linux and 
keep ttc for other purpose.

BTW: I think that will be better to spit this patch to two. The first for local 
timer and the second for OCM.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
