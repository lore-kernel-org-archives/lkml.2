Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1BURL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:11:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44874 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1BURL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:11:58 -0500
Message-ID: <4D629C82.3080906@mvista.com>
Date: Mon, 21 Feb 2011 20:10:26 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Pratheesh Gangadhar <pratheesh@ti.com>
CC: davinci-linux-open-source@linux.davincidsp.com, gregkh@suse.de,
        amit.chatterjee@ti.com, hjk@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used
 by PRUSS UIO driver
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>	<1298041530-26855-2-git-send-email-pratheesh@ti.com> <1298041530-26855-3-git-send-email-pratheesh@ti.com>
In-Reply-To: <1298041530-26855-3-git-send-email-pratheesh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Pratheesh Gangadhar wrote:

> Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>

    Signoff should follow the change log, not precede it. "From:" line may 
precede the change log.

> This patch defines PRUSS, ECAP clocks, memory and IRQ resources
> used by PRUSS UIO driver in DA850/AM18xx/OMAPL1-38 devices. UIO
> driver exports 64K I/O region of PRUSS, 128KB L3 RAM and 256KB
> DDR buffer to user space. PRUSS has 8 host event interrupt lines
> mapped to IRQ_DA8XX_EVTOUT0..7 of ARM9 INTC.These in conjunction
> with shared memory can be used to implement IPC between ARM9 and
> PRUSS.

> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 11f986b..ddcbac8 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1077,6 +1077,10 @@ static __init void da850_evm_init(void)
>  		pr_warning("da850_evm_init: i2c0 registration failed: %d\n",
>  				ret);
>  
> +	ret = da8xx_register_pruss();
> +       if (ret)
> +                pr_warning("da850_evm_init: pruss registration failed: %d\n",
> +                                 ret);
>  
>  	ret = da8xx_register_watchdog();
>  	if (ret)

    I'd put this into a pacth of its own, to have the SoC level changes 
separated from board-level changes...

> diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> index 3443d97..0096d4f 100644
> --- a/arch/arm/mach-davinci/da850.c
> +++ b/arch/arm/mach-davinci/da850.c
> @@ -238,6 +238,13 @@ static struct clk tptc2_clk = {
>  	.flags		= ALWAYS_ENABLED,
>  };
>  
> +static struct clk pruss_clk = {
> +	.name		= "pruss",
> +	.parent		= &pll0_sysclk2,
> +	.lpsc		= DA8XX_LPSC0_DMAX,

    We have patch submitted by TI that renames this #define to DA8XX_LPSC0_PRUSS...

> +	.flags		= ALWAYS_ENABLED,
> +};
> +

    We already have patch submitted by TI that defines this clock. It would be 
nice if you coordinated your efforts to avoid such conflicts.
    Again, I'd put the part adding the clocks into a patch of its own.

> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index beda8a4..4ea3d1f 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -725,3 +725,76 @@ int __init da8xx_register_cpuidle(void)
>  
>  	return platform_device_register(&da8xx_cpuidle_device);
>  }
> +static struct resource pruss_resources[] = {
> +	[0] = {
> +		.start  = DA8XX_PRUSS_BASE,
> +		.end    = DA8XX_PRUSS_BASE + SZ_64K - 1,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +	[1] = {
> +		.start  = DA8XX_L3RAM_BASE,
> +		.end    = DA8XX_L3RAM_BASE + SZ_128K - 1,
> +		.flags  = IORESOURCE_MEM,

    Are you going to use all SRAM?

> +	},
> +	[2] = {
> +		.start  = 0,
> +		.end    = SZ_256K - 1,
> +		.flags  = IORESOURCE_MEM,
> +	},
> +
> +	[3] = {
> +		.start  = IRQ_DA8XX_EVTOUT0,
> +		.end    = IRQ_DA8XX_EVTOUT0,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	[4] = {
> +		.start  = IRQ_DA8XX_EVTOUT1,
> +		.end    = IRQ_DA8XX_EVTOUT1,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	[5] = {
> +		.start  = IRQ_DA8XX_EVTOUT2,
> +		.end    = IRQ_DA8XX_EVTOUT2,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	[6] = {
> +		.start  = IRQ_DA8XX_EVTOUT3,
> +		.end    = IRQ_DA8XX_EVTOUT3,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	[7] = {
> +		.start  = IRQ_DA8XX_EVTOUT4,
> +		.end    = IRQ_DA8XX_EVTOUT4,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	[8] = {
> +		.start  = IRQ_DA8XX_EVTOUT5,
> +		.end    = IRQ_DA8XX_EVTOUT5,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	[9] = {
> +		.start  = IRQ_DA8XX_EVTOUT6,
> +		.end    = IRQ_DA8XX_EVTOUT6,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +	[10] = {
> +		.start  = IRQ_DA8XX_EVTOUT7,
> +		.end    = IRQ_DA8XX_EVTOUT7,
> +		.flags  = IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct platform_device pruss_device = {
> +	.name			= "pruss",
> +	.id			= 0,
> +	.num_resources		= ARRAY_SIZE(pruss_resources),
> +	.resource		= pruss_resources,
> +	.dev	 =	{
> +		.coherent_dma_mask = 0xffffffff,
> +	}
> +};
> +
> +int __init da8xx_register_pruss()
> +{
> +	return platform_device_register(&pruss_device);
> +}

    Again, there's TI patch that adds this device already...

WBR, Sergei
